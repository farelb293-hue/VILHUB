
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- [[ GLOBAL VARIABLES ]] --
local espActive = false
local autoGen = false
local autoSkillCheck = true
local killAuraActive = false
local walkSpeedValue = 16
local noclipActive = false

-- [[ WINDOW CONFIGURATION ]] --
local Window = WindUI:CreateWindow({
    Title = "Vilhub",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Folder = "VilhubData",
    Theme = "Indigo",
    Size = UDim2.fromOffset(580, 360),
    Transparent = true
})

-- [[ TABS ]] --
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ 1. MAIN TAB: MOVEMENT ]] --
MainTab:Slider({
    Title = "Speedwalk",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(v) walkSpeedValue = v end
})

MainTab:Toggle({
    Title = "Noclip (Nembus)",
    Callback = function(state) noclipActive = state end
})

-- [[ 2. VISUALS TAB: ESP (FIXED) ]] --
VisualTab:Toggle({
    Title = "ESP Players & Killer",
    Description = "Red = Killer, White = Survivor",
    Callback = function(state) 
        espActive = state 
        if not state then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("TereESP") then
                    p.Character.TereESP:Destroy()
                end
            end
        end
    end
})

-- [[ 3. COMBAT TAB: KILL AURA ]] --
CombatTab:Toggle({
    Title = "Kill Aura",
    Callback = function(state) killAuraActive = state end
})

-- [[ 4. AUTOMATION TAB: AUTO GEN ]] --
AutoTab:Toggle({
    Title = "Full Auto Generator",
    Description = "Teleport samping & Auto Repair",
    Callback = function(state) autoGen = state end
})

AutoTab:Toggle({
    Title = "Auto Perfect Skill Check",
    Callback = function(state) autoSkillCheck = state end
})

-- ==================== LOGIC CORE ====================

-- LOGIC: MOVEMENT & NOCLIP
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = walkSpeedValue
        if noclipActive then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- LOGIC: ESP (RENDERING)
RunService.RenderStepped:Connect(function()
    if espActive then
        for _, p in pairs(Players:GetPlayers()) do
... (91 lines left)