local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [[ SETTINGS ]] --
_G.ESP_Enabled = false
_G.AutoLook = false

local Window = WindUI:CreateWindow({
    Title = "VILHUB V6 OVERDRIVE",
    Author = "Vilhub",
    Theme = "Indigo",
    Size = UDim2.fromOffset(450, 420)
})

local VisualTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })

-- [[ FUNGSI DETEKSI KILLER PALING AGRESIF ]] --
local function GetKiller(char)
    if not char or not char:FindFirstChild("Humanoid") then return false end
    
    -- 1. Cek Tool di dalam Karakter
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and (tool.Name:lower():find("knife") or tool.Name:lower():find("dagger") or tool.Name:lower():find("hammer")) then
        return true
    end
    
    -- 2. Cek Nama Pemain dari Model
    local p = Players:GetPlayerFromCharacter(char)
    if p then
        if p.TeamColor == BrickColor.new("Really red") or p.Team.Name:lower():find("killer") or p.Name:lower():find("killer") then
            return true
        end
    end
    
    -- 3. Cek Tag Khusus (Beberapa game pakai ini)
    if char:FindFirstChild("Killer") or char:FindFirstChild("IsKiller") then
        return true
    end
    
    return false
end

-- [[ UI TOGGLES ]] --
VisualTab:Toggle({
    Title = "ESP Killer (Highlight Merah)",
    Callback = function(state) _G.ESP_Enabled = state end
})

CombatTab:Toggle({
    Title = "Auto Look at Killer",
    Callback = function(state) _G.AutoLook = state end
})

-- [[ MAIN LOOP ]] --
RunService.RenderStepped:Connect(function()
    -- Pindai SEMUA model di Workspace agar tidak ada yang terlewat
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= player.Character then
            local highlight = obj:FindFirstChild("VilESP")
            
            if _G.ESP_Enabled and GetKiller(obj) then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "VilESP"
                    highlight.Parent = obj
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.FillTransparency = 0.4
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Tembus Tembok
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
    
    -- Auto Look Logic (Lock Target)
    if _G.AutoLook then
        local target = nil
        local dist = math.huge
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and GetKiller(obj) then
                local d = (player.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    target = obj.HumanoidRootPart
                end
            end
        end
        
        if target then
            local root = player.Character.HumanoidRootPart
            root.CFrame = CFrame.lookAt(root.Position, Vector3.new(target.Position.X, root.Position.Y, target.Position.Z))
        end
    end
end)
