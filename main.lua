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
            Window:Notification({Title = "VILHUB", Content = "Generator tidak ditemukan!", Duration = 2})
        end
    end
})

-- [[ MAIN LOOP ]] --
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        -- LOGIK ESP & COMBAT
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= char then
            local killerDetected = IsKiller(obj)
            
            -- ESP Merah Tembus Tembok
            local hl = obj:FindFirstChild("VilESP")
            if _G.ESP_Enabled and killerDetected then
                if not hl then 
                    hl = Instance.new("Highlight", obj)
                    hl.Name = "VilESP"
                end
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            elseif hl then 
                hl:Destroy() 
            end

            -- Auto Attack (Dagger/Gun)
            if _G.AutoCombat and killerDetected and char:FindFirstChild("HumanoidRootPart") then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local d = (char.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                    if d < 25 then
                        char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, Vector3.new(obj.HumanoidRootPart.Position.X, char.HumanoidRootPart.Position.Y, obj.HumanoidRootPart.Position.Z))
                        tool:Activate()
                    end
                end
            end
        end

        -- LOGIK AUTO REPAIR
        if _G.AutoGenerator then
            if (obj.Name:lower():find("gen") or obj.Name:lower():find("engin")) then
                local remote = obj:FindFirstChildOfClass("RemoteEvent")
                if remote then
                    remote:FireServer("Repair")
                    remote:FireServer("Fix")
                end
                -- Support ProximityPrompt (Tombol E)
                local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end)
