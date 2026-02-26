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
local bv, bg

-- [[ WINDOW CONFIGURATION ]] --
local Window = WindUI:CreateWindow({
    Title = "VILHUB",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 420)
})

-- [[ TABS ]] --
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ 1. MAIN TAB: FLY ]] --
MainTab:Button({
    Title = "Aktifkan/Matikan Fly",
    Callback = function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not root or not hum then return end

        flying = not flying
        if flying then
            bv = Instance.new("BodyVelocity")
            bv.Name = "VilhubFlyBV"
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bv.Parent = root
            
            bg = Instance.new("BodyGyro")
            bg.Name = "VilhubFlyBG"
            bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            bg.P = 10000
            bg.Parent = root
            
            task.spawn(function()
                while flying and root and bv and bg do
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.FlySpeed
                    
                    if hum.MoveDirection.Magnitude > 0 then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    else
                        hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                    end
                    task.wait(0.01)
                end
            end)
        else
            if root:FindFirstChild("VilhubFlyBV") then root.VilhubFlyBV:Destroy() end
            if root:FindFirstChild("VilhubFlyBG") then root.VilhubFlyBG:Destroy() end
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
})

MainTab:Slider({
    Title = "Speed Terbang (Klik Angka)",
    Min = 0, Max = 2000, Default = 50,
    Callback = function(v) _G.FlySpeed = tonumber(v) or 50 end
})

-- [[ 2. COMBAT TAB ]] --
CombatTab:Toggle({
    Title = "Auto Dagger",
    Callback = function(state) autoDagger = state end
})

CombatTab:Toggle({
    Title = "Auto Look & Shoot Killer",
    Callback = function(state) autoShootKiller = state end
})

-- [[ 3. AUTOMATION TAB ]] --
AutoTab:Toggle({
    Title = "Auto Repair Gen",
    Callback = function(state) autoGen = state end
})

-- [[ LOGIC CORE ]] --
local function getKiller()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- Deteksi Team Merah atau nama Killer
            if p.TeamColor == BrickColor.new("Really red") or p.Name:lower():find("killer") then
                local d = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    target = p.
