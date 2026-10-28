-- DOGY VISUALS UI PATCH v6: mascot reference position, accent icons, keybind registry, clipboard notifications, visibility animations
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
    BuildVersion = "2026.10.28-v3-init-notifications", 
    Flags = { },

    MenuKeybind = tostring(Enum.KeyCode.X),

    Directory = "dogy visuals",

    -- Ссылка на твой Icons.lua (raw) в репозитории
    IconsUrl = "https://raw.githubusercontent.com/xolylol/dogy-visuals-ui/refs/heads/main/Icons.lua",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs"
    },

    FontSize = 14,

    Animation = {
        Time = 0.35,
        Style = "Quart",
        Direction = "Out"
    },

    ZIndexOrder = {
        ["OptionHolder"] = 5,
        ["KeybindWindow"] = 5,
        ["ColorpickerWindow"] = 6
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

    SafeLibraryMakeFolder(Library.Directory)

    for _, Folder in Library.Folders do
        SafeLibraryMakeFolder(Library.Directory .. Folder)
    end

    if not isfile(Library.Directory .. "/autoload.json") then
        SafeLibraryWriteFile(Library.Directory .. "/autoload.json", "")
    end

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

        for _, Folder in Library.Folders do
            SafeLibraryMakeFolder(Library.Directory .. Folder)
        end

        if not isfile(Library.Directory .. "/autoload.json") then
            SafeLibraryWriteFile(Library.Directory .. "/autoload.json", "")
        end

        return true
    end

    local Themes = {
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

    local ThemeOrder = { "Preset", "Sky", "Magma", "Sand", "Navy", "Emerald", "Rose", "Midnight", "Coral", "Mono" }

    Library.Themes = Themes

    -- flags that must be applied first when a config is loaded (JSON key order is random)
    Library.LoadFirst = { "SelectedTheme", "Mascot/Selected", "Mascot/Name" }
    -- UI-only flags that should never be written into a config
    Library.ConfigIgnore = { ["Configs"] = true, ["ConfigName"] = true }
    Library.ThemeOrder = ThemeOrder
    Library.Theme = table.clone(Themes["Preset"])

    Library.ApplyTheme = function(Self, Name)
        local ThemeData = Themes[Name]

        if not ThemeData then
            return false
        end

        for Index, Color in ThemeData do
            Library:ChangeTheme(Index, Color)

            local SetFunction = SetFlags[Index .. "Theming"]
            if SetFunction then
                SetFunction(Color, 0)
            end
        end

        return true
    end

    Library.AnimatedColorpickers = { }
    Library.RainbowTime = 0

    Library.LerpColor = function(Self, A, B, T)
        return A:Lerp(B, math.clamp(T, 0, 1))
    end

    Library.EnsureColorpickerAnimations = function(Self)
        if Library.ColorpickerAnimationConnection then
            return
        end

        Library.ColorpickerAnimationConnection = Library:Connect(RunService.RenderStepped, function(DeltaTime)
            local RainbowSpeedSum = 0
            local RainbowCount = 0

            for Colorpicker in Library.AnimatedColorpickers do
                if Colorpicker.AnimationEnabled and Colorpicker.AnimationMode == "Rainbow" then
                    local Speed = Colorpicker.AnimationSpeed
                    RainbowSpeedSum += Speed * Speed
                    RainbowCount += 1
                end
            end

            if RainbowCount > 0 then
                Library.RainbowTime += DeltaTime * (RainbowSpeedSum / RainbowCount)
            end

            for Colorpicker in Library.AnimatedColorpickers do
                if not Colorpicker.AnimationEnabled then
                    continue
                end

                local Mode = Colorpicker.AnimationMode
                if not Mode then
                    continue
                end

                local Speed = Colorpicker.AnimationSpeed
                Speed = Speed * Speed

                local Color
                local Alpha = Colorpicker.Alpha

                if Mode == "Rainbow" then
                    Color = Color3.fromHSV((Library.RainbowTime * 0.2) % 1, Colorpicker.Saturation, Colorpicker.Value)
                else
                    Colorpicker.AnimationTime += DeltaTime * Speed

                    local Time = Colorpicker.AnimationTime
                    local Primary = Colorpicker.KeyframeOne
                    local Secondary = Colorpicker.KeyframeTwo
                    if not Primary or not Secondary then
                        continue
                    end

                    local T = 0

                    if Mode == "Linear" then
                        T = Time % 1
                    elseif Mode == "Strobe" then
                        T = math.floor(Time * 4) % 2
                    elseif Mode == "Ping Pong" then
                        T = math.abs((Time % 2) - 1)
                    elseif Mode == "Pulse" then
                        T = math.abs(math.sin(Time * 2))
                    elseif Mode == "Oscillation" then
                        T = (math.sin(Time) + 1) * 0.5
                    end

                    Color = Library:LerpColor(Primary.Color, Secondary.Color, T)
                    Alpha = Primary.Alpha + (Secondary.Alpha - Primary.Alpha) * T
                end

                Colorpicker:Set(Color, Alpha, true)
            end
        end)
    end

    Library.SetColorpickerAnimating = function(Self, Colorpicker, Enabled)
        if Enabled then
            Library.AnimatedColorpickers[Colorpicker] = true
            Library:EnsureColorpickerAnimations()
        else
            Library.AnimatedColorpickers[Colorpicker] = nil
        end
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
        if Library.UIClickSound then
            Library.UIClickSound.SoundId = Library.UIClickSoundId or ""
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
        if not Sound or not Sound.Parent or not Library.UIClickSoundId then return end
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

        for _, Name in {"UIClickSound", "MascotClickSound"} do
            if Self[Name] then
                pcall(function() Self[Name]:Destroy() end)
            end
        end

        Library.ColorpickerAnimationConnection = nil
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

    Library.MakeDraggable = function(Self, Handle)
        if not Self.Instance then 
            return
        end
    
        local Gui = Self.Instance
        local HandleInstance = (Handle and Handle.Instance) or Gui
        local Dragging = false 
        local DragStart
        local StartPosition 
    
        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize
    
            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            Self:Tween({Position = UDim2.new(0, NewX, 0, NewY)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end
    
        local InputChanged
    
        Library:Connect(HandleInstance.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
    
                if InputChanged then 
                    return
                end
    
                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Library.ConvertAnchor = function(Self)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local AbsPos = Gui.AbsolutePosition

        Gui.AnchorPoint = Vector2.new(0, 0)
        task.wait()
        Gui.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
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
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
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
        
            Self:Tween({Position = UDim2.fromOffset(x, y)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Self:Tween({Size = UDim2.fromOffset(w, h)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
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

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then 
            return 
        end 

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
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

    Library.RegisterOpenFrame = function(Self, Frame, Data)
        local Owner = Data.Owner

        if Owner == nil and Data.AnchorInstance then
            Owner = Self:FindOpenFrameOwner(Data.AnchorInstance)
        end

        Data.Owner = Owner

        if Owner then
            Self:CloseOpenFramesExcept(Frame, Owner)
        else
            Self:CloseOpenFramesExcept(Frame)
        end

        Library.OpenFrames[Frame] = Data
        Library:EnsureOpenFramesConnection()
    end

    Library.UnregisterOpenFrame = function(Self, Frame)
        Library.OpenFrames[Frame] = nil
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

    Library.GetScreenScale = function(Self)
        local Scale = 1
    
        for _, Obj in Library.Holder.Instance:GetDescendants() do
            if Obj:IsA("UIScale") then
                Scale *= Obj.Scale
            end
        end
    
        return Scale
    end
    
    Library.PopupPosition = function(Self, Anchor, Popup, ExtraY)
        local Scale = Library:GetScreenScale()
        ExtraY = ExtraY or 0
    
        local X = Anchor.AbsolutePosition.X / Scale
        local Y = (Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset + ExtraY) / Scale
    
        return UDim2.fromOffset(X, Y)
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

    Library:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    Library:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14)
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

                AnimationEnabled = false,
                AnimationMode = "Linear",
                AnimationSpeed = 1,
                AnimationTime = 0,

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
                    Size = UDim2.new(0, 250, 0, 265),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Size = UDim2.new(1, 0, 0, 40),
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
                    Position = UDim2.new(0, 0, 0, 56),
                    Size = UDim2.new(1, 0, 1, -56),
                    BorderSizePixel = 0
                })

                if Colorpicker.ClipboardEnabled then
                    Items["Clipboard"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Top"].Instance,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 8, 0.5, 0),
                        Size = UDim2.new(0, 150, 0, 30),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0
                    })

                    Library:Create("UIListLayout", {
                        Name = "\0",
                        Parent = Items["Clipboard"].Instance,
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        Padding = UDim.new(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    for _, ButtonData in ipairs({
                        {Name = "Copy", Icon = "copy"},
                        {Name = "Paste", Icon = "clipboard"},
                    }) do
                        local Button = Library:Create("ImageButton", {
                            Name = "\0",
                            Parent = Items["Clipboard"].Instance,
                            Size = UDim2.new(0, 27, 0, 27),
                            BackgroundColor3 = Library.Theme["Tab"],
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            AutoButtonColor = false,
                            ImageColor3 = Library.Theme["Inactive Text"],
                            Image = "",
                            Active = true,
                            LayoutOrder = ButtonData.Name == "Copy" and 1 or 2
                        }):AddToTheme({BackgroundColor3 = "Tab", ImageColor3 = "Inactive Text"})

                        Library:Create("UICorner", {
                            Name = "\0",
                            Parent = Button.Instance,
                            CornerRadius = UDim.new(0, 5)
                        })

                        Library:Create("UIStroke", {
                            Name = "\0",
                            Parent = Button.Instance,
                            Color = Library.Theme["Outline"],
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        }):AddToTheme({Color = "Outline"})

                        local Icon = Library:Create("ImageLabel", {
                            Name = "\0",
                            Parent = Button.Instance,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(0, 15, 0, 15),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            ImageColor3 = Library.Theme["Inactive Text"]
                        }):AddToTheme({ImageColor3 = "Inactive Text"})

                        Library:ApplyIcon(Icon.Instance, ButtonData.Icon)
                        Items[ButtonData.Name] = Button
                    end

                    Items["HexInput"] = Library:Create("TextBox", {
                        Name = "\0",
                        Parent = Items["Top"].Instance,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -8, 0.5, 0),
                        Size = UDim2.new(0, 82, 0, 26),
                        BackgroundColor3 = Library.Theme["Tab"],
                        BorderSizePixel = 0,
                        TextColor3 = Library.Theme["Text"],
                        PlaceholderColor3 = Library.Theme["Inactive Text"],
                        PlaceholderText = "#RRGGBB",
                        Text = "#FFFFFF",
                        ClearTextOnFocus = false,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        FontFace = Library.Font,
                        TextSize = Library.FontSize
                    }):AddToTheme({BackgroundColor3 = "Tab", TextColor3 = "Text", PlaceholderColor3 = "Inactive Text"})

                    Library:Create("UICorner", {Name = "\0", Parent = Items["HexInput"].Instance, CornerRadius = UDim.new(0, 4)})
                    Library:Create("UIStroke", {Name = "\0", Parent = Items["HexInput"].Instance, Color = Library.Theme["Outline"], ApplyStrokeMode = Enum.ApplyStrokeMode.Border}):AddToTheme({Color = "Outline"})
                end

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
                if Items["HexInput"] and not Items["HexInput"].Instance:IsFocused() then
                    Items["HexInput"].Instance.Text = "#" .. Colorpicker.HexValue
                end

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

            local GlobalEnv = (getgenv and getgenv()) or _G
            local SetClipboard = rawget(GlobalEnv, "setclipboard") or rawget(GlobalEnv, "toclipboard") or (syn and syn.write_clipboard)
            local GetClipboard = rawget(GlobalEnv, "getclipboard") or rawget(GlobalEnv, "fromclipboard") or (syn and syn.read_clipboard)

            local function ParseClipboardColor(Text)
                if type(Text) ~= "string" then
                    return nil
                end

                Text = Text:gsub("%s+", "")

                local Hex = Text:match("^#?([%x][%x][%x][%x][%x][%x])$")
                if Hex then
                    local R = tonumber(Hex:sub(1, 2), 16)
                    local G = tonumber(Hex:sub(3, 4), 16)
                    local B = tonumber(Hex:sub(5, 6), 16)
                    return Color3.fromRGB(R, G, B)
                end

                local R, G, B = Text:match("^[Rr][Gg][Bb][Aa]?%s*%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
                if R and G and B then
                    return Color3.fromRGB(math.clamp(tonumber(R), 0, 255), math.clamp(tonumber(G), 0, 255), math.clamp(tonumber(B), 0, 255))
                end

                R, G, B = Text:match("^(%d+),(%d+),(%d+)$")
                if R and G and B then
                    return Color3.fromRGB(math.clamp(tonumber(R), 0, 255), math.clamp(tonumber(G), 0, 255), math.clamp(tonumber(B), 0, 255))
                end

                return nil
            end

            function Colorpicker:Copy()
                local Hex = tostring(Colorpicker.HexValue or Colorpicker.Color:ToHex() or "FFFFFF"):gsub("#", ""):upper()
                local Text = "#" .. Hex
                if not SetClipboard then
                    Library:Notification({Name = "Color Copy", Description = "Clipboard API is unavailable.", Duration = 2, Color = Library.Theme["Accent"]})
                    return false
                end
                local Ok, Result = pcall(SetClipboard, Text)
                if Ok and Result ~= false then
                    Library:Notification({Name = "Color copied", Description = Text .. " copied.", Duration = 2, Color = Library.Theme["Accent"]})
                    return true
                end
                Library:Notification({Name = "Color Copy", Description = "Clipboard write failed.", Duration = 2, Color = Color3.fromRGB(255, 80, 80)})
                return false
            end

            function Colorpicker:Paste()
                if not GetClipboard then
                    return false
                end

                local Success, Text = pcall(GetClipboard)
                if not Success then
                    return false
                end

                local Color = ParseClipboardColor(tostring(Text or ""))
                if not Color then
                    Library:Notification({Name = "Color Paste", Description = "Clipboard has no valid color.", Duration = 2, Color = Color3.fromRGB(255, 80, 80)})
                    return false
                end

                Colorpicker:Set(Color, Colorpicker.Alpha)
                Library:Notification({Name = "Color pasted", Description = "Color loaded from clipboard.", Duration = 2, Color = Library.Theme["Accent"]})
                return true
            end

            if Items["Copy"] then
                Items["Copy"]:OnHover(function()
                    Items["Copy"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"], ImageColor3 = Library.Theme.Text})
                end, function()
                    Items["Copy"]:Tween({BackgroundColor3 = Library.Theme.Tab, ImageColor3 = Library.Theme["Inactive Text"]})
                end)

                Items["Copy"]:Connect("MouseButton1Down", function()
                    Colorpicker:Copy()
                end)
                Items["Copy"]:Connect("MouseButton1Click", function()
                    Colorpicker:Copy()
                end)
                Items["Copy"]:Connect("Activated", function()
                    Colorpicker:Copy()
                end)
            end

            if Items["Paste"] then
                Items["Paste"]:OnHover(function()
                    Items["Paste"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"], ImageColor3 = Library.Theme.Text})
                end, function()
                    Items["Paste"]:Tween({BackgroundColor3 = Library.Theme.Tab, ImageColor3 = Library.Theme["Inactive Text"]})
                end)

                Items["Paste"]:Connect("MouseButton1Down", function()
                    Colorpicker:Paste()
                end)
                Items["Paste"]:Connect("MouseButton1Click", function()
                    Colorpicker:Paste()
                end)
                Items["Paste"]:Connect("Activated", function()
                    Colorpicker:Paste()
                end)
            end

            if Items["HexInput"] then
                Items["HexInput"]:Connect("FocusLost", function()
                    local Text = tostring(Items["HexInput"].Instance.Text or "")
                    local Color = ParseClipboardColor(Text)
                    if Color then
                        Colorpicker:Set(Color, Colorpicker.Alpha)
                    else
                        Items["HexInput"].Instance.Text = "#" .. Colorpicker.HexValue
                    end
                end)
            end

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 
                
                if Colorpicker.IsOpen then 
                    ColorpickerWindow.Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + GuiInset)

                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 10 + GuiInset)})
                    
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
            end

            Items["ColorpickerWindow"]:VisibleCheck()
    
            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end
    
                local ValueX = math.clamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY
    
                local SlideX = math.clamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.935)
                local SlideY = math.clamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.92)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(SlideX, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged
    
            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Hue = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.915)
    
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
    
            local SlidingAlpha = false 
            local AlphaChanged
    
            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end
    
                local ValueX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
    
                Colorpicker.Alpha = ValueX
    
                local SlideX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.915)
    
                Items["AlphaDragger"]:Tween({Position = UDim2.new(SlideX, 0, 0, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update(true)
            end
    
            function Colorpicker:Set(Color, Alpha, FromAnimation)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    local Parsed = ParseClipboardColor(Color)
                    if not Parsed then
                        return false
                    end
                    Color = Parsed
                else
                    Color = Color -- lul
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  

                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.935)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.92)
    
                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 0.915)
                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 0.915)

                local DraggerInfo = FromAnimation and TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.Out) or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                if FromAnimation then
                    Colorpicker.Color = Color
                    Colorpicker.HexValue = Colorpicker.Color:ToHex()
                    Items["ColorpickerButton"].Instance.BackgroundColor3 = Colorpicker.Color

                    if Items["Palette"] then
                        Items["Palette"].Instance.BackgroundColor3 = Color3.fromHSV(Colorpicker.Hue, 1, 1)
                    end

                    if Items["Alpha"] then
                        Items["Alpha"].Instance.BackgroundColor3 = Colorpicker.Color
                    end

                    if Items["PaletteDragger"] then
                        Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, DraggerInfo)
                    end

                    if Items["HueDragger"] then
                        Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, HuePositionY, 0)}, DraggerInfo)
                    end

                    if Items["AlphaDragger"] then
                        Items["AlphaDragger"]:Tween({Position = UDim2.new(AlphaPositionX, 0, 0, 0)}, DraggerInfo)
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

                    return
                end
    
                if Items["PaletteDragger"] then
                    Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, DraggerInfo)
                end

                if Items["HueDragger"] then
                    Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, HuePositionY, 0)}, DraggerInfo)
                end

                if Items["AlphaDragger"] then
                    Items["AlphaDragger"]:Tween({Position = UDim2.new(AlphaPositionX, 0, 0, 0)}, DraggerInfo)
                end

                Colorpicker:Update()
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
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                do -- Color controls
                    Items["Palette"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Color"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        Position = UDim2.new(0, 10, 0, 10),
                        Size = UDim2.new(1, -45, 1, -45),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Palette"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
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
                        Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Saturation"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
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
                        Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Value"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Items["PaletteDragger"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Palette"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["PaletteDragger"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = Items["PaletteDragger"].Instance,
                        Color = Library.Theme["Text"]
                    }):AddToTheme({Color = 'Text'})
                    
                    Items["Hue"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Color"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.new(1, -10, 0, 10),
                        Size = UDim2.new(0, 15, 1, -20),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Hue"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
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
                    
                    Items["HueDragger"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Hue"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 15, 0, 15),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["HueDragger"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = Items["HueDragger"].Instance,
                        Color = Library.Theme["Text"]
                    }):AddToTheme({Color = 'Text'})
                    
                    Items["Alpha"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Color"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, 10, 1, -10),
                        Size = UDim2.new(1, -45, 0, 15),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Alpha"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
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
                        Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.37, 0.5),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Checkers"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Items["AlphaDragger"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Alpha"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 15, 0, 15),
                        BorderSizePixel = 0,
                        ZIndex = 3,
                        Active = true
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["AlphaDragger"].Instance,
                        TopLeftRadius = UDim.new(0, 6),
                        TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6),
                        BottomLeftRadius = UDim.new(0, 6)
                    })
                    
                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = Items["AlphaDragger"].Instance,
                        Color = Library.Theme["Text"]
                    }):AddToTheme({Color = 'Text'})
                end

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
            Keys["Delete"] = "Delete" -- Delete is a valid bind; only the menu's Remove action clears it.

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
                    CornerRadius = UDim.new(0, 3)
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
                    CornerRadius = UDim.new(0, 4)
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
                    -- Capture the pressed key itself. Delete/Backspace are valid keybinds;
                    -- clearing a bind is done explicitly with the menu's Remove option.
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode == Enum.KeyCode.Unknown then
                            return
                        end
                        Keybind:Set(Input.KeyCode)
                    elseif Input.UserInputType ~= Enum.UserInputType.None then
                        Keybind:Set(Input.UserInputType)
                    else
                        return
                    end

                    if InputBegan then
                        InputBegan:Disconnect()
                        InputBegan = nil
                    end
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

            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items
        end

Library.SetUIClickVolume = function(Self, Volume)
    Volume = tonumber(Volume)
    if not Volume then return end
    Self.UIClickVolume = math.clamp(Volume, 0, 1)
    if Self.UIClickSound then
        Self.UIClickSound.Volume = Self.UIClickVolume
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
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.new(0.5, 0, 1, -10),
                    Size = UDim2.new(0, 0, 0, 45),
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
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Watermark.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 30, 0, 30),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})
                
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
                
                Items["FPSText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["NewHolder"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = 'FPS: <font color="rgb(120, 120, 120)">--</font>',
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["NewHolder"].Instance,
                    Padding = UDim.new(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["NewHolder"].Instance,
                    PaddingTop = UDim.new(0, 6)
                })
                
                Items["PingText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["NewHolder"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = 'PING: <font color="rgb(120, 120, 120)">--</font>',
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

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

            local FrameCount = 0
            local LastUpdate = os.clock()

            Library:Connect(RunService.RenderStepped, function()
                FrameCount += 1

                local Now = os.clock()
                if Now - LastUpdate < 1 then
                    return
                end

                local FPS = FrameCount
                FrameCount = 0
                LastUpdate = Now

                local Color = GetInactiveRGB()
                Items["FPSText"].Instance.Text = string.format('FPS: <font color="%s">%d</font>', Color, FPS)
                Items["PingText"].Instance.Text = string.format('PING: <font color="%s">%dms</font>', Color, GetPing())
            end)

            function Watermark:Center()
                Items["Watermark"]:ConvertAnchor()
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

            function KeybindList:Refresh()
                local Count = 0
                for _, Row in KeybindList.Keys do
                    if Row.Bound then
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

                function NewKey:SetBound(Bool)
                    NewKey.Bound = Bool and true or false
                    NewKey.AnimationToken += 1
                    KeybindList:Refresh()
                    if not NewKey.Bound then
                        RowItems["NewKey"].Instance.Visible = false
                        RowItems["NewKey"].Instance.Size = UDim2.new(1, 0, 0, 0)
                        RowItems["Text"].Instance.TextTransparency = 1
                        RowItems["Key"].Instance.TextTransparency = 1
                        return
                    end
                    RowItems["NewKey"].Instance.Visible = true
                    RowItems["NewKey"].Instance.Size = UDim2.new(1, 0, 0, 0)
                    RowItems["Text"].Instance.TextTransparency = 1
                    RowItems["Key"].Instance.TextTransparency = 1
                    RowItems["Text"].Instance.Position = UDim2.new(0, -SlideOffset, 0, RowHeight / 2)
                    RowItems["Key"].Instance.Position = UDim2.new(1, SlideOffset, 0, RowHeight / 2)
                    local Color = NewKey.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                    RowItems["Text"]:Tween({TextColor3 = Color}, KeybindTweenInfo)
                    RowItems["Key"]:Tween({TextColor3 = Color}, KeybindTweenInfo)
                    RowItems["NewKey"]:Tween({Size = UDim2.new(1, 0, 0, RowSlot)}, KeybindTweenInfo)
                    RowItems["Text"]:Tween({TextTransparency = 0, Position = UDim2.new(0, 0, 0, RowHeight / 2)}, KeybindTweenInfo)
                    RowItems["Key"]:Tween({TextTransparency = 0, Position = UDim2.new(1, 0, 0, RowHeight / 2)}, KeybindTweenInfo)
                end

                function NewKey:SetStatus(Bool)
                    NewKey.Active = Bool and true or false
                    NewKey.AnimationToken += 1
                    if not NewKey.Bound then return end
                    local Token = NewKey.AnimationToken
                    local Color = NewKey.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                    RowItems["NewKey"].Instance.Visible = true
                    RowItems["Text"]:Tween({TextColor3 = Color}, KeybindTweenInfo)
                    RowItems["Key"]:Tween({TextColor3 = Color}, KeybindTweenInfo)
                    RowItems["NewKey"]:Tween({Size = UDim2.new(1, 0, 0, RowSlot)}, KeybindTweenInfo)
                    RowItems["Text"]:Tween({TextTransparency = 0, Position = UDim2.new(0, 0, 0, RowHeight / 2)}, KeybindTweenInfo)
                    RowItems["Key"]:Tween({TextTransparency = 0, Position = UDim2.new(1, 0, 0, RowHeight / 2)}, KeybindTweenInfo)
                    task.delay(KeybindTweenInfo.Time + 0.03, function()
                        if Token ~= NewKey.AnimationToken or not NewKey.Bound or not RowItems["NewKey"].Instance.Parent then return end
                        RowItems["Text"].Instance.TextColor3 = NewKey.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                        RowItems["Key"].Instance.TextColor3 = NewKey.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                    end)
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

            return setmetatable(KeybindList, Library)
        end

        Library.NotificationTypes = {
            Success = Color3.fromRGB(95, 205, 135),
            Warning = Color3.fromRGB(235, 185, 85),
            Error   = Color3.fromRGB(230, 95, 95),
        }

        Library.NotificationCounter = 0
        Library.NotificationLimit = 5

        -- Library:Notification({Name = "Saved", Description = "Config created.", Type = "Success", Duration = 3})
        --   Type: "Success" | "Warning" | "Error" | nil (theme accent). Color overrides Type.
        -- Hover pauses the timer, click dismisses, an identical message restarts instead of stacking.
        Library.Notification = function(Self, Params)
            Params = Params or { }

            local Name = tostring(Params.Name or Params.name or Params.Title or Params.title or "Notification")
            local Description = tostring(Params.Description or Params.description or "")
            local Duration = math.max(tonumber(Params.Duration or Params.duration) or 4, 0.5)
            local Type = Params.Type or Params.type
            local Color = Params.Color or Params.color or (Type and Library.NotificationTypes[Type]) or Library.Theme.Accent
            local Key = Name .. "\n" .. Description

            for _, Existing in Library.Notifications do
                if Existing.Key == Key and not Existing.Removing then
                    Existing:Restart()
                    return Existing
                end
            end

            local Width = 290
            local Notification = {
                Key = Key,
                Removing = false,
                Closing = false,
                Paused = false,
                Elapsed = 0,
                Duration = Duration,
                Items = { }
            }
            local Items = Notification.Items

            Library.NotificationCounter += 1

            Items["Holder"] = Library:Create("Frame", {
                Name = "\0",
                Parent = Library.NotifHolder.Instance,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(0, Width, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = Library.NotificationCounter
            })

            Items["Card"] = Library:Create("Frame", {
                Name = "\0",
                Parent = Items["Holder"].Instance,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Position = UDim2.new(0, 36, 0, 0),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BackgroundColor3 = Library.Theme["Inline"]
            })

            Library:Create("UICorner", {
                Name = "\0",
                Parent = Items["Card"].Instance,
                CornerRadius = UDim.new(0, 6)
            })

            Items["Stroke"] = Library:Create("UIStroke", {
                Name = "\0",
                Parent = Items["Card"].Instance,
                Color = Library.Theme["Outline"],
                Transparency = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })

            Items["Accent"] = Library:Create("Frame", {
                Name = "\0",
                Parent = Items["Card"].Instance,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 3, 1, 0),
                BackgroundTransparency = 1,
                BackgroundColor3 = Color
            })

            Items["Body"] = Library:Create("Frame", {
                Name = "\0",
                Parent = Items["Card"].Instance,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 3, 0, 0),
                Size = UDim2.new(1, -3, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })

            Library:Create("UIPadding", {
                Name = "\0",
                Parent = Items["Body"].Instance,
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 13),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12)
            })

            Library:Create("UIListLayout", {
                Name = "\0",
                Parent = Items["Body"].Instance,
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Title"] = Library:Create("TextLabel", {
                Name = "\0",
                FontFace = Library.Font,
                TextSize = Library.FontSize,
                Parent = Items["Body"].Instance,
                Text = Name,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 1,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 1
            })

            Items["Description"] = Library:Create("TextLabel", {
                Name = "\0",
                FontFace = Library.Font,
                TextSize = Library.FontSize - 1,
                Parent = Items["Body"].Instance,
                Text = Description,
                Visible = Description ~= "",
                TextColor3 = Library.Theme["Inactive Text"],
                TextTransparency = 1,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 2
            })

            Items["Progress"] = Library:Create("Frame", {
                Name = "\0",
                Parent = Items["Card"].Instance,
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                BackgroundColor3 = Color,
                ZIndex = 3
            })

            Items["Hit"] = Library:Create("TextButton", {
                Name = "\0",
                Parent = Items["Card"].Instance,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 4
            })

            -- { instance, property, visible value }
            local Fades = {
                { Items["Card"].Instance, "BackgroundTransparency", 0 },
                { Items["Stroke"].Instance, "Transparency", 0 },
                { Items["Accent"].Instance, "BackgroundTransparency", 0 },
                { Items["Title"].Instance, "TextTransparency", 0 },
                { Items["Description"].Instance, "TextTransparency", 0 },
                { Items["Progress"].Instance, "BackgroundTransparency", 0.55 },
            }

            local InInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            local OutInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

            local Alive = function()
                return Library ~= nil and Items["Holder"].Instance.Parent ~= nil
            end

            local Play = function(Info, Hidden)
                for _, Entry in Fades do
                    TweenService:Create(Entry[1], Info, {[Entry[2]] = Hidden and 1 or Entry[3]}):Play()
                end
            end

            local ProgressTween

            function Notification:Restart()
                Notification.Elapsed = 0

                if ProgressTween then
                    ProgressTween:Cancel()
                end

                local Bar = Items["Progress"].Instance
                Bar.Size = UDim2.new(1, 0, 0, 2)

                ProgressTween = TweenService:Create(Bar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(0, 0, 0, 2)
                })
                ProgressTween:Play()

                if Notification.Paused then
                    ProgressTween:Pause()
                end
            end

            function Notification:Dismiss()
                Notification.Closing = true
            end

            -- plain connections on purpose: they die with the instance, no need to track them
            Items["Hit"].Instance.MouseEnter:Connect(function()
                Notification.Paused = true
                if ProgressTween then ProgressTween:Pause() end
            end)

            Items["Hit"].Instance.MouseLeave:Connect(function()
                Notification.Paused = false
                if ProgressTween then ProgressTween:Play() end
            end)

            Items["Hit"].Instance.MouseButton1Click:Connect(function()
                Notification.Closing = true
            end)

            table.insert(Library.Notifications, Notification)

            -- keep the stack short: oldest ones leave first
            local Active = { }
            for _, Value in Library.Notifications do
                if not Value.Removing and not Value.Closing then
                    table.insert(Active, Value)
                end
            end
            for Index = 1, #Active - Library.NotificationLimit do
                Active[Index]:Dismiss()
            end

            task.spawn(function()
                if not Alive() then return end

                Play(InInfo, false)
                TweenService:Create(Items["Card"].Instance, InInfo, {Position = UDim2.new(0, 0, 0, 0)}):Play()
                Notification:Restart()

                local Last = os.clock()

                while Alive() and not Notification.Closing and Notification.Elapsed < Duration do
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
                if Index then
                    table.remove(Library.Notifications, Index)
                end

                Play(OutInfo, true)
                TweenService:Create(Items["Card"].Instance, OutInfo, {Position = UDim2.new(0, 36, 0, 0)}):Play()
                task.wait(OutInfo.Time)

                if not Alive() then return end

                local Holder = Items["Holder"].Instance
                Holder.AutomaticSize = Enum.AutomaticSize.None
                Holder.Size = UDim2.new(0, Width, 0, Holder.AbsoluteSize.Y)
                Holder.ClipsDescendants = true

                local Collapse = TweenService:Create(Holder, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, Width, 0, 0)
                })
                Collapse:Play()
                Collapse.Completed:Wait()

                if Holder.Parent then
                    Holder:Destroy()
                end
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

            return ESPPreview
        end

        Library.Window = function(Self, Params)
            Params = Params or { }

            local Window = {
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
                
                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2.new(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y))
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
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
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0.5, 0),
                    Size = UDim2.new(0, 30, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({ImageColor3 = 'Accent'})
                
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
                    Size = UDim2.new(1, 0, 1, -56),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Text"]
                }):AddToTheme({BackgroundColor3 = 'Text'})                

                Window.Items = Items
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
                    Position = UDim2.new(0.5, Mascot.Offset.X, 0.5, Mascot.Offset.Y),
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
                Items["Image"].Instance.Position = UDim2.new(0.5, X, 0.5, Y)
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

                -- Mascot coordinates are relative to the center of the GUI:
                -- 0,0 = center, negative X = left, positive X = right,
                -- negative Y = up, positive Y = down.
                Items["Image"].Instance.Position = UDim2.new(0.5, Mascot.Offset.X, 0.5, Mascot.Offset.Y)
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

            -- Keep mascot coordinates valid when the menu is resized.
            Library:Connect(Self.Items["MainFrame"].Instance:GetPropertyChangedSignal("AbsoluteSize"), function()
                Mascot:SetPosition(Mascot.Offset.X, Mascot.Offset.Y, Mascot.ZIndex)
            end)

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
                    PaddingBottom = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

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
                    PaddingBottom = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

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
end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
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

    local Success, Module = pcall(function()
        return loadstring(game:HttpGet(Library.IconsUrl))()
    end)

    if Success and type(Module) == "table" and type(Module.Get) == "function" then
        Library.IconModule = Module
    else
        Library.IconModule = false
        Library:IconError("Failed to load Icons.lua: " .. tostring(Module):sub(1, 150))
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

    local Cached = Library.IconCache[Icon]
    if Cached ~= nil then
        return Cached or nil
    end

    local Module = Library:LoadIcons()
    local Data = Module and Module.Get(Icon) or nil

    if not Data and Module then
        Library:IconError('Unknown icon "' .. Icon .. '"')
    end

    Library.IconCache[Icon] = Data or false
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

Library.Section = function(Self, Params)
    Params = Params or { } 

    local Section = {
        Name = Params.Name or Params.name or "Section",
        Side = Params.Side or Params.side or 1,
        Icon = Params.Icon or Params.icon or "folder",

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
        
        Library:Create("UIPadding", {
            Name = "\0",
            Parent = Items["Section"].Instance,
            PaddingBottom = UDim.new(0, 12)
        })
        
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

        Library:Create("UIPadding", {
            Name = "\0",
            Parent = Items["Section"].Instance,
            PaddingBottom = UDim.new(0, 12)
        })                

        Section.Items = Items
    end 

    return setmetatable(Section, Library)
end

        -- ============================================================
        -- OPTIONS (gear popup) - PART 1/3
        -- Paste right BEFORE `Library.Toggle = function(Self, Params)`
        --
        -- Toggle:Options({ Name = "Options", Width = 250, Icon = "settings" })
        -- Label:Options({ ... })
        -- Returns an object that works like a Section: every element
        -- (Toggle, Slider, Dropdown, Label, Button, SubButton, Textbox,
        -- Divider, ListBox, Colorpicker, Keybind) can be added to it.
        -- ============================================================
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

            local WindowZIndex = 3
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

                local Y = GearButton.AbsolutePosition.Y + GearButton.AbsoluteSize.Y + GuiInset + 6
                local Direction = 1

                if Height > 0 and Y + Height > Screen.Y - 8 then
                    Y = GearButton.AbsolutePosition.Y + GuiInset - Height - 6
                    Direction = -1
                end

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
                    PopupWindow.Position = GetTarget(-SlideOffset)
                    PopupWindow.Parent = Library.Holder.Instance

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

                local NewKeybind, KeybindItems = Library:CreateKeybind({
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

            -- OPTIONS - PART 2/3 (inside Library.Toggle)
            -- Paste right BEFORE:  Items["Toggle"]:Connect("MouseButton1Down", function()
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
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme.Background})
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
                    Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
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
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
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
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://73883327119089",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})          
                
                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    Position = UDim2.new(0.719742476940155, 0, 0.1462799459695816, 0),
                    Size = UDim2.new(0, 241, 0, 175),
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
            end, function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme.Background})
            end)

            function Dropdown:Set(Value)
                if Dropdown.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Value

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
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Search(Query)
                SearchOptions(Dropdown.Options, Query, Items["Holder"])

                if not Dropdown.IsOpen then
                    return
                end

                Query = string.lower(tostring(Query or ""))
                local Width = Items["RealDropdown"].Instance.AbsoluteSize.X
                local TargetHeight = Dropdown.MaxSize

                if Query ~= "" then
                    local VisibleCount = 0

                    for _, OptionData in Dropdown.Options do
                        if OptionData.SearchVisible then
                            VisibleCount += 1
                        end
                    end

                    local HeaderHeight = 40
                    TargetHeight = math.clamp(HeaderHeight + VisibleCount * OptionSlot, HeaderHeight, Dropdown.MaxSize)
                end

                Items["Holder"]:Tween({ScrollBarImageTransparency = Query ~= "" and 1 or 0}, OptionSearchInfo)
                Items["OptionHolder"]:Tween({Size = UDim2.new(0, Width, 0, TargetHeight)}, OptionSearchInfo)
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
                Items["Dropdown"].Instance.Visible = Bool 
            end

            local Debounce = false 
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            local IsSettings = Dropdown.Section and Dropdown.Section.IsSettings

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Dropdown.IsOpen = Bool

                Debounce = true 
                
                if Dropdown.IsOpen then 
                    OptionHolder.Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + GuiInset)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X, 0, Dropdown.MaxSize)
                    
                    OptionHolder.Parent = Library.Holder.Instance
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    Library:RegisterOpenFrame(Dropdown, {
                        HoverItems = { Items["OptionHolder"], Items["RealDropdown"] },
                        AnchorInstance = RealDropdown,
                        PopupInstance = OptionHolder,
                    })
                else
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["OptionHolder"]:FadeDescendants(false, function()
                        OptionHolder.Parent = Library.UnusedHolder.Instance
                        Items["Search"].Instance.Text = ""
                        Dropdown:Search("")
                        Debounce = false
                    end)

                    Library:CloseOpenFrameChildren(Dropdown)
                    Library:UnregisterOpenFrame(Dropdown)
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder + 3 or 1
                    end
                end
            end

            Items["OptionHolder"]:VisibleCheck()

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

                local NewKeybind, KeybindItems = Library:CreateKeybind({
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

            -- OPTIONS - PART 3/3 (inside Library.Label)
            -- Paste right BEFORE:  Label:SetText(Label.Name)   (the one right above `return setmetatable(Label, Library)`)
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

        -- Window:Init() builds the "UI Settings" page: profiles, autoload, theming,
        -- mascot (picker / position / rotation / size / sounds / reset) and menu options.
        -- Call it LAST, after every page, so autoload can restore all flags.
        Library.Init = function(Self)
            local Window = (Self ~= Library and Self) or Library.ActiveWindow

            if not Window then
                warn("[Library] Init: create a window first, then call Window:Init()")
                return
            end

            if Window.SettingsPage then
                return Window.SettingsPage
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
                    Default = "Preset",
                    Callback = function(Value)
                        if Library:ApplyTheme(Value) and ThemeReady then
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

            local MascotObject = Window.Mascot

            if MascotObject then -- Mascot
                local MascotSection = SettingsPage:Section({Name = "Mascot", Icon = "smile", Side = 2})

                -- true while the controls are being built / synced, so their callbacks don't fight the mascot
                local Syncing = true

                local State = MascotObject:GetState()
                local Names = MascotObject:GetNames()

                if #Names == 0 then
                    Names = { "None" }
                end

                local SoundId = function()
                    local Data = MascotObject.Mascots and MascotObject.Mascots[MascotObject.CurrentMascot]
                    return (type(Data) == "table" and Data.ClickSound) or "102774986031312"
                end

                -- the user's sound choice survives a mascot switch (SetMascot loads the preset's sound)
                local ApplyAudio = function()
                    MascotObject:SetClickSound(Library.Flags["Mascot/ClickSound"] ~= "None" and SoundId() or nil)

                    local Volume = Library.Flags["Mascot/ClickVolume"]
                    if type(Volume) == "number" then
                        MascotObject:SetClickSoundVolume(Volume / 100)
                        Library:SetMascotClickVolume(Volume / 100)
                    end
                end

                local Sync = function()
                    local Was = Syncing
                    Syncing = true

                    local Now = MascotObject:GetState()
                    SetFlag("Mascot/X", Now.X)
                    SetFlag("Mascot/Y", Now.Y)
                    SetFlag("Mascot/Rotation", Now.Rotation)
                    SetFlag("Mascot/Size", Now.Size)

                    Syncing = Was
                end

                MascotSection:Dropdown({
                    Name = "Mascot",
                    Flag = "Mascot/Selected",
                    Items = Names,
                    Default = State.Name or Names[1],
                    Callback = function(Value)
                        if Syncing or Value == MascotObject.CurrentMascot then return end

                        MascotObject:SetMascot(Value)
                        Sync()
                        ApplyAudio()
                    end
                })

                MascotSection:Slider({
                    Name = "Position X", Flag = "Mascot/X", Min = -600, Max = 600,
                    Default = State.X, Decimals = 0,
                    Callback = function(Value)
                        if Syncing then return end
                        local _, Y = MascotObject:GetCenteredPosition()
                        MascotObject:SetCenteredPosition(Value, Y)
                    end
                })

                MascotSection:Slider({
                    Name = "Position Y", Flag = "Mascot/Y", Min = -600, Max = 600,
                    Default = State.Y, Decimals = 0,
                    Callback = function(Value)
                        if Syncing then return end
                        local X = MascotObject:GetCenteredPosition()
                        MascotObject:SetCenteredPosition(X, Value)
                    end
                })

                MascotSection:Slider({
                    Name = "Rotation", Flag = "Mascot/Rotation", Min = -180, Max = 180,
                    Default = State.Rotation, Decimals = 0, Suffix = "°",
                    Callback = function(Value)
                        if Syncing then return end
                        MascotObject:SetRotation(Value)
                    end
                })

                MascotSection:Slider({
                    Name = "Size", Flag = "Mascot/Size", Min = 20, Max = 400,
                    Default = State.Size, Decimals = 0,
                    Callback = function(Value)
                        if Syncing then return end
                        MascotObject:SetSize(Value)
                    end
                })

                MascotSection:Dropdown({
                    Name = "Click Sound", Flag = "Mascot/ClickSound",
                    Items = { "Default", "None" }, Default = "Default",
                    Callback = function()
                        if Syncing then return end
                        ApplyAudio()
                    end
                })

                MascotSection:Slider({
                    Name = "Click Volume", Flag = "Mascot/ClickVolume", Min = 0, Max = 100,
                    Default = math.floor(State.ClickSoundVolume * 100 + 0.5), Decimals = 0, Suffix = "%",
                    Callback = function()
                        if Syncing then return end
                        ApplyAudio()
                    end
                })

                MascotSection:Button({
                    Name = "Reset to Default",
                    Callback = function()
                        if not MascotObject:ResetToDefault() then
                            Notify("Error", "Reset failed", "The default mascot is missing from the registry.")
                            return
                        end

                        local Now = MascotObject:GetState()

                        Syncing = true
                        SetFlag("Mascot/Selected", Now.Name)
                        SetFlag("Mascot/ClickSound", "Default")
                        SetFlag("Mascot/ClickVolume", math.floor(Now.ClickSoundVolume * 100 + 0.5))
                        Syncing = false

                        Sync()
                        ApplyAudio()
                        Notify("Success", "Mascot reset", "Position, size, rotation and sound restored.")
                    end
                })

                Syncing = false
            end

            do -- Menu
                local MenuSection = SettingsPage:Section({Name = "Menu", Icon = "settings", Side = 2})

                MenuSection:Label({Name = "Menu Keybind"}):Keybind({
                    Name = "Menu Keybind",
                    Flag = "MenuKeybind",
                    Default = Enum.KeyCode.X,
                    Mode = "Toggle",
                    Callback = function()
                        local Key = Library.Flags["MenuKeybind"] and Library.Flags["MenuKeybind"].Key

                        -- "None" (Backspace) is ignored so the menu can never be left without a key
                        if Key and Key ~= "None" then
                            Library.MenuKeybind = Key
                        end
                    end
                })

                local Toggles = {
                    { "Watermark", "Watermark" },
                    { "KeybindList", "Keybind List" },
                    { "ESPPreview", "ESP Preview" },
                    { "Mascot", "Mascot" },
                }

                for _, Entry in Toggles do
                    local Object = Window[Entry[1]]

                    -- Window.X is also a Library method name, so make sure it is the real object
                    if type(Object) == "table" and Object.SetVisibility then
                        MenuSection:Toggle({
                            Name = Entry[2],
                            Flag = Entry[1],
                            Default = true,
                            Callback = function(Value)
                                Object:SetVisibility(Value)
                            end
                        })
                    end
                end

                MenuSection:Dropdown({
                    Name = "UI Click Sound",
                    Flag = "UIClickSound",
                    Items = { "Simple click", "None" },
                    Default = "Simple click",
                    Callback = function(Value)
                        Library:SetUIClickSound(Value ~= "None" and "88442833509532" or nil)
                    end
                })

                MenuSection:Slider({
                    Name = "UI Click Volume",
                    Flag = "UIClickVolume",
                    Min = 0,
                    Max = 100,
                    Default = math.floor((Library.UIClickVolume or 0.65) * 100 + 0.5),
                    Decimals = 0,
                    Suffix = "%",
                    Callback = function(Value)
                        Library:SetUIClickVolume(Value / 100)
                    end
                })

                MenuSection:Divider()

                MenuSection:SubButton({
                    Name = "Unload",
                    ConfirmText = "are you sure?",
                    ConfirmTime = 1.5,
                    Callback = function()
                        task.defer(function()
                            Library:Exit()
                        end)
                    end
                })
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

            return SettingsPage
        end
    end
end

getgenv().Library = Library
return Library
