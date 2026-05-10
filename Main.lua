    Rusty Raft Hub  |  v2.0
    -----------------------------------------------------------
      • GunController (NoRecoil via KickbackIntensity, FastBullets, LongRange)
      • PhysicsGun system (Object Grabber via NetworkConfig.PhysicsGunPickup)
      • ProximityPromptService (Auto Grab + Instant Prompts)
      • CollectionService tags (categorised ESP)
      • Mob folder structure (Auto Farm BETA)
--]]
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local oldHub = CoreGui:FindFirstChild("RustyRaftHub")
if oldHub then oldHub:Destroy() end
if _G.RustyRaftHub_Cleanup then pcall(_G.RustyRaftHub_Cleanup) end

local Players              = game:GetService("Players")
local UserInputService     = game:GetService("UserInputService")
local RunService           = game:GetService("RunService")
local Workspace            = game:GetService("Workspace")
local TweenService         = game:GetService("TweenService")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")
local CollectionService    = game:GetService("CollectionService")
local Lighting             = game:GetService("Lighting")
local VirtualUser          = game:GetService("VirtualUser")

local LocalPlayer          = Players.LocalPlayer
local Mouse                = LocalPlayer:GetMouse()
local Camera               = Workspace.CurrentCamera

local Settings = {
    NoRecoil       = true,
    FastBullets    = true,
    LongRange      = true,
    AutoFire       = false,
    AimAssist      = false,
    AimAssistRange = 200,

    InfJump        = false,
    SpeedBoost     = false,
    SpeedValue     = 28,
    JumpBoost      = false,
    JumpValue      = 90,
    Fly            = false,
    FlySpeed       = 60,

    AutoGrab       = true,
    AutoGrabRange  = 50,
    GrabTools      = true,
    GrabArmor      = true,
    GrabLootBox    = true,
    InstantPrompts = false,
    ObjectGrabber  = false,
    GrabberRange   = 60,

    ESP_Mobs       = false,
    ESP_LootBox    = false,
    ESP_Tools      = false,
    ESP_Armor      = false,
    ESP_Drifting   = false,
    ShowNames      = true,
    FullBright     = false,

    AutoFarm       = false,
    AutoFarmRange  = 150,
    AutoFarmRate   = 0.25,

    AntiAFK        = true,
}
_G.RustyRaftSettings = Settings

local connections = {}
local espObjects  = {} 

local function track(c) connections[#connections+1] = c; return c end

local THEME = {
    BG          = Color3.fromRGB(18, 20, 26),
    BG2         = Color3.fromRGB(26, 28, 36),
    BG3         = Color3.fromRGB(34, 38, 48),
    BG4         = Color3.fromRGB(44, 48, 60),
    Stroke      = Color3.fromRGB(60, 65, 80),
    Accent      = Color3.fromRGB(255, 103, 65),
    Accent2     = Color3.fromRGB(255, 165, 100),
    Text        = Color3.fromRGB(235, 238, 245),
    SubText     = Color3.fromRGB(155, 162, 178),
    Good        = Color3.fromRGB(85, 220, 130),
    Bad         = Color3.fromRGB(230, 90, 90),
    Beta        = Color3.fromRGB(180, 130, 255),
    Font        = Enum.Font.Gotham,
    BoldFont    = Enum.Font.GothamBold,
}

local ESP_COLORS = {
    Mob       = Color3.fromRGB(230, 80,  80),   
    LootBox   = Color3.fromRGB(255, 180, 60),   
    Tool      = Color3.fromRGB(85,  220, 130),  
    Armor     = Color3.fromRGB(180, 130, 255),  
    Drifting  = Color3.fromRGB(255, 250, 100),  
}

local function new(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    return inst
end

local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, r or 8)}) end
local function stroke(col, th, tr)
    return new("UIStroke", {Color = col or THEME.Stroke, Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end

local ScreenGui = new("ScreenGui", {
    Name = "RustyRaftHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = new("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(620, 420),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = THEME.BG,
    BorderSizePixel = 0,
    Parent = ScreenGui,
}, {corner(12), stroke(THEME.Stroke, 1)})

new("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 38)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 16, 22)),
    },
    Rotation = 135,
    Parent = Main,
})

new("ImageLabel", {
    Name = "Shadow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 6),
    Size = UDim2.new(1, 50, 1, 50),
    Image = "rbxassetid://1316045217",
    ImageColor3 = Color3.new(0,0,0),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(10,10,118,118),
    BackgroundTransparency = 1,
    ZIndex = 0,
    Parent = Main,
})

local TopBar = new("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = THEME.BG2,
    BorderSizePixel = 0,
    Parent = Main,
}, {corner(12)})
new("Frame", {Size=UDim2.new(1,0,0,12), Position=UDim2.new(0,0,1,-12), BackgroundColor3=THEME.BG2, BorderSizePixel=0, Parent=TopBar})

new("Frame", {Size=UDim2.fromOffset(8,8), Position=UDim2.new(0,12,0.5,-4), BackgroundColor3=THEME.Accent, BorderSizePixel=0, Parent=TopBar}, {corner(4)})
new("TextLabel", {
    Name="Title", Size=UDim2.new(1,-180,1,0), Position=UDim2.fromOffset(28,0),
    BackgroundTransparency=1, Font=THEME.BoldFont, Text="RUSTY RAFT  ·  HUB",
    TextColor3=THEME.Text, TextSize=15, TextXAlignment=Enum.TextXAlignment.Left, Parent=TopBar,
})
new("TextLabel", {
    Name="Version", Size=UDim2.fromOffset(50,16), Position=UDim2.fromOffset(170,14),
    BackgroundColor3=THEME.Accent, BorderSizePixel=0,
    Text="v2.0", Font=THEME.BoldFont, TextColor3=Color3.new(0,0,0), TextSize=10, Parent=TopBar,
}, {corner(4)})

local CloseBtn = new("TextButton", {
    Name="Close", Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,-36,0.5,-14),
    BackgroundColor3=THEME.BG3, BorderSizePixel=0, Text="X",
    Font=THEME.BoldFont, TextColor3=THEME.Text, TextSize=14, AutoButtonColor=false, Parent=TopBar,
}, {corner(6)})
local MinBtn = new("TextButton", {
    Name="Min", Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,-68,0.5,-14),
    BackgroundColor3=THEME.BG3, BorderSizePixel=0, Text="–",
    Font=THEME.BoldFont, TextColor3=THEME.Text, TextSize=18, AutoButtonColor=false, Parent=TopBar,
}, {corner(6)})

do
    local dragging, dragStart, startPos
    track(TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=Main.Position
        end
    end))
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end))
    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end))
end

local Sidebar = new("Frame", {
    Name="Sidebar", Size=UDim2.new(0,140,1,-54), Position=UDim2.new(0,6,0,48),
    BackgroundColor3=THEME.BG2, BorderSizePixel=0, Parent=Main,
}, {corner(10)})
new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4), Parent=Sidebar})
new("UIPadding", {PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), Parent=Sidebar})

local Content = new("Frame", {
    Name="Content", Size=UDim2.new(1,-158,1,-54), Position=UDim2.new(0,152,0,48),
    BackgroundColor3=THEME.BG2, BorderSizePixel=0, Parent=Main,
}, {corner(10)})
new("UIPadding", {PaddingTop=UDim.new(0,12), PaddingLeft=UDim.new(0,14), PaddingRight=UDim.new(0,14), PaddingBottom=UDim.new(0,12), Parent=Content})

local pages = {}
local function showPage(name)
    for k, page in pairs(pages) do
        page.Frame.Visible = (k == name)
        TweenService:Create(page.Tab, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            BackgroundColor3 = (k==name) and THEME.BG3 or THEME.BG2,
            TextColor3 = (k==name) and THEME.Accent or THEME.SubText,
        }):Play()
    end
end

local function addTab(name, order, icon, isBeta)
    local btn = new("TextButton", {
        Name=name, Size=UDim2.new(1,0,0,32), BackgroundColor3=THEME.BG2, BorderSizePixel=0,
        AutoButtonColor=false, Text="  "..(icon or "").."  "..name,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=THEME.BoldFont, TextSize=13, TextColor3=THEME.SubText,
        LayoutOrder=order, Parent=Sidebar,
    }, {corner(6)})

    if isBeta then
        new("TextLabel", {
            Size=UDim2.fromOffset(34,12), Position=UDim2.new(1,-40,0.5,-6),
            BackgroundColor3=THEME.Beta, BorderSizePixel=0, Text="BETA",
            Font=THEME.BoldFont, TextColor3=Color3.new(0,0,0), TextSize=9, Parent=btn,
        }, {corner(3)})
    end

    local page = new("ScrollingFrame", {
        Name=name.."Page", Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
        BorderSizePixel=0, Visible=false, ScrollBarThickness=3,
        ScrollBarImageColor3=THEME.Accent, CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=Content,
    })
    new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,8), Parent=page})
    new("UIPadding", {PaddingRight=UDim.new(0,6), Parent=page})

    track(btn.MouseButton1Click:Connect(function() showPage(name) end))
    pages[name] = {Tab=btn, Frame=page}
    return page
end

local function makeSection(parent, label, isBeta)
    local f = new("Frame", {Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, LayoutOrder=#parent:GetChildren(), Parent=parent})
    new("TextLabel", {
        Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
        Text=string.upper(label), Font=THEME.BoldFont,
        TextColor3=isBeta and THEME.Beta or THEME.Accent, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=f,
    })
    new("Frame", {AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,0,1,-2), Size=UDim2.new(1,0,0,1), BackgroundColor3=THEME.Stroke, BorderSizePixel=0, Parent=f})
end

local function makeToggle(parent, key, label, sub, accent)
    accent = accent or THEME.Accent
    local row = new("Frame", {
        Size=UDim2.new(1,0,0,40), BackgroundColor3=THEME.BG3, BorderSizePixel=0,
        LayoutOrder=#parent:GetChildren(), Parent=parent,
    }, {corner(8), stroke(THEME.Stroke, 1, 0.7)})

    new("TextLabel", {Size=UDim2.new(1,-70,0,18), Position=UDim2.fromOffset(12,4), BackgroundTransparency=1, Text=label, Font=THEME.BoldFont, TextColor3=THEME.Text, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    if sub then
        new("TextLabel", {Size=UDim2.new(1,-70,0,14), Position=UDim2.fromOffset(12,21), BackgroundTransparency=1, Text=sub, Font=THEME.Font, TextColor3=THEME.SubText, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    end

    local pill = new("Frame", {Size=UDim2.fromOffset(40,20), Position=UDim2.new(1,-52,0.5,-10), BackgroundColor3=Settings[key] and accent or THEME.Stroke, BorderSizePixel=0, Parent=row}, {corner(10)})
    local knob = new("Frame", {Size=UDim2.fromOffset(16,16), Position=Settings[key] and UDim2.new(1,-18,0.5,-8) or UDim2.fromOffset(2,2), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=pill}, {corner(8)})
    local btn = new("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=row})

    track(btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = Settings[key] and accent or THEME.Stroke}):Play()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Position = Settings[key] and UDim2.new(1,-18,0.5,-8) or UDim2.fromOffset(2,2)}):Play()
    end))
end

local function makeSlider(parent, key, label, minV, maxV, step)
    local row = new("Frame", {Size=UDim2.new(1,0,0,50), BackgroundColor3=THEME.BG3, BorderSizePixel=0, LayoutOrder=#parent:GetChildren(), Parent=parent}, {corner(8), stroke(THEME.Stroke, 1, 0.7)})
    local lbl = new("TextLabel", {Size=UDim2.new(1,-16,0,18), Position=UDim2.fromOffset(12,4), BackgroundTransparency=1, Text=label..": "..tostring(Settings[key]), Font=THEME.BoldFont, TextColor3=THEME.Text, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    local trk = new("Frame", {Size=UDim2.new(1,-24,0,6), Position=UDim2.fromOffset(12,32), BackgroundColor3=THEME.Stroke, BorderSizePixel=0, Parent=row}, {corner(3)})
    local fill = new("Frame", {Size=UDim2.fromScale((Settings[key]-minV)/(maxV-minV),1), BackgroundColor3=THEME.Accent, BorderSizePixel=0, Parent=trk}, {corner(3)})

    local function setValue(rel)
        rel = math.clamp(rel,0,1)
        local v = minV + (maxV-minV)*rel
        if step then v = math.floor(v/step + 0.5)*step end
        Settings[key] = v
        fill.Size = UDim2.fromScale((v-minV)/(maxV-minV),1)
        lbl.Text = label..": "..tostring(v)
    end

    local dragging
    track(trk.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; setValue((input.Position.X-trk.AbsolutePosition.X)/trk.AbsoluteSize.X)
        end
    end))
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            setValue((input.Position.X-trk.AbsolutePosition.X)/trk.AbsoluteSize.X)
        end
    end))
    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end))
end

local function makeKeybind(parent, label, default, onPress)
    local row = new("Frame", {Size=UDim2.new(1,0,0,40), BackgroundColor3=THEME.BG3, BorderSizePixel=0, LayoutOrder=#parent:GetChildren(), Parent=parent}, {corner(8), stroke(THEME.Stroke, 1, 0.7)})
    new("TextLabel", {Size=UDim2.new(1,-90,1,0), Position=UDim2.fromOffset(12,0), BackgroundTransparency=1, Text=label, Font=THEME.BoldFont, TextColor3=THEME.Text, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    local btn = new("TextButton", {Size=UDim2.fromOffset(70,24), Position=UDim2.new(1,-82,0.5,-12), BackgroundColor3=THEME.BG4, BorderSizePixel=0, Text=default.Name, Font=THEME.BoldFont, TextColor3=THEME.Accent, TextSize=12, AutoButtonColor=false, Parent=row}, {corner(6)})

    local key = default
    local listening = false
    track(btn.MouseButton1Click:Connect(function()
        listening = true; btn.Text = "..."
    end))
    track(UserInputService.InputBegan:Connect(function(input, gp)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode; btn.Text = key.Name; listening = false
            end
        elseif not gp and input.KeyCode == key then
            onPress()
        end
    end))
end

local CombatPage = addTab("Combat", 1, "[CMB]")
makeSection(CombatPage, "Guns")
makeToggle(CombatPage, "NoRecoil",    "No Recoil",    "Forces gun kickback to zero")
makeToggle(CombatPage, "FastBullets", "Fast Bullets", "Boosts tracer speed (visual)")
makeToggle(CombatPage, "LongRange",   "Long Range",   "Extends bullet max distance")
makeToggle(CombatPage, "AutoFire",    "Auto Fire",    "Hold M1 = full auto on any gun")
makeSection(CombatPage, "Aim", true)
makeToggle(CombatPage, "AimAssist",   "Aim Assist (BETA)", "Snap to nearest mob head", THEME.Beta)
makeSlider(CombatPage, "AimAssistRange", "Range", 50, 500, 10)

local MovePage = addTab("Movement", 2, "[MOV]")
makeSection(MovePage, "Locomotion")
makeToggle(MovePage, "InfJump",    "Infinite Jump", "Jump in mid-air")
makeToggle(MovePage, "SpeedBoost", "Walk Speed",    "Override walk speed")
makeSlider(MovePage, "SpeedValue", "Speed", 16, 80, 1)
makeToggle(MovePage, "JumpBoost",  "Jump Power",    "Override jump power")
makeSlider(MovePage, "JumpValue",  "Jump", 50, 250, 5)
makeSection(MovePage, "Flight", true)
makeToggle(MovePage, "Fly", "Fly (BETA)", "WASD/Space/LCtrl to fly", THEME.Beta)
makeSlider(MovePage, "FlySpeed", "Fly Speed", 20, 200, 5)

local PickupPage = addTab("Pickup", 3, "[PCK]")
makeSection(PickupPage, "Auto Grab")
makeToggle(PickupPage, "AutoGrab",       "Enabled",         "Auto-fire prompts in range")
makeSlider(PickupPage, "AutoGrabRange",  "Range", 10, 200, 5)
makeToggle(PickupPage, "GrabTools",      "Grab Tools",      "Pistols, ammo, food (PickupPrompt)")
makeToggle(PickupPage, "GrabArmor",      "Grab Armor",      "EquipPrompt items")
makeToggle(PickupPage, "GrabLootBox",    "Open Loot Boxes", "Auto open loot crates (OpenPrompt)")
makeToggle(PickupPage, "InstantPrompts", "Instant Prompts", "Sets HoldDuration=0 globally")
makeSection(PickupPage, "Object Grabber")
makeToggle(PickupPage, "ObjectGrabber",  "Object Grabber",  "Press G to grab whatever you look at")
makeSlider(PickupPage, "GrabberRange",   "Reach", 10, 200, 5)

local VisualsPage = addTab("Visuals", 4, "[VIS]")
makeSection(VisualsPage, "ESP")
makeToggle(VisualsPage, "ESP_Mobs",     "Mobs",          "Red highlight on enemies")
makeToggle(VisualsPage, "ESP_LootBox",  "Loot Crates",   "Gold highlight on lootable crates")
makeToggle(VisualsPage, "ESP_Tools",    "Weapons / Tools", "Green highlight on dropped tools")
makeToggle(VisualsPage, "ESP_Armor",    "Armor",         "Purple highlight on armor pieces")
makeToggle(VisualsPage, "ESP_Drifting", "Drifting Loot", "Yellow highlight on ocean drift loot")
makeToggle(VisualsPage, "ShowNames",    "Show Names",    "Render name labels above items")
makeSection(VisualsPage, "Lighting")
makeToggle(VisualsPage, "FullBright", "Full Bright", "Disable lighting at night")

local FarmPage = addTab("Farm", 5, "[FRM]", true)
makeSection(FarmPage, "Auto Farm", true)
makeToggle(FarmPage, "AutoFarm",      "Auto Shoot Mobs (BETA)", "Auto-aims+fires at nearest mob", THEME.Beta)
makeSlider(FarmPage, "AutoFarmRange", "Range", 50, 500, 10)
makeSlider(FarmPage, "AutoFarmRate",  "Rate (s)", 0.1, 2, 0.05)

local MiscPage = addTab("Misc", 6, "[CFG]")
makeSection(MiscPage, "Utility")
makeToggle(MiscPage, "AntiAFK", "Anti-AFK", "Prevents 20-min idle kick")

local statusFrame = new("Frame", {AnchorPoint=Vector2.new(0,1), Size=UDim2.new(1,-16,0,42), Position=UDim2.new(0,8,1,-8), BackgroundColor3=THEME.BG3, BorderSizePixel=0, Parent=Sidebar}, {corner(6)})
new("TextLabel", {Size=UDim2.new(1,0,0,18), Position=UDim2.fromOffset(0,2), BackgroundTransparency=1, Text="Rusty Raft v2.0", Font=THEME.BoldFont, TextColor3=THEME.Text, TextSize=11, Parent=statusFrame})
local fpsLabel = new("TextLabel", {Size=UDim2.new(1,0,0,16), Position=UDim2.fromOffset(0,22), BackgroundTransparency=1, Text="FPS --  PING --", Font=THEME.Font, TextColor3=THEME.SubText, TextSize=10, Parent=statusFrame})

local minimized = false
track(MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
        Size = minimized and UDim2.fromOffset(620, 44) or UDim2.fromOffset(620, 420),
    }):Play()
      
