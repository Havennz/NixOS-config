---@diagnostic disable: undefined-global

---- Helpers
local function uwsmWrap(program)
	return "uwsm app -- " .. program
end

-- Functions based on: https://github.com/fufexan/dotfiles/blob/f85bd6c76803d53ec14d2481f2300b0e9313c9b7/system/programs/hyprland/binds.lua#L5-L12
local function toggle(program)
	local prog = program:sub(1, 14)
	return "pkill " .. prog .. " || " .. uwsmWrap(program)
end

local function runOnce(program)
	return "pgrep " .. program .. " || " .. uwsmWrap(program)
end

local exec = hl.dsp.exec_cmd
local function execApp(program)
	return exec(uwsmWrap(program))
end

---- Apps
hl.bind("SUPER + CTRL + T", execApp("alacritty"))
hl.bind("SUPER + CTRL + E", execApp("nautilus --new-window"))
hl.bind("SUPER + CTRL + C", execApp("code"))

---- Window management
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse:274", hl.dsp.window.float({ action = "toggle" }))
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind("SUPER + CTRL + B", hl.dsp.window.close())
-- Move
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
-- Focus
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
-- Fullscreen
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))
-- Extras
hl.bind("SUPER + V", hl.dsp.window.center())
hl.bind("SUPER + CTRL + G", hl.dsp.window.pin())
-- Swap workspaces between the two main monitors
if autoWorkspaceRules.enable and #displays > 1 then
	hl.bind(
		"SUPER + R",
		hl.dsp.workspace.swap_monitors({
			monitor1 = displays[1].adapter,
			monitor2 = displays[2].adapter,
		})
	)
end

---- Groups
hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + CTRL + left", hl.dsp.group.prev())
hl.bind("SUPER + CTRL + right", hl.dsp.group.next())

---- Workspace management
-- Keys 1-9 are binded to workspaces 1-9, and key 0 binds to workspace 10
for i = 1, 10 do -- From: https://github.com/hyprwm/Hyprland/blob/face6d144be7e33c7f49798d8cc5e8fe416de43c/example/hyprland.lua#L275-L279
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + D", hl.dsp.window.move({ workspace = "+1", follow = false }))
hl.bind("SUPER + A", hl.dsp.window.move({ workspace = "-1", follow = false }))

---- Utilities
-- Cursor zoom
do
	local function zoom(value)
		value = value or 0
		local current = hl.get_config("cursor.zoom_factor")
		hl.config({ cursor = { zoom_factor = math.max(current + value, 1) } })
	end

	hl.bind("SUPER + CTRL + mouse_up", function()
		zoom(0.2)
	end)
	hl.bind("SUPER + CTRL + mouse_down", function()
		zoom(-0.2)
	end)
end

---- Plugins
hl.bind("SUPER + Y", hl.plugin.darkwindow.dsp_shade({ shader = "invert" }))

---- Screenshots
local grimblast = runOnce("grimblast")
local copyarea = grimblast .. " copy area"
local freezed = grimblast .. " --freeze copy area"
-- Freezed
hl.bind("SUPER + SHIFT + S", exec(freezed))
-- Edit copied image
hl.bind("SUPER + CTRL + S", exec("wl-paste | " .. uwsmWrap(executable.satty .. " --filename -")))

---- Media controls
-- From: https://github.com/hyprwm/Hyprland/blob/7d4a3c5768d5a04c7b62e63265c82a3659529fd7/example/hyprland.lua#L293-L305
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
