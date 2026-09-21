# UILib


A flat, dense Drawing menu for Matcha. Sharp corners, monospace, no dependencies.

## Load

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Shoobie-code/linoria-inspired/refs/heads/main/main"))()
local Library = _G.UILib
```

Matcha drops loadstring's return value, so the library publishes itself as `_G.UILib` (`UI` is Matcha's own).

## Start

```lua
local win = Library:CreateWindow({ title = "my hub", size = { 520, 600 } })

local main = win:AddTab("main")
local esp = main:AddGroup("esp", 1)

esp:AddToggle({ text = "boxes", flag = "boxes", default = true, callback = function(on) end })
    :AddKeybind({ flag = "boxes_key", default = "F1" })
esp:AddSlider({ text = "distance", flag = "dist", min = 0, max = 500, default = 200, suffix = "m" })

win:AddSettingsTab()
```

Right Shift opens and closes the menu. Full file: [example.lua](example.lua)

## Window

```lua
Library:CreateWindow({
    title        = "my hub",
    subtitle     = "v1",                         -- right side of the title bar
    id           = "my_hub",                     -- defaults to title; the same id replaces the old window
    size         = { 500, 560 },                 -- at text size 13, scales with the font
    x = nil, y = nil,                            -- centred by default
    columns      = 2,                            -- 1 to 3
    toggleKey    = "RSHIFT",
    resizable    = true,
    visible      = true,
    config       = "my_hub.json",                -- every flag, saved a moment after each change
    folder       = "UI/my_hub",                  -- named configs
    autoload     = true,
    captureInput = function() return true end,   -- false lets the game keep its input
    inputGuard   = function() return false end,  -- true makes the menu ignore the mouse
    onUnload     = function() end,
})
```

```lua
win:Show()             win:Hide()              win:Toggle()          win:IsVisible()
win:SelectTab("main")  win:SetTitle("x", "v2")
win:GetValue("boxes")  win:SetValue("boxes", false)                  win.Flags.boxes
win:LoadSettings()     win:SaveSettings()
win:Unload()           win:Destroy()
```

`win:LoadSettings()` at the end of your build applies the saved file right away, so your own code after it sees the saved values. `win:Unload()` runs `onUnload`, then removes the window; the last window unloads the library.

## Tabs and groups

```lua
local tab = win:AddTab("visuals")
local players = tab:AddGroup("players", 1)             -- column 1, 2, 3, or "left" / "right"
local world = tab:AddRightGroup("world")
local extras = tab:AddGroup("extras", 2, { collapsed = true })

players:SetCollapsed(true)   players:Toggle()   players:SetTitle("x")   tab:Select()
```

Click a group title to fold it. Tabs size to their names and wrap onto another row when they run out of room. Each column scrolls on its own.

## Widgets

```lua
g:AddToggle({ text = "god mode", flag = "god", default = false })
g:AddSlider({ text = "walk speed", flag = "ws", min = 16, max = 250, default = 16 })
g:AddSlider({ text = "smooth", flag = "smooth", min = 0, max = 1, step = .05, suffix = "x" })
g:AddDropdown({ text = "mode", flag = "mode", values = { "closest", "random" }, default = "closest" })
g:AddDropdown({ text = "parts", flag = "parts", values = { "head", "torso" }, multi = true })
g:AddColor({ text = "esp color", flag = "esp_color", default = "#FF5050" })
g:AddTextbox({ text = "webhook", flag = "hook", placeholder = "https://..." })
g:AddKeybind({ text = "panic", flag = "panic", default = "K", onClick = function() end })
g:AddButton({ text = "rejoin", confirm = true, callback = function() end })
g:AddLabel({ text = "status: idle", dim = true })
g:AddDivider()
```

Every widget takes one table:

| key | |
|---|---|
| `text` | label |
| `flag` | config key; also indexes `win.Flags` |
| `default` | starting value |
| `callback` | `function(value, widget)`, fires on change |
| `tooltip` | `"text"` or `{ title = "", text = "" }` |
| `badge` | `"!"` red, `"?"` orange, `"p"` blue, or `{ text = "[beta]", color = Color3 }` |
| `depends` | a toggle, `{ widget, value }`, or a function |
| `hideDisabled` | hide instead of dim when `depends` fails |
| `save = false` | leave out of configs |

- Sliders: drag the bar, or click the number and type. Arrow keys nudge a hovered slider.
- Dropdowns: right click steps to the next value. Lists longer than 8 filter as you type.
- Textboxes take `numeric`, `maxLength`, `live` (fire on every key).
- Colours take `Color3`, `"#RRGGBB"` or `{ r, g, b }`. The picker has hue, saturation/value, hex entry, rainbow and six recent colours.

## Handles

```lua
local aim = g:AddToggle({ text = "aimbot", flag = "aim" })
aim:AddKeybind({ flag = "aim_key", default = "MB2", mode = "hold" })
aim:AddColor({ flag = "fov_color", default = "#78FF8C" })

g:AddSlider({ text = "fov", flag = "fov", min = 10, max = 500, depends = aim })
```

```lua
h:Get()          h:Set(v)          h:Set(v, true)     h:OnChanged(fn)
h:SetText("x")   h:SetTooltip("x") h:SetVisible(b)    h:SetEnabled(b)
```

Colours also take `GetRGB` `GetHex` `SetRainbow`. Keybinds take `GetKey` `GetState` `SetMode` `OnClick`. Dropdowns take `SetValues`.

## Keybinds

Modes are `toggle`, `hold`, `always`. Click the key to rebind, Escape cancels, Backspace clears, right click cycles the mode. An inline bind drives its toggle unless `sync = false`.

Every press shows a notification: `aimbot: on` / `: off` for toggles, the row name for `onClick` binds. Hold binds stay quiet and repeated presses rewrite one notification. `notify = false` silences one bind, `list = false` keeps it off the keybind list.

Keys: `A`-`Z` `0`-`9` `F1`-`F24` `NUM0`-`NUM9` `LSHIFT` `RSHIFT` `LCTRL` `LALT` `SPACE` `TAB` `INS` `DEL` `HOME` `END` `PGUP` `PGDN` arrows `MB2`-`MB5`.

## Notifications

```lua
Library:Notify("saved", 3)
Library:Notify({ title = "aimbot", text = "enabled", duration = 3, key = "aim" })  -- same key rewrites
Library:SetWatermark("my hub")      -- name | ping | time, draggable
Library:SetKeybindList(true)        -- every bound key, active ones lit, draggable
```

## Look

```lua
Library:SetTheme("terminal")                 -- or a table of roles
Library:SetThemeColor("accent", "#FF8800")
Library:SetFont("Monospace", 13)             -- the whole menu scales with the size
Library:SetOpacity(.9)
Library:SetTextOutline(true)
Library:SetAccentBar({ rainbow = true, direction = 1, speed = .1 })
```

Presets: monochrome, graphite, deep sea, rose noir, terminal, ultraviolet, obsidian, nordic, sakura, amber.

Roles: `accent` `background` `group` `topbar` `border` `outline` `text`. Everything else is mixed from these. Title bar text and badges shift by contrast, so light themes stay readable.

Fonts: whatever Matcha's Drawing offers, usually UI, System, SystemBold, Minecraft, Monospace, Pixel, Fortnite, ProximaSoftBold.

## Configs

```lua
win:SaveConfig("legit")   win:LoadConfig("legit")   win:DeleteConfig("legit")
win:ListConfigs()         win:SetAutoload("legit")  win:GetAutoload()
```

Named configs are `UI/<id>/<name>.json`. `config` in `CreateWindow` is separate: one settings file, written a moment after every change and loaded on start. Window position, size, tab and folded groups are saved with it.

`win:AddSettingsTab()` puts presets, theme colours, font and size, opacity, watermark, keybind list, configs, menu key, refresh rate and unload in one tab. `{ unload = false }` drops the unload button.

## Input

Matcha has no mouse wheel. A column that overflows gets a flat arrow bar at each end: rest the pointer on one to scroll, click it to jump a page. The scrollbar, dragging empty space, and the arrow keys / Page Up / Page Down work too.

While the pointer is over the menu, game input is held back. `captureInput` returning false lets it through, for a macro that needs its clicks. `inputGuard` returning true makes the menu ignore the mouse while your script is clicking.

## Unload

```lua
Library:OnUnload(function() end)
Library:Unload()
```

Several scripts share one running copy. Running a script again replaces only its own window.

## Performance

- Every Drawing object is made when its widget is built. Popups are made on first open.
- Property writes are cached, so an idle frame writes nothing and a hover writes 4 properties.
- RenderStepped is only connected while something is on screen. Hidden, keybinds are polled from Heartbeat.
- Slider and colour drags fire your callback at most 30 times a second, plus once on release.
