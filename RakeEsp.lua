local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- Fungsi buat bikin/update ESP
local function updateESP(model, humanoid)
    -- 1. Pasang Highlight kalau belum ada
    local highlight = model:FindFirstChild("GeminiHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "GeminiHighlight"
        highlight.Parent = model
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.AlwaysOnTop = true
    end

    -- 2. Bikin/Update Billboard (Teks Jarak)
    local billboard = model:FindFirstChild("GeminiDist")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "GeminiDist"
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0) -- Jarak teks di atas kepala
        billboard.AlwaysOnTop = true
        billboard.Parent = model

        local label = Instance.new("TextLabel")
        label.Name = "DistLabel"
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
    end

    -- 3. Update Angka Jaraknya
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = localPlayer.Character.HumanoidRootPart.Position
        local targetPos = model.PrimaryPart and model.PrimaryPart.Position or model:FindFirstChildWhichIsA("BasePart").Position
        
        if targetPos then
            local distance = math.floor((myPos - targetPos).Magnitude)
            billboard.DistLabel.Text = "Monster [" .. distance .. "m]"
        end
    end
end

-- Looping Utama yang Lebih Optimal (Heartbeat biar nggak berat di FPS)
RunService.Heartbeat:Connect(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Name == "Monster" then
            local model = obj.Parent
            if model and model:IsA("Model") then
                updateESP(model, obj)
            end
        end
    end
end)

print("Gemini ESP Optimized: Jarak Aktif! 📏")
