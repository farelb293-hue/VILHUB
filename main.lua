local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ GLOBAL VARIABLES ]] --
local speed = 50
local flying = false
local autoGen = false
local bv, bg

-- [[ WINDOW CONFIGURATION ]] --
local Window = WindUI:CreateWindow({
    Title = "VILHUB",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 350)
})

-- [[ TABS ]] --
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
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
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(v) speed = v end
})

-- [[ 2. AUTOMATION TAB: AUTO GEN ]] --
AutoTab:Toggle({
    Title = "Auto Repair Generator",
    Description = "Otomatis memperbaiki generator terdekat",
    Callback = function(state) 
        autoGen = state 
    end
})

-- [[ LOGIC CORE: AUTO GEN ]] --
task.spawn(function()
    while task.wait(0.5) do
        if autoGen then
            -- Cari Generator terdekat (Logika dasar: mencari objek bernama 'Generator')
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Generator" and obj:FindFirstChild("RemoteEvent") then
                    -- Contoh logika: Mengirim signal repair ke server
                    obj.RemoteEvent:FireServer("Repair") 
                end
            end
        end
    end
end)

Window:Notification({
    Title = "VILHUB UPDATED",
    Content = "Fitur Auto Gen Berhasil Ditambahkan!",
    Duration = 5
})
