--[[
    COMANDOGAME - MOBILE EDITION
    Versão: 20.0.0
    Criador: Mk_gaming
    Fly Player (Hover) + Anti-Reset + Script CentHub Bounty + Ultra Desempenho
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
local Terrain = workspace:FindFirstChildOfClass("Terrain")

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
    UltraPerformance = {
        Enabled = false,
        RemoveTextures = true,
        RemoveShadows = true,
        RemoveParticles = true,
        RemoveEffects = true,
        RemoveDecorations = true,
        RemoveSky = true,
        RemoveTerrain = true,
        RemoveSounds = true,
        RemoveMeshes = true,
        RemoveBillboards = true,
        RemovePostFX = true,
        LowQuality = true,
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

-- Backup para Ultra Desempenho
local PerformanceBackup = {
    Lighting = {},
    RemovedObjects = {},
    OriginalParent = {},
    OriginalProperties = {},
    TerrainBackup = nil,
    IsActive = false,
}

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
-- ULTRA DESEMPENHO (NOVO)
-- ============================================

-- Aplica configurações de Ultra Desempenho
local function ApplyUltraPerformance()
    if PerformanceBackup.IsActive then return end
    
    PerformanceBackup.IsActive = true
    PerformanceBackup.RemovedObjects = {}
    PerformanceBackup.OriginalParent = {}
    PerformanceBackup.OriginalProperties = {}
    
    -- ===== LIGHTING =====
    pcall(function()
        PerformanceBackup.Lighting = {
            GlobalShadows = Lighting.GlobalShadows,
            Brightness = Lighting.Brightness,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            FogColor = Lighting.FogColor,
            ShadowSoftness = Lighting.ShadowSoftness,
            EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
            Technology = Lighting.Technology,
            QualityLevel = Lighting.QualityLevel,
        }
        
        Lighting.GlobalShadows = false
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.fromRGB(180, 180, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(0, 0, 0)
        Lighting.ShadowSoftness = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)
    
    -- ===== REMOVER EFEITOS DE LIGHTING =====
    pcall(function()
        for _, child in pairs(Lighting:GetChildren()) do
            if child:IsA("Atmosphere") or 
               child:IsA("BloomEffect") or 
               child:IsA("BlurEffect") or 
               child:IsA("ColorCorrectionEffect") or 
               child:IsA("SunRaysEffect") or 
               child:IsA("DepthOfFieldEffect") or
               child:IsA("Sky") then
                PerformanceBackup.OriginalParent[child] = child.Parent
                child.Parent = nil
                table.insert(PerformanceBackup.RemovedObjects, child)
            end
        end
    end)
    
    -- ===== REMOVER TEXTURAS DO WORKSPACE =====
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            -- Remover Decals e Texturas
            if Settings.UltraPerformance.RemoveTextures then
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    PerformanceBackup.OriginalProperties[obj] = obj.Transparency
                    obj.Transparency = 1
                end
                if obj:IsA("SurfaceAppearance") then
                    PerformanceBackup.OriginalParent[obj] = obj.Parent
                    obj.Parent = nil
                    table.insert(PerformanceBackup.RemovedObjects, obj)
                end
            end
            
            -- Remover Partículas e Efeitos
            if Settings.UltraPerformance.RemoveParticles then
                if obj:IsA("ParticleEmitter") or 
                   obj:IsA("Trail") or 
                   obj:IsA("Smoke") or 
                   obj:IsA("Fire") or 
                   obj:IsA("Sparkles") or
                   obj:IsA("Explosion") then
                    obj.Enabled = false
                    PerformanceBackup.OriginalProperties[obj] = "Enabled"
                end
            end
            
            -- Remover BillboardGuis
            if Settings.UltraPerformance.RemoveBillboards then
                if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                    -- Não remove o ESP do nosso script
                    if obj.Name ~= "ESP" and obj.Name ~= "ComandoGameESP" then
                        obj.Enabled = false
                    end
                end
            end
            
            -- Remover Decorações
            if Settings.UltraPerformance.RemoveDecorations then
                if obj:IsA("Decoration") then
                    PerformanceBackup.OriginalParent[obj] = obj.Parent
                    obj.Parent = nil
                    table.insert(PerformanceBackup.RemovedObjects, obj)
                end
            end
            
            -- Remover Meshes (reduzir qualidade)
            if Settings.UltraPerformance.RemoveMeshes then
                if obj:IsA("MeshPart") then
                    obj.TextureID = ""
                    obj.RenderFidelity = Enum.RenderFidelity.Performance
                end
                if obj:IsA("SpecialMesh") then
                    obj.TextureId = ""
                end
            end
        end
    end)
    
    -- ===== REMOVER SOM/ÁUDIO =====
    pcall(function()
        if Settings.UltraPerformance.RemoveSounds then
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("Sound") then
                    obj.Volume = 0
                    obj.Playing = false
                end
            end
            -- Desativar som global
            UserInputService.MouseIconEnabled = true
        end
    end)
    
    -- ===== TERRAIN =====
    pcall(function()
        if Settings.UltraPerformance.RemoveTerrain then
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                PerformanceBackup.TerrainBackup = {
                    WaterWaveSize = terrain.WaterWaveSize,
                    WaterWaveSpeed = terrain.WaterWaveSpeed,
                    WaterReflectance = terrain.WaterReflectance,
                    WaterTransparency = terrain.WaterTransparency,
                    Decoration = terrain.Decoration,
                }
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
                terrain.Decoration = false
            end
        end
    end)
    
    -- ===== REDUZIR QUALIDADE GRÁFICA =====
    pcall(function()
        -- Reduzir qualidade de renderização
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    end)
    
    print("✅ Ultra Desempenho ATIVADO!")
end

-- Remove o Ultra Desempenho
local function RemoveUltraPerformance()
    if not PerformanceBackup.IsActive then return end
    
    -- Restaurar Lighting
    pcall(function()
        for prop, value in pairs(PerformanceBackup.Lighting) do
            Lighting[prop] = value
        end
    end)
    
    -- Restaurar objetos removidos
    pcall(function()
        for _, obj in pairs(PerformanceBackup.RemovedObjects) do
            if obj and obj.Parent == nil then
                local originalParent = PerformanceBackup.OriginalParent[obj]
                if originalParent then
                    obj.Parent = originalParent
                end
            end
        end
    end)
    
    -- Restaurar propriedades
    pcall(function()
        for obj, value in pairs(PerformanceBackup.OriginalProperties) do
            if obj and obj.Parent then
                if value == "Enabled" then
                    obj.Enabled = true
                else
                    obj.Transparency = value
                end
            end
        end
    end)
    
    -- Restaurar Terrain
    pcall(function()
        if PerformanceBackup.TerrainBackup then
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                for prop, value in pairs(PerformanceBackup.TerrainBackup) do
                    terrain[prop] = value
                end
            end
        end
    end)
    
    -- Restaurar qualidade gráfica
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Automatic
    end)
    
    PerformanceBackup.IsActive = false
    PerformanceBackup.RemovedObjects = {}
    PerformanceBackup.OriginalParent = {}
    PerformanceBackup.OriginalProperties = {}
    PerformanceBackup.TerrainBackup = nil
    
    print("❌ Ultra Desempenho DESATIVADO!")
end

-- Aplicar quando objetos novos aparecerem
local function MonitorNewObjects()
    if not Settings.UltraPerformance.Enabled then return end
    
    spawn(function()
        while Settings.UltraPerformance.Enabled do
            wait(2)
            
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if Settings.UltraPerformance.RemoveParticles then
                        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                            obj.Enabled = false
                        end
                    end
                    
                    if Settings.UltraPerformance.RemoveTextures then
                        if obj:IsA("Decal") or obj:IsA("Texture") then
                            obj.Transparency = 1
                        end
                    end
                    
                    if Settings.UltraPerformance.RemoveSounds then
                        if obj:IsA("Sound") then
                            obj.Volume = 0
                            obj.Playing = false
                        end
                    end
                end
            end)
        end
    end)
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
    espGui.Name = "ComandoGameESP"
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
    -- ABA: PERFORMANCE (NOVA)
    -- ============================================
    
    local PerformanceTab = Window:CreateTab("⚡ Performance", 4483362458)
    
    PerformanceTab:CreateSection("🚀 Ultra Desempenho")
    
    PerformanceTab:CreateToggle({
        Name = "⚡ Ativar Ultra Desempenho",
        CurrentValue = false,
        Callback = function(v)
            Settings.UltraPerformance.Enabled = v
            if v then
                ApplyUltraPerformance()
                MonitorNewObjects()
                Rayfield:Notify({
                    Title = "Ultra Desempenho",
                    Content = "🚀 ATIVADO! FPS maximizado!",
                    Duration = 3,
                })
            else
                RemoveUltraPerformance()
                Rayfield:Notify({
                    Title = "Ultra Desempenho",
                    Content = "⏹️ DESATIVADO - Gráficos restaurados",
                    Duration = 3,
                })
            end
        end
    })
    
    PerformanceTab:CreateSection("⚙️ O que remover")
    
    PerformanceTab:CreateToggle({
        Name = "Remover Texturas",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.RemoveTextures = v
            if Settings.UltraPerformance.Enabled then
                if v then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Decal") or obj:IsA("Texture") then
                            obj.Transparency = 1
                        end
                    end
                end
            end
        end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Remover Sombras",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.RemoveShadows = v
            if Settings.UltraPerformance.Enabled and v then
                Lighting.GlobalShadows = false
            end
        end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Remover Partículas",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.RemoveParticles = v
            if Settings.UltraPerformance.Enabled then
                if v then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                            obj.Enabled = false
                        end
                    end
                end
            end
        end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Remover Efeitos de Luz",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.RemoveEffects = v
            if Settings.UltraPerformance.Enabled then
                if v then
                    for _, child in pairs(Lighting:GetChildren()) do
                        if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("SunRaysEffect") or child:IsA("DepthOfFieldEffect") then
                            child.Enabled = false
                        end
                    end
                end
            end
        end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Remover Sky/Atmosphere",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.RemoveSky = v
            if Settings.UltraPerformance.Enabled then
                if v then
                    for _, child in pairs(Lighting:GetChildren()) do
                        if child:IsA("Sky") or child:IsA("Atmosphere") then
                            child.Parent = nil
                        end
                    end
                end
            end
        end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Remover Água/Decorações",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.RemoveTerrain = v
            if Settings.UltraPerformance.Enabled then
                if v then
                    local terrain = workspace:FindFirstChildOfClass("Terrain")
                    if terrain then
                        terrain.WaterWaveSize = 0
                        terrain.WaterWaveSpeed = 0
                        terrain.WaterReflectance = 0
                        terrain.WaterTransparency = 1
                        terrain.Decoration = false
                    end
                end
            end
        end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Remover Sons",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.RemoveSounds = v
            if Settings.UltraPerformance.Enabled then
                if v then
                    for _, obj in pairs(game:GetDescendants()) do
                        if obj:IsA("Sound") then
                            obj.Volume = 0
                            obj.Playing = false
                        end
                    end
                end
            end
        end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Reduzir Qualidade de Malhas",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.RemoveMeshes = v
            if Settings.UltraPerformance.Enabled then
                if v then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("MeshPart") then
                            obj.RenderFidelity = Enum.RenderFidelity.Performance
                        end
                    end
                end
            end
        end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Remover BillboardGuis",
        CurrentValue = true,
        Callback = function(v) Settings.UltraPerformance.RemoveBillboards = v end
    })
    
    PerformanceTab:CreateToggle({
        Name = "Reduzir Qualidade Gráfica",
        CurrentValue = true,
        Callback = function(v) 
            Settings.UltraPerformance.LowQuality = v
            if Settings.UltraPerformance.Enabled and v then
                pcall(function()
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end)
            end
        end
    })
    
    PerformanceTab:CreateSection("ℹ️ Informações")
    
    PerformanceTab:CreateLabel("⚡ Ultra Desempenho remove:")
    PerformanceTab:CreateLabel("• Texturas e Decals")
    PerformanceTab:CreateLabel("• Sombras e Iluminação pesada")
    PerformanceTab:CreateLabel("• Partículas e Efeitos")
    PerformanceTab:CreateLabel("• Sky e Atmosphere")
    PerformanceTab:CreateLabel("• Água e Reflexos")
    PerformanceTab:CreateLabel("• Sons do jogo")
    PerformanceTab:CreateLabel("• Qualidade de malhas")
    PerformanceTab:CreateLabel("• E muito mais!")
    PerformanceTab:CreateLabel("")
    PerformanceTab:CreateLabel("💡 Aumenta MUITO o FPS")
    PerformanceTab:CreateLabel("📱 Perfeito para mobile fraco")
    PerformanceTab:CreateLabel("⚠️ Desative para voltar ao normal")

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

    -- ============================================
    -- ABA: SCRIPTS
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
                        Content = "❌ Erro: " .. tostring(err):sub(1, 40),
                        Duration = 5,
                    })
                    warn("❌ Erro CentHub: " .. tostring(err))
                end
            end)
        end
    })
    
    ScriptsTab:CreateLabel("🎯 Script de Bounty Hunt / PvP")
    ScriptsTab:CreateLabel("👤 Criador: JustParadozCode")
    ScriptsTab:CreateLabel("🔗 GitHub: CentuDox-Hub")

    -- ============================================
    -- ABA: SOBRE
    -- ============================================
    
    local AboutTab = Window:CreateTab("ℹ️ Sobre", 4483362458)
    AboutTab:CreateLabel("⚡ ComandoGame Mobile v20.0")
    AboutTab:CreateLabel("👤 Criador: Mk_gaming")
    AboutTab:CreateLabel("")
    AboutTab:CreateLabel("🆕 NOVIDADES:")
    AboutTab:CreateLabel("• Ultra Desempenho (NOVO)")
    AboutTab:CreateLabel("• Aba ⚡ Performance")
    AboutTab:CreateLabel("• Script CentHub Bounty")
    AboutTab:CreateLabel("• Fly Player (Hover)")
    AboutTab:CreateLabel("")
    AboutTab:CreateLabel("⚡ Ultra Desempenho")
    AboutTab:CreateLabel("🎯 Aimlock")
    AboutTab:CreateLabel("👁️ ESP")
    AboutTab:CreateLabel("🦘 Infinite Jump")
    AboutTab:CreateLabel("✈️ Fly Player")
    AboutTab:CreateLabel("🚀 Fly")
    AboutTab:CreateLabel("🛡️ Anti-Stun")
    AboutTab:CreateLabel("📜 CentHub Bounty")
end

-- ============================================
-- INICIAR
-- ============================================

CreateUI()

Rayfield:Notify({
    Title = "ComandoGame Mobile",
    Content = "⚡ v20.0 - Ultra Desempenho adicionado!",
    Duration = 4,
})

print("✅ ComandoGame Mobile v20.0 carregado!")
print("👤 Criador: Mk_gaming")
print("⚡ Ultra Desempenho disponível!")
print("📜 CentHub Bounty disponível!")
