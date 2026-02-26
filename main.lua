local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ GLOBAL VARIABLES ]] --
local speed = 50
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
    Size = UDim2.fromOffset(450, 400) -- Ukuran sedikit diperbesar untuk tab baru
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
            bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            
            task.spawn(function()
                while flying do
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
                    task.wait(0.05)
                end
            end)
        else
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
})

MainTab:Slider({
    Title = "Speed Terbang",
    Min = 10, Max = 200, Default = 50,
    Callback = function(v) speed = v end
})

-- [[ 2. COMBAT TAB: AUTO DAGGER ]] --
CombatTab:Toggle({
    Title = "Auto Dagger",
    Description = "Otomatis menyerang saat memegang pisau",
    Callback = function(state) 
        autoDagger = state 
    end
})

-- [[ 3. AUTOMATION TAB: AUTO GEN ]] --
AutoTab:Toggle({
    Title = "Auto Repair Generator",
    Callback = function(state) autoGen = state end
})

-- ==================== LOGIC CORE ====================

-- LOGIC: AUTO DAGGER (Setiap 0.1 detik cek senjata)
task.spawn(function()
    while task.wait(0.1) do
        if autoDagger then
            local char = player.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                -- Cek apakah nama item mengandung kata 'Dagger' atau 'Knife'
                if tool and (tool.Name:lower():find("dagger") or tool.Name:lower():find("knife")) then
                    tool:Activate() 
                end
            end
        end
    end
end)

-- LOGIC: AUTO GEN
task.spawn(function()
    while task.wait(0.5) do
        if autoGen then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Generator" and obj:FindFirstChild("RemoteEvent") then
                    obj.RemoteEvent:FireServer("Repair") 
                end
            end
        end
    end
end)

-- Notifikasi Berhasil Update
Window:Notification({
    Title = "VILHUB",
    Content = "Tab Combat & Auto Dagger Berhasil Ditambahkan!",
    Duration = 5
})
