-- DOGY VISUALS UI PATCH v5: Editable sliders + color clipboard + mascot rotation + window icons
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
    BuildVersion = "2026.10.27-mascot-settings-v2", 
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
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
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
        ["RightBracket"]      = "RightBracked",
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
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
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

    Library.SetUIClickVolume = function(Self, Volume)
        local Value = math.clamp(tonumber(Volume) or 0.65, 0, 1)
        Library.UIClickVolume = Value
        if Library.UIClickSound then Library.UIClickSound.Volume = Value end
        return Value
    end

    Library.SetMascotClickVolume = function(Self, Volume)
        local Value = math.clamp(tonumber(Volume) or 0.8, 0, 1)
        Library.MascotClickVolume = Value
        if Library.MascotClickSound then Library.MascotClickSound.Volume = Value end
        return Value
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
        for _, Connection in Library.Connections do 
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do 
            coroutine.close(Thread)
        end

        if Self.Holder then 
            Self.Holder.Instance:Destroy()
        end

        if Self.NotifHolder then 
            Self.NotifHolder.Instance:Destroy()
        end

        if Self.UnusedHolder then 
            Self.UnusedHolder.Instance:Destroy()
        end

        if Self.UIClickSound then
            pcall(function() Self.UIClickSound:Destroy() end)
        end

        if Self.MascotClickSound then
            pcall(function() Self.MascotClickSound:Destroy() end)
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do 
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
                continue
            end

            if Property == "TextSize" then 
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then 
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then 
                if Property == "AutoButtonColor" then 
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then 
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
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

                    return
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

    Library.FadeDescendants = function(Self, Visibility, Callback)
        Library._FadeTokens = Library._FadeTokens or {}
        local Object = Self.Instance
        local Token = (Library._FadeTokens[Object] or 0) + 1
        Library._FadeTokens[Object] = Token

        if Visibility then 
            Object.Visible = true 
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
            if Library._FadeTokens[Object] ~= Token then
                return
            end
            if Callback and type(Callback) == "function" then 
                Callback()
            end

            Object.Visible = Visibility
            return
        end

        Library:Connect(NewTween.Completed, function()
            if Library._FadeTokens[Object] ~= Token then
                return
            end

            if Callback and type(Callback) == "function" then 
                Callback()
            end

            Object.Visible = Visibility
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
            return false
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
            warn("Failed to get config:\n"..Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
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
                if not Library.Theme[Value] then
                    Object[Property] = Value 
                end

                Object[Property] = Library.Theme[Value]
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
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
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
                ClipboardEnabled = false,

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
                    Name = " ",
                    Parent = Items["Top"].Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0
                })

                Library:Create("Frame", {
                    Name = " ",
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

            local SetClipboard = setclipboard or toclipboard or (setclipboard and setclipboard) or (syn and syn.write_clipboard)
            local GetClipboard = getclipboard or fromclipboard or (syn and syn.read_clipboard)

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
    
                Items["PaletteDragger"].Instance.Position = UDim2.new(SlideX, 0, SlideY, 0)
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
    
                Items["HueDragger"].Instance.Position = UDim2.new(0, 0, SlideY, 0)
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
    
                Items["AlphaDragger"].Instance.Position = UDim2.new(SlideX, 0, 0, 0)
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
            local Keybind = {
                Name = Data.Name or "Keybind",
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = { },
            }

            local Items = { } do
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "MOUSE2",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Visible = false,
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 240, 0, 0),
                    Position = UDim2.new(0, 1004, 0, 121),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
                
                Keybind.Items = Items
            end

            local ListItem 

            if Library.KeyList then
                ListItem = Library.KeyList:Add(Keybind.Name, "None")
            end

            local Debounce = false
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true 
                
                if Keybind.IsOpen then 
                    KeybindWindow.Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset)

                    KeybindWindow.Parent = Library.Holder.Instance
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    Library:RegisterOpenFrame(Keybind, {
                        HoverItems = { Items["KeybindWindow"], Items["SettingsButton"] },
                        AnchorInstance = KeyButton,
                        PopupInstance = KeybindWindow,
                    })
                else
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    Library:CloseOpenFrameChildren(Keybind)
                    Library:UnregisterOpenFrame(Keybind)
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then 
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end

            Items["KeybindWindow"]:VisibleCheck()
    
            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Keybind.Flag .. "ModeDropdown",
                Parent = Items["KeybindWindow"],
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value

                    Keybind:SetMode()

                    if Value == "Always" then 
                        Keybind:Press(true)
                    end
                end
            })

            local ResetButton = Library:Button({
                Name = "Reset",
                Parent  = Items["KeybindWindow"],
                Callback = function()
                    if Data.Default then
                        Keybind:Set(Data.Default)
                    end
                end
            })
    
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
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end
    
            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then 
                    local IsBackspace = Key.Name == "Backspace"

                    Keybind.Key = IsBackspace and "None" or tostring(Key)
    
                    Key = IsBackspace and "None" or Key.Name
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay
    
                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    if ListItem then
                        ListItem:Set(Keybind.Name, Keybind.Value)
                        ListItem:SetStatus(Keybind.Toggled)
                    end
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)
    
                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode()
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode()
                    end
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
    
                    TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    if ListItem then
                        ListItem:Set(Keybind.Name, Keybind.Value)
                        ListItem:SetStatus(Keybind.Toggled)
                    end
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode()
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                Keybind.Picking = false
            end
    
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 
    
                Items["KeyButton"].Instance.Text = ". . ."
    
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
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
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
                if GPE then
                    return
                end

                if Keybind.Value == "None" then
                    return
                end
    
                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)

            Library:RegisterOpenFrameTrigger(Items["KeyButton"])
    
            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)
    
            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end
    
            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

Library.Watermark = function(Self, Params)
            Params = Params or { }

            local Watermark = { 
                Name = Params.Name or Params.name or Self.Name or "Watermark",
                Logo = Params.Logo or Params.logo or Self.Logo,

                Window = Self,
                Visible = true,
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
                local WatermarkPressPosition
                Items["Watermark"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        WatermarkPressPosition = Input.Position
                    end
                end)
                Items["Watermark"]:Connect("InputEnded", function(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 or not WatermarkPressPosition then return end
                    local Delta = Input.Position - WatermarkPressPosition
                    WatermarkPressPosition = nil
                    if Delta.Magnitude > 5 then return end
                    local WindowObject = Watermark.Window
                    if WindowObject and WindowObject.SetOpen then
                        WindowObject:SetOpen(not WindowObject.IsOpen)
                    end
                end)
                
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
                    Text = 'FPS: <font color="rgb(120, 120, 120)">0</font>',
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
                    Text = 'PING: <font color="rgb(120, 120, 120)">0MS</font>',
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

            function Watermark:SetVisibility(Bool)
                Bool = Bool and true or false
                if Watermark.Visible == Bool then return end
                Watermark.Visible = Bool
                Items["Watermark"]:FadeDescendants(Bool)
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
                Icon = Params.Icon or Params.icon or "",
                Keys = { },
                Window = Self,
                Visible = true,
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
                
                Library:Create("UICorner", {
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
                    Library:ApplyIcon(Items["Icon"].Instance, KeybindList.Icon)
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
                    PaddingBottom = UDim.new(0, 10),
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
                    Items = RowItems,
                    StatusToken = 0
                }

                function NewKey:Set(NewName, NewKeyValue)
                    if NewName ~= nil then
                        NewKey.Name = tostring(NewName)
                        RowItems["Text"].Instance.Text = NewKey.Name
                    end

                    if NewKeyValue ~= nil then
                        NewKey.Key = tostring(NewKeyValue)
                        RowItems["Key"].Instance.Text = string.upper(NewKey.Key)
                    end
                end

                function NewKey:SetStatus(Bool)
                    Bool = Bool and true or false
                    NewKey.Active = Bool
                    NewKey.StatusToken += 1
                    local Token = NewKey.StatusToken
                    local KeyIsAssigned = NewKey.Key and tostring(NewKey.Key) ~= "None" and tostring(NewKey.Key) ~= ""

                    -- Keybind List shows every assigned bind, even when disabled.
                    -- Disabled = gray, enabled = accent/white. No stale hide/show callbacks.
                    if not KeyIsAssigned then
                        RowItems["NewKey"].Instance.Visible = false
                        return
                    end

                    RowItems["NewKey"].Instance.Visible = true
                    RowItems["Text"]:Tween({
                        TextTransparency = 0,
                        TextColor3 = Bool and Library.Theme["Text"] or Library.Theme["Inactive Text"],
                        Position = UDim2.new(0, 0, 0, RowHeight / 2)
                    }, KeybindTweenInfo)
                    RowItems["Key"]:Tween({
                        TextTransparency = 0,
                        TextColor3 = Bool and Library.Theme["Accent"] or Library.Theme["Inactive Text"],
                        Position = UDim2.new(1, 0, 0, RowHeight / 2)
                    }, KeybindTweenInfo)
                    RowItems["NewKey"]:Tween({Size = UDim2.new(1, 0, 0, RowSlot)}, KeybindTweenInfo)
                end

                function NewKey:Remove()
                    local Index = table.find(KeybindList.Keys, NewKey)

                    if Index then
                        table.remove(KeybindList.Keys, Index)
                    end

                    RowItems["NewKey"].Instance:Destroy()
                end

                table.insert(KeybindList.Keys, NewKey)
                return NewKey
            end

            function KeybindList:SetVisibility(Bool)
                Bool = Bool and true or false
                if KeybindList.Visible == Bool then return end
                KeybindList.Visible = Bool
                Items["KeybindList"]:FadeDescendants(Bool)
            end

            function KeybindList:SetText(Text)
                KeybindList.Name = tostring(Text)
                Items["Title"].Instance.Text = KeybindList.Name
            end

            function KeybindList:Center()
                Items["KeybindList"]:ConvertAnchor()
            end

            KeybindList:Center()

            Library.KeyList = KeybindList
            Self.KeybindList = KeybindList

            return setmetatable(KeybindList, Library)
        end

        Library.Notification = function(Self, Params)
            Params = Params or { }

            local Name = Params.Name or Params.name or "Notification"
            local Description = Params.Description or Params.description or ""
            local Duration = Params.Duration or Params.duration or 5
            local Color = Params.Color or Params.color or Library.Theme.Accent

            local Notification = {
                Removing = false,
                Items = { }
            }

            local Items = { } do 
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Inline"],
                    ZIndex = 100
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["Stroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 25),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ZIndex = 101
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Description"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Description,
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ZIndex = 101
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 15),
                    Size = UDim2.new(1, 0, 0, 5),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color,
                    ZIndex = 101
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["Duration"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = string.format("%.1fs", Duration),
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ZIndex = 101
                }):AddToTheme({TextColor3 = 'Inactive Text'})                
            end

            Notification.Items = Items
            table.insert(Library.Notifications, 1, Notification)

            for Index, Notif in Library.Notifications do
                Notif.Items["Notification"].Instance.LayoutOrder = Index
            end

            task.wait()

            local FullSize = Items["Notification"].Instance.AbsoluteSize
            local TweenInfoIn = TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
            Items["Notification"].Instance.Size = UDim2.new(0, 0, 0, 0)
            Items["Notification"].Instance.BackgroundTransparency = 1
            Items["Stroke"].Instance.Transparency = 1
            Items["Text"].Instance.TextTransparency = 1
            Items["Description"].Instance.TextTransparency = 1
            Items["Duration"].Instance.TextTransparency = 1
            Items["Liner"].Instance.BackgroundTransparency = 1
            Items["Liner"].Instance.Size = UDim2.new(1, 0, 0, 5)

            local Fade = function(Transparency)
                Items["Notification"]:Tween({BackgroundTransparency = Transparency}, TweenInfoIn)
                Items["Stroke"]:Tween({Transparency = Transparency}, TweenInfoIn)
                Items["Text"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Description"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Duration"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Liner"]:Tween({BackgroundTransparency = Transparency}, TweenInfoIn)
            end

            Library:Thread(function()
                Fade(0)
                Items["Notification"]:Tween({Size = UDim2.new(0, FullSize.X, 0, FullSize.Y)}, TweenInfoIn)

                Items["Liner"]:Tween({Size = UDim2.new(0, 0, 0, 5)}, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))

                local Start = tick()
                while tick() - Start < Duration and not Notification.Removing do
                    local Remaining = math.max(0, Duration - (tick() - Start))
                    Items["Duration"].Instance.Text = string.format("%.1fs", Remaining)
                    task.wait(0.05)
                end

                if Notification.Removing then
                    return
                end

                Notification.Removing = true

                for Index, Value in Library.Notifications do
                    if Value == Notification then
                        table.remove(Library.Notifications, Index)
                        break
                    end
                end

                Fade(1)
                Items["Notification"]:Tween({Size = UDim2.new(0, 0, 0, 0)}, TweenInfoIn)

                task.wait(Library.Animation.Time)
                Items["Notification"].Instance:Destroy()
            end)

            return Notification
        end

        Library.ESPPreview = function(Self, Params)
            Params = Params or { }

            local ESPPreview = {
                Name = Params.Name or Params.name or "ESP Preview",
                Icon = Params.Icon or Params.icon or "",

                Window = Self,
                Player = nil,
                Spinning = false,
                Visible = true,
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

                ViewportModel.Parent = Viewport.Instance

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

            function ESPPreview:SetVisibility(Bool)
                Bool = Bool and true or false
                if ESPPreview.Visible == Bool then return end
                ESPPreview.Visible = Bool
                Items["ESPPreview"]:FadeDescendants(Bool)
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
                Size = Params.Size or Params.size or Vector2.new(120, 120),
                Offset = Params.Offset or Params.offset or Vector2.new(6, 12),
                ZIndex = Params.ZIndex or Params.zindex or 3,
                PressScale = Params.PressScale or Params.pressscale or Vector2.new(1.05, 0.88),
                Callback = Params.Callback or Params.callback or function() end,
                Mascots = Mascots,
                CurrentMascot = DefaultMascot,

                Window = Self,
                Visible = Params.Visible ~= false,
                Loaded = false,
                Items = { }
            }

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
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.new(0, Mascot.Offset.X, 0, Mascot.Offset.Y),
                    Size = BaseSize,
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
                if not Mascot.Loaded then
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
                local Parent = Items["Image"].Instance.Parent
                local ParentSize = Parent and Parent.AbsoluteSize or Vector2.new(0, 0)
                local Size = Items["Image"].Instance.AbsoluteSize
                if ParentSize.X <= 0 then ParentSize = Vector2.new(ParentSize.X, 1080) end
                if ParentSize.Y <= 0 then ParentSize = Vector2.new(1920, ParentSize.Y) end
                return Vector2.new(
                    Mascot.Offset.X - ((ParentSize.X - Size.X) / 2),
                    Mascot.Offset.Y - ((ParentSize.Y - Size.Y) / 2)
                )
            end

            function Mascot:SetCenteredPosition(X, Y)
                local Parent = Items["Image"].Instance.Parent
                local ParentSize = Parent and Parent.AbsoluteSize or Vector2.new(0, 0)
                local Size = Items["Image"].Instance.AbsoluteSize
                if ParentSize.X <= 0 then return end
                if ParentSize.Y <= 0 then return end
                local NewX = tonumber(X)
                local NewY = tonumber(Y)
                if NewX then NewX = NewX + ((ParentSize.X - Size.X) / 2) end
                if NewY then NewY = NewY + ((ParentSize.Y - Size.Y) / 2) end
                Mascot:SetPosition(NewX, NewY, nil)
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

                -- Keep the requested coordinates. Do not clamp them against AbsoluteSize:
                -- the old clamp made the mascot jump/disappear while the UI was resizing.
                Items["Image"].Instance.Position = UDim2.fromOffset(Mascot.Offset.X, Mascot.Offset.Y)
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

            function Mascot:SetClickSound(SoundId)
                Mascot.ClickSound = SoundId
                return Library:SetMascotClickSound(SoundId)
            end

            function Mascot:SetUrl(Url)
                Mascot.Url = tostring(Url or "")
                Mascot.Loaded = false

                task.spawn(function()
                    local Asset = LoadImage(Mascot.Url)
                    if not Library or not Asset or not Items["Image"].Instance.Parent then
                        return
                    end

                    Items["Image"].Instance.Image = Asset
                    Mascot.Loaded = true
                    if Mascot.Visible then
                        Show()
                    end
                end)
            end

            function Mascot:SetMascot(Name)
                local Data = Mascot.Mascots and Mascot.Mascots[Name]
                if type(Data) == "string" then Data = {Url = Data} end
                if type(Data) ~= "table" or not Data.Url then return false end

                Mascot.CurrentMascot = Name
                Mascot:SetSize(Data.Size or Mascot.Size.X)
                local Offset = Data.Offset or Mascot.Offset
                Mascot:SetPosition(Offset.X, Offset.Y, Data.ZIndex or Mascot.ZIndex)
                Mascot:SetClickSound(Data.ClickSound or Params.ClickSound or "102774986031312")
                Mascot:SetUrl(Data.Url)
                return true
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
                Library:ApplyIcon(Items["Icon"].Instance, Page.Icon)
                
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

    if not Data then
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
        Icon = Params.Icon or Params.icon or "",

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
                    Callback = Keybind.Callback
                })

                return NewKeybind
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
                Decimals = Params.Decimals ~= nil and Params.Decimals or (Params.decimals ~= nil and Params.decimals or 1),
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

                local Percent = Range == 0 and 0 or math.clamp((Slider.Value - Slider.Min) / Range, 0, 1)

                -- Slider values are intentionally updated with NO tween.
                -- This keeps the displayed number and actual value perfectly in sync.
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)
                Items["Accent"].Instance.Size = UDim2.new(Percent, 0, 1, 0)
                Items["DraggerOutline"].Instance.Position = UDim2.new(Percent, (12 / 2) - (Percent * 12), 0.5, 0)
                Items["Accent"].Instance.BackgroundTransparency = Slider.Value == Slider.Min and 1 or 0

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
                    Text = Text:gsub("%s*" .. Slider.Suffix .. "%s*$", "")
                end
                local Number = tonumber(Text)
                if Number == nil or Number ~= Number or Number == math.huge or Number == -math.huge then
                    Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)
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
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
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
                    if type(Value) ~= "table" then 
                        return
                    end

                    List.Value = Value

                    for Index, Value in Value do
                        local OptionData = List.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[List.Flag] = Value
                else
                    if not List.Options[Value] then
                        return
                    end

                    local OptionData = List.Options[Value]

                    List.Value = Value

                    for Index, Value in List.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
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
                for Index, Value in List.Options do 
                    List:Remove(Value.Name)
                end

                for Index, Value in ListItems do 
                    List:Add(Value)
                end

                List:Search(Items["Input"].Instance.Text)
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

        Library.Init = function(Self)
            local SettingsPage = Self:Page({Name = "UI Settings", Icon = "rbxassetid://71354798783833"})

            local ConfigName
            local ConfigSelected
            local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

            local Notify = function(Name, Description, Color)
                Library:Notification({
                    Name = Name,
                    Description = Description or "",
                    Duration = 3,
                    Color = Color or Library.Theme.Accent
                })
            end

            local SuccessColor = Color3.fromRGB(52, 255, 126)
            local ErrorColor = Color3.fromRGB(255, 80, 80)

            do -- Profiles
                local ConfigsSection = SettingsPage:Section({Name = "Profiles", Icon = "folder", Side = 1})

                local ConfigsList = ConfigsSection:ListBox({
                    Flag = "Configs",
                    Items = { },
                    Multi = false,
                    Height = 200,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsSection:Textbox({
                    Name = "Config name",
                    Flag = "ConfigName",
                    Placeholder = "Config name",
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if not ConfigName or ConfigName == "" then
                            Notify("Error", "Config name can't be empty.", ErrorColor)
                            return
                        end

                        if isfile(ConfigsFolder .. ConfigName .. ".json") then
                            Notify("Error", 'Config "' .. ConfigName .. '" already exists.', ErrorColor)
                            return
                        end

                        writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                        Library:GetConfigsList(ConfigsList)
                        Notify("Success", 'Created config "' .. ConfigName .. '".', SuccessColor)
                    end
                })

                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            Notify("Error", "No config selected.", ErrorColor)
                            return
                        end

                        if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                            Notify("Error", 'Config "' .. ConfigSelected .. '" does not exist.', ErrorColor)
                            return
                        end

                        local Success, Error = Library:LoadConfig(readfile(ConfigsFolder .. ConfigSelected .. ".json"))

                        if Success then
                            Notify("Success", 'Loaded config "' .. ConfigSelected .. '".', SuccessColor)
                        else
                            Notify("Error", "Failed to load config:\n" .. tostring(Error), ErrorColor)
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            Notify("Error", "No config selected.", ErrorColor)
                            return
                        end

                        if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                            Notify("Error", 'Config "' .. ConfigSelected .. '" does not exist.', ErrorColor)
                            return
                        end

                        delfile(ConfigsFolder .. ConfigSelected .. ".json")
                        ConfigSelected = nil
                        Library:GetConfigsList(ConfigsList)
                        Notify("Success", "Deleted config.", SuccessColor)
                    end
                })

                ConfigsSection:Button({
                    Name = "Overwrite",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            Notify("Error", "No config selected.", ErrorColor)
                            return
                        end

                        if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                            Notify("Error", 'Config "' .. ConfigSelected .. '" does not exist.', ErrorColor)
                            return
                        end

                        writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                        Notify("Success", 'Overwrote config "' .. ConfigSelected .. '".', SuccessColor)
                    end
                })

                Library:GetConfigsList(ConfigsList)
            end

            do -- Autoload
                local AutoloadSection = SettingsPage:Section({Name = "Autoload", Icon = "zap", Side = 1})

                AutoloadSection:Button({
                    Name = "Set selected as autoload",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            Notify("Error", "No config selected.", ErrorColor)
                            return
                        end

                        if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                            Notify("Error", 'Config "' .. ConfigSelected .. '" does not exist.', ErrorColor)
                            return
                        end

                        writefile(Library.Directory .. "/autoload.json", readfile(ConfigsFolder .. ConfigSelected .. ".json"))
                        Notify("Success", 'Set "' .. ConfigSelected .. '" as autoload.', SuccessColor)
                    end
                })

                AutoloadSection:Button({
                    Name = "Clear autoload",
                    Callback = function()
                        writefile(Library.Directory .. "/autoload.json", "")
                        Notify("Success", "Cleared autoload.", SuccessColor)
                    end
                })
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
                        if not Library:ApplyTheme(Value) then
                            return
                        end

                        if ThemeReady then
                            Notify("Theme", 'Applied "' .. Value .. '" theme.', SuccessColor)
                        end
                    end
                })

                ThemeReady = true
                ThemingSection:Divider()

                for Index, Value in Library.Theme do
                    ThemingSection:Label({Name = Index}):Colorpicker({
                        Name = Index,
                        Flag = Index .. "Theming",
                        Default = Value,
                        Callback = function(Color)
                            Library.Theme[Index] = Color
                            Library:ChangeTheme(Index, Color)
                        end
                    })
                end
            end

            do -- Mascot
                local MascotSection = SettingsPage:Section({Name = "Mascot", Icon = "smile", Side = 2})
                local MascotObject = Self.Mascot
                local MascotNames = MascotObject and MascotObject:GetNames() or { }
                local MascotDefault = MascotObject and MascotObject.CurrentMascot

                if #MascotNames == 0 then
                    MascotNames = { "None" }
                end

                MascotSection:Dropdown({
                    Name = "Mascot",
                    Flag = "Mascot/Selected",
                    Items = MascotNames,
                    Default = MascotDefault or MascotNames[1],
                    Callback = function(Value)
                        if MascotObject and Value ~= "None" then
                            MascotObject:SetMascot(Value)
                        end
                    end
                })

                MascotSection:Slider({
                    Name = "Position X",
                    Flag = "Mascot/PositionX",
                    Min = -400,
                    Max = 400,
                    Default = -222,
                    Decimals = 0,
                    Callback = function(Value)
                        if MascotObject and MascotObject.SetCenteredPosition then MascotObject:SetCenteredPosition(Value, nil) end
                    end
                })

                MascotSection:Slider({
                    Name = "Position Y",
                    Flag = "Mascot/PositionY",
                    Min = -400,
                    Max = 400,
                    Default = -333,
                    Decimals = 0,
                    Callback = function(Value)
                        if MascotObject and MascotObject.SetCenteredPosition then MascotObject:SetCenteredPosition(nil, Value) end
                    end
                })

                MascotSection:Slider({
                    Name = "Rotation",
                    Flag = "Mascot/Rotation",
                    Min = -180,
                    Max = 180,
                    Default = MascotObject and MascotObject.Rotation or 0,
                    Decimals = 0,
                    Suffix = "°",
                    Callback = function(Value)
                        if MascotObject then MascotObject:SetRotation(Value) end
                    end
                })

                MascotSection:Slider({
                    Name = "Size",
                    Flag = "Mascot/Size",
                    Min = 20,
                    Max = 400,
                    Default = MascotObject and MascotObject.Size.X or 120,
                    Decimals = 0,
                    Callback = function(Value)
                        if MascotObject then MascotObject:SetSize(Value) end
                    end
                })

                MascotSection:Dropdown({
                    Name = "Click Sound",
                    Flag = "Mascot/ClickSound",
                    Items = {"nyaa", "None"},
                    Default = "nyaa",
                    Callback = function(Value)
                        if MascotObject then
                            MascotObject:SetClickSound(Value == "None" and nil or "102774986031312")
                        end
                    end
                })

                MascotSection:Slider({
                    Name = "Click Sound Volume",
                    Flag = "Mascot/ClickSoundVolume",
                    Min = 0, Max = 100, Decimals = 0, Suffix = "%",
                    Default = 80,
                    Callback = function(Value)
                        if Library.SetMascotClickVolume then Library:SetMascotClickVolume(Value / 100) end
                    end
                })

                MascotSection:SubButton({
                    Name = "Reset to Default",
                    ConfirmText = "reset mascot?",
                    ConfirmTime = 1.5,
                    Callback = function()
                        if not MascotObject then return end
                        MascotObject:SetSize(120)
                        MascotObject:SetRotation(0)
                        if MascotObject.SetCenteredPosition then
                            MascotObject:SetCenteredPosition(-222, -333)
                        else
                            MascotObject:SetPosition(6, 12, nil)
                        end
                    end
                })
            end

            do -- Menu
                local MenuSection = SettingsPage:Section({Name = "Menu", Icon = "menu", Side = 2})

                MenuSection:Label({Name = "Menu Keybind"}):Keybind({
                    Name = "Menu Keybind",
                    Flag = "MenuKeybind",
                    Default = Enum.KeyCode.X,
                    Mode = "Toggle",
                    Callback = function()
                        local Key = Library.Flags["MenuKeybind"] and Library.Flags["MenuKeybind"].Key

                        -- "None" (Backspace) игнорируем, чтобы нельзя было остаться без кнопки меню
                        if Key and Key ~= "None" then
                            Library.MenuKeybind = Key
                        end
                    end
                })

                if Self.Watermark then
                    MenuSection:Toggle({
                        Name = "Watermark",
                        Flag = "Watermark",
                        Default = true,
                        Callback = function(Value)
                            Self.Watermark:SetVisibility(Value)
                        end
                    })
                end

                if Self.KeybindList then
                    MenuSection:Toggle({
                        Name = "Keybind List",
                        Flag = "KeybindList",
                        Default = true,
                        Callback = function(Value)
                            Self.KeybindList:SetVisibility(Value)
                        end
                    })
                end

                if Self.ESPPreview then
                    MenuSection:Toggle({
                        Name = "ESP Preview",
                        Flag = "ESPPreview",
                        Default = true,
                        Callback = function(Value)
                            Self.ESPPreview:SetVisibility(Value)
                        end
                    })
                end

                if Self.Mascot then
                    MenuSection:Toggle({
                        Name = "Mascot",
                        Flag = "Mascot",
                        Default = true,
                        Callback = function(Value)
                            Self.Mascot:SetVisibility(Value)
                        end
                    })
                end

                MenuSection:Dropdown({
                    Name = "UI Click Sound",
                    Flag = "UIClickSound",
                    Items = {"Simple click", "None"},
                    Default = "Simple click",
                    Callback = function(Value)
                        Library:SetUIClickSound(Value == "None" and nil or "88442833509532")
                    end
                })

                MenuSection:Slider({
                    Name = "UI Click Volume",
                    Flag = "UIClickVolume",
                    Min = 0, Max = 100, Decimals = 0, Suffix = "%",
                    Default = 65,
                    Callback = function(Value)
                        if Library.SetUIClickVolume then Library:SetUIClickVolume(Value / 100) end
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

            local AutoloadOk, AutoloadContent = pcall(readfile, Library.Directory .. "/autoload.json")

            if AutoloadOk and AutoloadContent ~= "" then
                local Success, Error = Library:LoadConfig(AutoloadContent)

                if Success then
                    Notify("Autoload", "Loaded autoload config.", SuccessColor)
                else
                    Notify("Autoload", "Failed to load autoload:\n" .. tostring(Error), ErrorColor)
                end
            end
        end
    end
end

getgenv().Library = Library
return Library
