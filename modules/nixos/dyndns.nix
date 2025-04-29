{
  pkgs,
  config,
  ...
}: let
  passwordPath = config.age.secrets.dyndns-password.path;
  api = "https://dynamicdns.park-your-domain.com/update";
  host = "home";
  domain = "linus.exposed";
  script =
    pkgs.writeScript "dyndns.nu"
    #nu
    ''
      mut prev_ip = "0.0.0.0"
      let password = cat ${passwordPath}
      loop {
        let ip = http get "https://checkip.amazonaws.com" | str trim
        if $ip != $prev_ip {
          print $"ip changed to '($ip)'"
          let res = http get -r -f $"${api}?host=${host}&domain=${domain}&password=($password)&ip=($ip)"
          if $res.status == 200 {
            print $"ip updated successfully '($prev_ip)' -> '($ip)': ($res)"
            $prev_ip = $ip
          } else {
            print "IP update failed, will try again"
          }
        }
        sleep 2min
      }
    '';
in {
  age.secrets.dyndns-password.file = ../../secrets/dyndns-password.age;
  systemd.services.dyndns = {
    enable = true;
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "update dyndns for this device's ip";
    serviceConfig = {
      ExecStart = "${pkgs.nushell}/bin/nu ${script}";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
