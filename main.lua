local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ SETTINGS ]] --
_G.ESP_Enabled = false
_G.AutoCombat = false 
_G.AutoGenerator = false

local Window = WindUI:CreateWindow({
    Title = "VILHUB V8 ULTRA",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 420)
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ FUNGSI DETEKSI KILLER AGGRESIF ]] --
local function IsKiller(obj)
    if not obj:IsA("Model") or not obj:FindFirstChild("Humanoid") then return false end
    -- Cek Senjata
    if obj:FindFirstChildOfClass("Tool") then return true end
    -- Cek Nama/Tim
    local p = Players:GetPlayerFromCharacter(obj)
    if p and (p.TeamColor == BrickColor.new("Really red") or p.Name:lower():find("killer") or p.Team.Name:lower():find("killer")) then
        return true
    end
    -- Cek Part Merah (Sering ada di Killer)
    if obj:FindFirstChild("Head") and obj.Head:FindFirstChildOfClass("PointLight") then return true end
    return false
end

-- [[ UI TOGGLES ]] --
VisualTab:Toggle({
    Title = "ESP Killer (All Folders)",
    Callback = function(state) _G.ESP_Enabled = state end
})

AutoTab:Toggle({
    Title = "Auto Attack & Shoot",
    Callback = function(state) _G.AutoCombat = state end
})

AutoTab:Toggle({
    Title = "Auto Repair (Multi-Name)",
    Callback = function(state) _G.AutoGenerator = state end
})

-- [[ MAIN LOOP ]] --
RunService.Heartbeat:Connect(function()
    -- 1. SCAN SEMUA MODEL (ESP & COMBAT)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= player.Character then
            local isTarget = IsKiller(obj)
            
            -- ESP
            local hl = obj:FindFirstChild("VilESP")
            if _G.ESP_Enabled and isTarget then
                if not hl then hl = Instance.new("Highlight", obj); hl.Name = "VilESP" end
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            elseif hl then hl:Destroy() end

            -- COMBAT (Dagger/Shoot)
            if _G.AutoCombat and isTarget and player.Character and player.Character:FindFirstChildOfClass("Tool") then
                local dist = (player.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if dist < 20 then
                    player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(player.Character.HumanoidRootPart.Position, Vector3.new(obj.HumanoidRootPart.Position.X, player.Character.HumanoidRootPart.Position.Y, obj.HumanoidRootPart.Position.Z))
                    player.Character:FindFirstChildOfClass("Tool"):Activate()
                end
            end
        end

        -- 2. SCAN GENERATOR (Multi-Target)
        if _G.AutoGenerator then
            if obj.Name:lower():find("gen") or obj.Name:lower():find("engin") or obj.Name:lower():find("repair") then
                local remote = obj:FindFirstChildOfClass("RemoteEvent") or obj:FindFirstChildOfClass("UnreliableRemoteEvent")
                if remote then
                    remote:FireServer("Repair")
                    remote:FireServer("Fix")
                    remote:FireServer("Action", "Repair")
                end
            end
        end
    end
end)
