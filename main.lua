local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ SETTINGS ]] --
_G.ESP_Enabled = false
_G.AutoCombat = false 
_G.AutoGenerator = false
_G.TP_Gen = false

local Window = WindUI:CreateWindow({
    Title = "VILHUB V9 GHOST",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 450)
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ FUNGSI DETEKSI KILLER GHOST ]] --
local function IsKiller(obj)
    if not obj:IsA("Model") or not obj:FindFirstChild("Humanoid") then return false end
    
    -- Cek Senjata (Paling Akurat)
    if obj:FindFirstChildOfClass("Tool") then return true end
    
    -- Cek Tim & Nama
    local p = Players:GetPlayerFromCharacter(obj)
    if p then
        if p.TeamColor == BrickColor.new("Really red") or 
           p.Name:lower():find("killer") or 
           (p.Team and p.Team.Name:lower():find("killer")) then
            return true
        end
    end
    
    -- Cek Animasi Serang (Khusus Killer NPC/Player)
    local hum = obj:FindFirstChild("Humanoid")
    if hum and hum:FindFirstChild("Animator") then
        for _, anim in pairs(hum.Animator:GetPlayingAnimationTracks()) do
            if anim.Animation.AnimationId:find("attack") or anim.Animation.AnimationId:find("slash") then
                return true
            end
        end
    end
    
    return false
end

-- [[ UI TOGGLES ]] --
VisualTab:Toggle({
    Title = "ESP Killer (Ultra Detect)",
    Callback = function(state) _G.ESP_Enabled = state end
})

AutoTab:Toggle({
    Title = "Auto Attack & Shoot",
    Callback = function(state) _G.AutoCombat = state end
})

AutoTab:Toggle({
    Title = "Auto Repair (Remote)",
    Callback = function(state) _G.AutoGenerator = state end
})

AutoTab:Button({
    Title = "TP ke Generator Terdekat",
    Callback = function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local targetGen = nil
        local dist = math.huge
        
        for _, v in pairs(workspace:GetDescendants()) do
            if (v.Name:lower():find("gen") or v.Name:lower():find("engin")) and v:IsA("BasePart") then
                local d = (char.HumanoidRootPart.Position - v.Position).Magnitude
                if d < dist then
                    dist = d
                    targetGen = v
                end
            end
        end
        
        if targetGen then
            char.HumanoidRootPart.CFrame = targetGen.CFrame * CFrame.new(0, 5, 0)
            Window:Notification({Title = "VILHUB", Content = "Berhasil TP ke Generator!", Duration = 2})
        else
            Window:Notification({Title = "VILHUB", Content = "
