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
                    
                    -- Animasi Kaki Bergerak
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
    Title = "Auto Tembak & Look Killer",
    Description = "Lock target & tembak Killer otomatis",
    Callback = function(state) autoShootKiller = state end
})

-- [[ 3. AUTOMATION TAB ]] --
AutoTab:Toggle({
    Title = "Auto Repair Gen",
    Callback = function(state) autoGen = state end
})

-- ==================== LOGIC CORE ====================

-- Fungsi mencari Killer terdekat
local function getKiller()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- Deteksi berdasarkan Team Red atau tag 'Killer'
            if p.TeamColor == BrickColor.new("Really red") or p.Name:lower():find("killer") or p.Character:FindFirstChild("KillerTag") then
                local d = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    target = p.Character.HumanoidRootPart
                end
            end
        end
    end
    return target
end

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local tool = char:FindFirstChildOfClass("Tool")

    -- LOGIC: AUTO DAGGER
    if autoDagger and tool then
        if tool.Name:lower():find("dagger") or tool.Name:lower():find("knife") then
            tool:Activate() 
        end
    end

    -- LOGIC: AUTO SHOOT & LOOK
    if autoShootKiller and tool then
        local target = getKiller()
        if target then
            -- AUTO LOOK (Menghadap Killer)
            local targetPos = Vector3.new(target.Position.X, char.HumanoidRootPart.Position.Y, target.Position.Z)
            char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, targetPos)
            
            -- AUTO SHOOT
            tool:Activate()
        end
    end

    -- LOGIC: AUTO GEN
