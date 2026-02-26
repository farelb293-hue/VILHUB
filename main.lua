local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ SETTINGS ]] --
_G.ESP_Enabled = false
_G.AutoCombat = false -- Auto Dagger & Shoot
_G.AutoGenerator = false

local Window = WindUI:CreateWindow({
    Title = "VILHUB V7 FINAL",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 420)
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local AutoTab = Window:Tab({ Title = "Automation", Icon = "cpu" })

-- [[ FUNGSI DETEKSI KILLER ]] --
local function GetKiller(char)
    if not char or not char:FindFirstChild("Humanoid") then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and (tool.Name:lower():find("knife") or tool.Name:lower():find("dagger") or tool.Name:lower():find("hammer") or tool.Name:lower():find("gun")) then
        return true
    end
    local p = Players:GetPlayerFromCharacter(char)
    if p and (p.TeamColor == BrickColor.new("Really red") or p.Name:lower():find("killer")) then
        return true
    end
    return false
end

-- [[ UI TOGGLES ]] --
VisualTab:Toggle({
    Title = "ESP Killer (Fixed Red)",
    Callback = function(state) _G.ESP_Enabled = state end
})

CombatTab:Toggle({
    Title = "Auto Dagger & Shoot Killer",
    Description = "Otomatis tebas/tembak saat dekat killer",
    Callback = function(state) _G.AutoCombat = state end
})

AutoTab:Toggle({
    Title = "Auto Generator",
    Description = "Otomatis repair mesin terdekat",
    Callback = function(state) _G.AutoGenerator = state end
})

-- [[ MAIN LOOP ]] --
RunService.RenderStepped:Connect(function()
    -- 1. FIXED RED ESP LOGIC
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= player.Character then
            local highlight = obj:FindFirstChild("VilESP")
            if _G.ESP_Enabled and GetKiller(obj) then
                if not highlight then
                    highlight = Instance.new("Highlight", obj)
                    highlight.Name = "VilESP"
                end
                highlight.FillColor = Color3.fromRGB(255, 0, 0) -- PAKSA MERAH
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.4
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
    
    -- 2. AUTO COMBAT (DAGGER & SHOOT)
    if _G.AutoCombat then
        local char = player.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and GetKiller(obj) and obj:FindFirstChild("HumanoidRootPart") then
                    local dist = (char.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                    if dist < 15 then -- Jarak jangkauan
                        -- Auto Look
                        char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, Vector3.new(obj.HumanoidRootPart.Position.X, char.HumanoidRootPart.Position.Y, obj.HumanoidRootPart.Position.Z))
                        -- Auto Attack
                        tool:Activate()
                    end
                end
            end
        end
    end

    -- 3. AUTO GENERATOR LOGIC
    if _G.AutoGenerator then
        for _, v in pairs(workspace:GetDescendants()) do
            if (v.Name:lower():find("generator") or v.Name:lower():find("engine")) and v:FindFirstChildOfClass("RemoteEvent") then
                v:FindFirstChildOfClass("RemoteEvent"):FireServer("Repair")
                v:FindFirstChildOfClass("RemoteEvent"):FireServer("Fix")
            end
        end
    end
end)
