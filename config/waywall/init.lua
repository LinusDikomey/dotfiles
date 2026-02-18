local waywall = require("waywall")
local helpers = require("waywall.helpers")

---------------------------------------------------------------------------------------------------
-- configurable options
---------------------------------------------------------------------------------------------------

-- path to the folder containing this file after being symlinked into .config
local folder = os.getenv("HOME") .. "/.config/waywall/"
local resolution = { x = 3840, y = 2160 }
local eye_projector_width = 30
local ecount_scale = 4
local pie_scale = 1

local remaps = {
	["mmb"] = "RightShift",
	["MB5"] = "F3",
	["MB4"] = "home",
	["delete"] = "backspace",
	["V"] = "0",
	["0"] = "v",
	["t"] = "n",
	["n"] = "t",
	["LeftAlt"] = "Equal",
	["L"] = "LeftAlt",
	["A"] = "Y",
	["Y"] = "A",
	["F1"] = "6",
	["6"] = "F1",
	["F2"] = "7",
	["7"] = "F2",
}

-- seems to not work (maybe depending on keyboard layout, one of them should always work hopefully)
local reset_ninbot = "h"

-- colors taken from Catppuccin Macchiato theme
local colors = {
	background = "#24273a", -- base
	blockentities = "#f5a97f", -- peach
	ecount = "#91d7e3", -- sky
	unspecified = "#a6da95", -- green
}

---------------------------------------------------------------------------------------------------

-- values are done in 1080p scale and then scaled to the actual resolution as needed
local pixel_scale = resolution.y / 1080.0

local config = {
	window = {
		fullscreen_width = resolution.x,
		fullscreen_height = resolution.y,
	},
	input = {
		layout = "mc",
		repeat_rate = 30,
		repeat_delay = 200,

		sensitivity = 4.0,
		confine_pointer = true,

		remaps = remaps,
	},
	theme = {
		background = colors.background,
		ninb_anchor = {
			position = "topright",
			x = -5,
			y = 50,
		},
		ninb_opacity = 0.7,
	},
	experimental = {
		tearing = true,
	},
}

-- state
local ninb_permanent = false

-- constants
local thin_size = { w = 315 * pixel_scale, h = 1080 * pixel_scale }

local is_ninb_running = function()
    local handle = io.popen("pgrep -f 'Ninjabrain.*jar'")
    local result = handle:read("*l")
    handle:close()
    return result ~= nil
end

local exec_ninb = function()
	if is_ninb_running() then
		return
	end
	waywall.exec("Ninjabrain-Bot")
end

-- resets and hides ninjabrain bot
-- also starts it if not running already
local clear_ninb = function()
	exec_ninb()
	ninb_permanent = false
	waywall.exec("xdotool key " .. reset_ninbot)
	waywall.show_floating(false)
end

local toggle_ninb = function()
	ninb_permanent = not ninb_permanent
	waywall.show_floating(ninb_permanent)
end

-- local show_ninb_if_f3 = function()
-- 	if waywall.get_key("F3") and not waywall.floating_shown() and not ninb_permanent then
-- 		waywall.show_floating(true)
-- 		waywall.sleep(f3_ninbot_seconds * 1000)
-- 		if not ninb_permanent then
-- 			waywall.show_floating(false)
-- 		end
-- 	end
-- end

local exec_paceman = function()
	waywall.exec("java -jar " .. os.getenv("HOME") .. "/mcsr/paceman-tracker.jar --nogui")
end

local make_image = function(path, dst)
	local this = nil

	return function(enable)
		if enable and not this then
			this = waywall.image(path, dst)
		elseif this and not enable then
			this:close()
			this = nil
		end
	end
end

local make_res = function(width, height, enable, disable)
	width = math.floor(width)
	height = math.floor(height)
	return function()
		local active_width, active_height = waywall.active_res()

		if active_width == width and active_height == height then
			waywall.set_resolution(0, 0)
			disable()
		else
			waywall.set_resolution(width, height)
			enable()
		end
	end
end

local scaled = function(rect)
	return {
		x = math.floor(rect.x * pixel_scale),
		y = math.floor(rect.y * pixel_scale),
		w = math.floor(rect.w * pixel_scale),
		h = math.floor(rect.h * pixel_scale),
	}
end

local tall_size = { w = 340, h = 16384 }
local tall_proj_width = (resolution.x - tall_size.w) / 2
local eye_zoom_rect = { x = 0, y = 370 * pixel_scale, w = tall_proj_width, h = tall_proj_width * (9 / 16) * 0.75 }
local wide_height = 340

---------------------------------------------------------------------------------------------------
-- mirrors
---------------------------------------------------------------------------------------------------

local make_mirror = function(options)
	local this = nil

	return function(enable)
		if enable and not this then
			this = waywall.mirror(options)
		elseif this and not enable then
			this:close()
			this = nil
		end
	end
end

local mirror_group = function(mirrors)
	return function(enable)
		for _, mirror in ipairs(mirrors) do
			mirror(enable)
		end
	end
end


local color_keys = {
	f3 = "#dddddd",
	text = {
		blockentities = "#E96D4D",
		unspecified = "#45CC65",
		tick = "#6543ca",
	},
	pie = {
		entities = "#E446C4",
		blockentities = "#EC6E4E",
		unspecified = "#46CE66",
	}
}
local pie_size = { w = 320, h = 170 }
local pie_aspect = pie_size.w / pie_size.h
local pie_right_pad = 40 -- right padding from the end of the thin resolution
local pie_dst = scaled({
	x = 1920 / 2 + thin_size.w / pixel_scale / 2 + pie_right_pad,
	y = 1080 / 2 - pie_size.h / 2,
	w = pie_size.w * pie_scale,
	h = pie_size.h * pie_scale * pie_aspect,
})

-- offset of the pie from the bottom right of the window
local pie_offset = { w = 330, h = 400 }

local pie_text_height = 8


local pie_mirror = function(window_size)
	local mirrors = {}
	local i = 1
	for _, key in pairs(color_keys.pie) do
		mirrors[i] = make_mirror({
			src = { x = window_size.w - pie_offset.w, y = window_size.h - pie_offset.h, w = pie_size.w, h = pie_size.h },
			dst = pie_dst,
			color_key = {
				input = key,
				output = key,
			}
		})
		i = i + 1
	end
	return mirror_group(mirrors)
end

local percentage_mirror = function(window_size, key, color, offset)
	local scale = 3
	local w = 32
	local mirrors = {}
	for i = 1,5 do
		mirrors[i] = make_mirror({
			src = { x = window_size.w - 92, y = window_size.h - 228 + i * pie_text_height, w = w, h = pie_text_height },
			dst = {
				x = pie_dst.x + offset * scale * pixel_scale,
				y = pie_dst.y - 25 * pie_aspect,
				w = w * scale * pixel_scale,
				h = pie_text_height * scale * pixel_scale,
			},
			color_key = {
				input = key,
				output = color,
			},
		})
	end
	return mirror_group(mirrors)
end

local pie_mirrors = function(window_size)
	return mirror_group({
		pie_mirror(window_size),
		percentage_mirror(window_size, color_keys.text.blockentities, colors.blockentities, 20),
		percentage_mirror(window_size, color_keys.text.unspecified, colors.unspecified, 55),
	})
end

local tick_number = function()
	local mirrors = {}
	for i = 1,6 do
		mirrors[i] = make_mirror({
			src = { x = resolution.x - 330, y = resolution.y - 228 + i * 8, w = 13, h = pie_text_height},
			dst = scaled({ x = 1860, y = 1040, w = 13 * 4, h = pie_text_height * 4 }),
			color_key = {
				input = color_keys.text.tick,
				output = colors.ecount,
			},
		})
	end
	return mirror_group(mirrors)
end

local mirrors = {
	eye_measure = make_mirror({
		src = { x = (tall_size.w / 2) - (eye_projector_width / 2), y = 7902, w = eye_projector_width, h = 580 },
		dst = eye_zoom_rect,
	}),

	f3_ecount = make_mirror({
		src = { x = 0, y = 37, w = 50, h = 9 },
		dst = scaled({ x = 600, y = 400, w = ecount_scale * 50, h = ecount_scale * 9 }),
		color_key = {
			input = color_keys.f3,
			output = colors.ecount,
		},
	}),

	tall = pie_mirrors(tall_size),
	thin = pie_mirrors(thin_size),

	pie_tick_number = tick_number(),
}

local images = {
	overlay = make_image(folder .. "overlay.png", {
		dst = eye_zoom_rect,
	}),
}

local show_mirrors = function(eye, f3, thin, tall)
	if eye then waywall.set_sensitivity(0.08) else waywall.set_sensitivity(0) end
	images.overlay(eye)
	mirrors.eye_measure(eye)

	mirrors.f3_ecount(f3)

	mirrors.thin(thin)
	mirrors.tall(tall)

	mirrors.pie_tick_number(not (eye or f3 or thin or tall))
end

local thin_enable = function()
	show_mirrors(false, true, true, false)
end

local tall_enable = function()
	waywall.show_floating(false)
	show_mirrors(false, true, false, true)
end

local wide_enable = function()
	show_mirrors(false, false, false, false)
end

local generic_disable = function()
	show_mirrors(false, false, false, false)
end

local eyezoom_enable = function()
	waywall.show_floating(true)
	ninb_permanent = true
	show_mirrors(true, false, false, false)
end

local eyezoom_disable = function()
	generic_disable()
end

local resolutions = {
	thin    = make_res(thin_size.w, thin_size.h, thin_enable, generic_disable),
	tall    = make_res(tall_size.w, tall_size.h, tall_enable, generic_disable),
	eyezoom = make_res(tall_size.w, tall_size.h, eyezoom_enable, eyezoom_disable),
	wide    = make_res(1920 * pixel_scale, wide_height * pixel_scale, wide_enable, generic_disable),
}

local oneshot_image = nil
local oneshot_crosshair = function()
	local r = 1.5
	if oneshot_image ~= nil then
		oneshot_image:close()
		oneshot_image = nil
		return
	end
	oneshot_image = waywall.image(
		folder .. "dot.png",
		{
			dst = {
				x = (1920 / 2 - r) * pixel_scale,
				y = (1080 / 2 - r) * pixel_scale,
				w = r * 2 * pixel_scale,
				h = r * 2 * pixel_scale,
			},
			depth = 0
		}
	)
end

local chatting_text = nil
local toggle_keymap = function()
	if chatting_text then
		waywall.set_keymap({ layout = "mc" })
		waywall.set_remaps(remaps)
		chatting_text:close()
		chatting_text = nil
	else
    chatting_text = waywall.text("*", {
        x = 10, y = 1000 * pixel_scale,
        color = "#ee4444", size = 5,
    })
		waywall.set_keymap({ layout = "us" })
		waywall.set_remaps({})
	end
	keymap_toggled = not keymap_toggled
end

local action = function(f)
		return function()
			if not chatting_text then
				f()
			end
			return false
		end
end

local rsg_reset = function()
	if waywall.get_key("RightShift") then
		clear_ninb()
		waywall.press_key("F10")
			waywall.set_resolution(0, 0)
			generic_disable()
	end
end

-- auto restore/hide ninbot on quit, disable mirrors
waywall.listen("state", function()
	local screen = waywall.state().screen
	if screen ~= "inworld" then
		print("screen is now (disabling): ", screen)
		waywall.set_resolution(0, 0)
		generic_disable()
		clear_ninb()
	end
end)



config.actions = {
	["*-Equal"] = action(resolutions.wide),
	["*-P"] = action(resolutions.thin),
	["*-Alt_l"] = action(resolutions.tall),
	["Grave"] = action(resolutions.eyezoom),
	["Shift-7"] = action(exec_ninb),
	["Shift-9"] = action(exec_paceman),
	["Ctrl-Grave"] = action(toggle_ninb),
	["o"] = action(oneshot_crosshair),
	["Ctrl-n"] = toggle_keymap,
	["bracketright"] = action(rsg_reset),
}

return config
