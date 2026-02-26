local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "VILHUB",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 300)
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

-- FUNGSI TERBANG (FLY)
local flying = false
local speed = 50
local bv, bg

local function toggleFly()
    local char = game.Players.LocalPlayer.Character
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

-- TOMBOL DI MENU
MainTab:Button({
    Title = "Aktifkan/Matikan Fly",
    Callback = function()
        toggleFly() -- Memanggil fungsi di atas, bukan loadstring lagi
    end
})

MainTab:Slider({
    Title = "Speed Terbang",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(v) speed = v end
})

