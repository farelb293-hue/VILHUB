-- [[ VILHUB V2 FULL FEATURE - ANTI ERROR VERSION ]] --
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success then return end

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

-- [[ WINDOW ]] --
local Window = WindUI:CreateWindow({
    Title = "VILHUB V2",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 400)
})

-- [[ TABS ]] --
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ 1. MAIN TAB - MOVEMENT ]] --
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
            bg.P = 10000
            
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

-- [[ 2. COMBAT TAB - ATTACK ]] --
CombatTab:Toggle({
    Title = "Auto Dagger (Meele)",
    Callback = function(state) autoDagger = state end
})

CombatTab:Toggle({
    Title = "Auto Look & Shoot Killer",
    Callback = function(state) autoShootKiller = state end
})

-- [[ 3. AUTOMATION TAB - MISSION ]] --
AutoTab:Toggle({
    Title = "Auto Repair Generator",
    Callback = function(state) autoGen = state end
})

-- [[ LOGIC CORE ]] --
local function getKiller()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- Deteksi Team Merah (Killer)
            if p.TeamColor == BrickColor.new("Really red") or p.Name:lower():find("killer") then
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
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")

    -- Auto Dagger
    if autoDagger and tool then
        if tool.Name:lower():find("dagger") or tool.Name:lower():find("knife") then
            tool:Activate()
        end
    end

    -- Auto Look & Shoot
    if autoShootKiller and tool then
        local target = getKiller()
        if target then
            local targetPos = Vector3.new(target.Position.X, char.HumanoidRootPart.Position.Y, target.Position.Z)
            char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, targetPos)
            tool:Activate()
        end
    end

    -- Auto Gen
    if autoGen then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Generator" and obj:FindFirstChild("RemoteEvent") then
                obj.RemoteEvent:FireServer("Repair")
            end
        end
    end
end)

Window:Notification({ Title = "VILHUB V2", Content = "Semua Fitur Aktif!", Duration = 5 })
