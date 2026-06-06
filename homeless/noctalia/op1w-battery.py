# note that this was reverse-engineered using ai and might break in various unpredictable ways
# be careful before using this
import fcntl
import json
import os
from pathlib import Path
import subprocess
import time

VID_PID_TOKEN = "0003:3367:1970"
VENDOR_INTERFACE_TOKEN = ":1.1/"

REPORT_ID = 0xA1
BATTERY_COMMAND = 0xB4
READ_SEQUENCES = [
    ([0x0F, 0x0F], [BATTERY_COMMAND]),
    ([0x0F, 0x01], [BATTERY_COMMAND]),
    ([0x0E], [0x0F, 0x0F], [BATTERY_COMMAND]),
    ([0x0E], [BATTERY_COMMAND]),
    ([BATTERY_COMMAND],),
]
REPORT_LENGTH = 64
ACK_OFFSET = 1
BATTERY_OFFSET = 16
ACK_OK = 0x01
ACK_STATUS = 0x08

LOCK_PATH = "/tmp/op1w-battery.lock"
NOTIFY_THRESHOLD = 10

_IOC_NRBITS = 8
_IOC_TYPEBITS = 8
_IOC_SIZEBITS = 14
_IOC_NRSHIFT = 0
_IOC_TYPESHIFT = _IOC_NRSHIFT + _IOC_NRBITS
_IOC_SIZESHIFT = _IOC_TYPESHIFT + _IOC_TYPEBITS
_IOC_DIRSHIFT = _IOC_SIZESHIFT + _IOC_SIZEBITS
_IOC_WRITE = 1
_IOC_READ = 2


class BatteryReadError(Exception):
    pass


class BatteryLock:
    def __enter__(self):
        self.fd = os.open(LOCK_PATH, os.O_CREAT | os.O_RDWR | os.O_CLOEXEC, 0o666)
        try:
            os.fchmod(self.fd, 0o666)
        except PermissionError:
            pass
        fcntl.flock(self.fd, fcntl.LOCK_EX)
        return self

    def __exit__(self, _exc_type, _exc, _traceback):
        fcntl.flock(self.fd, fcntl.LOCK_UN)
        os.close(self.fd)


def _ioc(direction, type_, nr, size):
    return (
        direction << _IOC_DIRSHIFT
        | type_ << _IOC_TYPESHIFT
        | nr << _IOC_NRSHIFT
        | size << _IOC_SIZESHIFT
    )


def hid_set_feature(length):
    return _ioc(_IOC_READ | _IOC_WRITE, ord("H"), 0x06, length)


def hid_get_feature(length):
    return _ioc(_IOC_READ | _IOC_WRITE, ord("H"), 0x07, length)


def find_op1w_hidraw():
    for node in sorted(Path("/sys/class/hidraw").glob("hidraw*")):
        try:
            target = os.readlink(node).upper()
        except OSError:
            continue

        if VID_PID_TOKEN in target and VENDOR_INTERFACE_TOKEN in target:
            return Path("/dev") / node.name

    return None


def feature_transaction(fd, payload, delay=0.35):
    request = bytearray(REPORT_LENGTH)
    request[0] = REPORT_ID
    request[1 : 1 + len(payload)] = bytes(payload)
    fcntl.ioctl(fd, hid_set_feature(len(request)), request, True)

    time.sleep(delay)

    response = bytearray(REPORT_LENGTH)
    response[0] = REPORT_ID
    fcntl.ioctl(fd, hid_get_feature(len(response)), response, True)
    return bytes(response)


def battery_percent_from_response(response):
    if response[ACK_OFFSET] not in (ACK_OK, ACK_STATUS):
        raise BatteryReadError(f"unexpected ack byte: 0x{response[ACK_OFFSET]:02x}")

    percent = response[BATTERY_OFFSET]
    if percent > 100:
        raise BatteryReadError(f"unexpected battery byte: 0x{percent:02x}")

    return percent


def read_battery(path):
    errors = []

    with BatteryLock():
        fd = os.open(path, os.O_RDWR | os.O_CLOEXEC)
        try:
            for sequence in READ_SEQUENCES:
                response = None
                for command in sequence:
                    response = feature_transaction(fd, command)

                try:
                    return battery_percent_from_response(response)
                except BatteryReadError as exc:
                    errors.append(str(exc))
        finally:
            os.close(fd)

    detail = "; ".join(errors[-3:]) if errors else "no response"
    raise BatteryReadError(f"could not read battery: {detail}")


def state_path():
    state_home = os.environ.get("XDG_STATE_HOME")
    if state_home:
        base = Path(state_home)
    else:
        base = Path.home() / ".local/state"
    return base / "op1w-battery.json"


def read_state():
    try:
        return json.loads(state_path().read_text())
    except (OSError, json.JSONDecodeError):
        return {}


def write_state(state):
    path = state_path()
    try:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(state, separators=(",", ":")))
    except OSError:
        pass


def send_low_battery_notification(percent):
    try:
        subprocess.run(
            [
                "notify-send",
                "--app-name=OP1w Battery",
                "--urgency=critical",
                "OP1w 4K battery low",
                f"{percent}% remaining",
            ],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except OSError:
        pass


def maybe_notify_low_battery(percent):
    state = read_state()
    previous_percent = state.get("previous_percent")

    if (
        isinstance(previous_percent, int)
        and previous_percent >= NOTIFY_THRESHOLD
        and percent < NOTIFY_THRESHOLD
    ):
        send_low_battery_notification(percent)

    write_state({"previous_percent": percent})


def battery_icon(percent):
    if percent < NOTIFY_THRESHOLD:
        return "battery-exclamation"
    if percent <= 25:
        return "battery-1"
    if percent <= 50:
        return "battery-2"
    if percent <= 75:
        return "battery-3"
    return "battery-4"


def color_for_percent(percent):
    return "error" if percent < NOTIFY_THRESHOLD else "none"


def print_json(payload):
    print(json.dumps(payload, separators=(",", ":")))


def print_battery_json(percent):
    tooltip = f"OP1w 4K\nBattery: {percent}%"

    print_json(
        {
            "text": f"{percent}%",
            "icon": battery_icon(percent),
            "tooltip": tooltip,
            "color": color_for_percent(percent),
        }
    )


def print_error_json(error):
    print_json(
        {
            "text": "--%",
            "icon": "battery-off",
            "tooltip": f"OP1w 4K\n{error}",
            "color": "error",
        }
    )


def main():
    path = find_op1w_hidraw()
    if path is None:
        print_error_json("OP1w 4K vendor hidraw interface not found")
        return 0

    try:
        percent = read_battery(path)
    except PermissionError:
        print_error_json(f"{path}: permission denied")
        return 0
    except OSError as exc:
        print_error_json(f"{path}: {exc}")
        return 0
    except BatteryReadError as exc:
        print_error_json(str(exc))
        return 0

    maybe_notify_low_battery(percent)
    print_battery_json(percent)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
