-- VILHUB FLY SCRIPT
print("VILHUB: Script Terbang Aktif!")

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- Setting
local flying = true
local speed = 50 

-- Menghilangkan gravitasi biar nggak jatuh
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
bv.Velocity = Vector3.new(0, 0, 0)
bv.Parent = root

local bg = Instance.new("BodyGyro") -- Biar badan tetep tegak
bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
bg.P = 10000
bg.Parent = root

-- Loop pergerakan mengikuti arah kamera
task.spawn(function()
    while flying do
        bg.CFrame = workspace.CurrentCamera.CFrame
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
        task.wait(0.05)
    end
end)

-- Notifikasi di layar biar keren
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "VILHUB",
    Text = "Script Terbang Aktif!",
    Duration = 5
})
