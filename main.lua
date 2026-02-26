local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ GLOBAL VARIABLES ]] --
_G.FlySpeed = 50
local flying, autoGen, autoDagger, autoShootKiller, espEnabled = false, false, false, false, false

-- [[ WINDOW ]] --
local Window = WindUI:CreateWindow({
    Title = "VILHUB V2.6 (FIXED)",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 420)
})

-- [[ TABS ]] --
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ 1. MAIN TAB ]] --
MainTab:Button({
    Title = "Aktifkan/Matikan Fly",
    Callback = function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not root or not hum then return end
        flying = not flying
        if flying then
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "VilFlyBV"
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            local bg = Instance.new("BodyGyro", root)
            bg.Name = "VilFlyBG"
            bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            task.spawn(function()
                while flying and root and bv and bg do
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.FlySpeed
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                    task.wait(0.01)
                end
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end
})

MainTab:Slider({
    Title = "Speed Terbang (Klik Angka)",
    Min = 0, Max = 1000, Default = 50,
    Callback = function(v) _G.FlySpeed = tonumber(v) or 50 end
})

-- [[ 2. COMBAT TAB ]] --
CombatTab:Toggle({ Title = "Auto Dagger", Callback = function(state) autoDagger = state end })
CombatTab:Toggle({ Title = "Auto Look & Shoot Killer", Callback = function(state) autoShootKiller = state end })

-- [[ 3. VISUAL TAB ]] --
VisualTab:Toggle({
    Title = "ESP Killer",
    Callback = function(state) espEnabled = state end
})

-- [[ 4. AUTOMATION TAB ]] --
AutoTab:Toggle({
    Title = "Auto Repair Gen",
    Callback = function(state) autoGen = state end
})

-- [[ LOGIC CORE ]] --

-- Fungsi Cerdas Deteksi Killer
local function isKiller(p)
    if not p.Character then return false end
    -- Cek Team Merah
    if p.TeamColor == BrickColor.new("Really red") then return true end
    -- Cek Nama
    if p.Name:lower():find("killer") or p.DisplayName:lower():find("killer") then return true end
    -- Cek Senjata yang dipegang
    local tool = p.Character:FindFirstChildOfClass("Tool")
    if tool and (tool.Name:lower():find("knife") or tool.Name:lower():find("dagger") or tool.Name:lower():find("hammer")) then
        return true
    end
    return false
end

-- Loop ESP & Auto Gen
RunService.Heartbeat:Connect(function()
    -- ESP LOGIC
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = p.Character:FindFirstChild("VilESP")
            if espEnabled and isKiller(p) then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "Vil
