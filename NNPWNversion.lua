local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local savedPosition = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperFacility_Clean"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui

-- [[ FRAME UTAMA UI ]] --
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.Text = "FACILITY GODMODE v5.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -28, 0, 3)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = MinBtn

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(1, 0, 1, -30)
MainContainer.Position = UDim2.new(0, 0, 0, 30)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = MainFrame

-- [[ KOTAK CHAT SPY ]] --
local ChatLogBox = Instance.new("ScrollingFrame")
ChatLogBox.Size = UDim2.new(1, -16, 0, 70)
ChatLogBox.Position = UDim2.new(0, 8, 0, 5)
ChatLogBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ChatLogBox.BackgroundTransparency = 0.4
ChatLogBox.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatLogBox.ScrollBarThickness = 3
ChatLogBox.Parent = MainContainer

local ChatLogLayout = Instance.new("UIListLayout")
ChatLogLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLogLayout.Padding = UDim.new(0, 3)
ChatLogLayout.Parent = ChatLogBox
Instance.new("UICorner", ChatLogBox).CornerRadius = UDim.new(0, 4)

-- [[ SCROLL MENU TOMBOL ]] --
local ButtonMenuScroll = Instance.new("ScrollingFrame")
ButtonMenuScroll.Size = UDim2.new(1, -16, 1, -85)
ButtonMenuScroll.Position = UDim2.new(0, 8, 0, 80)
ButtonMenuScroll.BackgroundTransparency = 1
ButtonMenuScroll.CanvasSize = UDim2.new(0, 0, 0, 320)
ButtonMenuScroll.ScrollBarThickness = 4
ButtonMenuScroll.Parent = MainContainer

local MenuLayout = Instance.new("UIListLayout")
MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
MenuLayout.Padding = UDim.new(0, 6)
MenuLayout.Parent = ButtonMenuScroll

local function createHackButton(text, color, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 32)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.SourceSansBold
    btn.LayoutOrder = order
    btn.Parent = ButtonMenuScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local BtnUnlockChat = createHackButton("🔓 Force Unlock Default Chat", Color3.fromRGB(142, 68, 173), 1)
local BtnTweenAlpha = createHackButton("⚡ Instant Trigger Coolant Alpha", Color3.fromRGB(41, 128, 185), 2)
local BtnTweenBeta  = createHackButton("⚡ Instant Trigger Coolant Beta", Color3.fromRGB(41, 128, 185), 3)
local BtnClearMines = createHackButton("💣 Destroy All Landmine", Color3.fromRGB(231, 76, 60), 4)
local BtnBringPipes = createHackButton("🛠️ Bring Pipes (Stand Up)", Color3.fromRGB(39, 174, 96), 5)
local BtnSetCoord   = createHackButton("🔵 [Car TP] Set Coordinate", Color3.fromRGB(0, 150, 255), 6)
local BtnTpCar      = createHackButton("🔴 [Car TP] Teleport Car", Color3.fromRGB(255, 50, 50), 7)

-- [[ LOGIKA MINIMIZE UI ]] --
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        MainContainer.Visible = false
        MainFrame.Size = UDim2.new(0, 250, 0, 32)
        MinBtn.Text = "+"
        isMinimized = true
    else
        MainFrame.Size = UDim2.new(0, 250, 0, 320)
        MainContainer.Visible = true
        MinBtn.Text = "-"
        isMinimized = false
    end
end)

-- [[ SYSTEM SADAP & UNLOCK CHAT ]] --
local function appendChatLog(sender, message)
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, 0, 0, 16)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = "[" .. sender.Name .. "]: " .. message
    msgLabel.TextColor3 = (sender == LocalPlayer) and Color3.fromRGB(52, 152, 219) or Color3.fromRGB(241, 196, 15)
    msgLabel.TextSize = 11
    msgLabel.Font = Enum.Font.SourceSans
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = ChatLogBox
    ChatLogBox.CanvasSize = UDim2.new(0, 0, 0, ChatLogLayout.AbsoluteContentSize.Y)
    ChatLogBox.CanvasPosition = Vector2.new(0, ChatLogLayout.AbsoluteContentSize.Y)
end

for _, p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(m) appendChatLog(p, m) end) end
Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(m) appendChatLog(p, m) end) end)

BtnUnlockChat.MouseButton1Click:Connect(function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
        local cGui = LocalPlayer.PlayerGui:FindFirstChild("Chat") or CoreGui:FindFirstChild("Chat")
        if cGui then cGui.Enabled = true end
    end)
    BtnUnlockChat.Text = "Chat Unlocked! ✅"
end)

-- [[ ✨ REPLACED: NEW INSTANT TELEPORT INTERACT (ALPHA & BETA) ✨ ]] --
local function instantTriggerCoolant(coolantType)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Ambil path sesuai tipe (CoolantBeta atau CoolantAlpha)
    local success, prompt = pcall(function()
        return workspace.FacilitySystems.Controls.Coolant["Coolant" .. coolantType].Main.ProximityPrompt
    end)

    if not success or not prompt then
        warn("Coolant " .. coolantType .. " ProximityPrompt gak ketemu, Dim!")
        return
    end

    -- Simpan posisi awal buat pulang kampung
    local originalPos = hrp.CFrame

    -- Cari posisi target part
    local targetCFrame = nil
    local part = prompt.Parent:FindFirstChildWhichIsA("BasePart")
    if part then
        targetCFrame = part.CFrame
    else
        targetCFrame = CFrame.new(prompt.Parent.Position)
    end

    -- TELEPORT + HADEPIN KE PROMPT
    hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    task.wait(0.05)
    hrp.CFrame = CFrame.lookAt(hrp.Position, prompt.Parent.Position)

    -- FORCE BYPASS SETTING PROMPT
    prompt.MaxActivationDistance = 50
    prompt.Enabled = true
    task.wait(0.1)

    -- PROSES EKSEKUSI (3 METODE TRIGGER)
    local triggered = false

    -- Cara 1: Invoking prompt bawaan engine
    pcall(function()
        prompt:Prompt(LocalPlayer)
        triggered = true
        print("Cara 1: Prompt() executed")
    end)

    task.wait(0.1)

    -- Cara 2: Executer framework function (fireproximityprompt)
    if fireproximityprompt and not triggered then
        pcall(function()
            fireproximityprompt(prompt)
            triggered = true
            print("Cara 2: fireproximityprompt executed")
        end)
    end

    task.wait(0.1)

    -- Cara 3: Simulasi pencet tombol E di keyboard virtual
    if not triggered then
        local VirtualInput = game:GetService("VirtualInputManager")
        VirtualInput:SendKeyPress("E", Enum.KeyCode.E)
        task.wait(0.05)
        VirtualInput:SendKeyRelease("E", Enum.KeyCode.E)
        print("Cara 3: Simulated E key")
    end

    task.wait(0.1)

    -- PULANG KE POSISI SEMULA
    hrp.CFrame = originalPos
    print("Selesai - Coolant " .. coolantType .. " Trigger status: " .. tostring(triggered))
end

-- Pasang fungsi baru ke tombol Alpha dan Beta
BtnTweenAlpha.MouseButton1Click:Connect(function() instantTriggerCoolant("Alpha") end)
BtnTweenBeta.MouseButton1Click:Connect(function() instantTriggerCoolant("Beta") end)

-- [[ HAPUS RANJAU LANDMINE ]] --
BtnClearMines.MouseButton1Click:Connect(function()
    local count = 0
    for _, o in pairs(game:GetService("Workspace"):GetDescendants()) do
        if o.Name == "Landmine" then o:Destroy() count = count + 1 end
    end
    if count > 0 then BtnClearMines.Text = "Cleaned " .. count .. " Mines! ✅" task.wait(1) BtnClearMines.Text = "💣 Destroy All Landmine" end
end)

-- [[ AMBIL PIPA WATERPIPE ]] --
BtnBringPipes.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local count = 0
    local spacing = 5
    local basePos = hrp.Position + (hrp.CFrame.LookVector * 7)
    
    for _, o in pairs(game:GetService("Workspace"):GetDescendants()) do
        if o.Name == "WaterPipe" then
            local offset = (count * spacing) - 6
            local newPos = basePos + (hrp.CFrame.RightVector * offset)
            
            local _, lookY, _ = hrp.CFrame:ToEulerAnglesXYZ()
            local straightCFrame = CFrame.new(newPos.X, hrp.Position.Y - 1, newPos.Z) * CFrame.Angles(0, lookY, 0)
            
            if o:IsA("Model") then
                o:PivotTo(straightCFrame)
            elseif o:IsA("BasePart") then
                o.CFrame = straightCFrame
                o.AssemblyLinearVelocity = Vector3.new(0,0,0)
                o.AssemblyAngularVelocity = Vector3.new(0,0,0)
            end
            count = count + 1
        end
    end
end)

-- [[ SYSTEM CAR TELEPORT BYPASS ]] --
BtnSetCoord.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        savedPosition = hrp.Position + Vector3.new(0, 2, 0)
        BtnSetCoord.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        BtnSetCoord.Text = "Saved! ✅"
        task.wait(0.5)
        BtnSetCoord.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        BtnSetCoord.Text = "🔵 [Car TP] Set Coordinate"
    end
end)

BtnTpCar.MouseButton1Click:Connect(function()
    if not savedPosition then
        StarterGui:SetCore("SendNotification", {Title = "Gagal!", Text = "Set koordinat dulu, Dimas! ❌", Duration = 3})
        return
    end
    
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if humanoid and humanoid.SeatPart then
        local seat = humanoid.SeatPart
        local vehicleModel = seat:FindFirstAncestorOfClass("Model") or seat
        
        if vehicleModel:IsA("Model") then
            vehicleModel:PivotTo(CFrame.new(savedPosition))
        else
            vehicleModel.CFrame = CFrame.new(savedPosition)
        end
        
        task.wait(0.1)
        
        for _, part in pairs(vehicleModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        StarterGui:SetCore("SendNotification", {Title = "Sukses!", Text = "Mobil meluncur tanpa rollback! 🏎️💨", Duration = 3})
    else
        StarterGui:SetCore("SendNotification", {Title = "Belum Naik Mobil!", Text = "Duduk di kursi Sedan dulu baru pencet TP!", Duration = 3})
    end
end)
