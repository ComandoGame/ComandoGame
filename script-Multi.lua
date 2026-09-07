-- Menu Multi-Jogos - Mk_gaming (Quantum Onyx em Manutenção)
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
    
    -- Lista de IDs de jogos conhecidos
    local games = {
        -- Blox Fruits (TODOS OS MARES)
        [2753915549] = "Blox Fruits",
        [4442272183] = "Blox Fruits (Teste)",
        [6284583030] = "Blox Fruits (Mobile)",
        [6403373529] = "Blox Fruits (Console)",
        [85211729168715] = "Blox Fruits (Primeiro Mar)",
        [79091703265657] = "Blox Fruits (Segundo Mar)",
        [100117331123089] = "Blox Fruits (Terceiro Mar)",
        [73902483975735] = "Blox Fruits (Masmorras)",
        -- Blitz
        [125686182205697] = "Blitz",
        [83469115925484] = "Blitz",
        [72632230828026] = "Blitz",
        -- Horror Elevador
        [6383408360] = "Horror Elevador",
        -- Knockback Battles
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
local function showMaintenanceNotice(scriptName)
    local gui = Instance.new("ScreenGui")
    gui.Name = "MaintenanceNotice"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 180)
    frame.Position = UDim2.new(0.5, -200, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    -- Ícone
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0.5, -30, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "🔧"
    icon.TextColor3 = Color3.fromRGB(255, 200, 50)
    icon.TextScaled = true
    icon.Font = Enum.Font.GothamBold
    icon.Parent = frame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 75)
    title.BackgroundTransparency = 1
    title.Text = "⚠️ SCRIPT EM MANUTENÇÃO"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- Mensagem
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -40, 0, 25)
    msg.Position = UDim2.new(0, 20, 0, 110)
    msg.BackgroundTransparency = 1
    msg.Text = "🔄 " .. scriptName .. " está sendo atualizado."
    msg.TextColor3 = Color3.fromRGB(255, 255, 255)
    msg.TextScaled = true
    msg.Font = Enum.Font.Gotham
    msg.Parent = frame
    
    -- Submensagem
    local msg2 = Instance.new("TextLabel")
    msg2.Size = UDim2.new(1, -40, 0, 20)
    msg2.Position = UDim2.new(0, 20, 0, 138)
    msg2.BackgroundTransparency = 1
    msg2.Text = "⏳ Em breve estará disponível novamente."
    msg2.TextColor3 = Color3.fromRGB(200, 200, 200)
    msg2.TextScaled = true
    msg2.Font = Enum.Font.Gotham
    msg2.TextSize = 10
    msg2.Parent = frame
    
    -- Botão Fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 30)
    closeBtn.Position = UDim2.new(0.5, -50, 0, 145)
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
    
    -- Auto-fecha após 5 segundos
    task.wait(5)
    gui:Destroy()
end

-- ============================================
-- LISTA DE SCRIPTS POR JOGO
-- ============================================
local scripts = {
    -- ===== BLOX FRUITS (14 SCRIPTS) =====
    -- QUANTUM ONYX - EM MANUTENÇÃO
    { 
        id = 1, 
        name = "Quantum Onyx", 
        game = "Blox Fruits",
        key = false, 
        desc = "🔧 EM MANUTENÇÃO - Aguarde",
        load = function()
            showMaintenanceNotice("Quantum Onyx")
        end,
        isMaintenance = true  -- Marca como em manutenção
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
        id = 5, 
        name = "Hunt Hub 2026", 
        game = "Blox Fruits",
        key = true, 
        desc = "Comandgame • Premium",
        load = 'loadstring(game:HttpGet("https://pastebin.com/raw/abHni44D"))()' 
    },
    { 
        id = 6, 
        name = "Draco Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Hub Completo",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/RealRyx/MainDraco/refs/heads/main/DracoMain.lua"))()' 
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
        id = 8, 
        name = "Esmerald Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Alternativo • Sem Key",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Emerald/script.luau"))()' 
    },
    { 
        id = 9, 
        name = "Star Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Leve • Seguro 2026",
        load = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Stellar/refs/heads/main/Star/script.luau"))()' 
    },
    { 
        id = 10, 
        name = "Hinishi Hub", 
        game = "Blox Fruits",
        key = false, 
        desc = "Auto Farm Level • Leve",
        load = function()
            local Settings = {
                JoinTeam = "Marines";
                Translator = true;
            }
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-Hinishi/Hinishi-Hub/refs/heads/main/Freemium.lua"))(Settings)
        end
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
        id = 18, 
        name = "Quantum Onyx (Dungeon)", 
        game = "Blox Fruits (Masmorras)",
        key = false, 
        desc = "🔧 EM MANUTENÇÃO - Aguarde",
        load = function()
            showMaintenanceNotice("Quantum Onyx (Dungeon)")
        end,
        isMaintenance = true
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
            frame.Size = UDim2.new(0, 400, 0, 150)
            frame.Position = UDim2.new(0.5, -200, 0.5, -75)
            frame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
            frame.BackgroundTransparency = 0.1
            frame.BorderSizePixel = 2
            frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
            frame.Parent = gui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 16)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 35)
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
            msg.Text = "🔄 O script Knockback Battles está sendo atualizado."
            msg.TextColor3 = Color3.fromRGB(255, 255, 255)
            msg.TextScaled = true
            msg.Font = Enum.Font.Gotham
            msg.Parent = frame
            
            local msg2 = Instance.new("TextLabel")
            msg2.Size = UDim2.new(1, -40, 0, 25)
            msg2.Position = UDim2.new(0, 20, 0, 78)
            msg2.BackgroundTransparency = 1
            msg2.Text = "⏳ Em breve estará disponível novamente."
            msg2.TextColor3 = Color3.fromRGB(200, 200, 200)
            msg2.TextScaled = true
            msg2.Font = Enum.Font.Gotham
            msg2.Parent = frame
            
            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 100, 0, 30)
            closeBtn.Position = UDim2.new(0.5, -50, 0, 110)
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
-- CRIAÇÃO DA GUI
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptMenu"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 620)
frame.Position = UDim2.new(0.5, -210, 0.5, -310)
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
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
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
title.Text = "✦ MULTI-GAME SCRIPTS ✦"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -33, 0, 10)
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
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -16, 0, 60)
infoFrame.Position = UDim2.new(0, 8, 0, 52)
infoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
infoFrame.BackgroundTransparency = 0.9
infoFrame.BorderSizePixel = 1
infoFrame.BorderColor3 = Color3.fromRGB(150, 50, 255)
infoFrame.Parent = frame
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local nomeLabel = Instance.new("TextLabel")
nomeLabel.Size = UDim2.new(0, 200, 0, 18)
nomeLabel.Position = UDim2.new(0, 10, 0, 3)
nomeLabel.BackgroundTransparency = 1
nomeLabel.Text = "👤 " .. player.Name
nomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nomeLabel.TextScaled = true
nomeLabel.Font = Enum.Font.GothamSemibold
nomeLabel.TextXAlignment = Enum.TextXAlignment.Left
nomeLabel.Parent = infoFrame

local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(0, 200, 0, 18)
levelLabel.Position = UDim2.new(0, 10, 0, 22)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "📊 Nível: 0"
levelLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
levelLabel.TextScaled = true
levelLabel.Font = Enum.Font.Gotham
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = infoFrame

local gameLabel = Instance.new("TextLabel")
gameLabel.Size = UDim2.new(0, 200, 0, 18)
gameLabel.Position = UDim2.new(0, 220, 0, 3)
gameLabel.BackgroundTransparency = 1
gameLabel.Text = "🎮 " .. currentGame.name
gameLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
gameLabel.TextScaled = true
gameLabel.Font = Enum.Font.GothamBold
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.Parent = infoFrame

local gameIdLabel = Instance.new("TextLabel")
gameIdLabel.Size = UDim2.new(0, 200, 0, 18)
gameIdLabel.Position = UDim2.new(0, 220, 0, 22)
gameIdLabel.BackgroundTransparency = 1
gameIdLabel.Text = "🆔 " .. currentGame.id
gameIdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
gameIdLabel.TextScaled = true
gameIdLabel.Font = Enum.Font.Gotham
gameIdLabel.TextXAlignment = Enum.TextXAlignment.Left
gameIdLabel.Parent = infoFrame

local statusGame = Instance.new("TextLabel")
statusGame.Size = UDim2.new(0, 200, 0, 18)
statusGame.Position = UDim2.new(0, 220, 0, 41)
statusGame.BackgroundTransparency = 1
statusGame.Text = "📜 " .. #availableScripts .. " scripts disponíveis"
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
-- ÁREA DE SCRIPTS
-- ============================================
local scriptArea = Instance.new("ScrollingFrame")
scriptArea.Size = UDim2.new(1, -16, 0, 260)
scriptArea.Position = UDim2.new(0, 8, 0, 120)
scriptArea.BackgroundTransparency = 1
scriptArea.ScrollBarThickness = 4
scriptArea.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)
scriptArea.Parent = frame

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
    row.Size = UDim2.new(1, -4, 0, 34)
    row.Position = UDim2.new(0, 0, 0, (i-1) * 38)
    
    -- Marcar scripts em manutenção
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
        -- Scripts em manutenção ou bloqueados mostram aviso ao clicar
        cb.MouseButton1Click:Connect(function()
            if data.isMaintenance then
                showMaintenanceNotice(data.name)
            elseif data.id == 13 then
                -- Já mostra o aviso de update
                data.load()
            end
        end)
    end
    
    -- Nome
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0, 130, 0, 16)
    nameLbl.Position = UDim2.new(0, 30, 0, 2)
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

    -- Jogo do Script
    local gameScriptLbl = Instance.new("TextLabel")
    gameScriptLbl.Size = UDim2.new(0, 80, 0, 14)
    gameScriptLbl.Position = UDim2.new(0, 30, 0, 18)
    gameScriptLbl.BackgroundTransparency = 1
    if data.isMaintenance then
        gameScriptLbl.Text = "🔧 MANUTENÇÃO"
        gameScriptLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 13 then
        gameScriptLbl.Text = "🔄 EM UPDATE"
        gameScriptLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif data.id == 18 then
        gameScriptLbl.Text = "🗡️ MASMORRAS"
        gameScriptLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        gameScriptLbl.Text = "🎮 " .. data.game
        gameScriptLbl.TextColor3 = isAvailable and Color3.fromRGB(180, 255, 180) or Color3.fromRGB(100, 100, 100)
    end
    gameScriptLbl.TextScaled = true
    gameScriptLbl.Font = Enum.Font.GothamBold
    gameScriptLbl.TextSize = 8
    gameScriptLbl.TextXAlignment = Enum.TextXAlignment.Left
    gameScriptLbl.Parent = row

    -- Descrição
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(0, 120, 0, 14)
    descLbl.Position = UDim2.new(0, 115, 0, 18)
    descLbl.BackgroundTransparency = 1
    if data.isMaintenance then
        descLbl.Text = "⏳ Aguarde atualização..."
        descLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    elseif data.id == 13 then
        descLbl.Text = "🔧 Atualizando script..."
        descLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    elseif data.id == 18 then
        descLbl.Text = "✅ Único que funciona em masmorras"
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

    -- Key
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

    -- Indicador de bloqueio / update / dungeon
    if not isAvailable or data.isMaintenance or data.id == 13 then
        local lockLbl = Instance.new("TextLabel")
        lockLbl.Size = UDim2.new(0, 60, 1, 0)
        lockLbl.Position = UDim2.new(1, -90, 0, 0)
        lockLbl.BackgroundTransparency = 1
        if data.isMaintenance then
            lockLbl.Text = "🔧 MANUTENÇÃO"
            lockLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
        elseif data.id == 13 then
            lockLbl.Text = "🔄 UPDATE"
            lockLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
        elseif data.id == 18 then
            lockLbl.Text = "🗡️ DUNGEON"
            lockLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            lockLbl.Text = "🔒 BLOQUEADO"
            lockLbl.TextColor3 = Color3.fromRGB(200, 100, 100)
        end
        lockLbl.TextScaled = true
        lockLbl.Font = Enum.Font.GothamBold
        lockLbl.TextSize = 7
        lockLbl.Parent = row
    end
end

scriptArea.CanvasSize = UDim2.new(0, 0, 0, #scripts * 38 + 10)

-- ============================================
-- BOTÕES
-- ============================================
local btnFrame = Instance.new("Frame")
btnFrame.Size = UDim2.new(1, -16, 0, 35)
btnFrame.Position = UDim2.new(0, 8, 0, 388)
btnFrame.BackgroundTransparency = 1
btnFrame.Parent = frame

local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0, 120, 0, 30)
execBtn.Position = UDim2.new(0, 0, 0, 2)
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
huntBtn.Size = UDim2.new(0, 80, 0, 30)
huntBtn.Position = UDim2.new(0, 130, 0, 2)
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
clearBtn.Size = UDim2.new(0, 70, 0, 30)
clearBtn.Position = UDim2.new(1, -80, 0, 2)
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

-- ============================================
-- BOTÃO AUTO EXECUTE
-- ============================================
local autoFrame = Instance.new("Frame")
autoFrame.Size = UDim2.new(1, -16, 0, 35)
autoFrame.Position = UDim2.new(0, 8, 0, 428)
autoFrame.BackgroundTransparency = 1
autoFrame.Parent = frame

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0, 150, 0, 30)
autoBtn.Position = UDim2.new(0.5, -75, 0, 2)
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

-- ============================================
-- STATUS LABEL
-- ============================================
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 22)
statusLabel.Position = UDim2.new(0, 8, 0, 470)
statusLabel.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
statusLabel.BackgroundTransparency = 0.85
statusLabel.BorderSizePixel = 1
statusLabel.BorderColor3 = Color3.fromRGB(200, 100, 255)
statusLabel.Text = savedData.autoEnabled and "⏳ Auto Execute ATIVADO" or "◆ Nenhum script selecionado"
statusLabel.TextColor3 = savedData.autoEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- ============================================
-- RODAPÉ
-- ============================================
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 16)
footer.Position = UDim2.new(0, 0, 1, -18)
footer.BackgroundTransparency = 1
footer.Text = "✦ Mk_gaming • " .. #scripts .. " Scripts • " .. #availableScripts .. " disponíveis ✦"
footer.TextColor3 = Color3.fromRGB(200, 100, 200)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.TextSize = 8
footer.TextTransparency = 0.3
footer.Parent = frame

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
    
    -- Verifica se está em manutenção
    if scriptData.isMaintenance then
        showMaintenanceNotice(scriptData.name)
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
            statusLabel.Text = "🔒 Script bloqueado para este jogo!"
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
            statusLabel.Text = "❌ Erro: " .. tostring(err):sub(1, 40)
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
    
    -- Verifica se está em manutenção
    if scriptData.isMaintenance then
        showMaintenanceNotice(scriptData.name)
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
            statusLabel.Text = "🔒 Script bloqueado para este jogo!"
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
        coroutine.close(autoTimerThread)
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
            if gui then gui:Destroy() end
        end
        
        autoRunning = false
        autoTimerThread = nil
    end)
    
    return true
end

-- ============================================
-- EVENTO DO BOTÃO AUTO EXECUTE
-- ============================================
autoBtn.MouseButton1Click:Connect(function()
    savedData.autoEnabled = not savedData.autoEnabled
    
    if savedData.autoEnabled then
        autoBtn.Text = "🔁 AUTO: ON"
        autoBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        autoBtn.BorderColor3 = Color3.fromRGB(50, 255, 50)
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "⏳ Auto Execute ATIVADO - Selecione um script disponível"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        
        if #selecionados > 0 then
            -- Verifica se o script selecionado está em manutenção
            local scriptId = selecionados[1]
            local scriptData = nil
            for _, s in ipairs(scripts) do
                if s.id == scriptId then
                    scriptData = s
                    break
                end
            end
            if scriptData and scriptData.isMaintenance then
                showMaintenanceNotice(scriptData.name)
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

-- ============================================
-- FUNÇÃO LIMPAR
-- ============================================
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
-- FUNÇÃO DE EXECUÇÃO MANUAL
-- ============================================
local executando = false

local function runScript(scriptData)
    -- Verifica se está em manutenção
    if scriptData.isMaintenance then
        showMaintenanceNotice(scriptData.name)
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
            statusLabel.Text = "🔒 Script bloqueado para este jogo!"
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
            statusLabel.Text = "⚠️ Nenhum script selecionado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        end
        return
    end
    
    -- Verifica se o script selecionado está em manutenção
    local scriptId = selecionados[1]
    local scriptData = nil
    for _, s in ipairs(scripts) do
        if s.id == scriptId then
            scriptData = s
            break
        end
    end
    if scriptData and scriptData.isMaintenance then
        showMaintenanceNotice(scriptData.name)
        return
    end
    
    autoRunning = false
    if autoTimerThread then
        coroutine.close(autoTimerThread)
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
                    showMaintenanceNotice(data.name)
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
        if blockedCount > 0 then
            statusLabel.Text = "✅ Concluído! (" .. blockedCount .. " bloqueados/manutenção)"
        else
            statusLabel.Text = "✅ Concluído!"
        end
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    execBtn.Text = "✓ FINALIZADO"
    execBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    executando = false
    task.wait(1)
    if gui then gui:Destroy() end
end)

-- ============================================
-- BOTÃO HUNT HUB
-- ============================================
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
    
    local huntAvailable = false
    for _, avail in ipairs(availableScripts) do
        if avail.id == 5 then
            huntAvailable = true
            break
        end
    end
    
    if not huntAvailable then
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "🔒 Hunt Hub bloqueado para este jogo!"
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
                    statusLabel.Text = "❌ Erro: " .. tostring(err):sub(1, 40)
                    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                huntBtn.Text = "❌ ERRO"
                huntBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
            
            wait(2)
            huntBtn.Text = "🎯 HUNT"
            huntBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
            executando = false
            task.wait(1)
            if gui then gui:Destroy() end
        end)
    else
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "❌ Hunt Hub não encontrado!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        executando = false
    end
end)

-- ============================================
-- INICIAR AUTO EXECUTE SE JÁ ESTIVER ATIVO
-- ============================================
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
        showMaintenanceNotice(scriptData.name)
    else
        startAutoCountdown()
    end
end

print("✅ Menu Multi-Jogos carregado! (Mk_gaming)")
print("🎮 Jogo atual: " .. currentGame.name .. " (ID: " .. currentGame.id .. ")")
print("📜 " .. #scripts .. " scripts total, " .. #availableScripts .. " disponíveis")
print("🔁 Auto Execute: " .. (savedData.autoEnabled and "ON" or "OFF"))