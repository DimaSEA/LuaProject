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
local BtnTweenAlpha = createHackButton("👻 Ghost Tween Coolant Alpha", Color3.fromRGB(41, 128, 185), 2)
local BtnTweenBeta  = createHackButton("👻 Ghost Tween Coolant Beta", Color3.fromRGB(41, 128, 185), 3)
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

-- [[ SYSTEM GHOST TWEEN INTERACT ]] --
local function ghostTween(type)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    local success, prompt = pcall(function()
        return game:GetService("Workspace").FacilitySystems.Controls.Coolant["Coolant" .. type].Main.ProximityPrompt
    end)
    
    if success and prompt and prompt:IsA("ProximityPrompt") then
        local targetPart = prompt.Parent
        local originalCFrame = hrp.CFrame
        local parts = {}
        
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then parts[p] = true; p.CanCollide = false end
        end
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        
        local distance = (targetPart.Position - hrp.Position).Magnitude
        local tweenInfo = TweenInfo.new(distance / 250, Enum.EasingStyle.Linear)
        local tTo = TweenService:Create(hrp, tweenInfo, {CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)})
        tTo:Play() tTo.Completed:Wait() task.wait(0.1)
        
        prompt:InputHoldBegin() task.wait(prompt.HoldDuration + 0.05) prompt:InputHoldEnd() task.wait(0.1)
        
        local tBack = TweenService:Create(hrp, tweenInfo, {CFrame = originalCFrame})
        tBack:Play() tBack.Completed:Wait()
        
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        for p, _ in pairs(parts) do if p and p.Parent then p.CanCollide = true end end
    end
end
BtnTweenAlpha.MouseButton1Click:Connect(function() ghostTween("Alpha") end)
BtnTweenBeta.MouseButton1Click:Connect(function() ghostTween("Beta") end)

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
    local spacing = 5 -- Jarak berjejer kesamping (dalam studs)
    
    for _, o in pairs(game:GetService("Workspace"):GetDescendants()) do
        if o.Name == "WaterPipe" then
            -- Logika baru: Pipa dipaksa ngikutin orientasi berdiri tegak dari badan lo, lalu digeser berjejer
            local offset = (count * spacing) - 6
            local straightCFrame = hrp.CFrame * CFrame.new(offset, -1, -7)
            
            if o:IsA("Model") then
                o:PivotTo(straightCFrame)
            elseif o:IsA("BasePart") then
                o.CFrame = straightCFrame
                o.AssemblyLinearVelocity = Vector3.new(0,0,0)
                o.AssemblyAngularVelocity = Vector3.new(0,0,0)
            end
            count = count + 1 -- count naik di luar biar barisannya gak tumpuk-tumpukan
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
