-- mimisense v22: no keybind conflict dialog, accented overlay glow, themed opaque notifications, stable options popup placement
-- mimisense UI library: search, tooltips, DependsOn, range slider, context menu, section reset, animated themes,
-- export/import strings, menu settings, new colorpicker, watermark fields, keybind list modes, notification side
--[[
    Made by samet
    Example is at the bottom.

    Date:
    7/30/2026 11:53 PM

    If you find any bugs or anything that needs to be changed, please let me know in the ticket or dms
    ^^^ if you find anything that I forgot to do aswell.
]]

if getgenv().Library then
    if getgenv().Library.Exit then
        getgenv().Library:Exit()
    elseif getgenv().Library.Unload then
        getgenv().Library:Unload()
    end
end

cloneref = cloneref or function(Object) return Object end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local CoreGui = cloneref(game:GetService("CoreGui"))

gethui = gethui or function() return CoreGui end

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled or false
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())

local Library = {
    BuildVersion = "2026.10.29-v27-mimisense-softglow",
    Flags = { },

    MenuKeybind = tostring(Enum.KeyCode.X),

    Directory = "mimisense",

    -- Ссылка на твой Icons.lua (raw) в репозитории
    IconsUrl = "https://raw.githubusercontent.com/xolylol/mimisense/main/Icons.lua",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs",
        Themes = "/Themes"
    },

    FontSize = 14,

    Animation = {
        Time = 0.35,
        Style = "Quart",
        Direction = "Out"
    },

    ZIndexOrder = {
        ["OptionHolder"] = 50,
        ["KeybindWindow"] = 55,
        ["ColorpickerWindow"] = 205
    },

    -- Ignore below
    Threads = { },
    Connections = { },
    SetFlags = { },

    ThemingStuff = { },
    ThemeMap = { },

    OpenFrames = { },
    OpenFrameTriggers = { },
    OpenFrameInteracting = false,

    Notifications = { },

    Holder = nil,
    UnusedHolder = nil,

    Theme = nil,

    Font = nil,

    UIClickSoundId = "rbxassetid://88442833509532",
    MascotClickSoundId = "rbxassetid://102774986031312",
    UIClickSound = nil,
    MascotClickSound = nil,
    UIClickVolume = 0.65,
    UIClickEnabled = true,
    NotificationEnabled = true,
    MascotClickVolume = 0.8,
} do
    Library.__index = Library

    local Flags = Library.Flags
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = ")",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "/",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracket",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "Keypad.",
        ["KeypadDivide"]      = "Keypad/",
        ["KeypadMultiply"]    = "Keypad*",
        ["KeypadMinus"]       = "Keypad-",
        ["KeypadPlus"]        = "Keypad+",
        ["KeypadEnter"]       = "KeypadEnter",
        ["KeypadEquals"]      = "Keypad=",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Folders
    local function SafeLibraryMakeFolder(Path)
        if isfolder and isfolder(Path) then
            return true
        end

        return pcall(function()
            makefolder(Path)
        end)
    end

    local function SafeLibraryWriteFile(Path, Content)
        return pcall(function()
            writefile(Path, Content)
        end)
    end

    local function PrepareFolders()
        for _, Folder in Library.Folders do
            SafeLibraryMakeFolder(Library.Directory .. Folder)
        end

        if not isfile(Library.Directory .. "/autoload.json") then
            SafeLibraryWriteFile(Library.Directory .. "/autoload.json", "")
        end
    end

    SafeLibraryMakeFolder(Library.Directory)
    PrepareFolders()

    -- Меняет папку скрипта (конфиги, автозагрузка). Можно вложенную: "my script/main"
    -- Вызывать в самом начале скрипта, до Library:Window и до работы с конфигами.
    -- Свои подпапки: Library.Folders.Themes = "/Themes" (перед вызовом SetDirectory)
    Library.SetDirectory = function(Self, Name)
        Name = tostring(Name or ""):gsub("\\", "/"):gsub("^/+", ""):gsub("/+$", "")

        if Name == "" then
            return false
        end

        Library.Directory = Name

        local Path = ""
        for Segment in Name:gmatch("[^/]+") do
            Path = Path == "" and Segment or (Path .. "/" .. Segment)
            SafeLibraryMakeFolder(Path)
        end

        PrepareFolders()

        return true
    end

    local Themes = {
        -- This is the shipped theme for every first-time user.
        -- Window.Theme, Library:SetStartupTheme(), or a saved default can override it.
        ["Default"] = {
            ["Background"] = Color3.fromRGB(26, 20, 19),
            ["Inline"] = Color3.fromRGB(33, 26, 24),
            ["Tab"] = Color3.fromRGB(42, 33, 30),
            ["Text"] = Color3.fromRGB(245, 232, 222),
            ["Inactive Text"] = Color3.fromRGB(150, 128, 116),
            ["Accent"] = Color3.fromRGB(232, 150, 130),
            ["Outline"] = Color3.fromRGB(52, 41, 37),
            ["Hovered Element"] = Color3.fromRGB(62, 49, 44),
        },
        ["Preset"] = {
            ["Background"] = Color3.fromRGB(20, 22, 24),
            ["Inline"] = Color3.fromRGB(24, 27, 29),
            ["Tab"] = Color3.fromRGB(28, 32, 34),
            ["Text"] = Color3.fromRGB(255, 255, 255),
            ["Inactive Text"] = Color3.fromRGB(120, 120, 120),
            ["Accent"] = Color3.fromRGB(179, 165, 255),
            ["Outline"] = Color3.fromRGB(29, 31, 34),
            ["Hovered Element"] = Color3.fromRGB(29, 31, 34),
        },
        ["Sky"] = {
            ["Background"] = Color3.fromRGB(20, 23, 24),
            ["Inline"] = Color3.fromRGB(31, 35, 36),
            ["Tab"] = Color3.fromRGB(36, 41, 43),
            ["Text"] = Color3.fromRGB(255, 255, 255),
            ["Inactive Text"] = Color3.fromRGB(134, 134, 134),
            ["Accent"] = Color3.fromRGB(147, 238, 255),
            ["Outline"] = Color3.fromRGB(41, 45, 46),
            ["Hovered Element"] = Color3.fromRGB(68, 73, 73),
        },
        ["Magma"] = {
            ["Background"] = Color3.fromRGB(34, 28, 28),
            ["Inline"] = Color3.fromRGB(31, 23, 23),
            ["Tab"] = Color3.fromRGB(41, 33, 33),
            ["Text"] = Color3.fromRGB(208, 207, 227),
            ["Inactive Text"] = Color3.fromRGB(134, 121, 121),
            ["Accent"] = Color3.fromRGB(233, 43, 26),
            ["Outline"] = Color3.fromRGB(41, 29, 29),
            ["Hovered Element"] = Color3.fromRGB(54, 42, 42),
        },
        ["Sand"] = {
            ["Background"] = Color3.fromRGB(45, 46, 37),
            ["Inline"] = Color3.fromRGB(63, 65, 55),
            ["Tab"] = Color3.fromRGB(54, 56, 44),
            ["Text"] = Color3.fromRGB(208, 207, 227),
            ["Inactive Text"] = Color3.fromRGB(136, 135, 132),
            ["Accent"] = Color3.fromRGB(255, 229, 147),
            ["Outline"] = Color3.fromRGB(88, 83, 68),
            ["Hovered Element"] = Color3.fromRGB(71, 71, 59),
        },
        ["Navy"] = {
            ["Background"] = Color3.fromRGB(28, 30, 36),
            ["Inline"] = Color3.fromRGB(32, 34, 41),
            ["Tab"] = Color3.fromRGB(40, 43, 49),
            ["Text"] = Color3.fromRGB(165, 164, 187),
            ["Inactive Text"] = Color3.fromRGB(101, 105, 126),
            ["Accent"] = Color3.fromRGB(0, 102, 255),
            ["Outline"] = Color3.fromRGB(37, 42, 54),
            ["Hovered Element"] = Color3.fromRGB(40, 43, 49),
        },
        ["Emerald"] = {
            ["Background"] = Color3.fromRGB(18, 24, 21),
            ["Inline"] = Color3.fromRGB(24, 32, 28),
            ["Tab"] = Color3.fromRGB(30, 40, 34),
            ["Text"] = Color3.fromRGB(230, 245, 235),
            ["Inactive Text"] = Color3.fromRGB(110, 135, 120),
            ["Accent"] = Color3.fromRGB(52, 211, 153),
            ["Outline"] = Color3.fromRGB(36, 48, 41),
            ["Hovered Element"] = Color3.fromRGB(42, 58, 48),
        },
        ["Rose"] = {
            ["Background"] = Color3.fromRGB(28, 20, 24),
            ["Inline"] = Color3.fromRGB(36, 26, 31),
            ["Tab"] = Color3.fromRGB(44, 32, 38),
            ["Text"] = Color3.fromRGB(255, 240, 245),
            ["Inactive Text"] = Color3.fromRGB(150, 120, 130),
            ["Accent"] = Color3.fromRGB(244, 114, 182),
            ["Outline"] = Color3.fromRGB(52, 36, 44),
            ["Hovered Element"] = Color3.fromRGB(58, 40, 48),
        },
        ["Midnight"] = {
            ["Background"] = Color3.fromRGB(12, 12, 18),
            ["Inline"] = Color3.fromRGB(18, 18, 28),
            ["Tab"] = Color3.fromRGB(24, 24, 38),
            ["Text"] = Color3.fromRGB(230, 230, 245),
            ["Inactive Text"] = Color3.fromRGB(110, 110, 140),
            ["Accent"] = Color3.fromRGB(129, 140, 248),
            ["Outline"] = Color3.fromRGB(32, 32, 48),
            ["Hovered Element"] = Color3.fromRGB(40, 40, 60),
        },
        ["Coral"] = {
            ["Background"] = Color3.fromRGB(28, 22, 20),
            ["Inline"] = Color3.fromRGB(36, 28, 25),
            ["Tab"] = Color3.fromRGB(44, 34, 30),
            ["Text"] = Color3.fromRGB(255, 245, 240),
            ["Inactive Text"] = Color3.fromRGB(150, 125, 115),
            ["Accent"] = Color3.fromRGB(255, 112, 67),
            ["Outline"] = Color3.fromRGB(52, 40, 35),
            ["Hovered Element"] = Color3.fromRGB(58, 44, 38),
        },
        ["Mono"] = {
            ["Background"] = Color3.fromRGB(14, 14, 14),
            ["Inline"] = Color3.fromRGB(22, 22, 22),
            ["Tab"] = Color3.fromRGB(30, 30, 30),
            ["Text"] = Color3.fromRGB(245, 245, 245),
            ["Inactive Text"] = Color3.fromRGB(120, 120, 120),
            ["Accent"] = Color3.fromRGB(220, 220, 220),
            ["Outline"] = Color3.fromRGB(40, 40, 40),
            ["Hovered Element"] = Color3.fromRGB(48, 48, 48),
        },
    }

    local ThemeOrder = { "Default", "Preset", "Sky", "Magma", "Sand", "Navy", "Emerald", "Rose", "Midnight", "Coral", "Mono" }

    Library.Themes = Themes

    -- flags that must be applied first when a config is loaded (JSON key order is random)
    Library.LoadFirst = { "SelectedTheme", "Mascot/Selected", "Mascot/Name" }
    -- UI-only flags that should never be written into a config
    Library.ConfigIgnore = {
        ["Configs"] = true, ["ConfigName"] = true, ["ThemeProfiles"] = true, ["ThemeName"] = true,
        -- interface settings live in ui_state.json, not in configs
        ["UI/SearchBar"] = true, ["UI/Scale"] = true, ["UI/Opacity"] = true, ["UI/Font"] = true,
        ["UI/NotifSide"] = true, ["UI/NotificationDuration"] = true, ["UI/ThemeAnimation"] = true, ["UI/RememberUI"] = true,
        ["UI/ScalePreset"] = true,
        ["UI/WatermarkFields"] = true, ["UI/KeybindListMode"] = true, ["UI/ImportString"] = true
    }
    Library.ThemeOrder = ThemeOrder
    Library.StartupTheme = "Default"
    Library.Theme = table.clone(Themes["Default"])

    -- Developers can set a global startup theme BEFORE creating a window:
    -- Library:SetStartupTheme("Sky")
    -- This sets the starting palette, not a disk preference or a forced theme on every restart.
    Library.SetStartupTheme = function(Self, Name)
        if type(Name) ~= "string" or Name == "" then return false end
        if Name == "defoult" or Name == "default" then Name = "Default" end
        if not Themes[Name] and not Library:ReadTheme(Name) then
            warn("[mimisense] Unknown startup theme: " .. tostring(Name))
            return false
        end
        Library.StartupTheme = Name
        return true
    end

    -- applies a { [ThemeKey] = Color3 } table: recolors the UI and syncs the Theming colorpickers
    -- Apply a complete theme in a single pass, avoiding multiple full-UI walks.
    Library.ApplyThemeData = function(Self, ThemeData)
        if type(ThemeData) ~= "table" then return false end
        local NewColors = {}
        for Key, Color in ThemeData do
            if Library.Theme[Key] ~= nil and typeof(Color) == "Color3" then
                NewColors[Key] = Color
            end
        end
        if not next(NewColors) then return false end

        Library.ThemeBulkUpdating = true
        for Key, Color in NewColors do
            Library.Theme[Key] = Color
            local Setter = Library.SetFlags[Key .. "Theming"]
            if Setter then pcall(Setter, Color, 0) end
        end
        Library.ThemeBulkUpdating = false

        local UseAnimation = Library.ThemeAnimation ~= false
        local Info = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        for _, Item in Library.ThemingStuff do
            local Object = Item.Item
            if Object and Object.Parent then
                local Targets = {}
                for Property, ThemeKey in Item.Properties do
                    if type(ThemeKey) == "string" then
                        if NewColors[ThemeKey] then Targets[Property] = Library.Theme[ThemeKey] end
                    elseif type(ThemeKey) == "function" then
                        local Ok, Value = pcall(ThemeKey)
                        if Ok and typeof(Value) == "Color3" then Targets[Property] = Value end
                    end
                end
                if next(Targets) then
                    if UseAnimation then
                        local Ok, Tween = pcall(TweenService.Create, TweenService, Object, Info, Targets)
                        if Ok then Tween:Play() else
                            for K, V in Targets do pcall(function() Object[K] = V end) end
                        end
                    else
                        for K, V in Targets do pcall(function() Object[K] = V end) end
                    end
                end
            end
        end
        if Library.SetMenuGlow then
            Library:SetMenuGlow(Library.MenuGlowStrength or 35, Library.MenuGlowEnabled ~= false)
        end
        return true
    end

    Library.ApplyTheme = function(Self, Name)
        local ThemeData = Themes[Name]

        if not ThemeData then
            return false
        end

        return Library:ApplyThemeData(ThemeData)
    end

    -- ---------------------------------------------------------------
    -- Theme profiles (custom themes saved as <Directory>/Themes/<name>.json)
    -- and the default theme (<Directory>/Themes/default.txt), loaded on start by Window:Init()
    -- ---------------------------------------------------------------
    local function ThemePath(Name)
        return Library.Directory .. Library.Folders.Themes .. "/" .. Name .. ".json"
    end

    local function DefaultThemePath()
        return Library.Directory .. Library.Folders.Themes .. "/default.txt"
    end

    Library.GetThemesList = function(Self)
        local Result = { }
        local Ok, List = pcall(listfiles, Library.Directory .. Library.Folders.Themes)

        if Ok and type(List) == "table" then
            for _, File in List do
                local Name = tostring(File):match("([^/\\]+)%.json$")

                if Name then
                    table.insert(Result, Name)
                end
            end

            table.sort(Result)
        end

        return Result
    end

    -- saves the colors that are in use right now
    Library.SaveTheme = function(Self, Name)
        local Data = { }

        for Index, Color in Library.Theme do
            Data[Index] = "#" .. Color:ToHex()
        end

        return pcall(writefile, ThemePath(Name), HttpService:JSONEncode(Data))
    end

    Library.ReadTheme = function(Self, Name)
        local Ok, Content = pcall(readfile, ThemePath(Name))

        if not Ok then
            return nil, "file not found"
        end

        local Decoded
        Ok, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)

        if not Ok or type(Decoded) ~= "table" then
            return nil, "invalid theme file"
        end

        local ThemeData = { }

        for Index, Hex in Decoded do
            if Library.Theme[Index] ~= nil and type(Hex) == "string" then
                local Parsed, Color = pcall(Color3.fromHex, Hex)

                if Parsed then
                    ThemeData[Index] = Color
                end
            end
        end

        return ThemeData
    end

    Library.DeleteTheme = function(Self, Name)
        return pcall(delfile, ThemePath(Name))
    end

    Library.GetDefaultTheme = function(Self)
        local Ok, Name = pcall(readfile, DefaultThemePath())

        if not Ok then
            return nil
        end

        Name = (tostring(Name):gsub("^%s+", ""):gsub("%s+$", ""))

        return Name ~= "" and Name or nil
    end

    -- Name = nil clears the default theme
    Library.SetDefaultTheme = function(Self, Name)
        return pcall(writefile, DefaultThemePath(), Name or "")
    end

    -- preset or custom theme by name
    Library.ApplyNamedTheme = function(Self, Name)
        if Name == "defoult" or Name == "default" then Name = "Default" end
        if Themes[Name] then
            return Library:ApplyTheme(Name)
        end

        local ThemeData = Library:ReadTheme(Name)

        if not ThemeData then
            return false
        end

        return Library:ApplyThemeData(ThemeData)
    end

    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            local Success, Result = pcall(function()
                if not isfile(Data.Id) then
                    writefile(Data.Id, game:HttpGet(Data.Url))
                end

                local FontData = {
                    name = Name,
                    faces = {
                        {
                            name = Name,
                            weight = Weight,
                            style = Style,
                            assetId = getcustomasset(Data.Id)
                        }
                    }
                }

                local AssetsFolder = Library.Directory .. Library.Folders.Assets
                if SafeLibraryMakeFolder then
                    SafeLibraryMakeFolder(AssetsFolder)
                end

                writefile(`{AssetsFolder}/{Name}.font`, HttpService:JSONEncode(FontData))
                return Font.new(getcustomasset(`{AssetsFolder}/{Name}.font`))
            end)

            return Success and Result or Font.fromEnum(Enum.Font.Code)
        end
        Library.Font = CustomFont:New("Figtree", 400, "Regular", {
            Id = "Figtree",
            Url = "https://github.com/NIcoGabrielRealYtr/luas/raw/refs/heads/main/fonts/Figtree-SemiBold.ttf"
        })
    end

    Library.NormalizeSoundId = function(Self, SoundId)
        if SoundId == nil or SoundId == "" or SoundId == false then
            return nil
        end

        local Value = tostring(SoundId)
        if Value:match("^rbxassetid://") then
            return Value
        end

        local Number = Value:match("(%d+)")
        return Number and ("rbxassetid://" .. Number) or nil
    end

    Library.SetUIClickSound = function(Self, SoundId)
        Library.UIClickSoundId = Self:NormalizeSoundId(SoundId)
        Library.UIClickEnabled = Library.UIClickSoundId ~= nil
        if Library.UIClickSound then
            Library.UIClickSound:Stop()
            Library.UIClickSound.SoundId = Library.UIClickSoundId or ""
            Library.UIClickSound.Volume = Library.UIClickEnabled and (Library.UIClickVolume or 0.65) or 0
        end
        return Library.UIClickSoundId
    end

    Library.SetMascotClickSound = function(Self, SoundId)
        Library.MascotClickSoundId = Self:NormalizeSoundId(SoundId)
        if Library.MascotClickSound then
            Library.MascotClickSound.SoundId = Library.MascotClickSoundId or ""
        end
        return Library.MascotClickSoundId
    end

    Library.PlayUIClickSound = function(Self)
        local Sound = Library.UIClickSound
        if not Sound or not Sound.Parent or Library.UIClickEnabled == false or not Library.UIClickSoundId then return end
        Sound.SoundId = Library.UIClickSoundId
        Sound.TimePosition = 0
        pcall(function() SoundService:PlayLocalSound(Sound) end)
    end

    Library.PlayMascotClickSound = function(Self)
        local Sound = Library.MascotClickSound
        if not Sound or not Sound.Parent or not Library.MascotClickSoundId then return end
        Sound.SoundId = Library.MascotClickSoundId
        Sound.TimePosition = 0
        pcall(function() SoundService:PlayLocalSound(Sound) end)
    end

    Library.Exit = function(Self)
        Self = Self or Library

        for _, Connection in Library.Connections do
            pcall(function() Connection:Disconnect() end)
        end

        local Current = coroutine.running()
        for _, Thread in Library.Threads do
            if Thread ~= Current then
                pcall(coroutine.close, Thread)
            end
        end

        for _, Name in {"Holder", "NotifHolder", "UnusedHolder"} do
            local Holder = Self[Name]
            if Holder and Holder.Instance then
                pcall(function() Holder.Instance:Destroy() end)
            end
        end

        for _, Name in {"UIClickSound", "MascotClickSound", "NotificationSound"} do
            if Self[Name] then
                pcall(function() Self[Name]:Destroy() end)
            end
        end

        Library.ActiveWindow = nil

        Library = nil
        getgenv().Library = nil
    end

    -- alias, old scripts call Library:Unload()
    Library.Unload = Library.Exit

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do
            if Index == "FontFace" and Property == "FontFace" then
                Data.Instance.FontFace = Library.Font
            elseif Index == "TextSize" and Property == "TextSize" then
                Data.Instance.TextSize = Library.FontSize
            else
                Data.Instance[Index] = Property
            end
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)

        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then
                if IsMobile and Signal == "MouseButton1Down" then
                    Connection = Self.Instance.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Callback(Input)
                        end
                    end)
                    table.insert(Library.Connections, Connection)
                    return Connection
                end

                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then
            return
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return { }
        end

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({
            [Property] = Visibility and OldTransparency or 1
        }, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    -- Stable widget visibility animation. Unlike FadeDescendants, this does not restore
    -- stale transparency values from an older hide tween after a newer show tween.
    Library.AnimatedVisibility = function(Self, Root, Visible, State, ScaleObject)
        State = State or {}
        State.Token = (State.Token or 0) + 1
        local Token = State.Token
        State.Visible = Visible and true or false
        State.Baseline = State.Baseline or {}

        local RootObject = Root.Instance or Root
        if not RootObject then return State end

        local Targets = RootObject:GetDescendants()
        table.insert(Targets, RootObject)

        if Visible then
            RootObject.Visible = true
        end

        for _, Object in Targets do
            local Property = Library:GetTweenProperty(Object)
            if type(Property) == "table" then
                for _, Name in Property do
                    if State.Baseline[Object] == nil then State.Baseline[Object] = {} end
                    if State.Baseline[Object][Name] == nil then
                        local Ok, Value = pcall(function() return Object[Name] end)
                        if Ok then State.Baseline[Object][Name] = Value end
                    end
                    local Target = Visible and State.Baseline[Object][Name] or 1
                    if Target ~= nil then Library:Tween({[Name] = Target}, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Visible and Enum.EasingDirection.Out or Enum.EasingDirection.In), Object) end
                end
            elseif Property then
                if State.Baseline[Object] == nil then State.Baseline[Object] = {} end
                if State.Baseline[Object][Property] == nil then
                    local Ok, Value = pcall(function() return Object[Property] end)
                    if Ok then State.Baseline[Object][Property] = Value end
                end
                local Target = Visible and State.Baseline[Object][Property] or 1
                if Target ~= nil then Library:Tween({[Property] = Target}, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Visible and Enum.EasingDirection.Out or Enum.EasingDirection.In), Object) end
            end
        end

        if ScaleObject then
            ScaleObject:Tween({Scale = Visible and 1 or 0.85}, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Visible and Enum.EasingDirection.Out or Enum.EasingDirection.In))
        end

        if not Visible then
            task.delay(0.27, function()
                if State.Token == Token and not State.Visible and RootObject.Parent then
                    RootObject.Visible = false
                end
            end)
        end

        return State
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then
            Self.Instance.Visible = true
        end

        local NewTween

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then
                continue
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        if not NewTween then
            if Callback and type(Callback) == "function" then
                Callback()
            end

            Self.Instance.Visible = Visibility
            return
        end

        Library:Connect(NewTween.Completed, function()
            if Callback and type(Callback) == "function" then
                Callback()
            end

            Self.Instance.Visible = Visibility
        end)
    end

    -- v17: movement is relative to the position at mouse-down, not to a
    -- reconstructed AbsolutePosition. Starting a drag with an unmoved mouse
    -- must NEVER change Gui.Position. No tween is created on every mouse event.
    Library.MakeDraggable = function(Self, Handle)
        if not Self.Instance then return end
        local Gui = Self.Instance
        local HandleInstance = (Handle and Handle.Instance) or Gui
        local Dragging = false
        local DragStart = nil
        local StartPosition = nil
        local StartAbsolute = nil
        local TouchInput = nil
        local EndConnection = nil

        local function FinishDrag()
            Dragging = false
            TouchInput = nil
            if EndConnection then
                EndConnection:Disconnect()
                EndConnection = nil
            end
        end

        Library:Connect(HandleInstance.InputBegan, function(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseButton1
                and Input.UserInputType ~= Enum.UserInputType.Touch then return end

            FinishDrag()
            Dragging = true
            TouchInput = Input.UserInputType == Enum.UserInputType.Touch and Input or nil
            DragStart = Vector2.new(Input.Position.X, Input.Position.Y)
            StartPosition = Gui.Position
            StartAbsolute = Gui.AbsolutePosition

            EndConnection = Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End
                    or Input.UserInputState == Enum.UserInputState.Cancel then
                    FinishDrag()
                end
            end)
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if not Dragging or not Gui.Parent then return end
            if TouchInput then
                if Input ~= TouchInput then return end
            elseif Input.UserInputType ~= Enum.UserInputType.MouseMovement then
                return
            end

            local Delta = Vector2.new(Input.Position.X, Input.Position.Y) - DragStart
            if Delta.Magnitude < 0.5 then return end

            local Parent = Gui.Parent
            local Screen = Parent.AbsoluteSize
            local Size = Gui.AbsoluteSize
            -- Keep some of the window/title reachable even when dragged out
            -- of view. Clamp the pixel DELTA, never rebuild a new anchor point.
            local ParentOrigin = Parent:IsA("GuiObject") and Parent.AbsolutePosition or Vector2.zero
            local DesiredX = math.clamp(StartAbsolute.X + Delta.X,
                ParentOrigin.X - Size.X + 90, ParentOrigin.X + Screen.X - 90)
            local DesiredY = math.clamp(StartAbsolute.Y + Delta.Y,
                ParentOrigin.Y - Size.Y + 55, ParentOrigin.Y + Screen.Y - 44)

            local MoveX = DesiredX - StartAbsolute.X
            local MoveY = DesiredY - StartAbsolute.Y
            Gui.Position = UDim2.new(
                StartPosition.X.Scale, StartPosition.X.Offset + MoveX,
                StartPosition.Y.Scale, StartPosition.Y.Offset + MoveY
            )
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Dragging and not TouchInput
                and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                FinishDrag()
            end
        end)
    end

    -- Preserve the existing on-screen top-left immediately. A one-frame wait
    -- or an extra GuiInset produces a visible jump on ScreenGui IgnoreGuiInset.
    Library.ConvertAnchor = function(Self)
        if not Self.Instance then return end
        local Gui = Self.Instance
        if Gui.AnchorPoint == Vector2.zero then return end
        local Absolute = Gui.AbsolutePosition
        local Parent = Gui.Parent
        local Origin = Parent and Parent:IsA("GuiObject") and Parent.AbsolutePosition or Vector2.zero
        Gui.AnchorPoint = Vector2.zero
        Gui.Position = UDim2.fromOffset(
            Absolute.X - Origin.X,
            Absolute.Y - Origin.Y
        )
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance

        local Resizing = false
        local CurrentSide = nil

        local StartMouse = nil
        local StartPosition = nil
        local StartSize = nil

        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left",
                UDim2.new(0, 0, 0, 0),
                UDim2.new(0, EdgeThickness, 1, 0)),
                Side = "L"
            },

            {Button = MakeEdge(
                "Right",
                UDim2.new(1, -EdgeThickness, 0, 0),
                UDim2.new(0, EdgeThickness, 1, 0)),
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2.new(0, 0, 0, 0),
                UDim2.new(1, 0, 0, EdgeThickness)),
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom",
                UDim2.new(0, 0, 1, -EdgeThickness),
                UDim2.new(1, 0, 0, EdgeThickness)),
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true
            CurrentSide = Side

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false
            CurrentSide = nil

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then
                return
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local ScaleObject = Gui:FindFirstChild("UserScale")
            local ActiveScale = ScaleObject and ScaleObject.Scale or 1
            local dx = (MouseLocation.X - StartMouse.X) / ActiveScale
            local dy = (MouseLocation.Y - StartMouse.Y) / ActiveScale

            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end

            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end

            local ScreenSize = Gui.Parent.AbsoluteSize
            w = math.clamp(w, Minimum.X, math.max(Minimum.X, ScreenSize.X / ActiveScale))
            h = math.clamp(h, Minimum.Y, math.max(Minimum.Y, ScreenSize.Y / ActiveScale))
            x = math.clamp(x, 0, math.max(0, ScreenSize.X - w))
            y = math.clamp(y, 0, math.max(0, ScreenSize.Y - h))
            -- Resize directly instead of creating a new tween every frame.
            Gui.Position = UDim2.fromOffset(x, y)
            Gui.Size = UDim2.fromOffset(w, h)
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then
            return
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
        and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false, Result
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        Number = tonumber(Number) or 0
        Float = tonumber(Float)

        if not Float then
            return Number
        end

        local Multiplier = 10 ^ Float
        return math.floor(Number * Multiplier + 0.5) / Multiplier
    end

    Library.GetConfig = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do
                if Library.ConfigIgnore[Index] then
                    continue
                end

                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n" .. tostring(Result))
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local DecodeOk, Decoded = pcall(function()
            return HttpService:JSONDecode(Config)
        end)

        if not DecodeOk or type(Decoded) ~= "table" then
            return false, "invalid config: " .. tostring(Decoded)
        end

        local Order = { }

        for _, Key in Library.LoadFirst do
            if Decoded[Key] ~= nil then
                table.insert(Order, Key)
            end
        end

        for Key in Decoded do
            if not table.find(Library.LoadFirst, Key) then
                table.insert(Order, Key)
            end
        end

        local Failed = { }

        for _, Index in Order do
            local Value = Decoded[Index]
            local SetFunction = Library.SetFlags[Index]

            if SetFunction then
                local Ok, Err = pcall(function()
                    if type(Value) == "table" and Value.Key then
                        SetFunction(Value)
                    elseif type(Value) == "table" and Value.Color then
                        SetFunction(Value.Color, Value.Alpha)
                    else
                        SetFunction(Value)
                    end
                end)

                if not Ok then
                    table.insert(Failed, Index .. ": " .. tostring(Err))
                end
            end
        end

        if #Failed > 0 then
            return false, table.concat(Failed, "\n", 1, math.min(#Failed, 3))
        end

        return true
    end

    Library.GetConfigsList = function(Self, Element)
        local ReturnList = { }

        local Ok, List = pcall(listfiles, Library.Directory .. Library.Folders.Configs)

        if Ok and type(List) == "table" then
            for _, File in List do
                local Name = tostring(File):match("([^/\\]+)%.json$")

                if Name then
                    table.insert(ReturnList, Name)
                end
            end

            table.sort(ReturnList)
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if Library.Theme[Value] ~= nil then
                    Object[Property] = Library.Theme[Value]
                end
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemeMap[Object] then
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
    end

    Library.ThemeAnimation = true

    local ColorsClose = function(A, B)
        return typeof(A) == "Color3" and typeof(B) == "Color3"
            and math.abs(A.R - B.R) < 0.004 and math.abs(A.G - B.G) < 0.004 and math.abs(A.B - B.B) < 0.004
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        if Library.ThemeBulkUpdating then
            Library.Theme[Theme] = Color
            return
        end
        local Transition = Library.ThemeTransition

        -- the same color arrives again through the theming colorpickers: already handled
        if Transition and Transition[Theme] and ColorsClose(Transition[Theme], Color) then
            return
        end

        if Transition then
            Transition[Theme] = Color
        end

        Library.Theme[Theme] = Color

        local Info = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        for _, Item in Library.ThemingStuff do
            local Object = Item.Item

            for Property, Value in Item.Properties do
                local Target

                if type(Value) == "string" then
                    if Value == Theme then
                        Target = Color
                    end
                elseif type(Value) == "function" then
                    Target = Value()
                end

                if Target ~= nil then
                    if Transition and typeof(Target) == "Color3" and Object.Parent then
                        TweenService:Create(Object, Info, {[Property] = Target}):Play()
                    else
                        Object[Property] = Target
                    end
                end
            end
        end

        -- Live accent edits (including the theme colorpicker) must update glow.
        -- Notification card elements are already bound via AddToTheme.
        if Theme == "Accent" and Library.SetMenuGlow then
            Library:SetMenuGlow(Library.MenuGlowStrength or 35, Library.MenuGlowEnabled ~= false)
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then
            return
        end

        Library:Connect(Object.MouseEnter, function(...)
            local Shield = Library.PopupShield and Library.PopupShield.Instance
            if Shield and Shield.Visible then
                local Allowed = false
                for _, Data in Library.OpenFrames do
                    if Data.Modal and Data.PopupInstance and Object:IsDescendantOf(Data.PopupInstance) then
                        Allowed = true
                        break
                    end
                end
                if not Allowed then return end
            end
            if OnHoverEnter then OnHoverEnter(...) end
        end)
        Library:Connect(Object.MouseLeave, function(...)
            if OnHoverLeave then OnHoverLeave(...) end
        end)
    end

    Library.IsMouseOverItems = function(Self, Items)
        for _, Item in Items do
            if Item and Item:IsMouseOverFrame() then
                return true
            end
        end

        return false
    end

    Library.RegisterOpenFrameTrigger = function(Self, Trigger)
        Library.OpenFrameTriggers[Trigger] = true
    end

    Library.IsMouseOverAnyOpenFrameTrigger = function(Self)
        for Trigger in Library.OpenFrameTriggers do
            if Trigger:IsMouseOverFrame() then
                return true
            end
        end

        return false
    end

    Library.IsMouseOverOpenFrameData = function(Self, Data)
        if Self:IsMouseOverItems(Data.HoverItems) then
            return true
        end

        if Data.GetHoverItems then
            return Self:IsMouseOverItems(Data.GetHoverItems())
        end

        return false
    end

    Library.ShouldKeepOpenFrame = function(Self, Frame)
        local Data = Library.OpenFrames[Frame]

        if not Data then
            return false
        end

        if Self:IsMouseOverOpenFrameData(Data) then
            return true
        end

        for ChildFrame, ChildData in Library.OpenFrames do
            if ChildData.Owner == Frame and ChildFrame.IsOpen and Self:ShouldKeepOpenFrame(ChildFrame) then
                return true
            end
        end

        return false
    end

    -- v18: shared modal hit shield. A popup must intercept input behind itself,
    -- not just draw over other controls. This covers Options, Colorpicker and Keybind.
    -- Embedded dropdown lists are intentionally NOT modal.
    Library.PopupLayerOriginal = setmetatable({}, {__mode = "k"})
    Library.PopupOrder = 0

    Library.RefreshPopupLayer = function(Self)
        local ModalFrames = {}
        for Frame, Data in Library.OpenFrames do
            if Frame.IsOpen and Data.Modal and Data.PopupInstance and Data.PopupInstance.Parent == Library.Holder.Instance then
                table.insert(ModalFrames, {Frame = Frame, Data = Data})
            end
        end
        table.sort(ModalFrames, function(A, B)
            return (A.Data.PopupOrder or 0) < (B.Data.PopupOrder or 0)
        end)
        local Shield = Library.PopupShield and Library.PopupShield.Instance
        if Shield then
            if #ModalFrames > 0 and not Shield.Visible and Library.HideTooltip then
                Library:HideTooltip()
            end
            Shield.Visible = #ModalFrames > 0
        end
        for Order, Entry in ModalFrames do
            local Popup = Entry.Data.PopupInstance
            local Base = 100 + (Order - 1) * 30
            local function Front(Object)
                if not Object:IsA("GuiObject") then return end
                if Library.PopupLayerOriginal[Object] == nil then
                    Library.PopupLayerOriginal[Object] = Object.ZIndex
                end
                -- Preserve the relative layer order of text, backgrounds, and arrows.
                Object.ZIndex = Base + math.clamp(Library.PopupLayerOriginal[Object], 0, 25)
            end
            Front(Popup)
            for _, Descendant in Popup:GetDescendants() do Front(Descendant) end
        end
    end


    Library.RegisterOpenFrame = function(Self, Frame, Data)
        local Owner = Data.Owner

        if Owner == nil and Data.AnchorInstance then
            Owner = Self:FindOpenFrameOwner(Data.AnchorInstance)
        end

        Data.Owner = Owner
        Data.Modal = Data.PopupInstance ~= nil and Data.PopupInstance.Parent == Library.Holder.Instance
        if Data.Modal then
            Library.PopupOrder += 1
            Data.PopupOrder = Library.PopupOrder
        end

        if Owner then
            Self:CloseOpenFramesExcept(Frame, Owner)
        else
            Self:CloseOpenFramesExcept(Frame)
        end

        Library.OpenFrames[Frame] = Data
        Library:EnsureOpenFramesConnection()
        Library:RefreshPopupLayer()
    end

    Library.UnregisterOpenFrame = function(Self, Frame)
        Library.OpenFrames[Frame] = nil
        Library:RefreshPopupLayer()
    end

    Library.FindOpenFrameOwner = function(Self, Instance)
        if not Instance then
            return nil
        end

        for Frame, Data in Library.OpenFrames do
            if Frame.IsOpen and Data.PopupInstance then
                if Instance:IsDescendantOf(Data.PopupInstance) or Instance == Data.PopupInstance then
                    return Frame
                end
            end
        end

        return nil
    end

    Library.CloseOpenFramesExcept = function(Self, KeepFrame, KeepOwner)
        for Frame, Data in Library.OpenFrames do
            if Frame == KeepFrame or Frame == KeepOwner then
                continue
            end

            if Frame.IsOpen then
                Frame:SetOpen(false)
            end
        end
    end

    Library.CloseOpenFrameChildren = function(Self, Parent)
        for Frame, Data in Library.OpenFrames do
            if Data.Owner == Parent and Frame.IsOpen then
                Frame:SetOpen(false)
            end
        end
    end

    Library.SetOpenFrameInteracting = function(Self, Bool)
        Library.OpenFrameInteracting = Bool
    end

    Library.ProcessOpenFrames = function(Self)
        if Library.OpenFrameInteracting then
            return
        end

        if Self:IsMouseOverAnyOpenFrameTrigger() then
            return
        end

        local ToClose = { }

        for Frame, Data in Library.OpenFrames do
            if Frame.IsOpen and not Frame.Picking and not Self:ShouldKeepOpenFrame(Frame) then
                table.insert(ToClose, Frame)
            end
        end

        for _, Frame in ToClose do
            Frame:SetOpen(false)
        end
    end

    Library.EnsureOpenFramesConnection = function(Self)
        if Library.OpenFramesInputConnection then
            return
        end

        Library.OpenFramesInputConnection = Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            task.defer(function()
                Library:ProcessOpenFrames()
            end)
        end)
    end

    Library.VisibleCheck = function(Self)
        local Object = Self.Instance

        if not Object then
            return
        end

        local OriginalParent = Object.Parent

        Library:Connect(Object:GetPropertyChangedSignal("Visible"), function()
            local IsVisible = Object.Visible
            Object.Parent = IsVisible and OriginalParent or Library.UnusedHolder.Instance
        end)
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.PopupShield = Library:Create("TextButton", {
        Parent = Library.Holder.Instance, Name = "MimisensePopupInputShield",
        Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Text = "", AutoButtonColor = false, Visible = false, ZIndex = 70
    })
    Library.PopupShield:Connect("MouseButton1Down", function()
        Library:CloseOpenFramesExcept(nil)
        Library:RefreshPopupLayer()
    end)

    Library.UIClickSound = Instance.new("Sound")
    Library.UIClickSound.Name = "UIClickSound"
    Library.UIClickSound.SoundId = Library.UIClickSoundId
    Library.UIClickSound.Volume = Library.UIClickVolume or 0.65
    Library.UIClickSound.Parent = SoundService

    Library.MascotClickSound = Instance.new("Sound")
    Library.MascotClickSound.Name = "MascotClickSound"
    Library.MascotClickSound.SoundId = Library.MascotClickSoundId
    Library.MascotClickSound.Volume = Library.MascotClickVolume or 0.8
    Library.MascotClickSound.Parent = SoundService

    Library:Connect(UserInputService.InputBegan, function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

        local WindowObject = Library.ActiveWindow
        local MainFrame = WindowObject and WindowObject.Items and WindowObject.Items.MainFrame and WindowObject.Items.MainFrame.Instance

        if not WindowObject or not WindowObject.IsOpen or not MainFrame or not MainFrame.Visible then return end

        local Position = Input.Position
        local InMainFrame = Position.X >= MainFrame.AbsolutePosition.X
            and Position.X <= MainFrame.AbsolutePosition.X + MainFrame.AbsoluteSize.X
            and Position.Y >= MainFrame.AbsolutePosition.Y
            and Position.Y <= MainFrame.AbsolutePosition.Y + MainFrame.AbsoluteSize.Y

        local InPopup = false
        local Ok, GuiObjects = pcall(function()
            return GuiService:GetGuiObjectsAtPosition(Position.X, Position.Y)
        end)

        if Ok and GuiObjects then
            for _, GuiObject in GuiObjects do
                if GuiObject:IsDescendantOf(Library.Holder.Instance) then
                    InPopup = true
                    break
                end
            end
        end

        local OnMascot = false
        if WindowObject and WindowObject.Mascot and WindowObject.Mascot.Items and WindowObject.Mascot.Items.Image then
            local MascotImage = WindowObject.Mascot.Items.Image.Instance
            if MascotImage.Visible then
                OnMascot = Position.X >= MascotImage.AbsolutePosition.X
                    and Position.X <= MascotImage.AbsolutePosition.X + MascotImage.AbsoluteSize.X
                    and Position.Y >= MascotImage.AbsolutePosition.Y
                    and Position.Y <= MascotImage.AbsolutePosition.Y + MascotImage.AbsoluteSize.Y
            end
        end

        if (InMainFrame or InPopup) and not OnMascot then
            Library:PlayUIClickSound()
        end
    end)

    Library.NotifHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        DisplayOrder = 999999999,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.NotificationStack = Library:Create("Frame", {
        Name = "MimisenseNotificationStack", Parent = Library.NotifHolder.Instance,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 14 + GuiInset),
        Size = UDim2.new(0, 308, 1, -28 - GuiInset), ClipsDescendants = false
    })
    Library:Create("UIListLayout", {
        Parent = Library.NotificationStack.Instance, Name = "\0",
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,
                Mini = Data.Mini == true,
                ClipboardEnabled = Data.Clipboard ~= false and Data.clipboard ~= false,

                Pages = { },
                Current = nil,

                Items = { }
            }

            local Items = { } do
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                }
                })

                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 996, 0, 92),
                    Size = UDim2.new(0, 250, 0, 300),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Size = UDim2.new(1, 0, 0, 34),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })

                -- Tabs are intentionally removed from colorpickers.
                -- Keep an invisible Pages container only for backwards compatibility.
                Items["Pages"] = Library:Create("Frame", {
                    Name = "",
                    Parent = Items["Top"].Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0
                })

                Library:Create("Frame", {
                    Name = "",
                    Parent = Items["Top"].Instance,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    BorderSizePixel = 0
                })

                -- header: option name + preview chip
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = tostring(Data.Name or Data.name or Data.Flag or "Color"),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 12, 0.5, 0),
                    Size = UDim2.new(1, -60, 0, 18),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BorderSizePixel = 0
                }):AddToTheme({TextColor3 = "Text"})

                Items["Preview"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 24, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                Library:Create("UICorner", {Name = "\0", Parent = Items["Preview"].Instance, CornerRadius = UDim.new(0, 4)})
                Library:Create("UIStroke", {Name = "\0", Parent = Items["Preview"].Instance, Color = Library.Theme["Outline"], ApplyStrokeMode = Enum.ApplyStrokeMode.Border}):AddToTheme({Color = "Outline"})

                local StyleBox = function(Object)
                    Library:Create("UICorner", {Name = "\0", Parent = Object.Instance, CornerRadius = UDim.new(0, 5)})
                    Library:Create("UIStroke", {Name = "\0", Parent = Object.Instance, Color = Library.Theme["Outline"], ApplyStrokeMode = Enum.ApplyStrokeMode.Border}):AddToTheme({Color = "Outline"})
                end

                local MakeInput = function(Name, Right, Y, Placeholder)
                    Items[Name] = Library:Create("TextBox", {
                        Name = "\0",
                        Parent = Items["Content"].Instance,
                        AnchorPoint = Vector2.new(Right and 1 or 0, 0),
                        Position = UDim2.new(Right and 1 or 0, Right and -10 or 10, 0, Y),
                        Size = UDim2.new(0.5, -15, 0, 26),
                        BackgroundColor3 = Library.Theme["Tab"],
                        BorderSizePixel = 0,
                        TextColor3 = Library.Theme["Text"],
                        PlaceholderColor3 = Library.Theme["Inactive Text"],
                        PlaceholderText = Placeholder,
                        Text = "",
                        ClearTextOnFocus = false,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        FontFace = Library.Font,
                        TextSize = Library.FontSize
                    }):AddToTheme({BackgroundColor3 = "Tab", TextColor3 = "Text", PlaceholderColor3 = "Inactive Text"})

                    StyleBox(Items[Name])
                end

                MakeInput("HexInput", false, 172, "#RRGGBB")
                MakeInput("RgbInput", true, 172, "R, G, B")

                if Colorpicker.ClipboardEnabled then
                    local MakeButton = function(Name, Text, Right)
                        Items[Name] = Library:Create("TextButton", {
                            Name = "\0",
                            Parent = Items["Content"].Instance,
                            AnchorPoint = Vector2.new(Right and 1 or 0, 0),
                            Position = UDim2.new(Right and 1 or 0, Right and -10 or 10, 0, 204),
                            Size = UDim2.new(0.5, -15, 0, 26),
                            BackgroundColor3 = Library.Theme["Tab"],
                            BorderSizePixel = 0,
                            AutoButtonColor = false,
                            TextColor3 = Library.Theme["Inactive Text"],
                            Text = Text,
                            FontFace = Library.Font,
                            TextSize = Library.FontSize
                        }):AddToTheme({BackgroundColor3 = "Tab", TextColor3 = "Inactive Text"})

                        StyleBox(Items[Name])
                    end

                    MakeButton("Copy", "Copy color", false)
                    MakeButton("Paste", "Paste color", true)
                end

                Items["Footer"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Position = UDim2.new(0, 10, 0, 238),
                    Size = UDim2.new(1, -20, 0, 18),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1
                }):AddToTheme({TextColor3 = "Inactive Text"})

                                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Items["ColorpickerButton"]:Tween({BackgroundColor3 = Colorpicker.Color})
                Colorpicker:UpdateReadouts()

                if Items["Palette"] then
                    Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})
                end

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Transparency = 1 - Colorpicker.Alpha
                }

                if not IsFromAlpha and Items["Alpha"] then
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            local IsSettings = Data.IsSettings or Data.Mini or (Data.Section and Data.Section.IsSettings)

            local function ParseClipboardColor(Text)
                if type(Text) ~= "string" then
                    return nil
                end

                Text = Text:gsub("^%s+", ""):gsub("%s+$", "")

                local Hex = Text:match("^#?(%x%x%x%x%x%x)$") or Text:match("^#?(%x%x%x%x%x%x)%x%x$")
                if Hex then
                    return Color3.fromRGB(tonumber(Hex:sub(1, 2), 16), tonumber(Hex:sub(3, 4), 16), tonumber(Hex:sub(5, 6), 16))
                end

                local H1, H2, H3 = Text:match("^#(%x)(%x)(%x)$")
                if H1 then
                    return Color3.fromRGB(tonumber(H1 .. H1, 16), tonumber(H2 .. H2, 16), tonumber(H3 .. H3, 16))
                end

                local R, G, B = Text:match("^[Rr][Gg][Bb][Aa]?%s*%(%s*(%d+)%s*[,%s]%s*(%d+)%s*[,%s]%s*(%d+)")
                if not R then
                    R, G, B = Text:match("^(%d+)[%s,]+(%d+)[%s,]+(%d+)$")
                end

                if R and G and B then
                    return Color3.fromRGB(math.clamp(tonumber(R), 0, 255), math.clamp(tonumber(G), 0, 255), math.clamp(tonumber(B), 0, 255))
                end

                return nil
            end

            local function RGBOf(Color)
                return math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5)
            end

            -- hex box, rgb box, footer and preview chip follow the color
            function Colorpicker:UpdateReadouts()
                local Color = Colorpicker.Color
                local R, G, B = RGBOf(Color)
                local Hex = "#" .. string.lower(Color:ToHex())

                if Items["HexInput"] and not Items["HexInput"].Instance:IsFocused() then
                    Items["HexInput"].Instance.Text = Hex
                end

                if Items["RgbInput"] and not Items["RgbInput"].Instance:IsFocused() then
                    Items["RgbInput"].Instance.Text = string.format("%d, %d, %d", R, G, B)
                end

                if Items["Footer"] then
                    Items["Footer"].Instance.Text = string.format("%s  \194\183  %d, %d, %d", Hex, R, G, B)
                end

                if Items["Preview"] then
                    Items["Preview"].Instance.BackgroundColor3 = Color
                end
            end

            function Colorpicker:Copy()
                local Text = "#" .. string.upper(Colorpicker.Color:ToHex())
                local Ok, Wrote = Library:CopyText(Text)

                Library:Notification({
                    Name = "Color copied",
                    Description = Wrote and (Text .. " copied.") or (Text .. " copied inside the menu (no system clipboard).")
                })

                if Items["Copy"] then
                    Items["Copy"].Instance.Text = "Copied!"
                    task.delay(1, function()
                        if Items["Copy"].Instance.Parent then
                            Items["Copy"].Instance.Text = "Copy color"
                        end
                    end)
                end

                return true
            end

            function Colorpicker:Paste()
                local Text = Library:PasteText()
                local Color = Text and ParseClipboardColor(tostring(Text))

                if not Color then
                    Library:Notification({Name = "Color paste", Description = "Clipboard has no valid color.", Type = "Warning", Duration = 2.5})
                    return false
                end

                Colorpicker:Set(Color, Colorpicker.Alpha)
                Library:Notification({Name = "Color pasted", Description = "#" .. string.upper(Color:ToHex()), Duration = 2})
                return true
            end

            for _, Name in {"Copy", "Paste"} do
                local Button = Items[Name]

                if Button then
                    Button:OnHover(function()
                        Button:Tween({BackgroundColor3 = Library.Theme["Hovered Element"], TextColor3 = Library.Theme.Text})
                    end, function()
                        Button:Tween({BackgroundColor3 = Library.Theme.Tab, TextColor3 = Library.Theme["Inactive Text"]})
                    end)

                    -- one signal only, Click works for mouse and touch
                    Button:Connect("MouseButton1Click", function()
                        if Name == "Copy" then
                            Colorpicker:Copy()
                        else
                            Colorpicker:Paste()
                        end
                    end)
                end
            end

            if Items["HexInput"] then
                Items["HexInput"]:Connect("FocusLost", function()
                    local Color = ParseClipboardColor(tostring(Items["HexInput"].Instance.Text or ""))

                    if Color then
                        Colorpicker:Set(Color, Colorpicker.Alpha)
                    end

                    Colorpicker:UpdateReadouts()
                end)
            end

            if Items["RgbInput"] then
                Items["RgbInput"]:Connect("FocusLost", function()
                    local Color = ParseClipboardColor(tostring(Items["RgbInput"].Instance.Text or ""))

                    if Color then
                        Colorpicker:Set(Color, Colorpicker.Alpha)
                    end

                    Colorpicker:UpdateReadouts()
                end)
            end

            function Colorpicker:SetOpen(Bool)
                Bool = Bool and true or false
                if Bool and Library.ActiveColorpicker and Library.ActiveColorpicker ~= Colorpicker then
                    local Previous = Library.ActiveColorpicker
                    Library.ActiveColorpicker = nil
                    -- Close old picker before the next one becomes visible.
                    Previous:SetOpen(false)
                    Previous.IsOpen = false
                    Library:UnregisterOpenFrame(Previous)
                    Library:CloseOpenFrameChildren(Previous)
                    if Previous.Items and Previous.Items.ColorpickerWindow then
                        local OldWindow = Previous.Items.ColorpickerWindow.Instance
                        if OldWindow then
                            OldWindow.Visible = false
                            OldWindow.Parent = Library.UnusedHolder.Instance
                        end
                    end
                end
                if Debounce and Bool then return end
                if Colorpicker.IsOpen == Bool then return end
                if Bool then Library.ActiveColorpicker = Colorpicker
                elseif Library.ActiveColorpicker == Colorpicker then Library.ActiveColorpicker = nil end
                Colorpicker.IsOpen = Bool

                Debounce = true

                if Colorpicker.IsOpen then
                    local Screen = Library.Holder.Instance.AbsoluteSize
                    local X = math.clamp(ColorpickerButton.AbsolutePosition.X, 8,
                        math.max(8, Screen.X - ColorpickerWindow.AbsoluteSize.X - 8))
                    local Height = math.max(300, ColorpickerWindow.AbsoluteSize.Y)
                    local Y = ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 4
                    if Y + Height > Screen.Y - 8 then
                        Y = ColorpickerButton.AbsolutePosition.Y - Height - 4
                    end
                    Y = math.clamp(Y, 8, math.max(8, Screen.Y - Height - 8))
                    ColorpickerWindow.Position = UDim2.fromOffset(X, Y - 6)

                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.fromOffset(X, Y)})

                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    Library:RegisterOpenFrame(Colorpicker, {
                        HoverItems = { Items["ColorpickerWindow"], Items["ColorpickerButton"] },
                        AnchorInstance = ColorpickerButton,
                        PopupInstance = ColorpickerWindow,
                    })
                else
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        ColorpickerWindow.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    Library:CloseOpenFrameChildren(Colorpicker)
                    Library:UnregisterOpenFrame(Colorpicker)
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
                if Library.RefreshPopupLayer then Library:RefreshPopupLayer() end
            end

            Items["ColorpickerWindow"]:VisibleCheck()

            local SlidingPalette = false
            local PaletteChanged
            local SlidingHue = false
            local HueChanged
            local SlidingAlpha = false
            local AlphaChanged

            local Fraction = function(Value, Size)
                return math.clamp(Value / math.max(Size, 1), 0, 1)
            end

            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local Palette = Items["Palette"].Instance
                local X = Fraction(Input.Position.X - Palette.AbsolutePosition.X, Palette.AbsoluteSize.X)
                local Y = Fraction(Input.Position.Y - Palette.AbsolutePosition.Y, Palette.AbsoluteSize.Y)

                Colorpicker.Saturation = X
                Colorpicker.Value = 1 - Y

                Items["PaletteDragger"].Instance.Position = UDim2.new(X, 0, Y, 0)
                Colorpicker:Update()
            end

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end

                local Bar = Items["Hue"].Instance
                local Y = Fraction(Input.Position.Y - Bar.AbsolutePosition.Y, Bar.AbsoluteSize.Y)

                Colorpicker.Hue = Y
                Items["HueDragger"].Instance.Position = UDim2.new(0.5, 0, Y, 0)
                Colorpicker:Update()
            end

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local Bar = Items["Alpha"].Instance
                local Y = Fraction(Input.Position.Y - Bar.AbsolutePosition.Y, Bar.AbsoluteSize.Y)

                Colorpicker.Alpha = Y
                Items["AlphaDragger"].Instance.Position = UDim2.new(0.5, 0, Y, 0)
                Colorpicker:Update(true)
            end

            function Colorpicker:Set(Color, Alpha, FromAnimation)
                if type(Color) == "table" then
                    if Color.Color ~= nil then
                        Alpha = Alpha or Color.Alpha
                        Color = Color.Color
                    else
                        Color = Color3.fromRGB(Color[1] or 255, Color[2] or 255, Color[3] or 255)
                    end
                end

                if type(Color) == "string" then
                    Color = ParseClipboardColor(Color)
                end

                if typeof(Color) ~= "Color3" then
                    return false
                end

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0

                local Info = FromAnimation and TweenInfo.new(0.08, Enum.EasingStyle.Linear) or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                if Items["PaletteDragger"] then
                    Items["PaletteDragger"]:Tween({Position = UDim2.new(Colorpicker.Saturation, 0, 1 - Colorpicker.Value, 0)}, Info)
                end

                if Items["HueDragger"] then
                    Items["HueDragger"]:Tween({Position = UDim2.new(0.5, 0, Colorpicker.Hue, 0)}, Info)
                end

                if Items["AlphaDragger"] then
                    Items["AlphaDragger"]:Tween({Position = UDim2.new(0.5, 0, Colorpicker.Alpha, 0)}, Info)
                end

                if FromAnimation then
                    Colorpicker.Color = Color
                    Colorpicker.HexValue = Colorpicker.Color:ToHex()
                    Items["ColorpickerButton"].Instance.BackgroundColor3 = Colorpicker.Color
                    Colorpicker:UpdateReadouts()

                    if Items["Palette"] then
                        Items["Palette"].Instance.BackgroundColor3 = Color3.fromHSV(Colorpicker.Hue, 1, 1)
                    end

                    if Items["Alpha"] then
                        Items["Alpha"].Instance.BackgroundColor3 = Colorpicker.Color
                    end

                    Flags[Colorpicker.Flag] = {
                        Alpha = Colorpicker.Alpha,
                        Color = Colorpicker.Color,
                        HexValue = Colorpicker.HexValue,
                        Transparency = 1 - Colorpicker.Alpha
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                    end

                    return true
                end

                Colorpicker:Update()
                return true
            end

                        function Colorpicker:Page(Params)
                Params = Params or { }

                local Page = {
                    Name = Params.Name or Params.name or "Page",
                    Icon = Params.Icon or Params.icon or "",

                    Colorpicker = Colorpicker,
                    Items = { },
                    Active = false,
                    Debounce = false
                }

                local PageItems = { } do
                    PageItems["Inactive"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Colorpicker.Items["Pages"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 35, 0, 35),
                        BorderSizePixel = 0,
                        ClipsDescendants = true,
                        LayoutOrder = #Colorpicker.Pages + 1,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = Library.Theme["Tab"]
                    }):AddToTheme({BackgroundColor3 = 'Tab'})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = PageItems["Inactive"].Instance
                    })

                    PageItems["Icon"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = PageItems["Inactive"].Instance,
                        ImageColor3 = Library.Theme["Inactive Text"],
                        AnchorPoint = Vector2.new(0, 0.5),
                        Image = "",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0.5, 1),
                        Size = UDim2.new(0, 20, 0, 20),
                        BorderSizePixel = 0
                    }):AddToTheme({ImageColor3 = 'Inactive Text'})
                    Library:ApplyIcon(PageItems["Icon"].Instance, Page.Icon)

PageItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize + 2,
                        Parent = PageItems["Inactive"].Instance,
                        Visible = true,
                        TextTransparency = 1,
                        AnchorPoint = Vector2.new(0, 0.5),
                        TextColor3 = Library.Theme["Text"],
                        Text = Page.Name,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 30, 0.5, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Text'})

                    Library:Create("UIPadding", {
                        Name = "\0",
                        Parent = PageItems["Inactive"].Instance,
                        PaddingRight = UDim.new(0, 8),
                        PaddingLeft = UDim.new(0, 8)
                    })

                    PageItems["Page"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Library.UnusedHolder.Instance,
                        BackgroundTransparency = 1,
                        Visible = false,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0
                    })

                    Page.Items = PageItems
                end

local GetSize = function()
    PageItems["Inactive"].Instance.Size = UDim2.new(0, 35, 0, 35)
    PageItems["Inactive"].Instance.AutomaticSize = Enum.AutomaticSize.None

    local TextWidth = PageItems["Text"].Instance.TextBounds.X
    if TextWidth <= 0 then
        TextWidth = #(Page.Name) * ((Library.FontSize + 2) * 0.55)
    end

    return Vector2.new(math.max(35, math.ceil(65 + TextWidth)), 35)
end

                PageItems["Inactive"]:OnHover(function()
                    if Page.Active then return end

                    PageItems["Icon"]:Tween({ImageColor3 = Library.Theme.Text})
                    PageItems["Inactive"]:Tween({BackgroundTransparency = 0})
                end, function()
                    if Page.Active then return end

                    PageItems["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})
                    PageItems["Inactive"]:Tween({BackgroundTransparency = 1})
                end)

                local Size = GetSize()
                local X = Size.X

function Page:Turn()
    local Old = Colorpicker.Current

    if Old == Page then
        return
    end

    if Page.Debounce then
        return
    end

    if Old and Old.Debounce then
        return
    end

    Page.Debounce = true

    if Old then
        Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Inactive Text"})
        Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})

        Old.Items["Inactive"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 35, 0, 35)})
        Old.Items["Text"]:Tween({TextTransparency = 1})

        Old.Items["Page"].Instance.Visible = false
        Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
        Old.Active = false
        Old.Debounce = false
    end

    PageItems["Page"].Instance.Parent = Colorpicker.Items["Content"].Instance
    PageItems["Page"].Instance.Visible = true

    local PageZIndex = Colorpicker.IsOpen and (IsSettings and Library.ZIndexOrder.ColorpickerWindow + 4 or Library.ZIndexOrder.ColorpickerWindow) or 1
    local PageDescendants = PageItems["Page"].Instance:GetDescendants()
    table.insert(PageDescendants, PageItems["Page"].Instance)

    for _, Value in PageDescendants do
        if Value.ClassName:find("UI") then
            continue
        end

        Value.ZIndex = PageZIndex
    end

    PageItems["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
    PageItems["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})

    PageItems["Inactive"].Instance.BackgroundTransparency = 0
    PageItems["Text"].Instance.TextTransparency = 0

    local Size = GetSize()

    PageItems["Inactive"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(0, Size.X, 0, 35)})
    PageItems["Text"]:Tween({TextTransparency = 0})

    Colorpicker.Current = Page
    Page.Active = true
    Page.Debounce = false
end

                PageItems["Inactive"]:Connect("MouseButton1Down", function()
                    Page:Turn()
                end)

                table.insert(Colorpicker.Pages, Page)
                return Page
            end

            do -- Color content (no tabs)
                if Colorpicker.Mini then
                    Items["Top"].Instance.Visible = false
                    Items["Content"].Instance.Position = UDim2.new(0, 0, 0, 0)
                    Items["Content"].Instance.Size = UDim2.new(1, 0, 1, 0)
                end

                Items["Color"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 170),
                    BorderSizePixel = 0
                })

                local Round = function(Object, Radius)
                    Library:Create("UICorner", {Name = "\0", Parent = Object.Instance, CornerRadius = UDim.new(0, Radius)})
                end

                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["Color"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -60, 0, 150),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                })
                Round(Items["Palette"], 6)

                -- white on the left, pure hue on the right
                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
                })
                Round(Items["Saturation"], 6)

                -- transparent on top, black at the bottom
                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                })
                Round(Items["Value"], 6)

                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                })
                Round(Items["PaletteDragger"], 6)

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    Thickness = 2,
                    Color = Color3.fromRGB(255, 255, 255)
                })

                local MakeBar = function(Name, Offset)
                    Items[Name] = Library:Create("TextButton", {
                        Name = "\0",
                        Parent = Items["Color"].Instance,
                        Text = "",
                        AutoButtonColor = false,
                        AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.new(1, Offset, 0, 10),
                        Size = UDim2.new(0, 14, 0, 150),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    })
                    Round(Items[Name], 5)
                end

                local MakeBarDragger = function(Name, Parent)
                    Items[Name] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Parent.Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0, 0),
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 4, 0, 6),
                        BorderSizePixel = 0,
                        ZIndex = 3,
                        Active = true
                    })
                    Round(Items[Name], 3)

                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = Items[Name].Instance,
                        Thickness = 2,
                        Color = Color3.fromRGB(255, 255, 255)
                    })
                end

                MakeBar("Hue", -30)

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }
                })

                MakeBarDragger("HueDragger", Items["Hue"])

                MakeBar("Alpha", -10)

                Items["Checkers"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 6, 0, 6),
                    Image = "http://www.roblox.com/asset/?id=18274452449",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 1,
                    Active = false,
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Checkers"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.37, 0.5),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })
                Round(Items["Checkers"], 5)

                MakeBarDragger("AlphaDragger", Items["Alpha"])
            end

                        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Library:RegisterOpenFrameTrigger(Items["ColorpickerButton"])

            if Items["Palette"] then
                Items["Palette"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Library:SetOpenFrameInteracting(true)
                        SlidingPalette = true

                        Colorpicker:SlidePalette(Input)

                        if PaletteChanged then
                            return
                        end

                        PaletteChanged = Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                SlidingPalette = false
                                Library:SetOpenFrameInteracting(false)

                                PaletteChanged:Disconnect()
                                PaletteChanged = nil
                            end
                        end)
                    end
                end)
            end

            if Items["Hue"] then
                Items["Hue"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Library:SetOpenFrameInteracting(true)
                        SlidingHue = true

                        Colorpicker:SlideHue(Input)

                        if HueChanged then
                            return
                        end

                        HueChanged = Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                SlidingHue = false
                                Library:SetOpenFrameInteracting(false)

                                HueChanged:Disconnect()
                                HueChanged = nil
                            end
                        end)
                    end
                end)
            end

            if Items["Alpha"] then
                local BeginAlphaSlide = function(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    Library:SetOpenFrameInteracting(true)
                    SlidingAlpha = true
                    Colorpicker:SlideAlpha(Input)

                    if AlphaChanged then
                        return
                    end

                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false
                            Library:SetOpenFrameInteracting(false)

                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end

                Items["Alpha"]:Connect("InputBegan", BeginAlphaSlide)

                if Items["Checkers"] then
                    Items["Checkers"]:Connect("InputBegan", BeginAlphaSlide)
                end

                if Items["AlphaDragger"] then
                    Items["AlphaDragger"]:Connect("InputBegan", BeginAlphaSlide)
                end
            end

            if Items["Alpha"] and Items["Palette"] and Items["Hue"] then
                Library:Connect(UserInputService.InputChanged, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        if SlidingPalette then
                            Colorpicker:SlidePalette(Input)
                        elseif SlidingHue then
                            Colorpicker:SlideHue(Input)
                        elseif SlidingAlpha then
                            Colorpicker:SlideAlpha(Input)
                        end
                    end
                end)
            end

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            else
                Colorpicker:Update()
            end

            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items
        end

        Library.CreateKeybind = function(Self, Data)
            local AllModes = { "Always", "Toggle", "Hold", "Remove" }

            -- compact mouse names, like "MB2"
            Keys["MouseButton1"] = Keys["MouseButton1"] or "MB1"
            Keys["MouseButton2"] = Keys["MouseButton2"] or "MB2"
            Keys["MouseButton3"] = Keys["MouseButton3"] or "MB3"

            local function Capitalize(Text)
                if type(Text) ~= "string" or Text == "" then
                    return nil
                end

                return Text:sub(1, 1):upper() .. Text:sub(2):lower()
            end

            -- Modes = { "Always", "Toggle", "Hold", "Remove" } - which entries the middle-click menu shows
            local function NormalizeModes(List)
                local Picked = { }

                if type(List) == "table" then
                    for _, Name in List do
                        local Fixed = Capitalize(Name)

                        if Fixed then
                            Picked[Fixed] = true
                        end
                    end
                end

                local Result = { }

                for _, Name in AllModes do
                    if Picked[Name] then
                        table.insert(Result, Name)
                    end
                end

                if #Result == 0 then
                    Result = table.clone(AllModes)
                end

                -- there must be at least one real mode, "Remove" alone is not a mode
                if not (table.find(Result, "Always") or table.find(Result, "Toggle") or table.find(Result, "Hold")) then
                    table.insert(Result, 1, "Toggle")
                end

                return Result
            end

            local function PickMode(Modes, Wanted)
                Wanted = Capitalize(Wanted)

                if Wanted and Wanted ~= "Remove" and table.find(Modes, Wanted) then
                    return Wanted
                end

                if table.find(Modes, "Toggle") then
                    return "Toggle"
                end

                for _, Name in Modes do
                    if Name ~= "Remove" then
                        return Name
                    end
                end

                return "Toggle"
            end

            local Keybind = {
                Name = Data.Name or "Keybind",
                Flag = Data.Flag or ("Keybind/" .. tostring(Data.Name or "Keybind")),
                IsOpen = false,

                Modes = NormalizeModes(Data.Modes or Data.modes),
                DefaultMode = "Toggle",

                Key = "None",
                Mode = "",
                Value = "None",

                Toggled = false,
                Picking = false,
                Ready = false,
                PressedInputs = {},
                DefaultKey = Data.Default,

                Items = { },
            }

            Keybind.DefaultMode = PickMode(Keybind.Modes, Data.Mode or Data.mode)

            local Items = { } do
                -- key button: outlined, rounded like the other small elements (toggle box / colorpicker swatch)
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "None",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 0, 16),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = "Background", TextColor3 = "Inactive Text"})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["KeyStroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    PaddingLeft = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6)
                })

                Library:Create("UISizeConstraint", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    MinSize = Vector2.new(24, 16)
                })

                -- mode menu (middle / right click)
                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Size = UDim2.new(0, 88, 0, 0),
                    Position = UDim2.new(0, 1004, 0, 121),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = "Inline"})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Keybind.Items = Items
            end

            local ListItem

            if Library.KeyList then
                ListItem = Library.KeyList:Add(Keybind.Name, "None")
            end

            local Debounce = false
            local Hovering = false
            local LastPicked = 0
            local FollowConnection
            local Rows = { }

            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings
            local MainWindow = Data.Section and Data.Section.Window

            local DangerColor = Color3.fromRGB(255, 95, 95)

            local function RefreshButton()
                local Active = Hovering or Keybind.IsOpen

                local Background = Active and "Hovered Element" or "Background"
                local Text = Keybind.Picking and "Accent" or (Active and "Text" or "Inactive Text")
                local Stroke = (Keybind.Picking or Keybind.IsOpen) and "Accent" or "Outline"

                Items["KeyButton"]:ChangeItemTheme({BackgroundColor3 = Background, TextColor3 = Text})
                Items["KeyButton"]:Tween({
                    BackgroundColor3 = Library.Theme[Background],
                    TextColor3 = Library.Theme[Text]
                })

                Items["KeyStroke"]:ChangeItemTheme({Color = Stroke})
                Items["KeyStroke"]:Tween({Color = Library.Theme[Stroke]})
            end

            local function RefreshRow(Row)
                local Selected = Row.Mode == Keybind.Mode

                local Text = (Selected or Row.Hover) and "Text" or "Inactive Text"
                local Background = Row.Hover and "Hovered Element" or "Inline"

                local TextTarget = Library.Theme[Text]
                local TextTheme = Text

                if Row.Mode == "Remove" and Row.Hover then
                    TextTarget = DangerColor
                    TextTheme = function()
                        return DangerColor
                    end
                end

                Row.Button:ChangeItemTheme({TextColor3 = TextTheme, BackgroundColor3 = Background})
                Row.Button:Tween({
                    TextColor3 = TextTarget,
                    BackgroundColor3 = Library.Theme[Background]
                })

                Row.Pill.Instance.Visible = Selected
            end

            local function RefreshRows()
                for _, Row in Rows do
                    RefreshRow(Row)
                end
            end

            local function ApplyZIndex()
                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                local ZIndex = 1

                if Keybind.IsOpen then
                    ZIndex = IsSettings and Library.ZIndexOrder.KeybindWindow or Library.ZIndexOrder.KeybindWindow + 1
                end

                for _, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = ZIndex
                end
            end

            -- menu sits under the key button, right edges aligned; flips above / clamps near the screen edge
            local function GetTarget(Offset)
                local Screen = Library.Holder.Instance.AbsoluteSize
                local Width = KeybindWindow.AbsoluteSize.X > 0 and KeybindWindow.AbsoluteSize.X or 88
                local Height = KeybindWindow.AbsoluteSize.Y

                if Height <= 0 then
                    Height = #Keybind.Modes * 24 + 8
                end

                local X = KeyButton.AbsolutePosition.X + KeyButton.AbsoluteSize.X
                X = math.clamp(X, Width + 8, math.max(Screen.X - 8, Width + 8))

                local Y = KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset + 4
                local Direction = 1

                if Y + Height > Screen.Y - 8 then
                    Y = KeyButton.AbsolutePosition.Y + GuiInset - Height - 4
                    Direction = -1
                end

                -- whole pixels only, fractional offsets make Roblox text blurry
                return UDim2.fromOffset(math.floor(X + 0.5), math.floor(Y + Offset * Direction + 0.5))
            end

            local function StopFollow()
                if FollowConnection then
                    FollowConnection:Disconnect()
                    FollowConnection = nil
                end
            end

            local function StartFollow()
                StopFollow()

                FollowConnection = RunService.RenderStepped:Connect(function()
                    if not Keybind.IsOpen then
                        return
                    end

                    if not KeyButton:IsDescendantOf(Library.Holder.Instance)
                    or (type(MainWindow) == "table" and MainWindow.IsOpen == false) then
                        Keybind:SetOpen(false)
                        return
                    end

                    KeybindWindow.Position = GetTarget(0)
                end)

                table.insert(Library.Connections, FollowConnection)
            end

            function Keybind:SetOpen(Bool)
                Bool = Bool and true or false

                if Debounce or Keybind.IsOpen == Bool then
                    return
                end

                Keybind.IsOpen = Bool
                Debounce = true

                if Keybind.IsOpen then
                    KeybindWindow.Position = GetTarget(-10)
                    KeybindWindow.Parent = Library.Holder.Instance

                    Items["KeybindWindow"]:Tween({Position = GetTarget(0)})

                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false

                        if Keybind.IsOpen then
                            StartFollow()
                        end
                    end)

                    Library:RegisterOpenFrame(Keybind, {
                        HoverItems = { Items["KeybindWindow"], Items["KeyButton"] },
                        AnchorInstance = KeyButton,
                        PopupInstance = KeybindWindow,
                    })
                else
                    StopFollow()

                    Items["KeybindWindow"]:Tween({Position = GetTarget(-10)})

                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    Library:CloseOpenFrameChildren(Keybind)
                    Library:UnregisterOpenFrame(Keybind)
                end

                ApplyZIndex()
                if Library.RefreshPopupLayer then Library:RefreshPopupLayer() end
                RefreshButton()
            end

            Items["KeybindWindow"]:VisibleCheck()

            function Keybind:SetLinkedState(Bool)
                Bool = Bool and true or false
                Keybind.Toggled = Bool
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end

            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Keybind.Ready and Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then
                    Keybind.Toggled = true
                end

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Keybind.LinkedToggle and Keybind.LinkedToggle.Value ~= Keybind.Toggled then
                    Keybind.LinkedToggle:Set(Keybind.Toggled)
                end

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end

            -- force the state (used when a Hold bind loses its key / leaves Always)
            function Keybind:ApplyToggled(Value)
                Keybind.Toggled = Value and true or false

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Keybind.LinkedToggle and Keybind.LinkedToggle.Value ~= Keybind.Toggled then
                    Keybind.LinkedToggle:Set(Keybind.Toggled)
                end

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end

            function Keybind:SetModeValue(Mode)
                local Previous = Keybind.Mode
                Keybind.Mode = Mode

                RefreshRows()

                if not Keybind.Ready then
                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    return
                end

                if Mode == "Always" then
                    Keybind:Press(true)
                elseif Previous == "Always" and Mode == "Hold" and Keybind.Toggled then
                    Keybind:ApplyToggled(false)
                else
                    Keybind:SetMode()
                end
            end

            local function Finish()
                Keybind.Picking = false
                LastPicked = os.clock()
                RefreshButton()
            end

            -- remove the bind (key becomes "None")
            function Keybind:Clear()
                Keybind.Key = "None"
                Keybind.Value = "None"
                Keybind.PressedInputs = { }

                KeyButton.Text = "None"

                if Keybind.Mode == "Hold" and Keybind.Toggled then
                    Keybind:ApplyToggled(false)
                else
                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Keybind.Ready and Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                if ListItem then
                    ListItem:Set(Keybind.Name, "None")
                    ListItem:SetBound(false)
                    ListItem:SetStatus(Keybind.Toggled)
                end

                Finish()
            end

            function Keybind:SelectMode(Mode)
                if Mode == "Remove" then
                    Keybind:Clear()
                elseif Mode ~= nil and table.find(Keybind.Modes, Mode) then
                    Keybind:SetModeValue(Mode)
                end
            end

            function Keybind:Set(Key)
                if typeof(Key) == "EnumItem" then
                    -- Duplicate keybinds are allowed; no conflict dialog.
                    -- every key can be bound, including Backspace / Delete (use "Remove" in the menu to unbind)
                    if Key == Enum.KeyCode.Unknown then
                        KeyButton.Text = Keybind.Value
                        Finish()
                        return
                    end

                    Keybind.Key = tostring(Key)
                    Keybind.Value = Keys[Key.Name] or Key.Name
                    Keybind.PressedInputs = { }

                    KeyButton.Text = Keybind.Value

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Keybind.Ready and Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    if ListItem then
                        ListItem:Set(Keybind.Name, Keybind.Value)
                        ListItem:SetBound(true)
                        ListItem:SetStatus(Keybind.Toggled)
                    end
                elseif type(Key) == "table" then
                    local Raw = Key.Key

                    if Raw == nil or tostring(Raw) == "None" or tostring(Raw) == "" then
                        Keybind.Key = "None"
                        Keybind.Value = "None"
                    else
                        Keybind.Key = tostring(Raw)

                        local Last = Keybind.Key:match("([^%.]+)$") or Keybind.Key
                        Keybind.Value = Keys[Last] or Last
                    end

                    Keybind.PressedInputs = { }
                    KeyButton.Text = Keybind.Value

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    Keybind:SetModeValue(PickMode(Keybind.Modes, Key.Mode or Keybind.DefaultMode))

                    if ListItem then
                        ListItem:Set(Keybind.Name, Keybind.Value)
                        ListItem:SetBound(Keybind.Value ~= "None" and Keybind.Value ~= "")
                        ListItem:SetStatus(Keybind.Toggled)
                    end
                elseif type(Key) == "string" then
                    local Mode = Capitalize(Key)

                    if Mode and Mode ~= "Remove" and table.find(Keybind.Modes, Mode) then
                        Keybind:SetModeValue(Mode)
                    end
                end

                Finish()
            end

            function Keybind:SetModes(List)
                Keybind.Modes = NormalizeModes(List)
                Keybind.DefaultMode = PickMode(Keybind.Modes, Keybind.DefaultMode)

                Keybind:BuildRows()

                if not table.find(Keybind.Modes, Keybind.Mode) or Keybind.Mode == "Remove" then
                    Keybind:SetModeValue(Keybind.DefaultMode)
                else
                    RefreshRows()
                end
            end

            function Keybind:BuildRows()
                for _, Row in Rows do
                    Row.Button.Instance:Destroy()
                end

                Rows = { }

                for Index, Name in Keybind.Modes do
                    local Row = { Mode = Name, Hover = false }

                    Row.Button = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["KeybindWindow"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = Name,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false,
                        LayoutOrder = Index,
                        Size = UDim2.new(1, 0, 0, 22),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }):AddToTheme({TextColor3 = "Inactive Text", BackgroundColor3 = "Inline"})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Row.Button.Instance,
                        CornerRadius = UDim.new(0, 4)
                    })

                    Library:Create("UIPadding", {
                        Name = "\0",
                        Parent = Row.Button.Instance,
                        PaddingLeft = UDim.new(0, 12),
                        PaddingRight = UDim.new(0, 6)
                    })

                    Row.Pill = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Row.Button.Instance,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, -9, 0.5, 0),
                        Size = UDim2.new(0, 2, 0, 10),
                        Visible = false,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Accent"]
                    }):AddToTheme({BackgroundColor3 = "Accent"})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Row.Pill.Instance,
                        CornerRadius = UDim.new(1, 0)
                    })

                    Row.Button:OnHover(function()
                        Row.Hover = true
                        RefreshRow(Row)
                    end, function()
                        Row.Hover = false
                        RefreshRow(Row)
                    end)

                    Row.Button:Connect("MouseButton1Down", function()
                        Keybind:SelectMode(Row.Mode)
                        Keybind:SetOpen(false)
                    end)

                    table.insert(Rows, Row)
                end

                if Keybind.IsOpen then
                    ApplyZIndex()
                end
            end

            Keybind:BuildRows()

            if not Data.Default and ListItem then
                ListItem:SetBound(false)
            end

            -- left click: pick a key
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                if Keybind.Picking then
                    return
                end

                Keybind.Picking = true

                KeyButton.Text = ". . ."
                RefreshButton()

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "None" then
                    return
                end

                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.PressedInputs[tostring(Input.KeyCode)] then return end
                        Keybind.PressedInputs[tostring(Input.KeyCode)] = true
                        if Keybind.Mode == "Toggle" then
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.PressedInputs[tostring(Input.UserInputType)] then return end
                        Keybind.PressedInputs[tostring(Input.UserInputType)] = true
                        if Keybind.Mode == "Toggle" then
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    end
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    Keybind.PressedInputs[tostring(Input.KeyCode)] = nil
                    if Keybind.Mode == "Hold" then
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    Keybind.PressedInputs[tostring(Input.UserInputType)] = nil
                    if Keybind.Mode == "Hold" then
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then
                        Keybind:Press(true)
                    end
                end
            end)

            Library:RegisterOpenFrameTrigger(Items["KeyButton"])

            Items["KeyButton"]:OnHover(function()
                Hovering = true
                RefreshButton()
            end, function()
                Hovering = false
                RefreshButton()
            end)

            local function ToggleMenu()
                -- the click that just picked a key must not also open the menu
                if Keybind.Picking or (os.clock() - LastPicked) < 0.2 then
                    return
                end

                Keybind:SetOpen(not Keybind.IsOpen)
            end

            -- middle click (GuiButton has no MouseButton3 event, so listen to InputBegan) and right click
            Library:Connect(KeyButton.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton3 then
                    ToggleMenu()
                end
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", ToggleMenu)

            if Data.Default then
                Keybind:Set({
                    Mode = Keybind.DefaultMode,
                    Key = Data.Default,
                })
            else
                Keybind:SetModeValue(Keybind.DefaultMode)
            end

            -- an "Always" bind is active right away
            if Keybind.Mode == "Always" then
                Keybind:Press(true)
            end

            Keybind.Ready = true
            Library.KeybindRegistry = Library.KeybindRegistry or {}
            table.insert(Library.KeybindRegistry, Keybind)

            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items
        end

-- Notification audio uses one reusable Sound instance, never one per message.
Library.NotificationSoundMode = "None"
Library.NotificationVolume = 0.55
Library.NotificationCustomSoundId = ""
Library.PlayNotificationSound = function(Self)
    if Library.NotificationSoundMode == "None" then return end
    local Id
    if Library.NotificationSoundMode == "Custom" then
        Id = Library:NormalizeSoundId(Library.NotificationCustomSoundId)
    else
        Id = "rbxassetid://88442833509532"
    end
    if not Id then return end
    local Sound = Library.NotificationSound
    if not Sound or not Sound.Parent then
        Sound = Instance.new("Sound")
        Sound.Name = "MimisenseNotificationSound"
        Sound.Parent = SoundService
        Library.NotificationSound = Sound
    end
    Sound.SoundId = Id
    Sound.Volume = math.clamp(Library.NotificationVolume or 0.55, 0, 1)
    Sound.TimePosition = 0
    pcall(function() SoundService:PlayLocalSound(Sound) end)
end

Library.SetUIClickVolume = function(Self, Volume)
    Volume = tonumber(Volume)
    if not Volume then return end
    Self.UIClickVolume = math.clamp(Volume, 0, 1)
    if Self.UIClickSound then
        Self.UIClickSound.Volume = (Self.UIClickEnabled == false) and 0 or Self.UIClickVolume
    end
end

Library.SetMascotClickVolume = function(Self, Volume)
    Volume = tonumber(Volume)
    if not Volume then return end
    Self.MascotClickVolume = math.clamp(Volume, 0, 1)
    if Self.MascotClickSound then
        Self.MascotClickSound.Volume = Self.MascotClickVolume
    end
end

Library.Watermark = function(Self, Params)
            Params = Params or { }

            local Watermark = {
                Name = Params.Name or Params.name or Self.Name or "Watermark",
                Logo = Params.Logo or Params.logo or Self.Logo,

                Window = Self,
                Items = { }
            }

            local Items = { } do
                Items["Watermark"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Text = "",
                    AutoButtonColor = false,
                    TextTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.new(0.5, 0, 1, -10),
                    Size = UDim2.fromOffset(220, 45),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Items["Watermark"]:MakeDraggable()

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Main"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 4,
                    Parent = Items["Main"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Watermark.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 38, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Main"].Instance,
                    ImageColor3 = Color3.new(1, 1, 1),
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Library:ResolveLogo(Watermark.Logo),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 30, 0, 30),
                    BorderSizePixel = 0
                })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["NewHolder"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["NewHolder"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Watermark.Items = Items
            end

            local GetInactiveRGB = function()
                local Color = Library.Theme["Inactive Text"]
                return string.format(
                    "rgb(%d, %d, %d)",
                    math.floor(Color.R * 255 + 0.5),
                    math.floor(Color.G * 255 + 0.5),
                    math.floor(Color.B * 255 + 0.5)
                )
            end

            local GetPing = function()
                local Ok, Value = pcall(function()
                    return math.floor(LocalPlayer:GetNetworkPing() * 1000)
                end)

                if Ok and Value then
                    return Value
                end

                Ok, Value = pcall(function()
                    return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                end)

                return (Ok and Value) or 0
            end

            -- what the watermark can show; Watermark:SetFields({"FPS", "Ping", "Place", ...})
            Watermark.FieldOrder = { "FPS", "Ping", "Place", "Session", "Time", "Date", "Player", "Players", "Memory" }
            Watermark.Fields = { FPS = true, Ping = true }
            Library.WatermarkFieldOrder = Watermark.FieldOrder

            local FieldTitles = {
                FPS = "FPS", Ping = "PING", Place = "PLACE", Session = "SESSION", Time = "TIME",
                Date = "DATE", Player = "PLAYER", Players = "PLAYERS", Memory = "MEM"
            }

            local Labels = { }
            local Columns = { }
            local CurrentFPS = 0
            local StartClock = os.clock()
            local PlaceName = "..."

            task.spawn(function()
                local Ok, Info = pcall(function()
                    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
                end)

                if Ok and type(Info) == "table" and Info.Name then
                    PlaceName = tostring(Info.Name)
                else
                    PlaceName = (game.Name ~= "" and game.Name) or "Unknown"
                end

                if #PlaceName > 24 then
                    PlaceName = PlaceName:sub(1, 23) .. "..."
                end
            end)

            local FormatSession = function()
                local Total = math.floor(os.clock() - StartClock)
                local Hours = math.floor(Total / 3600)
                local Minutes = math.floor((Total % 3600) / 60)
                local Seconds = Total % 60

                if Hours > 0 then
                    return string.format("%d:%02d:%02d", Hours, Minutes, Seconds)
                end

                return string.format("%02d:%02d", Minutes, Seconds)
            end

            local GetFieldValue = function(Name)
                if Name == "FPS" then
                    return tostring(CurrentFPS)
                elseif Name == "Ping" then
                    return GetPing() .. "ms"
                elseif Name == "Place" then
                    return PlaceName
                elseif Name == "Session" then
                    return FormatSession()
                elseif Name == "Time" then
                    return os.date("%H:%M:%S")
                elseif Name == "Date" then
                    return os.date("%d.%m.%Y")
                elseif Name == "Player" then
                    return LocalPlayer.DisplayName
                elseif Name == "Players" then
                    return #Players:GetPlayers() .. "/" .. Players.MaxPlayers
                elseif Name == "Memory" then
                    local Ok, Value = pcall(function()
                        return game:GetService("Stats"):GetTotalMemoryUsageMb()
                    end)

                    return Ok and string.format("%d MB", Value) or "--"
                end

                return "--"
            end

            local RefreshFields = function()
                local Color = GetInactiveRGB()

                for Name, Label in Labels do
                    Label.Instance.Text = string.format('%s: <font color="%s">%s</font>', FieldTitles[Name] or Name, Color, GetFieldValue(Name))
                end
            end

            local RebuildFields = function()
                for _, Column in Columns do
                    Column.Instance:Destroy()
                end

                table.clear(Columns)
                table.clear(Labels)

                local Enabled = { }

                for _, Name in Watermark.FieldOrder do
                    if Watermark.Fields[Name] then
                        table.insert(Enabled, Name)
                    end
                end

                local Column

                for Index, Name in Enabled do
                    -- two rows per column, like the old FPS / PING stack
                    if (Index - 1) % 2 == 0 then
                        Column = Library:Create("Frame", {
                            Name = "\0",
                            Parent = Items["NewHolder"].Instance,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 0, 1, 0),
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.X,
                            LayoutOrder = Index
                        })

                        Library:Create("UIListLayout", {
                            Name = "\0",
                            Parent = Column.Instance,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            Padding = UDim.new(0, 1),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        })

                        table.insert(Columns, Column)
                    end

                    Labels[Name] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Column.Instance,
                        RichText = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = "",
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        LayoutOrder = Index
                    }):AddToTheme({TextColor3 = 'Text'})
                end

                Items["NewHolder"].Instance.Visible = #Enabled > 0
                RefreshFields()
            end

            function Watermark:SetField(Name, Bool)
                if table.find(Watermark.FieldOrder, Name) then
                    Watermark.Fields[Name] = Bool and true or false
                    RebuildFields()
                end
            end

            -- array of names ({"FPS", "Ping"}) or a dictionary ({FPS = true, Ping = false})
            function Watermark:SetFields(Data)
                local Fields = { }

                if type(Data) == "table" then
                    if #Data > 0 then
                        for _, Name in Data do
                            Fields[Name] = true
                        end
                    else
                        for Name, Value in Data do
                            Fields[Name] = Value and true or nil
                        end
                    end
                end

                -- The watermark is centre-anchored, so adding/removing text
                -- cannot shift the bar to the right. Preserve drag position.
                Watermark.Fields = Fields
                RebuildFields()
            end

            function Watermark:GetFields()
                return table.clone(Watermark.Fields)
            end

            local FrameCount = 0
            local LastUpdate = os.clock()

            Library:Connect(RunService.RenderStepped, function()
                FrameCount += 1

                local Now = os.clock()
                if Now - LastUpdate < 1 then
                    return
                end

                CurrentFPS = FrameCount
                FrameCount = 0
                LastUpdate = Now

                RefreshFields()
            end)

            RebuildFields()

            function Watermark:Center()
                -- Keep the root anchored at its centre while AutomaticSize.X
                -- changes with the FPS/Ping fields. Never convert its anchor
                -- using AbsolutePosition before the UI has measured its width.
                local Frame = Items["Watermark"].Instance
                local OldAnchor = Frame.AnchorPoint
                if OldAnchor ~= Vector2.new(0.5, 1) then
                    local Centre = Frame.AbsolutePosition.X + Frame.AbsoluteSize.X / 2
                    local Bottom = Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
                    Frame.AnchorPoint = Vector2.new(0.5, 1)
                    Frame.Position = UDim2.fromOffset(Centre, Bottom)
                end
            end

            local WatermarkVisibilityState = {}
            local WatermarkScale = Library:Create("UIScale", {Name = "\0", Parent = Items["Watermark"].Instance, Scale = 1})
            function Watermark:SetVisibility(Bool)
                Library:AnimatedVisibility(Items["Watermark"], Bool, WatermarkVisibilityState, WatermarkScale)
            end

            function Watermark:SetText(Text)
                Watermark.Name = tostring(Text)
                Items["Title"].Instance.Text = Watermark.Name
            end

            Watermark:Center()
            Self.Watermark = Watermark
            Watermark.Window = Self
            if Library.SetMenuGlow then
                Library:SetMenuGlow(Library.MenuGlowStrength or 35, Library.MenuGlowEnabled ~= false)
            end

            -- The root itself handles clicks. Adding a 100%-wide sibling to
            -- its UIListLayout would create a circular AutomaticSize.X chain,
            -- stretching the watermark across the whole screen.
            Library:Connect(Items["Watermark"].Instance.MouseButton1Click, function()
                if Watermark.Window and Watermark.Window.SetOpen then
                    Watermark.Window:SetOpen(not Watermark.Window.IsOpen)
                end
            end)

            return setmetatable(Watermark, Library)
        end

        Library.KeybindList = function(Self, Params)
            Params = Params or { }

            local KeybindList = {
                Name = Params.Name or Params.name or "Keybind List",
                Icon = Params.Icon or Params.icon or "keyboard",
                Keys = { },
                Window = Self,
                Items = { }
            }

            local Items = { } do
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Size = UDim2.new(0, 220, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})

                Items["TopCorner"] = Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })

                if KeybindList.Icon ~= "" then
                    Items["Icon"] = Library:Create("ImageLabel", {
                        Name = "\0", Parent = Items["Top"].Instance, BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
                        Size = UDim2.new(0, 16, 0, 16), BorderSizePixel = 0, ImageColor3 = Library.Theme["Accent"]
                    }):AddToTheme({ImageColor3 = "Accent"})
                    if not Library:ApplyIcon(Items["Icon"].Instance, KeybindList.Icon) then
                        Items["Icon"].Instance:Destroy()
                        Items["Icon"] = nil
                        KeybindList.Icon = ""
                    end
                end

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = KeybindList.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, KeybindList.Icon ~= "" and 32 or 12, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Visible = false,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    TopRightRadius = UDim.new(0, 0),
                    TopLeftRadius = UDim.new(0, 0)
                })

                Items["KeybindList"]:MakeDraggable(Items["Top"])
                Items["KeybindList"]:MakeDraggable(Items["Content"])

                KeybindList.Items = Items
            end

            local KeybindTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            local RowHeight = 16
            local RowGap = 6
            local RowSlot = RowHeight + RowGap
            local SlideOffset = 14

            -- "Assigned" (default): binds that have a key | "Active": binds that are on | "All": everything
            KeybindList.Filter = "Assigned"

            function KeybindList:ShouldShow(Row)
                if KeybindList.Filter == "All" then
                    return true
                elseif KeybindList.Filter == "Active" then
                    return Row.Bound and Row.Active
                end

                return Row.Bound
            end

            function KeybindList:SetFilter(Mode)
                Mode = tostring(Mode or "Assigned"):lower()

                if Mode:find("all") then
                    Mode = "All"
                elseif Mode:find("active") then
                    Mode = "Active"
                else
                    Mode = "Assigned"
                end

                KeybindList.Filter = Mode

                for _, Row in KeybindList.Keys do
                    if Row.Apply then
                        Row:Apply()
                    end
                end
            end

            function KeybindList:Refresh()
                local Count = 0
                for _, Row in KeybindList.Keys do
                    if Row.Shown then
                        Count += 1
                    end
                end

                local HasRows = Count > 0
                Items["Content"].Instance.Visible = HasRows

                local Radius = UDim.new(0, HasRows and 0 or 8)
                Items["TopCorner"].Instance.BottomLeftRadius = Radius
                Items["TopCorner"].Instance.BottomRightRadius = Radius
            end

            function KeybindList:Add(Name, Key)
                local RowItems = { } do
                    RowItems["NewKey"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Content"].Instance,
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Size = UDim2.new(1, 0, 0, 0),
                        Visible = false,
                        BorderSizePixel = 0
                    })

                    RowItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = RowItems["NewKey"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Name or "Keybind",
                        TextTransparency = 1,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, -SlideOffset, 0, RowHeight / 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Text'})

                    RowItems["Key"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = RowItems["NewKey"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = string.upper(tostring(Key or "None")),
                        TextTransparency = 1,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, SlideOffset, 0, RowHeight / 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Inactive Text'})
                end

                local NewKey = {
                    Name = Name or "Keybind",
                    Key = Key or "None",
                    Active = false,
                    Bound = tostring(Key or "None") ~= "None" and tostring(Key or "None") ~= "",
                    AnimationToken = 0,
                    Items = RowItems
                }

                function NewKey:Set(NewName, NewKeyValue)
                    if NewName ~= nil then
                        NewKey.Name = tostring(NewName)
                        RowItems["Text"].Instance.Text = NewKey.Name
                    end
                    if NewKeyValue ~= nil then
                        NewKey.Key = tostring(NewKeyValue)
                        RowItems["Key"].Instance.Text = string.upper(NewKey.Key)
                        NewKey:SetBound(NewKey.Key ~= "None" and NewKey.Key ~= "")
                    end
                end

                function NewKey:Apply()
                    NewKey.AnimationToken += 1

                    local Token = NewKey.AnimationToken
                    local Show = KeybindList:ShouldShow(NewKey) and true or false
                    local WasShown = NewKey.Shown == true

                    NewKey.Shown = Show
                    KeybindList:Refresh()

                    local RowInstance = RowItems["NewKey"].Instance
                    local Lit = NewKey.Bound and NewKey.Active
                    local Color = Lit and Library.Theme["Text"] or Library.Theme["Inactive Text"]

                    if not Show then
                        if RowInstance.Visible then
                            RowItems["NewKey"]:Tween({Size = UDim2.new(1, 0, 0, 0)}, KeybindTweenInfo)
                            RowItems["Text"]:Tween({TextTransparency = 1, Position = UDim2.new(0, -SlideOffset, 0, RowHeight / 2)}, KeybindTweenInfo)
                            RowItems["Key"]:Tween({TextTransparency = 1, Position = UDim2.new(1, SlideOffset, 0, RowHeight / 2)}, KeybindTweenInfo)

                            task.delay(KeybindTweenInfo.Time + 0.03, function()
                                if Token == NewKey.AnimationToken and not NewKey.Shown and RowInstance.Parent then
                                    RowInstance.Visible = false
                                end
                            end)
                        end

                        return
                    end

                    if not WasShown or not RowInstance.Visible then
                        RowInstance.Visible = true
                        RowInstance.Size = UDim2.new(1, 0, 0, 0)
                        RowItems["Text"].Instance.TextTransparency = 1
                        RowItems["Key"].Instance.TextTransparency = 1
                        RowItems["Text"].Instance.Position = UDim2.new(0, -SlideOffset, 0, RowHeight / 2)
                        RowItems["Key"].Instance.Position = UDim2.new(1, SlideOffset, 0, RowHeight / 2)
                    end

                    RowItems["Text"]:Tween({TextColor3 = Color}, KeybindTweenInfo)
                    RowItems["Key"]:Tween({TextColor3 = Color}, KeybindTweenInfo)
                    RowItems["NewKey"]:Tween({Size = UDim2.new(1, 0, 0, RowSlot)}, KeybindTweenInfo)
                    RowItems["Text"]:Tween({TextTransparency = 0, Position = UDim2.new(0, 0, 0, RowHeight / 2)}, KeybindTweenInfo)
                    RowItems["Key"]:Tween({TextTransparency = 0, Position = UDim2.new(1, 0, 0, RowHeight / 2)}, KeybindTweenInfo)

                    task.delay(KeybindTweenInfo.Time + 0.03, function()
                        if Token ~= NewKey.AnimationToken or not NewKey.Shown or not RowInstance.Parent then
                            return
                        end

                        local Final = (NewKey.Bound and NewKey.Active) and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                        RowItems["Text"].Instance.TextColor3 = Final
                        RowItems["Key"].Instance.TextColor3 = Final
                    end)
                end

                function NewKey:SetBound(Bool)
                    NewKey.Bound = Bool and true or false
                    NewKey:Apply()
                end

                function NewKey:SetStatus(Bool)
                    NewKey.Active = Bool and true or false
                    NewKey:Apply()
                end

                NewKey:SetBound(NewKey.Bound)

                function NewKey:Remove()
                    local Index = table.find(KeybindList.Keys, NewKey)

                    if Index then
                        table.remove(KeybindList.Keys, Index)
                    end

                    RowItems["NewKey"].Instance:Destroy()
                    KeybindList:Refresh()
                end

                table.insert(KeybindList.Keys, NewKey)
                KeybindList:Refresh()
                return NewKey
            end

            local KeybindListVisibilityState = {}
            local KeybindListScale = Library:Create("UIScale", {Name = "\0", Parent = Items["KeybindList"].Instance, Scale = 1})
            function KeybindList:SetVisibility(Bool)
                Library:AnimatedVisibility(Items["KeybindList"], Bool, KeybindListVisibilityState, KeybindListScale)
            end

            function KeybindList:SetText(Text)
                KeybindList.Name = tostring(Text)
                Items["Title"].Instance.Text = KeybindList.Name
            end

            function KeybindList:Center()
                Items["KeybindList"]:ConvertAnchor()
            end

            KeybindList:Refresh()
            KeybindList:Center()

            Library.KeyList = KeybindList
            Self.KeybindList = KeybindList
            if Library.SetMenuGlow then
                Library:SetMenuGlow(Library.MenuGlowStrength or 35, Library.MenuGlowEnabled ~= false)
            end

            return setmetatable(KeybindList, Library)
        end

        Library.NotificationTypes = {
            Success = Color3.fromRGB(95, 205, 135),
            Warning = Color3.fromRGB(235, 185, 85),
            Error   = Color3.fromRGB(230, 95, 95),
        }

        Library.NotificationCounter = 0
        Library.NotificationLimit = 6
        -- Default lifetime for all notifications that do not supply Duration.
        Library.NotificationDuration = 3

        -- Notification v20: fully opaque theme-linked card, no icon or top strip.
        -- Title always comes from the Window.Name. Duration comes from Menu Options
        -- unless the caller explicitly passes Duration. Cards stack in NotificationStack.
        Library.Notification = function(Self, Params)
            Params = Params or {}
            if Library.NotificationEnabled == false then return nil end
            if Library.PlayNotificationSound then Library:PlayNotificationSound() end

            local Window = Library.ActiveWindow
            local Title = tostring(Window and Window.Name or "mimisense")
            local Description = tostring(Params.Description or Params.description or "")
            if Description == "" then
                Description = tostring(Params.Name or Params.name or Params.Title or Params.title or "")
            end
            local Lifetime = math.clamp(tonumber(Params.Duration or Params.duration)
                or tonumber(Library.NotificationDuration) or 3, 0.5, 60)
            local Key = Title .. "\n" .. Description

            for _, Existing in Library.Notifications do
                if Existing.Key == Key and not Existing.Removing and not Existing.Closing then
                    Existing:Restart()
                    return Existing
                end
            end

            local Width = 276
            local SlideOffset = Library.NotificationSide == "Left" and -28 or 28
            local Notification = {
                Key = Key, Removing = false, Closing = false,
                Paused = false, Elapsed = 0, Duration = Lifetime, Items = {}
            }
            local Items = Notification.Items
            Library.NotificationCounter += 1

            Items.Holder = Library:Create("Frame", {
                Name = "MimisenseNotificationSlot", Parent = Library.NotificationStack.Instance,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.new(0, Width, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = Library.NotificationCounter
            })
            Items.Card = Library:Create("Frame", {
                Name = "MimisenseNotificationCard", Parent = Items.Holder.Instance,
                BorderSizePixel = 0, ClipsDescendants = true,
                Position = UDim2.fromOffset(SlideOffset, 0),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 0,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = "Background"})
            Library:Create("UICorner", {
                Name = "MimisenseNotificationCorner", Parent = Items.Card.Instance,
                CornerRadius = UDim.new(0, 8)
            })
            Library:Create("UIStroke", {
                Name = "MimisenseNotificationOutline", Parent = Items.Card.Instance,
                Color = Library.Theme["Outline"], Transparency = 0,
                Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            Items.Body = Library:Create("Frame", {
                Name = "MimisenseNotificationBody", Parent = Items.Card.Instance,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Position = UDim2.fromOffset(0, 0),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            Library:Create("UIPadding", {
                Name = "MimisenseNotificationPadding", Parent = Items.Body.Instance,
                PaddingTop = UDim.new(0, 15),
                PaddingBottom = UDim.new(0, 29),
                PaddingLeft = UDim.new(0, 17),
                PaddingRight = UDim.new(0, 17)
            })
            Library:Create("UIListLayout", {
                Name = "MimisenseNotificationLayout", Parent = Items.Body.Instance,
                Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder
            })
            Items.Title = Library:Create("TextLabel", {
                Name = "MimisenseNotificationTitle", Parent = Items.Body.Instance,
                FontFace = Library.Font, TextSize = Library.FontSize + 3,
                Text = Title, TextColor3 = Library.Theme["Text"],
                TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 1
            }):AddToTheme({TextColor3 = "Text"})
            Items.Description = Library:Create("TextLabel", {
                Name = "MimisenseNotificationDescription", Parent = Items.Body.Instance,
                FontFace = Library.Font, TextSize = Library.FontSize + 5,
                Text = Description, Visible = Description ~= "",
                TextColor3 = Library.Theme["Text"],
                TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 2
            }):AddToTheme({TextColor3 = "Text"})

            Items.ProgressTrack = Library:Create("Frame", {
                Name = "MimisenseNotificationProgressTrack", Parent = Items.Card.Instance,
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 17, 1, -12),
                Size = UDim2.new(1, -34, 0, 3),
                BackgroundTransparency = 0,
                BackgroundColor3 = Library.Theme["Outline"], BorderSizePixel = 0,
                ZIndex = 3
            }):AddToTheme({BackgroundColor3 = "Outline"})
            Library:Create("UICorner", {Parent = Items.ProgressTrack.Instance,
                CornerRadius = UDim.new(1, 0)})
            Items.Progress = Library:Create("Frame", {
                Name = "MimisenseNotificationProgress", Parent = Items.ProgressTrack.Instance,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme["Accent"],
                BackgroundTransparency = 0, ZIndex = 4
            }):AddToTheme({BackgroundColor3 = "Accent"})
            Library:Create("UICorner", {Parent = Items.Progress.Instance,
                CornerRadius = UDim.new(1, 0)})
            Items.Hit = Library:Create("TextButton", {
                Name = "MimisenseNotificationHit", Parent = Items.Card.Instance,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1), Text = "", ZIndex = 5
            })

            local InInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local OutInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            local function Alive()
                return Library ~= nil and Items.Holder.Instance.Parent ~= nil
            end
            local ProgressTween
            function Notification:Restart()
                Notification.Elapsed = 0
                if ProgressTween then ProgressTween:Cancel() end
                local Bar = Items.Progress.Instance
                Bar.Size = UDim2.new(1, 0, 1, 0)
                ProgressTween = TweenService:Create(Bar, TweenInfo.new(Notification.Duration, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(0, 0, 1, 0)
                })
                ProgressTween:Play()
                if Notification.Paused then ProgressTween:Pause() end
            end
            function Notification:Dismiss()
                Notification.Closing = true
            end
            Library:Connect(Items.Hit.Instance.MouseEnter, function()
                Notification.Paused = true
                if ProgressTween then ProgressTween:Pause() end
            end)
            Library:Connect(Items.Hit.Instance.MouseLeave, function()
                Notification.Paused = false
                if ProgressTween then ProgressTween:Play() end
            end)
            Library:Connect(Items.Hit.Instance.MouseButton1Click, function()
                Notification.Closing = true
            end)

            table.insert(Library.Notifications, Notification)
            local Active = {}
            for _, Item in Library.Notifications do
                if not Item.Removing and not Item.Closing then
                    table.insert(Active, Item)
                end
            end
            for Index = 1, #Active - Library.NotificationLimit do
                Active[Index]:Dismiss()
            end
            task.spawn(function()
                if not Alive() then return end
                TweenService:Create(Items.Card.Instance, InInfo, {Position = UDim2.fromOffset(0, 0)}):Play()
                Notification:Restart()
                local Last = os.clock()
                while Alive() and not Notification.Closing and Notification.Elapsed < Notification.Duration do
                    task.wait(0.05)
                    local Now = os.clock()
                    if not Notification.Paused then
                        Notification.Elapsed += Now - Last
                    end
                    Last = Now
                end
                if not Alive() then return end
                Notification.Removing = true
                local Index = table.find(Library.Notifications, Notification)
                if Index then table.remove(Library.Notifications, Index) end
                TweenService:Create(Items.Card.Instance, OutInfo, {
                    Position = UDim2.fromOffset(SlideOffset, 0)
                }):Play()
                task.wait(OutInfo.Time)
                if not Alive() then return end
                local Holder = Items.Holder.Instance
                Holder.AutomaticSize = Enum.AutomaticSize.None
                Holder.Size = UDim2.fromOffset(Width, Holder.AbsoluteSize.Y)
                Holder.ClipsDescendants = true
                local Collapse = TweenService:Create(Holder,
                    TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(Width, 0)
                })
                Collapse:Play()
                Collapse.Completed:Wait()
                if Holder.Parent then Holder:Destroy() end
            end)
            return Notification
        end

        Library.Notify = function(Self, Name, Description, Type, Duration)
            return Library:Notification({Name = Name, Description = Description, Type = Type, Duration = Duration})
        end

        Library.ESPPreview = function(Self, Params)
            Params = Params or { }

            local ESPPreview = {
                Name = Params.Name or Params.name or "ESP Preview",
                Icon = Params.Icon or Params.icon or "eye",

                Window = Self,
                Player = nil,
                Spinning = false,
                Items = { }
            }

            local BottomHeight = 32

            local Items = { } do
                Items["ESPPreview"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = ESPPreview.Window.Items.MainFrame.Instance,
                    Position = UDim2.new(1, 10, 0, 0),
                    Size = UDim2.new(0, 200, 0, 260),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })

                if ESPPreview.Icon ~= "" then
                    Items["Icon"] = Library:Create("ImageLabel", {
                        Name = "\0", Parent = Items["Top"].Instance, BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
                        Size = UDim2.new(0, 16, 0, 16), BorderSizePixel = 0, ImageColor3 = Library.Theme["Accent"]
                    }):AddToTheme({ImageColor3 = "Accent"})
                    Library:ApplyIcon(Items["Icon"].Instance, ESPPreview.Icon)
                end

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = ESPPreview.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, ESPPreview.Icon ~= "" and 32 or 12, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Items["ViewportBackground"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ESPPreview"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 1, -(40 + BottomHeight)),
                    BorderSizePixel = 0
                })

                Items["Viewport"] = Library:Create("ViewportFrame", {
                    Name = "\0",
                    Parent = Items["ViewportBackground"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    Ambient = Color3.fromRGB(200, 200, 200),
                    LightColor = Color3.fromRGB(255, 255, 255)
                })

                Items["Bottom"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, BottomHeight),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Bottom"].Instance,
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Bottom"].Instance,
                    PaddingTop = UDim.new(0, 7),
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10)
                })

                ESPPreview.Items = Items
            end

            local ClampPitch = function(PitchValue)
                return math.clamp(PitchValue, math.rad(-80), math.rad(80))
            end

            local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Viewport = Items["Viewport"]

            local ViewportCamera = Instance.new("Camera")
            Viewport.Instance.CurrentCamera = ViewportCamera
            ViewportCamera.CameraType = Enum.CameraType.Track
            ViewportCamera.Parent = Viewport.Instance

            local ViewportModel
            local ESPVisibilityState = {}
            local Zoom = 6
            local MinZoom = 2
            local MaxZoom = 20

            local LastPosition
            local IsRotating = false
            local Sensitivity = 0.7

            local Yaw = math.rad(180)
            local Roll = 0
            local Pitch = 0

            local YawVelocity = 0
            local PitchVelocity = 0

            local Damping = 0.975
            local VelocityPower = 0.01
            local SpinSpeed = math.rad(35)

            local UpdateCamera = function()
                Library:Tween({CFrame = CFrame.new(Vector3.new(0, 2, Zoom), Vector3.new(0, 1, 0))}, nil, ViewportCamera)
            end

            ESPVisibilityState.Visible = true

            local SetupModel = function(Character)
                if ViewportModel then
                    ViewportModel:Destroy()
                    ViewportModel = nil
                end

                if not Character then
                    return
                end

                Character.Archivable = true
                ViewportModel = Character:Clone()
                Character.Archivable = false

                if ViewportModel.PrimaryPart then
                    ViewportModel.PrimaryPart.Anchored = true
                end

                if ESPVisibilityState.Visible ~= false then
                    ViewportModel.Parent = Viewport.Instance
                end

                for _, Value in ViewportModel:GetDescendants() do
                    if Value:IsA("LocalScript") or Value:IsA("Script") then
                        Value:Destroy()
                    elseif Value:IsA("BasePart") then
                        Value.Anchored = true
                        Value.CanCollide = false
                    end
                end

                local HumanoidRootPart = ViewportModel:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    if not ViewportModel.PrimaryPart then
                        ViewportModel.PrimaryPart = HumanoidRootPart
                    end

                    ViewportModel:SetPrimaryPartCFrame(CFrame.Angles(0, math.rad(180), 0) + Vector3.new(0, 2, 0))
                    ViewportCamera.CFrame = CFrame.new(Vector3.new(0, 2, Zoom), Vector3.new(0, 1, 0))
                end

                ViewportCamera.CameraSubject = ViewportModel
                ESPPreview.Player = ViewportModel
            end

            if LocalCharacter then
                SetupModel(LocalCharacter)
            end

            Library:Connect(LocalPlayer.CharacterAdded, function(Character)
                task.wait(0.25)
                SetupModel(Character)
            end)

            local ViewportInputChanged
            Items["ViewportBackground"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsRotating = true
                    LastPosition = Input.Position

                    if ViewportInputChanged then
                        return
                    end

                    ViewportInputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            IsRotating = false
                            ViewportInputChanged:Disconnect()
                            ViewportInputChanged = nil
                        end
                    end)
                end
            end)

            Items["ViewportBackground"]:Connect("InputChanged", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if not LastPosition or not IsRotating then
                        return
                    end

                    local RotationDelta = Input.Position - LastPosition
                    local DeltaX = RotationDelta.X
                    local DeltaY = RotationDelta.Y

                    Yaw = Yaw + math.rad(DeltaX * Sensitivity)
                    Pitch = ClampPitch(Pitch + math.rad(DeltaY * Sensitivity))

                    YawVelocity = DeltaX * VelocityPower
                    PitchVelocity = DeltaY * VelocityPower

                    LastPosition = Input.Position
                end

                if Input.UserInputType == Enum.UserInputType.MouseWheel then
                    Zoom = math.clamp(Zoom - Input.Position.Z, MinZoom, MaxZoom)
                    UpdateCamera()
                end
            end)

            Library:Connect(RunService.RenderStepped, function(DeltaTime)
                if not IsRotating then
                    if ESPPreview.Spinning then
                        Yaw = Yaw + SpinSpeed * DeltaTime
                        YawVelocity = 0
                    else
                        Yaw = Yaw + YawVelocity
                        YawVelocity = YawVelocity * Damping

                        if math.abs(YawVelocity) < 0.0001 then
                            YawVelocity = 0
                        end
                    end

                    Pitch = ClampPitch(Pitch + PitchVelocity)
                    PitchVelocity = PitchVelocity * Damping

                    if math.abs(PitchVelocity) < 0.0001 then
                        PitchVelocity = 0
                    end
                end

                if ViewportModel and ViewportModel.PrimaryPart then
                    local Rotation = CFrame.Angles(Pitch, Yaw, Roll)
                    ViewportModel:SetPrimaryPartCFrame(Rotation + Vector3.new(0, 2, 0))
                end
            end)

            UpdateCamera()

            setmetatable(ESPPreview, Library)

            ESPPreview:Toggle({
                Name = "Spin",
                Flag = "ESPPreview/Spin",
                Parent = Items["Bottom"],
                Default = false,
                Callback = function(Value)
                    ESPPreview.Spinning = Value
                end
            })

            local ESPScale = Library:Create("UIScale", {Name = "", Parent = Items["ESPPreview"].Instance, Scale = 1})
            function ESPPreview:SetVisibility(Bool)
                Bool = Bool and true or false
                ESPVisibilityState.Visible = Bool
                if Bool then
                    -- Re-parent the cloned character only while the preview is enabled.
                    if ViewportModel and ViewportModel.Parent ~= Viewport.Instance then
                        ViewportModel.Parent = Viewport.Instance
                    end
                else
                    -- ViewportModel is a real Instance; hiding the ViewportFrame alone can
                    -- leave the clone rendered by the viewport camera. Remove it as well.
                    if ViewportModel and ViewportModel.Parent == Viewport.Instance then
                        ViewportModel.Parent = nil
                    end
                end
                Library:AnimatedVisibility(Items["ESPPreview"], Bool, ESPVisibilityState, ESPScale)
            end

            function ESPPreview:SetText(Text)
                ESPPreview.Name = tostring(Text)
                Items["Text"].Instance.Text = ESPPreview.Name
            end

            Self.ESPPreview = ESPPreview
            if Library.SetMenuGlow then
                Library:SetMenuGlow(Library.MenuGlowStrength or 35, Library.MenuGlowEnabled ~= false)
            end

            return ESPPreview
        end

        Library.ResolveLogo = function(Self, Value)
            local Logo = tostring(Value or "")
            if Logo == "" then return "" end
            if Logo:match("^rbxassetid://") or Logo:match("^rbxasset://") then return Logo end
            if Logo:match("^%d+$") then return "rbxassetid://" .. Logo end
            if Logo:match("^https?://") then
                -- A Roblox ImageLabel does not render arbitrary GitHub URLs directly.
                -- Download PNG once and convert to a local asset when supported.
                Library.LogoCache = Library.LogoCache or {}
                if Library.LogoCache[Logo] then return Library.LogoCache[Logo] end
                local Ok, Result = pcall(function()
                    if not (writefile and getcustomasset) then return "" end
                    local FetchUrl = Logo
                    local Repo, Branch, Asset = Logo:match("^https?://github%.com/([^/]+/[^/]+)/blob/([^/]+)/(.+)$")
                    if Repo and Branch and Asset then
                        FetchUrl = "https://raw.githubusercontent.com/" .. Repo .. "/" .. Branch .. "/" .. Asset
                    end
                    local Hash = 0
                    for Index = 1, #FetchUrl do
                        Hash = (Hash * 33 + string.byte(FetchUrl, Index)) % 2147483647
                    end
                    local File = Library.Directory .. "/Assets/brand_logo_" .. tostring(Hash) .. ".png"
                    -- Cache by URL, use different files per image.
                    local Data = game:HttpGet(FetchUrl)
                    writefile(File, Data)
                    return getcustomasset(File)
                end)
                if Ok and Result ~= "" then
                    Library.LogoCache[Logo] = Result
                    return Result
                end
                warn("[mimisense] Could not load remote logo: " .. Logo)
                return ""
            end
            return Logo
        end

        Library.Window = function(Self, Params)
            Params = Params or { }

            -- Choose the palette BEFORE creating any GUI objects, eliminating
            -- the startup flash of the previous theme.
            -- Priority: Window.Theme > saved default.txt > SetStartupTheme > Default.
            local ExplicitTheme = Params.Theme
            if ExplicitTheme == nil then ExplicitTheme = Params.theme end
            local HasThemeOverride = ExplicitTheme ~= nil
            local StartupThemeData = type(ExplicitTheme) == "table" and ExplicitTheme or nil
            local ThemeName = (type(ExplicitTheme) == "string" and ExplicitTheme)
                or Library:GetDefaultTheme()
                or Library.StartupTheme
                or "Default"
            if ThemeName == "default" or ThemeName == "defoult" then ThemeName = "Default" end
            if not Library:ApplyNamedTheme(ThemeName) then
                warn("[mimisense] Startup theme " .. tostring(ThemeName) .. " not found; using Default")
                ThemeName = "Default"
                Library:ApplyTheme("Default")
            end
            if StartupThemeData then
                -- Custom colors override the base theme; unspecified keys stay Default.
                Library:ApplyTheme("Default")
                Library:ApplyThemeData(StartupThemeData)
                ThemeName = "Default"
            end

            -- Optional per-window font, applied before creating any text labels.
            local RequestedFont = Params.Font or Params.font
            if type(RequestedFont) == "string" and RequestedFont ~= "" then
                if table.find(Library.FontChoices or {}, RequestedFont) then
                    Library:SetUIFont(RequestedFont)
                else
                    warn("[mimisense] Unknown window font: " .. RequestedFont)
                    RequestedFont = nil
                end
            end

            local Window = {
                StartupTheme = ThemeName,
                StartupThemeData = StartupThemeData,
                HasStartupThemeOverride = HasThemeOverride,
                StartupFont = RequestedFont,
                Name = Params.Name or Params.name or "Window",
                SubName = Params.SubName or Params.subname or "",
                Logo = Params.Logo or Params.logo or "rbxassetid://87164893498141",

                IsOpen = true,
                Pages = { },
                Items = { }
            }

            local Items = { } do
                if IsMobile then
                    Library:Create("UIScale", {
                        Parent = Library.Holder.Instance,
                        Scale = 0.65
                    })
                end

                Items["MainFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 560, 0, 560),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                -- Resize handled by the small footer grip only.
                -- High-Z edge handles previously obscured colorpickers and dropdowns.

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    CornerRadius = UDim.new(0, 10)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Round
                }):AddToTheme({Color = 'Outline'})

                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Size = UDim2.new(1, 0, 0, 55),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })

                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    ImageColor3 = Color3.new(1, 1, 1),
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Library:ResolveLogo(Window.Logo),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0.5, 0),
                    Size = UDim2.new(0, 30, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Text"]
                })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 4,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Window.Name,
                    Position = UDim2.new(0, 52, 0, 10),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({TextColor3 = 'Text'})

                Items["SubTitle"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Window.SubName,
                    Position = UDim2.new(0, 52, 0, 30),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({TextColor3 = 'Inactive Text'})

                -- Move the main window ONLY by dragging its top bar.
                Items["MainFrame"]:MakeDraggable(Items["Top"])

                Items["Pages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Text"]
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    PaddingRight = UDim.new(0, 10)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 56),
                    Size = UDim2.new(1, 0, 1, -83),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({BackgroundColor3 = 'Text'})

                Window.Items = Items

                -- Minimal footer: editable version/status text and a dedicated resize grip.
                local Footer = Instance.new("Frame")
                Footer.Name = "MimisenseFooter"
                Footer.AnchorPoint = Vector2.new(0, 1)
                Footer.Position = UDim2.new(0, 0, 1, 0)
                Footer.Size = UDim2.new(1, 0, 0, 24)
                Footer.ClipsDescendants = true
                Footer.BackgroundTransparency = 0
                Footer.BackgroundColor3 = Library.Theme["Background"]
                Footer.BorderSizePixel = 0
                Footer.ZIndex = 2
                Footer.Parent = Items["MainFrame"].Instance
                -- Rounded bottom edge; avoid the rectangular footer covering the main corner.
                local FooterCorner = Instance.new("UICorner")
                FooterCorner.CornerRadius = UDim.new(0, 10)
                FooterCorner.Parent = Footer
                Library.AddToTheme({Instance = Footer}, {BackgroundColor3 = "Background"})

                -- Footer is rounded only at the bottom. Without this cap,
                -- the top rounded corners let scrolling content show through.
                local FooterTopFill = Instance.new("Frame")
                FooterTopFill.Name = "FooterTopFill"
                FooterTopFill.BorderSizePixel = 0
                FooterTopFill.BackgroundColor3 = Library.Theme["Background"]
                FooterTopFill.Size = UDim2.new(1, 0, 0, 12)
                FooterTopFill.Position = UDim2.fromOffset(0, 0)
                FooterTopFill.ZIndex = 2
                FooterTopFill.Parent = Footer
                Library.AddToTheme({Instance = FooterTopFill}, {BackgroundColor3 = "Background"})

                local FooterText = Instance.new("TextLabel")
                FooterText.Name = "VersionText"
                FooterText.BackgroundTransparency = 1
                FooterText.BorderSizePixel = 0
                
                FooterText.Text = tostring(Library.CustomVersionLabel or "mimisense · v27")
                
                FooterText.TextColor3 = Library.Theme["Inactive Text"]
                FooterText.FontFace = Library.Font
                FooterText.TextSize = Library.FontSize - 1
                FooterText.TextXAlignment = Enum.TextXAlignment.Center
                FooterText.Size = UDim2.new(1, -22, 1, 0)
                FooterText.Position = UDim2.new(0, 0, 0, 0)
                FooterText.ZIndex = 3
                FooterText.Parent = Footer
                local ResizeGrip = Instance.new("TextButton")
                ResizeGrip.Name = "ResizeGrip"
                ResizeGrip.AnchorPoint = Vector2.new(1, 1)
                ResizeGrip.Position = UDim2.new(1, -5, 1, -3)
                ResizeGrip.Size = UDim2.new(0, 17, 0, 15)
                ResizeGrip.BackgroundTransparency = 1
                ResizeGrip.BorderSizePixel = 0
                ResizeGrip.AutoButtonColor = false
                ResizeGrip.Text = "↘"
                ResizeGrip.TextColor3 = Library.Theme["Inactive Text"]
                ResizeGrip.FontFace = Library.Font
                ResizeGrip.TextSize = Library.FontSize + 2
                ResizeGrip.ZIndex = 3 -- Colorpicker and dropdown windows always render above this grip.
                ResizeGrip.Parent = Footer
                ResizeGrip.MouseEnter:Connect(function()
                    ResizeGrip.TextColor3 = Library.Theme["Accent"]
                end)
                ResizeGrip.MouseLeave:Connect(function()
                    ResizeGrip.TextColor3 = Library.Theme["Inactive Text"]
                end)
                local GripDragging = false
                local GripStartMouse, GripStartSize
                ResizeGrip.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        GripDragging = true
                        GripStartMouse = Input.Position
                        GripStartSize = Items["MainFrame"].Instance.Size
                        Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then GripDragging = false end
                        end)
                    end
                end)
                Library:Connect(UserInputService.InputChanged, function(Input)
                    if not GripDragging then return end
                    if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
                    local Frame = Items["MainFrame"].Instance
                    local View = Library.Holder.Instance.AbsoluteSize
                    local ScaleObject = Frame:FindFirstChild("UserScale")
                    local Scale = ScaleObject and ScaleObject.Scale or 1
                    local Delta = (Input.Position - GripStartMouse) / Scale
                    local Width = math.clamp(GripStartSize.X.Offset + Delta.X, 420, math.max(420, View.X / Scale + 250))
                    local Height = math.clamp(GripStartSize.Y.Offset + Delta.Y, 360, math.max(360, View.Y / Scale + 250))
                    Frame.Size = UDim2.fromOffset(math.floor(Width + 0.5), math.floor(Height + 0.5))
                end)
            end

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Window.IsOpen = Bool
                Items["MainFrame"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)

                for Index, Value in Library.OpenFrames do
                    Value:SetOpen(false)
                end
            end

            function Window:Center()
                Items["MainFrame"]:ConvertAnchor()
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:Center()
            Library.ActiveWindow = Window
            return setmetatable(Window, Library)
        end

        -- Mascot: картинка на углу окна. Нажимается (сжимается) и плавно включается/выключается.
        -- Window:Mascot({Url = "https://.../mimi.png", Size = Vector2.new(120, 120), Offset = Vector2.new(6, 12)})
        --   Url        - ссылка на картинку (скачивается и кешируется в Assets) или rbxassetid://...
        --   Size       - размер картинки в пикселях
        --   Offset     - X: отступ от левого края окна, Y: насколько низ картинки заходит ВНИЗ на окно (минус = выше)
        --   PressScale - во сколько раз меняется ширина/высота при нажатии (по умолчанию 1.05 / 0.88)
        --   Callback   - функция при клике
        -- PNG и JPG поддерживаются; JPG просто не имеет прозрачности.
        -- Mascot registry.
        -- Add mascots with:
        -- Mascots = {
        --     mimi = "https://.../mimi.png",
        --     kitty = { Url = "https://.../kitty.jpg", Size = 140, Offset = Vector2.new(10, 20), ZIndex = 3, ClickSound = "123" },
        -- }
        -- A mascot does NOT need to be hard-coded into the library. Example/config only provides the registry.
        Library.Mascot = function(Self, Params)
            Params = Params or { }

            local Mascots = Params.Mascots or Params.mascots or { }
            local DefaultMascot = Params.DefaultMascot or Params.defaultMascot or Params.Mascot or Params.mascot

            -- If only Url was supplied, turn it into a one-entry registry for backwards compatibility.
            if next(Mascots) == nil and (Params.Url or Params.url) then
                Mascots = {
                    mascot = {
                        Url = Params.Url or Params.url,
                        Size = Params.Size or Params.size,
                        Offset = Params.Offset or Params.offset,
                        ZIndex = Params.ZIndex or Params.zindex,
                        ClickSound = Params.ClickSound or Params.clickSound
                    }
                }
                DefaultMascot = DefaultMascot or "mascot"
            end

            if not DefaultMascot then
                for Name in Mascots do
                    DefaultMascot = Name
                    break
                end
            end

            local Mascot = {
                Url = "",
                Rotation = Params.Rotation or Params.rotation or 0,
                Size = Params.Size or Params.size or Vector2.new(120, 120),
                Offset = Params.Offset or Params.offset or Vector2.new(-222, -333),
                ZIndex = Params.ZIndex or Params.zindex or 3,
                PressScale = Params.PressScale or Params.pressscale or Vector2.new(1.05, 0.88),
                Callback = Params.Callback or Params.callback or function() end,
                Mascots = Mascots,
                CurrentMascot = DefaultMascot,
                DefaultMascot = DefaultMascot,

                Window = Self,
                Visible = Params.Visible ~= false,
                Loaded = false,
                Items = { }
            }

            -- accept numbers as well as Vector2 for Size / PressScale
            if type(Mascot.Size) == "number" then
                Mascot.Size = Vector2.new(Mascot.Size, Mascot.Size)
            end
            if type(Mascot.PressScale) == "number" then
                Mascot.PressScale = Vector2.new(Mascot.PressScale, Mascot.PressScale)
            end
            if typeof(Mascot.Offset) ~= "Vector2" then
                Mascot.Offset = Vector2.new(-222, -333)
            end

            Mascot.InitialSize = Mascot.Size.X
            Mascot.InitialOffset = Mascot.Offset
            -- Capture the initial visual center once. Resizing should NOT move the mascot
            -- relative to the top-left edge of the window.
            local WindowFrame = Self.Items["MainFrame"].Instance
            Mascot.AnchorOrigin = Vector2.new(WindowFrame.Size.X.Offset / 2, WindowFrame.Size.Y.Offset / 2)
            local function MascotPosition(X, Y)
                return UDim2.fromOffset(Mascot.AnchorOrigin.X + X, Mascot.AnchorOrigin.Y + Y)
            end

            local ShowInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local HideInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            local PressInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local ReleaseInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

            local BaseSize = UDim2.new(0, Mascot.Size.X, 0, Mascot.Size.Y)
            local PressedSize = UDim2.new(0, Mascot.Size.X * Mascot.PressScale.X, 0, Mascot.Size.Y * Mascot.PressScale.Y)

            local Items = { } do
                Items["Image"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Self.Items["MainFrame"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = MascotPosition(Mascot.Offset.X, Mascot.Offset.Y),
                    Size = BaseSize,
                    Rotation = Mascot.Rotation,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    ScaleType = Enum.ScaleType.Fit,
                    Image = "",
                    ImageTransparency = 1,
                    Visible = false,
                    ZIndex = Mascot.ZIndex
                })

                Items["Scale"] = Library:Create("UIScale", {
                    Name = "\0",
                    Parent = Items["Image"].Instance,
                    Scale = 0.85
                })

                Mascot.Items = Items
            end

            local Token = 0

            local function Show()
                Token += 1
                Items["Image"].Instance.Visible = true
                Items["Image"].Instance.Active = true
                Items["Scale"]:Tween({Scale = 1}, ShowInfo)
                Items["Image"]:Tween({ImageTransparency = 0}, ShowInfo)
            end

            local function Hide()
                Token += 1
                local Mine = Token
                Items["Image"].Instance.Active = false
                Items["Scale"]:Tween({Scale = 0.85}, HideInfo)
                Items["Image"]:Tween({ImageTransparency = 1}, HideInfo)
                task.delay(HideInfo.Time + 0.05, function()
                    if Library and Token == Mine then
                        Items["Image"].Instance.Visible = false
                    end
                end)
            end

            function Mascot:SetVisibility(Bool)
                Bool = Bool and true or false
                Mascot.Visible = Bool
                if not Mascot.Loaded and Items["Image"].Instance.Image == "" then
                    return
                end
                if Bool then Show() else Hide() end
            end

            local Pressed = false
            local function Squish()
                if Pressed then return end
                Pressed = true
                Items["Image"]:Tween({Size = PressedSize}, PressInfo)
            end
            local function Release()
                if not Pressed then return end
                Pressed = false
                Items["Image"]:Tween({Size = BaseSize}, ReleaseInfo)
            end

            Items["Image"]:Connect("MouseButton1Down", Squish)
            Items["Image"]:Connect("MouseButton1Up", Release)
            Items["Image"]:Connect("MouseLeave", Release)
            Items["Image"]:Connect("MouseButton1Click", function()
                Library:PlayMascotClickSound()
                Library:SafeCall(Mascot.Callback)
            end)

            local function Fail(Text)
                warn("[Library] Mascot: " .. Text)
            end

            local function LoadImage(TargetUrl)
                local Url = tostring(TargetUrl or "")
                if Url == "" then return nil end

                if Url:match("^rbxasset") or Url:match("^rbxthumb") then
                    return Url
                end

                local GetAsset = getcustomasset or getsynasset
                if not (writefile and GetAsset and isfile) then
                    Fail("executor doesn't support writefile + getcustomasset/getsynasset")
                    return nil
                end

                if isfile(Url) then
                    local AssetOk, Asset = pcall(GetAsset, Url)
                    if AssetOk and Asset then return Asset end
                end

                local function Download(TargetUrl)
                    local Separator = TargetUrl:find("?", 1, true) and "&" or "?"
                    local Success, Data = pcall(game.HttpGet, game, TargetUrl .. Separator .. "v=" .. os.time())
                    if Success and type(Data) == "string" and #Data >= 16 then
                        return Data
                    end

                    if request then
                        local Ok, Response = pcall(request, {Url = TargetUrl, Method = "GET"})
                        if Ok and Response and tonumber(Response.StatusCode or 0) >= 200 and tonumber(Response.StatusCode or 0) < 300 and type(Response.Body) == "string" then
                            return Response.Body
                        end
                    end
                    return nil
                end

                Library.MascotAssetCache = Library.MascotAssetCache or { }
                if Library.MascotAssetCache[Url] then
                    return Library.MascotAssetCache[Url]
                end

                local Data = Download(Url)
                if not Data and Url:lower():match("%.jpe?g$") then
                    local PngUrl = Url:gsub("%.[jJ][pP][eE][gG]$", ".png"):gsub("%.[jJ][pP][gG]$", ".png")
                    Data = Download(PngUrl)
                end

                if not Data then
                    Fail("failed to download image: " .. Url)
                    return nil
                end

                local IsPng = Data:sub(1, 8) == "\137PNG\r\n\26\n"
                local IsJpg = Data:byte(1) == 255 and Data:byte(2) == 216
                if not IsPng and not IsJpg then
                    Fail("file is not a PNG/JPG: " .. Url)
                    return nil
                end

                local Folder = Library.Directory .. Library.Folders.Assets
                pcall(function()
                    if isfolder and not isfolder(Folder) then makefolder(Folder) end
                end)

                local SafeName = Url:match("([^/?#]+)%.[^/?#]+$") or (Mascot.CurrentMascot or "mascot")
                SafeName = SafeName:gsub("[^%w_%-]", "_")
                local Path = Folder .. "/mascot_" .. SafeName .. (IsPng and ".png" or ".jpg")
                pcall(writefile, Path, Data)

                if not isfile(Path) then
                    Fail("failed to save image: " .. Path)
                    return nil
                end

                local AssetOk, Asset = pcall(GetAsset, Path)
                if not AssetOk or not Asset then
                    Fail("failed to create custom asset: " .. Path)
                    return nil
                end
                Library.MascotAssetCache[Url] = Asset
                return Asset
            end

            function Mascot:GetNames()
                local Names = { }
                for Name in Mascot.Mascots do
                    table.insert(Names, tostring(Name))
                end
                table.sort(Names)
                return Names
            end

            function Mascot:Add(Name, Data)
                if not Name or Name == "" then return false end
                if type(Data) == "string" then
                    Data = {Url = Data}
                elseif type(Data) ~= "table" then
                    return false
                end
                Mascot.Mascots[tostring(Name)] = Data
                return true
            end

            function Mascot:GetCenteredPosition()
                return Mascot.Offset.X, Mascot.Offset.Y
            end

            function Mascot:SetCenteredPosition(X, Y)
                X = tonumber(X) or 0
                Y = tonumber(Y) or 0

                Mascot.Offset = Vector2.new(X, Y)
                Items["Image"].Instance.Position = MascotPosition(X, Y)
                Items["Image"].Instance.ZIndex = Mascot.ZIndex
            end

            function Mascot:SetPosition(X, Y, Z)
                local NewX = tonumber(X)
                local NewY = tonumber(Y)
                local NewZ = tonumber(Z)

                if NewX and NewX == NewX and NewX ~= math.huge and NewX ~= -math.huge then
                    Mascot.Offset = Vector2.new(NewX, Mascot.Offset.Y)
                end
                if NewY and NewY == NewY and NewY ~= math.huge and NewY ~= -math.huge then
                    Mascot.Offset = Vector2.new(Mascot.Offset.X, NewY)
                end
                if NewZ and NewZ == NewZ and NewZ ~= math.huge and NewZ ~= -math.huge then
                    Mascot.ZIndex = math.clamp(NewZ, 1, 100)
                end

                -- Coordinates keep their original center-based API, but screen position
                -- is now resolved from the FIXED initial window size, not the live size.
                Items["Image"].Instance.Position = MascotPosition(Mascot.Offset.X, Mascot.Offset.Y)
                Items["Image"].Instance.ZIndex = Mascot.ZIndex

                if Mascot.Visible and Mascot.Loaded then
                    Items["Image"].Instance.Visible = true
                    Items["Image"].Instance.Active = true
                    Items["Image"].Instance.ImageTransparency = 0
                end
            end

            function Mascot:SetSize(Value)
                local Number = math.max(1, tonumber(Value) or Mascot.Size.X)
                Mascot.Size = Vector2.new(Number, Number)
                BaseSize = UDim2.new(0, Number, 0, Number)
                PressedSize = UDim2.new(0, Number * Mascot.PressScale.X, 0, Number * Mascot.PressScale.Y)
                Items["Image"].Instance.Size = BaseSize
                Mascot:SetPosition(Mascot.Offset.X, Mascot.Offset.Y, Mascot.ZIndex)
                if Mascot.Visible and Mascot.Loaded then
                    Items["Image"].Instance.Visible = true
                    Items["Image"].Instance.Active = true
                    Items["Image"].Instance.ImageTransparency = 0
                end
            end

            function Mascot:SetRotation(Value)
                local Number = tonumber(Value)
                if not Number or Number ~= Number or Number == math.huge or Number == -math.huge then
                    return
                end
                Mascot.Rotation = math.clamp(Number, -180, 180)
                Items["Image"].Instance.Rotation = Mascot.Rotation
            end

            function Mascot:SetClickSoundVolume(Value)
                local Number = tonumber(Value)
                if not Number then return end
                Mascot.ClickSoundVolume = math.clamp(Number, 0, 1)
                if Library.MascotClickSound then
                    Library.MascotClickSound.Volume = Mascot.ClickSoundVolume
                end
            end

            function Mascot:SetClickSound(SoundId)
                Mascot.ClickSound = SoundId
                return Library:SetMascotClickSound(SoundId)
            end

            local LoadToken = 0

            function Mascot:SetUrl(Url)
                Mascot.Url = tostring(Url or "")
                Mascot.Loaded = false

                LoadToken += 1
                local Mine = LoadToken

                task.spawn(function()
                    local Asset = LoadImage(Mascot.Url)
                    -- a newer SetUrl call won the race, drop this result
                    if not Library or Mine ~= LoadToken or not Asset or not Items["Image"].Instance.Parent then
                        return
                    end

                    Items["Image"].Instance.Image = Asset
                    Mascot.Loaded = true
                    if Mascot.Visible then
                        Show()
                    end
                end)
            end

            local ToNumber = function(Value, Fallback)
                if typeof(Value) == "Vector2" then
                    return Value.X
                end
                return tonumber(Value) or Fallback
            end

            -- KeepTransform = true keeps the current size / rotation / position (only swaps image + sound)
            function Mascot:SetMascot(Name, KeepTransform)
                local Data = Mascot.Mascots and Mascot.Mascots[Name]
                if type(Data) == "string" then Data = {Url = Data} end
                if type(Data) ~= "table" or not Data.Url then return false end

                Mascot.CurrentMascot = Name

                if not KeepTransform then
                    Mascot:SetSize(ToNumber(Data.Size, Mascot.Size.X))
                    Mascot:SetRotation(Data.Rotation or Data.rotation or Mascot.Rotation or 0)
                    local Offset = typeof(Data.Offset) == "Vector2" and Data.Offset or Mascot.Offset
                    Mascot:SetPosition(Offset.X, Offset.Y, Data.ZIndex or Mascot.ZIndex)
                end

                Mascot:SetClickSound(Data.ClickSound or Params.ClickSound or "102774986031312")
                Mascot:SetClickSoundVolume(Data.ClickSoundVolume or Data.clickSoundVolume or Mascot.ClickSoundVolume or Library.MascotClickVolume or 0.8)
                Mascot:SetUrl(Data.Url)
                return true
            end

            -- back to the values the registry / constructor was created with
            function Mascot:ResetToDefault()
                local Name = Mascot.DefaultMascot or Mascot.CurrentMascot
                local Data = Mascot.Mascots and Mascot.Mascots[Name]
                if type(Data) == "string" then Data = {Url = Data} end
                if type(Data) ~= "table" or not Data.Url then return false end

                local Offset = typeof(Data.Offset) == "Vector2" and Data.Offset or Mascot.InitialOffset

                Mascot:SetSize(ToNumber(Data.Size, Mascot.InitialSize))
                Mascot:SetRotation(Data.Rotation or Data.rotation or 0)
                Mascot:SetPosition(Offset.X, Offset.Y, Data.ZIndex or 3)

                local Volume = Data.ClickSoundVolume or Data.clickSoundVolume or 0.8
                Mascot:SetClickSoundVolume(Volume)
                Library:SetMascotClickVolume(Volume)

                return Mascot:SetMascot(Name, true)
            end

            function Mascot:GetState()
                return {
                    Name = Mascot.CurrentMascot,
                    X = Mascot.Offset.X,
                    Y = Mascot.Offset.Y,
                    Rotation = Mascot.Rotation,
                    Size = Mascot.Size.X,
                    ClickSoundVolume = Mascot.ClickSoundVolume or Library.MascotClickVolume or 0.8
                }
            end

            if Mascot.CurrentMascot and Mascot.Mascots[Mascot.CurrentMascot] then
                task.spawn(function()
                    Mascot:SetMascot(Mascot.CurrentMascot)
                end)
            end

            -- No AbsoluteSize listener: resizing and the bottom-right grip must not
            -- influence the mascot's placement.

            Self.Mascot = Mascot
            Mascot:SetPosition(Mascot.Offset.X, Mascot.Offset.Y, Mascot.ZIndex)
            Mascot:SetRotation(Mascot.Rotation)
            return setmetatable(Mascot, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",
                Icon = Params.Icon or Params.icon or "",

                Window = Self,
                ColumnsData = { },
                Items = { },
                Active = false,
                Debounce = false
            }

            local Items = { } do
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Window.Items["Pages"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 35, 0, 35),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance
                })

                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 1),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})
                if not Library:ApplyIcon(Items["Icon"].Instance, Page.Icon) then
                    Items["Icon"].Instance.Image = "rbxassetid://132783180980031"
                end

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 2,
                    Parent = Items["Inactive"].Instance,
                    Visible = true,
                    TextTransparency = 1,
                    AnchorPoint = Vector2.new(0, 0.5),
                    TextColor3 = Library.Theme["Text"],
                    Text = Page.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 30, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 25)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                local Layout = Items["LeftColumn"].Instance:FindFirstChildOfClass("UIListLayout")
                if Layout then
                    Library:Connect(Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                        local Scroller = Items["LeftColumn"].Instance
                        Scroller.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 48)
                    end)
                end

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 25)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                local Layout = Items["RightColumn"].Instance:FindFirstChildOfClass("UIListLayout")
                if Layout then
                    Library:Connect(Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                        local Scroller = Items["RightColumn"].Instance
                        Scroller.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 48)
                    end)
                end

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            local GetSize = function()
                local AbsSize = Items["Inactive"].Instance.AbsoluteSize
                Items["Inactive"].Instance.Size = UDim2.new(0, 35, 0, 35)
                task.wait()
                Items["Inactive"].Instance.AutomaticSize = Enum.AutomaticSize.None

                return AbsSize
            end

            Items["Inactive"]:OnHover(function()
                if Page.Active then return end

                Items["Icon"]:Tween({ImageColor3 = Library.Theme.Text})
                Items["Inactive"]:Tween({BackgroundTransparency = 0})
            end, function()
                if Page.Active then return end

                Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})
                Items["Inactive"]:Tween({BackgroundTransparency = 1})
            end)

            local Size = GetSize()
            local X = Size.X

function Page:Turn()
    local Old = Page.Window.Current

    if Old == Page then return end
    if Page.Debounce then return end
    if Old and Old.Debounce then return end

    Page.Debounce = true

    if Old then
        Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Inactive Text"})
        Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})

        Old.Items["Inactive"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 35, 0, 35)})
        Old.Items["Text"]:Tween({TextTransparency = 1})

        Old.Items["Page"]:FadeDescendants(false, function()
            Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
        end)

        Old.Active = false
    end

    Items["Text"].Instance.Visible = true

    local TextWidth = Items["Text"].Instance.TextBounds.X
    if TextWidth <= 0 then
        TextWidth = #(Page.Name) * ((Library.FontSize + 2) * 0.65)
    end

    local TabWidth = math.max(35, math.ceil(58 + TextWidth))

    Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
    Items["Page"].Instance.Visible = true
    Items["Page"]:FadeDescendants(true, function()
        Page.Debounce = false
    end)

    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
    Items["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})

    Items["Inactive"]:Tween({
        BackgroundTransparency = 0,
        Size = UDim2.new(0, TabWidth, 0, 35)
    })
    Items["Text"]:Tween({TextTransparency = 0})

    Page.Window.Current = Page
    Page.Active = true

    if Library.QueueSaveUIState then
        Library:QueueSaveUIState()
    end
end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then
                -- First page must be visible immediately; never depend on a fade callback.
                Page.Window.Current = Page
                Page.Active = true
                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Page"].Instance.Visible = true
                Items["Text"].Instance.Visible = true
                Items["Text"].Instance.TextTransparency = 0
                Items["Icon"].Instance.ImageColor3 = Library.Theme["Accent"]
                Items["Inactive"].Instance.BackgroundTransparency = 0
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

-- Built-in names use the icon IDs published by icons.rest.
-- The optional Icons.lua remote module can extend this to the full catalog.
Library.Lucide = {
    ["accessibility"] = "10709751939",
    ["activity"] = "10709752035",
    ["air-vent"] = "10709752131",
    ["alarm-clock"] = "10709752630",
    ["alarm-clock-off"] = "10709752508",
    ["alarm-minus"] = "10709752732",
    ["alert-circle"] = "10709752996",
    ["align-center"] = "10709753570",
    ["align-left"] = "10709759764",
    ["book-open"] = "84762150530577",
    ["bot"] = "70979486241131",
    ["briefcase"] = "78701740878808",
    ["calendar"] = "126460151885084",
    ["camera"] = "114084146151777",
    ["check"] = "86817768619372",
    ["chevron-down"] = "71457658246709",
    ["chevron-left"] = "102314312897830",
    ["chevron-right"] = "101007429951147",
    ["chevron-up"] = "98648581502859",
    ["circle-check"] = "88244323237265",
    ["code"] = "75851496262862",
    ["cog"] = "123222732420633",
    ["copy"] = "116378866141355",
    ["crosshair"] = "83752373575368",
    ["eye"] = "127234874352422",
    ["file"] = "108499043987115",
    ["folder"] = "77937190465422",
    ["github"] = "140138081031269",
    ["globe"] = "125685532120024",
    ["heart"] = "88525382655929",
    ["home"] = "109841253338329",
    ["image"] = "114022611279795",
    ["info"] = "120620848266512",
    ["key"] = "83474888140571",
    ["layout-dashboard"] = "70433574792490",
    ["link"] = "86131768436965",
    ["list"] = "101699539545687",
    ["lock"] = "119765975153029",
    ["log-out"] = "140299936053191",
    ["mail"] = "77537514051485",
    ["package"] = "106101842173393",
    ["palette"] = "127369887384101",
    ["play"] = "76386816441302",
    ["plus"] = "101123124881873",
    ["power"] = "89331085993646",
    ["save"] = "122894934359450",
    ["search"] = "72296609649861",
    ["settings"] = "106205298246017",
    ["settings-2"] = "109485777305919",
    ["shield"] = "106509993556171",
    ["shopping-cart"] = "79435149356304",
    ["sliders-horizontal"] = "125396339381135",
    ["star"] = "72669221096319",
    ["target"] = "121091323240554",
    ["terminal"] = "102379915564176",
    ["trash"] = "94712995845562",
    ["trash-2"] = "126010725826757",
}

Library.RegisterLucideIcons = function(Self, Icons)
    if type(Icons) ~= "table" then return false end
    for Name, Id in Icons do
        local Key = tostring(Name):lower():gsub("^lucide%-", ""):gsub("_", "-")
        local Number = tostring(Id):match("(%d+)")
        if Number then
            Library.Lucide[Key] = Number
            Library.IconCache[Key] = nil
        end
    end
    return true
end

-- ICONS ------------------------------------------------------
-- Icon может быть: "eye" (название из Icons.lua), "rbxassetid://123", 123 (число), "rbxthumb://..."
-- GetIcon возвращает таблицу {Image, ImageRectSize, ImageRectOffset} или nil
Library.IconCache = { }

-- Показывает проблему с иконками прямо на экране (консоль смотреть не нужно)
Library.IconError = function(Self, Text)
    warn("[Library] " .. Text)
    pcall(function()
        Library:Notification({
            Name = "Icons",
            Description = Text,
            Duration = 8,
            Color = Color3.fromRGB(255, 80, 80)
        })
    end)
end

Library.LoadIcons = function(Self)
    if Library.IconModule ~= nil then
        return Library.IconModule or nil
    end

    local Success, Module = false, nil
    for _, Url in {
        Library.IconsUrl,
        "https://raw.githubusercontent.com/xolylol/dogy-visuals-ui/main/Icons.lua"
    } do
        Success, Module = pcall(function()
            return loadstring(game:HttpGet(Url))()
        end)
        if Success and type(Module) == "table" and type(Module.Get) == "function" then
            break
        end
    end
    if Success and type(Module) == "table" and type(Module.Get) == "function" then
        Library.IconModule = Module
    else
        Library.IconModule = false
        warn("[mimisense] Optional Icons.lua unavailable: " .. tostring(Module):sub(1, 150))
    end

    return Library.IconModule or nil
end

Library.GetIcon = function(Self, Icon)
    if Icon == nil or Icon == "" then
        return nil
    end

    if type(Icon) == "number" then
        return { Image = "rbxassetid://" .. tostring(Icon) }
    end

    if type(Icon) ~= "string" then
        return nil
    end

    if Icon:match("^rbxasset") or Icon:match("^rbxthumb") or Icon:match("^https?://") then
        return { Image = Icon }
    end

    local Key = Icon:lower():gsub("^lucide%-", ""):gsub("_", "-"):gsub("%s+", "-")
    local Cached = Library.IconCache[Key]
    if Cached ~= nil then return Cached or nil end

    local Builtin = Library.Lucide[Key]
    if Builtin then
        local Data = {Image = "rbxassetid://" .. tostring(Builtin)}
        Library.IconCache[Key] = Data
        return Data
    end

    -- The optional Github Icons.lua module may contain many more icons.
    local Module = Library:LoadIcons()
    local Data = Module and (Module.Get(Key) or Module.Get("lucide-" .. Key)) or nil
    if type(Data) == "string" then
        Data = {Image = Data}
    end
    Library.IconCache[Key] = Data or false
    return Data
end

-- Применяет иконку к уже созданному ImageLabel
Library.ApplyIcon = function(Self, ImageInstance, Icon)
    local Data = Library:GetIcon(Icon)
    if not Data then
        return false
    end

    ImageInstance.Image = Data.Image
    if Data.ImageRectSize then
        ImageInstance.ImageRectSize = Data.ImageRectSize
        ImageInstance.ImageRectOffset = Data.ImageRectOffset or Vector2.new(0, 0)
    end

    return true
end
---------------------------------------------------------------

-- chevron used by sections and dropdowns (lucide icon, text fallback when Icons.lua is missing)
Library.CreateArrow = function(Self, Data)
    local IconData = Library:GetIcon(Data.Icon or "chevron-down")
    local Color = Data.Color or "Text"
    local Arrow, Property

    if IconData then
        Property = "ImageColor3"
        Arrow = Library:Create("ImageLabel", {
            Name = "\0",
            Parent = Data.Parent,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = Data.Position,
            Size = UDim2.new(0, Data.Size, 0, Data.Size),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Image = IconData.Image,
            ImageRectSize = IconData.ImageRectSize or Vector2.new(0, 0),
            ImageRectOffset = IconData.ImageRectOffset or Vector2.new(0, 0),
            ImageColor3 = Library.Theme[Color]
        })
    else
        Property = "TextColor3"
        Arrow = Library:Create("TextLabel", {
            Name = "\0",
            FontFace = Library.Font,
            TextSize = Data.Size,
            Parent = Data.Parent,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = Data.Position,
            Size = UDim2.new(0, Data.Size, 0, Data.Size),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = (Data.Icon == "chevron-up") and "^" or "v",
            TextColor3 = Library.Theme[Color]
        })
    end

    Arrow:AddToTheme({[Property] = Color})
    Arrow.ColorProperty = Property

    return Arrow
end

Library.Section = function(Self, Params)
    Params = Params or { }

    local Section = {
        Name = Params.Name or Params.name or "Section",
        Side = Params.Side or Params.side or 1,
        Icon = Params.Icon or Params.icon or "folder",

        -- arrow in the header: click to fold / unfold (Collapsible = false hides it, Collapsed = true starts folded)
        Collapsible = Params.Collapsible ~= false and Params.collapsible ~= false,
        Collapsed = false,

        Window = Self.Window,
        Page = Self,
        Items = { },
    }

    local IconData = Library:GetIcon(Section.Icon)
    local HasIcon = IconData ~= nil

    local Items = { } do
        Items["Section"] = Library:Create("Frame", {
            Name = "\0",
            Parent = Section.Page.ColumnsData[Section.Side].Instance,
            Size = UDim2.new(1, 0, 0, 75),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Library.Theme["Inline"]
        }):AddToTheme({BackgroundColor3 = 'Inline'})

        Library:Create("UICorner", {
            Name = "\0",
            Parent = Items["Section"].Instance
        })

        Items["Top"] = Library:Create("Frame", {
            Name = "\0",
            Parent = Items["Section"].Instance,
            Size = UDim2.new(1, 0, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme["Tab"]
        }):AddToTheme({BackgroundColor3 = 'Tab'})

        Library:Create("UICorner", {
            Name = "\0",
            Parent = Items["Top"].Instance,
            BottomRightRadius = UDim.new(0, 0),
            BottomLeftRadius = UDim.new(0, 0)
        })

        if HasIcon then
            Items["Icon"] = Library:Create("ImageLabel", {
                Name = "\0",
                Parent = Items["Top"].Instance,
                ImageColor3 = Library.Theme["Accent"],
                AnchorPoint = Vector2.new(0, 0.5),
                Image = IconData.Image,
                ImageRectSize = IconData.ImageRectSize,
                ImageRectOffset = IconData.ImageRectOffset,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                Size = UDim2.new(0, 18, 0, 18),
                BorderSizePixel = 0
            }):AddToTheme({ImageColor3 = 'Accent'})
        end

        Items["Text"] = Library:Create("TextLabel", {
            Name = "\0",
            FontFace = Library.Font,
            TextSize = Library.FontSize + 2,
            Parent = Items["Top"].Instance,
            TextColor3 = Library.Theme["Text"],
            Text = Section.Name,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, HasIcon and 38 or 12, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY
        }):AddToTheme({TextColor3 = 'Text'})

        if Section.Collapsible then
            Items["Arrow"] = Library:CreateArrow({
                Parent = Items["Top"].Instance,
                Icon = "chevron-down",
                Size = 18,
                Position = UDim2.new(1, -12, 0.5, 0),
                Color = "Text"
            })

            Items["HeaderButton"] = Library:Create("TextButton", {
                Name = "\0",
                FontFace = Library.Font,
                TextSize = Library.FontSize,
                Parent = Items["Top"].Instance,
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                BorderSizePixel = 0
            })
        end

        Items["Content"] = Library:Create("Frame", {
            Name = "\0",
            Parent = Items["Section"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 52),
            Size = UDim2.new(1, -24, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y
        })

        Library:Create("UIListLayout", {
            Name = "\0",
            Parent = Items["Content"].Instance,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Section.Items = Items
    end

    if Section.Collapsible then
        local Debounce = false
        local Content = Items["Content"]
        local Arrow = Items["Arrow"]

        function Section:SetCollapsed(Bool, Instant)
            Bool = Bool and true or false

            if Debounce or Section.Collapsed == Bool then
                return
            end

            Section.Collapsed = Bool

            local SectionInstance = Items["Section"].Instance
            local HeaderHeight = 40

            -- Size offsets are scaled by UIScale, AbsoluteSize is not
            local ToLocal = function(Pixels)
                local Scale = Items["Top"].Instance.AbsoluteSize.Y / HeaderHeight

                if Scale <= 0 then
                    Scale = 1
                end

                return Pixels / Scale
            end

            -- AutomaticSize treats Size as a minimum, so it is dropped while folded
            if Instant then
                Arrow.Instance.Rotation = Bool and -90 or 0
                Content.Instance.Visible = not Bool
                SectionInstance.AutomaticSize = Enum.AutomaticSize.Y
                SectionInstance.Size = UDim2.new(1, 0, 0, Bool and 0 or 75)
                return
            end

            local Info = TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            Arrow:Tween({Rotation = Bool and -90 or 0})

            Debounce = true

            local Finish = function()
                SectionInstance.ClipsDescendants = false
                SectionInstance.AutomaticSize = Enum.AutomaticSize.Y
                SectionInstance.Size = UDim2.new(1, 0, 0, Section.Collapsed and 0 or 75)
                Debounce = false
            end

            -- the section frame animates its height together with the content fade,
            -- so an empty background box never pops in or out
            if Bool then
                local From = ToLocal(SectionInstance.AbsoluteSize.Y)

                SectionInstance.AutomaticSize = Enum.AutomaticSize.None
                SectionInstance.Size = UDim2.new(1, 0, 0, From)
                SectionInstance.ClipsDescendants = true

                Library:Tween({Size = UDim2.new(1, 0, 0, HeaderHeight)}, Info, SectionInstance)
                Content:FadeDescendants(false, Finish)
            else
                SectionInstance.AutomaticSize = Enum.AutomaticSize.None
                SectionInstance.Size = UDim2.new(1, 0, 0, HeaderHeight)
                SectionInstance.ClipsDescendants = true

                task.spawn(function()
                    Content:FadeDescendants(true)

                    -- wait for the layout to measure the content
                    RunService.Heartbeat:Wait()
                    RunService.Heartbeat:Wait()

                    local Target = math.max(75, 52 + ToLocal(Content.Instance.AbsoluteSize.Y))
                    local Tween = Library:Tween({Size = UDim2.new(1, 0, 0, Target)}, Info, SectionInstance)

                    if Tween then
                        Tween.Completed:Wait()
                    else
                        task.wait(Info.Time)
                    end

                    Finish()
                end)
            end
        end

        Items["HeaderButton"]:Connect("MouseButton1Down", function()
            Section:SetCollapsed(not Section.Collapsed)
        end)

        if Params.Collapsed or Params.collapsed then
            Section:SetCollapsed(true, true)
        end
    end

    return setmetatable(Section, Library)
end

        -- ---------- mimisense v25: full-section Tabbox ----------
        -- Page:Tabbox({Side=2, Tabs={"Tab 1", "Tab 2"}})
        -- or ExistingSection:Tabbox({Tabs={...}, FullSection=true})
        -- The tabs REPLACE the entire normal section header. No secondary
        -- sub-card, duplicate header or narrow centered tab bar.
        Library.Tabbox = function(Self, Params)
            Params = Params or {}
            local Host = Self
            if not Host.Items or not Host.Items.Content or not Host.Items.Top then
                error("Tabbox requires a Section. Use Page:Tabbox(...) to create one.")
            end
            if Host.__MimisenseTabbox then
                return Host.__MimisenseTabbox
            end
            local Full = Params.FullSection ~= false and Params.fullsection ~= false
            local Box = {
                Window = Host.Window, Page = Host.Page, Section = Host,
                Tabs = {}, Order = {}, Active = nil, Items = {}
            }
            Host.__MimisenseTabbox = Box
            local Parent = Host.Items.Content.Instance
            local Header = Host.Items.Top.Instance

            local Holder = Library:Create("Frame", {
                Name = "MimisenseTabContentHolder", Parent = Parent,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            Library:Create("UIListLayout", {
                Parent = Holder.Instance, SortOrder = Enum.SortOrder.LayoutOrder
            })
            local Navigation
            if Full then
                -- Reuse original section header, preserving original rounding.
                if Host.Items.Icon then Host.Items.Icon.Instance.Visible = false end
                if Host.Items.Text then Host.Items.Text.Instance.Visible = false end
                if Host.Items.Arrow then Host.Items.Arrow.Instance.Visible = false end
                if Host.Items.HeaderButton then Host.Items.HeaderButton.Instance.Visible = false end
                Host.Collapsible = false
                Navigation = Library:Create("Frame", {
                    Name = "MimisenseFullSectionTabs", Parent = Header,
                    Position = UDim2.fromOffset(5, 4),
                    Size = UDim2.new(1, -10, 1, -8),
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    ZIndex = 3
                })
            else
                -- Optional inline mode for sections containing other elements.
                Navigation = Library:Create("Frame", {
                    Name = "MimisenseInlineTabs", Parent = Parent,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme["Tab"],
                    BorderSizePixel = 0, LayoutOrder = -1,
                }):AddToTheme({BackgroundColor3 = "Tab"})
                Library:Create("UICorner", {
                    Parent = Navigation.Instance, CornerRadius = UDim.new(0, 6)
                })
            end
            Library:Create("UIListLayout", {
                Parent = Navigation.Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 3),
            })

            local Ease = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local function Refresh(Animate)
                local Count = math.max(1, #Box.Order)
                local Gaps = 3 * (Count - 1)
                for Index, Tab in ipairs(Box.Order) do
                    local Selected = Tab == Box.Active
                    local Background = Library.Theme[Selected and "Inline" or "Tab"]
                    local Foreground = Library.Theme[Selected and "Text" or "Inactive Text"]
                    local Control = Tab.Button.Instance
                    Control.LayoutOrder = Index
                    Control.Size = UDim2.new(1 / Count, -Gaps / Count, 1, 0)
                    Tab.Content.Instance.Visible = Selected
                    Tab.Underline.Instance.Visible = Selected
                    Tab.Button:ChangeItemTheme({
                        BackgroundColor3 = Selected and "Inline" or "Tab",
                        TextColor3 = Selected and "Text" or "Inactive Text"
                    })
                    if Animate then
                        Tab.Button:Tween({BackgroundColor3 = Background, TextColor3 = Foreground}, Ease)
                    else
                        Control.BackgroundColor3 = Background
                        Control.TextColor3 = Foreground
                    end
                    Tab.Underline.Instance.BackgroundColor3 = Library.Theme["Accent"]
                end
            end
            function Box:SetTab(Name)
                local Tab = type(Name) == "table" and Name or self.Tabs[tostring(Name)]
                if not Tab or Tab == self.Active then return Tab end
                self.Active = Tab
                Refresh(true)
                return Tab
            end
            function Box:Tab(Data)
                local Name = type(Data) == "table" and (Data.Name or Data.name) or Data
                Name = tostring(Name or ("Tab " .. tostring(#self.Order + 1)))
                if self.Tabs[Name] then return self.Tabs[Name] end
                local Button = Library:Create("TextButton", {
                    Name = "MimisenseTabButton", Parent = Navigation.Instance,
                    Text = Name, FontFace = Library.Font, TextSize = Library.FontSize,
                    TextColor3 = Library.Theme["Inactive Text"],
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    BackgroundColor3 = Library.Theme["Tab"],
                    BackgroundTransparency = 0,
                    AutoButtonColor = false, BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0), ZIndex = 4
                }):AddToTheme({BackgroundColor3 = "Tab", TextColor3 = "Inactive Text"})
                Library:Create("UICorner", {
                    Parent = Button.Instance, CornerRadius = UDim.new(0, 6)
                })
                local Underline = Library:Create("Frame", {
                    Name = "MimisenseTabAccent", Parent = Button.Instance,
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.new(0.5, 0, 1, 0),
                    Size = UDim2.new(0.42, 0, 0, 2),
                    BackgroundColor3 = Library.Theme["Accent"],
                    BorderSizePixel = 0, Visible = false, ZIndex = 5
                }):AddToTheme({BackgroundColor3 = "Accent"})
                Library:Create("UICorner", {
                    Parent = Underline.Instance, CornerRadius = UDim.new(1, 0)
                })

                local Body = Library:Create("Frame", {
                    Name = "MimisenseTabBody", Parent = Holder.Instance,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Visible = false
                })
                Library:Create("UIListLayout", {
                    Parent = Body.Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6)
                })
                local Tab = setmetatable({
                    Name = Name, Side = Host.Side,
                    Window = Host.Window, Page = Host.Page,
                    IsSettings = Host.IsSettings,
                    Items = {Content = Body}, Elements = Host.Elements,
                    ParentSection = Host, Button = Button,
                    Underline = Underline, Content = Body
                }, Library)
                self.Tabs[Name] = Tab
                table.insert(self.Order, Tab)
                Button:Connect("MouseButton1Down", function()
                    self:SetTab(Name)
                end)
                if not self.Active then self.Active = Tab end
                Refresh(false)
                return Tab
            end
            Box.AddTab = Box.Tab
            Box.Select = Box.SetTab
            Box.Items = {Holder = Holder, Header = Navigation, Content = Holder}
            for _, Entry in ipairs(Params.Tabs or Params.tabs or {}) do
                Box:Tab(Entry)
            end
            return Box
        end
        Library.TabBox = Library.Tabbox

        -- Create a dedicated section whose FULL top bar is a tab switcher.
        Library.CreatePageTabbox = function(Self, Params)
            Params = Params or {}
            local Section = Self:Section({
                Name = Params.Name or "Tabs", Side = Params.Side or Params.side or 1,
                Collapsible = false
            })
            return Section:Tabbox(Params)
        end
        -- Page:Tabbox dispatches through this prototype method. A Section
        -- also inherits Library.Tabbox but resolves the same API differently.
        -- Use "Page:Tabbox" only when Self has ColumnsData.
        local OldTabbox = Library.Tabbox
        Library.Tabbox = function(Self, Params)
            if Self.ColumnsData then
                return Library.CreatePageTabbox(Self, Params)
            end
            return OldTabbox(Self, Params)
        end
        Library.TabBox = Library.Tabbox

        -- Toggle:Options({ Name = "Options", Width = 250, Icon = "settings" })  /  Label:Options({ ... })
        -- Gear next to the element, opens a window that works like a Section:
        -- Toggle, Slider, Dropdown, Label, Button, SubButton, Textbox, Divider, ListBox, Colorpicker, Keybind
        Library.CreateOptions = function(Self, Data)
            Data = Data or { }

            local Options = {
                Name = Data.Name or Data.name or "Options",
                Width = Data.Width or Data.width or 250,
                Icon = Data.Icon or Data.icon or "settings",

                IsOpen = false,
                IsSettings = true, -- dropdown / colorpicker / keybind popups opened inside render above this window

                Window = Data.Window,
                Page = Data.Page,

                Items = { }
            }

            local WindowZIndex = 8
            local SlideOffset = 10
            local Items = { }
            local ColorProperty = "ImageColor3"

            do
                local IconData = Library:GetIcon(Options.Icon)

                -- gear button (lives in the SubElements row of the toggle / label)
                Items["GearButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    LayoutOrder = 100, -- always the right-most sub element
                    BorderSizePixel = 0
                })

                if IconData then
                    Items["Gear"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items["GearButton"].Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Image = IconData.Image,
                        ImageRectSize = IconData.ImageRectSize or Vector2.new(0, 0),
                        ImageRectOffset = IconData.ImageRectOffset or Vector2.new(0, 0),
                        ImageColor3 = Library.Theme["Inactive Text"]
                    }):AddToTheme({ImageColor3 = "Inactive Text"})
                else
                    -- Icons.lua could not be loaded: text fallback
                    ColorProperty = "TextColor3"
                    Items["Gear"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize + 4,
                        Parent = Items["GearButton"].Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Text = utf8.char(0x2699),
                        TextColor3 = Library.Theme["Inactive Text"]
                    }):AddToTheme({TextColor3 = "Inactive Text"})
                end

                -- popup window (same look as the keybind / colorpicker windows)
                Items["OptionsWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Size = UDim2.new(0, Options.Width, 0, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = "Inline"})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["OptionsWindow"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionsWindow"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["OptionsWindow"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["OptionsWindow"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                -- header: accent pill + title
                Items["Header"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["OptionsWindow"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    LayoutOrder = 1,
                    BorderSizePixel = 0
                })

                Items["Pill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Header"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 3, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = "Accent"})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Pill"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 1,
                    Parent = Items["Header"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Options.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 11, 0.5, 0),
                    Size = UDim2.new(1, -11, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BorderSizePixel = 0
                }):AddToTheme({TextColor3 = "Text"})

                Items["Separator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["OptionsWindow"].Instance,
                    Size = UDim2.new(1, 0, 0, 2),
                    LayoutOrder = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = "Background"})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Separator"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                -- content: every element goes in here (Section-compatible)
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["OptionsWindow"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    LayoutOrder = 3,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Options.Items = Items
            end

            local GearButton = Items["GearButton"].Instance
            local PopupWindow = Items["OptionsWindow"].Instance

            local Hovering = false
            local Debounce = false
            local FollowConnection
            local PopupDirection -- lock above/below while open, never flip when scrolling

            local function UpdateGear()
                local Key = Options.IsOpen and "Accent" or (Hovering and "Text" or "Inactive Text")

                Items["Gear"]:ChangeItemTheme({[ColorProperty] = Key})
                Items["Gear"]:Tween({
                    [ColorProperty] = Library.Theme[Key],
                    Rotation = Options.IsOpen and 90 or 0
                }, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            end

            -- popup sits under the gear, right edges aligned; flips above / clamps when near a screen edge
            local function GetTarget(Offset)
                local Screen = Library.Holder.Instance.AbsoluteSize
                local Height = PopupWindow.AbsoluteSize.Y

                local X = GearButton.AbsolutePosition.X + GearButton.AbsoluteSize.X
                X = math.clamp(X, Options.Width + 8, math.max(Screen.X - 8, Options.Width + 8))

                local Y = GearButton.AbsolutePosition.Y + GearButton.AbsoluteSize.Y + 3
                if PopupDirection == nil then
                    PopupDirection = (Height > 0 and Y + Height > Screen.Y - 8) and -1 or 1
                end
                if PopupDirection == -1 then
                    Y = GearButton.AbsolutePosition.Y - Height - 3
                end
                local Direction = PopupDirection
                Y = math.clamp(Y, 5, math.max(5, Screen.Y - Height - 5))
                -- whole pixels only: fractional offsets make Roblox text blurry / shimmery
                return UDim2.fromOffset(math.floor(X + 0.5), math.floor(Y + Offset * Direction + 0.5))
            end

            local function StopFollow()
                if FollowConnection then
                    FollowConnection:Disconnect()
                    FollowConnection = nil
                end
            end

            local function StartFollow()
                StopFollow()

                FollowConnection = RunService.RenderStepped:Connect(function()
                    if not Options.IsOpen then
                        return
                    end

                    -- page was switched / library unloaded / main window closed
                    local MainWindow = Options.Window
                    if not GearButton:IsDescendantOf(Library.Holder.Instance)
                    or (type(MainWindow) == "table" and MainWindow.IsOpen == false) then
                        Options:SetOpen(false)
                        return
                    end

                    PopupWindow.Position = GetTarget(0)
                end)

                table.insert(Library.Connections, FollowConnection)
            end

            function Options:SetOpen(Bool)
                Bool = Bool and true or false

                if Debounce or Options.IsOpen == Bool then
                    return
                end

                Options.IsOpen = Bool
                Debounce = true

                if Options.IsOpen then
                    PopupDirection = nil
                    -- Reparent before measuring: an inactive ScreenGui can report
                    -- zero absolute popup height and produce the wrong placement.
                    PopupWindow.Parent = Library.Holder.Instance
                    PopupWindow.Position = GetTarget(-SlideOffset)

                    Items["OptionsWindow"]:Tween({Position = GetTarget(0)})

                    Items["OptionsWindow"]:FadeDescendants(true, function()
                        Debounce = false

                        if Options.IsOpen then
                            StartFollow()
                        end
                    end)

                    Library:RegisterOpenFrame(Options, {
                        HoverItems = { Items["OptionsWindow"], Items["GearButton"] },
                        AnchorInstance = GearButton,
                        PopupInstance = PopupWindow,
                    })
                    Library:RefreshPopupLayer()
                else
                    StopFollow()

                    Items["OptionsWindow"]:Tween({Position = GetTarget(-SlideOffset)})

                    Items["OptionsWindow"]:FadeDescendants(false, function()
                        PopupWindow.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    Library:CloseOpenFrameChildren(Options)
                    Library:UnregisterOpenFrame(Options)
                end

                local Descendants = PopupWindow:GetDescendants()
                table.insert(Descendants, PopupWindow)

                for _, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = Options.IsOpen and WindowZIndex or 1
                end

                if Library.RefreshPopupLayer then Library:RefreshPopupLayer() end
                UpdateGear()
            end

            function Options:Open()
                Options:SetOpen(true)
            end

            function Options:Close()
                Options:SetOpen(false)
            end

            function Options:SetName(Text)
                Options.Name = tostring(Text)
                Items["Title"].Instance.Text = Options.Name
            end

            function Options:SetVisibility(Bool)
                if not Bool then
                    Options:SetOpen(false)
                end

                GearButton.Visible = Bool
            end

            Items["OptionsWindow"]:VisibleCheck()

            Items["GearButton"]:OnHover(function()
                Hovering = true

                if not Options.IsOpen then
                    UpdateGear()
                end
            end, function()
                Hovering = false

                if not Options.IsOpen then
                    UpdateGear()
                end
            end)

            Library:RegisterOpenFrameTrigger(Items["GearButton"])

            Items["GearButton"]:Connect("MouseButton1Down", function()
                Options:SetOpen(not Options.IsOpen)
            end)

            return setmetatable(Options, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = { } do
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Toggle.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})

                Items["IndicatorOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["IndicatorOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["IndicatorOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Check"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ImageTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "rbxassetid://133055463536692",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                }
                })

                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -26, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Toggle.Items = Items
            end

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then return end
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                if Toggle.Value then return end
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            function Toggle:Set(Bool)
                Toggle.Value = Bool

                if Bool then
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme.Text})

                    Items["Inline"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                    Items["Check"]:Tween({ImageTransparency = 0})
                else
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})

                    Items["Inline"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
                    Items["Check"]:Tween({ImageTransparency = 1})
                end

                Flags[Toggle.Flag] = Bool

                -- Keep a Toggle's optional Keybind and the Keybind List in sync
                -- even when the toggle is changed from the menu.
                if Toggle.LinkedKeybind and Toggle.LinkedKeybind.SetLinkedState then
                    Toggle.LinkedKeybind:SetLinkedState(Bool)
                end

                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Colorpicker(Data, Data2, Data3)
                local Inputs
                if Data2 ~= nil or Data3 ~= nil then
                    Inputs = {Data, Data2, Data3}
                elseif type(Data) == "table" and Data[1] ~= nil then
                    Inputs = Data
                else
                    Inputs = {Data}
                end

                local Result = { }
                for Index = 1, math.min(#Inputs, 3) do
                    local ItemData = Inputs[Index] or { }
                    local Colorpicker = {
                        Flag = ItemData.Flag or ItemData.flag or (ItemData.Name or ItemData.name or (Toggle.Name .. "/Color" .. Index)),
                        Default = ItemData.Default or ItemData.default or Color3.fromRGB(255, 255, 255),
                        Callback = ItemData.Callback or ItemData.callback or function() end,
                        Alpha = ItemData.Alpha or ItemData.alpha or 0,

                        Window = Toggle.Window,
                        Page = Toggle.Page,
                        Section = Toggle.Section,
                    }

                    local NewColorpicker = Library:CreateColorpicker({
                        Parent = Items["SubElements"],
                        Name = ItemData.Name or ItemData.name or Toggle.Name,
                        Page = Colorpicker.Page,
                        Section = Colorpicker.Section,
                        Flag = Colorpicker.Flag,
                        Default = Colorpicker.Default,
                        Callback = Colorpicker.Callback,
                        Alpha = Colorpicker.Alpha,
                        Clipboard = ItemData.Clipboard,
                    })

                    table.insert(Result, NewColorpicker)
                end

                return #Result == 1 and Result[1] or Result
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                    Modes = Data.Modes or Data.modes,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Modes = Keybind.Modes,
                    Callback = Keybind.Callback
                })

                Toggle.LinkedKeybind = NewKeybind
                NewKeybind.LinkedToggle = Toggle
                if NewKeybind.SetLinkedState then
                    NewKeybind:SetLinkedState(Toggle.Value)
                end

                return NewKeybind
            end

            function Toggle:Options(Data)
                Data = Data or { }

                local NewOptions = Library:CreateOptions({
                    Parent = Items["SubElements"],
                    Name = Data.Name or Data.name or "Options",
                    Width = Data.Width or Data.width,
                    Icon = Data.Icon or Data.icon,
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                })

                Toggle.LinkedOptions = NewOptions

                return NewOptions
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or { }

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Callback = Params.Callback or Params.callback or function() end,
                Flash = Params.Flash ~= false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Button.Section.Items["Content"]
            end

            local Items = { } do
                Items["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["RealButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealButton"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Button.Name,
                    ZIndex = 2 ,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Button.Items = Items
            end

            Items["RealButton"]:OnHover(function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Accent"], BackgroundTransparency = 0.82})
            end, function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Background"], BackgroundTransparency = 0})
            end)

            function Button:Press()
                if Button.Flash then
                    Items["Accent"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                    task.wait(0.18)
                    Items["Accent"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
                end

                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["RealButton"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return setmetatable(Button, Library)
        end

        -- SubButton: кнопка с подтверждением.
        -- 1-й клик: на самой кнопке появляется ConfirmText цветом акцента (по умолчанию "are you sure?").
        -- 2-й клик (пока надпись стоит): вызывается Callback.
        -- Если не нажать за ConfirmTime секунд (по умолчанию 1.5) - надпись возвращается обратно.
        -- ConfirmText и ConfirmTime задаются в скрипте, можно менять и потом: SubButton.ConfirmTime = 3
        Library.SubButton = function(Self, Params)
            Params = Params or { }

            local Options = { }
            for Index, Value in Params do
                Options[Index] = Value
            end

            local RealCallback = Params.Callback or Params.callback or function() end

            local State = {
                Armed = false,
                Token = 0,
                OriginalText = ""
            }

            local SubButton

            -- Цвет и текст меняются сразу и одновременно (без твина), поэтому ничего не мигает
            local function SetLook(Armed)
                local Text = SubButton.Items["Text"]

                Text:ChangeItemTheme({TextColor3 = Armed and "Accent" or "Text"})
                Text.Instance.TextColor3 = Armed and Library.Theme["Accent"] or Library.Theme["Text"]
            end

            local function Restore()
                SubButton.Items["Text"].Instance.Text = State.OriginalText
                SetLook(false)
            end

            local function Disarm()
                if not State.Armed then
                    return
                end

                State.Armed = false
                State.Token += 1

                Restore()
            end

            local function Arm()
                State.Armed = true
                State.Token += 1

                local Token = State.Token
                local Text = SubButton.Items["Text"]

                State.OriginalText = Text.Instance.Text
                Text.Instance.Text = tostring(SubButton.ConfirmText)
                SetLook(true)

                task.delay(tonumber(SubButton.ConfirmTime) or 1.5, function()
                    if not Library or State.Token ~= Token or not State.Armed then
                        return
                    end

                    Disarm()
                end)
            end

            Options.Flash = false
            Options.Callback = function()
                if not State.Armed then
                    Arm()
                    return
                end

                -- Подтверждение: отменяем таймер, но надпись пока НЕ возвращаем,
                -- чтобы перед Unload не мелькало старое название
                State.Armed = false
                State.Token += 1

                Library:SafeCall(RealCallback)

                -- Возвращаем надпись уже после колбэка (если библиотека не выгружена)
                task.defer(function()
                    if not Library then
                        return
                    end

                    local Text = SubButton.Items["Text"]
                    if Text.Instance.Parent then
                        Restore()
                    end
                end)
            end

            SubButton = Library.Button(Self, Options)
            SubButton.ConfirmText = Params.ConfirmText or "are you sure?"
            SubButton.ConfirmTime = Params.ConfirmTime or 1.5

            -- Надпись занимает всю кнопку и выровнена по центру: размер не прыгает при смене текста
            local Label = SubButton.Items["Text"].Instance
            Label.AutomaticSize = Enum.AutomaticSize.None
            Label.AnchorPoint = Vector2.new(0, 0)
            Label.Position = UDim2.new(0, 0, 0, 0)
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.TextXAlignment = Enum.TextXAlignment.Center

            function SubButton:Disarm()
                Disarm()
            end

            return SubButton
        end

        Library.Slider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 1,
                Suffix = Params.Suffix or Params.suffix or "",
                Step = Params.Step or Params.step,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = { }
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Items["RealSliderOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSliderOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 2),
                    TopRightRadius = UDim.new(0, 2),
                    BottomRightRadius = UDim.new(0, 2),
                    BottomLeftRadius = UDim.new(0, 2)
                })

                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealSliderOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(0.8999999761581421, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                }
                })

                Items["DraggerOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["DraggerOutline"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })

                Items["DraggerInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["DraggerOutline"].Instance,
                    Position = UDim2.new(0, 2, 0, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["DraggerInline"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["DraggerInline"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                }
                })

                Items["Value"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "0",
                    PlaceholderText = "0",
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 78, 0, 18),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    MultiLine = false
                }):AddToTheme({TextColor3 = 'Inactive Text', PlaceholderColor3 = 'Inactive Text'})

                Slider.Items = Items
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            Slider.DisplayValue = Slider.Default

            function Slider:AnimateValue(NewValue)
                if Slider.ValueTween then
                    Slider.ValueTween:Disconnect()
                end

                local Start = Slider.DisplayValue
                local Goal = NewValue
                local Duration = 0.18

                local Clock = tick()

                Slider.ValueTween = RunService.RenderStepped:Connect(function()
                    local Alpha = math.clamp((tick() - Clock) / Duration, 0, 1)
                    Alpha = TweenService:GetValue(Alpha, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                    local Current = Start + (Goal - Start) * Alpha

                    local Rounded = Library:Round(Current, Slider.Decimals)

                    Items["Value"].Instance.Text = string.format("%s%s", Rounded, Slider.Suffix)

                    if Alpha >= 1 then
                        Slider.DisplayValue = Goal
                        Items["Value"].Instance.Text = string.format("%s%s", Goal, Slider.Suffix)

                        Slider.ValueTween:Disconnect()
                        Slider.ValueTween = nil
                    end
                end)
            end

            function Slider:Set(Value)
                Value = tonumber(Value)
                if not Value or Value ~= Value or Value == math.huge or Value == -math.huge then
                    Value = Slider.Value
                end

                local Range = Slider.Max - Slider.Min
                if Range == 0 then
                    Slider.Value = Slider.Min
                else
                    local Clamped = math.clamp(Value, Slider.Min, Slider.Max)

                    if Slider.Step and Slider.Step > 0 then
                        Clamped = Slider.Min + math.floor((Clamped - Slider.Min) / Slider.Step + 0.5) * Slider.Step
                        Clamped = math.clamp(Clamped, Slider.Min, Slider.Max)
                    end

                    Slider.Value = Library:Round(Clamped, Slider.Decimals)
                end

                local FillPercent = Range == 0 and 0 or math.clamp((Slider.Value - Slider.Min) / Range, 0, 1)
                Items["Accent"]:Tween({Size = UDim2.new(FillPercent, 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Slider:AnimateValue(Slider.Value)

                local Percent = Range == 0 and 0 or math.clamp((Slider.Value - Slider.Min) / Range, 0, 1)
                Items["DraggerOutline"]:Tween({Position = UDim2.new(Percent, (12 / 2) - (Percent * 12), 0.5, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))

                if Slider.Value == Slider.Min then
                    Items["Accent"]:Tween({BackgroundTransparency = 1})
                else
                    Items["Accent"]:Tween({BackgroundTransparency = 0})
                end

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local Width = Items["RealSlider"].Instance.AbsoluteSize.X
                if Width <= 0 then
                    return Slider.Value
                end

                local SizeX = math.clamp((Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Width, 0, 1)
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local function CommitSliderText()
                local Text = tostring(Items["Value"].Instance.Text or "")
                if Slider.Suffix ~= "" then
                    Text = Text:gsub("%s*" .. Slider.Suffix:gsub("%p", "%%%0") .. "%s*$", "")
                end
                local Number = tonumber(Text)
                if Number == nil or Number ~= Number or Number == math.huge or Number == -math.huge then
                    Slider:AnimateValue(Slider.Value)
                    return
                end
                Slider:Set(Number)
            end

            Items["Value"]:Connect("Focused", function()
                Items["Value"].Instance.CursorPosition = #Items["Value"].Instance.Text + 1
            end)

            Items["Value"]:Connect("FocusLost", function(EnterPressed)
                CommitSliderText()
            end)

            local InputChanged

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        local OptionSearchInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        local OptionHeight = 18
        local OptionGap = 6
        local OptionSlot = OptionHeight + OptionGap

        local SetOptionSearchVisible = function(OptionData, OptionItems, Visible) -- sorry i have to do this brto
            if OptionData.SearchVisible == Visible then
                return
            end

            OptionData.SearchVisible = Visible

            local Button = OptionItems["Toggle"]
            local ButtonInstance = Button.Instance

            if Visible then
                ButtonInstance.Visible = true
                Button:Tween({Size = UDim2.new(1, 0, 0, OptionSlot)}, OptionSearchInfo)
                OptionItems["IndicatorOutline"]:Tween({BackgroundTransparency = 0}, OptionSearchInfo)
                OptionItems["Indicator"]:Tween({BackgroundTransparency = 0}, OptionSearchInfo)

                if OptionData.IsSelected then
                    OptionItems["Text"]:Tween({TextTransparency = 0, TextColor3 = Library.Theme.Text}, OptionSearchInfo)
                    OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}, OptionSearchInfo)
                    OptionItems["Check"]:Tween({ImageTransparency = 0}, OptionSearchInfo)
                else
                    OptionItems["Text"]:Tween({TextTransparency = 0, TextColor3 = Library.Theme["Inactive Text"]}, OptionSearchInfo)
                    OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, OptionSearchInfo)
                    OptionItems["Check"]:Tween({ImageTransparency = 1}, OptionSearchInfo)
                end
            else
                Button:Tween({Size = UDim2.new(1, 0, 0, 0)}, OptionSearchInfo)
                OptionItems["Text"]:Tween({TextTransparency = 1}, OptionSearchInfo)
                OptionItems["IndicatorOutline"]:Tween({BackgroundTransparency = 1}, OptionSearchInfo)
                OptionItems["Indicator"]:Tween({BackgroundTransparency = 1}, OptionSearchInfo)
                OptionItems["Inline"]:Tween({BackgroundTransparency = 1}, OptionSearchInfo)
                OptionItems["Check"]:Tween({ImageTransparency = 1}, OptionSearchInfo)
            end
        end

        local SearchOptions = function(Options, Query, Holder)
            Query = string.lower(tostring(Query or ""))

            for _, OptionData in Options do
                local Matches = Query == "" or string.find(string.lower(OptionData.Name), Query, 1, true) ~= nil
                OptionData:SetSearchVisible(Matches)
            end

            if Holder then
                Holder:Tween({CanvasPosition = Vector2.new(0, 0)}, OptionSearchInfo)
            end
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or { }

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,
                MaxSize = Params.MaxSize or Params.maxsize or 120,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                IsOpen = false,
                Items = { }
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = { } do
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 51),
                    ClipsDescendants = true, -- avoid overlay during open tween
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Items["RealDropdownOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.fromOffset(0, 21),
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDropdownOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdownOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "...",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})

                Items["Icon"] = Library:CreateArrow({
                    Parent = Items["RealDropdown"].Instance,
                    Icon = "chevron-up",
                    Size = 16,
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Color = "Inactive Text"
                })

                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    Position = UDim2.fromOffset(0, 54),
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Search"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["OptionHolder"].Instance,
                    TextWrapped = true,
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search..",
                    Size = UDim2.new(1, -20, 0, 20),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0, 7),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://103256802537537",
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -20, 1, -45),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 35),
                    BottomImage = "rbxassetid://103256802537537",
                    TopImage = "rbxassetid://103256802537537"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingBottom = UDim.new(0, 0)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Dropdown.Items = Items
            end

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Icon"]:Tween({[Items["Icon"].ColorProperty] = Library.Theme.Text})
            end, function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme.Background})
                Items["Icon"]:Tween({[Items["Icon"].ColorProperty] = Library.Theme["Inactive Text"]})
            end)

            function Dropdown:Set(Value)
                if Dropdown.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    Dropdown.Value = Value

                    for Name, OptionData in Dropdown.Options do
                        if OptionData.IsSelected and not table.find(Value, Name) then
                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        end
                    end

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionItems = { } do
                    OptionItems["Toggle"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Holder"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Size = UDim2.new(1, 0, 0, OptionSlot),
                        BorderSizePixel = 0
                    })

                    OptionItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = OptionItems["Toggle"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Value,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 28, 0, OptionHeight / 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Text'})

                    OptionItems["IndicatorOutline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["Toggle"].Instance,
                        Size = UDim2.new(0, 18, 0, 18),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }):AddToTheme({BackgroundColor3 = 'Outline'})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["IndicatorOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })

                    OptionItems["Indicator"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["IndicatorOutline"].Instance,
                        Position = UDim2.new(0, 1, 0, 1),
                        Size = UDim2.new(1, -2, 1, -2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }):AddToTheme({BackgroundColor3 = 'Background'})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["Indicator"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })

                    OptionItems["Inline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["Indicator"].Instance,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Accent"]
                    }):AddToTheme({BackgroundColor3 = 'Accent'})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })

                    OptionItems["Check"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        ImageColor3 = Color3.fromRGB(0, 0, 0),
                        ImageTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = "rbxassetid://133055463536692",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0
                    })

                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        Rotation = 90,
                        Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                    }
                    })
                end

                local OptionData = {
                    Button = OptionItems["Toggle"],
                    Text = OptionItems["Text"],
                    Name = Value,
                    IsSelected = false,
                    SearchVisible = true
                }

                OptionItems["Toggle"]:OnHover(function()
                    if OptionData.IsSelected or not Dropdown.IsOpen then return end
                    OptionItems["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    if OptionData.IsSelected or not Dropdown.IsOpen then return end
                    OptionItems["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end)

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme.Text})
                            OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                            OptionItems["Check"]:Tween({ImageTransparency = 0})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme.Text
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 1, 0)
                        end
                    else
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                            OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
                            OptionItems["Check"]:Tween({ImageTransparency = 1})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme["Inactive Text"]
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 0, 0)
                        end
                    end
                end

                function OptionData:SetSearchVisible(Visible)
                    SetOptionSearchVisible(OptionData, OptionItems, Visible)
                end

                function OptionData:Set()
                    if not Dropdown.IsOpen then return end

                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    if not Dropdown.Multi and Dropdown.IsOpen then
                        task.defer(function()
                            if Dropdown.IsOpen then Dropdown:SetOpen(false) end
                        end)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            local function GetDropdownContentHeight(Query)
                local Count = 0
                for _, OptionData in Dropdown.Options do
                    if Query == "" or OptionData.SearchVisible then
                        Count += 1
                    end
                end
                -- Search row + padded list. Clamp to MaxSize (internal scrolling).
                return math.clamp(43 + Count * OptionSlot, 56, math.max(56, Dropdown.MaxSize))
            end

            function Dropdown:Search(Query)
                Query = string.lower(tostring(Query or ""))
                SearchOptions(Dropdown.Options, Query, Items["Holder"])
                if Dropdown.IsOpen then
                    local Height = GetDropdownContentHeight(Query)
                    Items["OptionHolder"].Instance.Size = UDim2.new(1, 0, 0, Height)
                    Items["Dropdown"].Instance.Size = UDim2.new(1, 0, 0, 54 + Height)
                end
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do
                    Dropdown:Add(Value)
                end

                Dropdown:Search(Items["Search"].Instance.Text)
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                if not Bool and Dropdown.IsOpen then Dropdown:SetOpen(false) end
                Items["Dropdown"].Instance.Visible = Bool
            end

            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance
            local DropdownFrame = Items["Dropdown"].Instance
            local DropdownTween
            local OpenHeight = 0

            -- The options are INSIDE the dropdown's layout cell. UIListLayout
            -- pushes all following controls and sections down automatically,
            -- rather than covering them with a floating screen-space popup.
            function Dropdown:SetOpen(Bool)
                Bool = Bool and true or false
                if Bool == Dropdown.IsOpen then return end
                Dropdown.IsOpen = Bool
                Items["Icon"]:Tween({Rotation = Bool and 180 or 0})
                if DropdownTween then DropdownTween:Cancel() DropdownTween = nil end

                if Bool then
                    Library:RegisterOpenFrame(Dropdown, {
                        HoverItems = { Items["OptionHolder"], Items["RealDropdown"] },
                        AnchorInstance = RealDropdown,
                        PopupInstance = OptionHolder,
                    })
                    OptionHolder.Parent = DropdownFrame
                    OptionHolder.Position = UDim2.fromOffset(0, 54)
                    OpenHeight = GetDropdownContentHeight(Items["Search"].Instance.Text:lower())
                    OptionHolder.Visible = true
                    OptionHolder.Size = UDim2.new(1, 0, 0, OpenHeight)
                    DropdownTween = TweenService:Create(DropdownFrame,
                        TweenInfo.new(0.19, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                        {Size = UDim2.new(1, 0, 0, 54 + OpenHeight)})
                    DropdownTween:Play()
                    -- v18: keep the expanded inline list visible above the
                    -- footer. Scroll its nearest ScrollingFrame into view,
                    -- rather than drawing the list over other controls.
                    task.delay(0.21, function()
                        if not Dropdown.IsOpen or not DropdownFrame.Parent then return end
                        local Scroll = DropdownFrame.Parent
                        while Scroll and not Scroll:IsA("ScrollingFrame") do
                            Scroll = Scroll.Parent
                        end
                        if not Scroll or not Scroll.Parent then return end
                        local Bottom = DropdownFrame.AbsolutePosition.Y + DropdownFrame.AbsoluteSize.Y
                        local ViewBottom = Scroll.AbsolutePosition.Y + Scroll.AbsoluteSize.Y - 8
                        if Bottom > ViewBottom then
                            local Extra = Bottom - ViewBottom
                            local MaxY = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteSize.Y)
                            Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X,
                                math.clamp(Scroll.CanvasPosition.Y + Extra, 0, MaxY))
                        end
                    end)
                else
                    -- Close before collapsing, so rows never cover the next
                    -- element during the animation.
                    OptionHolder.Visible = false
                    Library:CloseOpenFrameChildren(Dropdown)
                    Library:UnregisterOpenFrame(Dropdown)
                    DropdownTween = TweenService:Create(DropdownFrame,
                        TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                        {Size = UDim2.new(1, 0, 0, 51)})
                    DropdownTween:Play()
                    Items["Search"].Instance.Text = ""
                end
                -- No global ZIndex override: an embedded list must not cover
                -- unrelated popups, footer, other sections or color pickers.
                if Library.RefreshPopupLayer then Library:RefreshPopupLayer() end
                -- An embedded dropdown inherits its parent's modal popup layer.
                -- Do not push it behind the input shield.
                local InModal = false
                for _, Data in Library.OpenFrames do
                    if Data.Modal and Data.PopupInstance and DropdownFrame:IsDescendantOf(Data.PopupInstance) then
                        InModal = true
                        break
                    end
                end
                if not InModal then
                    OptionHolder.ZIndex = 8
                    for _, Object in OptionHolder:GetDescendants() do
                        if Object:IsA("GuiObject") then Object.ZIndex = 9 end
                    end
                end
            end

            Library:RegisterOpenFrameTrigger(Items["RealDropdown"])

            Library:Connect(Items["Search"].Instance:GetPropertyChangedSignal("Text"), function()
                Dropdown:Search(Items["Search"].Instance.Text)
            end)

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            for Index, Value in Dropdown.OptionItems do
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or { }

            local Label = {
                Name = Params.Name or Params.name or "Label",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Label.Section.Items["Content"]
            end

            local Items = { } do
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Label.Items = Items
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data, Data2, Data3)
                local Inputs
                if Data2 ~= nil or Data3 ~= nil then
                    Inputs = {Data, Data2, Data3}
                elseif type(Data) == "table" and Data[1] ~= nil then
                    Inputs = Data
                else
                    Inputs = {Data}
                end

                local Result = { }
                for Index = 1, math.min(#Inputs, 3) do
                    local ItemData = Inputs[Index] or { }
                    local Colorpicker = {
                        Flag = ItemData.Flag or ItemData.flag or (ItemData.Name or ItemData.name or (Label.Name .. "/Color" .. Index)),
                        Default = ItemData.Default or ItemData.default or Color3.fromRGB(255, 255, 255),
                        Callback = ItemData.Callback or ItemData.callback or function() end,
                        Alpha = ItemData.Alpha or ItemData.alpha or 0,

                        Window = Label.Window,
                        Page = Label.Page,
                        Section = Label.Section,
                    }

                    local NewColorpicker = Library:CreateColorpicker({
                        Parent = Items["SubElements"],
                        Name = ItemData.Name or ItemData.name or Label.Name,
                        Page = Colorpicker.Page,
                        Section = Colorpicker.Section,
                        Flag = Colorpicker.Flag,
                        Default = Colorpicker.Default,
                        Callback = Colorpicker.Callback,
                        Alpha = Colorpicker.Alpha,
                        Clipboard = ItemData.Clipboard,
                    })

                    table.insert(Result, NewColorpicker)
                end

                return #Result == 1 and Result[1] or Result
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                    Modes = Data.Modes or Data.modes,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Modes = Keybind.Modes,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            function Label:Options(Data)
                Data = Data or { }

                local NewOptions = Library:CreateOptions({
                    Parent = Items["SubElements"],
                    Name = Data.Name or Data.name or "Options",
                    Width = Data.Width or Data.width,
                    Icon = Data.Icon or Data.icon,
                    Window = Label.Window,
                    Page = Label.Page,
                })

                Label.LinkedOptions = NewOptions

                return NewOptions
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        -- Section-level Colorpicker / Keybind (a Label row with the element attached).
        -- Without these, Section:Colorpicker({...}) / Section:Keybind({...}) threw
        -- "attempt to call a nil value" and the script died before the UI Settings page.
        Library.Colorpicker = function(Self, Params)
            Params = Params or { }
            local Row = Library.Label(Self, {Name = Params.Name or Params.name or "Colorpicker"})
            return Row:Colorpicker(Params)
        end

        Library.Keybind = function(Self, Params)
            Params = Params or { }
            local Row = Library.Label(Self, {Name = Params.Name or Params.name or "Keybind"})
            return Row:Keybind(Params)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or { }

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Numeric = Params.Numeric or Params.numeric or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Textbox.Section.Items["Content"]
            end

            local Items = { } do
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 51),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Textbox"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                Items["BackgroundOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["BackgroundOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["BackgroundOutline"].Instance,
                    Size = UDim2.new(1, -2, 1, -2),
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -16, 0, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 8, 0.5, 0),
                    CursorPosition = -1,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text'})

                Textbox.Items = Items
            end

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            Items["Input"]:Connect("Focused", function()
                Items["BackgroundOutline"]:ChangeItemTheme({BackgroundColor3 = Library.Theme["Accent"]})
                Items["BackgroundOutline"]:Tween({BackgroundColor3 = Library.Theme["Accent"]})
            end)

            Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                if Textbox.Finished then
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end

                Items["BackgroundOutline"]:ChangeItemTheme({BackgroundColor3 = Library.Theme["Outline"]})
                Items["BackgroundOutline"]:Tween({BackgroundColor3 = Library.Theme["Outline"]})
            end)

            if not Textbox.Finished then
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return setmetatable(Textbox, Library)
        end

        Library.Divider = function(Self)
            local Items = { } do
                Items["Divider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Self.Items.Content.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 7),
                    BorderSizePixel = 0
                })

                Items["RealDivider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Divider"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 0, 3),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDivider"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
            end

            return Items
        end

        Library.ListBox = function(Self, Params)
            Params = Params or { }

            local List = {
                Name = Params.Name or Params.name or "ListBox",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,
                Height = Params.Height or Params.height or Params.MaxSize or Params.maxsize or 225,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                Items = { }
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = List.Section.Items["Content"]
            end

            local Items = { } do
                Items["List"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, List.Height),
                    BorderSizePixel = 0
                })

                Items["TopOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["List"].Instance,
                    Size = UDim2.new(0, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["TopOutline"].Instance,
                    PaddingTop = UDim.new(0, 1),
                    PaddingBottom = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 1)
                })

                Items["TopInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["TopOutline"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["TopInline"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["TopInline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })

                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["TopInline"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "rbxassetid://132783180980031",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 2),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["TopInline"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search...",
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 24, 0.5, 1),
                    Size = UDim2.new(0, 0, 0, 16),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    ClipsDescendants = true
                }):AddToTheme({TextColor3 = 'Text'})

                Items["SearchMeasure"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Search...",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Visible = false,
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["TopInline"].Instance,
                    Size = UDim2.new(1, 16, 0, 2),
                    Position = UDim2.new(0, -8, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["TopOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })

                Items["InlineOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["List"].Instance,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 1, -30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["InlineOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://103256802537537",
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -16, 1, -16),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 8),
                    BottomImage = "rbxassetid://103256802537537",
                    TopImage = "rbxassetid://103256802537537"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                List.Items = Items
            end

            local SearchBarExtra = 48

            local UpdateSearchBarSize = function(Instant)
                local Input = Items["Input"].Instance
                local Measure = Items["SearchMeasure"].Instance
                local Text = Input.Text ~= "" and Input.Text or Input.PlaceholderText

                Measure.Text = Text

                local TextWidth = math.ceil(math.max(Measure.TextBounds.X, Measure.AbsoluteSize.X))
                local TargetWidth = TextWidth + SearchBarExtra
                local MaxWidth = Items["List"].Instance.AbsoluteSize.X

                if MaxWidth > 0 then
                    TargetWidth = math.min(TargetWidth, MaxWidth)
                end

                local InputWidth = math.max(TextWidth + 6, 0)

                if Instant then
                    Items["TopOutline"].Instance.Size = UDim2.new(0, TargetWidth, 0, 30)
                    Input.Size = UDim2.new(0, InputWidth, 0, 16)
                else
                    Items["TopOutline"]:Tween({Size = UDim2.new(0, TargetWidth, 0, 30)}, OptionSearchInfo)
                    Items["Input"]:Tween({Size = UDim2.new(0, InputWidth, 0, 16)}, OptionSearchInfo)
                end
            end

            UpdateSearchBarSize(true)

            function List:Set(Value)
                if List.Multi then
                    if type(Value) == "string" then
                        Value = { Value }
                    end

                    if type(Value) ~= "table" then
                        return
                    end

                    local Wanted = { }
                    for _, Name in Value do
                        Wanted[Name] = true
                    end

                    local NewValue = { }
                    for _, Name in Value do
                        if List.Options[Name] then
                            table.insert(NewValue, Name)
                        end
                    end

                    for Name, OptionData in List.Options do
                        local On = Wanted[Name] == true
                        OptionData.IsSelected = On
                        OptionData:ToggleState(On and "Active" or "Inactive")
                    end

                    List.Value = NewValue
                    Flags[List.Flag] = NewValue
                else
                    if not List.Options[Value] then
                        return
                    end

                    local OptionData = List.Options[Value]

                    List.Value = Value

                    for Index, Other in List.Options do
                        if Other ~= OptionData then
                            Other.IsSelected = false
                            Other:ToggleState("Inactive")
                        else
                            Other.IsSelected = true
                            Other:ToggleState("Active")
                        end
                    end

                    Flags[List.Flag] = Value
                end

                Library:SafeCall(List.Callback, List.Value)
            end

            function List:Add(Value)
                local OptionItems = { } do
                    OptionItems["Toggle"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Holder"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Size = UDim2.new(1, 0, 0, OptionSlot),
                        BorderSizePixel = 0
                    })

                    OptionItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = OptionItems["Toggle"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Value,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 28, 0, OptionHeight / 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Text'})

                    OptionItems["IndicatorOutline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["Toggle"].Instance,
                        Size = UDim2.new(0, 18, 0, 18),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }):AddToTheme({BackgroundColor3 = 'Outline'})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["IndicatorOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })

                    OptionItems["Indicator"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["IndicatorOutline"].Instance,
                        Position = UDim2.new(0, 1, 0, 1),
                        Size = UDim2.new(1, -2, 1, -2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }):AddToTheme({BackgroundColor3 = 'Background'})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["Indicator"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })

                    OptionItems["Inline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = OptionItems["Indicator"].Instance,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Accent"]
                    }):AddToTheme({BackgroundColor3 = 'Accent'})

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        TopLeftRadius = UDim.new(0, 4),
                        TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4),
                        BottomLeftRadius = UDim.new(0, 4)
                    })

                    OptionItems["Check"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        ImageColor3 = Color3.fromRGB(0, 0, 0),
                        ImageTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = "rbxassetid://133055463536692",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0
                    })

                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = OptionItems["Inline"].Instance,
                        Rotation = 90,
                        Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                    }
                    })
                end

                local OptionData = {
                    Button = OptionItems["Toggle"],
                    Text = OptionItems["Text"],
                    Name = Value,
                    IsSelected = false,
                    SearchVisible = true
                }

                OptionItems["Toggle"]:OnHover(function()
                    if OptionData.IsSelected then return end
                    OptionItems["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    if OptionData.IsSelected then return end
                    OptionItems["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end)

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme.Text})
                            OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                            OptionItems["Check"]:Tween({ImageTransparency = 0})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme.Text
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 1, 0)
                        end
                    else
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                            OptionItems["Inline"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
                            OptionItems["Check"]:Tween({ImageTransparency = 1})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme["Inactive Text"]
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 0, 0)
                        end
                    end
                end

                function OptionData:SetSearchVisible(Visible)
                    SetOptionSearchVisible(OptionData, OptionItems, Visible)
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if List.Multi then
                        local Index = table.find(List.Value, OptionData.Name)

                        if Index then
                            table.remove(List.Value, Index)
                        else
                            table.insert(List.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[List.Flag] = List.Value
                    else
                        if OptionData.IsSelected then
                            List.Value = OptionData.Name
                            Flags[List.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in List.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end
                        else
                            List.Value = nil
                            Flags[List.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        end
                    end

                    Library:SafeCall(List.Callback, List.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                List.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function List:Search(Query)
                SearchOptions(List.Options, Query, Items["Holder"])
            end

            function List:Remove(Option)
                if List.Options[Option] then
                    List.Options[Option].Button.Instance:Destroy()
                    List.Options[Option] = nil
                end
            end

            function List:Refresh(ListItems)
                local Previous = List.Value

                for Name in List.Options do
                    List:Remove(Name)
                end

                for _, Value in ListItems do
                    List:Add(Value)
                end

                local Lost = false

                if List.Multi then
                    local NewValue = { }

                    for _, Name in (type(Previous) == "table" and Previous or { }) do
                        local OptionData = List.Options[Name]

                        if OptionData then
                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")
                            table.insert(NewValue, Name)
                        else
                            Lost = true
                        end
                    end

                    List.Value = NewValue
                    Flags[List.Flag] = NewValue
                else
                    local OptionData = type(Previous) == "string" and List.Options[Previous]

                    if OptionData then
                        OptionData.IsSelected = true
                        OptionData:ToggleState("Active")
                    else
                        if type(Previous) == "string" then
                            Lost = true
                        end

                        List.Value = nil
                        Flags[List.Flag] = nil
                    end
                end

                List:Search(Items["Input"].Instance.Text)

                if Lost then
                    Library:SafeCall(List.Callback, List.Value)
                end
            end

            function List:SetVisibility(Bool)
                Items["List"].Instance.Visible = Bool
            end

            Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                UpdateSearchBarSize(false)
                List:Search(Items["Input"].Instance.Text)
            end)

            for Index, Value in List.OptionItems do
                List:Add(Value)
            end

            List:Set(List.Default)

            SetFlags[List.Flag] = function(Value)
                List:Set(Value)
            end

            return setmetatable(List, Library)
        end

        -- =====================================================================
        -- EXTRAS: clipboard, tooltips, context menu, Tooltip/DependsOn/Reset,
        -- RangeSlider, menu search, UI state, config/theme export & import
        -- =====================================================================

        -- ---------- clipboard (system clipboard + internal fallback) ----------
        local FindGlobal = function(...)
            for _, Name in {...} do
                local Value

                pcall(function() Value = getgenv()[Name] end)

                if type(Value) ~= "function" then
                    pcall(function() Value = getfenv(0)[Name] end)
                end

                if type(Value) == "function" then
                    return Value
                end
            end

            return nil
        end

        Library.InternalClipboard = ""

        -- returns ok, wroteSystemClipboard
        Library.CopyText = function(Self, Text)
            Text = tostring(Text or "")
            Library.InternalClipboard = Text

            local Fn = FindGlobal("setclipboard", "toclipboard", "set_clipboard")

            if not Fn then
                pcall(function()
                    if syn and syn.write_clipboard then
                        Fn = syn.write_clipboard
                    end
                end)
            end

            if Fn then
                local Ok = pcall(Fn, Text)
                return Ok, Ok
            end

            return true, false
        end

        -- system clipboard when readable, otherwise the last thing copied through the UI
        Library.PasteText = function(Self)
            local Fn = FindGlobal("getclipboard", "fromclipboard", "get_clipboard")

            if Fn then
                local Ok, Text = pcall(Fn)

                if Ok and type(Text) == "string" and Text:gsub("%s+", "") ~= "" then
                    return Text
                end
            end

            if Library.InternalClipboard ~= "" then
                return Library.InternalClipboard
            end

            return nil
        end

        -- ---------- base64 (for export strings) ----------
        local B64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

        local B64Encode = function(Data)
            local Bits = Data:gsub(".", function(Char)
                local Byte, Result = Char:byte(), ""

                for Index = 8, 1, -1 do
                    Result = Result .. ((Byte % 2 ^ Index - Byte % 2 ^ (Index - 1) > 0) and "1" or "0")
                end

                return Result
            end) .. "0000"

            local Encoded = Bits:gsub("%d%d%d?%d?%d?%d?", function(Chunk)
                if #Chunk < 6 then
                    return ""
                end

                local Value = 0

                for Index = 1, 6 do
                    Value = Value + ((Chunk:sub(Index, Index) == "1") and 2 ^ (6 - Index) or 0)
                end

                return B64Chars:sub(Value + 1, Value + 1)
            end)

            return Encoded .. ({ "", "==", "=" })[#Data % 3 + 1]
        end

        local B64Decode = function(Data)
            Data = Data:gsub("[^" .. B64Chars .. "=]", "")

            local Bits = Data:gsub(".", function(Char)
                if Char == "=" then
                    return ""
                end

                local Found = B64Chars:find(Char, 1, true)
                local Value, Result = Found - 1, ""

                for Index = 6, 1, -1 do
                    Result = Result .. ((Value % 2 ^ Index - Value % 2 ^ (Index - 1) > 0) and "1" or "0")
                end

                return Result
            end)

            local Decoded = Bits:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(Chunk)
                if #Chunk ~= 8 then
                    return ""
                end

                local Value = 0

                for Index = 1, 8 do
                    Value = Value + ((Chunk:sub(Index, Index) == "1") and 2 ^ (8 - Index) or 0)
                end

                return string.char(Value)
            end)

            return Decoded
        end

        Library.ConfigPrefix = "DOGYCFG1:"
        Library.ThemePrefix = "DOGYTHM1:"

        Library.ExportConfig = function(Self)
            local Json = Library:GetConfig()

            if not Json then
                return nil
            end

            return Library.ConfigPrefix .. B64Encode(Json)
        end

        Library.ImportConfig = function(Self, Text)
            Text = tostring(Text or ""):gsub("%s+", "")

            if Text:sub(1, #Library.ConfigPrefix) ~= Library.ConfigPrefix then
                return false, "this is not a config string"
            end

            local Ok, Json = pcall(B64Decode, Text:sub(#Library.ConfigPrefix + 1))

            if not Ok or Json == "" then
                return false, "the string is damaged"
            end

            return Library:LoadConfig(Json)
        end

        Library.ExportTheme = function(Self)
            local Data = { }

            for Index, Color in Library.Theme do
                Data[Index] = "#" .. Color:ToHex()
            end

            return Library.ThemePrefix .. B64Encode(HttpService:JSONEncode(Data))
        end

        Library.ImportTheme = function(Self, Text)
            Text = tostring(Text or ""):gsub("%s+", "")

            if Text:sub(1, #Library.ThemePrefix) ~= Library.ThemePrefix then
                return false, "this is not a theme string"
            end

            local Ok, Json = pcall(B64Decode, Text:sub(#Library.ThemePrefix + 1))
            local Decoded

            if Ok then
                Ok, Decoded = pcall(HttpService.JSONDecode, HttpService, Json)
            end

            if not Ok or type(Decoded) ~= "table" then
                return false, "the string is damaged"
            end

            local ThemeData = { }

            for Index, Hex in Decoded do
                if Library.Theme[Index] ~= nil and type(Hex) == "string" then
                    local Parsed, Color = pcall(Color3.fromHex, Hex)

                    if Parsed then
                        ThemeData[Index] = Color
                    end
                end
            end

            if next(ThemeData) == nil then
                return false, "no colors found"
            end

            Library:ApplyThemeData(ThemeData)
            return true
        end

        -- ---------- small helpers ----------
        local IsOverInstance = function(Instance_)
            if not Instance_ or not Instance_.Parent then
                return false
            end

            local X, Y = Mouse.X, Mouse.Y
            local Position, Size = Instance_.AbsolutePosition, Instance_.AbsoluteSize

            return X >= Position.X and X <= Position.X + Size.X and Y >= Position.Y and Y <= Position.Y + Size.Y
        end

        local ClampToScreen = function(X, Y, Width, Height)
            local Camera = workspace.CurrentCamera
            local Viewport = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)

            return math.clamp(X, 4, math.max(4, Viewport.X - Width - 4)), math.clamp(Y, 4, math.max(4, Viewport.Y - Height - 4))
        end

        -- ---------- tooltips ----------
        local Tooltip = { Token = 0, Visible = false }

        do
            Tooltip.Frame = Library:Create("Frame", {
                Name = "\0",
                Parent = Library.Holder.Instance,
                Visible = false,
                ZIndex = 5000,
                AutomaticSize = Enum.AutomaticSize.XY,
                Size = UDim2.new(0, 0, 0, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme["Tab"]
            }):AddToTheme({BackgroundColor3 = "Tab"})

            Library:Create("UICorner", { Name = "\0", Parent = Tooltip.Frame.Instance, CornerRadius = UDim.new(0, 5) })

            Library:Create("UIStroke", {
                Name = "\0",
                Parent = Tooltip.Frame.Instance,
                Color = Library.Theme["Outline"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            Library:Create("UIPadding", {
                Name = "\0",
                Parent = Tooltip.Frame.Instance,
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8)
            })

            Tooltip.Label = Library:Create("TextLabel", {
                Name = "\0",
                FontFace = Library.Font,
                TextSize = Library.FontSize - 1,
                Parent = Tooltip.Frame.Instance,
                TextColor3 = Library.Theme["Text"],
                Text = "",
                ZIndex = 5001,
                TextWrapped = true,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.XY,
                Size = UDim2.new(0, 0, 0, 0)
            }):AddToTheme({TextColor3 = "Text"})

            Library:Create("UISizeConstraint", {
                Name = "\0",
                Parent = Tooltip.Label.Instance,
                MaxSize = Vector2.new(250, math.huge)
            })

            Library:Connect(RunService.RenderStepped, function()
                if not Tooltip.Visible then
                    return
                end

                local Location = UserInputService:GetMouseLocation()
                local Size = Tooltip.Frame.Instance.AbsoluteSize
                local X, Y = ClampToScreen(Location.X + 14, Location.Y + 16, Size.X, Size.Y)

                Tooltip.Frame.Instance.Position = UDim2.new(0, X, 0, Y)
            end)
        end

        Library.ShowTooltip = function(Self, Text)
            Text = tostring(Text or "")

            if Text == "" then
                return
            end

            Tooltip.Label.Instance.Text = Text
            Tooltip.Frame.Instance.Visible = true
            Tooltip.Visible = true
        end

        Library.HideTooltip = function(Self)
            Tooltip.Token += 1
            Tooltip.Visible = false
            Tooltip.Frame.Instance.Visible = false
        end

        local BindTooltip = function(HoverInstance, GetText)
            HoverInstance.MouseEnter:Connect(function()
                if Library.PopupShield and Library.PopupShield.Instance.Visible then
                    local InsidePopup = false
                    for _, FrameData in Library.OpenFrames do
                        if FrameData.Modal and FrameData.PopupInstance
                            and HoverInstance:IsDescendantOf(FrameData.PopupInstance) then
                            InsidePopup = true
                            break
                        end
                    end
                    if not InsidePopup then return end
                end
                Tooltip.Token += 1
                local Token = Tooltip.Token

                task.delay(0.35, function()
                    if Tooltip.Token ~= Token or not Library then
                        return
                    end

                    local Text = GetText()

                    if Text and Text ~= "" then
                        Library:ShowTooltip(Text)
                    end
                end)
            end)

            HoverInstance.MouseLeave:Connect(function()
                Library:HideTooltip()
            end)
        end

        -- ---------- context menu ----------
        local ContextMenu = { Entries = { } }

        do
            ContextMenu.Frame = Library:Create("Frame", {
                Name = "\0",
                Parent = Library.Holder.Instance,
                Visible = false,
                ZIndex = 4000,
                Size = UDim2.new(0, 160, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme["Tab"]
            }):AddToTheme({BackgroundColor3 = "Tab"})

            Library:Create("UICorner", { Name = "\0", Parent = ContextMenu.Frame.Instance, CornerRadius = UDim.new(0, 6) })

            Library:Create("UIStroke", {
                Name = "\0",
                Parent = ContextMenu.Frame.Instance,
                Color = Library.Theme["Outline"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            Library:Create("UIPadding", {
                Name = "\0",
                Parent = ContextMenu.Frame.Instance,
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4)
            })

            Library:Create("UIListLayout", {
                Name = "\0",
                Parent = ContextMenu.Frame.Instance,
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Library:Connect(UserInputService.InputBegan, function(Input)
                if not ContextMenu.Frame.Instance.Visible then
                    return
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1
                    or Input.UserInputType == Enum.UserInputType.MouseButton2
                    or Input.UserInputType == Enum.UserInputType.Touch then
                    -- the frame is a plain Frame, so clicks on its buttons are checked by hit test
                    if not IsOverInstance(ContextMenu.Frame.Instance) then
                        Library:CloseContextMenu()
                    end
                end
            end)
        end

        Library.CloseContextMenu = function(Self)
            ContextMenu.Frame.Instance.Visible = false
        end

        -- Entries = { { Name = "Reset", Callback = fn, Disabled = bool }, ... }
        Library.OpenContextMenu = function(Self, Entries)
            for _, Entry in ContextMenu.Entries do
                pcall(function() Entry:Destroy() end)
            end

            table.clear(ContextMenu.Entries)

            for Index, Data in Entries do
                local Button = Instance.new("TextButton")
                Button.Name = "\0"
                Button.Parent = ContextMenu.Frame.Instance
                Button.LayoutOrder = Index
                Button.Size = UDim2.new(1, 0, 0, 24)
                Button.BackgroundColor3 = Library.Theme["Hovered Element"]
                Button.BackgroundTransparency = 1
                Button.BorderSizePixel = 0
                Button.AutoButtonColor = false
                Button.FontFace = Library.Font
                Button.TextSize = Library.FontSize - 1
                Button.TextXAlignment = Enum.TextXAlignment.Left
                Button.TextColor3 = Data.Disabled and Library.Theme["Inactive Text"] or Library.Theme["Text"]
                Button.Text = "  " .. Data.Name
                Button.ZIndex = 4001

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 4)
                Corner.Parent = Button

                if not Data.Disabled then
                    Button.MouseEnter:Connect(function()
                        TweenService:Create(Button, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
                    end)

                    Button.MouseLeave:Connect(function()
                        TweenService:Create(Button, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
                    end)

                    Button.MouseButton1Click:Connect(function()
                        Library:CloseContextMenu()
                        Library:SafeCall(Data.Callback)
                    end)
                end

                table.insert(ContextMenu.Entries, Button)
            end

            local Location = UserInputService:GetMouseLocation()
            local Height = 8 + #Entries * 26
            local X, Y = ClampToScreen(Location.X + 4, Location.Y + 4, 160, Height)

            ContextMenu.Frame.Instance.Position = UDim2.new(0, X, 0, Y)
            ContextMenu.Frame.Instance.Visible = true
            Library:HideTooltip()
        end

        -- ---------- RangeSlider ----------
        -- Section:RangeSlider({ Name = "Distance", Min = 0, Max = 500, Default = { Min = 50, Max = 300 },
        --     Step = 5, Suffix = "m", Flag = "Dist", Tooltip = "...", Callback = function(Min, Max) end })
        -- Flag value: { Min = n, Max = n }
        Library.RangeSlider = function(Self, Params)
            Params = Params or { }

            local MinLimit = Params.Min or Params.min or 0
            local MaxLimit = Params.Max or Params.max or 100
            local Default = Params.Default or Params.default

            local DefaultMin, DefaultMax

            if type(Default) == "table" then
                DefaultMin = Default.Min or Default.min or Default[1]
                DefaultMax = Default.Max or Default.max or Default[2]
            end

            DefaultMin = DefaultMin or Params.DefaultMin or MinLimit
            DefaultMax = DefaultMax or Params.DefaultMax or MaxLimit

            local Range = {
                Name = Params.Name or Params.name or "Range",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name or "Range"),
                Min = MinLimit,
                Max = MaxLimit,
                Step = Params.Step or Params.step,
                Decimals = Params.Decimals or Params.decimals or 0,
                Suffix = Params.Suffix or Params.suffix or "",
                Callback = Params.Callback or Params.callback or function() end,
                Default = { Min = DefaultMin, Max = DefaultMax },

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { Min = DefaultMin, Max = DefaultMax },
                Sliding = nil,
                Items = { }
            }

            local Parent = Params.Parent or Range.Section.Items["Content"]
            local Items = { } do
                Items["RangeSlider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RangeSlider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Range.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = "Text"})

                Items["Outline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RangeSlider"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = "Outline"})

                Library:Create("UICorner", { Name = "\0", Parent = Items["Outline"].Instance, CornerRadius = UDim.new(0, 2) })

                Items["Track"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = "Background"})

                Library:Create("UICorner", { Name = "\0", Parent = Items["Track"].Instance, CornerRadius = UDim.new(0, 4) })

                Items["Fill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Track"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = "Accent"})

                Library:Create("UICorner", { Name = "\0", Parent = Items["Fill"].Instance, CornerRadius = UDim.new(0, 4) })

                for _, Side in { "Min", "Max" } do
                    Items["Dragger" .. Side] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Track"].Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0,
                        ZIndex = 2
                    })

                    Library:Create("UICorner", { Name = "\0", Parent = Items["Dragger" .. Side].Instance, CornerRadius = UDim.new(1, 0) })

                    Items["Dragger" .. Side .. "Inline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Dragger" .. Side].Instance,
                        Position = UDim2.new(0, 2, 0, 2),
                        Size = UDim2.new(1, -4, 1, -4),
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        BackgroundColor3 = Library.Theme["Accent"]
                    }):AddToTheme({BackgroundColor3 = "Accent"})

                    Library:Create("UICorner", { Name = "\0", Parent = Items["Dragger" .. Side .. "Inline"].Instance, CornerRadius = UDim.new(1, 0) })
                end

                Items["Value"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RangeSlider"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "",
                    PlaceholderText = "min - max",
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 120, 0, 18),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    MultiLine = false
                }):AddToTheme({TextColor3 = "Inactive Text", PlaceholderColor3 = "Inactive Text"})

                Range.Items = Items
            end

            local Span = function()
                return Range.Max - Range.Min
            end

            local Fraction = function(Value)
                local Total = Span()
                return Total == 0 and 0 or math.clamp((Value - Range.Min) / Total, 0, 1)
            end

            local Normalize = function(Value)
                Value = math.clamp(tonumber(Value) or Range.Min, Range.Min, Range.Max)

                if Range.Step and Range.Step > 0 then
                    Value = Range.Min + math.floor((Value - Range.Min) / Range.Step + 0.5) * Range.Step
                    Value = math.clamp(Value, Range.Min, Range.Max)
                end

                return Library:Round(Value, Range.Decimals)
            end

            local FormatText = function()
                return string.format("%s%s - %s%s", Range.Value.Min, Range.Suffix, Range.Value.Max, Range.Suffix)
            end

            local Info = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            local Redraw = function()
                local P1, P2 = Fraction(Range.Value.Min), Fraction(Range.Value.Max)

                Items["Fill"]:Tween({
                    Position = UDim2.new(P1, 6 - P1 * 12, 0, 0),
                    Size = UDim2.new(P2 - P1, -(P2 - P1) * 12, 1, 0)
                }, Info)

                Items["DraggerMin"]:Tween({Position = UDim2.new(P1, 6 - P1 * 12, 0.5, 0)}, Info)
                Items["DraggerMax"]:Tween({Position = UDim2.new(P2, 6 - P2 * 12, 0.5, 0)}, Info)

                if not Items["Value"].Instance:IsFocused() then
                    Items["Value"].Instance.Text = FormatText()
                end
            end

            function Range:Set(Low, High)
                if type(Low) == "table" then
                    Low, High = Low.Min or Low.min or Low[1], Low.Max or Low.max or Low[2]
                end

                Low = Normalize(Low == nil and Range.Value.Min or Low)
                High = Normalize(High == nil and Range.Value.Max or High)

                if Low > High then
                    Low, High = High, Low
                end

                Range.Value = { Min = Low, Max = High }
                Flags[Range.Flag] = { Min = Low, Max = High }

                Redraw()
                Library:SafeCall(Range.Callback, Low, High)
            end

            function Range:SetVisibility(Bool)
                Items["RangeSlider"].Instance.Visible = Bool
            end

            function Range:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local ValueAt = function(Input)
                local Track = Items["Track"].Instance
                local Width = Track.AbsoluteSize.X - 12

                if Width <= 0 then
                    return Range.Min
                end

                local Alpha = math.clamp((Input.Position.X - Track.AbsolutePosition.X - 6) / Width, 0, 1)
                return Range.Min + Span() * Alpha
            end

            local Drag = function(Input)
                if not Range.Sliding then
                    return
                end

                local Value = Normalize(ValueAt(Input))

                if Range.Sliding == "Min" then
                    Range:Set(math.min(Value, Range.Value.Max), Range.Value.Max)
                else
                    Range:Set(Range.Value.Min, math.max(Value, Range.Value.Min))
                end
            end

            local InputChanged

            Items["Outline"]:Connect("InputBegan", function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                local Value = ValueAt(Input)
                local ToMin = math.abs(Value - Range.Value.Min)
                local ToMax = math.abs(Value - Range.Value.Max)

                if ToMin == ToMax then
                    Range.Sliding = Value < Range.Value.Min and "Min" or "Max"
                else
                    Range.Sliding = ToMin < ToMax and "Min" or "Max"
                end

                Drag(Input)

                if InputChanged then
                    return
                end

                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Range.Sliding = nil
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Range.Sliding and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    Drag(Input)
                end
            end)

            Items["Value"]:Connect("FocusLost", function()
                local Numbers = { }

                for Number in tostring(Items["Value"].Instance.Text):gmatch("%-?%d+%.?%d*") do
                    table.insert(Numbers, tonumber(Number))
                end

                if #Numbers >= 2 then
                    Range:Set(Numbers[1], Numbers[2])
                else
                    Items["Value"].Instance.Text = FormatText()
                end
            end)

            Range:Set(Range.Default.Min, Range.Default.Max)

            SetFlags[Range.Flag] = function(Value)
                Range:Set(Value)
            end

            return setmetatable(Range, Library)
        end

        -- ---------- element decoration: Tooltip, DependsOn, search, context menu ----------
        Library.Dependents = { }

        local ParseClipboardValue = function(Kind, Text)
            Text = tostring(Text or "")
            local Trimmed = Text:gsub("^%s+", ""):gsub("%s+$", "")

            if Kind == "Toggle" then
                local Lower = Trimmed:lower()

                if Lower == "true" or Lower == "1" or Lower == "on" or Lower == "yes" then
                    return true
                elseif Lower == "false" or Lower == "0" or Lower == "off" or Lower == "no" then
                    return false
                end

                return nil
            elseif Kind == "Slider" then
                return tonumber((Trimmed:gsub("[^%d%.%-]", "")))
            elseif Kind == "RangeSlider" then
                local Numbers = { }

                for Number in Trimmed:gmatch("%-?%d+%.?%d*") do
                    table.insert(Numbers, tonumber(Number))
                end

                if #Numbers >= 2 then
                    return { Min = Numbers[1], Max = Numbers[2] }
                end

                return nil
            elseif Kind == "Dropdown" then
                if Trimmed:sub(1, 1) == "{" or Trimmed:sub(1, 1) == "[" then
                    local Ok, Decoded = pcall(HttpService.JSONDecode, HttpService, Trimmed)

                    if Ok and type(Decoded) == "table" then
                        return Decoded
                    end
                end

                return Trimmed
            end

            return Text
        end

        local ValueToText = function(Kind, Value)
            if Kind == "RangeSlider" and type(Value) == "table" then
                return tostring(Value.Min) .. " - " .. tostring(Value.Max)
            end

            if type(Value) == "table" then
                local Ok, Encoded = pcall(HttpService.JSONEncode, HttpService, Value)
                return Ok and Encoded or ""
            end

            return tostring(Value)
        end

        local ValueKinds = { Toggle = true, Slider = true, Dropdown = true, Textbox = true, RangeSlider = true }

        local DependencySatisfied = function(Dependency)
            local Current = Library.Flags[Dependency.Flag]

            if type(Current) == "table" and Dependency.Value ~= nil and type(Dependency.Value) ~= "table" then
                -- multi dropdown: satisfied when the option is selected
                for Key, Value in Current do
                    if Value == Dependency.Value or (Value == true and Key == Dependency.Value) then
                        return true
                    end
                end

                return false
            end

            if Dependency.Value == nil then
                return Current == true
            end

            return Current == Dependency.Value
        end

        local ParseDependencies = function(Raw)
            local List = { }

            if Raw == nil then
                return List
            end

            local Add

            Add = function(Entry)
                if type(Entry) == "string" then
                    table.insert(List, { Flag = Entry, Value = true })
                elseif type(Entry) == "table" and Entry.Flag and not Entry.Items then
                    table.insert(List, { Flag = Entry.Flag, Value = Entry.Value == nil and true or Entry.Value })
                elseif type(Entry) == "table" and Entry.Flag and Entry.Items then
                    -- a Toggle object
                    table.insert(List, { Flag = Entry.Flag, Value = true })
                elseif type(Entry) == "table" then
                    if Entry[1] ~= nil and type(Entry[1]) == "string" and Entry[2] ~= nil and type(Entry[2]) ~= "table" then
                        table.insert(List, { Flag = Entry[1], Value = Entry[2] })
                    else
                        for _, Sub in Entry do
                            Add(Sub)
                        end
                    end
                end
            end

            Add(Raw)
            return List
        end

        local DimElement = function(Element, Disabled)
            local Root = Element.RootInstance

            if not Root then
                return
            end

            Element.DimBase = Element.DimBase or { }

            local Targets = Root:GetDescendants()
            table.insert(Targets, Root)

            for _, Object in Targets do
                if Object.Name == "Blocker" then
                    continue
                end

                local Properties = Library:GetTweenProperty(Object)

                if type(Properties) == "table" then
                    for _, Property in Properties do
                        Element.DimBase[Object] = Element.DimBase[Object] or { }

                        local Base = Element.DimBase[Object][Property]

                        if Base == nil then
                            local Ok, Value = pcall(function() return Object[Property] end)

                            if Ok then
                                Base = Value
                                Element.DimBase[Object][Property] = Value
                            end
                        end

                        if Base ~= nil then
                            local Target = Disabled and (1 - (1 - Base) * 0.4) or Base
                            TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {[Property] = Target}):Play()
                        end
                    end
                end
            end
        end

        Library.DecorateElement = function(Self, Element, Params, Kind, Section, RootName)
            local Items = Element.Items or { }
            local RootItem = Items[RootName]

            if not RootItem or not RootItem.Instance then
                return
            end

            local Root = RootItem.Instance

            Element.Kind = Kind
            Element.RootInstance = Root
            Element.Name = Element.Name or Params.Name or Params.name or ""
            Element.Searchable = Kind ~= "ListBox"

            Section.Elements = Section.Elements or { }
            table.insert(Section.Elements, Element)
            Library.AllResettableElements = Library.AllResettableElements or {}
            table.insert(Library.AllResettableElements, Element)

            -- composite visibility: user + search + dependency
            Element.HiddenBy = { User = false, Search = false, Depend = false }

            local RefreshVisibility = function()
                local Hidden = Element.HiddenBy.User or Element.HiddenBy.Search or Element.HiddenBy.Depend
                Root.Visible = not Hidden
            end

            Element.SetVisibility = function(_, Bool)
                Element.HiddenBy.User = not Bool
                RefreshVisibility()
            end

            Element.SetSearchHidden = function(_, Bool)
                Element.HiddenBy.Search = Bool and true or false
                RefreshVisibility()
            end

            if Params.Visible == false then
                Element.HiddenBy.User = true
                RefreshVisibility()
            end

            -- tooltip on the option name
            Element.Tooltip = Params.Tooltip or Params.tooltip
            Element.DisabledTooltip = Params.DisabledTooltip or Params.disabledtooltip

            local HoverInstance = (Items["Text"] and Items["Text"].Instance) or Root
            local TooltipBound = false

            local BindElementTooltip = function()
                if TooltipBound then
                    return
                end

                TooltipBound = true

                BindTooltip(HoverInstance, function()
                    if Element.Disabled and Element.DisabledTooltip then
                        return Element.DisabledTooltip
                    end

                    return Element.Tooltip
                end)
            end

            if Element.Tooltip or Element.DisabledTooltip then
                BindElementTooltip()
            end

            Element.SetTooltip = function(_, Text)
                Element.Tooltip = Text
                BindElementTooltip()
            end

            -- DependsOn: grey out (default) or hide until the parent toggle / value is set
            Element.DependsMode = tostring(Params.DependsMode or Params.dependsmode or "Disable")
            Element.Dependencies = ParseDependencies(Params.DependsOn or Params.dependson or Params.Depends or Params.depends)
            Element.Disabled = false

            Element.SetDisabled = function(_, Bool)
                Bool = Bool and true or false

                if Element.Disabled == Bool then
                    return
                end

                Element.Disabled = Bool

                if not Element.Blocker then
                    local Blocker = Instance.new("TextButton")
                    Blocker.Name = "Blocker"
                    Blocker.Text = ""
                    Blocker.AutoButtonColor = false
                    Blocker.BackgroundTransparency = 1
                    Blocker.BorderSizePixel = 0
                    Blocker.Size = UDim2.new(1, 0, 1, 0)
                    Blocker.ZIndex = 3
                    Blocker.Active = true
                    Blocker.Visible = false
                    Blocker.Parent = Root
                    Element.Blocker = Blocker

                    if Element.DisabledTooltip then
                        BindElementTooltip()
                    end
                end

                Element.Blocker.Visible = Bool
                DimElement(Element, Bool)
            end

            if #Element.Dependencies > 0 then
                local Apply = function()
                    local Satisfied = true

                    for _, Dependency in Element.Dependencies do
                        if not DependencySatisfied(Dependency) then
                            Satisfied = false
                            break
                        end
                    end

                    if Element.DependsMode == "Hide" then
                        Element.HiddenBy.Depend = not Satisfied
                        RefreshVisibility()
                    else
                        Element:SetDisabled(not Satisfied)
                    end
                end

                Element.UpdateDependency = Apply
                table.insert(Library.Dependents, Element)
                task.defer(Apply)
            end
        end

        do
            local Roots = {
                Toggle = "Toggle",
                Slider = "Slider",
                Dropdown = "Dropdown",
                Button = "Button",
                Label = "Label",
                Textbox = "Textbox",
                ListBox = "List",
                RangeSlider = "RangeSlider"
            }

            for Kind, RootName in Roots do
                local Original = Library[Kind]

                if type(Original) == "function" then
                    Library[Kind] = function(Self, Params)
                        local Element = Original(Self, Params)

                        if type(Element) == "table" then
                            local Ok, Err = pcall(Library.DecorateElement, Library, Element, Params or { }, Kind, Self, RootName)

                            if not Ok then
                                warn("[Library] element setup failed (" .. Kind .. "): " .. tostring(Err))
                            end
                        end

                        return Element
                    end
                end
            end

            -- dividers are hidden while searching
            local OriginalDivider = Library.Divider

            Library.Divider = function(Self)
                local Items = OriginalDivider(Self)

                if type(Items) == "table" and Items["Divider"] then
                    Self.Dividers = Self.Dividers or { }
                    table.insert(Self.Dividers, Items["Divider"].Instance)
                end

                return Items
            end

            -- colorpickers attached to rows are reset together with their section
            local OriginalColorpicker = Library.CreateColorpicker

            Library.CreateColorpicker = function(Self, Data)
                local Picker, PickerItems = OriginalColorpicker(Self, Data)
                local Section = Data and Data.Section

                if type(Section) == "table" and Picker then
                    Section.Elements = Section.Elements or { }

                    local Default = Data.Default
                    local DefaultAlpha = Data.Alpha

                    local ResetEntry = {
                        Kind = "Colorpicker",
                        Name = "",
                        Searchable = false,
                        Default = Default,
                        Set = function(_, Value)
                            Picker:Set(Value, DefaultAlpha)
                        end,
                        SetSearchHidden = function() end,
                        HiddenBy = { }
                    }
                    table.insert(Section.Elements, ResetEntry)
                    Library.AllResettableElements = Library.AllResettableElements or {}
                    table.insert(Library.AllResettableElements, ResetEntry)
                end

                return Picker, PickerItems
            end

            -- dependency polling (parent toggles can change from anywhere: configs, keybinds, code)
            local Accumulator = 0

            Library:Connect(RunService.Heartbeat, function(Delta)
                Accumulator += Delta

                if Accumulator < 0.1 then
                    return
                end

                Accumulator = 0

                for _, Element in Library.Dependents do
                    if Element.UpdateDependency then
                        Element.UpdateDependency()
                    end
                end
            end)
        end

        -- ---------- Section extras: registry + Reset section button ----------
        do
            local OriginalSection = Library.Section

            Library.Section = function(Self, Params)
                Params = Params or { }

                local Section = OriginalSection(Self, Params)

                if type(Section) ~= "table" then
                    return Section
                end

                Section.Elements = Section.Elements or { }
                Self.Sections = Self.Sections or { }
                table.insert(Self.Sections, Section)

                if Library.WindowOpacity and Library.WindowOpacity > 0 then
                    Section.Items["Section"].Instance.BackgroundTransparency = Library.WindowOpacity
                    Section.Items["Top"].Instance.BackgroundTransparency = Library.WindowOpacity
                end

                function Section:ResetAll()
                    local Count = 0

                    for _, Element in Section.Elements do
                        if Element.Default ~= nil and Element.Set then
                            local Ok = pcall(function()
                                if Element.Kind == "RangeSlider" then
                                    Element:Set(Element.Default.Min, Element.Default.Max)
                                else
                                    Element:Set(Element.Default)
                                end
                            end)

                            if Ok then
                                Count += 1
                            end
                        end
                    end

                    return Count
                end

                if Params.ResetButton or Params.resetbutton or Params.Resettable or Params.resettable then
                    local Top = Section.Items["Top"].Instance
                    local Offset = Section.Collapsible and 38 or 14

                    local Button = Instance.new("TextButton")
                    Button.Name = "\0"
                    Button.AnchorPoint = Vector2.new(1, 0.5)
                    Button.Position = UDim2.new(1, -Offset, 0.5, 0)
                    Button.Size = UDim2.new(0, 22, 0, 22)
                    Button.BackgroundTransparency = 1
                    Button.BorderSizePixel = 0
                    Button.AutoButtonColor = false
                    Button.Text = ""
                    Button.ZIndex = 3
                    Button.Parent = Top

                    local Icon = Instance.new("ImageLabel")
                    Icon.Name = "\0"
                    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
                    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Icon.Size = UDim2.new(0, 15, 0, 15)
                    Icon.BackgroundTransparency = 1
                    Icon.BorderSizePixel = 0
                    Icon.ImageColor3 = Library.Theme["Inactive Text"]
                    Icon.ZIndex = 3
                    Icon.Parent = Button

                    if not Library:ApplyIcon(Icon, "rotate-ccw") then
                        Icon:Destroy()
                        Button.Text = "R"
                        Button.FontFace = Library.Font
                        Button.TextSize = Library.FontSize
                        Button.TextColor3 = Library.Theme["Inactive Text"]
                    end

                    Button.MouseEnter:Connect(function()
                        if Icon.Parent then
                            TweenService:Create(Icon, TweenInfo.new(0.15), {ImageColor3 = Library.Theme["Accent"]}):Play()
                        end

                        Library:ShowTooltipLater("Reset this section")
                    end)

                    Button.MouseLeave:Connect(function()
                        if Icon.Parent then
                            TweenService:Create(Icon, TweenInfo.new(0.15), {ImageColor3 = Library.Theme["Inactive Text"]}):Play()
                        end

                        Library:HideTooltip()
                    end)

                    local ResetArmed = false
                    local ResetToken = 0
                    Button.MouseButton1Click:Connect(function()
                        if not ResetArmed then
                            ResetArmed = true
                            ResetToken += 1
                            local Token = ResetToken
                            local OriginalText = Button.Text
                            Button.Text = "?"
                            Icon.Visible = false
                            Button.BackgroundTransparency = 0.15
                            Button.BackgroundColor3 = Library.Theme["Accent"]
                            Library:ShowTooltip("Click again to reset this section")
                            task.delay(2.5, function()
                                if ResetArmed and ResetToken == Token and Button.Parent then
                                    ResetArmed = false
                                    Button.Text = OriginalText
                                    Icon.Visible = true
                                    Button.BackgroundTransparency = 1
                                end
                            end)
                            return
                        end

                        ResetArmed = false
                        ResetToken += 1
                        Button.Text = ""
                        Icon.Visible = true
                        Button.BackgroundTransparency = 1
                        local Count = Section:ResetAll()
                        Library:Notification({
                            Name = "Section reset",
                            Description = Section.Name .. ": " .. Count .. " options restored.",
                            Type = "Success",
                            Duration = 2
                        })
                    end)
                end

                return Section
            end

            Library.ShowTooltipLater = function(Self, Text)
                Tooltip.Token += 1
                local Token = Tooltip.Token

                task.delay(0.35, function()
                    if Tooltip.Token == Token then
                        Library:ShowTooltip(Text)
                    end
                end)
            end
        end

        -- ---------- notifications side ----------
        Library.NotificationSide = Library.NotificationSide or "Right"

        Library.SetNotificationSide = function(Self, Side)
            Side = tostring(Side or "Right")
            Side = (Side:lower() == "left") and "Left" or "Right"

            Library.NotificationSide = Side

            local Stack = Library.NotificationStack and Library.NotificationStack.Instance
            if not Stack then return end
            if Side == "Left" then
                Stack.AnchorPoint = Vector2.new(0, 0)
                Stack.Position = UDim2.new(0, 14, 0, GuiInset + 8)
            else
                Stack.AnchorPoint = Vector2.new(1, 0)
                Stack.Position = UDim2.new(1, -14, 0, GuiInset + 8)
            end
            local Layout = Stack:FindFirstChildOfClass("UIListLayout")
            if Layout then
                Layout.HorizontalAlignment = Side == "Left" and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
            end
        end

        Library:SetNotificationSide(Library.NotificationSide)

        -- ---------- UI state (window position, last tab, scale, opacity, font, ...) ----------
        Library.UIState = Library.UIState or { }
        Library.WindowOpacity = Library.WindowOpacity or 0
        Library.FigtreeFont = Library.FigtreeFont or Library.Font
        Library.ThemeAnimation = true

        local UIStatePath = function()
            return Library.Directory .. "/ui_state.json"
        end

        Library.UIStateLoaded = false

        Library.LoadUIState = function(Self)
            local Ok, Content = pcall(readfile, UIStatePath())

            if Ok and type(Content) == "string" and Content ~= "" then
                local Decoded
                Ok, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)

                if Ok and type(Decoded) == "table" then
                    Library.UIState = Decoded
                end
            end

            Library.UIStateLoaded = true
            return Library.UIState
        end

        Library.SaveUIState = function(Self)
            -- nothing is written before the saved state was read, otherwise the defaults would overwrite it
            if not Library.UIStateLoaded then
                return
            end

            local Window = Library.ActiveWindow

            if not Library.RestoringUI and Window and Window.Items and Window.Items.MainFrame and Library.UIState.RememberUI ~= false then
                local Frame = Window.Items.MainFrame.Instance

                if Frame and Frame.AnchorPoint == Vector2.new(0, 0) then
                    Library.UIState.X = Frame.Position.X.Offset
                    Library.UIState.Y = Frame.Position.Y.Offset
                end

                if Window.Current then
                    Library.UIState.Page = Window.Current.Name
                end
            end

            pcall(writefile, UIStatePath(), HttpService:JSONEncode(Library.UIState))
        end

        Library.QueueSaveUIState = function(Self)
            if Library.SaveQueued then
                return
            end

            Library.SaveQueued = true

            task.delay(0.6, function()
                Library.SaveQueued = false

                if Library then
                    Library:SaveUIState()
                end
            end)
        end

        local ApplyFontToTree = function(Root, FontFace)
            if not Root then
                return
            end

            for _, Object in Root:GetDescendants() do
                if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
                    pcall(function() Object.FontFace = FontFace end)
                end
            end
        end

        Library.FontChoices = { "Figtree", "Gotham", "Ubuntu", "Code", "RobotoMono", "Montserrat", "Nunito", "Arial", "SourceSans" }

        Library.SetUIFont = function(Self, Name)
            local FontFace

            if Name == "Figtree" or not Enum.Font[Name] then
                FontFace = Library.FigtreeFont
            else
                FontFace = Font.fromEnum(Enum.Font[Name])
            end

            if not FontFace then
                return false
            end

            Library.Font = FontFace
            ApplyFontToTree(Library.Holder and Library.Holder.Instance, FontFace)
            ApplyFontToTree(Library.NotifHolder and Library.NotifHolder.Instance, FontFace)
            return true
        end

        Library.SetUIScale = function(Self, Scale)
            Scale = math.clamp(tonumber(Scale) or 1, 0.5, 1.5)

            local Window = Library.ActiveWindow

            if not Window or not Window.Items or not Window.Items.MainFrame then
                return
            end

            local Frame = Window.Items.MainFrame.Instance
            local ScaleObject = Frame:FindFirstChild("UserScale")

            if not ScaleObject then
                ScaleObject = Instance.new("UIScale")
                ScaleObject.Name = "UserScale"
                ScaleObject.Parent = Frame
            end

            TweenService:Create(ScaleObject, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = Scale}):Play()
        end

        Library.SetWindowOpacity = function(Self, Transparency)
            Transparency = math.clamp(tonumber(Transparency) or 0, 0, 0.7)
            Library.WindowOpacity = Transparency

            local Window = Library.ActiveWindow

            if not Window or not Window.Items then
                return
            end

            Window.Items.MainFrame.Instance.BackgroundTransparency = Transparency
            Window.Items.Top.Instance.BackgroundTransparency = Transparency

            for _, Page in Window.Pages do
                for _, Section in Page.Sections or { } do
                    Section.Items["Section"].Instance.BackgroundTransparency = Transparency
                    Section.Items["Top"].Instance.BackgroundTransparency = Transparency
                end
            end
        end

        -- ---------- mimisense v27: native-position nine-slice soft glow ----------
        -- Custom 128x128 RGBA asset embedded in Source.lua (no GitHub image
        -- download needed). The middle 64x64 region is fully transparent.
        -- Unlike Stretch, nine-slice preserves the gradient and the corners.
        Library.MenuGlowEnabled = Library.MenuGlowEnabled ~= false
        Library.MenuGlowStrength = math.clamp(tonumber(Library.MenuGlowStrength) or 65, 0, 100)
        Library.MenuGlowPadding = math.clamp(tonumber(Library.MenuGlowPadding) or 30, 12, 40)
        Library.OuterGlowMap = setmetatable({}, {__mode='k'})
        local CachedGlowAsset
        local SoftGlowBase64 = [[
            iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAKHUlEQVR42u2d25KjOAyGZUP2ofMA89DbYO1NU+todDTkwiBVUSEk
            nQT/nw6WmaEgYgHdSvC1EviMM989k+Hg63jimOu7iwHAWfHPAnJ3GxX4Mgg0AMqXhX8yCFeJjCejiQjAVeKXAQjuDIJXHO35pRBw
            AHhFKReBUB4OAF4kPI5AQAG4Qvzo/lMgiIb06P4QBD0AI+J/Y/9JEQC/vG9CcADwDfHPvj57RPCEYG7/7OshCAoi1ovE145F33/3
            PgAGBcaTQKizgDoo/igEJQDJ7CB4Qn70cRQIcRZQLxbf8xiF4A4AeMX/FhjiLKB+SXzrmOdv7pAGJIEs8UfgCEOwXiy+dEyDwBMZ
            Zi8CvWIXYR+Z88fuPdzfSZ/18Xx1FICW+B5P145ZUNwNABSeoyIYJ7wEgxeCjwhQLhDf8uzops0OZoNAExwVEMAAoochCkEBAFxh
            rO9fnB6vbXUAhJkBsLYWAIITnoPAAqisQdFHxa/C8+oAYsZI4PH8RvYLA0EzvsOCwIRhdYZ+KRVY4ldB9Koco393JwCo6I0RrHWv
            VwMEKjwX+tVUsDo93lPZa8JToT3HZk8DnPc3In7rhG7d+fYRwQKBFoXohEAsAsGZ+yHo8dy2GADUmwDQDAB2Ziwb+SwNBCRjhMZM
            QiwCI505K+d7RF8UEGaOApL3c8JTb9dgaMY4aP0ENhV4GkFe4TWPX5jHhXmuRYNZAdC8vnaevXfi78q59ikDnCCEGkHanN+CQRK/
            F3olAHAw3BmAvXvcOxCObXOcaxOaQaDUA+CpAbwrcxSMKkBABV6Z/VWBgJsRzFQDUAA48TdhCrwblX8fBbjZgCsVrI7Cz9vgqYr4
            vdh0f1WiQRWiz0wAUO/fGe/fAtEOmSgQqQn+agUXh/DgqPy94r+I+FwkOD7jThGAev+mhH9veqlMOkBGS3FRyGoEgXPuX40o0Av/
            EmA43ifVATPWAFL+337PcXPMdqTWMO0dSD0BLR3A6igArfyv5X7q6S8CwkuIAvWmKaCv/nfjHK3VRCR/J9UBoBWCViPIu5zLTflW
            4v3c1kcBLgLM6P1aFNi7c9uF4k8DaTEg4KIACPlfLAJL0PurUQAuQhR4MfWAlP/v0gns5/2b4vncekH/GRIEVhQAaRpo5X0r90dT
            wEtIAYtS/M0MAG34aF6vrRjSdnDpnkeiwEcN4L3qxsr9RZjOafn/JfQBZg79VgVeFADQ0T6m6wJSLYDaGgA3C7CKP08rmEaBVYgC
            q9AHkAqiP5NC8O7OowoAeIWnU8amaOG+MGQNhn8IzAC0OmAVPL/P+bOKDgK4b0EUVJpGdAz7NMBBAEy0UdNADYYzqQ3sKQK153cU
            X4KhGA0z6bm1YgojNVN15H/v9X4WCE/y/DMQaGMk9Uei11IWDgBrPQCcawPcEjC30rcwBN9ZfA6CAvo1EtIKaTGKSY+GLADWNfnR
            C0C4k+inek8TX4KgGGNVg1HA0g+sCBD5z528qUC6FrA8TPweAu2ayUjoH9XvI/d600D0Wn/tauC0z5pAGqfIv6dwh38AKHXgh4Kj
            LtCu8p15gedb4nsvqvWMW2hMa/BHWr0CcEQHba78xDSgRYMSGGdLryEAihMGDyTWj84ooP8by5HxD88Czvx4cPzwtLFUq0WAU1Zz
            rJ9tCUACkJYApCUAaQlAWgKQlgCkJQBpCUBaApCWAKQlAGkJQFoCkJYApCUAaQlAWgKQlgCkJQBpCUBaApCWAKQlAGkJQFoCkJYA
            pCUAaQlAWgKQlgCkJQBpCUBaApCWAKQlAGkJQFoCkJYApCUAafcC4LjXDX3O3RsnzT+mYIwpXjGmNfhDtC9Gxw9HBZCnC66N1ej4
            m45XB71cE1O62XETfsz7wcK/hbFuyjiCw5ncDlZPhiYJCO5GhyicXHq/fKdQbizRoUMoBWBQdHR4OSonokWDJ0OgjZM1xqN1l3jf
            QAwc8971kosKx/4T08BbEFwas6aIP6rfXymAFiH0jzEg+nESOzmh4xg9gffDxKfjqY1VC8Dg0e/ULMCTBqST2JnXnwYBFV8aF2nc
            vOE/PAuwPgCdwnMRYAeArdt2hu4nQPAmOT86Rs0JAjo1DU0DQZinWsLvzAk9EQKP+NpzCwRwiv9ha/fmokQDejdqzfuP25xzEEg3
            P6TfVQgEfyYXnZvuSZ6/CeLvQjEt9Qg8vQIoiPgPGXgA/bZv2l3CX79QvbrtH7K9usfj/fRGyaWLTrPfbOoY+KaI//O7/ds99ttP
            tx3vt8BoRmrAIwJQzy7KiRTB+0vn9RSSzfB6+nkLiThlUhC4VImC51Nxf4xIgEYU8DaKcGUEttIAMOL3+30a8NwtlANq+X2sNwGg
            F78xYf+H8XIuHXDhv4G9liA2iFblhxflOBcBigDAEQUs72+/v6cS8evkADRmureR8L8J4keKQHGurx1fjdDviQIUgiMNbCDf3FDz
            +qUDaOb7DGtF8uZIAT/kfc1RBEZWXZGLAFY9IEUBDgLqtcUYnD7sL/D3zadnigKc90sRYCOeH00BXu9nnXp1io/OWoCmg134HG5K
            tP4+Lh0EtH6YMQJw+Z+LAhwAUuj35n4TglUQuyj1AP2g1uVtr5fSE1o68RcmAtwlBexCf2RjgNiNjiAavQBQ+gPsLACMdOCpdMGY
            RtKquAdgId5fbxYBuD7/LojtKQARfO1gdVq4MnP84kwHheS6SkCwCj8OACn/zzYV1GDflWjQi98C0z8IhH3UikCpFkCmmOO+rAUG
            pR8QGvbvDIC0VC4tB0evCfAsC5tFICjRQMvr1REBFjIglfQOqpL/ZwTAc6EMtxysXQPQgqFfbQRJHq+lAqsmaErYx05gJI2fyqw7
            3KkTqEWDs6JjJPTTIhCNAaapQAKhXxdoRs8fifBVKPzushagAWAds64H5Kp+17WeqyG29Mj1BDQQsPN4ZKaPVVk7gMlTAIB81a8U
            GdApPBp5H41UYDaCrJSgQSBFBGQ+rwG/Yng3ADyXgEevAEZnyBcbQaAUgqBEgOKEAJgOYR8RitBFnDn8gwOA6OXelvjo8XiuFawt
            BBVHLaBBgIKoxXhtVs8fiQRRsb3ig6MRxBaBWiqwIPACpAkuef6sRSA4RPSu6KEClVX9s/ursw1sQWAVhdJncuLDzQGAAc/2iB4R
            //9BRfz410HcBZrgEIV7tI55/mbm8O+JBBYUXtGj4qMEwNUQRODQhC83Et+q1L1TudPiSwBcAcEoGJ7vnxWACARnhHaLrwHghSAq
            fuTYHcK/JURU1HCR56kBtLX2KASRcB4N92Vy0aNp4Yzg3n8mjgcA8CUIRvbv5PkjKeHKfRPEHoBRCL4leLm5+FcDERafA+AqCCKC
            P0F8LwQ4+NqQ+BIA0Tw8Kvyd8v2VdcFZECLfIwJwJQRPDvtXpYOviG8BYAlypchPER4GBTwjvPqaBcAVEJwJ9eXGQo967WXiAwD8
            B321G0T6uxsfAAAAAElFTkSuQmCC
        ]]
        local function DecodeBase64(Data)
            local Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            local Output = {}
            Data = Data:gsub('%s', '')
            for Index = 1, #Data, 4 do
                local A = Alphabet:find(Data:sub(Index, Index), 1, true)
                local B = Alphabet:find(Data:sub(Index+1, Index+1), 1, true)
                if not A or not B then break end
                local CharC = Data:sub(Index+2, Index+2)
                local CharD = Data:sub(Index+3, Index+3)
                local C = CharC == '=' and 1 or Alphabet:find(CharC, 1, true)
                local D = CharD == '=' and 1 or Alphabet:find(CharD, 1, true)
                if not C or not D then break end
                local Bits = (A-1)*262144 + (B-1)*4096 + (C-1)*64 + (D-1)
                Output[#Output+1] = string.char(math.floor(Bits/65536)%256)
                if CharC ~= '=' then Output[#Output+1] = string.char(math.floor(Bits/256)%256) end
                if CharD ~= '=' then Output[#Output+1] = string.char(Bits%256) end
            end
            return table.concat(Output)
        end
        local function ResolveSoftGlow()
            if CachedGlowAsset then return CachedGlowAsset end
            local Fallback = 'rbxassetid://88645182616510'
            if type(writefile) == 'function' and type(getcustomasset) == 'function' then
                local Path = Library.Directory .. Library.Folders.Assets .. '/SoftGlow_v27.png'
                local Ok, Asset = pcall(function()
                    -- Load local copy if present, otherwise materialize the PNG
                    -- embedded in the code. Never download anything for Glow.
                    if not (type(isfile) == 'function' and isfile(Path)) then
                        if type(isfolder) == 'function' and type(makefolder) == 'function' then
                            local Folder = Library.Directory .. Library.Folders.Assets
                            if not isfolder(Library.Directory) then makefolder(Library.Directory) end
                            if not isfolder(Folder) then makefolder(Folder) end
                        end
                        writefile(Path, DecodeBase64(SoftGlowBase64))
                    end
                    return getcustomasset(Path)
                end)
                if Ok and type(Asset) == 'string' and Asset ~= '' then
                    CachedGlowAsset = Asset
                    return Asset
                end
                warn('[mimisense] SoftGlow local asset unavailable; using fallback')
            end
            CachedGlowAsset = Fallback
            return Fallback
        end
        local function GlowTargets(Window)
            local Targets = {}
            local function Add(Item)
                local Root = Item and Item.Instance
                if Root and Root:IsA('GuiObject') and Root.Parent then
                    Targets[#Targets+1] = Root
                end
            end
            Add(Window.Items and Window.Items.MainFrame)
            local Watermark = rawget(Window, 'Watermark')
            Add(type(Watermark)=='table' and Watermark.Items and Watermark.Items.Watermark)
            local KeybindList = rawget(Window, 'KeybindList')
            Add(type(KeybindList)=='table' and KeybindList.Items and KeybindList.Items.KeybindList)
            local ESPPreview = rawget(Window, 'ESPPreview')
            Add(type(ESPPreview)=='table' and ESPPreview.Items and ESPPreview.Items.ESPPreview)
            return Targets
        end
        Library.SetMenuGlow = function(Self, _Ignored, Enabled)
            Library.MenuGlowEnabled = Enabled ~= false
            local Window = Library.ActiveWindow
            if not Window or not Window.Items or not Library.Holder then return end
            for _, Root in ipairs(GlowTargets(Window)) do
                local Entry = Library.OuterGlowMap[Root]
                if not Entry or not Entry.Image or not Entry.Image.Parent then
                    -- Always create a sibling of the target, not a child.
                    -- This avoids UIListLayout/AutomaticSize feedback and keeps
                    -- it in the same coordinate system during dragging.
                    local Image = Instance.new('ImageLabel')
                    Image.Name = 'MimisenseSoftGlow_v27'
                    Image.BackgroundTransparency = 1
                    Image.BorderSizePixel = 0
                    Image.Active = false
                    Image.Selectable = false
                    Image.ZIndex = 0
                    Image.Image = ResolveSoftGlow()
                    Image.ImageColor3 = Library.Theme['Accent']
                    Image.ImageTransparency = 1 - Library.MenuGlowStrength / 100
                    Image.ScaleType = Enum.ScaleType.Slice
                    Image.SliceCenter = Rect.new(32,32,96,96)
                    Image.SliceScale = 1
                    Image.Parent = Root.Parent
                    Entry = {Image=Image}
                    Library.OuterGlowMap[Root] = Entry
                    local function Sync()
                        if not Root.Parent or not Image.Parent then return end
                        if Image.Parent ~= Root.Parent then Image.Parent = Root.Parent end
                        local Pad = Library.MenuGlowPadding
                        local Anchor = Root.AnchorPoint
                        -- Position is always parent-local. No global coordinates,
                        -- no RenderStepped and no Tween lag on dragging.
                        Image.AnchorPoint = Anchor
                        Image.Position = Root.Position + UDim2.fromOffset(
                            (2*Anchor.X-1)*Pad, (2*Anchor.Y-1)*Pad)
                        local S = Root.AbsoluteSize
                        Image.Size = UDim2.fromOffset(math.max(1,S.X+2*Pad), math.max(1,S.Y+2*Pad))
                        Image.Visible = Library.MenuGlowEnabled and Root.Visible
                    end
                    Entry.Sync = Sync
                    Library:Connect(Root:GetPropertyChangedSignal('Position'), Sync)
                    Library:Connect(Root:GetPropertyChangedSignal('AnchorPoint'), Sync)
                    Library:Connect(Root:GetPropertyChangedSignal('AbsoluteSize'), Sync)
                    Library:Connect(Root:GetPropertyChangedSignal('Visible'), Sync)
                    Library:Connect(Root:GetPropertyChangedSignal('Parent'), function()
                        if Root.Parent then Sync() else Image:Destroy() end
                    end)
                    Library:Connect(Root.Destroying, function()
                        Library.OuterGlowMap[Root] = nil
                        if Image.Parent then Image:Destroy() end
                    end)
                end
                local Image = Entry.Image
                Image.ImageColor3 = Library.Theme['Accent']
                Image.ImageTransparency = 1 - Library.MenuGlowStrength/100
                Entry.Sync()
            end
        end

        -- ---------- menu search ----------
        Library.SearchMenu = function(Self, Query)
            Query = tostring(Query or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
            Library.SearchQuery = Query

            local Window = Library.ActiveWindow

            if not Window then
                return
            end

            local FirstPage

            for _, Page in Window.Pages do
                local PageMatches = 0

                for _, Section in Page.Sections or { } do
                    local Matches = 0
                    local SectionHit = Query ~= "" and string.find(tostring(Section.Name):lower(), Query, 1, true) ~= nil

                    for _, Element in Section.Elements or { } do
                        local Hit = Query == ""
                            or SectionHit
                            or (Element.Searchable ~= false and string.find(tostring(Element.Name):lower(), Query, 1, true) ~= nil)

                        Element:SetSearchHidden(not Hit)

                        if Hit and Element.Kind ~= "Colorpicker" then
                            Matches += 1
                        end
                    end

                    for _, Divider in Section.Dividers or { } do
                        if Divider.Parent then
                            Divider.Visible = Query == ""
                        end
                    end

                    Section.Items["Section"].Instance.Visible = Query == "" or Matches > 0 or SectionHit

                    if Query ~= "" and Matches > 0 and Section.Collapsed and Section.SetCollapsed then
                        Section:SetCollapsed(false)
                    end

                    PageMatches += Matches
                end

                Page.SearchMatches = PageMatches

                if PageMatches > 0 and not FirstPage then
                    FirstPage = Page
                end

                if Page.Items and Page.Items["Icon"] then
                    Page.Items["Icon"].Instance.ImageTransparency = (Query ~= "" and PageMatches == 0) and 0.7 or 0
                end
            end

            if Query ~= "" and FirstPage and Window.Current and (Window.Current.SearchMatches or 0) == 0 then
                FirstPage:Turn()
            end
        end

        -- search bar under the header: Window:SetSearchVisible(bool)
        do
            local OriginalWindow = Library.Window

            Library.Window = function(Self, Params)
                local Window = OriginalWindow(Self, Params)

                if type(Window) ~= "table" or not Window.Items or not Window.Items.MainFrame then
                    return Window
                end

                local Items = Window.Items
                local MainFrame = Items.MainFrame.Instance

                Items["SearchBar"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = MainFrame,
                    Position = UDim2.new(0, 10, 0, 62),
                    Size = UDim2.new(1, -20, 0, 28),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = "Tab"})

                Library:Create("UICorner", { Name = "\0", Parent = Items["SearchBar"].Instance, CornerRadius = UDim.new(0, 6) })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBar"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["SearchIcon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["SearchBar"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 9, 0.5, 0),
                    Size = UDim2.new(0, 15, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ImageColor3 = Library.Theme["Inactive Text"]
                }):AddToTheme({ImageColor3 = "Inactive Text"})

                if not Library:ApplyIcon(Items["SearchIcon"].Instance, "search") then
                    Items["SearchIcon"].Instance:Destroy()
                end

                Items["SearchInput"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["SearchBar"].Instance,
                    Position = UDim2.new(0, 32, 0, 0),
                    Size = UDim2.new(1, -62, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    TextColor3 = Library.Theme["Text"],
                    PlaceholderText = "Search options...",
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    Text = "",
                    ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Inactive Text"})

                Items["SearchClear"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 2,
                    Parent = Items["SearchBar"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 22, 0, 22),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Text = "x",
                    Visible = false,
                    TextColor3 = Library.Theme["Inactive Text"]
                }):AddToTheme({TextColor3 = "Inactive Text"})

                Library:Connect(Items["SearchInput"].Instance:GetPropertyChangedSignal("Text"), function()
                    local Text = Items["SearchInput"].Instance.Text
                    Items["SearchClear"].Instance.Visible = Text ~= ""
                    Library:SearchMenu(Text)
                end)

                Items["SearchClear"].Instance.MouseButton1Click:Connect(function()
                    Items["SearchInput"].Instance.Text = ""
                end)

                function Window:SetSearchVisible(Bool)
                    Bool = Bool and true or false
                    Items["SearchBar"].Instance.Visible = Bool

                    local Top = Bool and 94 or 56
                    Items["Content"].Instance.Position = UDim2.new(0, 0, 0, Top)
                    Items["Content"].Instance.Size = UDim2.new(1, 0, 1, -Top)

                    if not Bool then
                        Items["SearchInput"].Instance.Text = ""
                    end
                end

                function Window:FocusSearch()
                    Items["SearchInput"].Instance:CaptureFocus()
                end

                Window:SetSearchVisible(true)

                -- Ctrl+F focuses the search bar
                Library:Connect(UserInputService.InputBegan, function(Input, Processed)
                    if Input.KeyCode == Enum.KeyCode.F
                        and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl))
                        and Window.IsOpen and Items["SearchBar"].Instance.Visible then
                        task.defer(function()
                            Items["SearchInput"].Instance:CaptureFocus()
                        end)
                    end
                end)

                -- remember position / tab whenever the menu closes
                local OriginalSetOpen = Window.SetOpen

                Window.SetOpen = function(WindowSelf, Bool)
                    OriginalSetOpen(WindowSelf, Bool)

                    if Library.SaveUIState then
                        task.defer(function() Library:SaveUIState() end)
                    end
                end

                return Window
            end
        end


        -- Defaults shared by every window. Override before Window:Init() if desired.
        Library.DefaultMascotEnabled = true
        Library.DefaultMascotOptions = {
            Mascots = {
                mimi = {
                    Url = "https://raw.githubusercontent.com/xolylol/dogy-visuals-ui/refs/heads/main/mimi.jpg",
                    Size = 120,
                    Offset = Vector2.new(-222, -333),
                    Rotation = 0,
                    ZIndex = 3,
                    ClickSound = "102774986031312",
                    ClickSoundVolume = 0.8
                }
            },
            DefaultMascot = "mimi",
            PressScale = Vector2.new(1.05, 0.88)
        }

        -- Window:Init() builds the "UI Settings" page: profiles, autoload, theming,
        -- mascot (picker / position / rotation / size / sounds / reset) and menu options.
        -- Call it LAST, after every page, so autoload can restore all flags.
        -- Used by public examples to avoid duplicating the built-in mascot.
        Library.MascotInitFixed = true

        Library.Init = function(Self)
            local Window = (Self ~= Library and Self) or Library.ActiveWindow

            if not Window then
                warn("[Library] Init: create a window first, then call Window:Init()")
                return
            end

            if Window.SettingsPage then
                return Window.SettingsPage
            end

            -- Built-in mascot belongs to the library, not the consumer example.
            -- Consumers may still override it by calling Window:Mascot(...) before :Init().
            -- A window inherits Library.Mascot as a METHOD through __index.
            -- Using `if not Window.Mascot` tests that inherited function, not
            -- whether a mascot object actually exists, and breaks Init later
            -- when it calls `MascotObject:GetState()` on that function.
            if type(rawget(Window, "Mascot")) ~= "table" and Library.DefaultMascotEnabled ~= false then
                Window:Mascot(Library.DefaultMascotOptions)
            end

            if type(rawget(Window, "Watermark")) ~= "table" then
                Window:Watermark({Name = Window.Name, Logo = Window.Logo})
            end

            local SettingsPage = Window:Page({Name = "UI Settings", Icon = "settings"})
            Window.SettingsPage = SettingsPage

            local Notify = function(Type, Name, Description)
                Library:Notification({Name = Name, Description = Description or "", Type = Type, Duration = 3})
            end

            local SetFlag = function(Flag, Value)
                local Setter = Library.SetFlags[Flag]
                if Setter then
                    Setter(Value)
                end
            end

            -- true while the default theme is applied on start, so no "Theme applied" popup shows up
            local SilentTheme = false

            local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"
            local AutoloadFile = Library.Directory .. "/autoload.json"
            local AutoloadNameFile = Library.Directory .. "/autoload.txt"

            local ConfigPath = function(Name)
                return ConfigsFolder .. Name .. ".json"
            end

            local CleanName = function(Name)
                Name = tostring(Name or ""):gsub('[\\/:*?"<>|]', ""):gsub("^%s+", ""):gsub("%s+$", "")
                return Name
            end

            local ConfigSelected
            local ConfigName

            do -- Profiles + Autoload
                local ConfigsSection = SettingsPage:Section({Name = "Profiles", Icon = "folder", Side = 1})

                local ConfigsList = ConfigsSection:ListBox({
                    Flag = "Configs",
                    Items = { },
                    Multi = false,
                    Height = 180,
                    Callback = function(Value)
                        ConfigSelected = type(Value) == "string" and Value or nil
                    end
                })

                local AutoloadSection = SettingsPage:Section({Name = "Autoload", Icon = "play-circle", Side = 1})
                local AutoloadLabel = AutoloadSection:Label({Name = "Autoload: none"})

                local ReadAutoloadName = function()
                    local Ok, Name = pcall(readfile, AutoloadNameFile)
                    Name = Ok and CleanName(Name) or ""
                    return Name ~= "" and Name or nil
                end

                local RefreshAutoloadLabel = function()
                    AutoloadLabel:SetText("Autoload: " .. (ReadAutoloadName() or "none"))
                end

                -- returns the selected config name, or nil after telling the user why
                local Selected = function()
                    if not ConfigSelected or ConfigSelected == "" then
                        Notify("Error", "No config selected", "Pick one from the list first.")
                        return nil
                    end

                    if not isfile(ConfigPath(ConfigSelected)) then
                        Notify("Error", "Config not found", '"' .. ConfigSelected .. '" is gone.')
                        Library:GetConfigsList(ConfigsList)
                        return nil
                    end

                    return ConfigSelected
                end

                ConfigsSection:Textbox({
                    Name = "Config name",
                    Flag = "ConfigName",
                    Placeholder = "Config name",
                    Callback = function(Value)
                        ConfigName = CleanName(Value)
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        local Name = CleanName(ConfigName or Library.Flags["ConfigName"])

                        if Name == "" then
                            Notify("Error", "Name is empty", "Type a config name first.")
                            return
                        end

                        if isfile(ConfigPath(Name)) then
                            Notify("Error", "Already exists", '"' .. Name .. '" is taken, use Overwrite.')
                            return
                        end

                        local Data = Library:GetConfig()
                        if not Data then
                            Notify("Error", "Couldn't save", "Current settings could not be read.")
                            return
                        end

                        writefile(ConfigPath(Name), Data)
                        Library:GetConfigsList(ConfigsList)
                        ConfigsList:Set(Name)
                        Notify("Success", "Config created", Name)
                    end
                })

                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        local Name = Selected()
                        if not Name then return end

                        local Ok, Content = pcall(readfile, ConfigPath(Name))
                        if not Ok then
                            Notify("Error", "Couldn't read file", tostring(Content))
                            return
                        end

                        local Success, Err = Library:LoadConfig(Content)
                        if Success then
                            Notify("Success", "Config loaded", Name)
                        else
                            Notify("Warning", "Loaded with errors", tostring(Err))
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Overwrite",
                    Callback = function()
                        local Name = Selected()
                        if not Name then return end

                        local Data = Library:GetConfig()
                        if not Data then
                            Notify("Error", "Couldn't save", "Current settings could not be read.")
                            return
                        end

                        writefile(ConfigPath(Name), Data)
                        Notify("Success", "Config saved", Name)
                    end
                })

                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        local Name = Selected()
                        if not Name then return end

                        delfile(ConfigPath(Name))

                        if ReadAutoloadName() == Name then
                            writefile(AutoloadFile, "")
                            writefile(AutoloadNameFile, "")
                            RefreshAutoloadLabel()
                        end

                        ConfigSelected = nil
                        Library:GetConfigsList(ConfigsList)
                        Notify("Success", "Config deleted", Name)
                    end
                })

                AutoloadSection:Button({
                    Name = "Set selected as autoload",
                    Callback = function()
                        local Name = Selected()
                        if not Name then return end

                        local Ok, Content = pcall(readfile, ConfigPath(Name))
                        if not Ok then
                            Notify("Error", "Couldn't read file", tostring(Content))
                            return
                        end

                        writefile(AutoloadFile, Content)
                        writefile(AutoloadNameFile, Name)
                        RefreshAutoloadLabel()
                        Notify("Success", "Autoload set", Name)
                    end
                })

                AutoloadSection:Button({
                    Name = "Clear autoload",
                    Callback = function()
                        writefile(AutoloadFile, "")
                        writefile(AutoloadNameFile, "")
                        RefreshAutoloadLabel()
                        Notify("Success", "Autoload cleared")
                    end
                })

                Library:GetConfigsList(ConfigsList)
                RefreshAutoloadLabel()
            end

            do -- Theming
                local ThemingSection = SettingsPage:Section({Name = "Theming", Icon = "palette", Side = 2})
                local ThemeReady = false

                ThemingSection:Dropdown({
                    Name = "Theme",
                    Flag = "SelectedTheme",
                    Items = Library.ThemeOrder,
                    Default = Library.Themes[Window.StartupTheme] and Window.StartupTheme or "Default",
                    Callback = function(Value)
                        -- Dropdown constructors can fire their callback immediately.
                        -- Do not overwrite the developer's chosen theme while building UI Settings.
                        if not ThemeReady then return end
                        if Library:ApplyTheme(Value) and not SilentTheme then
                            Notify("Success", "Theme applied", Value)
                        end
                    end
                })

                ThemeReady = true
                ThemingSection:Divider()

                -- fixed order, a plain pairs() over the theme table reshuffles the rows every run
                local Order = { "Background", "Inline", "Tab", "Text", "Inactive Text", "Accent", "Outline", "Hovered Element" }
                local Seen = { }
                local Keys = { }

                for _, Index in Order do
                    if Library.Theme[Index] ~= nil then
                        table.insert(Keys, Index)
                        Seen[Index] = true
                    end
                end

                for Index in Library.Theme do
                    if not Seen[Index] then
                        table.insert(Keys, Index)
                    end
                end

                for _, Index in Keys do
                    ThemingSection:Label({Name = Index}):Colorpicker({
                        Name = Index,
                        Flag = Index .. "Theming",
                        Default = Library.Theme[Index],
                        Callback = function(Color)
                            Library.Theme[Index] = Color
                            Library:ChangeTheme(Index, Color)
                        end
                    })
                end
            end

            do -- Theme profiles (custom themes + default theme)
                local ProfilesSection = SettingsPage:Section({Name = "Theme Profiles", Icon = "palette", Side = 2})

                local ThemeSelected
                local ThemeName

                local DefaultLabel = ProfilesSection:Label({Name = "Default theme: Default"})

                local RefreshDefaultLabel = function()
                    DefaultLabel:SetText("Default theme: " .. (Library:GetDefaultTheme() or Library.StartupTheme or "Default"))
                end

                local ThemeList = ProfilesSection:ListBox({
                    Flag = "ThemeProfiles",
                    Items = { },
                    Multi = false,
                    Height = 120,
                    Callback = function(Value)
                        ThemeSelected = type(Value) == "string" and Value or nil
                    end
                })

                local RefreshThemes = function()
                    ThemeList:Refresh(Library:GetThemesList())
                end

                -- returns the selected theme name, or nil after telling the user why
                local SelectedTheme = function()
                    if not ThemeSelected or ThemeSelected == "" then
                        Notify("Error", "No theme selected", "Pick one from the list first.")
                        return nil
                    end

                    if not isfile(Library.Directory .. Library.Folders.Themes .. "/" .. ThemeSelected .. ".json") then
                        Notify("Error", "Theme not found", '"' .. ThemeSelected .. '" is gone.')
                        RefreshThemes()
                        return nil
                    end

                    return ThemeSelected
                end

                ProfilesSection:Textbox({
                    Name = "Theme name",
                    Flag = "ThemeName",
                    Placeholder = "Theme name",
                    Callback = function(Value)
                        ThemeName = CleanName(Value)
                    end
                })

                ProfilesSection:Button({
                    Name = "Create theme",
                    Callback = function()
                        local Name = CleanName(ThemeName or Library.Flags["ThemeName"])

                        if Name == "" then
                            Notify("Error", "Name is empty", "Type a theme name first.")
                            return
                        end

                        if Library.Themes[Name] then
                            Notify("Error", "Name is reserved", '"' .. Name .. '" is a built-in theme.')
                            return
                        end

                        if isfile(Library.Directory .. Library.Folders.Themes .. "/" .. Name .. ".json") then
                            Notify("Error", "Already exists", '"' .. Name .. '" is taken, use Overwrite.')
                            return
                        end

                        if not Library:SaveTheme(Name) then
                            Notify("Error", "Couldn't save", "The theme file could not be written.")
                            return
                        end

                        RefreshThemes()
                        ThemeList:Set(Name)
                        Notify("Success", "Theme created", Name)
                    end
                })

                ProfilesSection:Button({
                    Name = "Load theme",
                    Callback = function()
                        local Name = SelectedTheme()
                        if not Name then return end

                        local ThemeData, Err = Library:ReadTheme(Name)

                        if not ThemeData then
                            Notify("Error", "Couldn't load theme", tostring(Err))
                            return
                        end

                        Library:ApplyThemeData(ThemeData)
                        Notify("Success", "Theme loaded", Name)
                    end
                })

                ProfilesSection:Button({
                    Name = "Overwrite theme",
                    Callback = function()
                        local Name = SelectedTheme()
                        if not Name then return end

                        if Library:SaveTheme(Name) then
                            Notify("Success", "Theme saved", Name)
                        else
                            Notify("Error", "Couldn't save", "The theme file could not be written.")
                        end
                    end
                })

                ProfilesSection:Button({
                    Name = "Delete theme",
                    Callback = function()
                        local Name = SelectedTheme()
                        if not Name then return end

                        Library:DeleteTheme(Name)

                        if Library:GetDefaultTheme() == Name then
                            Library:SetDefaultTheme(nil)
                            RefreshDefaultLabel()
                        end

                        ThemeSelected = nil
                        RefreshThemes()
                        Notify("Success", "Theme deleted", Name)
                    end
                })

                ProfilesSection:Divider()

                ProfilesSection:Button({
                    Name = "Set selected as default",
                    Callback = function()
                        local Name = SelectedTheme()
                        if not Name then return end

                        Library:SetDefaultTheme(Name)
                        RefreshDefaultLabel()
                        Notify("Success", "Default theme set", Name)
                    end
                })

                ProfilesSection:Button({
                    Name = "Set preset as default",
                    Callback = function()
                        local Name = Library.Flags["SelectedTheme"]

                        if not Library.Themes[Name] then
                            Notify("Error", "No preset selected", "Pick a preset in the Theme dropdown first.")
                            return
                        end

                        Library:SetDefaultTheme(Name)
                        RefreshDefaultLabel()
                        Notify("Success", "Default theme set", Name)
                    end
                })

                ProfilesSection:Button({
                    Name = "Clear default theme",
                    Callback = function()
                        Library:SetDefaultTheme(nil)
                        RefreshDefaultLabel()
                        Notify("Success", "Default theme cleared")
                    end
                })

                RefreshThemes()
                RefreshDefaultLabel()
            end

            -- UI Settings: a single Menu section; options open from small gear icons.
            do
                local State = Library:LoadUIState()
                local Menu = SettingsPage:Section({Name = "Menu", Icon = "settings", Side = 2, ResetButton = false})
                -- The Menu section is shown first in the UI Settings right column.
                Menu.Items.Section.Instance.LayoutOrder = -100
                local function Save(Field, Value)
                    State[Field] = Value
                    Library:QueueSaveUIState()
                end
                local function Panel(Row, Name)
                    return Row:Options({Name = Name, Width = 265, Icon = "settings"})
                end
                local function Visibility(Name, Object, Flag)
                    if type(Object) ~= "table" or not Object.SetVisibility then return nil end
                    return Menu:Toggle({Name = Name, Flag = Flag, Default = true,
                        Callback = function(Value) Object:SetVisibility(Value) end})
                end

                Menu:Label({Name = "Menu Keybind"}):Keybind({
                    Name = "Menu Keybind", Flag = "MenuKeybind", Default = Enum.KeyCode.X,
                    Mode = "Toggle", Callback = function()
                        local Bind = Library.Flags["MenuKeybind"]
                        if type(Bind) == "table" and Bind.Key and Bind.Key ~= "None" then
                            Library.MenuKeybind = tostring(Bind.Key):match("^Enum%.") and tostring(Bind.Key) or "Enum.KeyCode." .. tostring(Bind.Key)
                        end
                    end
                })

                local Watermark = rawget(Window, "Watermark")
                local WatermarkRow = Visibility("Watermark", Watermark, "UI/Menu/Watermark")
                if WatermarkRow and type(Watermark.SetFields) == "function" then
                    local Options = Panel(WatermarkRow, "Watermark Options")
                    Options:Dropdown({Name = "Modules", Flag = "UI/WatermarkFields", Multi = true,
                        Items = Library.WatermarkFieldOrder or {"FPS", "Ping", "Place", "Session", "Time", "Date", "Player", "Players", "Memory"},
                        Default = State.WatermarkFields or {"FPS", "Ping"},
                        Callback = function(Value)
                            if type(Value) == "table" then Watermark:SetFields(Value) Save("WatermarkFields", Value) end
                        end})
                end

                local KeybindList = rawget(Window, "KeybindList")
                local KeybindRow = Visibility("Keybind List", KeybindList, "UI/Menu/KeybindList")
                if KeybindRow and type(KeybindList.SetFilter) == "function" then
                    Panel(KeybindRow, "Keybind List Options"):Dropdown({
                        Name = "Display Mode", Flag = "UI/KeybindListMode",
                        Items = {"Only assigned", "Only active", "Show all"},
                        Default = State.KeybindListMode or "Only assigned",
                        Callback = function(Value) KeybindList:SetFilter(Value) Save("KeybindListMode", Value) end})
                end
                Visibility("ESP Preview", rawget(Window, "ESPPreview"), "UI/Menu/ESPPreview")

                local Mascot = rawget(Window, "Mascot")
                local MascotRow = Visibility("Mascot", Mascot, "UI/Menu/Mascot")
                if MascotRow and Mascot.GetState then
                    local Options = Panel(MascotRow, "Mascot Options")
                    local Original = Mascot:GetState()
                    local Syncing = false
                    local function SyncCoords()
                        Syncing = true
                        local Current = Mascot:GetState()
                        for Key, Value in { ["Mascot/X"] = Current.X, ["Mascot/Y"] = Current.Y,
                            ["Mascot/Rotation"] = Current.Rotation, ["Mascot/Size"] = Current.Size } do
                            local Set = Library.SetFlags[Key]
                            if Set then Set(Value) end
                        end
                        Syncing = false
                    end
                    local function ApplyMascotSound()
                        local Data = Mascot.Mascots and Mascot.Mascots[Mascot.CurrentMascot]
                        local SoundId = (type(Data) == "table" and Data.ClickSound) or "102774986031312"
                        if Library.Flags["Mascot/ClickSound"] == "None" then
                            Mascot:SetClickSound(nil)
                        else
                            Mascot:SetClickSound(SoundId)
                        end
                        local Volume = tonumber(Library.Flags["Mascot/ClickVolume"]) or 80
                        Mascot:SetClickSoundVolume(Volume / 100)
                        Library:SetMascotClickVolume(Volume / 100)
                    end
                    local Names = Mascot:GetNames()
                    if #Names == 0 then Names = {"None"} end
                    Options:Dropdown({Name = "Mascot", Flag = "Mascot/Selected", Items = Names,
                        Default = Original.Name or Names[1], Callback = function(Value)
                            if Value == Mascot.CurrentMascot then return end
                            Mascot:SetMascot(Value)
                            SyncCoords()
                            ApplyMascotSound()
                        end})
                    Options:Slider({Name = "Position X", Flag = "Mascot/X", Min = -600, Max = 600,
                        Default = Original.X, Callback = function(Value)
                            if Syncing then return end
                            local _, Y = Mascot:GetCenteredPosition()
                            Mascot:SetCenteredPosition(Value, Y)
                        end})
                    Options:Slider({Name = "Position Y", Flag = "Mascot/Y", Min = -600, Max = 600,
                        Default = Original.Y, Callback = function(Value)
                            if Syncing then return end
                            local X = Mascot:GetCenteredPosition()
                            Mascot:SetCenteredPosition(X, Value)
                        end})
                    Options:Slider({Name = "Rotation", Flag = "Mascot/Rotation", Min = -180, Max = 180,
                        Default = Original.Rotation, Suffix = "°", Callback = function(Value)
                            if not Syncing then Mascot:SetRotation(Value) end
                        end})
                    Options:Slider({Name = "Size", Flag = "Mascot/Size", Min = 20, Max = 400,
                        Default = Original.Size, Callback = function(Value)
                            if not Syncing then Mascot:SetSize(Value) end
                        end})
                    Options:Dropdown({Name = "Click Sound", Flag = "Mascot/ClickSound",
                        Items = {"Default", "None"}, Default = "Default", Callback = ApplyMascotSound})
                    Options:Slider({Name = "Click Volume", Flag = "Mascot/ClickVolume", Min = 0, Max = 100,
                        Default = math.floor((Original.ClickSoundVolume or 0.8) * 100 + 0.5), Suffix = "%",
                        Callback = ApplyMascotSound})
                    Options:Button({Name = "Reset Mascot", Callback = function()
                        Mascot:ResetToDefault()
                        SyncCoords()
                        ApplyMascotSound()
                    end})
                end

                local Interface = Panel(Menu:Label({Name = "Interface"}), "Interface Options")
                Interface:Toggle({Name = "Search Bar", Flag = "UI/SearchBar", Default = State.SearchBar ~= false,
                    Callback = function(Value) Window:SetSearchVisible(Value) Save("SearchBar", Value) end})
                Interface:Slider({Name = "UI Scale", Flag = "UI/Scale", Min = 50, Max = 150,
                    Default = math.floor((State.Scale or 1) * 100 + 0.5), Step = 5, Suffix = "%",
                    Callback = function(Value) Library:SetUIScale(Value / 100) Save("Scale", Value / 100) end})
                Interface:Dropdown({Name = "UI Scale Preset", Flag = "UI/ScalePreset",
                    Items = {"Small", "Normal", "Large", "Custom"}, Default = "Custom",
                    Callback = function(Value)
                        local Presets = { Small = 0.8, Normal = 1, Large = 1.2 }
                        if not Presets[Value] then return end
                        local Set = Library.SetFlags["UI/Scale"]
                        if Set then Set(math.floor(Presets[Value] * 100)) end
                        Library:SetUIScale(Presets[Value])
                        Save("Scale", Presets[Value])
                    end})
                Interface:Slider({Name = "Opacity", Flag = "UI/Opacity", Min = 30, Max = 100,
                    Default = math.floor((1 - (State.Transparency or 0)) * 100 + 0.5), Suffix = "%",
                    Callback = function(Value) Library:SetWindowOpacity(1 - Value / 100) Save("Transparency", 1 - Value / 100) end})
                Interface:Dropdown({Name = "Font", Flag = "UI/Font", Items = Library.FontChoices,
                    Default = Window.StartupFont or State.Font or "Figtree", Callback = function(Value) Library:SetUIFont(Value) Save("Font", Value) end})
                Interface:Toggle({Name = "Theme Animation", Flag = "UI/ThemeAnimation",
                    Default = State.ThemeAnimation ~= false, Callback = function(Value)
                        Library.ThemeAnimation = Value
                        Save("ThemeAnimation", Value)
                    end})
                Interface:Toggle({Name = "Remember Position & Tab", Flag = "UI/RememberUI",
                    Default = State.RememberUI ~= false, Callback = function(Value) Save("RememberUI", Value) end})

                local NotificationRow = Menu:Toggle({Name = "Notifications", Flag = "UI/NotificationsEnabled",
                    Default = Library.NotificationEnabled ~= false,
                    Callback = function(Value) Library.NotificationEnabled = Value end})
                local Notification = Panel(NotificationRow, "Notification Options")
                Library.NotificationDuration = math.clamp(tonumber(State.NotificationDuration) or 3, 1, 15)
                Notification:Button({Name = "Test Notification", Callback = function()
                    Library:Notification({Description = "Notification preview"})
                end})
                Notification:Slider({Name = "Duration", Flag = "UI/NotificationDuration",
                    Min = 1, Max = 15, Default = Library.NotificationDuration, Step = 1,
                    Suffix = "s", Callback = function(Value)
                        Library.NotificationDuration = math.clamp(tonumber(Value) or 3, 1, 15)
                        Save("NotificationDuration", Library.NotificationDuration)
                    end})
                Notification:Dropdown({Name = "Notification Side", Flag = "UI/NotifSide",
                    Items = {"Right", "Left"}, Default = State.NotifSide or "Right",
                    Callback = function(Value) Library:SetNotificationSide(Value) Save("NotifSide", Value) end})
                Notification:Dropdown({Name = "Message Sound", Flag = "UI/NotificationSoundMode",
                    Items = {"None", "Simple click", "Custom"}, Default = "None",
                    Callback = function(Value) Library.NotificationSoundMode = Value end})
                Notification:Textbox({Name = "Custom Sound ID", Flag = "UI/NotificationSoundId",
                    Placeholder = "rbxassetid://...", Default = "", Finished = true,
                    Callback = function(Value) Library.NotificationCustomSoundId = tostring(Value or "") end})
                Notification:Slider({Name = "Sound Volume", Flag = "UI/NotificationVolume",
                    Min = 0, Max = 100, Default = 55, Suffix = "%",
                    Callback = function(Value) Library.NotificationVolume = Value / 100 end})

                local GlowToggle = Menu:Toggle({Name = "Glow", Flag = "UI/GlowEnabled",
                    Default = Library.MenuGlowEnabled ~= false,
                    Callback = function(Value) Library:SetMenuGlow(nil, Value) end})
                local GlowOptions = Panel(GlowToggle, "Glow Options")
                GlowOptions:Slider({Name = "Strength", Flag = "UI/GlowStrength",
                    Min = 0, Max = 100, Default = Library.MenuGlowStrength, Suffix = "%",
                    Callback = function(Value)
                        Library.MenuGlowStrength = math.clamp(tonumber(Value) or 65, 0, 100)
                        Library:SetMenuGlow(nil, Library.MenuGlowEnabled ~= false)
                    end})
                GlowOptions:Slider({Name = "Spread", Flag = "UI/GlowSpread",
                    Min = 12, Max = 40, Default = Library.MenuGlowPadding,
                    Callback = function(Value)
                        Library.MenuGlowPadding = math.clamp(tonumber(Value) or 30, 12, 40)
                        Library:SetMenuGlow(nil, Library.MenuGlowEnabled ~= false)
                    end})
                Library:SetMenuGlow(nil, Library.MenuGlowEnabled ~= false)

                Menu:Dropdown({Name = "UI Click Sound", Flag = "UIClickSound", Items = {"Simple click", "None"},
                    Default = "Simple click", Callback = function(Value)
                        if Value == "None" then
                            Library:SetUIClickSound(nil)
                        else
                            Library:SetUIClickSound("88442833509532")
                        end
                    end})
                Menu:Slider({Name = "UI Click Volume", Flag = "UIClickVolume", Min = 0, Max = 100,
                    Default = math.floor((Library.UIClickVolume or 0.65) * 100 + 0.5), Suffix = "%",
                    Callback = function(Value) Library:SetUIClickVolume(Value / 100) end})
                Menu:Divider()
                Menu:SubButton({Name = "Reset All Settings", ConfirmText = "Are you sure?", ConfirmTime = 2,
                    Callback = function()
                        local Count = 0
                        for _, Element in Library.AllResettableElements or {} do
                            if Element.Default ~= nil and type(Element.Set) == "function" then
                                local Ok = pcall(function() Element:Set(Element.Default) end)
                                if Ok then Count += 1 end
                            end
                        end
                        for _, Bind in Library.KeybindRegistry or {} do
                            local Ok = pcall(function()
                                if Bind.DefaultKey then
                                    Bind:Set({Key = Bind.DefaultKey, Mode = Bind.DefaultMode})
                                else
                                    Bind:Clear()
                                end
                            end)
                            if Ok then Count += 1 end
                        end
                        Library:Notification({Description = tostring(Count) .. " options reset to default", Duration = 3})
                    end})
                Menu:SubButton({Name = "Unload", ConfirmText = "are you sure?", ConfirmTime = 1.5,
                    Callback = function() task.defer(function() Library:Exit() end) end})
            end

            do -- Interface / Overlays / Share (search, scale, opacity, font, notifications, watermark, keybind list, strings)
                local State = Library:LoadUIState()
                Library.RestoringUI = true

                local Save = function()
                    Library:QueueSaveUIState()
                end

                -- Interface, overlays, Mascot, Glow and notifications are all in Menu Options above.
                -- Share/config export remains its own functional section (no hidden duplicates).

                local ShareSection = SettingsPage:Section({Name = "Share", Icon = "clipboard", Side = 1})

                local ImportBox = ShareSection:Textbox({
                    Name = "Import string",
                    Flag = "UI/ImportString",
                    Placeholder = "paste a config or theme string",
                    Tooltip = "If your executor cannot read the clipboard, paste the string here (Ctrl+V) and press Import.",
                    Callback = function() end
                })

                local ReadImport = function()
                    local Text = tostring(Library.Flags["UI/ImportString"] or "")

                    if Text:gsub("%s+", "") == "" then
                        Text = Library:PasteText() or ""
                    end

                    return Text
                end

                local CopyString = function(Text, Title)
                    if not Text then
                        Notify("Error", Title, "Nothing to export.")
                        return
                    end

                    local _, Wrote = Library:CopyText(Text)

                    if Wrote then
                        Notify("Success", Title, "Copied to the clipboard.")
                    else
                        if ImportBox and ImportBox.Set then
                            ImportBox:Set(Text)
                        end

                        Notify("Warning", Title, "Clipboard is unavailable, the string is in the field above.")
                    end
                end

                ShareSection:Button({
                    Name = "Copy config string",
                    Callback = function()
                        CopyString(Library:ExportConfig(), "Config exported")
                    end
                })

                ShareSection:Button({
                    Name = "Import config string",
                    Callback = function()
                        local Ok, Err = Library:ImportConfig(ReadImport())

                        if Ok then
                            Notify("Success", "Config imported")
                        else
                            Notify("Error", "Import failed", tostring(Err))
                        end
                    end
                })

                ShareSection:Divider()

                ShareSection:Button({
                    Name = "Copy theme string",
                    Callback = function()
                        CopyString(Library:ExportTheme(), "Theme exported")
                    end
                })

                ShareSection:Button({
                    Name = "Import theme string",
                    Callback = function()
                        local Ok, Err = Library:ImportTheme(ReadImport())

                        if Ok then
                            Notify("Success", "Theme imported")
                        else
                            Notify("Error", "Import failed", tostring(Err))
                        end
                    end
                })

                -- restore window position and last tab once the first page has finished fading in
                local Restore = {
                    X = State.X, Y = State.Y, Page = State.Page, Enabled = State.RememberUI ~= false
                }

                task.spawn(function()
                    task.wait(0.9)

                    if Restore.Enabled then
                        local Frame = Window.Items and Window.Items.MainFrame and Window.Items.MainFrame.Instance

                        if Frame and tonumber(Restore.X) and tonumber(Restore.Y) then
                            local Camera = workspace.CurrentCamera
                            local Viewport = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
                            local X = math.clamp(Restore.X, 0, math.max(0, Viewport.X - 120))
                            local Y = math.clamp(Restore.Y, 0, math.max(0, Viewport.Y - 120))

                            Frame.AnchorPoint = Vector2.new(0, 0)
                            Frame.Position = UDim2.new(0, X, 0, Y)
                        end

                        if Restore.Page then
                            for _, Page in Window.Pages do
                                if Page.Name == Restore.Page and Window.Current ~= Page then
                                    for _ = 1, 10 do
                                        Page:Turn()

                                        if Window.Current == Page then
                                            break
                                        end

                                        task.wait(0.2)
                                    end

                                    break
                                end
                            end
                        end
                    end

                    Library.RestoringUI = false
                end)
            end

            do -- Autoload
                local Ok, Content = pcall(readfile, AutoloadFile)

                if Ok and type(Content) == "string" and Content ~= "" then
                    local Success, Err = Library:LoadConfig(Content)
                    local Ok2, Name = pcall(readfile, AutoloadNameFile)
                    Name = Ok2 and CleanName(Name) or ""

                    if Success then
                        Notify("Success", "Autoload", Name ~= "" and ('Loaded "' .. Name .. '".') or "Loaded autoload config.")
                    else
                        Notify("Warning", "Autoload had errors", tostring(Err))
                    end
                end
            end

            do -- Apply the selected startup palette last, after optional autoload config.
                -- An explicit Window.Theme takes precedence over a saved default theme.
                -- With no override and no saved preference, Default is always the initial theme.
                local Name = Window.HasStartupThemeOverride and Window.StartupTheme
                    or Library:GetDefaultTheme()
                    or Window.StartupTheme
                    or "Default"
                SilentTheme = true

                if Window.StartupThemeData then
                    Library:ApplyTheme("Default")
                    Library:ApplyThemeData(Window.StartupThemeData)
                elseif Library:ApplyNamedTheme(Name) then
                    if Library.Themes[Name] then
                        SetFlag("SelectedTheme", Name)
                    end
                else
                    warn("[mimisense] Cannot restore startup theme " .. tostring(Name))
                    Library:ApplyTheme("Default")
                    SetFlag("SelectedTheme", "Default")
                end

                SilentTheme = false
            end

            return SettingsPage
        end
    end
end

getgenv().Library = Library
return Library
