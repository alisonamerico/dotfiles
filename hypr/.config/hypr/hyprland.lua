-- =============================================================================
-- HYPRLAND LUA CONFIG
-- Converted from hyprland.conf to Lua for Hyprland 0.55+
-- =============================================================================

-- You can split this configuration into multiple files:
-- require("myColors")


--------------------
--- MY PROGRAMS ---
--------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "rofi -show drun -theme ~/.config/rofi/style-3.rasi"


------------------
--- AUTOSTART ---
------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon &")
    hl.exec_cmd("sleep 1 && ~/.config/hypr/scripts/wallpaper.sh")
    -- waybar is (re)launched by monitor-daemon.sh so it survives HDMI hotplug
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("~/.config/hypr/scripts/monitor-daemon.sh")
    hl.exec_cmd("sleep 2 && ~/dotfiles/scripts/battery-warning.sh &")
    hl.exec_cmd("udiskie &")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
end)


--------------------------------
--- ENVIRONMENT VARIABLES ---
--------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_SCALE", "1")
hl.env("GDK_DPI_SCALE", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")


------------------
--- MONITORS ---
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})

-- HDMI switching handled by udev rule + monitor-daemon.sh
-- Install: ~/.config/hypr/scripts/install-hdmi-udev.sh


---------------------------
--- PERMISSIONS (off) ---
---------------------------

-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


------------------------
--- LOOK AND FEEL ---
------------------------

hl.config({
    general = {
        gaps_in        = 4,
        gaps_out       = 8,
        border_size    = 1,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "intl",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },
})


-------------------------------
--- CURVES (BEZIERS) ---
-------------------------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })


---------------------------
--- ANIMATIONS ---
---------------------------

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })


---------------------------
--- GESTURE ---
---------------------------

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


-- Per-device config (example, disabled)
-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })


-----------------
--- BINDS ---
-----------------

local mainMod = "SUPER"

-- Toggle notification center
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Open terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

-- Close active window
hl.bind(mainMod .. " + C", hl.dsp.window.close())

-- Shutdown/suspend menu
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))

-- File manager
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- Toggle floating
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Launcher (rofi)
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- Pseudo (dwindle) - NOTE: overridden by systemctl suspend below
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Toggle split (dwindle)
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Move focus with arrows
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch / move to workspaces 1-10
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move / resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots (Print)
hl.bind("Print",            hl.dsp.exec_cmd("grim -g \"$(slurp)\" -t ppm - | satty --filename - --output-filename ~/images/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))
hl.bind("SHIFT + Print",    hl.dsp.exec_cmd("grim -t ppm - | satty --filename - --output-filename ~/images/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))

-- Screenshots (Super + O)
hl.bind(mainMod .. " + O",         hl.dsp.exec_cmd("grim -g \"$(slurp)\" -t ppm - | satty --filename - --output-filename ~/images/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("grim -t ppm - | satty --filename - --output-filename ~/images/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))

-- App shortcuts
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave --password-store=basic --disable-brave-wallet --disable-ethereum"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("nvim"))

-- Reload config
hl.bind(mainMod .. " + CTRL + R",       hl.dsp.exec_cmd("hyprctl reload && killall waybar && waybar"))
hl.bind(mainMod .. " + CTRL + SHIFT + R", hl.dsp.exec_cmd("killall waybar && waybar"))

-- Lock and power
hl.bind(mainMod .. " + L",       hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + X",       hl.dsp.exec_cmd("~/.config/rofi/scripts/powermenu.sh"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("loginctl terminate-user $USER"))
hl.bind(mainMod .. " + P",       hl.dsp.exec_cmd("systemctl suspend"))  -- overrides pseudo above

-- Audio controls (keyboard)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { repeating = true })

-- Brightness controls (keyboard)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

-- Audio controls (Super + keys)
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { repeating = true })
hl.bind(mainMod .. " + XF86AudioMute",  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { repeating = true })

-- Brightness controls (Super + keys)
hl.bind(mainMod .. " + XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
hl.bind(mainMod .. " + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

-- Media controls (locked = works when screen is locked)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Laptop lid switch — keeps external monitor active when lid is closed
hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd("~/.config/hypr/scripts/lid-switch.sh close"))
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/lid-switch.sh open"))


---------------------------------
--- WINDOW RULES ---
---------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
