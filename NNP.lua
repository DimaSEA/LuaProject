-- 1. BIKIN CORE SYSTEM & SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "DimasBypassGUI_V10"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. TOMBOL BUKA/TUTUP MENU UTAMA
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleButton.BorderSizePixel = 1
ToggleButton.BorderColor3 = Color3.fromRGB(255, 215, 0)
ToggleButton.Position = UDim2.new(0.02, 0, 0.3, 0)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "🛠️"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20
ToggleButton.Active = true
ToggleButton.Draggable = true

-- Desain Frame Utama (Ukuran pas di layar HP)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 210, 0, 260) 
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Judul GUI
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "🛠️ BYPASS REPAIR 🛠️"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 16

-- AREA SCROLL FRAME BIAR BISA DI-GESER
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = MainFrame
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 320)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createSection(text, order)
    local label = Instance.new("TextLabel")
    label.Parent = ScrollFrame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Font = Enum.Font.SourceSansBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextSize = 14
    label.LayoutOrder = order
end

-- ========================================================
-- [LOGIKA 1: FAST REPAIR METODE POMPA & TURBIN]
-- ========================================================
local function doInstantRepair(machineType, machineName, targetPartName)
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local character = localPlayer.Character
    
    local wrench = character and character:FindFirstChild("Wrench")
    if not wrench and localPlayer:FindFirstChild("Backpack") then
        local backpackWrench = localPlayer.Backpack:FindFirstChild("Wrench")
        if backpackWrench then
            backpackWrench.Parent = character
            task.wait(0.1)
            wrench = character:FindFirstChild("Wrench")
        end
    end
    
    if not wrench then return end

    local workspaceService = game:GetService("Workspace")
    local facility = workspaceService:FindFirstChild("FacilitySystems")
    local targetRepair = nil
    
    if facility then
        local typeFolder = facility:FindFirstChild(machineType)
        local machineFolder = typeFolder and typeFolder:FindFirstChild(machineName)
        if machineFolder then
            targetRepair = machineFolder:FindFirstChild(targetPartName)
        end
    end
    
    if not targetRepair then return end

    local args = { wrench, targetRepair, "Durability" }
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RepairSystem")
    
    remotes.RequestRepair:FireServer(unpack(args))
    
    for i = 1, 20 do
        remotes.Repair:FireServer(unpack(args))
        task.wait(0.01)
    end
end

-- ========================================================
-- [LOGIKA 2: VEHICLE TELEPORT BYPASS SYSTEM]
-- ========================================================
local function doVehicleTeleport()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TARGET_POSITION = Vector3.new(-1720, 86, 3497) -- Koordinat buatan Dimas

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- Ngecek apakah karakter lu lagi duduk di mobil
    if humanoid and humanoid.SeatPart then
        local seat = humanoid.SeatPart
        local vehicleModel = seat:FindFirstAncestorOfClass("Model") or seat
        
        -- Angkut mobil beserta lu ke koordinat target
        if vehicleModel:IsA("Model") then
            vehicleModel:PivotTo(CFrame.new(TARGET_POSITION))
        else
            vehicleModel.CFrame = CFrame.new(TARGET_POSITION)
        end
        
        task.wait(0.1)
        
        -- Stabilisator: Nahan bodi mobil biar gak glinding pas nyampe
        for _, part in pairs(vehicleModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        -- Notifikasi pop-up di layar kanan bawah game
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Teleport Sukses!",
            Text = "Nyampe tanpa rollback, bro! 🏎️💨",
            Duration = 4
        })
    else
        -- Notifikasi kalau lu pencet tombol tapi masih berdiri di luar
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Gagal Teleport!",
            Text = "Duduk di kursi kemudi mobil dulu, Dimas!",
            Duration = 4
        })
    end
end

-- ========================================================
-- [PROSES METODE PENEMPATAN TOMBOL]
-- ========================================================
local function createRepairButton(name, machineType, machineName, targetPartName, order)
    local button = Instance.new("TextButton")
    button.Parent = ScrollFrame
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(0, 180, 0, 35)
    button.Font = Enum.Font.SourceSans
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.LayoutOrder = order
    
    button.MouseEnter:Connect(function() button.BackgroundColor3 = Color3.fromRGB(70, 70, 85) end)
    button.MouseLeave:Connect(function() button.BackgroundColor3 = Color3.fromRGB(50, 50, 60) end)
    
    button.MouseButton1Click:Connect(function()
        doInstantRepair(machineType, machineName, targetPartName)
    end)
end

-- Tombol Khusus Buat Teleport Mobil Permanen di GUI
local function createTeleportButton(name, order)
    local button = Instance.new("TextButton")
    button.Parent = ScrollFrame
    button.BackgroundColor3 = Color3.fromRGB(70, 40, 40) -- Warna merah marun biar mencolok
    button.BorderSizePixel = 0
    button.Size = UDim2.new(0, 180, 0, 35)
    button.Font = Enum.Font.SourceSansBold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 215, 0) -- Teks emas biar keren
    button.TextSize = 14
    button.LayoutOrder = order
    
    button.MouseEnter:Connect(function() button.BackgroundColor3 = Color3.fromRGB(90, 50, 50) end)
    button.MouseLeave:Connect(function() button.BackgroundColor3 = Color3.fromRGB(70, 40, 40) end)
    
    button.MouseButton1Click:Connect(function()
        doVehicleTeleport() -- Langsung panggil fungsi teleport pas tombol di GUI di-klik
    end)
end

-- 3. SUSUN ISI MENUNYA (Rapih, Padat, fungsional)
Title.LayoutOrder = 0

createSection("--- PUMP SYSTEM ---", 1)
createRepairButton("🔧 Fix FWPump A", "Feedwater", "FWPumpA", "Repair", 2)
createRepairButton("🔧 Fix FWPump B", "Feedwater", "FWPumpB", "Repair", 3)

createSection("--- TURBINE SYSTEM ---", 4)
createRepairButton("⚡ Fix Turbine Alpha", "Turbines", "TurbineAlpha", "Repair", 5)
createRepairButton("⚡ Fix Turbine Beta", "Turbines", "TurbineBeta", "Repair", 6)

-- SEKSI TELEPORT MOBIL PERMANEN DI GUI
createSection("--- TELEPORT SYSTEM ---", 7)
createTeleportButton("🏎️ Teleport Vehicle", 8)
