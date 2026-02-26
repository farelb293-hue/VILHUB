-- Tunggu sampai game benar-benar siap
if not game:IsLoaded() then game.Loaded:Wait() end

-- Perbaikan Anti-Error UIStroke untuk Delta/Executor Mobile
local function SafeUI(instance)
    if instance:IsA("TextButton") or instance:IsA("Frame") then
        instance.ChildAdded:Connect(function(child)
            if child:IsA("UIStroke") then
                task.wait()
                child:Destroy() -- Hapus otomatis jika bikin error
            end
        end)
    end
end

-- Ambil Library WindUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("Gagal memuat WindUI. Mencoba ulang...")
    return
end

-- BUAT WINDOW DENGAN PROTEKSI
local Window = WindUI:CreateWindow({
    Title = "VILHUB FIXED",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 400)
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })

-- Fitur Fly yang sudah diperbaiki
_G.FlySpeed = 50
local flying = false

MainTab:Button({
    Title = "Aktifkan/Matikan Fly",
    Callback = function()
        flying = not flying
        local char = game.Players.LocalPlayer.Character
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
    Title = "Speed Terbang",
    Min = 10, Max = 500, Default = 50,
    Callback = function(v) _G.FlySpeed = v end
})

Window:Notification({
    Title = "VILHUB",
    Content = "Script Berhasil Dimuat Tanpa Error!",
    Duration = 5
})
