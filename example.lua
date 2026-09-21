-- Every widget on one menu. Right Shift shows and hides it.

local LIB_FILE = "UILib.lua"

local function findLib()
	local g = rawget(_G, "UILib")
	if type(g) ~= "table" and type(getgenv) == "function" then
		local ok, env = pcall(getgenv)
		if ok and type(env) == "table" then
			g = rawget(env, "UILib")
		end
	end
	if type(g) == "table" and not g._dead then
		return g
	end
	return nil
end

do -- always run it: the library itself decides whether to reuse a live copy
	local src
	if not rawget(_G, "UI_LOCAL") then -- GitHub first, cached for offline runs
		pcall(function()
			src = game:HttpGet("https://raw.githubusercontent.com/Shoobie-code/linoria-inspired/refs/heads/main/main")
		end)
		if type(src) == "string" and #src > 1000 then
			pcall(writefile, LIB_FILE, src)
		else
			src = nil
		end
	end
	if not src then
		pcall(function()
			src = readfile(LIB_FILE)
		end)
	end
	if type(src) == "string" then
		pcall(function()
			loadstring(src)()
		end)
	end
end

local Library = findLib()
if not Library then
	warn("UILib.lua was not found in the Matcha workspace folder")
	return
end

local win = Library:CreateWindow({
	id = "ui_demo",
	title = "ui demo",
	subtitle = "v" .. Library.Version,
	size = { 520, 600 },
	toggleKey = "RSHIFT",
})

local main = win:AddTab("main")
local colors = win:AddTab("colors")

-- main / left column ---------------------------------------------------------

local master = main:AddGroup("master", 1)
master:AddToggle({ text = "esp toggle", flag = "esp", default = true }):AddKeybind({ flag = "esp_key", default = "F1" })
master:AddToggle({ text = "hud toggle", flag = "hud", default = true }):AddKeybind({ flag = "hud_key", default = "F2" })

local prefs = main:AddGroup("preferences", 1)
prefs:AddDropdown({ text = "hud style", flag = "hud_style", values = { "minimal", "boxed", "classic" }, default = "minimal" })
prefs:AddToggle({ text = "esp text outline", flag = "esp_outline", default = true })

local loot = main:AddGroup("loot esp", 1)
loot:AddToggle({ text = "loot esp", flag = "loot", default = true })
loot:AddDropdown({ text = "loot style", flag = "loot_style", values = { "none", "box", "corner", "dot" }, default = "none" })

local crates = main:AddGroup("supply crates", 1)
crates:AddToggle({ text = "crate esp", flag = "crate", default = true })
crates:AddToggle({ text = "supplies esp", flag = "supplies", default = true })
crates:AddButton({
	text = "insta-open crate", badge = "p", tooltip = "requires hybrid mode",
	callback = function()
		Library:Notify("opened the nearest crate", 3)
	end,
})

local dist = main:AddGroup("distance esp", 1)
dist:AddToggle({ text = "distance", flag = "distance" })
dist:AddDropdown({ text = "label position", flag = "label_pos", values = { "below", "above", "left", "right" }, default = "below" })
local minDist = dist:AddToggle({ text = "minimum distance", flag = "min_dist" })
dist:AddSlider({ text = "show distance after", flag = "min_dist_m", min = 0, max = 200, default = 20, suffix = "m", depends = minDist })

local target = main:AddGroup("target esp", 1)
target:AddToggle({ text = "target name", flag = "t_name", default = true })
target:AddTextbox({ text = "custom name", flag = "t_custom", default = "rake", placeholder = "leave empty for the real name" })
target:AddToggle({ text = "target health", flag = "t_health", default = true })
target:AddToggle({ text = "target distance", flag = "t_dist" })
target:AddToggle({ text = "health-based color", flag = "t_hpcolor" })
target:AddDropdown({ text = "health style", flag = "t_hpstyle", values = { "value", "bar", "both" }, default = "value" })
target:AddSlider({ text = "name y offset", flag = "t_name_y", min = -40, max = 40, default = 0, suffix = "px" })
target:AddSlider({ text = "health y offset", flag = "t_hp_y", min = -40, max = 40, default = 0, suffix = "px" })

-- main / right column --------------------------------------------------------

local client = main:AddGroup("client", 2)
client:AddToggle({ text = "no jump cooldown", flag = "no_jump_cd", badge = "!", tooltip = "server can notice this; use sparingly" })
client:AddToggle({ text = "infinite stamina", flag = "inf_stamina", badge = "!", tooltip = "server can notice this; use sparingly" })
client:AddToggle({ text = "no fall damage", flag = "no_fall" })
client:AddToggle({ text = "third person", flag = "third_person", badge = "?", tooltip = "lets the camera zoom out past the game's limit" })
client:AddSlider({ text = "zoom amount", flag = "zoom", min = .5, max = 50, step = .5, default = 10, suffix = " studs" })
client:AddButton({ text = "enable shift lock", badge = "?", tooltip = "turns on the game's own shift lock setting" })

local hud = main:AddGroup("player hud", 2)
hud:AddToggle({ text = "target", flag = "hud_target", default = true })
hud:AddToggle({ text = "loot value", flag = "hud_loot", default = true })

local world = main:AddGroup("world objects", 2)
world:AddToggle({ text = "flare gun", flag = "w_flare", default = true })
world:AddToggle({ text = "trap", flag = "w_trap", default = true })
world:AddDropdown({ text = "highlight", flag = "w_highlight", multi = true, values = { "flare", "trap", "crate", "loot" }, default = { "flare", "trap" } })

local power = main:AddGroup("power hud", 2)
power:AddToggle({ text = "power remaining", flag = "p_left", default = true, badge = "p", tooltip = "requires hybrid mode" })
power:AddToggle({ text = "decimal value", flag = "p_decimal", default = true })

local usage = main:AddGroup("power usage", 2)
usage:AddToggle({ text = "activity panel", flag = "u_panel", default = true })
usage:AddDropdown({ text = "show when", flag = "u_when", values = { "activity", "always", "never" }, default = "activity" })
usage:AddToggle({ text = "voltmeter level", flag = "u_volt", default = true })

local structs = main:AddGroup("structures esp", 2)
for _, name in ipairs({ "roof hp", "base", "house", "station", "shop", "tower" }) do
	structs:AddToggle({ text = name, flag = "s_" .. name, default = name ~= "roof hp" })
end

-- colors ---------------------------------------------------------------------

local sc = colors:AddGroup("structures esp", 1)
for _, name in ipairs({ "base", "house", "station", "shop", "tower" }) do
	sc:AddColor({ text = name, flag = "c_" .. name, default = "#FFFFFF" })
end

local lc = colors:AddGroup("loot esp", 1)
local lootColors = { "#9C8A63", "#B5995E", "#CDAA55", "#E5BB45", "#FFCC00" }
for i, hex in ipairs(lootColors) do
	lc:AddColor({ text = "loot " .. i, flag = "c_loot" .. i, default = hex })
end

local wc = colors:AddGroup("world objects", 1)
wc:AddColor({ text = "flare", flag = "c_flare", default = "#FF6B6B" })
wc:AddColor({ text = "trap", flag = "c_trap", default = "#E8C8F0" })
wc:AddColor({ text = "supply", flag = "c_supply", default = "#4DE8B0" })

local tc = colors:AddGroup("target esp", 1)
tc:AddColor({ text = "name", flag = "c_t_name", default = "#FF5A5A" })
tc:AddColor({ text = "health", flag = "c_t_hp", default = "#FFFFFF" })
tc:AddColor({ text = "health bar", flag = "c_t_bar", default = "#FF5A5A", rainbow = false })

local hl = colors:AddGroup("hud labels", 2)
for _, name in ipairs({ "timer label", "cooldown label", "target label", "loot label", "power label" }) do
	hl:AddColor({ text = name, flag = "c_" .. name, default = "#8C8C8C" })
end

local hv = colors:AddGroup("hud values", 2)
for _, name in ipairs({ "timer value", "cooldown value", "target value", "loot value", "power value" }) do
	hv:AddColor({ text = name, flag = "c_" .. name, default = "#FFFFFF" })
end
hv:AddColor({ text = "timer warning", flag = "c_timer_warn", default = "#FF7A7A" })

local cc = colors:AddGroup("crate", 2)
local crateColors = { medkit = "#D8FFD8", vitamin = "#C8C8FF", ["uv lamp"] = "#E080FF", ["stun stick"] = "#FFE08A", vest = "#8CC8FF", tracker = "#C8C0FF" }
for _, name in ipairs({ "medkit", "vitamin", "uv lamp", "stun stick", "vest", "tracker" }) do
	cc:AddColor({ text = name, flag = "c_" .. name, default = crateColors[name] })
end

-- misc: the library's settings tab plus a couple of extra groups -------------

local misc = win:AddSettingsTab("misc")

local binds = misc:AddGroup("keybinds", 2)
binds:AddKeybind({ text = "tp to loot", flag = "k_tp_loot", default = "F3", notify = false, onClick = function()
	Library:Notify("teleport to loot (demo)", 2)
end })
binds:AddKeybind({ text = "tp to flare", flag = "k_tp_flare", default = "F4", mode = "hold", callback = function(held)
	if held then
		Library:Notify("holding F4 (demo)", 1)
	end
end })
binds:AddLabel({ text = "right-click a bind to change its mode", dim = true })

local tp = misc:AddGroup("teleports", 1)
tp:AddDropdown({ text = "sort by", flag = "tp_sort", values = { "nearest", "value", "name" }, default = "nearest" })
tp:AddButton({ text = "teleport to loot", callback = function()
	Library:Notify("teleport to loot (demo)", 2)
end })

Library:SetWatermark("ui demo")
Library:SetWatermarkVisible(false)
Library:Notify("ui demo loaded - right shift toggles the menu", 5)
