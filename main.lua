-- SCRIPT TESTER VILHUB
print("VILHUB: Script Berhasil Berjalan!")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Fungsi Fly Sederhana
local flying = true
local speed = 50
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
bv.Velocity = Vector3.new(0, 0, 0)
bv.Parent = char:WaitForChild("HumanoidRootPart")

task.spawn(function()
    while flying do
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
        task.wait(0.1)
    end
end)

print("Status: Terbang Aktif")
