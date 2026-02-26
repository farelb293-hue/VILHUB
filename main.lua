-- Tunggu game loading sempurna
if not game:IsLoaded() then game.Loaded:Wait() end

-- Panggil library UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Buat Window Utama
local Window = WindUI:CreateWindow({
    Title = "VILHUB",
    Icon = "rbxassetid://136360402262473",
    Author = "Vilhub",
    Folder = "VilhubData",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 300), -- Ukuran diperkecil biar ringan
    Transparent = true
})

-- Buat Tab
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

-- Tambah Fitur Speed
MainTab:Slider({
    Title = "Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

-- Tambah Fitur Terbang (Fly)
MainTab:Button({
    Title = "Aktifkan Fly",
    Callback = function()
        -- Script terbang simpel kamu yang tadi
        loadstring(game:HttpGet("https://raw.githubusercontent.com/farelb293-hue/VILHUB/main/main.lua"))() 
    end
})

-- Notifikasi kalau berhasil
Window:Notification({
    Title = "VILHUB",
    Content = "Script Berhasil Dimuat!",
    Duration = 3
})
