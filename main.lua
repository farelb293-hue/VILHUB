-- [[ VILHUB V4.1 ULTRA-LITE ]] --
local function GetLibrary()
    local success, lib = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    return success and lib or nil
end

local WindUI = GetLibrary()
if not WindUI then 
    warn("Gagal Memuat Library!") 
    return 
end

local Window = WindUI:CreateWindow({
    Title = "VILHUB FIXED",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 400)
})

-- [[ TAB GENERATOR DENGAN DELAY AGAR TIDAK KOSONG ]] --
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
task.wait(0.1)
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
task.wait(0.1)
local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
task.wait(0.1)
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ ISI TAB VISUALS (DIPASTIKAN ADA) ]] --
VisualTab:Toggle({
    Title = "ESP Killer",
    Callback = function(state) 
        _G.ESP = state 
    end
})

-- [[ ISI TAB AUTOMATION ]] --
AutoTab:Toggle({
    Title = "Auto Repair",
    Callback = function(state) 
        _G.AutoRepair = state 
    end
})

-- LOGIC UTAMA (RE-WRITTEN)
RunService.Heartbeat:Connect(function()
    if _G.ESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("Highlight")
                if p.TeamColor == BrickColor.new("Really red") then
                    if not hl then Instance.new("Highlight", p.Character) end
                end
            end
        end
    end
end)
