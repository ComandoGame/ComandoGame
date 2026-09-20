-- Menu Multi-Jogos - Mk_gaming (Mobile Otimizado)
-- Detecta o jogo atual e libera apenas os scripts compatíveis

local player = game.Players.LocalPlayer
if not player then repeat wait() until game.Players.LocalPlayer end
repeat wait() until game:IsLoaded()

-- ============================================
-- DETECTOR DE JOGO
-- ============================================
local function detectGame()
    local gameId = game.PlaceId
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Desconhecido"
    
    local games = {
        [2753915549] = "Blox Fruits",
        [4442272183] = "Blox Fruits (Teste)",
        [6284583030] = "Blox Fruits (Mobile)",
        [6403373529] = "Blox Fruits (Console)",
        [85211729168715] = "Blox Fruits (Primeiro Mar)",
        [79091703265657] = "Blox Fruits (Segundo Mar)",
        [100117331123089] = "Blox Fruits (Terceiro Mar)",
        [73902483975735] = "Blox Fruits (Masmorras)",
        [125686182205697] = "Blitz",
        [83469115925484] = "Blitz",
        [72632230828026] = "Blitz",
        [6383408360] = "Horror Elevador",
        [114701676447029] = "Knockback Battles",
    }
    
    local detectedName = games[gameId] or gameName
    
    if games[gameId] == "Blitz" or string.find(gameName, "Blitz") or string.find(gameName, "BLITZ") then
        detectedName = "Blitz"
    end
    
    return {
        id = gameId,
        name = detectedName,
        rawName = gameName,
        isBloxFruits = gameId == 2753915549 or gameId == 4442272183 or gameId == 6284583030 or gameId == 6403373529 or gameId == 85211729168715 or gameId == 79091703265657 or gameId == 100117331123089,
        isBloxFruitsDungeon = gameId == 73902483975735,
        isBlitz = gameId == 125686182205697 or gameId == 83469115925484 or gameId == 72632230828026 or string.find(gameName, "Blitz") or string.find(gameName, "BLITZ"),
        isHorrorElevador = gameId == 6383408360,
        isKnockback = gameId == 114701676447029
    }
end

local currentGame = detectGame()

-- ============================================
-- DETECTAR SE É MOBILE
-- ============================================
local isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled

-- ============================================
-- DIMENSÕES RESPONSIVAS
-- ============================================
local viewportSize = workspace.CurrentCamera.ViewportSize
local isSmallScreen = viewportSize.X < 800 or viewportSize.Y < 600

local frameWidth = isMobile and math.min(viewportSize.X * 0.9, 380) or 420
local frameHeight = isMobile and math.min(viewportSize.Y * 0.85, 500) or 620
local scriptAreaHeight = isMobile and (frameHeight * 0.42) or 255

-- ============================================
-- FUNÇÃO PARA MOSTRAR AVISO DE MANUTENÇÃO
-- ============================================
local function showMaintenanceNotice(scriptName, reason)
    local gui = Instance.new("ScreenGui")
    gui.Name = "MaintenanceNotice"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, isMobile and 300 or 400, 0, isMobile and 180 or 200)
    frame.Position = UDim2.new(0.5, isMobile and -150 or -200, 0.5, isMobile and -90 or -100)
    frame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = "⚠️ SCRIPT EM MANUTENÇÃO"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -40, 0, 25)
    msg.Position = UDim2.new(0, 20, 0, 55)
    msg.BackgroundTransparency = 1
    msg.Text = "🔄 " .. scriptName
    msg.TextColor3 = Color3.fromRGB(255, 255, 255)
    msg.TextScaled = true
    msg.Font = Enum.Font.Gotham
    msg.Parent = frame
    
    if reason then
        local reasonLabel = Instance.new("TextLabel")
        reasonLabel.Size = UDim2.new(1, -40, 0, 40)
        reasonLabel.Position = UDim2.new(0, 20, 0, 85)
        reasonLabel.BackgroundTransparency = 1
        reasonLabel.Text = reason
        reasonLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        reasonLabel.TextScaled = true
        reasonLabel.TextWrapped = true
        reasonLabel.Font = Enum.Font.Gotham
        reasonLabel.Parent = frame
    end
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 30)
    closeBtn.Position = UDim2.new(0.5, -50, 1, -40)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.BorderSizePixel = 1
    closeBtn.BorderColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.Text = "✕ FECHAR"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    task.wait(5)
    gui:Destroy()
end

-- ============================================
-- LISTA DE SCRIPTS POR JOGO
-- ============================================
local scripts = {
    -- ===== BLOX FRUITS (11 SCRIPTS) =====
    { 
        id = 1, 
        name = "Quantum Onyx", 
        game = "Blox Fruits",
        key = false, 
        desc = "✅ Atualizado • Sistema de Key",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()' 
    },
    { 
        id = 2, 
        name = "Hoho Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Quest • Fly",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()' 
    },
    { 
        id = 3, 
        name = "Speed Hub X", 
        game = "Blox Fruits",
        key = false, 
        desc = "ESP • Speed Hack • PvP",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))()' 
    },
    { 
        id = 4, 
        name = "Cokka Hub", 
        game = "Blox Fruits",
        key = true, 
        desc = "Mobile Hack • Auto Farm",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua"))()' 
    },
    -- HUNT HUB - ATUALIZADO
    { 
        id = 5, 
        name = "Hunt Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "ComandoGame • Atualizado",
        load = 'loadstring(game:HttpGet("https://github.com/ComandoGame/ComandoGame/raw/ComandoGame/Hunt%20hub.lua"))()' 
    },
    { 
        id = 7, 
        name = "Neva Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Farm • Magnet",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/VEZ2/NEVAHUB/main/2"))()' 
    },
    { 
        id = 14, 
        name = "Hermanos Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "PVP • FARM",
        load = function()
            local script_mode = "FARM"
            loadstring(game:HttpGet("https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"))()
        end
    },
    { 
        id = 15, 
        name = "Night Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Farm • Hop Script",
        load = 'loadstring(game:HttpGet("https://github.com/WhiteX1208/Scripts/blob/main/HopScript.luau?raw=true"))()' 
    },
    { 
        id = 16, 
        name = "Teddy Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Farm • Auto Quest",
        load = 'repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))()' 
    },
    { 
        id = 17, 
        name = "Redz Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Farm • Auto Raid",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2"))()' 
    },
    { 
        id = 19, 
        name = "Tsuo Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "⚠️ PESADO - Instabilidade FPS",
        load = function()
            showMaintenanceNotice("Tsuo Hub", "⚠️ Script pesado causa instabilidade de FPS e travamentos.")
        end,
        isMaintenance = true
    },
    { 
        id = 20, 
        name = "Ruby Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Farm • Sem Key",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Ruby/script.lua"))()' 
    },
    { 
        id = 21, 
        name = "CentuDox PvP", 
        game = "Blox Fruits",
        key = false, 
        desc = "⚔️ Bounty • PvP • Sem Key",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/JustParadozCode/CentuDox-Hub/refs/heads/main/CentuDox-Pvp.xyz"))()' 
    },
    { 
        id = 18, 
        name = "Quantum Onyx (Dungeon)", 
        game = "Blox Fruits (Masmorras)",
        key = false, 
        desc = "✅ Atualizado • Único que funciona",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()' 
    },
    
    -- ===== BLITZ (UNIVERSAL) =====
    { 
        id = 11, 
        name = "Blitz ModMenu", 
        game = "Universal",
        key = false, 
        desc = "Fly • Aimbot • ESP • Auto Farm",
        load = 'loadstring(game:HttpGet("https://pastebin.com/raw/mF6iNG8C"))()' 
    },
    
    -- ===== HORROR ELEVADOR =====
    { 
        id = 12, 
        name = "Horror Elevador", 
        game = "Horror Elevador",
        key = false, 
        desc = "Coleta • GodMode • Auto Farm",
        load = 'loadstring(game:HttpGet("https://pastebin.com/raw/MDjMhyrA"))()' 
    },
    
    -- ===== KNOCKBACK BATTLES (EM UPDATE) =====
    { 
        id = 13, 
        name = "Knockback Battles", 
        game = "Knockback Battles",
        key = false, 
        desc = "🔄 EM UPDATE - Em breve",
        load = function()
            local gui = Instance.new("ScreenGui")
            gui.Name = "UpdateNotice"
            gui.ResetOnSpawn = false
            gui.Parent = game.Players.LocalPlayer.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, isMobile and 300 or 400, 0, isMobile and 130 or 150)
            frame.Position = UDim2.new(0.5, isMobile and -150 or -200, 0.5, isMobile and -65 or -75)
            frame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
            frame.BackgroundTransparency = 0.1
            frame.BorderSizePixel = 2
            frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
            frame.Parent = gui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 16)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 30)
            title.Position = UDim2.new(0, 0, 0, 10)
            title.BackgroundTransparency = 1
            title.Text = "🔧 SCRIPT EM UPDATE"
            title.TextColor3 = Color3.fromRGB(255, 200, 50)
            title.TextScaled = true
            title.Font = Enum.Font.GothamBold
            title.Parent = frame
            
            local msg = Instance.new("TextLabel")
            msg.Size = UDim2.new(1, -40, 0, 25)
            msg.Position = UDim2.new(0, 20, 0, 50)
            msg.BackgroundTransparency = 1
            msg.Text = "🔄 Knockback Battles sendo atualizado."
            msg.TextColor3 = Color3.fromRGB(255, 255, 255)
            msg.TextScaled = true
            msg.Font = Enum.Font.Gotham
            msg.Parent = frame
            
            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 100, 0, 30)
            closeBtn.Position = UDim2.new(0.5, -50, 1, -40)
            closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            closeBtn.BackgroundTransparency = 0.2
            closeBtn.BorderSizePixel = 1
            closeBtn.BorderColor3 = Color3.fromRGB(255, 100, 100)
            closeBtn.Text = "✕ FECHAR"
            closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeBtn.TextScaled = true
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.Parent = frame
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(0, 8)
            closeCorner.Parent = closeBtn
            
            closeBtn.MouseButton1Click:Connect(function()
                gui:Destroy()
            end)
            
            task.wait(5)
            gui:Destroy()
        end
    },
}

-- ============================================
-- FILTRAR SCRIPTS POR JOGO ATUAL
-- ============================================
local function getAvailableScripts()
    local available = {}
    
    if currentGame.isBloxFruitsDungeon then
        for _, script in ipairs(scripts) do
            if script.id == 18 then
                table.insert(available, script)
            end
        end
        return available
    end
    
    if currentGame.isBloxFruits then
        for _, script in ipairs(scripts) do
            if script.game == "Blox Fruits" then
                table.insert(available, script)
            end
        end
        return available
    end
    
    for _, script in ipairs(scripts) do
        if script.game == currentGame.name or script.game == "Universal" then
            table.insert(available, script)
        end
    end
    return available
end

local availableScripts = getAvailableScripts()

-- ============================================
-- CARREGAR CONFIGURAÇÃO SALVA
-- ============================================
local savedData = {
    autoScriptId = nil,
    autoEnabled = false
}

pcall(function()
    local data = getfenv()._G.BloxFruitsMenuData
    if data then
        savedData.autoScriptId = data.autoScriptId
        savedData.autoEnabled = data.autoEnabled
    end
end)

-- ============================================
-- CRIAÇÃO DA GUI (RESPONSIVA)
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptMenu"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
frame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
frame.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(150, 50, 255)
frame.ClipsDescendants = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

-- ============================================
-- HEADER
-- ============================================
local headerHeight = isMobile and 40 or 45
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, headerHeight)
header.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
header.Parent = frame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦ SCRIPTS ✦"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -33, 0, (headerHeight - 25)/2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 60)
closeBtn.BackgroundTransparency = 0.2
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() 
    if gui then gui:Destroy() end
end)

-- ============================================
-- INFO DO JOGO E JOGADOR
-- ============================================
local infoHeight = isMobile and 50 or 60
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -16, 0, infoHeight)
infoFrame.Position = UDim2.new(0, 8, 0, headerHeight + 7)
infoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
infoFrame.BackgroundTransparency = 0.9
infoFrame.BorderSizePixel = 1
infoFrame.BorderColor3 = Color3.fromRGB(150, 50, 255)
infoFrame.Parent = frame
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local nomeLabel = Instance.new("TextLabel")
nomeLabel.Size = UDim2.new(0.5, -10, 0, 16)
nomeLabel.Position = UDim2.new(0, 8, 0, 3)
nomeLabel.BackgroundTransparency = 1
nomeLabel.Text = "👤 " .. player.Name
nomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nomeLabel.TextScaled = true
nomeLabel.Font = Enum.Font.GothamSemibold
nomeLabel.TextXAlignment = Enum.TextXAlignment.Left
nomeLabel.Parent = infoFrame

local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(0.5, -10, 0, 16)
levelLabel.Position = UDim2.new(0, 8, 0, 20)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "📊 Nível: 0"
levelLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
levelLabel.TextScaled = true
levelLabel.Font = Enum.Font.Gotham
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = infoFrame

local gameLabel = Instance.new("TextLabel")
gameLabel.Size = UDim2.new(0.5, -10, 0, 16)
gameLabel.Position = UDim2.new(0.5, 0, 0, 3)
gameLabel.BackgroundTransparency = 1
gameLabel.Text = "🎮 " .. currentGame.name
gameLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
gameLabel.TextScaled = true
gameLabel.Font = Enum.Font.GothamBold
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.Parent = infoFrame

local statusGame = Instance.new("TextLabel")
statusGame.Size = UDim2.new(0.5, -10, 0, 16)
statusGame.Position = UDim2.new(0.5, 0, 0, 20)
statusGame.BackgroundTransparency = 1
statusGame.Text = "📜 " .. #availableScripts .. " disponíveis"
statusGame.TextColor3 = Color3.fromRGB(255, 200, 100)
statusGame.TextScaled = true
statusGame.Font = Enum.Font.Gotham
statusGame.TextXAlignment = Enum.TextXAlignment.Left
statusGame.Parent = infoFrame

task.spawn(function()
    while gui and gui.Parent do
        pcall(function()
            if not levelLabel or not levelLabel.Parent then return end
            
            local data = player:FindFirstChild("Data")
            if data then
                local lvl = data:FindFirstChild("Level")
                if lvl then 
                    levelLabel.Text = "📊 Nível: " .. tostring(lvl.Value) 
                end
            end
        end)
        wait(1)
    end
end)

-- ============================================
-- ÁREA DE SCRIPTS (SCROLL)
-- ============================================
local scriptArea = Instance.new("ScrollingFrame")
scriptArea.Size = UDim2.new(1, -16, 0, scriptAreaHeight)
scriptArea.Position = UDim2.new(0, 8, 0, headerHeight + infoHeight + 14)
scriptArea.BackgroundTransparency = 1
scriptArea.ScrollBarThickness = 4
scriptArea.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)
scriptArea.CanvasSize = UDim2.new(0, 0, 0, #scripts * (isMobile and 34 or 38))
scriptArea.Parent = frame

local selecionados = {}
local botoesCheck = {}
local linhas = {}

local rowHeight = isMobile and 32 or 34
local rowSpacing = isMobile and 36 or 38

for i, data in ipairs(scripts) do
    local isAvailable = false
    for _, avail in ipairs(availableScripts) do
        if avail.id == data.id then
            isAvailable = true
            break
        end
    end
    
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, rowHeight)
    row.Position = UDim2.new(0, 0, 0, (i-1) * rowSpacing)
    
    if data.isMaintenance then
        row.BackgroundColor3 = Color3.fromRGB(80, 60, 30)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(255, 200, 50)
        row.BorderSizePixel = 2
    elseif data.id == 13 then
        row.BackgroundColor3 = Color3.fromRGB(80, 60, 30)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(255, 200, 50)
        row.BorderSizePixel = 2
    elseif data.id == 18 then
        row.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(100, 255, 100)
        row.BorderSizePixel = 2
    elseif isAvailable then
        row.BackgroundColor3 = data.key and Color3.fromRGB(180, 100, 50) or Color3.fromRGB(60, 30, 80)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = data.key and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(150, 100, 200)
    else
        row.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        row.BackgroundTransparency = 0.3
        row.BorderColor3 = Color3.fromRGB(80, 80, 80)
    end
    row.BorderSizePixel = 1
    row.Parent = scriptArea
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent = row

    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 20, 1, -4)
    cb.Position = UDim2.new(0, 4, 0, 2)
    cb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cb.BackgroundTransparency = 0.3
    cb.BorderSizePixel = 1
    
    if data.isMaintenance then
        cb.BorderColor3 = Color3.fromRGB(255, 200, 50)
        cb.Text = "🔧"
        cb.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 13 then
        cb.BorderColor3 = Color3.fromRGB(255, 200, 50)
        cb.Text = "🔒"
        cb.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 18 then
        cb.BorderColor3 = Color3.fromRGB(100, 255, 100)
        cb.Text = "☐"
        cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif isAvailable then
        cb.BorderColor3 = Color3.fromRGB(200, 150, 255)
        cb.Text = "☐"
        cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        cb.BorderColor3 = Color3.fromRGB(80, 80, 80)
        cb.Text = "🔒"
        cb.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
    cb.TextScaled = true
    cb.Font = Enum.Font.GothamBold
    cb.Parent = row
    local cbCorner = Instance.new("UICorner")
    cbCorner.CornerRadius = UDim.new(0, 4)
    cbCorner.Parent = cb

    botoesCheck[data.id] = cb
    linhas[data.id] = {row = row, corBase = row.BackgroundColor3, isAvailable = isAvailable, isMaintenance = data.isMaintenance}

    if isAvailable and data.id ~= 13 and not data.isMaintenance then
        cb.MouseButton1Click:Connect(function()
            local idx = table.find(selecionados, data.id)
            if idx then
                table.remove(selecionados, idx)
                cb.Text = "☐"
                cb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                cb.BorderColor3 = Color3.fromRGB(200, 150, 255)
                row.BackgroundColor3 = data.key and Color3.fromRGB(180, 100, 50) or Color3.fromRGB(60, 30, 80)
            else
                for _, id in ipairs(selecionados) do
                    local cb2 = botoesCheck[id]
                    local row2 = linhas[id]
                    if cb2 and row2 and row2.isAvailable and not row2.isMaintenance then
                        cb2.Text = "☐"
                        cb2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        cb2.BorderColor3 = Color3.fromRGB(200, 150, 255)
                    end
                    if row2 and row2.row and row2.isAvailable and not row2.isMaintenance then
                        row2.row.BackgroundColor3 = row2.corBase
                    end
                end
                selecionados = {}
                
                table.insert(selecionados, data.id)
                cb.Text = "☑"
                cb.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
                cb.BorderColor3 = Color3.fromRGB(255, 100, 200)
                row.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            end
            local count = #selecionados
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = count > 0 and "◆ " .. count .. " selecionado" or "◆ Nenhum selecionado"
                statusLabel.TextColor3 = count > 0 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(200, 200, 200)
            end
            
            pcall(function()
                getfenv()._G.BloxFruitsMenuData = {
                    autoScriptId = #selecionados > 0 and selecionados[1] or nil,
                    autoEnabled = savedData.autoEnabled
                }
            end)
        end)
    else
        cb.MouseButton1Click:Connect(function()
            if data.isMaintenance then
                data.load()
            elseif data.id == 13 then
                data.load()
            end
        end)
    end
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0, 120, 0, 14)
    nameLbl.Position = UDim2.new(0, 30, 0, 1)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = data.name
    if data.isMaintenance then
        nameLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 13 then
        nameLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 18 then
        nameLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        nameLbl.TextColor3 = isAvailable and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    end
    nameLbl.TextScaled = true
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = row

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(0, 100, 0, 12)
    descLbl.Position = UDim2.new(0, 30, 0, 16)
    descLbl.BackgroundTransparency = 1
    if data.isMaintenance then
        descLbl.Text = "⏳ Manutenção..."
        descLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    elseif data.id == 13 then
        descLbl.Text = "🔧 Atualizando..."
        descLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    elseif data.id == 18 then
        descLbl.Text = "✅ Único que funciona"
        descLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        descLbl.Text = data.desc
        descLbl.TextColor3 = isAvailable and Color3.fromRGB(180, 180, 200) or Color3.fromRGB(100, 100, 100)
    end
    descLbl.TextScaled = true
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 8
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = row

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(0, 25, 1, 0)
    keyLbl.Position = UDim2.new(1, -30, 0, 0)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = data.key and "🔑" or "✓"
    if data.isMaintenance then
        keyLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 13 then
        keyLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 18 then
        keyLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        keyLbl.TextColor3 = isAvailable and (data.key and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(50, 255, 50)) or Color3.fromRGB(100, 100, 100)
    end
    keyLbl.TextScaled = true
    keyLbl.Font = Enum.Font.Gotham
    keyLbl.Parent = row
end

-- ============================================
-- BOTÕES INFERIORES
-- ============================================
local btnHeight = isMobile and 32 or 35
local btnFrame = Instance.new("Frame")
btnFrame.Size = UDim2.new(1, -16, 0, btnHeight)
btnFrame.Position = UDim2.new(0, 8, 1, -(btnHeight * 3 + 20))
btnFrame.BackgroundTransparency = 1
btnFrame.Parent = frame

local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0.38, -3, 1, 0)
execBtn.Position = UDim2.new(0, 0, 0, 0)
execBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
execBtn.BackgroundTransparency = 0.1
execBtn.BorderSizePixel = 2
execBtn.BorderColor3 = Color3.fromRGB(200, 100, 255)
execBtn.Text = "▶ EXECUTAR"
execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBold
execBtn.Parent = btnFrame
local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 8)
execCorner.Parent = execBtn

local huntBtn = Instance.new("TextButton")
huntBtn.Size = UDim2.new(0.3, -3, 1, 0)
huntBtn.Position = UDim2.new(0.38, 3, 0, 0)
huntBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
huntBtn.BackgroundTransparency = 0.1
huntBtn.BorderSizePixel = 2
huntBtn.BorderColor3 = Color3.fromRGB(255, 200, 100)
huntBtn.Text = "🎯 HUNT"
huntBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
huntBtn.TextScaled = true
huntBtn.Font = Enum.Font.GothamBold
huntBtn.Parent = btnFrame
local huntCorner = Instance.new("UICorner")
huntCorner.CornerRadius = UDim.new(0, 8)
huntCorner.Parent = huntBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.32, -3, 1, 0)
clearBtn.Position = UDim2.new(0.68, 3, 0, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 100)
clearBtn.BackgroundTransparency = 0.1
clearBtn.BorderSizePixel = 1
clearBtn.BorderColor3 = Color3.fromRGB(150, 100, 200)
clearBtn.Text = "↺ LIMPAR"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextScaled = true
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Parent = btnFrame
local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 8)
clearCorner.Parent = clearBtn

local autoFrame = Instance.new("Frame")
autoFrame.Size = UDim2.new(1, -16, 0, btnHeight)
autoFrame.Position = UDim2.new(0, 8, 1, -(btnHeight * 2 + 15))
autoFrame.BackgroundTransparency = 1
autoFrame.Parent = frame

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1, 0, 1, 0)
autoBtn.Position = UDim2.new(0, 0, 0, 0)
autoBtn.BackgroundColor3 = savedData.autoEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(80, 60, 100)
autoBtn.BackgroundTransparency = 0.1
autoBtn.BorderSizePixel = 2
autoBtn.BorderColor3 = savedData.autoEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(150, 100, 200)
autoBtn.Text = savedData.autoEnabled and "🔁 AUTO: ON" or "🔁 AUTO: OFF"
autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBtn.TextScaled = true
autoBtn.Font = Enum.Font.GothamBold
autoBtn.Parent = autoFrame
local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 8)
autoCorner.Parent = autoBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 22)
statusLabel.Position = UDim2.new(0, 8, 1, -(btnHeight + 10))
statusLabel.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
statusLabel.BackgroundTransparency = 0.85
statusLabel.BorderSizePixel = 1
statusLabel.BorderColor3 = Color3.fromRGB(200, 100, 255)
statusLabel.Text = savedData.autoEnabled and "⏳ Auto ATIVADO" or "◆ Nenhum selecionado"
statusLabel.TextColor3 = savedData.autoEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- ============================================
-- FUNÇÃO AUTO EXECUTE
-- ============================================
local autoRunning = false
local autoTimerThread = nil

local function executeSelectedScript()
    if #selecionados == 0 then
        return false
    end
    
    local scriptId = selecionados[1]
    local scriptData = nil
    for _, s in ipairs(scripts) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    
    if not scriptData then
        return false
    end
    
    if scriptData.isMaintenance then
        scriptData.load()
        return false
    end
    
    local isAvailable = false
    for _, avail in ipairs(availableScripts) do
        if avail.id == scriptData.id then
            isAvailable = true
            break
        end
    end
    
    if not isAvailable then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "🔒 Script bloqueado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return false
    end
    
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "▶ " .. scriptData.name
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    local success, err = pcall(function()
        if type(scriptData.load) == "function" then
            scriptData.load()
        else
            local func = loadstring(scriptData.load)
            if func then func() end
        end
    end)
    
    if success then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "✅ " .. scriptData.name
            statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        end
    else
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "❌ Erro!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
    
    return success
end

local function startAutoCountdown()
    if not savedData.autoEnabled or #selecionados == 0 then
        return false
    end
    
    if autoRunning then
        return false
    end
    
    local scriptId = selecionados[1]
    local scriptData = nil
    for _, s in ipairs(scripts) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    
    if not scriptData then
        autoRunning = false
        return false
    end
    
    if scriptData.isMaintenance then
        scriptData.load()
        autoRunning = false
        return false
    end
    
    local isAvailable = false
    for _, avail in ipairs(availableScripts) do
        if avail.id == scriptId then
            isAvailable = true
            break
        end
    end
    
    if not isAvailable then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "🔒 Bloqueado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return false
    end
    
    autoRunning = true
    
    local timer = 5
    
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "⏳ " .. scriptData.name .. " em " .. timer .. "s"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    if autoTimerThread then
        coroutine.close(autoTimerThread)
        autoTimerThread = nil
    end
    
    autoTimerThread = task.spawn(function()
        while timer > 0 and savedData.autoEnabled and #selecionados > 0 do
            wait(1)
            timer = timer - 1
            if timer > 0 and #selecionados > 0 then
                if statusLabel and statusLabel.Parent then
                    statusLabel.Text = "⏳ " .. scriptData.name .. " em " .. timer .. "s"
                end
            end
        end
        
        if savedData.autoEnabled and #selecionados > 0 and timer == 0 then
            executeSelectedScript()
            wait(1)
            if gui then gui:Destroy() end
        end
        
        autoRunning = false
        autoTimerThread = nil
    end)
    
    return true
end

autoBtn.MouseButton1Click:Connect(function()
    savedData.autoEnabled = not savedData.autoEnabled
    
    if savedData.autoEnabled then
        autoBtn.Text = "🔁 AUTO: ON"
        autoBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        autoBtn.BorderColor3 = Color3.fromRGB(50, 255, 50)
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "⏳ Auto ATIVADO - Selecione um script"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        
        if #selecionados > 0 then
            local scriptId = selecionados[1]
            local scriptData = nil
            for _, s in ipairs(scripts) do
                if s.id == scriptId then
                    scriptData = s
                    break
                end
            end
            if scriptData and scriptData.isMaintenance then
                scriptData.load()
            else
                startAutoCountdown()
            end
        end
    else
        autoBtn.Text = "🔁 AUTO: OFF"
        autoBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 100)
        autoBtn.BorderColor3 = Color3.fromRGB(150, 100, 200)
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "◆ Auto DESATIVADO"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        autoRunning = false
        if autoTimerThread then
            coroutine.close(autoTimerThread)
            autoTimerThread = nil
        end
    end
    
    pcall(function()
        getfenv()._G.BloxFruitsMenuData = {
            autoScriptId = #selecionados > 0 and selecionados[1] or nil,
            autoEnabled = savedData.autoEnabled
        }
    end)
end)

clearBtn.MouseButton1Click:Connect(function()
    autoRunning = false
    if autoTimerThread then
        coroutine.close(autoTimerThread)
        autoTimerThread = nil
    end
    
    for _, id in ipairs(selecionados) do
        local cb = botoesCheck[id]
        local linhaInfo = linhas[id]
        if cb then
            cb.Text = "☐"
            cb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            cb.BorderColor3 = Color3.fromRGB(200, 150, 255)
        end
        if linhaInfo and linhaInfo.row and linhaInfo.isAvailable then
            linhaInfo.row.BackgroundColor3 = linhaInfo.corBase
        end
    end
    selecionados = {}
    if statusLabel and statusLabel.Parent then
        if savedData.autoEnabled then
            statusLabel.Text = "⏳ Auto: Aguardando..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        else
            statusLabel.Text = "◆ Seleção limpa"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    pcall(function()
        getfenv()._G.BloxFruitsMenuData = {
            autoScriptId = nil,
            autoEnabled = savedData.autoEnabled
        }
    end)
end)

local executando = false

local function runScript(scriptData)
    if scriptData.isMaintenance then
        scriptData.load()
        return
    end
    
    local isAvailable = false
    for _, avail in ipairs(availableScripts) do
        if avail.id == scriptData.id then
            isAvailable = true
            break
        end
    end
    
    if not isAvailable then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "🔒 Bloqueado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    task.spawn(function()
        pcall(function()
            if type(scriptData.load) == "function" then
                scriptData.load()
            else
                local func = loadstring(scriptData.load)
                if func then func() end
            end
        end)
    end)
end

execBtn.MouseButton1Click:Connect(function()
    if executando then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "⏳ Aguarde..."
        end
        return
    end
    if #selecionados == 0 then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "⚠️ Nenhum selecionado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        end
        return
    end
    
    local scriptId = selecionados[1]
    local scriptData = nil
    for _, s in ipairs(scripts) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    if scriptData and scriptData.isMaintenance then
        scriptData.load()
        return
    end
    
    autoRunning = false
    if autoTimerThread then
        coroutine.close(autoTimerThread)
        autoTimerThread = nil
    end
    
    executando = true
    execBtn.Text = "◉ EXEC..."
    execBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "⏳ Executando..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    local total = #selecionados
    local atual = 0
    local blockedCount = 0
    
    for _, id in ipairs(selecionados) do
        for _, data in ipairs(scripts) do
            if data.id == id then
                local isAvailable = false
                for _, avail in ipairs(availableScripts) do
                    if avail.id == data.id then
                        isAvailable = true
                        break
                    end
                end
                
                if not isAvailable then
                    blockedCount = blockedCount + 1
                elseif data.isMaintenance then
                    data.load()
                    blockedCount = blockedCount + 1
                else
                    atual = atual + 1
                    if statusLabel and statusLabel.Parent then
                        statusLabel.Text = "▶ [" .. atual .. "/" .. (total - blockedCount) .. "] " .. data.name
                    end
                    runScript(data)
                    wait(1.5)
                end
            end
        end
    end
    
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "✅ Concluído!"
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    execBtn.Text = "✓ OK"
    execBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    executando = false
    task.wait(1)
    if gui then gui:Destroy() end
end)

huntBtn.MouseButton1Click:Connect(function()
    if executando then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "⏳ Aguarde..."
        end
        return
    end
    
    autoRunning = false
    if autoTimerThread then
        coroutine.close(autoTimerThread)
        autoTimerThread = nil
    end
    
    local huntData = nil
    for _, d in ipairs(scripts) do
        if d.id == 5 then huntData = d end
    end
    
    if not huntData then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "❌ Hunt não encontrado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        return
    end
    
    executando = true
    huntBtn.Text = "◉..."
    huntBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "🎯 Hunt Hub..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    task.spawn(function()
        local ok, err = pcall(function()
            if type(huntData.load) == "function" then
                huntData.load()
            else
                local func = loadstring(huntData.load)
                if func then func() end
            end
        end)
        
        if ok then
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = "✅ Hunt Hub OK!"
                statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
            end
            huntBtn.Text = "✓"
            huntBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = "❌ Erro no Hunt!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
            huntBtn.Text = "❌"
            huntBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
        
        wait(2)
        huntBtn.Text = "🎯 HUNT"
        huntBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        executando = false
        task.wait(1)
        if gui then gui:Destroy() end
    end)
end)

if savedData.autoEnabled and #selecionados > 0 then
    local scriptId = selecionados[1]
    local scriptData = nil
    for _, s in ipairs(scripts) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    if scriptData and scriptData.isMaintenance then
        scriptData.load()
    else
        startAutoCountdown()
    end
end

print("✅ Menu Multi-Jogos carregado! (Mobile Otimizado)")
print("🎮 Jogo: " .. currentGame.name)
print("📱 Mobile: " .. (isMobile and "Sim" or "Não"))
print("📜 Scripts disponíveis: " .. #availableScripts)
