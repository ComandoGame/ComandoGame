-- Menu Multi-Jogos - Mk_gaming (Nukermode Style + ScriptsDoDev + Version)
-- Detecta o jogo atual e libera apenas os scripts compatíveis
-- ✅ Fecha automaticamente após executar qualquer script

local player = game.Players.LocalPlayer
if not player then repeat wait() until game.Players.LocalPlayer end
repeat wait() until game:IsLoaded()

-- ============================================
-- DETECTAR SE É MOBILE
-- ============================================
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Configurações de tamanho adaptáveis (estilo Nukermode)
local MENU_WIDTH = isMobile and 360 or 620
local MENU_HEIGHT = isMobile and 420 or 400
local SIDEBAR_WIDTH = isMobile and 110 or 150
local ROW_HEIGHT = isMobile and 28 or 32
local ROW_SPACING = isMobile and 32 or 36

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
    
    local noticeWidth = isMobile and 300 or 400
    local noticeHeight = isMobile and 170 or 200
    
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
    noticeIcon.Size = UDim2.new(0, 50, 0, 50)
    noticeIcon.Position = UDim2.new(0.5, -25, 0, 10)
    noticeIcon.BackgroundTransparency = 1
    noticeIcon.Text = "🔧"
    noticeIcon.TextColor3 = Color3.fromRGB(255, 200, 50)
    noticeIcon.TextScaled = true
    noticeIcon.Font = Enum.Font.GothamBold
    noticeIcon.Parent = noticeFrame
    
    local noticeTitle = Instance.new("TextLabel")
    noticeTitle.Size = UDim2.new(1, -40, 0, 25)
    noticeTitle.Position = UDim2.new(0, 20, 0, 65)
    noticeTitle.BackgroundTransparency = 1
    noticeTitle.Text = "⚠️ SCRIPT EM UPDATE"
    noticeTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
    noticeTitle.TextScaled = true
    noticeTitle.Font = Enum.Font.GothamBold
    noticeTitle.Parent = noticeFrame
    
    local noticeMsg = Instance.new("TextLabel")
    noticeMsg.Size = UDim2.new(1, -40, 0, 22)
    noticeMsg.Position = UDim2.new(0, 20, 0, 95)
    noticeMsg.BackgroundTransparency = 1
    noticeMsg.Text = "🔄 " .. scriptName .. " está em update."
    noticeMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
    noticeMsg.TextScaled = true
    noticeMsg.Font = Enum.Font.Gotham
    noticeMsg.Parent = noticeFrame
    
    if reason then
        local reasonLabel = Instance.new("TextLabel")
        reasonLabel.Size = UDim2.new(1, -40, 0, 22)
        reasonLabel.Position = UDim2.new(0, 20, 0, 118)
        reasonLabel.BackgroundTransparency = 1
        reasonLabel.Text = reason
        reasonLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        reasonLabel.TextScaled = true
        reasonLabel.Font = Enum.Font.Gotham
        reasonLabel.Parent = noticeFrame
    end
    
    local noticeClose = Instance.new("TextButton")
    noticeClose.Size = UDim2.new(0, 100, 0, 28)
    noticeClose.Position = UDim2.new(0.5, -50, 1, -38)
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
-- LISTA DE SCRIPTS POR JOGO (PÁGINA: SCRIPTS)
-- ============================================
local scripts = {
    -- ===== BLOX FRUITS =====
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
}

-- ============================================
-- SCRIPTS DO DEV (PÁGINA: ScriptsDoDev)
-- ============================================
local devScripts = {
    {
        id = 100,
        name = "Blitz ModMenu",
        game = "Blitz",
        desc = "🔄 EM UPDATE • Fly • Aimbot • ESP",
        status = "update",
        load = function()
            showMaintenanceNotice("Blitz ModMenu", "🔄 Estamos atualizando para a nova versão do jogo.")
        end
    },
    {
        id = 101,
        name = "Hunt Hub",
        game = "Blox Fruits",
        desc = "🎯 Hunt Script • ComandoGame",
        status = "stable",
        isHuntHub = true,
        load = 'loadstring(game:HttpGet("https://github.com/ComandoGame/ComandoGame/raw/ComandoGame/Hunt%20hub.lua"))()',
        autoClose = true
    },
    {
        id = 102,
        name = "Horror Elevador",
        game = "Horror Elevador",
        desc = "🔄 EM UPDATE • Coleta • GodMode",
        status = "update",
        load = function()
            showMaintenanceNotice("Horror Elevador", "🔄 Estamos atualizando para a nova versão do jogo.")
        end
    },
    {
        id = 103,
        name = "Knockback Battles",
        game = "Knockback Battles",
        desc = "🔄 EM UPDATE • Em breve",
        status = "update",
        load = function()
            showMaintenanceNotice("Knockback Battles", "🔄 Estamos desenvolvendo este script.")
        end
    },
    {
        id = 104,
        name = "Mk Admin Panel",
        game = "Universal",
        desc = "🛠️ Painel administrativo exclusivo",
        status = "beta",
        load = function()
            print("Mk Admin Panel carregado!")
        end
    },
    {
        id = 105,
        name = "Mk Auto Farm Pro",
        game = "Universal",
        desc = "🌾 Farm automático otimizado",
        status = "stable",
        load = function()
            print("Mk Auto Farm Pro carregado!")
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
-- CRIAÇÃO DA GUI (ESTILO NUKERMODE)
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptMenu"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT)
frame.Position = UDim2.new(0.5, -MENU_WIDTH/2, 0.5, -MENU_HEIGHT/2)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(60, 60, 60)
frame.ClipsDescendants = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- ============================================
-- HEADER (Título + Fechar)
-- ============================================
local headerHeight = isMobile and 34 or 38
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, headerHeight)
header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
header.BackgroundTransparency = 0
header.BorderSizePixel = 0
header.Parent = frame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

local headerBottomLine = Instance.new("Frame")
headerBottomLine.Size = UDim2.new(1, 0, 0, 1)
headerBottomLine.Position = UDim2.new(0, 0, 1, -1)
headerBottomLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
headerBottomLine.BorderSizePixel = 0
headerBottomLine.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Menu Multi-Jogos - Mk_gaming"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -30, 0, (headerHeight - 22) / 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
closeBtn.BackgroundTransparency = 0.1
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function() 
    if gui then gui:Destroy() end
end)

-- ============================================
-- SIDEBAR (Menu Lateral Esquerdo)
-- ============================================
local BOTTOM_BAR_HEIGHT = isMobile and 55 or 60
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -headerHeight - BOTTOM_BAR_HEIGHT)
sidebar.Position = UDim2.new(0, 0, 0, headerHeight)
sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
sidebar.BackgroundTransparency = 0
sidebar.BorderSizePixel = 0
sidebar.Parent = frame

local sidebarRightLine = Instance.new("Frame")
sidebarRightLine.Size = UDim2.new(0, 1, 1, 0)
sidebarRightLine.Position = UDim2.new(1, -1, 0, 0)
sidebarRightLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sidebarRightLine.BorderSizePixel = 0
sidebarRightLine.Parent = sidebar

-- Botões da Sidebar
local sidebarButtons = {}
local pages = {
    { id = "scripts", label = "Scripts" },
    { id = "devscripts", label = "ScriptsDoDev" },
    { id = "version", label = "Version" },
}

local currentPage = "scripts"

for i, page in ipairs(pages) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, isMobile and 30 or 34)
    btn.Position = UDim2.new(0, 6, 0, 8 + (i-1) * (isMobile and 34 or 38))
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = page.label
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local btnPadding = Instance.new("UIPadding")
    btnPadding.PaddingLeft = UDim.new(0, 10)
    btnPadding.Parent = btn
    
    btn.Name = page.id
    table.insert(sidebarButtons, { button = btn, id = page.id })
end

-- Rodapé da Sidebar (Info do jogador/jogo)
local sidebarFooter = Instance.new("Frame")
sidebarFooter.Size = UDim2.new(1, 0, 0, isMobile and 80 or 90)
sidebarFooter.Position = UDim2.new(0, 0, 1, -(isMobile and 80 or 90))
sidebarFooter.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
sidebarFooter.BackgroundTransparency = 0
sidebarFooter.BorderSizePixel = 0
sidebarFooter.Parent = sidebar

local footerLine = Instance.new("Frame")
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.Position = UDim2.new(0, 0, 0, 0)
footerLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
footerLine.BorderSizePixel = 0
footerLine.Parent = sidebarFooter

local playerLabel = Instance.new("TextLabel")
playerLabel.Size = UDim2.new(1, -12, 0, 16)
playerLabel.Position = UDim2.new(0, 6, 0, 6)
playerLabel.BackgroundTransparency = 1
playerLabel.Text = "👤 " .. player.Name
playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerLabel.TextScaled = true
playerLabel.Font = Enum.Font.GothamSemibold
playerLabel.TextXAlignment = Enum.TextXAlignment.Left
playerLabel.Parent = sidebarFooter

local gameLabel = Instance.new("TextLabel")
gameLabel.Size = UDim2.new(1, -12, 0, 14)
gameLabel.Position = UDim2.new(0, 6, 0, 24)
gameLabel.BackgroundTransparency = 1
gameLabel.Text = "🎮 " .. currentGame.name
gameLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
gameLabel.TextScaled = true
gameLabel.Font = Enum.Font.GothamBold
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.Parent = sidebarFooter

local gameIdLabel = Instance.new("TextLabel")
gameIdLabel.Size = UDim2.new(1, -12, 0, 12)
gameIdLabel.Position = UDim2.new(0, 6, 0, 40)
gameIdLabel.BackgroundTransparency = 1
gameIdLabel.Text = "🆔 " .. currentGame.id
gameIdLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
gameIdLabel.TextScaled = true
gameIdLabel.Font = Enum.Font.Gotham
gameIdLabel.TextXAlignment = Enum.TextXAlignment.Left
gameIdLabel.Parent = sidebarFooter

local statusGame = Instance.new("TextLabel")
statusGame.Size = UDim2.new(1, -12, 0, 12)
statusGame.Position = UDim2.new(0, 6, 0, 56)
statusGame.BackgroundTransparency = 1
statusGame.Text = "📜 " .. #availableScripts .. " disponíveis"
statusGame.TextColor3 = Color3.fromRGB(255, 200, 100)
statusGame.TextScaled = true
statusGame.Font = Enum.Font.Gotham
statusGame.TextXAlignment = Enum.TextXAlignment.Left
statusGame.Parent = sidebarFooter

-- ============================================
-- PAINEL DIREITO (Conteúdo das Páginas)
-- ============================================
local contentPanel = Instance.new("Frame")
contentPanel.Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, -headerHeight - BOTTOM_BAR_HEIGHT)
contentPanel.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, headerHeight)
contentPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
contentPanel.BackgroundTransparency = 0
contentPanel.BorderSizePixel = 0
contentPanel.Parent = frame

-- ============================================
-- PÁGINA 1: SCRIPTS
-- ============================================
local scriptsPage = Instance.new("Frame")
scriptsPage.Name = "scripts"
scriptsPage.Size = UDim2.new(1, 0, 1, 0)
scriptsPage.BackgroundTransparency = 1
scriptsPage.Parent = contentPanel

local scriptScroll = Instance.new("ScrollingFrame")
scriptScroll.Size = UDim2.new(1, -12, 1, -12)
scriptScroll.Position = UDim2.new(0, 6, 0, 6)
scriptScroll.BackgroundTransparency = 1
scriptScroll.ScrollBarThickness = 4
scriptScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
scriptScroll.Parent = scriptsPage

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
    row.Position = UDim2.new(0, 0, 0, (i-1) * ROW_SPACING)
    
    if data.isMaintenance then
        row.BackgroundColor3 = Color3.fromRGB(70, 55, 25)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(255, 200, 50)
        row.BorderSizePixel = 1
    elseif data.id == 18 then
        row.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(100, 255, 100)
        row.BorderSizePixel = 1
    elseif isAvailable then
        row.BackgroundColor3 = data.key and Color3.fromRGB(150, 90, 40) or Color3.fromRGB(35, 35, 42)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = data.key and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(70, 70, 80)
    else
        row.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        row.BackgroundTransparency = 0.3
        row.BorderColor3 = Color3.fromRGB(60, 60, 60)
    end
    row.BorderSizePixel = 1
    row.Parent = scriptScroll
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 5)
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
    elseif data.id == 18 then
        cb.BorderColor3 = Color3.fromRGB(100, 255, 100)
        cb.Text = "☐"
        cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif isAvailable then
        cb.BorderColor3 = Color3.fromRGB(150, 150, 200)
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

    if isAvailable and not data.isMaintenance then
        cb.MouseButton1Click:Connect(function()
            local idx = table.find(selecionados, data.id)
            if idx then
                table.remove(selecionados, idx)
                cb.Text = "☐"
                cb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                cb.BorderColor3 = Color3.fromRGB(150, 150, 200)
                row.BackgroundColor3 = data.key and Color3.fromRGB(150, 90, 40) or Color3.fromRGB(35, 35, 42)
            else
                for _, id in ipairs(selecionados) do
                    local cb2 = botoesCheck[id]
                    local row2 = linhas[id]
                    if cb2 and row2 and row2.isAvailable and not row2.isMaintenance then
                        cb2.Text = "☐"
                        cb2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        cb2.BorderColor3 = Color3.fromRGB(150, 150, 200)
                    end
                    if row2 and row2.row and row2.isAvailable and not row2.isMaintenance then
                        row2.row.BackgroundColor3 = row2.corBase
                    end
                end
                selecionados = {}
                
                table.insert(selecionados, data.id)
                cb.Text = "☑"
                cb.BackgroundColor3 = Color3.fromRGB(120, 60, 200)
                cb.BorderColor3 = Color3.fromRGB(200, 150, 255)
                row.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
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
            end
        end)
    end
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.5, -30, 0, isMobile and 14 or 16)
    nameLbl.Position = UDim2.new(0, 30, 0, 1)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = data.name
    if data.isMaintenance then
        nameLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 18 then
        nameLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        nameLbl.TextColor3 = isAvailable and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 140)
    end
    nameLbl.TextScaled = true
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = row

    local gameScriptLbl = Instance.new("TextLabel")
    gameScriptLbl.Size = UDim2.new(0.4, 0, 0, isMobile and 12 or 14)
    gameScriptLbl.Position = UDim2.new(0, 30, 0, isMobile and 15 or 17)
    gameScriptLbl.BackgroundTransparency = 1
    if data.isMaintenance then
        gameScriptLbl.Text = "🔧 MANUTENÇÃO"
        gameScriptLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 18 then
        gameScriptLbl.Text = "🗡️ DUNGEON"
        gameScriptLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        gameScriptLbl.Text = "🎮 " .. data.game
        gameScriptLbl.TextColor3 = isAvailable and Color3.fromRGB(160, 220, 160) or Color3.fromRGB(100, 100, 100)
    end
    gameScriptLbl.TextScaled = true
    gameScriptLbl.Font = Enum.Font.GothamBold
    gameScriptLbl.TextXAlignment = Enum.TextXAlignment.Left
    gameScriptLbl.Parent = row

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(0.3, 0, 0, isMobile and 12 or 14)
    descLbl.Position = UDim2.new(0.45, 5, 0, isMobile and 15 or 17)
    descLbl.BackgroundTransparency = 1
    if data.isMaintenance then
        descLbl.Text = "⏳ Aguarde..."
        descLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    elseif data.id == 18 then
        descLbl.Text = "✅ Atualizado"
        descLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        descLbl.Text = data.desc
        descLbl.TextColor3 = isAvailable and Color3.fromRGB(160, 160, 180) or Color3.fromRGB(100, 100, 100)
    end
    descLbl.TextScaled = true
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = row

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(0, 20, 1, 0)
    keyLbl.Position = UDim2.new(1, -25, 0, 0)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = data.key and "🔑" or "✓"
    if data.isMaintenance then
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

scriptScroll.CanvasSize = UDim2.new(0, 0, 0, #scripts * ROW_SPACING + 10)

-- ============================================
-- PÁGINA 2: SCRIPTS DO DEV
-- ============================================
local devPage = Instance.new("Frame")
devPage.Name = "devscripts"
devPage.Size = UDim2.new(1, 0, 1, 0)
devPage.BackgroundTransparency = 1
devPage.Visible = false
devPage.Parent = contentPanel

local devScroll = Instance.new("ScrollingFrame")
devScroll.Size = UDim2.new(1, -12, 1, -12)
devScroll.Position = UDim2.new(0, 6, 0, 6)
devScroll.BackgroundTransparency = 1
devScroll.ScrollBarThickness = 4
devScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
devScroll.Parent = devPage

local devSelected = {}
local devBotoes = {}
local devLinhas = {}

for i, data in ipairs(devScripts) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, ROW_HEIGHT)
    row.Position = UDim2.new(0, 0, 0, (i-1) * ROW_SPACING)
    
    if data.status == "update" then
        row.BackgroundColor3 = Color3.fromRGB(70, 55, 25)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.status == "beta" then
        row.BackgroundColor3 = Color3.fromRGB(40, 60, 80)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(100, 180, 255)
    elseif data.status == "stable" then
        row.BackgroundColor3 = Color3.fromRGB(35, 50, 35)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(80, 200, 80)
    else
        row.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        row.BackgroundTransparency = 0.2
        row.BorderColor3 = Color3.fromRGB(70, 70, 80)
    end
    row.BorderSizePixel = 1
    row.Parent = devScroll
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 5)
    rowCorner.Parent = row

    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 20, 1, -4)
    cb.Position = UDim2.new(0, 4, 0, 2)
    cb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cb.BackgroundTransparency = 0.3
    cb.BorderSizePixel = 1
    
    if data.status == "update" then
        cb.BorderColor3 = Color3.fromRGB(255, 200, 50)
        cb.Text = "🔧"
        cb.TextColor3 = Color3.fromRGB(255, 200, 50)
    else
        cb.BorderColor3 = Color3.fromRGB(150, 150, 200)
        cb.Text = "☐"
        cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    cb.TextScaled = true
    cb.Font = Enum.Font.GothamBold
    cb.Parent = row
    local cbCorner = Instance.new("UICorner")
    cbCorner.CornerRadius = UDim.new(0, 4)
    cbCorner.Parent = cb

    devBotoes[data.id] = cb
    devLinhas[data.id] = {row = row, corBase = row.BackgroundColor3, status = data.status}

    if data.status == "update" then
        cb.MouseButton1Click:Connect(function()
            data.load()
        end)
    else
        cb.MouseButton1Click:Connect(function()
            local idx = table.find(devSelected, data.id)
            if idx then
                table.remove(devSelected, idx)
                cb.Text = "☐"
                cb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                cb.BorderColor3 = Color3.fromRGB(150, 150, 200)
                row.BackgroundColor3 = devLinhas[data.id].corBase
            else
                for _, id in ipairs(devSelected) do
                    local cb2 = devBotoes[id]
                    local row2 = devLinhas[id]
                    if cb2 and row2 and row2.status ~= "update" then
                        cb2.Text = "☐"
                        cb2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        cb2.BorderColor3 = Color3.fromRGB(150, 150, 200)
                        row2.row.BackgroundColor3 = row2.corBase
                    end
                end
                devSelected = {}
                
                table.insert(devSelected, data.id)
                cb.Text = "☑"
                cb.BackgroundColor3 = Color3.fromRGB(120, 60, 200)
                cb.BorderColor3 = Color3.fromRGB(200, 150, 255)
                row.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
            end
            
            if statusLabel and statusLabel.Parent then
                local count = #devSelected
                statusLabel.Text = count > 0 and "◆ " .. count .. " selecionado (Dev)" or "◆ Nenhum selecionado"
                statusLabel.TextColor3 = count > 0 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(200, 200, 200)
            end
        end)
    end
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.5, -30, 0, isMobile and 14 or 16)
    nameLbl.Position = UDim2.new(0, 30, 0, 1)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = data.name
    if data.status == "update" then
        nameLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.status == "beta" then
        nameLbl.TextColor3 = Color3.fromRGB(100, 180, 255)
    else
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    nameLbl.TextScaled = true
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = row

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(0.4, 0, 0, isMobile and 12 or 14)
    statusLbl.Position = UDim2.new(0, 30, 0, isMobile and 15 or 17)
    statusLbl.BackgroundTransparency = 1
    if data.status == "update" then
        statusLbl.Text = "🔄 EM UPDATE"
        statusLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.status == "beta" then
        statusLbl.Text = "🧪 BETA"
        statusLbl.TextColor3 = Color3.fromRGB(100, 180, 255)
    else
        statusLbl.Text = "✅ ESTÁVEL"
        statusLbl.TextColor3 = Color3.fromRGB(80, 200, 80)
    end
    statusLbl.TextScaled = true
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Parent = row

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(0.3, 0, 0, isMobile and 12 or 14)
    descLbl.Position = UDim2.new(0.45, 5, 0, isMobile and 15 or 17)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = data.desc
    descLbl.TextColor3 = data.status == "update" and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(160, 160, 180)
    descLbl.TextScaled = true
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = row

    local typeLbl = Instance.new("TextLabel")
    typeLbl.Size = UDim2.new(0, 20, 1, 0)
    typeLbl.Position = UDim2.new(1, -25, 0, 0)
    typeLbl.BackgroundTransparency = 1
    if data.status == "update" then
        typeLbl.Text = "🔧"
        typeLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.status == "beta" then
        typeLbl.Text = "🧪"
        typeLbl.TextColor3 = Color3.fromRGB(100, 180, 255)
    else
        typeLbl.Text = "✓"
        typeLbl.TextColor3 = Color3.fromRGB(80, 200, 80)
    end
    typeLbl.TextScaled = true
    typeLbl.Font = Enum.Font.Gotham
    typeLbl.Parent = row
end

devScroll.CanvasSize = UDim2.new(0, 0, 0, #devScripts * ROW_SPACING + 10)

-- ============================================
-- PÁGINA 3: VERSION
-- ============================================
local versionPage = Instance.new("Frame")
versionPage.Name = "version"
versionPage.Size = UDim2.new(1, 0, 1, 0)
versionPage.BackgroundTransparency = 1
versionPage.Visible = false
versionPage.Parent = contentPanel

local versionScroll = Instance.new("ScrollingFrame")
versionScroll.Size = UDim2.new(1, -12, 1, -12)
versionScroll.Position = UDim2.new(0, 6, 0, 6)
versionScroll.BackgroundTransparency = 1
versionScroll.ScrollBarThickness = 4
versionScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
versionScroll.Parent = versionPage

local versionContent = Instance.new("Frame")
versionContent.Size = UDim2.new(1, -8, 0, 400)
versionContent.Position = UDim2.new(0, 4, 0, 0)
versionContent.BackgroundTransparency = 1
versionContent.Parent = versionScroll

local function makeVersionRow(y, label, value, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.4, 0, 0, 22)
    l.Position = UDim2.new(0, 5, 0, y)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = Color3.fromRGB(200, 200, 200)
    l.TextScaled = true
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = versionContent
    
    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0.55, 0, 0, 22)
    v.Position = UDim2.new(0.42, 0, 0, y)
    v.BackgroundTransparency = 1
    v.Text = value
    v.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    v.TextScaled = true
    v.Font = Enum.Font.GothamBold
    v.TextXAlignment = Enum.TextXAlignment.Left
    v.Parent = versionContent
end

-- Título
local versionTitle = Instance.new("TextLabel")
versionTitle.Size = UDim2.new(1, -10, 0, 30)
versionTitle.Position = UDim2.new(0, 5, 0, 0)
versionTitle.BackgroundTransparency = 1
versionTitle.Text = "✦ MENU MULTI-JOGOS ✦"
versionTitle.TextColor3 = Color3.fromRGB(180, 120, 255)
versionTitle.TextScaled = true
versionTitle.Font = Enum.Font.GothamBold
versionTitle.Parent = versionContent

local versionSubtitle = Instance.new("TextLabel")
versionSubtitle.Size = UDim2.new(1, -10, 0, 16)
versionSubtitle.Position = UDim2.new(0, 5, 0, 30)
versionSubtitle.BackgroundTransparency = 1
versionSubtitle.Text = "Criado por Mk_gaming"
versionSubtitle.TextColor3 = Color3.fromRGB(160, 160, 160)
versionSubtitle.TextScaled = true
versionSubtitle.Font = Enum.Font.Gotham
versionSubtitle.Parent = versionContent

local sep1 = Instance.new("Frame")
sep1.Size = UDim2.new(1, -10, 0, 1)
sep1.Position = UDim2.new(0, 5, 0, 55)
sep1.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
sep1.BorderSizePixel = 0
sep1.Parent = versionContent

makeVersionRow(65, "📌 Versão:", "v2.0 Nukermode", Color3.fromRGB(180, 120, 255))
makeVersionRow(90, "📅 Atualizado:", "2025", Color3.fromRGB(255, 255, 255))
makeVersionRow(115, "🖥️ Plataforma:", isMobile and "📱 Mobile" or "💻 PC", Color3.fromRGB(100, 200, 255))

local sep2 = Instance.new("Frame")
sep2.Size = UDim2.new(1, -10, 0, 1)
sep2.Position = UDim2.new(0, 5, 0, 145)
sep2.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
sep2.BorderSizePixel = 0
sep2.Parent = versionContent

local gameTitle = Instance.new("TextLabel")
gameTitle.Size = UDim2.new(1, -10, 0, 20)
gameTitle.Position = UDim2.new(0, 5, 0, 155)
gameTitle.BackgroundTransparency = 1
gameTitle.Text = "🎮 JOGO DETECTADO"
gameTitle.TextColor3 = Color3.fromRGB(180, 120, 255)
gameTitle.TextScaled = true
gameTitle.Font = Enum.Font.GothamBold
gameTitle.TextXAlignment = Enum.TextXAlignment.Left
gameTitle.Parent = versionContent

makeVersionRow(180, "Nome:", currentGame.name, Color3.fromRGB(100, 255, 100))
makeVersionRow(205, "ID:", tostring(currentGame.id), Color3.fromRGB(255, 255, 255))
makeVersionRow(230, "Scripts totais:", tostring(#scripts + #devScripts), Color3.fromRGB(255, 200, 100))
makeVersionRow(255, "Disponíveis:", tostring(#availableScripts), Color3.fromRGB(255, 200, 100))

local sep3 = Instance.new("Frame")
sep3.Size = UDim2.new(1, -10, 0, 1)
sep3.Position = UDim2.new(0, 5, 0, 285)
sep3.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
sep3.BorderSizePixel = 0
sep3.Parent = versionContent

local creditsTitle = Instance.new("TextLabel")
creditsTitle.Size = UDim2.new(1, -10, 0, 20)
creditsTitle.Position = UDim2.new(0, 5, 0, 295)
creditsTitle.BackgroundTransparency = 1
creditsTitle.Text = "👨‍💻 CRÉDITOS"
creditsTitle.TextColor3 = Color3.fromRGB(180, 120, 255)
creditsTitle.TextScaled = true
creditsTitle.Font = Enum.Font.GothamBold
creditsTitle.TextXAlignment = Enum.TextXAlignment.Left
creditsTitle.Parent = versionContent

local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1, -10, 0, 50)
creditsText.Position = UDim2.new(0, 5, 0, 320)
creditsText.BackgroundTransparency = 1
creditsText.Text = "• Mk_gaming (Dev Principal)\n• Comunidade de Scripts\n• Todos os Hub Creators"
creditsText.TextColor3 = Color3.fromRGB(220, 220, 220)
creditsText.TextScaled = true
creditsText.Font = Enum.Font.Gotham
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.Parent = versionContent

versionScroll.CanvasSize = UDim2.new(0, 0, 0, 400)

-- ============================================
-- LÓGICA DE TROCA DE PÁGINAS
-- ============================================
local function switchPage(pageId)
    currentPage = pageId
    
    scriptsPage.Visible = (pageId == "scripts")
    devPage.Visible = (pageId == "devscripts")
    versionPage.Visible = (pageId == "version")
    
    for _, entry in ipairs(sidebarButtons) do
        if entry.id == pageId then
            entry.button.BackgroundColor3 = Color3.fromRGB(120, 60, 200)
            entry.button.BackgroundTransparency = 0.1
            entry.button.TextColor3 = Color3.fromRGB(255, 255, 255)
            if not entry.button:FindFirstChild("ActiveBar") then
                local bar = Instance.new("Frame")
                bar.Name = "ActiveBar"
                bar.Size = UDim2.new(0, 3, 0, isMobile and 30 or 34)
                bar.Position = UDim2.new(0, -6, 0, 0)
                bar.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
                bar.BorderSizePixel = 0
                bar.Parent = entry.button
                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(0, 2)
                barCorner.Parent = bar
            end
        else
            entry.button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            entry.button.BackgroundTransparency = 1
            entry.button.TextColor3 = Color3.fromRGB(180, 180, 180)
            local bar = entry.button:FindFirstChild("ActiveBar")
            if bar then bar:Destroy() end
        end
    end
end

for _, entry in ipairs(sidebarButtons) do
    entry.button.MouseButton1Click:Connect(function()
        switchPage(entry.id)
    end)
end

switchPage("scripts")

-- ============================================
-- BARRA INFERIOR (EXECUTAR / LIMPAR / AUTO)
-- ============================================
local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, 0, 0, BOTTOM_BAR_HEIGHT)
bottomBar.Position = UDim2.new(0, 0, 1, -BOTTOM_BAR_HEIGHT)
bottomBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
bottomBar.BackgroundTransparency = 0
bottomBar.BorderSizePixel = 0
bottomBar.Parent = frame

local bottomTopLine = Instance.new("Frame")
bottomTopLine.Size = UDim2.new(1, 0, 0, 1)
bottomTopLine.Position = UDim2.new(0, 0, 0, 0)
bottomTopLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
bottomTopLine.BorderSizePixel = 0
bottomTopLine.Parent = bottomBar

local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0, isMobile and 90 or 110, 0, 30)
execBtn.Position = UDim2.new(0, 8, 0, (BOTTOM_BAR_HEIGHT - 30) / 2 - 3)
execBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 200)
execBtn.BackgroundTransparency = 0.1
execBtn.BorderSizePixel = 1
execBtn.BorderColor3 = Color3.fromRGB(180, 120, 255)
execBtn.Text = "▶ EXECUTAR"
execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBold
execBtn.Parent = bottomBar
local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 6)
execCorner.Parent = execBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, isMobile and 70 or 80, 0, 30)
clearBtn.Position = UDim2.new(0, isMobile and 105 or 125, 0, (BOTTOM_BAR_HEIGHT - 30) / 2 - 3)
clearBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 100)
clearBtn.BackgroundTransparency = 0.1
clearBtn.BorderSizePixel = 1
clearBtn.BorderColor3 = Color3.fromRGB(130, 90, 180)
clearBtn.Text = "↺ LIMPAR"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextScaled = true
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Parent = bottomBar
local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0, isMobile and 80 or 90, 0, 30)
autoBtn.Position = UDim2.new(1, -(isMobile and 88 or 98), 0, (BOTTOM_BAR_HEIGHT - 30) / 2 - 3)
autoBtn.BackgroundColor3 = savedData.autoEnabled and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(70, 55, 90)
autoBtn.BackgroundTransparency = 0.1
autoBtn.BorderSizePixel = 1
autoBtn.BorderColor3 = savedData.autoEnabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(130, 90, 180)
autoBtn.Text = savedData.autoEnabled and "🔁 ON" or "🔁 OFF"
autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBtn.TextScaled = true
autoBtn.Font = Enum.Font.GothamBold
autoBtn.Parent = bottomBar
local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 6)
autoCorner.Parent = autoBtn

-- Status label dentro da bottomBar
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 18)
statusLabel.Position = UDim2.new(0, 8, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = savedData.autoEnabled and "⏳ Auto Execute ATIVADO" or "◆ Nenhum script selecionado"
statusLabel.TextColor3 = savedData.autoEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(180, 180, 180)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = bottomBar

-- ============================================
-- FUNÇÕES AUXILIARES
-- ============================================
local function getSelectedList()
    if currentPage == "devscripts" then
        return devSelected
    end
    return selecionados
end

local function getAllScriptsList()
    if currentPage == "devscripts" then
        return devScripts
    end
    return scripts
end

-- ============================================
-- FUNÇÃO AUTO EXECUTE
-- ============================================
local autoRunning = false
local autoTimerThread = nil

local function executeSelectedScript()
    local list = getSelectedList()
    if #list == 0 then
        return false
    end
    
    local scriptId = list[1]
    local scriptData = nil
    for _, s in ipairs(getAllScriptsList()) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    
    if not scriptData then
        return false
    end
    
    if scriptData.isMaintenance or scriptData.status == "update" then
        scriptData.load()
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
            statusLabel.Text = "❌ Erro: " .. tostring(err):sub(1, 40)
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
    
    return success
end

local function startAutoCountdown()
    if not savedData.autoEnabled or #getSelectedList() == 0 then
        return false
    end
    if autoRunning then return false end
    
    local scriptId = getSelectedList()[1]
    local scriptData = nil
    for _, s in ipairs(getAllScriptsList()) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    if not scriptData then autoRunning = false; return false end
    
    if scriptData.isMaintenance or scriptData.status == "update" then
        scriptData.load()
        autoRunning = false
        return false
    end
    
    autoRunning = true
    local timer = 5
    
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "⏳ Auto: " .. scriptData.name .. " em " .. timer .. "s"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    if autoTimerThread then
        coroutine.close(autoTimerThread)
        autoTimerThread = nil
    end
    
    autoTimerThread = task.spawn(function()
        while timer > 0 and savedData.autoEnabled and #getSelectedList() > 0 do
            wait(1)
            timer = timer - 1
            if timer > 0 and #getSelectedList() > 0 then
                if statusLabel and statusLabel.Parent then
                    statusLabel.Text = "⏳ Auto: " .. scriptData.name .. " em " .. timer .. "s"
                end
            end
        end
        
        if savedData.autoEnabled and #getSelectedList() > 0 and timer == 0 then
            executeSelectedScript()
            wait(1)
            if gui then gui:Destroy() end
        end
        
        autoRunning = false
        autoTimerThread = nil
    end)
    
    return true
end

-- ============================================
-- BOTÃO AUTO
-- ============================================
autoBtn.MouseButton1Click:Connect(function()
    savedData.autoEnabled = not savedData.autoEnabled
    
    if savedData.autoEnabled then
        autoBtn.Text = "🔁 ON"
        autoBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
        autoBtn.BorderColor3 = Color3.fromRGB(80, 255, 80)
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "⏳ Auto Execute ATIVADO - Selecione um script"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        
        if #getSelectedList() > 0 then
            local scriptId = getSelectedList()[1]
            local scriptData = nil
            for _, s in ipairs(getAllScriptsList()) do
                if s.id == scriptId then
                    scriptData = s
                    break
                end
            end
            if scriptData and (scriptData.isMaintenance or scriptData.status == "update") then
                scriptData.load()
            else
                startAutoCountdown()
            end
        end
    else
        autoBtn.Text = "🔁 OFF"
        autoBtn.BackgroundColor3 = Color3.fromRGB(70, 55, 90)
        autoBtn.BorderColor3 = Color3.fromRGB(130, 90, 180)
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "◆ Auto Execute DESATIVADO"
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
            autoScriptId = #getSelectedList() > 0 and getSelectedList()[1] or nil,
            autoEnabled = savedData.autoEnabled
        }
    end)
end)

-- ============================================
-- BOTÃO LIMPAR
-- ============================================
clearBtn.MouseButton1Click:Connect(function()
    autoRunning = false
    if autoTimerThread then
        coroutine.close(autoTimerThread)
        autoTimerThread = nil
    end
    
    if currentPage == "devscripts" then
        for _, id in ipairs(devSelected) do
            local cb = devBotoes[id]
            local rowInfo = devLinhas[id]
            if cb then
                cb.Text = "☐"
                cb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                cb.BorderColor3 = Color3.fromRGB(150, 150, 200)
            end
            if rowInfo and rowInfo.row then
                rowInfo.row.BackgroundColor3 = rowInfo.corBase
            end
        end
        devSelected = {}
    else
        for _, id in ipairs(selecionados) do
            local cb = botoesCheck[id]
            local rowInfo = linhas[id]
            if cb then
                cb.Text = "☐"
                cb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                cb.BorderColor3 = Color3.fromRGB(150, 150, 200)
            end
            if rowInfo and rowInfo.row then
                rowInfo.row.BackgroundColor3 = rowInfo.corBase
            end
        end
        selecionados = {}
    end
    
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

-- ============================================
-- FUNÇÃO EXECUTAR SCRIPT (com fechamento automático)
-- ============================================
local executando = false

local function runScript(scriptData)
    if scriptData.isMaintenance or scriptData.status == "update" then
        scriptData.load()
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

-- ============================================
-- BOTÃO EXECUTAR (✅ FECHA AUTOMATICAMENTE)
-- ============================================
execBtn.MouseButton1Click:Connect(function()
    if executando then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "⏳ Aguarde..."
        end
        return
    end
    
    local list = getSelectedList()
    local allList = getAllScriptsList()
    
    if #list == 0 then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "⚠️ Nenhum script selecionado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        end
        return
    end
    
    local scriptId = list[1]
    local scriptData = nil
    for _, s in ipairs(allList) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    
    -- Se for manutenção/update, mostra aviso e fecha também
    if scriptData and (scriptData.isMaintenance or scriptData.status == "update") then
        scriptData.load()
        task.wait(0.5)
        if gui then gui:Destroy() end
        return
    end
    
    autoRunning = false
    if autoTimerThread then
        coroutine.close(autoTimerThread)
        autoTimerThread = nil
    end
    
    executando = true
    execBtn.Text = "◉ EXECUTANDO..."
    execBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "▶ Executando " .. (scriptData and scriptData.name or "script") .. "..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    -- Executa o script
    if scriptData then
        runScript(scriptData)
    end
    
    -- ✅ FECHA IMEDIATAMENTE após executar
    task.wait(0.3)
    if gui then gui:Destroy() end
end)

-- ============================================
-- AUTO EXECUTE AO INICIAR (se estava ativado)
-- ============================================
if savedData.autoEnabled and #getSelectedList() > 0 then
    local scriptId = getSelectedList()[1]
    local scriptData = nil
    for _, s in ipairs(getAllScriptsList()) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    if scriptData and (scriptData.isMaintenance or scriptData.status == "update") then
        scriptData.load()
    else
        startAutoCountdown()
    end
end

print("✅ Menu Multi-Jogos carregado! (Mk_gaming) - Estilo Nukermode")
print("📱 Modo Mobile: " .. (isMobile and "ATIVADO" or "DESATIVADO"))
print("🎮 Jogo atual: " .. currentGame.name .. " (ID: " .. currentGame.id .. ")")
print("📜 " .. #scripts .. " scripts + " .. #devScripts .. " scripts do dev")
print("🔁 Auto Execute: " .. (savedData.autoEnabled and "ON" or "OFF"))
print("✅ Fechamento automático após executar: ATIVADO")
