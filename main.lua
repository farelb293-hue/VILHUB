local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ GLOBAL VARIABLES ]] --
_G.FlySpeed = 50
local flying = false
local autoGen = false
local autoDagger = false
local autoShootKiller = false
local espEnabled = false
local walkSpeedValue = 16

-- [[ WINDOW CONFIGURATION ]] --
local Window = WindUI:CreateWindow({
    Title = "VILHUB V3 FULL",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(480, 420)
})

-- [[ TABS ]] --
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ 1. MAIN TAB: MOVEMENT ]] --
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
                    hum:ChangeState(Enum.HumanoidStateType.Running) -- Animasi kaki gerak
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

MainTab:Slider({
    Title = "WalkSpeed (Jalan Kaki)",
    Min = 16, Max = 200, Default = 16,
    Callback = function(v) walkSpeedValue = v end
})

-- [[ 2. COMBAT TAB ]] --
CombatTab:Toggle({
    Title = "Auto Dagger / Knife",
    Callback = function(state) autoDagger = state end
})

CombatTab:Toggle({
    Title = "Auto Look & Shoot Killer",
    Callback = function(state) autoShootKiller = state end
})

-- [[ 3.
