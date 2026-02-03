local waywall = require("waywall")
local helpers = require("waywall.helpers")

---------------------------------------------------------------------------------------------------
-- path to the folder containing this file after being symlinked into .config
local folder = os.getenv("HOME") .. "/.config/waywall/"
local resolution = { x = 3840, y = 2160 }
local eye_projector_width = 30

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
	-- ["Equal"] = "Home",
}

local reset_ninbot = "H"

-- colors taken from Catppuccin Macchiato theme
local colors = {
	background = "#24273a", -- base
	blockentities = "#f5a97f", -- peach
	ecount = "#91d7e3", -- sky
}

---------------------------------------------------------------------------------------------------

-- values are done in 1080p scale and then scaled to the actual resolution as needed
local scale = resolution.y / 1080.0



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
		ninb_anchor = "topright",
		ninb_opacity = 0.7,
	},
	experimental = {
		tearing = true,
	},
}

-- state
local ninb_permanent = false

local exec_ninb = function()
	print("starting Ninjabrain Bot")
	if not helpers.floating_shown then
		helpers.toggle_floating()
	end
	waywall.exec("Ninjabrain-Bot")
end

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

local tall_width = 340
local tall_proj_width = (resolution.x - tall_width) / 2
local eye_zoom_rect = { x = 0, y = 370 * scale, w = tall_proj_width, h = tall_proj_width * (9 / 16) * 0.75 }

local ecount_scale = 1.5

local mirrors = {
	eye_measure = make_mirror({
		src = { x = (tall_width / 2) - (eye_projector_width / 2), y = 7902, w = eye_projector_width, h = 580 },
		dst = eye_zoom_rect,
	}),

	f3_ecount = make_mirror({
		src = { x = 0, y = 37, w = 50, h = 9 },
		-- dst = scaled({ x = 600, y = 300, w = 125 * scale, h = 25 * ecount_scale }),
		dst = scaled({ x = 600, y = 400, w = 4 * 50, h = 4 * 9 }),
		color_key = {
			input = "#dddddd",
			output = colors.ecount,
		},
	}),

	tall_pie = make_mirror({
		src = { x = 0, y = 15965, w = 310, h = 240 },
		dst = scaled({ x = 1130, y = 750, w = 300, h = 232 }),
	}),

	tall_pie_blockentities_percent = make_mirror({
		src = { x = 220, y = 16160, w = 50, h = 60 },
		dst = scaled({ x = 1125, y = 600, w = 150, h = 180 }),
		color_key = {
			input = "#E96D4D",
			output = colors.blockentities,
		},
	}),
}

local images = {
	overlay = make_image(folder .. "overlay.png", {
		dst = eye_zoom_rect,
	}),
}

local show_mirrors = function(eye, f3, thin, pie)
	print(eye)
	if eye then waywall.set_sensitivity(0.1) else waywall.set_sensitivity(0) end
	images.overlay(eye)
	mirrors.eye_measure(eye)

	mirrors.f3_ecount(f3)

	mirrors.tall_pie(pie)
	mirrors.tall_pie_blockentities_percent(pie)
end

local thin_enable = function()
	show_mirrors(talle, true, true, false)
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
	thin = make_res(315 * scale, 1080 * scale - 4, thin_enable, generic_disable),
	tall = make_res(tall_width, 16384, tall_enable, generic_disable),
	eyezoom = make_res(tall_width, 16384, eyezoom_enable, eyezoom_disable),
	wide = make_res(1920 * scale, 340 * scale, wide_enable, generic_disable),
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
				x = (1920 / 2 - r) * scale,
				y = (1080 / 2 - r) * scale,
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
        x = 10, y = 1000 * scale,
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


-- local show_ninb_if_f3 = function()
-- 	if waywall.get_key("F3") and not waywall.floating_shown() and not ninb_permanent then
-- 		waywall.show_floating(true)
-- 		waywall.sleep(f3_ninbot_seconds * 1000)
-- 		if not ninb_permanent then
-- 			waywall.show_floating(false)
-- 		end
-- 	end
-- end

-- resets and hides ninjabrain bot
local clear_ninb = function()
	local screen = waywall.state().screen
	if screen ~= "inworld" then
		ninb_permanent = false
		print(waywall.exec("xdotool key " .. reset_ninbot))
		waywall.show_floating(false)
	end
end

local toggle_ninb = function()
	ninb_permanent = not ninb_permanent
	waywall.show_floating(ninb_permanent)
end

local rsg_reset = function()
	if waywall.get_key("RightShift") then
		waywall.press_key("F10")
			waywall.set_resolution(0, 0)
			generic_disable()
	end
end

-- auto hide ninbot on quit
waywall.listen("state", clear_ninb)


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
	["L"] = action(clear_ninb),
}

return config
