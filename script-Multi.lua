-- Menu Multi-Jogos - Mk_gaming (Adaptado para Mobile)
-- Detecta o jogo atual e libera apenas os scripts compatíveis

local player = game.Players.LocalPlayer
if not player then repeat wait() until game.Players.LocalPlayer end
repeat wait() until game:IsLoaded()

-- ============================================
-- DETECTAR SE É MOBILE
-- ============================================
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================
-- ADAPTAR TAMANHO À TELA DO DISPOSITIVO
-- ============================================
local camera = workspace.CurrentCamera
local viewportSize = camera.ViewportSize
local screenW = viewportSize.X
local screenH = viewportSize.Y

-- Calcula tamanho baseado na tela (nunca maior que 95% da tela)
local MENU_WIDTH = isMobile 
    and math.clamp(screenW * 0.92, 280, 380) 
    or 420
local MENU_HEIGHT = isMobile 
    and math.clamp(screenH * 0.75, 380, 560) 
    or 620

-- Tamanhos de linha adaptáveis (menores no mobile)
local ROW_HEIGHT = isMobile and math.clamp(MENU_HEIGHT * 0.075, 34, 44) or 38
local ROW_SPACING = ROW_HEIGHT + (isMobile and 4 or 6)

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
-- FUNÇÃO PARA MOSTRAR AVISO DE MANUTENÇÃO
-- ============================================
local function showMaintenanceNotice(scriptName, reason)
    local noticeGui = Instance.new("ScreenGui")
    noticeGui.Name = "MaintenanceNotice"
    noticeGui.ResetOnSpawn = false
    noticeGui.Parent = player.PlayerGui
    
    local noticeWidth = isMobile and math.clamp(screenW * 0.8, 260, 320) or 400
    local noticeHeight = isMobile and math.clamp(screenH * 0.25, 140, 180) or 200
    
    local noticeFrame = Instance.new("Frame")
    noticeFrame.Size = UDim2.new(0, noticeWidth, 0, noticeHeight)
    noticeFrame.Position = UDim2.new(0.5, -noticeWidth/2, 0.5, -noticeHeight/2)
    noticeFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    noticeFrame.BackgroundTransparency = 0.1
    noticeFrame.BorderSizePixel = 2
    noticeFrame.BorderColor3 = Color3.fromRGB(255, 200, 50)
    noticeFrame.Parent = noticeGui
    
    local noticeCorner = Instance.new("UICorner")
    noticeCorner.CornerRadius = UDim.new(0, 16)
    noticeCorner.Parent = noticeFrame
    
    local noticeIcon = Instance.new("TextLabel")
    noticeIcon.Size = UDim2.new(0, 40, 0, 40)
    noticeIcon.Position = UDim2.new(0.5, -20, 0, 8)
    noticeIcon.BackgroundTransparency = 1
    noticeIcon.Text = reason and "⚠️" or "🔧"
    noticeIcon.TextColor3 = Color3.fromRGB(255, 200, 50)
    noticeIcon.TextScaled = true
    noticeIcon.Font = Enum.Font.GothamBold
    noticeIcon.Parent = noticeFrame
    
    local noticeTitle = Instance.new("TextLabel")
    noticeTitle.Size = UDim2.new(1, -30, 0, 22)
    noticeTitle.Position = UDim2.new(0, 15, 0, 52)
    noticeTitle.BackgroundTransparency = 1
    noticeTitle.Text = "⚠️ SCRIPT EM MANUTENÇÃO"
    noticeTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
    noticeTitle.TextScaled = true
    noticeTitle.Font = Enum.Font.GothamBold
    noticeTitle.Parent = noticeFrame
    
    local noticeMsg = Instance.new("TextLabel")
    noticeMsg.Size = UDim2.new(1, -30, 0, 20)
    noticeMsg.Position = UDim2.new(0, 15, 0, 78)
    noticeMsg.BackgroundTransparency = 1
    noticeMsg.Text = "🔄 " .. scriptName .. " está em manutenção."
    noticeMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
    noticeMsg.TextScaled = true
    noticeMsg.Font = Enum.Font.Gotham
    noticeMsg.Parent = noticeFrame
    
    if reason then
        local reasonLabel = Instance.new("TextLabel")
        reasonLabel.Size = UDim2.new(1, -30, 0, 20)
        reasonLabel.Position = UDim2.new(0, 15, 0, 100)
        reasonLabel.BackgroundTransparency = 1
        reasonLabel.Text = reason
        reasonLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        reasonLabel.TextScaled = true
        reasonLabel.Font = Enum.Font.Gotham
        reasonLabel.Parent = noticeFrame
    end
    
    local noticeClose = Instance.new("TextButton")
    noticeClose.Size = UDim2.new(0, 100, 0, 28)
    noticeClose.Position = UDim2.new(0.5, -50, 1, -36)
    noticeClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    noticeClose.BackgroundTransparency = 0.2
    noticeClose.BorderSizePixel = 1
    noticeClose.BorderColor3 = Color3.fromRGB(255, 100, 100)
    noticeClose.Text = "✕ FECHAR"
    noticeClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    noticeClose.TextScaled = true
    noticeClose.Font = Enum.Font.GothamBold
    noticeClose.Parent = noticeFrame
    
    local noticeCloseCorner = Instance.new("UICorner")
    noticeCloseCorner.CornerRadius = UDim.new(0, 8)
    noticeCloseCorner.Parent = noticeClose
    
    noticeClose.MouseButton1Click:Connect(function()
        noticeGui:Destroy()
    end)
    
    task.wait(5)
    if noticeGui and noticeGui.Parent then
        noticeGui:Destroy()
    end
end

-- ============================================
-- LISTA DE SCRIPTS (mantida igual)
-- ============================================
local scripts = {
    -- ===== BLOX FRUITS =====
    { 
        id = 1, 
        name = "Quantum Onyx", 
        game = "Blox Fruits",
        key = false, 
        desc = "✅ Atualizado • Key",
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
        desc = "ESP • Speed • PvP",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))()' 
    },
    { 
        id = 4, 
        name = "Cokka Hub", 
        game = "Blox Fruits",
        key = true, 
        desc = "Mobile • Auto Farm",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua"))()' 
    },
    { 
        id = 5, 
        name = "Hunt Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "ComandoGame • Atualizado",
        load = 'loadstring(game:HttpGet("https://github.com/ComandoGame/ComandoGame/raw/ComandoGame/Hunt%20hub.lua"))()',
        autoClose = true
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
        desc = "Auto Farm • Hop",
        load = 'loadstring(game:HttpGet("https://github.com/WhiteX1208/Scripts/blob/main/HopScript.luau?raw=true"))()' 
    },
    { 
        id = 16, 
        name = "Teddy Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Farm • Quest",
        load = 'repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))()' 
    },
    { 
        id = 17, 
        name = "Redz Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Farm • Raid",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/UCT-hub/main/refs/heads/main/redz-v2"))()' 
    },
    { 
        id = 19, 
        name = "Tsuo Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "⚠️ PESADO - FPS baixo",
        load = function()
            showMaintenanceNotice("Tsuo Hub", "⚠️ Script pesado causa instabilidade de FPS.")
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
        desc = "⚔️ Bounty • PvP",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/JustParadozCode/CentuDox-Hub/refs/heads/main/CentuDox-Pvp.xyz"))()' 
    },
    { 
        id = 18, 
        name = "Quantum Onyx (Dungeon)", 
        game = "Blox Fruits (Masmorras)",
        key = false, 
        desc = "✅ Atualizado • Único",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()' 
    },
    { 
        id = 11, 
        name = "Blitz ModMenu", 
        game = "Universal",
        key = false, 
        desc = "Fly • Aimbot • ESP",
        load = 'loadstring(game:HttpGet("https://pastebin.com/raw/mF6iNG8C"))()' 
    },
    { 
        id = 12, 
        name = "Horror Elevador", 
        game = "Horror Elevador",
        key = false, 
        desc = "Coleta • GodMode",
        load = 'loadstring(game:HttpGet("https://pastebin.com/raw/MDjMhyrA"))()' 
    },
    { 
        id = 13, 
        name = "Knockback Battles", 
        game = "Knockback Battles",
        key = false, 
        desc = "🔄 EM UPDATE",
        load = function()
            local updateGui = Instance.new("ScreenGui")
            updateGui.Name = "UpdateNotice"
            updateGui.ResetOnSpawn = false
            updateGui.Parent = game.Players.LocalPlayer.PlayerGui
            
            local updateFrame = Instance.new("Frame")
            updateFrame.Size = UDim2.new(0, isMobile and math.clamp(screenW * 0.8, 260, 320) or 400, 0, isMobile and 130 or 150)
            updateFrame.Position = UDim2.new(0.5, -(isMobile and math.clamp(screenW * 0.4, 130, 160) or 200), 0.5, -(isMobile and 65 or 75))
            updateFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
            updateFrame.BackgroundTransparency = 0.1
            updateFrame.BorderSizePixel = 2
            updateFrame.BorderColor3 = Color3.fromRGB(255, 200, 50)
            updateFrame.Parent = updateGui
            
            local updateCorner = Instance.new("UICorner")
            updateCorner.CornerRadius = UDim.new(0, 16)
            updateCorner.Parent = updateFrame
            
            local updateTitle = Instance.new("TextLabel")
            updateTitle.Size = UDim2.new(1, 0, 0, 30)
            updateTitle.Position = UDim2.new(0, 0, 0, 10)
            updateTitle.BackgroundTransparency = 1
            updateTitle.Text = "🔧 SCRIPT EM UPDATE"
            updateTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
            updateTitle.TextScaled = true
            updateTitle.Font = Enum.Font.GothamBold
            updateTitle.Parent = updateFrame
            
            local updateMsg = Instance.new("TextLabel")
            updateMsg.Size = UDim2.new(1, -30, 0, 22)
            updateMsg.Position = UDim2.new(0, 15, 0, 45)
            updateMsg.BackgroundTransparency = 1
            updateMsg.Text = "🔄 Knockback Battles em atualização."
            updateMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
            updateMsg.TextScaled = true
            updateMsg.Font = Enum.Font.Gotham
            updateMsg.Parent = updateFrame
            
            local updateClose = Instance.new("TextButton")
            updateClose.Size = UDim2.new(0, 90, 0, 28)
            updateClose.Position = UDim2.new(0.5, -45, 1, -36)
            updateClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            updateClose.BackgroundTransparency = 0.2
            updateClose.BorderSizePixel = 1
            updateClose.BorderColor3 = Color3.fromRGB(255, 100, 100)
            updateClose.Text = "✕ FECHAR"
            updateClose.TextColor3 = Color3.fromRGB(255, 255, 255)
            updateClose.TextScaled = true
            updateClose.Font = Enum.Font.GothamBold
            updateClose.Parent = updateFrame
            
            local updateCloseCorner = Instance.new("UICorner")
            updateCloseCorner.CornerRadius = UDim.new(0, 8)
            updateCloseCorner.Parent = updateClose
            
            updateClose.MouseButton1Click:Connect(function()
                updateGui:Destroy()
            end)
            
            task.wait(5)
            if updateGui and updateGui.Parent then
                updateGui:Destroy()
            end
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
-- CRIAÇÃO DA GUI (RESPONSIVA E ADAPTATIVA)
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptMenu"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT)
frame.Position = UDim2.new(0.5, -MENU_WIDTH/2, 0.5, -MENU_HEIGHT/2)
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
-- HEADER (compacto no mobile)
-- ============================================
local HEADER_HEIGHT = isMobile and 38 or 45
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
header.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
header.Parent = frame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦ MULTI-GAME ✦"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -30, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 60)
closeBtn.BackgroundTransparency = 0.2
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function() 
    if gui then gui:Destroy() end
end)

-- ============================================
-- INFO DO JOGO E JOGADOR (compacto no mobile)
-- ============================================
local INFO_HEIGHT = isMobile and 42 or 60
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -12, 0, INFO_HEIGHT)
infoFrame.Position = UDim2.new(0, 6, 0, HEADER_HEIGHT + 4)
infoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
infoFrame.BackgroundTransparency = 0.9
infoFrame.BorderSizePixel = 1
infoFrame.BorderColor3 = Color3.fromRGB(150, 50, 255)
infoFrame.Parent = frame
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local nomeLabel = Instance.new("TextLabel")
nomeLabel.Size = UDim2.new(0.5, -8, 0, isMobile and 12 or 16)
nomeLabel.Position = UDim2.new(0, 6, 0, 2)
nomeLabel.BackgroundTransparency = 1
nomeLabel.Text = "👤 " .. player.Name
nomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nomeLabel.TextScaled = true
nomeLabel.Font = Enum.Font.GothamSemibold
nomeLabel.TextXAlignment = Enum.TextXAlignment.Left
nomeLabel.Parent = infoFrame

local gameLabel = Instance.new("TextLabel")
gameLabel.Size = UDim2.new(0.5, -8, 0, isMobile and 12 or 16)
gameLabel.Position = UDim2.new(0.5, 2, 0, 2)
gameLabel.BackgroundTransparency = 1
gameLabel.Text = "🎮 " .. currentGame.name
gameLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
gameLabel.TextScaled = true
gameLabel.Font = Enum.Font.GothamBold
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.Parent = infoFrame

local statusGame = Instance.new("TextLabel")
statusGame.Size = UDim2.new(1, -12, 0, isMobile and 12 or 16)
statusGame.Position = UDim2.new(0, 6, 0, isMobile and 16 or 20)
statusGame.BackgroundTransparency = 1
statusGame.Text = "📜 " .. #availableScripts .. " scripts disponíveis • ID: " .. currentGame.id
statusGame.TextColor3 = Color3.fromRGB(255, 200, 100)
statusGame.TextScaled = true
statusGame.Font = Enum.Font.Gotham
statusGame.TextXAlignment = Enum.TextXAlignment.Left
statusGame.Parent = infoFrame

-- Nível (só mostra se existir, para não ocupar espaço)
local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(1, -12, 0, isMobile and 12 or 16)
levelLabel.Position = UDim2.new(0, 6, 0, isMobile and 28 or 38)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "📊 Nível: --"
levelLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
levelLabel.TextScaled = true
levelLabel.Font = Enum.Font.Gotham
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = infoFrame
levelLabel.Visible = not isMobile -- Esconde no mobile para economizar espaço

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
-- ÁREA DE SCRIPTS (ocupa o espaço restante)
-- ============================================
local BOTTOM_SECTION_HEIGHT = isMobile and 110 or 145
local SCRIPT_AREA_TOP = HEADER_HEIGHT + INFO_HEIGHT + 8
local SCRIPT_AREA_HEIGHT = MENU_HEIGHT - SCRIPT_AREA_TOP - BOTTOM_SECTION_HEIGHT

local scriptArea = Instance.new("ScrollingFrame")
scriptArea.Size = UDim2.new(1, -12, 0, SCRIPT_AREA_HEIGHT)
scriptArea.Position = UDim2.new(0, 6, 0, SCRIPT_AREA_TOP)
scriptArea.BackgroundTransparency = 1
scriptArea.ScrollBarThickness = isMobile and 3 or 4
scriptArea.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)
scriptArea.BorderSizePixel = 0
scriptArea.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptArea.Parent = frame

-- Layout automático com UIListLayout
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, isMobile and 4 or 6)
listLayout.Parent = scriptArea

local selecionados = {}
local botoesCheck = {}
local linhas = {}

for i, data in ipairs(scripts) do
    local isAvailable = false
    for _, avail in ipairs(availableScripts) do
        if avail.id == data.id then
            isAvailable = true
            break
        end
    end
    
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, ROW_HEIGHT)
    row.Position = UDim2.new(0, 0, 0, 0)
    row.LayoutOrder = i
    
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

    -- Checkbox
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, isMobile and 22 or 20, 0, isMobile and 22 or 20)
    cb.Position = UDim2.new(0, 6, 0.5, isMobile and -11 or -10)
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
                -- Desmarca todos os outros (seleção única)
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
    
    -- Nome do script (ajustado para mobile)
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.55, -34, 0, isMobile and 14 or 16)
    nameLbl.Position = UDim2.new(0, 34, 0, 2)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = data.name
    if data.isMaintenance or data.id == 13 then
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

    -- Descrição (embaixo do nome)
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(0.85, -34, 0, isMobile and 11 or 13)
    descLbl.Position = UDim2.new(0, 34, 0, isMobile and 16 or 19)
    descLbl.BackgroundTransparency = 1
    if data.isMaintenance then
        descLbl.Text = "⏳ Aguarde..."
        descLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    elseif data.id == 13 then
        descLbl.Text = "🔧 Atualizando..."
        descLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    elseif data.id == 18 then
        descLbl.Text = "✅ Atualizado"
        descLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        descLbl.Text = data.desc
        descLbl.TextColor3 = isAvailable and Color3.fromRGB(180, 180, 200) or Color3.fromRGB(100, 100, 100)
    end
    descLbl.TextScaled = true
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = row

    -- Ícone de chave (lado direito)
    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(0, 22, 0, isMobile and 22 or 20)
    keyLbl.Position = UDim2.new(1, -28, 0.5, isMobile and -11 or -10)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = data.key and "🔑" or "✓"
    if data.isMaintenance or data.id == 13 then
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

-- Ajusta o canvas após criar todos os itens
scriptArea.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)

-- Atualiza canvas quando o layout mudar
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scriptArea.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- ============================================
-- BOTÕES INFERIORES (layout compacto)
-- ============================================
local BTN_HEIGHT = isMobile and 30 or 32
local BTN_GAP = isMobile and 4 or 6

-- Frame que agrupa todos os botões inferiores
local bottomFrame = Instance.new("Frame")
bottomFrame.Size = UDim2.new(1, -12, 0, BOTTOM_SECTION_HEIGHT)
bottomFrame.Position = UDim2.new(0, 6, 1, -BOTTOM_SECTION_HEIGHT - 4)
bottomFrame.BackgroundTransparency = 1
bottomFrame.Parent = frame

-- Linha 1: EXECUTAR + HUNT + LIMPAR
local row1 = Instance.new("Frame")
row1.Size = UDim2.new(1, 0, 0, BTN_HEIGHT)
row1.Position = UDim2.new(0, 0, 0, 0)
row1.BackgroundTransparency = 1
row1.Parent = bottomFrame

-- EXECUTAR (60% da largura)
local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0.55, -BTN_GAP, 1, 0)
execBtn.Position = UDim2.new(0, 0, 0, 0)
execBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
execBtn.BackgroundTransparency = 0.1
execBtn.BorderSizePixel = 2
execBtn.BorderColor3 = Color3.fromRGB(200, 100, 255)
execBtn.Text = "▶ EXECUTAR"
execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBold
execBtn.Parent = row1
local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 8)
execCorner.Parent = execBtn

-- HUNT (restante)
local huntBtn = Instance.new("TextButton")
huntBtn.Size = UDim2.new(0.45, -BTN_GAP, 1, 0)
huntBtn.Position = UDim2.new(0.55, BTN_GAP, 0, 0)
huntBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
huntBtn.BackgroundTransparency = 0.1
huntBtn.BorderSizePixel = 2
huntBtn.BorderColor3 = Color3.fromRGB(255, 200, 100)
huntBtn.Text = "🎯 HUNT"
huntBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
huntBtn.TextScaled = true
huntBtn.Font = Enum.Font.GothamBold
huntBtn.Parent = row1
local huntCorner = Instance.new("UICorner")
huntCorner.CornerRadius = UDim.new(0, 8)
huntCorner.Parent = huntBtn

-- Linha 2: LIMPAR + AUTO
local row2 = Instance.new("Frame")
row2.Size = UDim2.new(1, 0, 0, BTN_HEIGHT)
row2.Position = UDim2.new(0, 0, 0, BTN_HEIGHT + BTN_GAP)
row2.BackgroundTransparency = 1
row2.Parent = bottomFrame

-- LIMPAR
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.35, -BTN_GAP, 1, 0)
clearBtn.Position = UDim2.new(0, 0, 0, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 100)
clearBtn.BackgroundTransparency = 0.1
clearBtn.BorderSizePixel = 1
clearBtn.BorderColor3 = Color3.fromRGB(150, 100, 200)
clearBtn.Text = "↺ LIMPAR"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextScaled = true
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Parent = row2
local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 8)
clearCorner.Parent = clearBtn

-- AUTO
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0.65, -BTN_GAP, 1, 0)
autoBtn.Position = UDim2.new(0.35, BTN_GAP, 0, 0)
autoBtn.BackgroundColor3 = savedData.autoEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(80, 60, 100)
autoBtn.BackgroundTransparency = 0.1
autoBtn.BorderSizePixel = 2
autoBtn.BorderColor3 = savedData.autoEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(150, 100, 200)
autoBtn.Text = savedData.autoEnabled and "🔁 AUTO: ON" or "🔁 AUTO: OFF"
autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBtn.TextScaled = true
autoBtn.Font = Enum.Font.GothamBold
autoBtn.Parent = row2
local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 8)
autoCorner.Parent = autoBtn

-- Label de status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, isMobile and 20 or 22)
statusLabel.Position = UDim2.new(0, 0, 0, (BTN_HEIGHT + BTN_GAP) * 2)
statusLabel.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
statusLabel.BackgroundTransparency = 0.85
statusLabel.BorderSizePixel = 1
statusLabel.BorderColor3 = Color3.fromRGB(200, 100, 255)
statusLabel.Text = savedData.autoEnabled and "⏳ Auto Execute ATIVADO" or "◆ Nenhum script selecionado"
statusLabel.TextColor3 = savedData.autoEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = bottomFrame
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
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
        statusLabel.Text = "▶ Executando " .. scriptData.name .. " (Auto)..."
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
            statusLabel.Text = "✅ " .. scriptData.name .. " executado!"
            statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        end
    else
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "❌ Erro: " .. tostring(err):sub(1, 30)
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
            statusLabel.Text = "🔒 Script bloqueado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return false
    end
    
    autoRunning = true
    local timer = 5
    
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "⏳ Auto: " .. scriptData.name .. " em " .. timer .. "s"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    if autoTimerThread then
        pcall(function() coroutine.close(autoTimerThread) end)
        autoTimerThread = nil
    end
    
    autoTimerThread = task.spawn(function()
        while timer > 0 and savedData.autoEnabled and #selecionados > 0 do
            wait(1)
            timer = timer - 1
            if timer > 0 and #selecionados > 0 then
                if statusLabel and statusLabel.Parent then
                    statusLabel.Text = "⏳ Auto: " .. scriptData.name .. " em " .. timer .. "s"
                end
            end
        end
        
        if savedData.autoEnabled and #selecionados > 0 and timer == 0 then
            executeSelectedScript()
            wait(1)
            if gui and gui.Parent then gui:Destroy() end
        end
        
        autoRunning = false
        autoTimerThread = nil
    end)
    
    return true
end

-- ============================================
-- EVENTOS DOS BOTÕES
-- ============================================
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
            statusLabel.Text = "◆ Auto Execute DESATIVADO"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        autoRunning = false
        if autoTimerThread then
            pcall(function() coroutine.close(autoTimerThread) end)
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
        pcall(function() coroutine.close(autoTimerThread) end)
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
            statusLabel.Text = "⏳ Auto: Aguardando seleção..."
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
    
    return true
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
            statusLabel.Text = "⚠️ Nenhum script selecionado!"
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
        pcall(function() coroutine.close(autoTimerThread) end)
        autoTimerThread = nil
    end
    
    executando = true
    execBtn.Text = "◉ EXECUTANDO..."
    execBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "⏳ Executando..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    local total = #selecionados
    local atual = 0
    local blockedCount = 0
    local shouldAutoClose = false
    
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
                    if statusLabel and statusLabel.Parent then
                        statusLabel.Text = "🔒 " .. data.name .. " bloqueado!"
                        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    end
                    wait(0.5)
                elseif data.isMaintenance then
                    data.load()
                    blockedCount = blockedCount + 1
                else
                    atual = atual + 1
                    if statusLabel and statusLabel.Parent then
                        statusLabel.Text = "▶ [" .. atual .. "/" .. (total - blockedCount) .. "] " .. data.name
                    end
                    
                    if data.autoClose then
                        shouldAutoClose = true
                    end
                    
                    runScript(data)
                    wait(1.5)
                end
            end
        end
    end
    
    if statusLabel and statusLabel.Parent then
        if blockedCount > 0 then
            statusLabel.Text = "✅ Concluído! (" .. blockedCount .. " bloqueados)"
        else
            statusLabel.Text = "✅ Concluído!"
        end
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    execBtn.Text = "✓ FINALIZADO"
    execBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    executando = false
    
    wait(1)
    if gui and gui.Parent then gui:Destroy() end
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
        pcall(function() coroutine.close(autoTimerThread) end)
        autoTimerThread = nil
    end
    
    local huntAvailable = false
    for _, avail in ipairs(availableScripts) do
        if avail.id == 5 then
            huntAvailable = true
            break
        end
    end
    
    if not huntAvailable then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "🔒 Hunt Hub bloqueado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    executando = true
    huntBtn.Text = "◉ CARREGANDO..."
    huntBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "🎯 Carregando Hunt Hub..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    local huntData = nil
    for _, d in ipairs(scripts) do
        if d.id == 5 then huntData = d end
    end
    
    if huntData then
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
                    statusLabel.Text = "✅ Hunt Hub executado!"
                    statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
                end
                huntBtn.Text = "✓ OK"
                huntBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            else
                if statusLabel and statusLabel.Parent then
                    statusLabel.Text = "❌ Erro: " .. tostring(err):sub(1, 30)
                    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                huntBtn.Text = "❌ ERRO"
                huntBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
            
            wait(1)
            executando = false
            
            if gui and gui.Parent then gui:Destroy() end
        end)
    else
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "❌ Hunt Hub não encontrado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        executando = false
    end
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

print("✅ Menu Multi-Jogos carregado! (Mk_gaming)")
print("📱 Modo Mobile: " .. (isMobile and "ATIVADO" or "DESATIVADO"))
print("📐 Tamanho: " .. MENU_WIDTH .. "x" .. MENU_HEIGHT .. " (Tela: " .. screenW .. "x" .. screenH .. ")")
print("🎮 Jogo atual: " .. currentGame.name .. " (ID: " .. currentGame.id .. ")")
print("📜 " .. #scripts .. " scripts total, " .. #availableScripts .. " disponíveis")
print("🔁 Auto Execute: " .. (savedData.autoEnabled and "ON" or "OFF"))
