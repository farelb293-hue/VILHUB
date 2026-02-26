-- [[ VILHUB V2.5 FULL FEATURE + ESP KILLER ]] --
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
local espEnabled = false

-- [[ WINDOW ]] --
local Window = WindUI:CreateWindow({
    Title = "VILHUB V2.5",
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

-- [[ 3. VISUAL TAB (ESP) ]] --
VisualTab:Toggle({
    Title = "ESP Killer (Kelihatan Tembok)",
    Description = "Membuat Killer berwarna merah terang",
    Callback = function(state) 
        espEnabled = state 
    end
})

-- [[ 4. AUTOMATION TAB ]] --
AutoTab:Toggle({ Title = "Auto Repair Generator", Callback = function(state) autoGen = state end })

-- [[ LOGIC CORE ]] --

-- Fungsi Deteksi Killer
local function isKiller(p)
    return p.TeamColor == BrickColor.new("Really red") or p.Name:lower():find("killer")
end

-- Sistem ESP (Highlight)
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = p.Character:FindFirstChild("VilESP")
            if espEnabled and isKiller(p) then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "VilESP"
                    highlight.Parent = p.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- Sistem Combat & Auto Gen
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")

    if autoDagger and tool and (tool.Name:lower():find("dagger") or tool.Name:lower():find("knife")) then
        tool:Activate()
    end

    if autoShootKiller and tool then
        local target = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and isKiller(p) then
                local d = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; target = p.Character.HumanoidRootPart end
            end
        end
        if target then
            char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, Vector3.new(target.Position.X, char.HumanoidRootPart.Position.Y, target.Position.Z))
            tool:Activate()
        end
    end

    if autoGen then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Generator" and obj:FindFirstChild("RemoteEvent") then
                obj.RemoteEvent:FireServer("Repair")
            end
        end
    end
end)

Window:Notification({ Title = "VILHUB V2.5", Content = "ESP Killer Siap!", Duration = 5 })
