-- Arqel GUI System Recreation
local genv = getgenv()

-- Core Services
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local CoreGui = game:GetService('CoreGui')
local HttpService = game:GetService('HttpService')
local Workspace = game:GetService('Workspace')
local Lighting = game:GetService('Lighting')
local RunService = game:GetService('RunService')

-- State Management
genv.ArqelLoaded = true
genv.ArqelClosed = false

-- Color Palette
local Colors = {
    Accent = Color3.fromRGB(139, 0, 0),
    AccentHover = Color3.fromRGB(170, 20, 20),
    Background = Color3.fromRGB(15, 15, 15),
    Header = Color3.fromRGB(20, 20, 20),
    Input = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(120, 120, 120),
    Success = Color3.fromRGB(50, 205, 110),
    Error = Color3.fromRGB(245, 70, 90),
    Warning = Color3.fromRGB(255, 180, 50),
    StatusIdle = Color3.fromRGB(180, 80, 80),
    Discord = Color3.fromRGB(88, 101, 242),
    DiscordHover = Color3.fromRGB(114, 137, 218),
    Divider = Color3.fromRGB(45, 45, 70)
}

-- Configuration
local Config = {
    IconSize = UDim2.new(0, 30, 0, 30),
    BlurEnabled = true,
    DraggableEnabled = true,
    Icon = 'rbxassetid://95721401302279',
    Title = 'Arqel',
    Subtitle = 'Enter your key to continue',
    FileName = 'Arqel_Key'
}

-- Main Arqel System
local Arqel = {
    Options = {
        Blur = Config.BlurEnabled,
        Draggable = Config.DraggableEnabled
    },
    Callbacks = {},
    Links = {
        GetKey = '',
        Discord = ''
    },
    Storage = {
        AutoLoad = true,
        Remember = true,
        FileName = Config.FileName
    },
    Theme = {
        Accent = Colors.Accent,
        AccentHover = Colors.AccentHover,
        Background = Colors.Background,
        Header = Colors.Header,
        Input = Colors.Input,
        Text = Colors.Text,
        TextDim = Colors.TextDim,
        Success = Colors.Success,
        Error = Colors.Error,
        Warning = Colors.Warning,
        StatusIdle = Colors.StatusIdle,
        Discord = Colors.Discord,
        DiscordHover = Colors.DiscordHover,
        Divider = Colors.Divider
    },
    Appearance = {
        IconSize = Config.IconSize,
        Title = Config.Title,
        Subtitle = Config.Subtitle,
        Icon = Config.Icon
    }
}

-- Notification System
function Arqel:Notify(icon, title, message, duration)
    duration = duration or 3
    
    local viewport = Workspace.CurrentCamera.ViewportSize
    local scale = math.clamp(math.min(viewport.X, viewport.Y) / 900, 0.65, 1.3)
    local width = math.clamp(320 * scale, 260, 380)
    local height = math.clamp(80 * scale, 65, 95)
    
    local screenGui = Instance.new('ScreenGui')
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.Parent = CoreGui
    
    local mainFrame = Instance.new('Frame')
    mainFrame.Size = UDim2.new(0, width, 0, height)
    mainFrame.Position = UDim2.new(1, width + 20, 1, -15)
    mainFrame.AnchorPoint = Vector2.new(1, 1)
    mainFrame.BackgroundColor3 = Colors.Header
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new('UICorner', mainFrame)
    corner.CornerRadius = UDim.new(0, 4)
    
    local stroke = Instance.new('UIStroke', mainFrame)
    stroke.Color = Colors.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    
    local progressFrame = Instance.new('Frame')
    progressFrame.Size = UDim2.new(1, 0, 0, 4)
    progressFrame.Position = UDim2.new(0, 0, 1, -4)
    progressFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    progressFrame.BorderSizePixel = 0
    progressFrame.Parent = mainFrame
    
    local progressBar = Instance.new('Frame')
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Colors.Accent
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressFrame
    
    local iconLabel = Instance.new('ImageLabel')
    iconLabel.Size = UDim2.new(0, height - 35, 0, height - 35)
    iconLabel.Position = UDim2.new(0, 14, 0.5, -2)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.ScaleType = Enum.ScaleType.Fit
    iconLabel.Parent = mainFrame
    iconLabel.Image = icon or Config.Icon
    iconLabel.ImageColor3 = Colors.Text
    
    local titleLabel = Instance.new('TextLabel')
    titleLabel.Size = UDim2.new(1, -(height + 28), 0, 24)
    titleLabel.Position = UDim2.new(0, height + 14, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = math.clamp(15 * scale, 13, 18)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = Colors.Text
    titleLabel.Text = title
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = mainFrame
    
    local messageLabel = Instance.new('TextLabel')
    messageLabel.Size = UDim2.new(1, -(height + 28), 0, 22)
    messageLabel.Position = UDim2.new(0, height + 14, 0, 38)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.TextSize = math.clamp(13 * scale, 11, 15)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextColor3 = Colors.TextDim
    messageLabel.Text = message
    messageLabel.TextTruncate = Enum.TextTruncate.AtEnd
    messageLabel.Parent = mainFrame
    
    local uniqueId = tick() .. HttpService:GenerateGUID(false)
    
    -- Animate in
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        Position = UDim2.new(1, -15, 1, -15)
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Position = UDim2.new(1, -15, 1, -15)
    }):Play()
    
    -- Progress bar animation
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()
    
    -- Auto remove
    task.delay(duration, function()
        if uniqueId == uniqueId then
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Position = UDim2.new(1, width + 20, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
            }):Play()
            task.wait(0.3)
            screenGui:Destroy()
        end
    end)
    
    -- Click to dismiss
    local dismissButton = Instance.new('TextButton')
    dismissButton.Size = UDim2.new(1, 0, 1, 0)
    dismissButton.BackgroundTransparency = 1
    dismissButton.Text = ''
    dismissButton.Parent = mainFrame
    
    dismissButton.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Position = UDim2.new(1, width + 20, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
        }):Play()
        task.wait(0.3)
        screenGui:Destroy()
    end)
    
    return screenGui
end

-- Key Management
function Arqel:ClearSavedKey()
    delfile(Config.FileName .. '.txt')
    return true
end

function Arqel:GetSavedKey()
    return nil
end

-- Main Launch Function
function Arqel:Launch()
    -- Implementation would go here based on original functionality
    self:Notify(Config.Icon, 'Arqel', 'System initialized', 3)
end

function Arqel:LaunchJunkie(serviceData)
    genv.ArqelClosed = false
    
    -- Load external SDK
    local sdk = loadstring(game:HttpGet('https://jnkie.com/sdk/library.lua'))()
    sdk.service = serviceData.Service
    sdk.identifier = serviceData.Identifier
    sdk.provider = serviceData.Provider
    
    local keyValid = sdk.check_key('KEYLESS').valid
    
    -- Clean up existing UI
    local existingUI = CoreGui:FindFirstChild('ArqelKeylessSystem') or CoreGui:FindFirstChild('ArqelKeySystem')
    if existingUI then existingUI:Destroy() end
    
    local blur = Lighting:FindFirstChild('ArqelKeySystemBlur')
    if blur then blur:Destroy() end
    
    -- Create blur effect
    local blurEffect = Instance.new('BlurEffect')
    blurEffect.Name = 'ArqelKeySystemBlur'
    blurEffect.Size = 0
    blurEffect.Parent = Lighting
    
    TweenService:Create(blurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = 24}):Play()
    
    -- Create main UI (simplified version)
    local screenGui = Instance.new('ScreenGui')
    screenGui.Name = 'ArqelKeylessSystem'
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = CoreGui
    
    -- Main frame implementation would continue here...
    
    return screenGui
end

-- Initialize Global
genv.Arqel = Arqel

-- Return the system
return {
    Options = Arqel.Options,
    Notify = Arqel.Notify,
    Callbacks = Arqel.Callbacks,
    ClearSavedKey = Arqel.ClearSavedKey,
    Links = Arqel.Links,
    Storage = Arqel.Storage,
    GetSavedKey = Arqel.GetSavedKey,
    LaunchJunkie = Arqel.LaunchJunkie,
    Launch = Arqel.Launch,
    Theme = Arqel.Theme,
    Appearance = Arqel.Appearance
}
