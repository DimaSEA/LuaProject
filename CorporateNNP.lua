local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local ScoutTargetRemote = ReplicatedStorage:WaitForChild("TREK_SERVICES")
    :WaitForChild("TREK_Remotes")
    :WaitForChild("ScoutTarget")
local TVehicles = Workspace:WaitForChild("TVehicles")

-- [[ 1. SETUP GUI UTAMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Scout_Ultimate_V3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 340) -- Ditambah tinggi dikit buat kolom search
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Judul Panel
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 35)
Title.Text = "🎯 SCOUT PANEL V3 SPEED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 52, 71)
Title.TextSize = 11
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- [[ FITUR MINIMIZE ]] --
local MiniFrame = Instance.new("Frame")
MiniFrame.Size = UDim2.new(0, 40, 0, 40)
MiniFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MiniFrame.BackgroundColor3 = Color3.fromRGB(45, 52, 71)
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true
MiniFrame.Parent = ScreenGui

local MiniBtnActual = Instance.new("TextButton")
MiniBtnActual.Size = UDim2.new(1, 0, 1, 0)
MiniBtnActual.Text = "🎯"
MiniBtnActual.TextSize = 18
MiniBtnActual.BackgroundColor3 = Color3.fromRGB(45, 52, 71)
MiniBtnActual.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtnActual.Parent = MiniFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.Text = "—"
MinimizeBtn.TextSize = 14
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(192, 41, 43)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Parent = MainFrame

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniFrame.Position = MainFrame.Position
    MiniFrame.Visible = true
end)

MiniBtnActual.MouseButton1Click:Connect(function()
    MiniFrame.Visible = false
    MainFrame.Position = MiniFrame.Position
    MainFrame.Visible = true
end)

-- [[ SETUP TAB SYSTEM ]] --
local TabMobilBtn = Instance.new("TextButton")
TabMobilBtn.Size = UDim2.new(0, 110, 0, 25)
TabMobilBtn.Position = UDim2.new(0, 10, 0, 40)
TabMobilBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
TabMobilBtn.Text = "🚘 VEHICLES"
TabMobilBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMobilBtn.Font = Enum.Font.SourceSansBold
TabMobilBtn.TextSize = 10
TabMobilBtn.Parent = MainFrame

local TabPlayerBtn = Instance.new("TextButton")
TabPlayerBtn.Size = UDim2.new(0, 110, 0, 25)
TabPlayerBtn.Position = UDim2.new(0, 120, 0, 40)
TabPlayerBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TabPlayerBtn.Text = "👤 PLAYERS"
TabPlayerBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
TabPlayerBtn.Font = Enum.Font.SourceSansBold
TabPlayerBtn.TextSize = 10
TabPlayerBtn.Parent = MainFrame

-- [[ FITUR SEARCH BAR (KHUSUS PLAYER) ]] --
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -20, 0, 30)
SearchFrame.Position = UDim2.new(0, 10, 0, 70)
SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
SearchFrame.Visible = false -- Cuma muncul di tab player
SearchFrame.Parent = MainFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -35, 1, 0)
SearchBox.Position = UDim2.new(0, 5, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Cari nama player..."
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 110, 120)
SearchBox.TextSize = 11
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchFrame

local ClearSearchBtn = Instance.new("TextButton")
ClearSearchBtn.Size = UDim2.new(0, 25, 0, 25)
ClearSearchBtn.Position = UDim2.new(1, -27, 0, 2)
ClearSearchBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
ClearSearchBtn.Text = "X"
ClearSearchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearSearchBtn.Font = Enum.Font.SourceSansBold
ClearSearchBtn.TextSize = 10
ClearSearchBtn.Parent = SearchFrame

-- Scrolling Frame (Posisinya dinamis tergantung kolom search muncul/enggak)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -115)
ScrollFrame.Position = UDim2.new(0, 10, 0, 70)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- Tombol Refresh
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -20, 0, 30)
RefreshBtn.Position = UDim2.new(0, 10, 1, -35)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
RefreshBtn.Text = "🔄 REFRESH DAFTAR"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 11
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.Parent = MainFrame

local modeAktif = "Mobil"

-- [[ 2. LOGIKA RENDER DENGAN FILTER SEARCH ]] --
local function updateUltimateList()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local totalY = 0
    local filterText = string.lower(SearchBox.Text)
    
    if modeAktif == "Mobil" then
        ScrollFrame.Position = UDim2.new(0, 10, 0, 70)
        ScrollFrame.Size = UDim2.new(1, -20, 1, -115)
        SearchFrame.Visible = false
        
        local vehicles = TVehicles:GetChildren()
        for _, vehicle in pairs(vehicles) do
            if vehicle:IsA("Model") then
                totalY = totalY + 35
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, -5, 0, 30)
                Btn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
                Btn.Text = "🚘 " .. vehicle.Name
                Btn.TextColor3 = Color3.fromRGB(241, 196, 15)
                Btn.TextSize = 11
                Btn.Font = Enum.Font.SourceSansBold
                Btn.Parent = ScrollFrame
                
                Btn.MouseButton1Click:Connect(function()
                    if vehicle and vehicle.Parent then
                        pcall(function() ScoutTargetRemote:FireServer(vehicle) end)
                        Btn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
                        Btn.Text = "🎯 SCOUTED!"
                        task.wait(0.4)
                        if Btn then Btn.BackgroundColor3 = Color3.fromRGB(52, 73, 94) Btn.Text = "🚘 " .. vehicle.Name end
                    end
                end)
            end
        end
    elseif modeAktif == "Player" then
        -- Geser scroll down biar ga tabrakan sama search bar
        ScrollFrame.Position = UDim2.new(0, 10, 0, 105)
        ScrollFrame.Size = UDim2.new(1, -20, 1, -150)
        SearchFrame.Visible = true
        
        local allPlayers = Players:GetPlayers()
        for _, pler in pairs(allPlayers) do
            if pler ~= LocalPlayer then
                -- Logika Filter Text
                if filterText == "" or string.find(string.lower(pler.Name), filterText) then
                    totalY = totalY + 35
                    local Btn = Instance.new("TextButton")
                    Btn.Size = UDim2.new(1, -5, 0, 30)
                    Btn.BackgroundColor3 = Color3.fromRGB(45, 55, 70)
                    Btn.Text = "👤 " .. pler.Name
                    Btn.TextColor3 = Color3.fromRGB(236, 240, 241)
                    Btn.TextSize = 11
                    Btn.Font = Enum.Font.SourceSansBold
                    Btn.Parent = ScrollFrame
                    
                    Btn.MouseButton1Click:Connect(function()
                        if pler.Character and pler.Character:FindFirstChild("HumanoidRootPart") then
                            pcall(function() ScoutTargetRemote:FireServer(pler.Character) end)
                            Btn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
                            Btn.Text = "🎯 TARGET SPOTTED!"
                            task.wait(0.4)
                            if Btn then Btn.BackgroundColor3 = Color3.fromRGB(45, 55, 70) Btn.Text = "👤 " .. pler.Name end
                        else
                            Btn.Text = "❌ PLAYER BELUM SPAWN"
                            Btn.BackgroundColor3 = Color3.fromRGB(192, 41, 43)
                        end
                    end)
                end
            end
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalY + 10)
end

-- [[ REAKSI INPUT SEARCH & CLEAR ]] --
SearchBox:GetPropertyChangedSignal("Text"):Connect(updateUltimateList)

ClearSearchBtn.MouseButton1Click:Connect(function()
    SearchBox.Text = "" -- Hapus tulisan, list otomatis nge-reset utuh lagi
    SearchBox:ReleaseFocus()
end)

-- [[ PERPINDAHAN TAB ]] --
TabMobilBtn.MouseButton1Click:Connect(function()
    modeAktif = "Mobil"
    TabMobilBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    TabMobilBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabPlayerBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabPlayerBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    updateUltimateList()
end)

TabPlayerBtn.MouseButton1Click:Connect(function()
    modeAktif = "Player"
    TabPlayerBtn.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    TabPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabMobilBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabMobilBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    updateUltimateList()
end)

RefreshBtn.MouseButton1Click:Connect(updateUltimateList)
updateUltimateList()
