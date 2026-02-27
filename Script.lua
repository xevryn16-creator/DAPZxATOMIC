-- [[ DAPZxATOMIC | FISHING GOD EDITION ]] --
local ScriptName = "DAPZxATOMIC"
local OldGui = game.CoreGui:FindFirstChild(ScriptName)
if OldGui then OldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = ScriptName
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local ScreenSaver = Instance.new("Frame", ScreenGui)
ScreenSaver.Size = UDim2.new(10, 0, 10, 0)
ScreenSaver.Position = UDim2.new(-5, 0, -5, 0)
ScreenSaver.ZIndex = 9999
ScreenSaver.Visible = false

local Colors = {
    Sidebar = Color3.fromRGB(12, 12, 18),
    Accent = Color3.fromRGB(0, 200, 255),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(130, 130, 150),
    ItemBg = Color3.fromRGB(20, 20, 25)
}

-- COORDINATES --
local IslandCoords = {
    {Name = "Stater Island 1", Pos = Vector3.new(119.98, 67.28, -926.37)},
    {Name = "Stater Island 2", Pos = Vector3.new(112.65, 51.34, -846.82)},
    {Name = "Glacier Island 1", Pos = Vector3.new(-36.76, 46.91, 640.59)},
    {Name = "Glacier Island 2", Pos = Vector3.new(48.51, 46.56, 843.41)},
    {Name = "Temple Island 1", Pos = Vector3.new(1157.94, 48.14, -3.49)},
    {Name = "Temple Island 2", Pos = Vector3.new(1506.06, 59.90, -8.89)},
    {Name = "Sky Heaven",      Pos = Vector3.new(1993.38, 902.81, -646.18)},
    {Name = "Candy Island",Pos = Vector3.new(-994.31, 49.11, 40.90)},
}

-- SETTINGS (REBRANDED GLOBALS) --
_G.AtomicRunning = true
_G.AtomicFishBasic = false
_G.AtomicFishAdv = false
_G.AtomicCustomRod = false
_G.AtomicDelayBasic = 1.5 
_G.AtomicDelayAdv = 0.05 
_G.AtomicRodName = "serpent Rod" 
_G.AtomicBait = "Bag-O-Gold"
_G.AtomicZone = "stater" 
_G.AtomicSpoofRarity = ""
_G.AtomicSpoofWeight = ""
_G.AtomicAutoSell = false
_G.AtomicSellDelay = 10
_G.AtomicWalkToggle = false
_G.AtomicWalkVal = 16
_G.AtomicFlyToggle = false
_G.AtomicFlyVal = 16
_G.AtomicNoclip = false

-- SERVICES --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem", 5)

-- UI HELPERS --
local function AddGradient(Parent)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(10, 10, 20)), 
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 60, 110))
    }
    UIGradient.Rotation = 45
    UIGradient.Parent = Parent
end

local function AddAtomicBorder(Parent)
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 3
    Stroke.Parent = Parent
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.25, Colors.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.75, Colors.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }
    Gradient.Parent = Stroke
    RunService.RenderStepped:Connect(function()
        if Parent and Parent.Parent then Gradient.Rotation = (Gradient.Rotation + 2) % 360 end
    end)
end

-- LOGO / TOGGLE BUTTON --
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.BackgroundColor3 = Colors.Sidebar
ToggleBtn.AnchorPoint = Vector2.new(0,0.5)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, 0 )
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Image = "rbxassetid://72264271152446" -- Aset ID Kamu
ToggleBtn.Visible = false
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", ToggleBtn).Color = Colors.Accent

-- MAIN UI --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 260) 
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
AddGradient(MainFrame)
AddAtomicBorder(MainFrame)

local InnerFrame = Instance.new("Frame", MainFrame)
InnerFrame.Size = UDim2.new(1, 0, 1, 0)
InnerFrame.BackgroundTransparency = 1
InnerFrame.ClipsDescendants = true
Instance.new("UICorner", InnerFrame).CornerRadius = UDim.new(0, 10)

local CloseBtn = Instance.new("TextButton", InnerFrame)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)

local MinBtn = Instance.new("TextButton", InnerFrame)
MinBtn.Text = "-"
MinBtn.TextColor3 = Colors.SubText
MinBtn.BackgroundTransparency = 1
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -55, 0, 5)

local Title = Instance.new("TextLabel", InnerFrame)
Title.Text = "DAPZxATOMIC | PREMIER"
Title.TextColor3 = Colors.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 11
Title.Position = UDim2.new(0, 15, 0, 10)
Title.Size = UDim2.new(0, 200, 0, 15)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local Body = Instance.new("Frame", InnerFrame)
Body.Size = UDim2.new(1, 0, 1, -30)
Body.Position = UDim2.new(0, 0, 0, 30)
Body.BackgroundTransparency = 1

local Sidebar = Instance.new("ScrollingFrame", Body)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.5
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2

local Content = Instance.new("Frame", Body)
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 115, 0, 0)
Content.Size = UDim2.new(1, -120, 1, 0)

-- TAB SYSTEM --
local Tabs = {}
local PageCounters = {}

local function CreateTab(Name, Icon, Order)
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local PL = Instance.new("UIListLayout", Page)
    PL.Padding = UDim.new(0, 5)
    
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.BackgroundTransparency = 1
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.Text = Name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextColor3 = Colors.SubText
    Btn.TextSize = 9
    Btn.LayoutOrder = Order

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible = false t.Btn.TextColor3 = Colors.SubText end
        Page.Visible = true
        Btn.TextColor3 = Colors.Accent
    end)
    
    table.insert(Tabs, {Btn = Btn, Page = Page})
    return Page
end

-- PLACEHOLDERS FOR FUNCTIONS --
local function GetFishData(tool)
    local fId = tool:GetAttribute("fishId") or tool:GetAttribute("FishId")
    if fId then
        return {
            fishId = fId,
            rarity = _G.AtomicSpoofRarity ~= "" and _G.AtomicSpoofRarity or (tool:GetAttribute("rarity") or "Common"),
            weight = tonumber(_G.AtomicSpoofWeight) or (tool:GetAttribute("weight") or 1)
        }
    end
    return nil
end

local function AtomicSellAll()
    local batch = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        local data = GetFishData(v)
        if data then table.insert(batch, data) end
    end
    if #batch > 0 then
        FishingSystem:WaitForChild("SellFish"):FireServer("SellAllBatch", batch)
    end
end

-- UI PAGES --
local Tab1 = CreateTab("Home", "🏠", 1)
local Tab2 = CreateTab("Fishing", "🎣", 2)
local Tab3 = CreateTab("Movement", "🏃", 3)

-- HOME --
local IBox = Instance.new("Frame", Tab1)
IBox.Size = UDim2.new(0.95, 0, 0, 100)
IBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", IBox)
local ITxt = Instance.new("TextLabel", IBox)
ITxt.Size = UDim2.new(1, -10, 1, -10)
ITxt.Position = UDim2.new(0, 5, 0, 5)
ITxt.Text = "Welcome to DAPZxATOMIC PREMIER.\n\nEnjoy the most advanced Fishing script.\nAlways use with caution."
ITxt.TextColor3 = Colors.Text
ITxt.Font = Enum.Font.Gotham
ITxt.TextSize = 10
ITxt.TextWrapped = true
ITxt.BackgroundTransparency = 1

-- FISHING LOGIC --
task.spawn(function()
    while _G.AtomicRunning do
        if _G.AtomicFishBasic then
            pcall(function()
                local root = LocalPlayer.Character.HumanoidRootPart
                local Bobber = root.Position + (root.CFrame.LookVector * 15)
                FishingSystem.CastReplication:FireServer(root.Position, Bobber, "serpent Rod", 100)
                task.wait(_G.AtomicDelayBasic)
                FishingSystem.FishGiver:FireServer({{hookPosition = Bobber, zone = _G.AtomicZone}})
                FishingSystem.CleanupCast:FireServer()
            end)
        end
        task.wait(0.5)
    end
end)

-- MOVEMENT --
RunService.Stepped:Connect(function()
    if not _G.AtomicRunning then return end
    local char = LocalPlayer.Character
    if char then
        if _G.AtomicNoclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if _G.AtomicWalkToggle then
            char.Humanoid.WalkSpeed = _G.AtomicWalkVal
        end
    end
end)

-- BUTTON EVENTS --
CloseBtn.MouseButton1Click:Connect(function()
    _G.AtomicRunning = false
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
end)

-- Default Open --
Tabs[1].Page.Visible = true
Tabs[1].Btn.TextColor3 = Colors.Accent

print("DAPZxATOMIC Loaded Successfully.")
