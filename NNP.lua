-- 1. BIKIN CORE SYSTEM & SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local ToggleButton = Instance.new("TextButton") -- Tombol Buka/Tutup

-- Pastikan GUI gak ilang pas karakter lu mati/respawn
ScreenGui.Name = "DimasBypassGUI_V2"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. TOMBOL BUKA/TUTUP (Khusus buat user HP biar praktis)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleButton.BorderSizePixel = 1
ToggleButton.BorderColor3 = Color3.fromRGB(255, 215, 0)
ToggleButton.Position = UDim2.new(0.02, 0, 0.3, 0) -- Nangkring di pojok kiri layar
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "🛠️"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20
ToggleButton.Active = true
ToggleButton.Draggable = true -- Tombol buletnya juga bisa digeser sesuka hati!

-- Desain Frame Utama (Sama persis kayak kemarin, gak diubah)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true -- Default-nya kebuka pas di-execute

-- Fungsi klik tombol buat buka/tutup menu utama
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

-- Layout biar tombolnya otomatis rapi kebawah
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Fungsi Helper buat bikin sub-judul (Section)
local function createSection(text, order)
    local label = Instance.new("TextLabel")
    label.Parent = MainFrame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Font = Enum.Font.SourceSansBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextSize = 14
    label.LayoutOrder = order
end

-- Fungsi Utama buat Fungsi Instant Repair (Udah di-update jalurnya pake data Spy baru!)
local function doInstantRepair(machineType, machineName)
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local character = localPlayer.Character
    
    -- Cek Wrench di tangan, kalau gak ada otomatis ambil dari Backpack
    local wrench = character and character:FindFirstChild("Wrench")
    if not wrench and localPlayer:FindFirstChild("Backpack") then
        local backpackWrench = localPlayer.Backpack:FindFirstChild("Wrench")
        if backpackWrench then
            backpackWrench.Parent = character
            task.wait(0.1)
            wrench = character:FindFirstChild("Wrench")
        end
    end
    
    if not wrench then
        print("⚠️ Dimas, ambil Wrench dulu atau beli dulu, bro!")
        return
    end

    -- DETEKSI JALUR WORKSPACE BERDASARKAN HASIL SPY LU LUAR BIASA!
    local workspaceService = game:GetService("Workspace")
    local facility = workspaceService:FindFirstChild("FacilitySystems")
    local targetRepair = nil
    
    if facility then
        local typeFolder = facility:FindFirstChild(machineType) -- Nyari folder "Feedwater" atau "Turbines"
        local machineFolder = typeFolder and typeFolder:FindFirstChild(machineName) -- Nyari nama mesinnya
        if machineFolder then
            targetRepair = machineFolder:FindFirstChild("Repair")
        end
    end
    
    if not targetRepair then
        print("⚠️ Objek " .. machineName .. "/Repair gak ketemu di Workspace!")
        return
    end

    -- Eksekusi Tembak Remote!
    local args = { wrench, targetRepair, "Durability" }
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RepairSystem")
    
    print("⚡ Memulai bypass instan untuk: " .. machineName)
    remotes.RequestRepair:FireServer(unpack(args))
    
    for i = 1, 20 do
        remotes.Repair:FireServer(unpack(args))
        task.wait(0.01)
    end
    print("✅ Selesai! " .. machineName .. " berhasil diperbaiki!")
end

-- Fungsi buat bikin tombolnya
local function createRepairButton(name, machineType, machineName, order)
    local button = Instance.new("TextButton")
    button.Parent = MainFrame
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
        doInstantRepair(machineType, machineName)
    end)
end

-- 3. SUSUN ISI MENUNYA
Title.LayoutOrder = 0

createSection("--- PUMP SYSTEM ---", 1)
createRepairButton("🔧 Fix FWPump A", "Feedwater", "FWPumpA", 2)
createRepairButton("🔧 Fix FWPump B", "Feedwater", "FWPumpB", 3)

createSection("--- TURBINE SYSTEM ---", 4)
createRepairButton("⚡ Fix Turbine Alpha", "Turbines", "TurbineAlpha", 5)
createRepairButton("⚡ Fix Turbine Beta", "Turbines", "TurbineBeta", 6)

print("✅ GUI V2 Siap Digunakan! Jalur Turbin aktif + Tombol Buka Tutup ready, bro.")
