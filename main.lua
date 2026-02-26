-- [[ VILHUB V4 STABLE UPDATE ]] --
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

-- Jika library gagal, gunakan notifikasi internal Roblox
if not success or not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "VILHUB ERROR",
        Text = "Gagal memuat UI Library. Coba execute ulang!",
        Duration = 5
    })
    return
end

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ GLOBAL VARIABLES ]] --
_G.FlySpeed = 50
local flying, autoGen, autoDagger, autoShootKiller, espEnabled = false, false, false, false, false
local walkSpeedValue = 16

-- [[ WINDOW ]] --
local Window = WindUI:CreateWindow({
    Title = "VILHUB V4 STABLE",
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

-- [[ 1. MAIN TAB ]] --
MainTab:Button({
    Title = "Aktifkan/Matikan Fly",
    Callback = function()
        flying = not flying
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if flying then
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "VilFly"
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            task.spawn(function()
                while flying do
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.FlySpeed
                    task.wait()
                end
                bv:Destroy()
            end)
        end
    end
})

MainTab:Slider({
    Title = "Speed Terbang (Klik Angka)",
    Min = 0, Max = 1000, Default = 50,
    Callback = function(v) _G.FlySpeed = v end
})

-- [[ 2. COMBAT TAB ]] --
CombatTab:Toggle({ Title = "Auto Dagger", Callback = function(s) autoDagger = s end })
CombatTab:Toggle({ Title = "Auto Look Killer", Callback = function(s) autoShootKiller = s end })

-- [[ 3. VISUALS TAB (FIXED) ]] --
VisualTab:Toggle({
    Title = "ESP Killer",
    Description = "Membuat killer tembus pandang",
    Callback = function(state) espEnabled = state end
})

-- [[ 4. AUTOMATION TAB (FIXED) ]] --
AutoTab:Toggle({
    Title = "Auto Repair Generator",
    Callback = function(state) autoGen = state end
})

-- [[ LOGIC CORE ]] --
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end

    -- ESP LOGIC
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hl = p.Character:FindFirstChild("VilHighlight")
            if espEnabled and (p.TeamColor == BrickColor.new("Really red") or p.Name:lower():find("killer")) then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "VilHighlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                end
            elseif hl then hl:Destroy() end
        end
    end

    -- AUTO GEN LOGIC
    if autoGen then
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():find("generator") and v:FindFirstChildOfClass("RemoteEvent") then
                v:FindFirstChildOfClass("RemoteEvent"):FireServer("Repair")
            end
        end
    end
end)

Window:Notification({ Title = "VILHUB", Content = "Script Updated V4!", Duration = 5 })
