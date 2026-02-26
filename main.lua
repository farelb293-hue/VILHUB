local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ GLOBAL VARIABLES ]] --
_G.FlySpeed = 50 -- Menggunakan Global Variable agar pasti terbaca
local flying = false
local autoGen = false
local autoDagger = false
local bv, bg

-- [[ WINDOW CONFIGURATION ]] --
local Window = WindUI:CreateWindow({
    Title = "VILHUB",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 400)
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
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        flying = not flying
        if flying then
            -- Buat BodyVelocity
            bv = Instance.new("BodyVelocity")
            bv.Name = "VilhubFlyBV"
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bv.Parent = root
            
            -- Buat BodyGyro
            bg = Instance.new("BodyGyro")
            bg.Name = "VilhubFlyBG"
            bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            bg.P = 10000
            bg.Parent = root
            
            -- Loop Terbang
            task.spawn(function()
                while flying and root and bv and bg do
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    -- Mengambil nilai langsung dari _G.FlySpeed
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.FlySpeed
                    task.wait(0.01)
                end
            end)
        else
            -- Hapus efek terbang
            flying = false
            if root:FindFirstChild("VilhubFlyBV") then root.VilhubFlyBV:Destroy() end
            if root:FindFirstChild("VilhubFlyBG") then root.VilhubFlyBG:Destroy() end
        end
    end
})

MainTab:Slider({
    Title = "Speed Terbang",
    Min = 0, 
    Max = 500, 
    Default = 50,
    Callback = function(v) 
        _G.FlySpeed = v -- Update nilai global
    end
})

-- [[ 2. COMBAT TAB ]] --
CombatTab:Toggle({
    Title = "Auto Dagger",
    Callback = function(state) autoDagger = state end
})

-- [[ 3. AUTOMATION TAB ]] --
AutoTab:Toggle({
    Title = "Auto Repair Gen",
    Callback = function(state) autoGen = state end
})

-- [[ LOGIC CORE ]] --
RunService.Heartbeat:Connect(function()
    if autoDagger and player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool and (tool.Name:lower():find("dagger") or tool.Name:lower():find("knife")) then
            tool:Activate() 
        end
    end
end)

Window:Notification({
    Title = "VILHUB",
    Content = "Script Fixed! Coba geser slidernya.",
    Duration = 3
})
