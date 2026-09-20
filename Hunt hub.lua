--[[
    COMANDOGAME - MOBILE EDITION
    Versão: 19.0.0
    Criador: Mk_gaming
    Fly Player (Hover) + Anti-Reset + Script CentHub Bounty
]]

-- ============================================
-- CARREGAR RAYFIELD
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

-- ============================================
-- CONFIGURAÇÕES - TUDO DESATIVADO
-- ============================================

local Settings = {
    Aimbot = {
        Enabled = false,
        MaxDistance = 5000,
        Smoothness = 0.15,
        TeamFilter = false,
        AimPart = "Head",
        LockMode = true,
    },
    FlyPlayer = {
        Enabled = false,
        Height = 10,
        AntiReset = true,
        AntiFall = true,
        MoveSpeed = 50,
    },
    InfiniteJump = {
        Enabled = false,
    },
    AntiStun = {
        Enabled = false,
        AntiRagdoll = false,
    },
    Noclip = {
        Enabled = false,
    },
    Speed = {
        Enabled = false,
        Value = 300,
    },
    Jump = {
        Enabled = false,
        Value = 150,
    },
    Fly = {
        Enabled = false,
        Speed = 150,
    },
    ESP = {
        Enabled = false,
        MaxDistance = 100000,
    },
    NoFog = {
        Enabled = false,
    },
}

-- ============================================
-- VARIÁVEIS
-- ============================================

local ESPObjects = {}
local ESPConnections = {}
local FlyActive = false
local FlyBodyVelocity = nil
local FlyPlayerActive = false
local FlyPlayerBodyVelocity = nil
local FlyPlayerBodyGyro = nil
local FlyPlayerOriginalY = 0
local SpaceHeld = false
local RenderConnection = nil
local OriginalFog = nil
local PlayerTeam = nil
local Window = nil
local CurrentTarget = nil
local JumpHeld = false
local CurrentHeight = 0
local CentHubLoaded = false

-- ============================================
-- DETECÇÃO DE TIME
-- ============================================

local function GetPlayerTeam(player)
    if not player then return "Desconhecido" end
    
    local team = "Desconhecido"
    
    pcall(function()
        if player.Team then
            local teamName = player.Team.Name
            local lowerName = teamName:lower()
            if lowerName:match("marinha") or lowerName:match("marine") or lowerName:match("navy") then
                team = "Marinha"
            elseif lowerName:match("pirata") or lowerName:match("pirate") then
                team = "Pirata"
            end
        end
    end)
    
    if team == "Desconhecido" then
        pcall(function()
            local data = player:FindFirstChild("Data")
            if data then
                local teamValue = data:FindFirstChild("Team")
                if teamValue then
                    local val = tostring(teamValue.Value):lower()
                    if val:match("marinha") or val:match("marine") or val:match("navy") then
                        team = "Marinha"
                    elseif val:match("pirata") or val:match("pirate") then
                        team = "Pirata"
                    end
                end
            end
        end)
    end
    
    if team == "Desconhecido" then
        pcall(function()
            local playerGui = player:FindFirstChild("PlayerGui")
            if playerGui then
                local main = playerGui:FindFirstChild("Main")
                if main then
                    local teamValue = main:FindFirstChild("Team")
                    if teamValue then
                        local val = tostring(teamValue.Value):lower()
                        if val:match("marinha") or val:match("marine") then
                            team = "Marinha"
                        elseif val:match("pirata") or val:match("pirate") then
                            team = "Pirata"
                        end
                    end
                end
            end
        end)
    end
    
    if team == "Desconhecido" then
        pcall(function()
            if player.Team then
                local color = player.Team.Color
                if color == Color3.fromRGB(0, 100, 255) or color == Color3.fromRGB(0, 85, 255) then
                    team = "Marinha"
                elseif color == Color3.fromRGB(255, 50, 50) or color == Color3.fromRGB(200, 0, 0) then
                    team = "Pirata"
                end
            end
        end)
    end
    
    return team
end

local function GetLocalTeam()
    if PlayerTeam and PlayerTeam ~= "Desconhecido" then return PlayerTeam end
    PlayerTeam = GetPlayerTeam(LocalPlayer)
    return PlayerTeam
end

local function IsEnemy(player)
    if not Settings.Aimbot.TeamFilter then return true end
    
    local localTeam = GetLocalTeam()
    local targetTeam = GetPlayerTeam(player)
    
    if localTeam == "Desconhecido" then return true end
    if targetTeam == "Desconhecido" then return false end
    
    if localTeam == "Marinha" then
        return targetTeam == "Pirata"
    end
    
    if localTeam == "Pirata" then
        return targetTeam == "Marinha"
    end
    
    return true
end

-- ============================================
-- FLY PLAYER (HOVER)
-- ============================================

local function StartFlyPlayer()
    if not Settings.FlyPlayer.Enabled then return end
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    FlyPlayerOriginalY = rootPart.Position.Y
    CurrentHeight = FlyPlayerOriginalY + Settings.FlyPlayer.Height
    
    humanoid.PlatformStand = true
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    if FlyPlayerBodyVelocity then
        FlyPlayerBodyVelocity:Destroy()
        FlyPlayerBodyVelocity = nil
    end
    if FlyPlayerBodyGyro then
        FlyPlayerBodyGyro:Destroy()
        FlyPlayerBodyGyro = nil
    end
    
    FlyPlayerBodyVelocity = Instance.new("BodyVelocity")
    FlyPlayerBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyPlayerBodyVelocity.MaxForce = Vector3.new(0, 50000, 0)
    FlyPlayerBodyVelocity.P = 5000
    FlyPlayerBodyVelocity.Parent = rootPart
    
    FlyPlayerBodyGyro = Instance.new("BodyGyro")
    FlyPlayerBodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    FlyPlayerBodyGyro.P = 0
    FlyPlayerBodyGyro.D = 0
    FlyPlayerBodyGyro.Parent = rootPart
    
    FlyPlayerActive = true
    
    Rayfield:Notify({
        Title = "Fly Player",
        Content = "✅ Fly Player ATIVADO!",
        Duration = 2,
    })
end

local function StopFlyPlayer()
    FlyPlayerActive = false
    
    if FlyPlayerBodyVelocity then
        FlyPlayerBodyVelocity:Destroy()
        FlyPlayerBodyVelocity = nil
    end
    if FlyPlayerBodyGyro then
        FlyPlayerBodyGyro:Destroy()
        FlyPlayerBodyGyro = nil
    end
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    Rayfield:Notify({
        Title = "Fly Player",
        Content = "⏹️ Fly Player DESATIVADO",
        Duration = 2,
    })
end

local function UpdateFlyPlayer()
    if not FlyPlayerActive or not Settings.FlyPlayer.Enabled then return end
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    if humanoid.Health <= 0 then
        StopFlyPlayer()
        return
    end
    
    if Settings.FlyPlayer.AntiFall then
        local currentY = rootPart.Position.Y
        local targetY = CurrentHeight
        local diffY = targetY - currentY
        local velY = math.clamp(diffY * 10, -50, 50)
        
        if FlyPlayerBodyVelocity then
            FlyPlayerBodyVelocity.Velocity = Vector3.new(0, velY, 0)
        end
        
        if currentY < CurrentHeight - 5 then
            rootPart.CFrame = CFrame.new(rootPart.Position.X, CurrentHeight, rootPart.Position.Z)
        end
    end
    
    local humanoidMoveDirection = humanoid.MoveDirection
    if humanoidMoveDirection.Magnitude > 0 then
        local moveSpeed = Settings.FlyPlayer.MoveSpeed or 50
        local newPos = rootPart.Position + humanoidMoveDirection * moveSpeed * 0.05
        newPos = Vector3.new(newPos.X, rootPart.Position.Y, newPos.Z)
        rootPart.CFrame = CFrame.new(newPos)
    end
end

-- ============================================
-- AIMLOCK
-- ============================================

local function GetClosestPlayer()
    if not LocalPlayer.Character then return nil end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local closest = nil
    local closestDist = Settings.Aimbot.MaxDistance or 5000
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local targetHumanoid = character:FindFirstChild("Humanoid")
                if targetHumanoid and targetHumanoid.Health > 0 then
                    if not IsEnemy(player) then
                        continue
                    end
                    
                    local targetRoot = character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local dist = (rootPart.Position - targetRoot.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function AimLock()
    if not Settings.Aimbot.Enabled then 
        CurrentTarget = nil
        return 
    end
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    if CurrentTarget then
        local validTarget = false
        pcall(function()
            if CurrentTarget.Character then
                local targetHum = CurrentTarget.Character:FindFirstChild("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    validTarget = true
                end
            end
        end)
        if not validTarget then
            CurrentTarget = nil
        end
    end
    
    if not CurrentTarget then
        CurrentTarget = GetClosestPlayer()
    end
    
    if not CurrentTarget or not CurrentTarget.Character then 
        return 
    end
    
    local targetRoot = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then 
        CurrentTarget = nil
        return 
    end
    
    local aimPart = CurrentTarget.Character:FindFirstChild(Settings.Aimbot.AimPart)
    if not aimPart then
        aimPart = CurrentTarget.Character:FindFirstChild("Head") or targetRoot
    end
    if not aimPart then return end
    if not Camera then return end
    
    local pos = aimPart.Position
    local targetCFrame = CFrame.new(Camera.CFrame.Position, pos)
    
    if Settings.Aimbot.LockMode then
        Camera.CFrame = targetCFrame
    else
        local smoothness = Settings.Aimbot.Smoothness or 0.15
        if smoothness > 0 then
            local currentCFrame = Camera.CFrame
            local lerpAlpha = math.clamp(1 - math.exp(-smoothness * 20 * 0.016), 0, 1)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, lerpAlpha)
        else
            Camera.CFrame = targetCFrame
        end
    end
end

-- ============================================
-- INFINITE JUMP
-- ============================================

local function SetupInfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        if Settings.InfiniteJump.Enabled then
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
end

-- ============================================
-- FLY TRADICIONAL
-- ============================================

local function StartFly()
    if not Settings.Fly.Enabled then return end
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    FlyBodyVelocity.P = 1000
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        FlyBodyVelocity.Parent = rootPart
    end
    
    FlyActive = true
    humanoid.PlatformStand = true
end

local function StopFly()
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    FlyActive = false
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

local function UpdateFly()
    if not FlyActive or not Settings.Fly.Enabled then return end
    if not FlyBodyVelocity then return end
    if not LocalPlayer.Character then return end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    if SpaceHeld or JumpHeld then
        FlyBodyVelocity.Velocity = Vector3.new(0, Settings.Fly.Speed or 150, 0)
    else
        FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

-- ============================================
-- NOCLIP
-- ============================================

local function SetupNoclip()
    if not LocalPlayer.Character then return end
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not Settings.Noclip.Enabled
        end
    end
end

-- ============================================
-- NO FOG
-- ============================================

local function ToggleNoFog()
    if Settings.NoFog.Enabled then
        if OriginalFog == nil then
            OriginalFog = {
                FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart,
                FogColor = Lighting.FogColor,
                GlobalShadows = Lighting.GlobalShadows,
                Ambient = Lighting.Ambient,
                Brightness = Lighting.Brightness,
                TimeOfDay = Lighting.TimeOfDay,
                ClockTime = Lighting.ClockTime,
            }
        end
        pcall(function()
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.FogColor = Color3.fromRGB(0, 0, 0)
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.TimeOfDay = 12
            Lighting.ClockTime = 12
        end)
    else
        if OriginalFog then
            pcall(function()
                Lighting.FogEnd = OriginalFog.FogEnd
                Lighting.FogStart = OriginalFog.FogStart
                Lighting.FogColor = OriginalFog.FogColor
                Lighting.GlobalShadows = OriginalFog.GlobalShadows
                Lighting.Ambient = OriginalFog.Ambient
                Lighting.Brightness = OriginalFog.Brightness
                Lighting.TimeOfDay = OriginalFog.TimeOfDay
                Lighting.ClockTime = OriginalFog.ClockTime
            end)
        end
    end
end

-- ============================================
-- ANTI-STUN
-- ============================================

local function AntiStunSystem()
    if not Settings.AntiStun.Enabled then return end
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if Settings.AntiStun.AntiRagdoll then
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            humanoid.PlatformStand = false
        end
        for _, child in pairs(LocalPlayer.Character:GetChildren()) do
            if child:IsA("Motor6D") and (child.Name:match("Ragdoll") or child.Name:match("Joint")) then
                child:Destroy()
            end
        end
        if humanoid:GetState() == Enum.HumanoidStateType.Physics then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    
    local state = humanoid:GetState()
    if state == Enum.HumanoidStateType.Stunned then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- ============================================
-- SPEED + JUMP
-- ============================================

local function ApplySpeedAndJump()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if Settings.Speed.Enabled then
        humanoid.WalkSpeed = Settings.Speed.Value
    else
        humanoid.WalkSpeed = 16
    end
    
    if Settings.Jump.Enabled then
        humanoid.JumpPower = Settings.Jump.Value
    else
        humanoid.JumpPower = 50
    end
end

-- ============================================
-- ESP
-- ============================================

local function GetPlayerLevel(player)
    local level = 0
    pcall(function()
        local data = player:FindFirstChild("Data")
        if data then
            local levelValue = data:FindFirstChild("Level")
            if levelValue then
                level = levelValue.Value or 0
            end
        end
    end)
    return level
end

local function GetPlayerMaxHealth(player)
    local maxHealth = 100
    pcall(function()
        local data = player:FindFirstChild("Data")
        if data then
            local healthValue = data:FindFirstChild("MaxHealth")
            if healthValue then
                maxHealth = healthValue.Value or 100
            end
        end
    end)
    return maxHealth
end

local function GetTeamColor(player)
    local team = GetPlayerTeam(player)
    if team == "Marinha" then
        return Color3.fromRGB(0, 100, 255)
    elseif team == "Pirata" then
        return Color3.fromRGB(255, 50, 50)
    else
        return Color3.fromRGB(150, 150, 150)
    end
end

local function GetTeamEmoji(player)
    local team = GetPlayerTeam(player)
    if team == "Marinha" then
        return "⚓"
    elseif team == "Pirata" then
        return "🏴‍☠️"
    else
        return "❓"
    end
end

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end
    if not player then return end
    
    if not player.Character then
        player.CharacterAdded:Wait()
        wait(0.5)
        if not player.Character then return end
    end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        character:WaitForChild("Humanoid")
        wait(0.3)
        humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
    end
    
    for _, data in pairs(ESPObjects) do
        if data.Player == player then
            return
        end
    end
    
    local espGui = Instance.new("BillboardGui")
    espGui.Size = UDim2.new(0, 250, 0, 100)
    espGui.AlwaysOnTop = true
    espGui.StudsOffset = Vector3.new(0, 3, 0)
    espGui.MaxDistance = Settings.ESP.MaxDistance or 100000
    espGui.Enabled = true
    espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local head = character:FindFirstChild("Head")
    if head then
        espGui.Parent = head
    else
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            espGui.Parent = rootPart
        else
            espGui.Parent = character
        end
    end
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 0.6
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = GetTeamColor(player)
    mainFrame.Parent = espGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = mainFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = GetTeamEmoji(player) .. " " .. player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = mainFrame
    
    local teamLabel = Instance.new("TextLabel")
    teamLabel.Size = UDim2.new(1, 0, 0, 16)
    teamLabel.Position = UDim2.new(0, 0, 0, 23)
    teamLabel.BackgroundTransparency = 1
    teamLabel.Text = GetPlayerTeam(player)
    teamLabel.TextColor3 = GetTeamColor(player)
    teamLabel.TextSize = 11
    teamLabel.Font = Enum.Font.GothamBold
    teamLabel.TextStrokeTransparency = 0.3
    teamLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    teamLabel.Parent = mainFrame
    
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Size = UDim2.new(1, 0, 0, 16)
    levelLabel.Position = UDim2.new(0, 0, 0, 40)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "🏆 " .. GetPlayerLevel(player)
    levelLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    levelLabel.TextSize = 11
    levelLabel.Font = Enum.Font.GothamBold
    levelLabel.TextStrokeTransparency = 0.3
    levelLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    levelLabel.Parent = mainFrame
    
    local hpLabel = Instance.new("TextLabel")
    hpLabel.Size = UDim2.new(1, 0, 0, 16)
    hpLabel.Position = UDim2.new(0, 0, 0, 57)
    hpLabel.BackgroundTransparency = 1
    local maxHealth = GetPlayerMaxHealth(player) or humanoid.MaxHealth or 100
    hpLabel.Text = "❤️ " .. math.floor(humanoid.Health) .. "/" .. math.floor(maxHealth)
    hpLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    hpLabel.TextSize = 11
    hpLabel.Font = Enum.Font.GothamBold
    hpLabel.TextStrokeTransparency = 0.3
    hpLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpLabel.Parent = mainFrame
    
    local hpBarBg = Instance.new("Frame")
    hpBarBg.Size = UDim2.new(0.9, 0, 0, 4)
    hpBarBg.Position = UDim2.new(0.05, 0, 0, 76)
    hpBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    hpBarBg.BorderSizePixel = 0
    hpBarBg.Parent = mainFrame
    local hpBarBgCorner = Instance.new("UICorner")
    hpBarBgCorner.CornerRadius = UDim.new(0, 2)
    hpBarBgCorner.Parent = hpBarBg
    
    local hpBar = Instance.new("Frame")
    hpBar.Size = UDim2.new(1, 0, 1, 0)
    hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    hpBar.BorderSizePixel = 0
    hpBar.Parent = hpBarBg
    local hpBarCorner = Instance.new("UICorner")
    hpBarCorner.CornerRadius = UDim.new(0, 2)
    hpBarCorner.Parent = hpBar
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 14)
    distLabel.Position = UDim2.new(0, 0, 0, 83)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "📏 0m"
    distLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    distLabel.TextSize = 9
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextStrokeTransparency = 0.3
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Parent = mainFrame
    
    local espData = {
        Player = player,
        ESP = espGui,
        MainFrame = mainFrame,
        NameLabel = nameLabel,
        TeamLabel = teamLabel,
        LevelLabel = levelLabel,
        HPLabel = hpLabel,
        HPBar = hpBar,
        DistLabel = distLabel,
        Humanoid = humanoid,
        Character = character,
        MaxHealth = maxHealth,
        Team = GetPlayerTeam(player),
        TeamColor = GetTeamColor(player),
        Active = true
    }
    
    table.insert(ESPObjects, espData)
    
    local connections = {}
    
    local healthConnection = humanoid.HealthChanged:Connect(function(health)
        for _, data in pairs(ESPObjects) do
            if data.Player == player and data.Active then
                local maxHp = GetPlayerMaxHealth(player) or humanoid.MaxHealth or 100
                data.MaxHealth = maxHp
                if data.HPLabel then
                    data.HPLabel.Text = "❤️ " .. math.floor(health) .. "/" .. math.floor(maxHp)
                    local hpPercent = health / maxHp
                    if hpPercent > 0.5 then
                        data.HPLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif hpPercent > 0.25 then
                        data.HPLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        data.HPLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
                if data.HPBar then
                    local hpPercent = math.clamp(health / maxHp, 0, 1)
                    data.HPBar.Size = UDim2.new(hpPercent, 0, 1, 0)
                    if hpPercent > 0.5 then
                        data.HPBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    elseif hpPercent > 0.25 then
                        data.HPBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        data.HPBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
                break
            end
        end
    end)
    table.insert(connections, healthConnection)
    
    local deathConnection = humanoid.Died:Connect(function()
        pcall(function() 
            if espGui and espGui.Parent then
                espGui:Destroy()
            end
        end)
        for i, data in pairs(ESPObjects) do
            if data.Player == player then
                data.Active = false
                table.remove(ESPObjects, i)
                break
            end
        end
        deathConnection:Disconnect()
        healthConnection:Disconnect()
    end)
    table.insert(connections, deathConnection)
    
    local characterConnection = player.CharacterAdded:Connect(function(newCharacter)
        pcall(function() 
            if espGui and espGui.Parent then
                espGui:Destroy()
            end
        end)
        for i, data in pairs(ESPObjects) do
            if data.Player == player then
                data.Active = false
                table.remove(ESPObjects, i)
                break
            end
        end
        if Settings.ESP.Enabled then
            wait(0.5)
            CreateESPForPlayer(player)
        end
    end)
    table.insert(connections, characterConnection)
    
    ESPConnections[player] = connections
end

local function ClearESPForPlayer(player)
    for i, data in pairs(ESPObjects) do
        if data.Player == player then
            pcall(function() 
                if data.ESP and data.ESP.Parent then
                    data.ESP:Destroy()
                end
            end)
            data.Active = false
            table.remove(ESPObjects, i)
            break
        end
    end
    if ESPConnections[player] then
        for _, conn in pairs(ESPConnections[player]) do
            pcall(function() conn:Disconnect() end)
        end
        ESPConnections[player] = nil
    end
end

local function CreateESPForAllPlayers()
    for _, data in pairs(ESPObjects) do
        pcall(function() 
            if data.ESP and data.ESP.Parent then
                data.ESP:Destroy()
            end
        end)
    end
    ESPObjects = {}
    for _, conns in pairs(ESPConnections) do
        for _, conn in pairs(conns) do
            pcall(function() conn:Disconnect() end)
        end
    end
    ESPConnections = {}
    if not Settings.ESP.Enabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESPForPlayer(player)
        end
    end
end

local function UpdateESP()
    for _, data in pairs(ESPObjects) do
        if data.Player and data.Player.Character and data.Active then
            local humanoid = data.Player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if data.LevelLabel then
                    data.LevelLabel.Text = "🏆 " .. GetPlayerLevel(data.Player)
                end
                if data.DistLabel and LocalPlayer.Character then
                    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetRoot = data.Player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart and targetRoot then
                        data.DistLabel.Text = "📏 " .. math.floor((rootPart.Position - targetRoot.Position).Magnitude) .. "m"
                    end
                end
                if data.TeamLabel then
                    local newTeam = GetPlayerTeam(data.Player)
                    if newTeam ~= data.Team then
                        data.Team = newTeam
                        data.TeamColor = GetTeamColor(data.Player)
                        data.TeamLabel.Text = newTeam
                        data.TeamLabel.TextColor3 = data.TeamColor
                        if data.NameLabel then
                            data.NameLabel.Text = GetTeamEmoji(data.Player) .. " " .. data.Player.Name
                        end
                        if data.MainFrame then
                            data.MainFrame.BorderColor3 = data.TeamColor
                        end
                    end
                end
            end
        end
    end
end

local function MonitorNewPlayers()
    while Settings.ESP.Enabled do
        wait(1)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local hasESP = false
                for _, data in pairs(ESPObjects) do
                    if data.Player == player and data.Active then
                        hasESP = true
                        break
                    end
                end
                if not hasESP then
                    CreateESPForPlayer(player)
                end
            end
        end
    end
end

-- ============================================
-- EVENTOS
-- ============================================

Players.PlayerAdded:Connect(function(player)
    if Settings.ESP.Enabled and player ~= LocalPlayer then
        wait(0.5)
        CreateESPForPlayer(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    ClearESPForPlayer(player)
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.5)
    ApplySpeedAndJump()
    if Settings.Noclip.Enabled then SetupNoclip() end
    if Settings.Fly.Enabled and FlyActive then
        StopFly()
        wait(0.1)
        StartFly()
    end
    if Settings.FlyPlayer.Enabled and FlyPlayerActive then
        StopFlyPlayer()
        wait(0.3)
        StartFlyPlayer()
    end
    if Settings.ESP.Enabled then
        wait(0.3)
        CreateESPForAllPlayers()
    end
    if Settings.NoFog.Enabled then
        ToggleNoFog()
    end
    PlayerTeam = nil
    CurrentTarget = nil
end)

-- ============================================
-- INPUTS
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        SpaceHeld = true
        if Settings.Fly.Enabled and not FlyActive then
            StartFly()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        SpaceHeld = false
        if FlyActive and not JumpHeld then
            StopFly()
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump.Enabled then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
    
    if Settings.Fly.Enabled then
        if not FlyActive then
            StartFly()
        end
        JumpHeld = true
        spawn(function()
            wait(0.2)
            JumpHeld = false
            if FlyActive and not SpaceHeld then
                StopFly()
            end
        end)
    end
end)

-- ============================================
-- LOOPS
-- ============================================

spawn(function()
    while wait(0.03) do
        UpdateFly()
    end
end)

spawn(function()
    while wait(0.03) do
        if Settings.FlyPlayer.Enabled and FlyPlayerActive then
            UpdateFlyPlayer()
        end
    end
end)

spawn(function()
    while true do
        wait(0.1)
        if LocalPlayer.Character then
            ApplySpeedAndJump()
        end
    end
end)

spawn(function()
    while wait(0.15) do
        if Settings.ESP.Enabled then
            UpdateESP()
        end
    end
end)

spawn(function()
    while wait(2) do
        if Settings.ESP.Enabled then
            MonitorNewPlayers()
        end
    end
end)

spawn(function()
    while wait(5) do
        PlayerTeam = nil
        GetLocalTeam()
    end
end)

-- ============================================
-- LOOP PRINCIPAL
-- ============================================

local function OnRenderStep()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    AntiStunSystem()
    SetupNoclip()
    ApplySpeedAndJump()
    
    if Settings.Aimbot.Enabled then
        AimLock()
    end
end

RenderConnection = RunService.RenderStepped:Connect(OnRenderStep)

SetupInfiniteJump()

-- ============================================
-- INTERFACE RAYFIELD
-- ============================================

local function CreateUI()
    Window = Rayfield:CreateWindow({
        Name = "⚡ ComandoGame Mobile",
        LoadingTitle = "ComandoGame",
        LoadingSubtitle = "by Mk_gaming",
        Theme = "Dark",
        ConfigurationSaving = {
            Enabled = false,
        },
    })

    -- ============================================
    -- ABA: PLAYER
    -- ============================================
    
    local PlayerTab = Window:CreateTab("🎯 Player", 4483362458)
    
    PlayerTab:CreateSection("Aimlock")
    PlayerTab:CreateToggle({
        Name = "Aimlock",
        CurrentValue = false,
        Callback = function(v) 
            Settings.Aimbot.Enabled = v 
            if not v then CurrentTarget = nil end
        end
    })
    PlayerTab:CreateToggle({
        Name = "Travar no Alvo (Lock)",
        CurrentValue = true,
        Callback = function(v) Settings.Aimbot.LockMode = v end
    })
    PlayerTab:CreateToggle({
        Name = "Filtro de Time",
        CurrentValue = false,
        Callback = function(v) Settings.Aimbot.TeamFilter = v end
    })
    PlayerTab:CreateDropdown({
        Name = "Parte do Corpo",
        Options = {"Head", "HumanoidRootPart", "UpperTorso"},
        CurrentOption = "Head",
        Callback = function(Option) Settings.Aimbot.AimPart = Option end
    })
    PlayerTab:CreateSlider({
        Name = "Distância",
        Range = {500, 10000},
        Increment = 500,
        Suffix = "studs",
        CurrentValue = 5000,
        Callback = function(v) Settings.Aimbot.MaxDistance = v end
    })
    PlayerTab:CreateSlider({
        Name = "Suavidade (só sem Lock)",
        Range = {0, 100},
        Increment = 5,
        Suffix = "%",
        CurrentValue = 15,
        Callback = function(v) Settings.Aimbot.Smoothness = v / 100 end
    })
    
    PlayerTab:CreateSection("ESP")
    PlayerTab:CreateToggle({
        Name = "ESP Box 2D",
        CurrentValue = false,
        Callback = function(v)
            Settings.ESP.Enabled = v
            if v then
                CreateESPForAllPlayers()
            else
                for _, data in pairs(ESPObjects) do
                    pcall(function() if data.ESP and data.ESP.Parent then data.ESP:Destroy() end end)
                end
                ESPObjects = {}
                for _, conns in pairs(ESPConnections) do
                    for _, conn in pairs(conns) do
                        pcall(function() conn:Disconnect() end)
                    end
                end
                ESPConnections = {}
            end
        end
    })
    PlayerTab:CreateSlider({
        Name = "Distância ESP",
        Range = {1000, 100000},
        Increment = 1000,
        Suffix = "studs",
        CurrentValue = 100000,
        Callback = function(v)
            Settings.ESP.MaxDistance = v
            for _, data in pairs(ESPObjects) do
                if data.ESP then data.ESP.MaxDistance = v end
            end
        end
    })
    
    PlayerTab:CreateSection("Noclip")
    PlayerTab:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Callback = function(v) Settings.Noclip.Enabled = v SetupNoclip() end
    })
    
    PlayerTab:CreateSection("Anti-Stun")
    PlayerTab:CreateToggle({
        Name = "Anti-Stun",
        CurrentValue = false,
        Callback = function(v) Settings.AntiStun.Enabled = v end
    })
    PlayerTab:CreateToggle({
        Name = "Anti-Ragdoll",
        CurrentValue = false,
        Callback = function(v) Settings.AntiStun.AntiRagdoll = v end
    })
    
    PlayerTab:CreateSection("Visual")
    PlayerTab:CreateToggle({
        Name = "No Fog",
        CurrentValue = false,
        Callback = function(v) Settings.NoFog.Enabled = v ToggleNoFog() end
    })

    -- ============================================
    -- ABA: MOVIMENTO
    -- ============================================
    
    local MoveTab = Window:CreateTab("🏃 Movimento", 4483362458)
    
    MoveTab:CreateSection("Speed")
    MoveTab:CreateToggle({
        Name = "Speed",
        CurrentValue = false,
        Callback = function(v) Settings.Speed.Enabled = v ApplySpeedAndJump() end
    })
    MoveTab:CreateSlider({
        Name = "Velocidade",
        Range = {16, 500},
        Increment = 10,
        Suffix = "WalkSpeed",
        CurrentValue = 300,
        Callback = function(v) Settings.Speed.Value = v ApplySpeedAndJump() end
    })
    
    MoveTab:CreateSection("Jump")
    MoveTab:CreateToggle({
        Name = "Jump",
        CurrentValue = false,
        Callback = function(v) Settings.Jump.Enabled = v ApplySpeedAndJump() end
    })
    MoveTab:CreateSlider({
        Name = "Altura",
        Range = {50, 300},
        Increment = 10,
        Suffix = "JumpPower",
        CurrentValue = 150,
        Callback = function(v) Settings.Jump.Value = v ApplySpeedAndJump() end
    })
    MoveTab:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Callback = function(v) Settings.InfiniteJump.Enabled = v end
    })
    
    MoveTab:CreateSection("✈️ Fly Player (Hover)")
    
    MoveTab:CreateToggle({
        Name = "Fly Player (Hover)",
        CurrentValue = false,
        Callback = function(v)
            Settings.FlyPlayer.Enabled = v
            if v then
                StartFlyPlayer()
            else
                StopFlyPlayer()
            end
        end
    })
    
    MoveTab:CreateToggle({
        Name = "Anti-Reset Fly",
        CurrentValue = true,
        Callback = function(v) Settings.FlyPlayer.AntiReset = v end
    })
    
    MoveTab:CreateToggle({
        Name = "Anti-Fall (Não Cai)",
        CurrentValue = true,
        Callback = function(v) Settings.FlyPlayer.AntiFall = v end
    })
    
    MoveTab:CreateSlider({
        Name = "Altura no Ar",
        Range = {5, 100},
        Increment = 5,
        Suffix = "studs",
        CurrentValue = 10,
        Callback = function(v) 
            Settings.FlyPlayer.Height = v
            if FlyPlayerActive and LocalPlayer.Character then
                local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    CurrentHeight = rootPart.Position.Y + v
                end
            end
        end
    })
    
    MoveTab:CreateSlider({
        Name = "Velocidade de Movimento",
        Range = {10, 150},
        Increment = 5,
        Suffix = "studs/s",
        CurrentValue = 50,
        Callback = function(v) Settings.FlyPlayer.MoveSpeed = v end
    })
    
    MoveTab:CreateLabel("💡 Fica parado no ar e você se move normalmente")
    MoveTab:CreateLabel("📱 Funciona no mobile (arraste o direcional)")
    
    MoveTab:CreateSection("🚀 Fly Tradicional")
    
    MoveTab:CreateToggle({
        Name = "Fly (ESPAÇO/JUMP)",
        CurrentValue = false,
        Callback = function(v)
            Settings.Fly.Enabled = v
            if not v and FlyActive then StopFly() end
        end
    })
    MoveTab:CreateSlider({
        Name = "Velocidade do Fly",
        Range = {50, 300},
        Increment = 10,
        Suffix = "studs/s",
        CurrentValue = 150,
        Callback = function(v) Settings.Fly.Speed = v end
    })
    
    MoveTab:CreateLabel("💡 PC: Segure ESPAÇO")
    MoveTab:CreateLabel("📱 Mobile: Segure BOTÃO JUMP")

    -- ============================================
    -- ABA: SCRIPTS (NOVA)
    -- ============================================
    
    local ScriptsTab = Window:CreateTab("📜 Scripts", 4483362458)
    
    ScriptsTab:CreateSection("🎯 CentHub Bounty")
    
    ScriptsTab:CreateButton({
        Name = "⚔️ Carregar CentHub Bounty",
        Callback = function()
            if CentHubLoaded then
                Rayfield:Notify({
                    Title = "CentHub",
                    Content = "⚠️ CentHub já foi carregado!",
                    Duration = 3,
                })
                return
            end
            
            Rayfield:Notify({
                Title = "CentHub Bounty",
                Content = "⏳ Carregando script...",
                Duration = 3,
            })
            
            spawn(function()
                local success, err = pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/JustParadozCode/CentuDox-Hub/refs/heads/main/CentuDox-Pvp.xyz"))()
                end)
                
                if success then
                    CentHubLoaded = true
                    Rayfield:Notify({
                        Title = "CentHub Bounty",
                        Content = "✅ Script carregado com sucesso!",
                        Duration = 4,
                    })
                    print("✅ CentHub Bounty carregado!")
                else
                    Rayfield:Notify({
                        Title = "CentHub Bounty",
                        Content = "❌ Erro ao carregar: " .. tostring(err):sub(1, 40),
                        Duration = 5,
                    })
                    warn("❌ Erro CentHub: " .. tostring(err))
                end
            end)
        end
    })
    
    ScriptsTab:CreateLabel("🎯 Script de Bounty Hunt / PvP")
    ScriptsTab:CreateLabel("💡 Clique no botão para carregar")
    ScriptsTab:CreateLabel("⚠️ Pode demorar alguns segundos")
    
    ScriptsTab:CreateSection("ℹ️ Informações")
    
    ScriptsTab:CreateLabel("📌 Script: CentHub Bounty")
    ScriptsTab:CreateLabel("👤 Criador: JustParadozCode")
    ScriptsTab:CreateLabel("🔗 GitHub: CentuDox-Hub")
    ScriptsTab:CreateLabel("")
    ScriptsTab:CreateLabel("💡 Dica: Ative depois de carregar")
    ScriptsTab:CreateLabel("   para não conflitar com este menu")

    -- ============================================
    -- ABA: SOBRE
    -- ============================================
    
    local AboutTab = Window:CreateTab("ℹ️ Sobre", 4483362458)
    AboutTab:CreateLabel("⚡ ComandoGame Mobile v19.0")
    AboutTab:CreateLabel("👤 Criador: Mk_gaming")
    AboutTab:CreateLabel("")
    AboutTab:CreateLabel("🆕 NOVIDADES:")
    AboutTab:CreateLabel("• Script CentHub Bounty")
    AboutTab:CreateLabel("• Aba 📜 Scripts")
    AboutTab:CreateLabel("")
    AboutTab:CreateLabel("🎯 Aimlock - Trava no alvo")
    AboutTab:CreateLabel("👁️ ESP - Nome, Nível, HP")
    AboutTab:CreateLabel("🦘 Infinite Jump")
    AboutTab:CreateLabel("🏃 Speed/Jump")
    AboutTab:CreateLabel("✈️ Fly Player (Hover)")
    AboutTab:CreateLabel("🚀 Fly Tradicional")
    AboutTab:CreateLabel("🛡️ Anti-Stun")
    AboutTab:CreateLabel("🌫️ No Fog")
    AboutTab:CreateLabel("📜 CentHub Bounty")
end

-- ============================================
-- INICIAR
-- ============================================

CreateUI()

Rayfield:Notify({
    Title = "ComandoGame Mobile",
    Content = "⚡ v19.0 - CentHub Bounty adicionado!",
    Duration = 4,
})

print("✅ ComandoGame Mobile v19.0 carregado!")
print("👤 Criador: Mk_gaming")
print("📜 Aba Scripts adicionada!")
print("🎯 CentHub Bounty disponível")
