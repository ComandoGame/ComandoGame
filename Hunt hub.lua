--[[
    COMANDOGAME - MOBILE EDITION
    Versão: 29.0.0
    Criador: Mk_gaming
    FLY LIVRE - WASD + Câmera (PC) / Direcional (Mobile)
    SEM Espaço e SEM Shift
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

-- ============================================
-- CONFIGURAÇÕES
-- ============================================

local Settings = {
    Aimbot = { Enabled = false, MaxDistance = 5000, Smoothness = 0.15, TeamFilter = false, AimPart = "Head", LockMode = true },
    FlyPlayer = { Enabled = false, Height = 10, AntiReset = true, AntiFall = true, MoveSpeed = 50 },
    InfiniteJump = { Enabled = false },
    AntiStun = { Enabled = false, AntiRagdoll = false },
    Noclip = { Enabled = false },
    Speed = { Enabled = false, Value = 300 },
    Jump = { Enabled = false, Value = 150 },
    -- FLY LIVRE (SEM ESPAÇO/SHIFT)
    Fly = {
        Enabled = false,
        Speed = 150,           -- Velocidade geral
        AntiReset = true,
        AutoRestart = true,
        AutoNoclip = true,
    },
    ESP = { Enabled = false, MaxDistance = 100000 },
    NoFog = { Enabled = false },
    UltraPerformance = {
        Enabled = false,
        RemoveTextures = true, RemoveShadows = true, RemoveParticles = true,
        RemoveDecorations = true, RemoveSky = true, RemoveTerrain = true,
        RemoveSounds = true, RemoveMeshes = true, RemoveBillboards = false,
        LowQuality = true,
        KeepColorCorrection = true, KeepBloom = true, KeepBlur = true, KeepDamageEffects = true,
    },
    MemoryOptimizer = {
        Enabled = false,
        SmoothGC = true, AdaptiveInterval = true,
        MinInterval = 15, MaxInterval = 60,
        MaxMemoryMB = 1800, CriticalMemoryMB = 2200,
        CleanDistantMeshes = true, CleanInvisibleParts = true,
        CleanOldParticles = true, CleanUnusedSounds = true,
        LastClean = 0, TotalCleans = 0, MemorySaved = 0, CurrentMemory = 0,
    },
    NetworkOptimizer = {
        Enabled = false,
        Interval = 2,
        OptimizePing = true, ReduceLatency = true,
        ClearNetworkCache = true,
        LastOptimize = 0, TotalOptimizations = 0,
        PingHistory = {}, AvgPing = 0, MinPing = 9999, MaxPing = 0, LastPing = 0,
        BoostBandwidth = true, ReducePacketLoss = true,
        JitterCompensation = true, LowLatencyMode = true,
    },
}

-- ============================================
-- VARIÁVEIS
-- ============================================

local ESPObjects = {}
local ESPConnections = {}
local FlyActive = false
local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local FlyLoopRunning = false
local FlyPlayerActive = false
local FlyPlayerBodyVelocity = nil
local FlyPlayerBodyGyro = nil
local FlyPlayerOriginalY = 0
local RenderConnection = nil
local OriginalFog = nil
local PlayerTeam = nil
local Window = nil
local CurrentTarget = nil
local CurrentHeight = 0
local CentHubLoaded = false
local FlyOriginalNoclip = false

local FPSMonitor = { Frames = 0, LastUpdate = tick(), CurrentFPS = 60 }
local MemoryStats = { LastMemory = 0, CleanCount = 0, TotalSaved = 0 }

local PerformanceBackup = {
    Lighting = {}, RemovedObjects = {}, OriginalParent = {},
    OriginalProperties = {}, TerrainBackup = nil, IsActive = false,
    KeptEffects = {},
}

-- ============================================
-- FUNÇÕES ÚTEIS
-- ============================================

local function GetPing()
    local ping = 0
    pcall(function()
        ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ping == 0 then
        pcall(function()
            ping = LocalPlayer:GetNetworkPing() * 1000
        end)
    end
    return math.floor(ping or 0)
end

local function GetMemoryMB()
    local mem = 0
    pcall(function()
        mem = math.floor(collectgarbage("count") / 1024)
    end)
    return mem
end

-- ============================================
-- MEMORY OPTIMIZER PRO
-- ============================================

local function SmoothGarbageCollect()
    spawn(function()
        pcall(function()
            collectgarbage("collect")
            task.wait()
            collectgarbage("collect")
            task.wait()
            collectgarbage("collect")
        end)
    end)
end

local function SmartClean()
    local memBefore = GetMemoryMB()
    
    if Settings.MemoryOptimizer.CleanDistantMeshes then
        local localRoot = nil
        pcall(function()
            if LocalPlayer.Character then
                localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            end
        end)
        if localRoot then
            spawn(function()
                pcall(function()
                    local count = 0
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("MeshPart") then
                            local dist = (obj.Position - localRoot.Position).Magnitude
                            if dist > 500 and obj.TextureID ~= "" then obj.TextureID = "" end
                        end
                        count = count + 1
                        if count % 20 == 0 then task.wait() end
                    end
                end)
            end)
        end
    end
    
    if Settings.MemoryOptimizer.CleanInvisibleParts then
        spawn(function()
            pcall(function()
                local count = 0
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Transparency >= 1 and obj.CanCollide then
                        obj.CanCollide = false
                    end
                    count = count + 1
                    if count % 30 == 0 then task.wait() end
                end
            end)
        end)
    end
    
    if Settings.MemoryOptimizer.CleanOldParticles then
        spawn(function()
            pcall(function()
                local count = 0
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj:IsA("ParticleEmitter") or obj:IsA("Trail")) and not obj.Enabled then
                        obj:Clear()
                    end
                    count = count + 1
                    if count % 30 == 0 then task.wait() end
                end
            end)
        end)
    end
    
    if Settings.MemoryOptimizer.SmoothGC then
        SmoothGarbageCollect()
    end
    
    task.wait(0.5)
    local memAfter = GetMemoryMB()
    local saved = math.max(0, memBefore - memAfter)
    if saved > 0 then
        Settings.MemoryOptimizer.MemorySaved = Settings.MemoryOptimizer.MemorySaved + saved
    end
    Settings.MemoryOptimizer.TotalCleans = Settings.MemoryOptimizer.TotalCleans + 1
end

local function CheckMemory()
    if not Settings.MemoryOptimizer.Enabled then return end
    local currentMem = GetMemoryMB()
    Settings.MemoryOptimizer.CurrentMemory = currentMem
    
    local interval = Settings.MemoryOptimizer.MinInterval
    if Settings.MemoryOptimizer.AdaptiveInterval then
        if FPSMonitor.CurrentFPS > 45 then interval = Settings.MemoryOptimizer.MaxInterval
        elseif FPSMonitor.CurrentFPS > 30 then interval = 30
        else interval = Settings.MemoryOptimizer.MinInterval end
    end
    
    local now = tick()
    local sinceLast = now - Settings.MemoryOptimizer.LastClean
    local memoryHigh = currentMem > Settings.MemoryOptimizer.MaxMemoryMB
    local memoryCritical = currentMem > Settings.MemoryOptimizer.CriticalMemoryMB
    
    if memoryCritical or (memoryHigh and sinceLast > 10) or (sinceLast > interval) then
        Settings.MemoryOptimizer.LastClean = now
        SmartClean()
    end
end

local function StartMemoryOptimizer()
    spawn(function()
        while Settings.MemoryOptimizer.Enabled do
            wait(2)
            pcall(CheckMemory)
        end
    end)
end

-- ============================================
-- FPS MONITOR
-- ============================================

spawn(function()
    while true do
        wait(1)
        local now = tick()
        local elapsed = now - FPSMonitor.LastUpdate
        if elapsed > 0 then
            FPSMonitor.CurrentFPS = math.floor(FPSMonitor.Frames / elapsed)
        end
        FPSMonitor.Frames = 0
        FPSMonitor.LastUpdate = now
    end
end)

RunService.RenderStepped:Connect(function()
    FPSMonitor.Frames = FPSMonitor.Frames + 1
end)

-- ============================================
-- OTIMIZADOR DE INTERNET
-- ============================================

local function OptimizeNetwork()
    if not Settings.NetworkOptimizer.Enabled then return end
    local now = tick()
    if now - Settings.NetworkOptimizer.LastOptimize < Settings.NetworkOptimizer.Interval then return end
    Settings.NetworkOptimizer.LastOptimize = now
    
    local currentPing = GetPing()
    Settings.NetworkOptimizer.LastPing = currentPing
    
    table.insert(Settings.NetworkOptimizer.PingHistory, currentPing)
    if #Settings.NetworkOptimizer.PingHistory > 10 then
        table.remove(Settings.NetworkOptimizer.PingHistory, 1)
    end
    
    local total = 0
    for _, p in pairs(Settings.NetworkOptimizer.PingHistory) do total = total + p end
    Settings.NetworkOptimizer.AvgPing = math.floor(total / #Settings.NetworkOptimizer.PingHistory)
    
    if currentPing < Settings.NetworkOptimizer.MinPing then Settings.NetworkOptimizer.MinPing = currentPing end
    if currentPing > Settings.NetworkOptimizer.MaxPing then Settings.NetworkOptimizer.MaxPing = currentPing end
    
    pcall(function()
        if Settings.NetworkOptimizer.LowLatencyMode and workspace.CurrentCamera then
            local fov = workspace.CurrentCamera.FieldOfView
            workspace.CurrentCamera.FieldOfView = fov + 0.001
            workspace.CurrentCamera.FieldOfView = fov
        end
        if Settings.NetworkOptimizer.ClearNetworkCache then
            spawn(function() collectgarbage("collect") end)
        end
        if Settings.NetworkOptimizer.BoostBandwidth then
            pcall(function() settings().Network.IncomingReplicationLag = 0 end)
        end
    end)
    
    Settings.NetworkOptimizer.TotalOptimizations = Settings.NetworkOptimizer.TotalOptimizations + 1
end

local function StartNetworkOptimizer()
    spawn(function()
        while Settings.NetworkOptimizer.Enabled do
            wait(Settings.NetworkOptimizer.Interval or 2)
            pcall(OptimizeNetwork)
        end
    end)
end

-- ============================================
-- ULTRA DESEMPENHO
-- ============================================

local function ApplyUltraPerformance()
    if PerformanceBackup.IsActive then return end
    PerformanceBackup.IsActive = true
    PerformanceBackup.RemovedObjects = {}
    PerformanceBackup.OriginalParent = {}
    PerformanceBackup.OriginalProperties = {}
    PerformanceBackup.KeptEffects = {}
    
    pcall(function()
        PerformanceBackup.Lighting = {
            GlobalShadows = Lighting.GlobalShadows, Brightness = Lighting.Brightness,
            Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
            FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
            FogColor = Lighting.FogColor, ShadowSoftness = Lighting.ShadowSoftness,
        }
        Lighting.GlobalShadows = false
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.fromRGB(180, 180, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.ShadowSoftness = 0
    end)
    
    pcall(function()
        for _, child in pairs(Lighting:GetChildren()) do
            local shouldRemove = false
            if child:IsA("Atmosphere") or child:IsA("Sky") or 
               child:IsA("SunRaysEffect") or child:IsA("DepthOfFieldEffect") then
                shouldRemove = true
            end
            if child:IsA("BloomEffect") then
                if Settings.UltraPerformance.KeepBloom then
                    table.insert(PerformanceBackup.KeptEffects, child)
                else shouldRemove = true end
            end
            if child:IsA("ColorCorrectionEffect") then
                if Settings.UltraPerformance.KeepColorCorrection then
                    table.insert(PerformanceBackup.KeptEffects, child)
                else shouldRemove = true end
            end
            if child:IsA("BlurEffect") then
                if Settings.UltraPerformance.KeepBlur then
                    table.insert(PerformanceBackup.KeptEffects, child)
                else shouldRemove = true end
            end
            if shouldRemove then
                PerformanceBackup.OriginalParent[child] = child.Parent
                child.Parent = nil
                table.insert(PerformanceBackup.RemovedObjects, child)
            end
        end
    end)
    
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            local isLocalChar = LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character)
            if Settings.UltraPerformance.RemoveTextures and not isLocalChar then
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    PerformanceBackup.OriginalProperties[obj] = obj.Transparency
                    obj.Transparency = 1
                end
            end
            if Settings.UltraPerformance.RemoveParticles and not isLocalChar then
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or 
                   obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    local n = obj.Name:lower()
                    if not (n:match("damage") or n:match("hurt") or n:match("hit")) then
                        obj.Enabled = false
                    end
                end
            end
            if Settings.UltraPerformance.RemoveSounds and not isLocalChar then
                if obj:IsA("Sound") then obj.Volume = 0 end
            end
        end
    end)
    
    pcall(function()
        if Settings.UltraPerformance.RemoveTerrain then
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                PerformanceBackup.TerrainBackup = {
                    WaterWaveSize = terrain.WaterWaveSize, WaterWaveSpeed = terrain.WaterWaveSpeed,
                    WaterReflectance = terrain.WaterReflectance,
                    WaterTransparency = terrain.WaterTransparency, Decoration = terrain.Decoration,
                }
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
                terrain.Decoration = false
            end
        end
    end)
    
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
end

local function RemoveUltraPerformance()
    if not PerformanceBackup.IsActive then return end
    pcall(function()
        for prop, value in pairs(PerformanceBackup.Lighting) do Lighting[prop] = value end
    end)
    pcall(function()
        for _, obj in pairs(PerformanceBackup.RemovedObjects) do
            if obj and obj.Parent == nil then
                local op = PerformanceBackup.OriginalParent[obj]
                if op then obj.Parent = op end
            end
        end
    end)
    pcall(function()
        for obj, value in pairs(PerformanceBackup.OriginalProperties) do
            if obj and obj.Parent then obj.Transparency = value end
        end
    end)
    pcall(function()
        if PerformanceBackup.TerrainBackup then
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                for prop, value in pairs(PerformanceBackup.TerrainBackup) do terrain[prop] = value end
            end
        end
    end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
    
    PerformanceBackup.IsActive = false
    PerformanceBackup.RemovedObjects = {}
    PerformanceBackup.OriginalParent = {}
    PerformanceBackup.OriginalProperties = {}
    PerformanceBackup.TerrainBackup = nil
    PerformanceBackup.KeptEffects = {}
end

local function ProtectDamageEffects()
    spawn(function()
        while true do
            wait(2)
            if Settings.UltraPerformance.Enabled then
                pcall(function()
                    local hasCC = false
                    for _, child in pairs(Lighting:GetChildren()) do
                        if child:IsA("ColorCorrectionEffect") then hasCC = true break end
                    end
                    if not hasCC and PerformanceBackup.KeptEffects then
                        for _, effect in pairs(PerformanceBackup.KeptEffects) do
                            if effect and effect.Parent == nil then effect.Parent = Lighting end
                        end
                    end
                end)
            end
        end
    end)
end

-- ============================================
-- DETECÇÃO DE TIME
-- ============================================

local function GetPlayerTeam(player)
    if not player then return "Desconhecido" end
    local team = "Desconhecido"
    pcall(function()
        if player.Team then
            local tn = player.Team.Name:lower()
            if tn:match("marinha") or tn:match("marine") or tn:match("navy") then team = "Marinha"
            elseif tn:match("pirata") or tn:match("pirate") then team = "Pirata" end
        end
    end)
    if team == "Desconhecido" then
        pcall(function()
            local data = player:FindFirstChild("Data")
            if data then
                local tv = data:FindFirstChild("Team")
                if tv then
                    local v = tostring(tv.Value):lower()
                    if v:match("marinha") or v:match("marine") then team = "Marinha"
                    elseif v:match("pirata") or v:match("pirate") then team = "Pirata" end
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
    local lt = GetLocalTeam()
    local tt = GetPlayerTeam(player)
    if lt == "Desconhecido" then return true end
    if tt == "Desconhecido" then return false end
    if lt == "Marinha" then return tt == "Pirata" end
    if lt == "Pirata" then return tt == "Marinha" end
    return true
end

-- ============================================
-- FLY LIVRE - SEM ESPAÇO/SHIFT (v29)
-- ============================================

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function CreateFlyInstances()
    if not LocalPlayer.Character then return false end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return false end
    
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyVelocity.P = 1250
    FlyBodyVelocity.Parent = rootPart
    
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyGyro.P = 10000
    FlyBodyGyro.D = 500
    FlyBodyGyro.CFrame = CFrame.new(rootPart.Position)
    FlyBodyGyro.Parent = rootPart
    
    humanoid.PlatformStand = true
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    return true
end

local function StartFly()
    if not Settings.Fly.Enabled then return end
    if not LocalPlayer.Character then return end
    if FlyActive then return end
    
    FlyActive = true
    FlyOriginalNoclip = Settings.Noclip.Enabled
    
    if Settings.Fly.AutoNoclip then
        Settings.Noclip.Enabled = true
        pcall(function()
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
    
    CreateFlyInstances()
    Rayfield:Notify({Title = "Fly Livre", Content = "✅ ATIVADO! WASD/Direcional", Duration = 2})
end

local function StopFly()
    if not FlyActive then return end
    FlyActive = false
    
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
    if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    
    if Settings.Fly.AutoNoclip then
        Settings.Noclip.Enabled = FlyOriginalNoclip
        pcall(function()
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = not Settings.Noclip.Enabled end
            end
        end)
    end
end

local function AntiResetFly()
    if not Settings.Fly.Enabled or not Settings.Fly.AntiReset then return end
    if not FlyActive then return end
    if not LocalPlayer.Character then return end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    
    if not rootPart or not humanoid then
        task.wait(0.5)
        if Settings.Fly.Enabled then
            FlyActive = false
            CreateFlyInstances()
            FlyActive = true
        end
        return
    end
    
    if not FlyBodyVelocity or not FlyBodyVelocity.Parent then
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        FlyBodyVelocity = nil
        CreateFlyInstances()
    end
    
    if not FlyBodyGyro or not FlyBodyGyro.Parent then
        if FlyBodyGyro then FlyBodyGyro:Destroy() end
        FlyBodyGyro = nil
        CreateFlyInstances()
    end
    
    if humanoid and not humanoid.PlatformStand then
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
end

-- ===== ATUALIZAÇÃO DO FLY LIVRE =====
-- PC: WASD move na direção da CÂMERA (sobe/desce conforme olhar)
-- MOBILE: direcional move na direção da CÂMERA
local function UpdateFly()
    if not FlyActive or not Settings.Fly.Enabled then return end
    if not LocalPlayer.Character then return end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end
    if not FlyBodyVelocity or not FlyBodyGyro then return end
    
    local speed = Settings.Fly.Speed or 150
    local velocity = Vector3.new(0, 0, 0)
    
    -- ===== MOBILE: direcional =====
    if IS_MOBILE then
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            -- Direção baseada na câmera (livre 3D)
            local camCFrame = Camera.CFrame
            local camForward = camCFrame.LookVector
            local camRight = camCFrame.RightVector
            
            -- Combina direção do direcional com a câmera
            local forwardInput = moveDir.Z
            local rightInput = moveDir.X
            
            velocity = (camForward * forwardInput + camRight * rightInput).Unit * speed
        end
    else
        -- ===== PC: WASD (livre 3D - sobe/desce conforme olhar) =====
        local camCFrame = Camera.CFrame
        local camForward = camCFrame.LookVector
        local camRight = camCFrame.RightVector
        
        local moveVec = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVec = moveVec + camForward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVec = moveVec - camForward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVec = moveVec + camRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVec = moveVec - camRight
        end
        
        if moveVec.Magnitude > 0 then
            velocity = moveVec.Unit * speed
        end
    end
    
    FlyBodyVelocity.Velocity = velocity
    
    -- Anti-Reset: mantém orientação vertical estável
    if Settings.Fly.AntiReset then
        FlyBodyGyro.CFrame = CFrame.new(rootPart.Position)
    end
end

local function StartFlyLoop()
    if FlyLoopRunning then return end
    FlyLoopRunning = true
    
    spawn(function()
        while FlyLoopRunning do
            wait(0.03)
            
            if Settings.Fly.Enabled then
                if not FlyActive and Settings.Fly.AutoRestart then
                    pcall(function()
                        CreateFlyInstances()
                        FlyActive = true
                    end)
                end
                
                if FlyActive then
                    pcall(UpdateFly)
                    pcall(AntiResetFly)
                end
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if Settings.Fly.Enabled then
        FlyActive = false
        wait(0.5)
        if Settings.Fly.Enabled then
            CreateFlyInstances()
            FlyActive = true
        end
    end
end)

StartFlyLoop()

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
    
    if FlyPlayerBodyVelocity then FlyPlayerBodyVelocity:Destroy() end
    if FlyPlayerBodyGyro then FlyPlayerBodyGyro:Destroy() end
    
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
    Rayfield:Notify({Title = "Fly Player", Content = "✅ ATIVADO!", Duration = 2})
end

local function StopFlyPlayer()
    FlyPlayerActive = false
    if FlyPlayerBodyVelocity then FlyPlayerBodyVelocity:Destroy() FlyPlayerBodyVelocity = nil end
    if FlyPlayerBodyGyro then FlyPlayerBodyGyro:Destroy() FlyPlayerBodyGyro = nil end
    if LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then h.PlatformStand = false end
    end
end

local function UpdateFlyPlayer()
    if not FlyPlayerActive or not Settings.FlyPlayer.Enabled then return end
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    if humanoid.Health <= 0 then StopFlyPlayer() return end
    
    if Settings.FlyPlayer.AntiFall then
        local cy = rootPart.Position.Y
        local dy = CurrentHeight - cy
        local vy = math.clamp(dy * 10, -50, 50)
        if FlyPlayerBodyVelocity then
            FlyPlayerBodyVelocity.Velocity = Vector3.new(0, vy, 0)
        end
        if cy < CurrentHeight - 5 then
            rootPart.CFrame = CFrame.new(rootPart.Position.X, CurrentHeight, rootPart.Position.Z)
        end
    end
    
    local md = humanoid.MoveDirection
    if md.Magnitude > 0 then
        local ms = Settings.FlyPlayer.MoveSpeed or 50
        local np = rootPart.Position + md * ms * 0.05
        np = Vector3.new(np.X, rootPart.Position.Y, np.Z)
        rootPart.CFrame = CFrame.new(np)
    end
end

-- ============================================
-- AIMLOCK
-- ============================================

local function GetClosestPlayer()
    if not LocalPlayer.Character then return nil end
    local h = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not h or h.Health <= 0 then return nil end
    local rp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rp then return nil end
    
    local closest = nil
    local cd = Settings.Aimbot.MaxDistance or 5000
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local c = player.Character
            if c then
                local th = c:FindFirstChild("Humanoid")
                if th and th.Health > 0 and IsEnemy(player) then
                    local tr = c:FindFirstChild("HumanoidRootPart")
                    if tr then
                        local d = (rp.Position - tr.Position).Magnitude
                        if d < cd then cd = d closest = player end
                    end
                end
            end
        end
    end
    return closest
end

local function AimLock()
    if not Settings.Aimbot.Enabled then CurrentTarget = nil return end
    if not LocalPlayer.Character then return end
    local h = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not h or h.Health <= 0 then return end
    
    if CurrentTarget then
        local valid = false
        pcall(function()
            if CurrentTarget.Character then
                local th = CurrentTarget.Character:FindFirstChild("Humanoid")
                if th and th.Health > 0 then valid = true end
            end
        end)
        if not valid then CurrentTarget = nil end
    end
    
    if not CurrentTarget then CurrentTarget = GetClosestPlayer() end
    if not CurrentTarget or not CurrentTarget.Character then return end
    
    local tr = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
    if not tr then CurrentTarget = nil return end
    
    local ap = CurrentTarget.Character:FindFirstChild(Settings.Aimbot.AimPart)
    if not ap then ap = CurrentTarget.Character:FindFirstChild("Head") or tr end
    if not ap or not Camera then return end
    
    local pos = ap.Position
    local tcf = CFrame.new(Camera.CFrame.Position, pos)
    
    if Settings.Aimbot.LockMode then
        Camera.CFrame = tcf
    else
        local sm = Settings.Aimbot.Smoothness or 0.15
        if sm > 0 then
            local la = math.clamp(1 - math.exp(-sm * 20 * 0.016), 0, 1)
            Camera.CFrame = Camera.CFrame:Lerp(tcf, la)
        else
            Camera.CFrame = tcf
        end
    end
end

-- ============================================
-- INFINITE JUMP
-- ============================================

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump.Enabled and not FlyActive then
        local c = LocalPlayer.Character
        if c then
            local h = c:FindFirstChild("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- ============================================
-- NOCLIP
-- ============================================

local function SetupNoclip()
    if not LocalPlayer.Character then return end
    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = not Settings.Noclip.Enabled end
    end
end

-- ============================================
-- NO FOG
-- ============================================

local function ToggleNoFog()
    if Settings.NoFog.Enabled then
        if OriginalFog == nil then
            OriginalFog = {
                FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
                FogColor = Lighting.FogColor, GlobalShadows = Lighting.GlobalShadows,
                Ambient = Lighting.Ambient, Brightness = Lighting.Brightness,
                TimeOfDay = Lighting.TimeOfDay, ClockTime = Lighting.ClockTime,
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
    local h = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not h then return end
    
    if Settings.AntiStun.AntiRagdoll then
        local s = h:GetState()
        if s == Enum.HumanoidStateType.Physics then
            h:ChangeState(Enum.HumanoidStateType.GettingUp)
            h.PlatformStand = false
        end
        for _, c in pairs(LocalPlayer.Character:GetChildren()) do
            if c:IsA("Motor6D") and (c.Name:match("Ragdoll") or c.Name:match("Joint")) then
                c:Destroy()
            end
        end
    end
    local s = h:GetState()
    if s == Enum.HumanoidStateType.Stunned then
        h:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- ============================================
-- SPEED + JUMP
-- ============================================

local function ApplySpeedAndJump()
    if not LocalPlayer.Character then return end
    local h = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not h then return end
    if Settings.Speed.Enabled then h.WalkSpeed = Settings.Speed.Value
    else h.WalkSpeed = 16 end
    if Settings.Jump.Enabled then h.JumpPower = Settings.Jump.Value
    else h.JumpPower = 50 end
end

-- ============================================
-- ESP
-- ============================================

local function GetPlayerLevel(player)
    local l = 0
    pcall(function()
        local d = player:FindFirstChild("Data")
        if d then
            local lv = d:FindFirstChild("Level")
            if lv then l = lv.Value or 0 end
        end
    end)
    return l
end

local function GetPlayerMaxHealth(player)
    local m = 100
    pcall(function()
        local d = player:FindFirstChild("Data")
        if d then
            local hv = d:FindFirstChild("MaxHealth")
            if hv then m = hv.Value or 100 end
        end
    end)
    return m
end

local function GetTeamColor(player)
    local t = GetPlayerTeam(player)
    if t == "Marinha" then return Color3.fromRGB(0, 100, 255)
    elseif t == "Pirata" then return Color3.fromRGB(255, 50, 50)
    else return Color3.fromRGB(150, 150, 150) end
end

local function GetTeamEmoji(player)
    local t = GetPlayerTeam(player)
    if t == "Marinha" then return "⚓"
    elseif t == "Pirata" then return "🏴‍☠️"
    else return "❓" end
end

local function CreateESPForPlayer(player)
    if player == LocalPlayer or not player then return end
    if not player.Character then
        player.CharacterAdded:Wait()
        wait(0.5)
        if not player.Character then return end
    end
    local c = player.Character
    if not c then return end
    local h = c:FindFirstChild("Humanoid")
    if not h then
        c:WaitForChild("Humanoid")
        wait(0.3)
        h = c:FindFirstChild("Humanoid")
        if not h then return end
    end
    for _, d in pairs(ESPObjects) do
        if d.Player == player then return end
    end
    
    local g = Instance.new("BillboardGui")
    g.Name = "ComandoGameESP"
    g.Size = UDim2.new(0, 250, 0, 100)
    g.AlwaysOnTop = true
    g.StudsOffset = Vector3.new(0, 3, 0)
    g.MaxDistance = Settings.ESP.MaxDistance or 100000
    g.Enabled = true
    
    local hd = c:FindFirstChild("Head")
    if hd then g.Parent = hd
    else
        local rp = c:FindFirstChild("HumanoidRootPart")
        if rp then g.Parent = rp else g.Parent = c end
    end
    
    local mf = Instance.new("Frame")
    mf.Size = UDim2.new(1, 0, 1, 0)
    mf.BackgroundTransparency = 0.6
    mf.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mf.BorderSizePixel = 2
    mf.BorderColor3 = GetTeamColor(player)
    mf.Parent = g
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 6)
    fc.Parent = mf
    
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, 0, 0, 20)
    nl.Position = UDim2.new(0, 0, 0, 2)
    nl.BackgroundTransparency = 1
    nl.Text = GetTeamEmoji(player) .. " " .. player.Name
    nl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nl.TextSize = 13
    nl.Font = Enum.Font.GothamBold
    nl.TextStrokeTransparency = 0.3
    nl.Parent = mf
    
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 0, 16)
    tl.Position = UDim2.new(0, 0, 0, 23)
    tl.BackgroundTransparency = 1
    tl.Text = GetPlayerTeam(player)
    tl.TextColor3 = GetTeamColor(player)
    tl.TextSize = 11
    tl.Font = Enum.Font.GothamBold
    tl.Parent = mf
    
    local ll = Instance.new("TextLabel")
    ll.Size = UDim2.new(1, 0, 0, 16)
    ll.Position = UDim2.new(0, 0, 0, 40)
    ll.BackgroundTransparency = 1
    ll.Text = "🏆 " .. GetPlayerLevel(player)
    ll.TextColor3 = Color3.fromRGB(255, 215, 0)
    ll.TextSize = 11
    ll.Font = Enum.Font.GothamBold
    ll.Parent = mf
    
    local hl = Instance.new("TextLabel")
    hl.Size = UDim2.new(1, 0, 0, 16)
    hl.Position = UDim2.new(0, 0, 0, 57)
    hl.BackgroundTransparency = 1
    local mh = GetPlayerMaxHealth(player) or h.MaxHealth or 100
    hl.Text = "❤️ " .. math.floor(h.Health) .. "/" .. math.floor(mh)
    hl.TextColor3 = Color3.fromRGB(0, 255, 0)
    hl.TextSize = 11
    hl.Font = Enum.Font.GothamBold
    hl.Parent = mf
    
    local hb = Instance.new("Frame")
    hb.Size = UDim2.new(0.9, 0, 0, 4)
    hb.Position = UDim2.new(0.05, 0, 0, 76)
    hb.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    hb.Parent = mf
    
    local hbb = Instance.new("Frame")
    hbb.Size = UDim2.new(1, 0, 1, 0)
    hbb.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    hbb.Parent = hb
    
    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, 0, 0, 14)
    dl.Position = UDim2.new(0, 0, 0, 83)
    dl.BackgroundTransparency = 1
    dl.Text = "📏 0m"
    dl.TextColor3 = Color3.fromRGB(150, 200, 255)
    dl.TextSize = 9
    dl.Font = Enum.Font.Gotham
    dl.Parent = mf
    
    local data = {
        Player = player, ESP = g, MainFrame = mf,
        NameLabel = nl, TeamLabel = tl, LevelLabel = ll,
        HPLabel = hl, HPBar = hbb, DistLabel = dl,
        Humanoid = h, Character = c, MaxHealth = mh,
        Team = GetPlayerTeam(player), TeamColor = GetTeamColor(player), Active = true
    }
    table.insert(ESPObjects, data)
    
    local conns = {}
    local hc = h.HealthChanged:Connect(function(health)
        for _, d in pairs(ESPObjects) do
            if d.Player == player and d.Active then
                local mhp = GetPlayerMaxHealth(player) or h.MaxHealth or 100
                d.MaxHealth = mhp
                if d.HPLabel then
                    d.HPLabel.Text = "❤️ " .. math.floor(health) .. "/" .. math.floor(mhp)
                    local p = health / mhp
                    if p > 0.5 then d.HPLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif p > 0.25 then d.HPLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else d.HPLabel.TextColor3 = Color3.fromRGB(255, 0, 0) end
                end
                if d.HPBar then
                    d.HPBar.Size = UDim2.new(math.clamp(health / mhp, 0, 1), 0, 1, 0)
                end
                break
            end
        end
    end)
    table.insert(conns, hc)
    
    local dc = h.Died:Connect(function()
        pcall(function() if g and g.Parent then g:Destroy() end end)
        for i, d in pairs(ESPObjects) do
            if d.Player == player then
                d.Active = false
                table.remove(ESPObjects, i)
                break
            end
        end
        dc:Disconnect()
        hc:Disconnect()
    end)
    table.insert(conns, dc)
    
    local cc = player.CharacterAdded:Connect(function()
        pcall(function() if g and g.Parent then g:Destroy() end end)
        for i, d in pairs(ESPObjects) do
            if d.Player == player then
                d.Active = false
                table.remove(ESPObjects, i)
                break
            end
        end
        if Settings.ESP.Enabled then
            wait(0.5)
            CreateESPForPlayer(player)
        end
    end)
    table.insert(conns, cc)
    
    ESPConnections[player] = conns
end

local function ClearESPForPlayer(player)
    for i, d in pairs(ESPObjects) do
        if d.Player == player then
            pcall(function() if d.ESP and d.ESP.Parent then d.ESP:Destroy() end end)
            d.Active = false
            table.remove(ESPObjects, i)
            break
        end
    end
    if ESPConnections[player] then
        for _, c in pairs(ESPConnections[player]) do
            pcall(function() c:Disconnect() end)
        end
        ESPConnections[player] = nil
    end
end

local function CreateESPForAllPlayers()
    for _, d in pairs(ESPObjects) do
        pcall(function() if d.ESP and d.ESP.Parent then d.ESP:Destroy() end end)
    end
    ESPObjects = {}
    for _, conns in pairs(ESPConnections) do
        for _, c in pairs(conns) do
            pcall(function() c:Disconnect() end)
        end
    end
    ESPConnections = {}
    if not Settings.ESP.Enabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then CreateESPForPlayer(p) end
    end
end

local function UpdateESP()
    for _, d in pairs(ESPObjects) do
        if d.Player and d.Player.Character and d.Active then
            local h = d.Player.Character:FindFirstChild("Humanoid")
            if h and h.Health > 0 then
                if d.LevelLabel then
                    d.LevelLabel.Text = "🏆 " .. GetPlayerLevel(d.Player)
                end
                if d.DistLabel and LocalPlayer.Character then
                    local rp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local tr = d.Player.Character:FindFirstChild("HumanoidRootPart")
                    if rp and tr then
                        d.DistLabel.Text = "📏 " .. math.floor((rp.Position - tr.Position).Magnitude) .. "m"
                    end
                end
                if d.TeamLabel then
                    local nt = GetPlayerTeam(d.Player)
                    if nt ~= d.Team then
                        d.Team = nt
                        d.TeamColor = GetTeamColor(d.Player)
                        d.TeamLabel.Text = nt
                        d.TeamLabel.TextColor3 = d.TeamColor
                        if d.NameLabel then
                            d.NameLabel.Text = GetTeamEmoji(d.Player) .. " " .. d.Player.Name
                        end
                        if d.MainFrame then d.MainFrame.BorderColor3 = d.TeamColor end
                    end
                end
            end
        end
    end
end

local function MonitorNewPlayers()
    while Settings.ESP.Enabled do
        wait(1)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local has = false
                for _, d in pairs(ESPObjects) do
                    if d.Player == p and d.Active then has = true break end
                end
                if not has then CreateESPForPlayer(p) end
            end
        end
    end
end

-- ============================================
-- EVENTOS
-- ============================================

Players.PlayerAdded:Connect(function(p)
    if Settings.ESP.Enabled and p ~= LocalPlayer then
        wait(0.5)
        CreateESPForPlayer(p)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    ClearESPForPlayer(p)
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    ApplySpeedAndJump()
    if Settings.Noclip.Enabled then SetupNoclip() end
    if Settings.FlyPlayer.Enabled and FlyPlayerActive then
        StopFlyPlayer() wait(0.3) StartFlyPlayer()
    end
    if Settings.ESP.Enabled then
        wait(0.3)
        CreateESPForAllPlayers()
    end
    if Settings.NoFog.Enabled then ToggleNoFog() end
    PlayerTeam = nil
    CurrentTarget = nil
end)

-- ============================================
-- LOOPS
-- ============================================

spawn(function() while wait(0.03) do
    if Settings.FlyPlayer.Enabled and FlyPlayerActive then UpdateFlyPlayer() end
end end)
spawn(function() while true do
    wait(0.1)
    if LocalPlayer.Character then ApplySpeedAndJump() end
end end)
spawn(function() while wait(0.15) do
    if Settings.ESP.Enabled then UpdateESP() end
end end)
spawn(function() while wait(2) do
    if Settings.ESP.Enabled then MonitorNewPlayers() end
end end)
spawn(function() while wait(5) do
    PlayerTeam = nil
    GetLocalTeam()
end end)

-- ============================================
-- LOOP PRINCIPAL
-- ============================================

local function OnRenderStep()
    if not LocalPlayer.Character then return end
    local h = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not h or h.Health <= 0 then return end
    AntiStunSystem()
    SetupNoclip()
    ApplySpeedAndJump()
    if Settings.Aimbot.Enabled then AimLock() end
end

RenderConnection = RunService.RenderStepped:Connect(OnRenderStep)

ProtectDamageEffects()

-- ============================================
-- INTERFACE RAYFIELD
-- ============================================

local function CreateUI()
    Window = Rayfield:CreateWindow({
        Name = "⚡ ComandoGame Mobile",
        LoadingTitle = "ComandoGame",
        LoadingSubtitle = "by Mk_gaming",
        Theme = "Dark",
        ConfigurationSaving = { Enabled = false },
    })

    -- ============================================
    -- ABA: PERFORMANCE
    -- ============================================
    
    local PerformanceTab = Window:CreateTab("⚡ Performance", 4483362458)
    
    PerformanceTab:CreateSection("🧠 Memory Optimizer PRO")
    
    PerformanceTab:CreateToggle({
        Name = "Memory Optimizer PRO",
        CurrentValue = false,
        Callback = function(v)
            Settings.MemoryOptimizer.Enabled = v
            if v then
                Settings.MemoryOptimizer.LastClean = 0
                StartMemoryOptimizer()
                Rayfield:Notify({Title = "Memory Optimizer", Content = "🧠 ATIVADO!", Duration = 3})
            end
        end
    })
    
    PerformanceTab:CreateToggle({Name = "Intervalo Adaptativo", CurrentValue = true, Callback = function(v) Settings.MemoryOptimizer.AdaptiveInterval = v end})
    PerformanceTab:CreateSlider({Name = "Intervalo Mínimo", Range = {10, 60}, Increment = 5, Suffix = "s", CurrentValue = 15, Callback = function(v) Settings.MemoryOptimizer.MinInterval = v end})
    PerformanceTab:CreateSlider({Name = "RAM Máxima", Range = {1000, 3000}, Increment = 100, Suffix = "MB", CurrentValue = 1800, Callback = function(v) Settings.MemoryOptimizer.MaxMemoryMB = v end})
    
    PerformanceTab:CreateSection("📊 Estatísticas")
    
    local memCurrentLabel = PerformanceTab:CreateLabel("💾 RAM Atual: 0 MB")
    local memSavedLabel = PerformanceTab:CreateLabel("💾 Liberado: 0 MB")
    local memCleanLabel = PerformanceTab:CreateLabel("🧹 Limpezas: 0")
    
    spawn(function()
        while wait(2) do
            local currentMem = GetMemoryMB()
            if memCurrentLabel then 
                local color = currentMem < 1000 and "✅" or currentMem < 1800 and "⚠️" or "🚨"
                memCurrentLabel:Set(color .. " RAM Atual: " .. currentMem .. " MB") 
            end
            if memSavedLabel then memSavedLabel:Set("💾 Liberado: " .. Settings.MemoryOptimizer.MemorySaved .. " MB") end
            if memCleanLabel then memCleanLabel:Set("🧹 Limpezas: " .. Settings.MemoryOptimizer.TotalCleans) end
        end
    end)
    
    PerformanceTab:CreateSection("🌐 Otimizador de Internet")
    
    PerformanceTab:CreateToggle({
        Name = "🌐 Otimizar Internet/Ping",
        CurrentValue = false,
        Callback = function(v)
            Settings.NetworkOptimizer.Enabled = v
            if v then
                Settings.NetworkOptimizer.LastOptimize = 0
                StartNetworkOptimizer()
                Rayfield:Notify({Title = "🌐 Otimizador", Content = "🚀 ATIVADO!", Duration = 3})
            end
        end
    })
    
    PerformanceTab:CreateSlider({Name = "Intervalo", Range = {1, 10}, Increment = 1, Suffix = "s", CurrentValue = 2, Callback = function(v) Settings.NetworkOptimizer.Interval = v end})
    
    local pLabel = PerformanceTab:CreateLabel("📡 Ping: 0ms")
    local pAvgLabel = PerformanceTab:CreateLabel("📊 Média: 0ms")
    local pOptLabel = PerformanceTab:CreateLabel("🚀 Otimizações: 0")
    
    spawn(function()
        while wait(1) do
            local currentPing = GetPing()
            if pLabel then 
                local color = currentPing < 100 and "✅" or currentPing < 200 and "⚠️" or "🚨"
                pLabel:Set(color .. " Ping: " .. currentPing .. "ms") 
            end
            if pAvgLabel then pAvgLabel:Set("📊 Média: " .. Settings.NetworkOptimizer.AvgPing .. "ms") end
            if pOptLabel then pOptLabel:Set("🚀 Otimizações: " .. Settings.NetworkOptimizer.TotalOptimizations) end
        end
    end)
    
    PerformanceTab:CreateSection("🚀 Ultra Desempenho")
    
    PerformanceTab:CreateToggle({
        Name = "⚡ Ativar Ultra Desempenho",
        CurrentValue = false,
        Callback = function(v)
            Settings.UltraPerformance.Enabled = v
            if v then
                ApplyUltraPerformance()
                Rayfield:Notify({Title = "Ultra Desempenho", Content = "🚀 ATIVADO!", Duration = 3})
            else
                RemoveUltraPerformance()
                Rayfield:Notify({Title = "Ultra Desempenho", Content = "⏹️ DESATIVADO", Duration = 3})
            end
        end
    })
    
    PerformanceTab:CreateToggle({Name = "Remover Texturas", CurrentValue = true, Callback = function(v) Settings.UltraPerformance.RemoveTextures = v end})
    PerformanceTab:CreateToggle({Name = "Remover Sombras", CurrentValue = true, Callback = function(v) Settings.UltraPerformance.RemoveShadows = v end})
    PerformanceTab:CreateToggle({Name = "Remover Partículas", CurrentValue = true, Callback = function(v) Settings.UltraPerformance.RemoveParticles = v end})
    PerformanceTab:CreateToggle({Name = "Remover Sky", CurrentValue = true, Callback = function(v) Settings.UltraPerformance.RemoveSky = v end})
    PerformanceTab:CreateToggle({Name = "Remover Água", CurrentValue = true, Callback = function(v) Settings.UltraPerformance.RemoveTerrain = v end})
    PerformanceTab:CreateToggle({Name = "Remover Sons", CurrentValue = true, Callback = function(v) Settings.UltraPerformance.RemoveSounds = v end})

    -- ============================================
    -- ABA: PLAYER
    -- ============================================
    
    local PlayerTab = Window:CreateTab("🎯 Player", 4483362458)
    
    PlayerTab:CreateSection("Aimlock")
    PlayerTab:CreateToggle({Name = "Aimlock", CurrentValue = false, Callback = function(v) Settings.Aimbot.Enabled = v if not v then CurrentTarget = nil end end})
    PlayerTab:CreateToggle({Name = "Travar no Alvo (Lock)", CurrentValue = true, Callback = function(v) Settings.Aimbot.LockMode = v end})
    PlayerTab:CreateToggle({Name = "Filtro de Time", CurrentValue = false, Callback = function(v) Settings.Aimbot.TeamFilter = v end})
    PlayerTab:CreateDropdown({Name = "Parte do Corpo", Options = {"Head", "HumanoidRootPart", "UpperTorso"}, CurrentOption = "Head", Callback = function(o) Settings.Aimbot.AimPart = o end})
    PlayerTab:CreateSlider({Name = "Distância", Range = {500, 10000}, Increment = 500, Suffix = "studs", CurrentValue = 5000, Callback = function(v) Settings.Aimbot.MaxDistance = v end})
    PlayerTab:CreateSlider({Name = "Suavidade", Range = {0, 100}, Increment = 5, Suffix = "%", CurrentValue = 15, Callback = function(v) Settings.Aimbot.Smoothness = v / 100 end})
    
    PlayerTab:CreateSection("ESP")
    PlayerTab:CreateToggle({Name = "ESP Box 2D", CurrentValue = false, Callback = function(v)
        Settings.ESP.Enabled = v
        if v then CreateESPForAllPlayers()
        else
            for _, d in pairs(ESPObjects) do pcall(function() if d.ESP and d.ESP.Parent then d.ESP:Destroy() end end) end
            ESPObjects = {}
            for _, cs in pairs(ESPConnections) do for _, c in pairs(cs) do pcall(function() c:Disconnect() end) end end
            ESPConnections = {}
        end
    end})
    PlayerTab:CreateSlider({Name = "Distância ESP", Range = {1000, 100000}, Increment = 1000, Suffix = "studs", CurrentValue = 100000, Callback = function(v)
        Settings.ESP.MaxDistance = v
        for _, d in pairs(ESPObjects) do if d.ESP then d.ESP.MaxDistance = v end end
    end})
    
    PlayerTab:CreateSection("Noclip")
    PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) Settings.Noclip.Enabled = v SetupNoclip() end})
    
    PlayerTab:CreateSection("Anti-Stun")
    PlayerTab:CreateToggle({Name = "Anti-Stun", CurrentValue = false, Callback = function(v) Settings.AntiStun.Enabled = v end})
    PlayerTab:CreateToggle({Name = "Anti-Ragdoll", CurrentValue = false, Callback = function(v) Settings.AntiStun.AntiRagdoll = v end})
    
    PlayerTab:CreateSection("Visual")
    PlayerTab:CreateToggle({Name = "No Fog", CurrentValue = false, Callback = function(v) Settings.NoFog.Enabled = v ToggleNoFog() end})

    -- ============================================
    -- ABA: MOVIMENTO
    -- ============================================
    
    local MoveTab = Window:CreateTab("🏃 Movimento", 4483362458)
    
    MoveTab:CreateSection("Speed")
    MoveTab:CreateToggle({Name = "Speed", CurrentValue = false, Callback = function(v) Settings.Speed.Enabled = v ApplySpeedAndJump() end})
    MoveTab:CreateSlider({Name = "Velocidade", Range = {16, 500}, Increment = 10, Suffix = "WalkSpeed", CurrentValue = 300, Callback = function(v) Settings.Speed.Value = v ApplySpeedAndJump() end})
    
    MoveTab:CreateSection("Jump")
    MoveTab:CreateToggle({Name = "Jump", CurrentValue = false, Callback = function(v) Settings.Jump.Enabled = v ApplySpeedAndJump() end})
    MoveTab:CreateSlider({Name = "Altura", Range = {50, 300}, Increment = 10, Suffix = "JumpPower", CurrentValue = 150, Callback = function(v) Settings.Jump.Value = v ApplySpeedAndJump() end})
    MoveTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) Settings.InfiniteJump.Enabled = v end})
    
    MoveTab:CreateSection("🚀 Fly Livre")
    
    MoveTab:CreateToggle({
        Name = "Fly - Voar Livre",
        CurrentValue = false,
        Callback = function(v)
            Settings.Fly.Enabled = v
            if v then StartFly() else StopFly() end
        end
    })
    
    MoveTab:CreateSlider({
        Name = "Velocidade",
        Range = {30, 300},
        Increment = 10,
        Suffix = "studs/s",
        CurrentValue = 150,
        Callback = function(v) Settings.Fly.Speed = v end
    })
    
    MoveTab:CreateToggle({
        Name = "Anti-Reset Fly",
        CurrentValue = true,
        Callback = function(v) Settings.Fly.AntiReset = v end
    })
    
    MoveTab:CreateToggle({
        Name = "Auto-Reiniciar Fly",
        CurrentValue = true,
        Callback = function(v) Settings.Fly.AutoRestart = v end
    })
    
    MoveTab:CreateToggle({
        Name = "Noclip Automático",
        CurrentValue = true,
        Callback = function(v) Settings.Fly.AutoNoclip = v end
    })
    
    MoveTab:CreateLabel("")
    MoveTab:CreateLabel("🎮 COMO USAR:")
    MoveTab:CreateLabel("📱 MOBILE: use o DIRECIONAL")
    MoveTab:CreateLabel("💻 PC: use WASD")
    MoveTab:CreateLabel("")
    MoveTab:CreateLabel("✨ Olhe para CIMA e mova = SOBE")
    MoveTab:CreateLabel("✨ Olhe para BAIXO e mova = DESCE")
    MoveTab:CreateLabel("✨ Olhe reto e mova = ANDA NO AR")
    MoveTab:CreateLabel("")
    MoveTab:CreateLabel("🚫 SEM ESPAÇO / SEM SHIFT")
    
    MoveTab:CreateSection("✈️ Fly Player (Hover)")
    MoveTab:CreateToggle({Name = "Fly Player (Hover)", CurrentValue = false, Callback = function(v)
        Settings.FlyPlayer.Enabled = v
        if v then StartFlyPlayer() else StopFlyPlayer() end
    end})
    MoveTab:CreateToggle({Name = "Anti-Reset Fly", CurrentValue = true, Callback = function(v) Settings.FlyPlayer.AntiReset = v end})
    MoveTab:CreateToggle({Name = "Anti-Fall", CurrentValue = true, Callback = function(v) Settings.FlyPlayer.AntiFall = v end})
    MoveTab:CreateSlider({Name = "Altura no Ar", Range = {5, 100}, Increment = 5, Suffix = "studs", CurrentValue = 10, Callback = function(v)
        Settings.FlyPlayer.Height = v
        if FlyPlayerActive and LocalPlayer.Character then
            local rp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rp then CurrentHeight = rp.Position.Y + v end
        end
    end})
    MoveTab:CreateSlider({Name = "Velocidade", Range = {10, 150}, Increment = 5, Suffix = "studs/s", CurrentValue = 50, Callback = function(v) Settings.FlyPlayer.MoveSpeed = v end})

    -- ============================================
    -- ABA: SCRIPTS
    -- ============================================
    
    local ScriptsTab = Window:CreateTab("📜 Scripts", 4483362458)
    
    ScriptsTab:CreateSection("🎯 CentHub Bounty")
    
    ScriptsTab:CreateButton({
        Name = "⚔️ Carregar CentHub Bounty",
        Callback = function()
            if CentHubLoaded then
                Rayfield:Notify({Title = "CentHub", Content = "⚠️ Já carregado!", Duration = 3})
                return
            end
            Rayfield:Notify({Title = "CentHub Bounty", Content = "⏳ Carregando...", Duration = 3})
            spawn(function()
                local ok, err = pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/JustParadozCode/CentuDox-Hub/refs/heads/main/CentuDox-Pvp.xyz"))()
                end)
                if ok then
                    CentHubLoaded = true
                    Rayfield:Notify({Title = "CentHub Bounty", Content = "✅ Carregado!", Duration = 4})
                else
                    Rayfield:Notify({Title = "CentHub Bounty", Content = "❌ Erro", Duration = 5})
                end
            end)
        end
    })

    -- ============================================
    -- ABA: SOBRE
    -- ============================================
    
    local AboutTab = Window:CreateTab("ℹ️ Sobre", 4483362458)
    AboutTab:CreateLabel("⚡ ComandoGame Mobile v29.0")
    AboutTab:CreateLabel("👤 Criador: Mk_gaming")
    AboutTab:CreateLabel("")
    AboutTab:CreateLabel("🆕 v29.0:")
    AboutTab:CreateLabel("✅ FLY LIVRE 3D")
    AboutTab:CreateLabel("🚫 Sem ESPAÇO / Sem SHIFT")
    AboutTab:CreateLabel("")
    AboutTab:CreateLabel("📱 MOBILE:")
    AboutTab:CreateLabel("• Direcional = voar livremente")
    AboutTab:CreateLabel("• Olhar pra cima = sobe")
    AboutTab:CreateLabel("• Olhar pra baixo = desce")
    AboutTab:CreateLabel("")
    AboutTab:CreateLabel("💻 PC:")
    AboutTab:CreateLabel("• WASD = voar livremente")
    AboutTab:CreateLabel("• Olhar pra cima = sobe")
    AboutTab:CreateLabel("• Olhar pra baixo = desce")
    AboutTab:CreateLabel("")
    AboutTab:CreateLabel("✨ Voo natural em 3D!")
end

CreateUI()

Rayfield:Notify({
    Title = "ComandoGame Mobile",
    Content = "⚡ v29.0 - FLY LIVRE 3D!",
    Duration = 5,
})

print("✅ ComandoGame Mobile v29.0 carregado!")
print("🚀 FLY LIVRE - Sem Espaço/Shift")
print("📱 Mobile: direcional + câmera")
print("💻 PC: WASD + câmera")
print("✨ Olhe pra cima/baixo para subir/descer")
