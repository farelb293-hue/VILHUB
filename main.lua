local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ SETTINGS ]] --
_G.ESP_Enabled = false
_G.AutoLook = false

local Window = WindUI:CreateWindow({
    Title = "VILHUB V5 UNIVERSAL",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 400)
})

local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })

-- [[ FUNGSI DETEKSI KILLER SUPER AKURAT ]] --
local function GetKiller(p)
    if not p.Character then return false end
    
    -- 1. Cek dari Senjata yang dipegang
    local tool = p.Character:FindFirstChildOfClass("Tool")
    if tool and (tool.Name:lower():find("knife") or tool.Name:lower():find("dagger") or tool.Name:lower():find("hammer") or tool.Name:lower():find("weapon")) then
        return true
    end
    
    -- 2. Cek dari Team (Merah/Killer)
    if p.TeamColor == BrickColor.new("Really red") or p.Team.Name:lower():find("killer") then
        return true
    end
    
    -- 3. Cek dari String Nama
    if p.Name:lower():find("killer") or p.DisplayName:lower():find("killer") then
        return true
    end
    
    return false
end

-- [[ UI TOGGLES ]] --
VisualTab:Toggle({
    Title = "ESP Killer (Highlight Merah)",
    Callback = function(state) _G.ESP_Enabled = state end
})

CombatTab:Toggle({
    Title = "Auto Look at Killer",
    Callback = function(state) _G.AutoLook = state end
})

-- [[ MAIN LOOP ]] --
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = p.Character:FindFirstChild("VilESP")
            
            if _G.ESP_Enabled and GetKiller(p) then
                -- Buat Highlight jika belum ada
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "VilESP"
                    highlight.Parent = p.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) --
