-- [[ ESP TEAM SYSTEM - GREEN & CYAN VERSION (3s REFRESH FOR LAG FIX) ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function pasangESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("Head") then return end
    local head = char.Head

    -- Hapus ESP lama biar gak numpuk pas di-refresh
    if head:FindFirstChild("SimpleESP") then
        head.SimpleESP:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SimpleESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 7
    textLabel.TextStrokeTransparency = 0 -- Outline hitam tetap aktif

    local infoText = player.Name
    local infoColor = Color3.fromRGB(0, 255, 255) -- Default Cyan

    -- Logika Murni Team Bawaan
    if LocalPlayer.Team and player.Team then
        if player.Team == LocalPlayer.Team then
            -- TEMEN = Ijo
            infoText = "[TEMEN] " .. player.Name
            infoColor = Color3.fromRGB(0, 255, 120)
        else
            -- MUSUH = Cyan (Polosan)
            infoText = player.Name
            infoColor = Color3.fromRGB(0, 255, 255)
        end
    else
        infoColor = Color3.fromRGB(0, 255, 255)
    end

    textLabel.Text = infoText
    textLabel.TextColor3 = infoColor
    billboard.Parent = head
end

-- [[ REFRESH LOOP AMAN - PER 3 DETIK ]] --
task.spawn(function()
    while task.wait(3) do -- Nah, segini biar device lo bisa bernafas lega, wkwkw
        for _, player in ipairs(Players:GetPlayers()) do
            pasangESP(player)
        end
    end
end)

print("[Sukses] ESP Anti-Lag Aktif! Refresh per 3 detik ya, Dimas.")
