--[[
    Icons.lua  (кладётся в твой репозиторий рядом с Source.lua)

    Что делает: превращает название иконки ("eye", "settings", ...) в данные для ImageLabel.
    Иконки берутся из Lucide (https://lucide.dev) через latte-soft/lucide-roblox.

    ПОДГОТОВКА:
    1. Открой https://github.com/latte-soft/lucide-roblox -> Releases
       и скачай lucide-roblox.luau
    2. Залей его в свой репозиторий и вставь raw-ссылку в LUCIDE_URL ниже.

    Лицензии: lucide-roblox - MIT, сами иконки Lucide - ISC. Оставь их уведомления в репозитории.
]]

local LUCIDE_URL = "https://raw.githubusercontent.com/xolylol/dogy-visuals-ui/main/lucide-roblox.luau"

local Icons = {
    -- Размер спрайта Lucide. Если иконки не находятся, поменяй на 256
    Size = 48,
    Custom = { },
}

local Lucide do
    local Success, Result = pcall(function()
        return loadstring(game:HttpGet(LUCIDE_URL))()
    end)

    if Success and type(Result) == "table" then
        Lucide = Result
    else
        warn("[Icons] Failed to load lucide-roblox: " .. tostring(Result))
    end
end

local function Normalize(Name)
    Name = tostring(Name):lower():gsub("^lucide[%-_:]", ""):gsub("[%s_]+", "-")
    return Name
end

-- Свои иконки: Icons.Register("logo", "rbxassetid://123")
function Icons.Register(Name, Asset)
    if type(Asset) == "number" then
        Asset = "rbxassetid://" .. tostring(Asset)
    end

    Icons.Custom[Normalize(Name)] = Asset
end

-- Возвращает { Image, ImageRectSize, ImageRectOffset } или nil
function Icons.Get(Name, Size)
    Name = Normalize(Name)

    local Custom = Icons.Custom[Name]
    if Custom then
        return { Image = Custom }
    end

    if not Lucide then
        return nil
    end

    for _, TrySize in { Size or Icons.Size, 256, 48 } do
        local Success, Asset = pcall(Lucide.GetAsset, Name, TrySize)

        if Success and type(Asset) == "table" and Asset.Url then
            return {
                Image = Asset.Url,
                ImageRectSize = Asset.ImageRectSize,
                ImageRectOffset = Asset.ImageRectOffset
            }
        end
    end

    return nil
end

function Icons.Has(Name)
    return Icons.Get(Name) ~= nil
end

-- Список всех названий Lucide
function Icons.List()
    return Lucide and Lucide.IconNames or { }
end

return Icons
