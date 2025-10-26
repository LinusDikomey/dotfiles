local waywall = require("waywall")
local helpers = require("waywall.helpers")

-- folder with Ninjabrain-Bot.jar and overlay.png. No trailing slash!
local mcsrFolder = "/home/linus/mcsr"

local config = {
	input = {
		layout = "us",
		repeat_rate = 25,
		repeat_delay = 300,

		sensitivity = 1.0,
		confine_pointer = true,

		remaps = {
			["MB5"] = "F3",
			["V"] = "0",
			["0"] = "V",
		},
	},
	theme = {
		background = "#303030ff",
		ninb_anchor = "topleft",
	},
}

local exec_ninb = function()
	helpers.toggle_floating()
	print("starting Ninjabrain Bot")
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

local eye_zoom_rect = { x = 0, y = 500, w = 1120, h = 650 }

local mirrors = {
	eye_measure = make_mirror({
		src = { x = 130, y = 7902, w = 60, h = 580 },
		dst = eye_zoom_rect,
	}),

	f3_ecount = make_mirror({
		src = { x = 0, y = 36, w = 50, h = 11 },
		dst = { x = 530, y = 40, w = 250, h = 55 },
		color_key = {
			input = "#dddddd",
			output = "#ffffff",
		},
	}),

	thin_pie_blockentities = make_mirror({
		src = { x = 0, y = 15950, w = 310, h = 240 },
		dst = { x = 1450, y = 1000, w = 400, h = 310 },
		-- color_key = {
		-- 	input = "#ec6e4e",
		-- 	output = "#f25d38",
		-- },
	}),

	thin_pie_blockentities_percent = make_mirror({
		src = { x = 220, y = 16160, w = 37 * 3, h = 17 * 3 },
		dst = { x = 1500, y = 800, w = 185 * 3, h = 100 * 3 },
		color_key = {
			input = "#E96D4D",
			output = "#FFFFFF",
		},
	}),

	thin_pie_unspecified = make_mirror({
		src = { x = 0, y = 595, w = 330, h = 180 },
		dst = { x = 1150, y = 600, w = 500, h = 200 },
		color_key = {
			input = "#46CE66",
			output = "#3eb85b",
		},
	}),

	thin_pie_entities = make_mirror({
		src = { x = 0, y = 595, w = 330, h = 180 },
		dst = { x = 1150, y = 600, w = 500, h = 200 },
		color_key = {
			input = "#E446C4",
			output = "#2e3440",
		},
	}),

	thin_pie_destroyProgress = make_mirror({
		src = { x = 0, y = 595, w = 330, h = 180 },
		dst = { x = 1150, y = 600, w = 500, h = 200 },
		color_key = {
			input = "#CC6C46",
			output = "#2e3440",
		},
	}),

	thin_pie_prepare = make_mirror({
		src = { x = 0, y = 595, w = 330, h = 180 },
		dst = { x = 1150, y = 600, w = 500, h = 200 },
		color_key = {
			input = "#464C46",
			output = "#2e3440",
		},
	}),
}

local images = {
	overlay = make_image(mcsrFolder .. "/overlay.png", {
		dst = eye_zoom_rect,
	}),
}

local show_mirrors = function(eye, f3, thin)
	if eye then waywall.set_sensitivity(0.05) else waywall.set_sensitivity(0) end
	images.overlay(eye)
	mirrors.eye_measure(eye)

	mirrors.f3_ecount(f3)

	mirrors.thin_pie_blockentities(eye)
	mirrors.thin_pie_blockentities_percent(eye)
	mirrors.thin_pie_entities(eye)
	mirrors.thin_pie_unspecified(eye)
	mirrors.thin_pie_destroyProgress(eye)
end

local thin_enable = function()
	show_mirrors(false, true, true)
end

local tall_enable = function()
	show_mirrors(true, true, false)
end

local wide_enable = function()
	show_mirrors(false, false, false)
end

local generic_disable = function()
	show_mirrors(false, false, false)
end

local resolutions = {
	thin = make_res(400, 1400, thin_enable, generic_disable),
	tall = make_res(320, 16384, tall_enable, generic_disable),
	wide = make_res(2560, 360, wide_enable, generic_disable),
}

local keep_keypress = function(f)
		return function()
			f()
			return false
		end
end

config.actions = {
	["*-grave"] = keep_keypress(resolutions.tall),
	["*-P"] = keep_keypress(resolutions.thin),
	["Shift-g"] = keep_keypress(resolutions.wide),
	["Shift-7"] = keep_keypress(exec_ninb),
	["x"] = keep_keypress(helpers.toggle_floating),
}

return config
