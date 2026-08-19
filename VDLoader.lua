--[[
    ██████╗ ██╗   ██╗██╗     ██╗  ██╗███████╗██╗   ██╗
    ██╔══██╗██║   ██║██║     ╚██╗██╔╝╚══███╔╝╚██╗ ██╔╝
    ██████╔╝██║   ██║██║      ╚███╔╝   ███╔╝  ╚████╔╝ 
    ██╔══██╗██║   ██║██║      ██╔██╗  ███╔╝    ╚██╔╝  
    ██║  ██║╚██████╔╝███████╗██╔╝ ██╗███████╗   ██║   
    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   
    
    RULLZYY EXEC VD - [CURE] Violence District
    Executor Support: Xeno | Ronix | Kernel | Fluxus | Delta
    Version: 1.0 Final
--]]

local RullzyyExec = {
    Name = "RullzyyExecVD",
    Version = "1.0",
    Support = {"Xeno","Ronix","Kernel","Fluxus","Delta"},
    Map = "[CURE] Violence District"
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- Libraries
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rullzyy/Scripts/main/AdwaitaLibrary.lua"))()

-- Variables
local SurvivorMenu = {}
local KillerMenu = {}
local AimbotMenu = {}
local ESPMenu = {}
local Visuals = {}

-- Config Table
local Config = {
    Survivor = {
        NoFallDamage = false,
        Invisible = false,
        AutoParry = false,
        AutoSkillcheck = false,
        SkillcheckMode = "Legit" -- Legit / Instant
    },
    Killer = {
        SpeedHack = false,
        AttackRange = false,
        WallHack = false,
        AutoAttack = false,
        StunImmunity = false
    },
    Aimbot = {
        Enabled = false,
        Crosshair = false,
        AutoAim = false,
        VeilSpear = false,
        Protection = false,
        FOV = 120,
        Smoothness = 0.3,
        TargetPart = "Head"
    },
    ESP = {
        Enabled = false,
        Survivor = false,
        Killer = false,
        Generator = false,
        Pallet = false,
        Progress = false,
        ColorMode = "Default"
    }
}

-- Logo ASCII
local Logo = [[
╔════════════════════════════════════════╗
║                                        ║
║    ██████╗ ██╗   ██╗██╗     ██╗  ██╗  ║
║    ██╔══██╗██║   ██║██║     ╚██╗██╔╝  ║
║    ██████╔╝██║   ██║██║      ╚███╔╝   ║
║    ██╔══██╗██║   ██║██║      ██╔██╗   ║
║    ██║  ██║╚██████╔╝███████╗██╔╝ ██╗  ║
║    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝  ║
║                                        ║
║    RULLZYY EXEC VD - v1.0              ║
║    [CURE] Violence District            ║
║    Executor: Xeno | Ronix | Kernel    ║
║             Fluxus | Delta            ║
╚════════════════════════════════════════╝
]]

print(Logo)

-- ===== SURVIVOR MENU =====
SurvivorMenu.Create = function()
    local Window = Library:CreateWindow("Survivor Menu [VD]", {Theme = "Adwaita Dark"})
    
    local MainTab = Window:CreateTab("Main")
    local ProtectionTab = Window:CreateTab("Protection")
    local SkillTab = Window:CreateTab("Skillcheck")
    
    -- Main Tab
    MainTab:CreateToggle("No Fall Damage", function(Value)
        Config.Survivor.NoFallDamage = Value
        if Value then
            Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        else
            Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end
    end)
    
    MainTab:CreateToggle("Invisible", function(Value)
        Config.Survivor.Invisible = Value
        if Value then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = 1
                end
            end
        else
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                    v.Transparency = 0
                end
            end
        end
    end)
    
    MainTab:CreateToggle("Auto Parry", function(Value)
        Config.Survivor.AutoParry = Value
        if Value then
            -- Auto parry logic
            local function CheckAttack()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name:find("Attack") and v.Parent and v.Parent:FindFirstChild("Humanoid") then
                        if (v.Position - Player.Character.HumanoidRootPart.Position).Magnitude < 10 then
                            -- Execute parry
                            local ParryRemote = ReplicatedStorage:FindFirstChild("ParryRemote")
                            if ParryRemote then
                                ParryRemote:FireServer()
                            end
                        end
                    end
                end
            end
            game:GetService("RunService").Heartbeat:Connect(CheckAttack)
        end
    end)
    
    -- Protection Tab
    ProtectionTab:CreateToggle("Anti Stun", function(Value)
        if Value then
            game:GetService("StunService").Enabled = false
        end
    end)
    
    ProtectionTab:CreateToggle("Anti Grab", function(Value)
        if Value then
            local GrabDetection = Player.Character:FindFirstChild("Grabbed")
            if GrabDetection then
                GrabDetection:Destroy()
            end
        end
    end)
    
    -- Skillcheck Tab
    SkillTab:CreateDropdown("Mode", {"Legit", "Instant"}, function(Value)
        Config.Survivor.SkillcheckMode = Value
    end)
    
    SkillTab:CreateToggle("Auto Skillcheck", function(Value)
        Config.Survivor.AutoSkillcheck = Value
        if Value then
            -- Auto skillcheck logic
            local function CheckSkillcheck()
                local SkillcheckGui = Player.PlayerGui:FindFirstChild("Skillcheck")
                if SkillcheckGui and SkillcheckGui.Visible then
                    if Config.Survivor.SkillcheckMode == "Instant" then
                        local SuccessRemote = ReplicatedStorage:FindFirstChild("SkillcheckSuccess")
                        if SuccessRemote then
                            SuccessRemote:FireServer(1)
                        end
                    else
                        -- Legit mode - automatic perfect timing
                        local buttons = SkillcheckGui:GetDescendants()
                        for _, btn in pairs(buttons) do
                            if btn:IsA("ImageButton") and btn.Name == "Success" then
                                btn:Click()
                                break
                            end
                        end
                    end
                end
            end
            game:GetService("RunService").RenderStepped:Connect(CheckSkillcheck)
        end
    end)
end

-- ===== KILLER MENU =====
KillerMenu.Create = function()
    local Window = Library:CreateWindow("Killer Menu [VD]", {Theme = "Adwaita Dark"})
    
    local MainTab = Window:CreateTab("Main")
    local CombatTab = Window:CreateTab("Combat")
    local UtilityTab = Window:CreateTab("Utility")
    
    MainTab:CreateToggle("Speed Hack", function(Value)
        Config.Killer.SpeedHack = Value
        if Value then
            local Humanoid = Player.Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = 45
                Humanoid.JumpPower = 100
            end
        else
            local Humanoid = Player.Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = 16
                Humanoid.JumpPower = 50
            end
        end
    end)
    
    MainTab:CreateToggle("Wall Hack", function(Value)
        Config.Killer.WallHack = Value
        if Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency > 0 then
                    v.Transparency = 0.3
                end
            end
        else
            Lighting.Brightness = 0.5
            Lighting.ClockTime = 18
            Lighting.FogEnd = 100
            Lighting.FogStart = 0
        end
    end)
    
    MainTab:CreateToggle("Stun Immunity", function(Value)
        Config.Killer.StunImmunity = Value
        if Value then
            local Humanoid = Player.Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.BreakJointsOnDeath = false
            end
        end
    end)
    
    CombatTab:CreateToggle("Auto Attack", function(Value)
        Config.Killer.AutoAttack = Value
        if Value then
            local function CheckSurvivors()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local Distance = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                        if Distance < 15 then
                            -- Auto attack nearest survivor
                            local AttackRemote = ReplicatedStorage:FindFirstChild("AttackRemote")
                            if AttackRemote then
                                AttackRemote:FireServer(v.Character.HumanoidRootPart.Position)
                            end
                        end
                    end
                end
            end
            game:GetService("RunService").Heartbeat:Connect(CheckSurvivors)
        end
    end)
    
    CombatTab:CreateSlider("Attack Range", 0, 30, 15, function(Value)
        Config.Killer.AttackRange = Value
    end)
    
    UtilityTab:CreateToggle("Killer Invisible", function(Value)
        if Value then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = 0.8
                end
            end
        else
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = 0
                end
            end
        end
    end)
    
    UtilityTab:CreateButton("Reset Stats", function()
        local Humanoid = Player.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
end

-- ===== AIMBOT MENU =====
AimbotMenu.Create = function()
    local Window = Library:CreateWindow("Aimbot Menu [VD]", {Theme = "Adwaita Dark"})
    
    local MainTab = Window:CreateTab("Aimbot")
    local VisualTab = Window:CreateTab("Visuals")
    local VeilTab = Window:CreateTab("Veil Spear")
    
    MainTab:CreateToggle("Enabled", function(Value)
        Config.Aimbot.Enabled = Value
        if Value then
            -- Aimbot loop
            local function Aim()
                local Target = nil
                local Closest = math.huge
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local Distance = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                        if Distance < Config.Aimbot.FOV and Distance < Closest then
                            Closest = Distance
                            Target = v
                        end
                    end
                end
                
                if Target then
                    local TargetPos = Target.Character[Config.Aimbot.TargetPart].Position
                    local LookVector = (TargetPos - Camera.CFrame.Position).Unit
                    local NewCFrame = CFrame.new(Camera.CFrame.Position, TargetPos)
                    Camera.CFrame = Camera.CFrame:Lerp(NewCFrame, Config.Aimbot.Smoothness)
                end
            end
            
            game:GetService("RunService").RenderStepped:Connect(Aim)
        end
    end)
    
    MainTab:CreateDropdown("Target Part", {"Head", "HumanoidRootPart", "Torso"}, function(Value)
        Config.Aimbot.TargetPart = Value
    end)
    
    MainTab:CreateSlider("FOV", 30, 360, 120, function(Value)
        Config.Aimbot.FOV = Value
    end)
    
    MainTab:CreateSlider("Smoothness", 0.1, 1, 0.3, function(Value)
        Config.Aimbot.Smoothness = Value
    end)
    
    VisualTab:CreateToggle("Crosshair", function(Value)
        Config.Aimbot.Crosshair = Value
        if Value then
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "CrosshairGUI"
            ScreenGui.Parent = Player.PlayerGui
            
            local Crosshair = Instance.new("ImageLabel")
            Crosshair.Name = "Crosshair"
            Crosshair.Size = UDim2.new(0, 30, 0, 30)
            Crosshair.Position = UDim2.new(0.5, -15, 0.5, -15)
            Crosshair.BackgroundTransparency = 1
            Crosshair.Image = "rbxassetid://1234567890" -- Placeholder
            Crosshair.Parent = ScreenGui
        else
            local gui = Player.PlayerGui:FindFirstChild("CrosshairGUI")
            if gui then gui:Destroy() end
        end
    end)
    
    VeilTab:CreateToggle("Veil Spear Auto Aim", function(Value)
        Config.Aimbot.VeilSpear = Value
        if Value then
            local function AutoSpear()
                local Target = nil
                local Closest = math.huge
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local Distance = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                        if Distance < 60 and Distance < Closest then
                            Closest = Distance
                            Target = v
                        end
                    end
                end
                
                if Target then
                    local SpearRemote = ReplicatedStorage:FindFirstChild("VeilSpearRemote")
                    if SpearRemote then
                        SpearRemote:FireServer(Target.Character.HumanoidRootPart.Position)
                    end
                end
            end
            game:GetService("RunService").Heartbeat:Connect(AutoSpear)
        end
    end)
    
    VeilTab:CreateToggle("Protection Mode", function(Value)
        Config.Aimbot.Protection = Value
        if Value then
            -- Auto dodge/block incoming attacks
            local function DetectThreats()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name:find("Projectile") then
                        local Direction = (v.Velocity).Unit
                        local Distance = (v.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                        if Distance < 20 and Direction:Dot(Player.Character.HumanoidRootPart.CFrame.LookVector) < -0.5 then
                            -- Move away from projectile
                            local Humanoid = Player.Character:FindFirstChild("Humanoid")
                            if Humanoid then
                                local MoveDir = (Player.Character.HumanoidRootPart.Position - v.Position).Unit
                                Humanoid:Move(MoveDir, true)
                            end
                        end
                    end
                end
            end
            game:GetService("RunService").Heartbeat:Connect(DetectThreats)
        end
    end)
end

-- ===== ESP MENU =====
ESPMenu.Create = function()
    local Window = Library:CreateWindow("ESP Menu [VD]", {Theme = "Adwaita Dark"})
    
    local MainTab = Window:CreateTab("Main")
    local ColorsTab = Window:CreateTab("Colors")
    local ObjectsTab = Window:CreateTab("Objects")
    
    MainTab:CreateToggle("ESP Enabled", function(Value)
        Config.ESP.Enabled = Value
        if Value then
            -- ESP loop
            local function DrawESP()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= Player and v.Character then
                        local HRP = v.Character:FindFirstChild("HumanoidRootPart")
                        if HRP then
                            local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
                            if OnScreen then
                                -- Draw ESP box
                                local Box = Instance.new("Frame")
                                Box.Size = UDim2.new(0, 100, 0, 200)
                                Box.Position = UDim2.new(0, Pos.X - 50, 0, Pos.Y - 100)
                                Box.BackgroundTransparency = 0.5
                                Box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                                Box.BorderSizePixel = 0
                                Box.Parent = Player.PlayerGui
                                
                                -- Health bar
                                local HealthBar = Instance.new("Frame")
                                HealthBar.Size = UDim2.new(1, 0, 0, 5)
                                HealthBar.Position = UDim2.new(0, 0, 1, 0)
                                HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                                HealthBar.Parent = Box
                                
                                -- Name label
                                local NameLabel = Instance.new("TextLabel")
                                NameLabel.Text = v.Name
                                NameLabel.Size = UDim2.new(1, 0, 0, 20)
                                NameLabel.Position = UDim2.new(0, 0, -1.1, 0)
                                NameLabel.BackgroundTransparency = 1
                                NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                NameLabel.TextSize = 14
                                NameLabel.Parent = Box
                            end
                        end
                    end
                end
            end
            
            game:GetService("RunService").RenderStepped:Connect(DrawESP)
        else
            -- Cleanup ESP
            for _, v in pairs(Player.PlayerGui:GetChildren()) do
                if v:IsA("Frame") then
                    v:Destroy()
                end
            end
        end
    end)
    
    MainTab:CreateToggle("Survivor ESP", function(Value)
        Config.ESP.Survivor = Value
    end)
    
    MainTab:CreateToggle("Killer ESP", function(Value)
        Config.ESP.Killer = Value
    end)
    
    ObjectsTab:CreateToggle("Generator ESP", function(Value)
        Config.ESP.Generator = Value
        if Value then
            -- Generator ESP logic
            local function FindGenerators()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name:find("Generator") then
                        local Pos, OnScreen = Camera:WorldToViewportPoint(v.Position)
                        if OnScreen then
                            local Dot = Instance.new("Frame")
                            Dot.Size = UDim2.new(0, 10, 0, 10)
                            Dot.Position = UDim2.new(0, Pos.X - 5, 0, Pos.Y - 5)
                            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                            Dot.BackgroundTransparency = 0.3
                            Dot.Parent = Player.PlayerGui
                        end
                    end
                end
            end
            game:GetService("RunService").RenderStepped:Connect(FindGenerators)
        end
    end)
    
    ObjectsTab:CreateToggle("Pallet ESP", function(Value)
        Config.ESP.Pallet = Value
        if Value then
            -- Pallet ESP logic
            local function FindPallets()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name:find("Pallet") then
                        local Pos, OnScreen = Camera:WorldToViewportPoint(v.Position)
                        if OnScreen then
                            local Dot = Instance.new("Frame")
                            Dot.Size = UDim2.new(0, 8, 0, 8)
                            Dot.Position = UDim2.new(0, Pos.X - 4, 0, Pos.Y - 4)
                            Dot.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
                            Dot.BackgroundTransparency = 0.3
                            Dot.Parent = Player.PlayerGui
                        end
                    end
                end
            end
            game:GetService("RunService").RenderStepped:Connect(FindPallets)
        end
    end)
    
    ObjectsTab:CreateToggle("Progress ESP", function(Value)
        Config.ESP.Progress = Value
        if Value then
            -- Show generator progress
            local function ShowProgress()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name:find("Generator") then
                        local Progress = v:GetAttribute("Progress")
                        if Progress then
                            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Position)
                            if OnScreen then
                                local ProgressBar = Instance.new("Frame")
                                ProgressBar.Size = UDim2.new(0, 100, 0, 10)
                                ProgressBar.Position = UDim2.new(0, Pos.X - 50, 0, Pos.Y + 20)
                                ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                ProgressBar.BackgroundTransparency = 0.5
                                ProgressBar.Parent = Player.PlayerGui
                                
                                local Fill = Instance.new("Frame")
                                Fill.Size = UDim2.new(Progress / 100, 0, 1, 0)
                                Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                                Fill.Parent = ProgressBar
                            end
                        end
                    end
                end
            end
            game:GetService("RunService").RenderStepped:Connect(ShowProgress)
        end
    end)
    
    ColorsTab:CreateColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(Color)
        Config.ESP.ColorMode = Color
    end)
end

-- ===== FEATURE COMMANDS =====
local Commands = {
    ["/survivor"] = function()
        SurvivorMenu.Create()
    end,
    ["/killer"] = function()
        KillerMenu.Create()
    end,
    ["/aimbot"] = function()
        AimbotMenu.Create()
    end,
    ["/esp"] = function()
        ESPMenu.Create()
    end,
    ["/menu"] = function()
        print(Logo)
        print("Commands:")
        print("/survivor - Open Survivor Menu")
        print("/killer - Open Killer Menu")
        print("/aimbot - Open Aimbot Menu")
        print("/esp - Open ESP Menu")
        print("/menu - Show this menu")
    end
}

-- Command Handler
local function HandleCommand(Input)
    local Command = Commands[Input]
    if Command then
        Command()
    else
        print("Unknown command. Type /menu for help.")
    end
end

-- Check for Xeno Executor compatibility
local function CheckExecutor()
    local Executors = {
        Xeno = syn and syn.xeno,
        Ronix = ronix and ronix.is_running,
        Kernel = kernel and kernel.is_loaded,
        Fluxus = fluxus and fluxus.is_connected,
        Delta = delta and delta.is_available
    }
    
    local Supported = false
    for Executor, Loaded in pairs(Executors) do
        if Loaded then
            Supported = true
            print("Loaded on: " .. Executor)
            break
        end
    end
    
    if not Supported then
        print("Executor not detected. Running in standard mode.")
    end
end

-- Initialize
local function Initialize()
    CheckExecutor()
    print("RullzyyExecVD loaded successfully!")
    print("Map: [CURE] Violence District")
    print("Type /menu for commands")
    
    -- UI Cleanup on exit
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
        for _, v in pairs(Player.PlayerGui:GetChildren()) do
            if v.Name:find("Rullzyy") then
                v:Destroy()
            end
        end
    end)
end

-- Hotkey handler
UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
    
    if Input.KeyCode == Enum.KeyCode.RightControl then
        HandleCommand("/menu")
    end
end)

Initialize()

-- Main loop for features
local function FeatureLoop()
    -- Anti AFK
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    
    -- Survivor: No Fall Damage
    if Config.Survivor.NoFallDamage and Player.Character then
        local Humanoid = Player.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end
    end
    
    -- Survivor: Auto Parry
    if Config.Survivor.AutoParry then
        -- Parry logic
    end
    
    -- Killer: Speed Hack
    if Config.Killer.SpeedHack and Player.Character then
        local Humanoid = Player.Character:FindFirstChild("Humanoid")
        if Humanoid and Humanoid.WalkSpeed < 45 then
            Humanoid.WalkSpeed = 45
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(FeatureLoop)

-- Global command handler
getgenv().RullzyyExec = {
    Execute = function(Command)
        HandleCommand(Command)
    end,
    Version = RullzyyExec.Version,
    Support = RullzyyExec.Support
}

print("RullzyyExecVD is ready.")
print("==========================================")