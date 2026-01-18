local waywall = require("waywall")
local helpers = require("waywall.helpers")

-- folder with Ninjabrain-Bot.jar and overlay.png. No trailing slash!
local mcsrFolder = "~/.config/waywall"

-- local resolution = { x = 2560, y = 1440 }
local resolution = { x = 3840, y = 2160 }
local scale = resolution.y / 1440.0 -- config was originally made for 1440p, this scales everything

local remaps = {
	["MB5"] = "F3",
	["V"] = "0",
	["0"] = "v",
	["t"] = "n",
	["n"] = "t",
	["q"] = "backspace",
	["backspace"] = "q",
	-- ["LeftShift"] = "LeftCtrl",
	-- ["LeftCtrl"] = "LeftShift",
	["LeftAlt"] = "L",
	["L"] = "LeftAlt",
}

local config = {
	window = {
		fullscreen_width = resolution.x,
		fullscreen_height = resolution.y,
	},
	input = {
		layout = "mc",
		repeat_rate = 35,
		repeat_delay = 250,

		sensitivity = 4.0,
		confine_pointer = true,

		remaps = remaps,
	},
	theme = {
		background = "#303030ff",
		ninb_anchor = "topright",
		ninb_opacity = 0.65,
	},
	experimental = {
		tearing = true,
	},
}

local exec_ninb = function()
	print("starting Ninjabrain Bot")
	if not helpers.floating_shown then
		helpers.toggle_floating()
	end
	waywall.exec("Ninjabrain-Bot")
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
		x = math.floor(rect.x * scale),
		y = math.floor(rect.y * scale),
		w = math.floor(rect.w * scale),
		h = math.floor(rect.h * scale),
	}
end

local eye_zoom_rect = scaled({ x = 0, y = 500, w = 1120, h = 650 })

local ecount_scale = 1.5

local mirrors = {
	eye_measure = make_mirror({
		src = { x = 130, y = 7902, w = 60, h = 580 },
		dst = eye_zoom_rect,
	}),

	f3_ecount = make_mirror({
		src = { x = 0, y = 36, w = 50, h = 11 },
		dst = { x = 1200, y = 600, w = 250 * ecount_scale, h = 55 * ecount_scale },
		color_key = {
			input = "#dddddd",
			output = "#ffffff",
		},
	}),

	thin_pie = make_mirror({
		src = { x = 0, y = 15965, w = 310, h = 240 },
		dst = scaled({ x = 1450, y = 1000, w = 400, h = 310 }),
	}),

	thin_pie_blockentities_percent = make_mirror({
		src = { x = 220, y = 16160, w = 50, h = 60 },
		dst = scaled({ x = 1500, y = 800, w = 200, h = 240 }),
		color_key = {
			input = "#E96D4D",
			output = "#E96D4D",
		},
	}),
}

local images = {
	overlay = make_image(mcsrFolder .. "/overlay.png", {
		dst = eye_zoom_rect,
	}),
}

local show_mirrors = function(eye, f3, thin, pie)
	print(eye)
	if eye then waywall.set_sensitivity(0.1) else waywall.set_sensitivity(0) end
	images.overlay(eye)
	mirrors.eye_measure(eye)

	mirrors.f3_ecount(f3)

	mirrors.thin_pie(pie)
	mirrors.thin_pie_blockentities_percent(pie)
end

local thin_enable = function()
	show_mirrors(false, true, true, false)
end

local tall_enable = function()
	show_mirrors(false, true, false, true)
end

local wide_enable = function()
	show_mirrors(false, false, false, false)
end

local generic_disable = function()
	show_mirrors(false, false, false, false)
end

local eyezoom_enable = function()
	show_mirrors(true, false, false, false)
end

local eyezoom_disable = function()
	generic_disable()
end

local resolutions = {
	thin = make_res(400 * scale, 1440 * scale - 4, thin_enable, generic_disable),
	tall = make_res(320, 16384, tall_enable, generic_disable),
	eyezoom = make_res(320, 16384, eyezoom_enable, eyezoom_disable),
	wide = make_res(2560 * scale - 4, 360 * scale, wide_enable, generic_disable),
}

local oneshot_image = nil
local oneshot_crosshair = function()
	local r = 2
	if oneshot_image ~= nil then
		print("closing oneshot image: ")
		oneshot_image:close()
		print("nilling")
		oneshot_image = nil
		return
	end
	oneshot_image = waywall.image(
		mcsrFolder .. "/dot.png",
		{
			dst = {
				x = (2560 / 2 - r) * scale,
				y = (1440 / 2 - r) * scale,
				w = r * 2 * scale,
				h = r * 2 * scale,
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
        x = 10, y = 1300,
        color = "#ee4444", size = 5,
    })
		print("Toggling keymap to us")
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


config.actions = {
	["*-Equal"] = action(resolutions.wide),
	["*-P"] = action(resolutions.thin),
	["*-Alt_l"] = action(resolutions.tall),
	["Grave"] = action(resolutions.eyezoom),
	["Shift-7"] = action(exec_ninb),
	["Shift-Grave"] = action(helpers.toggle_floating),
	["o"] = action(oneshot_crosshair),
	["Ctrl-n"] = toggle_keymap,
}

return config
