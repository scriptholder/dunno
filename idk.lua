-- Arqel UI System - Cleaned Recreation
local genv = getgenv()

-- Core Services
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local CoreGui = game:GetService('CoreGui')
local HttpService = game:GetService('HttpService')
local Workspace = game:GetService('Workspace')
local Lighting = game:GetService('Lighting')

-- State Management
genv.ArqelLoaded = genv.ArqelLoaded or false
genv.ArqelClosed = genv.ArqelClosed or false

if genv.ArqelLoaded then 
    return genv.Arqel
end

-- Configuration
local Config = {
    Colors = {
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
        Discord = Color3.fromRGB(88, 101, 242),
        DiscordHover = Color3.fromRGB(114, 137, 218),
        Divider = Color3.fromRGB(45, 45, 70)
    },
    IconSize = UDim2.new(0, 30, 0, 30),
    Icon = 'rbxassetid://95721401302279'
}

-- Main Arqel System
local Arqel = {
    Options = {
        Blur = true,
        Draggable = true
    },
    Callbacks = {
        OnVerify = function(key) return false end,
        OnSuccess = function() end,
        OnFailure = function() end
    },
    Links = {
        GetKey = '',
        Discord = ''
    },
    Storage = {
        AutoLoad = true,
        Remember = true,
        FileName = 'Arqel_Key'
    },
    Theme = Config.Colors,
    Appearance = {
        IconSize = Config.IconSize,
        Title = 'Arqel',
        Subtitle = 'Enter your key to continue',
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
    mainFrame.BackgroundColor3 = Config.Colors.Header
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new('UICorner', mainFrame)
    corner.CornerRadius = UDim.new(0, 4)
    
    local stroke = Instance.new('UIStroke', mainFrame)
    stroke.Color = Config.Colors.Accent
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
    progressBar.BackgroundColor3 = Config.Colors.Accent
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
    iconLabel.ImageColor3 = Config.Colors.Text
    
    local titleLabel = Instance.new('TextLabel')
    titleLabel.Size = UDim2.new(1, -(height + 28), 0, 24)
    titleLabel.Position = UDim2.new(0, height + 14, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = math.clamp(15 * scale, 13, 18)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = Config.Colors.Text
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
    messageLabel.TextColor3 = Config.Colors.TextDim
    messageLabel.Text = message
    messageLabel.TextTruncate = Enum.TextTruncate.AtEnd
    messageLabel.Parent = mainFrame
    
    local uniqueId = tick() .. HttpService:GenerateGUID(false)
    
    -- Animate in
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
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

-- Key Management Functions
function Arqel:ClearSavedKey()
    delfile(self.Storage.FileName .. '.txt')
    return true
end

function Arqel:GetSavedKey()
    return nil
end

-- Main Launch Function
function Arqel:Launch()
    if genv.ArqelLoaded then return end
    genv.ArqelLoaded = true
    
    -- Remove existing UI
    local existingUI = CoreGui:FindFirstChild('ArqelKeySystem') or CoreGui:FindFirstChild('ArqelKeylessSystem')
    if existingUI then existingUI:Destroy() end
    
    local blur = Lighting:FindFirstChild('ArqelKeySystemBlur')
    if blur then blur:Destroy() end
    
    -- Create main key system UI
    local screenGui = Instance.new('ScreenGui')
    screenGui.Name = 'ArqelKeySystem'
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = CoreGui
    
    -- Main frame
    local mainFrame = Instance.new('Frame')
    mainFrame.Size = UDim2.new(0, 300, 0, 265)
    mainFrame.Position = UDim2.new(0.5, 0, 1.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Config.Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new('UICorner', mainFrame)
    corner.CornerRadius = UDim.new(0, 4)
    
    local stroke = Instance.new('UIStroke', mainFrame)
    stroke.Color = Config.Colors.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0.4
    
    -- Header
    local header = Instance.new('Frame')
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Config.Colors.Header
    header.BorderSizePixel = 0
    header.Active = true
    header.Parent = mainFrame
    
    local headerCorner = Instance.new('UICorner', header)
    headerCorner.CornerRadius = UDim.new(0, 4)
    
    local headerIcon = Instance.new('ImageLabel')
    headerIcon.Size = UDim2.new(0, 30, 0, 30)
    headerIcon.Position = UDim2.new(0, 14, 0.5, 0)
    headerIcon.AnchorPoint = Vector2.new(0, 0.5)
    headerIcon.BackgroundTransparency = 1
    headerIcon.Image = Config.Icon
    headerIcon.ImageColor3 = Config.Colors.Text
    headerIcon.ScaleType = Enum.ScaleType.Fit
    headerIcon.Parent = header
    
    local headerTitle = Instance.new('TextLabel')
    headerTitle.Size = UDim2.new(1, -90, 1, 0)
    headerTitle.Position = UDim2.new(0, 54, 0, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = self.Appearance.Title
    headerTitle.TextColor3 = Config.Colors.Text
    headerTitle.TextSize = 26
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.Parent = header
    
    -- Close button
    local closeButton = Instance.new('ImageButton')
    closeButton.Size = UDim2.new(0, 18, 0, 18)
    closeButton.Position = UDim2.new(1, -14, 0.5, 0)
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = 'rbxassetid://6022668916'
    closeButton.ImageColor3 = Config.Colors.TextDim
    closeButton.ScaleType = Enum.ScaleType.Fit
    closeButton.Parent = header
    
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.15), {ImageColor3 = Config.Colors.Error}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.15), {ImageColor3 = Config.Colors.TextDim}):Play()
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        genv.ArqelClosed = true
        screenGui:Destroy()
    end)
    
    -- Input field
    local inputFrame = Instance.new('Frame')
    inputFrame.Size = UDim2.new(0.94, 0, 0, 52)
    inputFrame.Position = UDim2.new(0.5, 0, 0, 60)
    inputFrame.AnchorPoint = Vector2.new(0.5, 0)
    inputFrame.BackgroundColor3 = Config.Colors.Input
    inputFrame.BackgroundTransparency = 0.85
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = mainFrame
    
    local inputCorner = Instance.new('UICorner', inputFrame)
    inputCorner.CornerRadius = UDim.new(0, 4)
    
    local inputStroke = Instance.new('UIStroke', inputFrame)
    inputStroke.Color = Config.Colors.Accent
    inputStroke.Thickness = 1
    inputStroke.Transparency = 0.5
    
    local keyInput = Instance.new('TextBox')
    keyInput.Size = UDim2.new(1, -60, 1, 0)
    keyInput.Position = UDim2.new(0, 52, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = 'Enter your key...'
    keyInput.Text = ''
    keyInput.TextColor3 = Config.Colors.Text
    keyInput.TextSize = 16
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.Parent = inputFrame
    
    -- Submit button
    local submitButton = Instance.new('TextButton')
    submitButton.Size = UDim2.new(0.75, 0, 0, 42)
    submitButton.Position = UDim2.new(0.5, 0, 0, 163)
    submitButton.AnchorPoint = Vector2.new(0.5, 0)
    submitButton.BackgroundColor3 = Config.Colors.Accent
    submitButton.BorderSizePixel = 0
    submitButton.Text = ''
    submitButton.AutoButtonColor = false
    submitButton.Parent = mainFrame
    
    local submitCorner = Instance.new('UICorner', submitButton)
    submitCorner.CornerRadius = UDim.new(0, 4)
    
    local submitStroke = Instance.new('UIStroke', submitButton)
    submitStroke.Color = Config.Colors.AccentHover
    submitStroke.Thickness = 1
    submitStroke.Transparency = 0.5
    
    local submitContent = Instance.new('Frame')
    submitContent.Size = UDim2.new(1, 0, 1, 0)
    submitContent.BackgroundTransparency = 1
    submitContent.Parent = submitButton
    
    local submitLayout = Instance.new('UIListLayout', submitContent)
    submitLayout.FillDirection = Enum.FillDirection.Horizontal
    submitLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    submitLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    submitLayout.Padding = UDim.new(0, 8)
    
    local submitIcon = Instance.new('ImageLabel')
    submitIcon.Size = UDim2.new(0, 18, 0, 18)
    submitIcon.BackgroundTransparency = 1
    submitIcon.Image = 'rbxassetid://89965059528921'
    submitIcon.ImageColor3 = Config.Colors.Text
    submitIcon.ScaleType = Enum.ScaleType.Fit
    submitIcon.LayoutOrder = 1
    submitIcon.Parent = submitContent
    
    local submitLabel = Instance.new('TextLabel')
    submitLabel.Size = UDim2.new(0, 0, 0, 18)
    submitLabel.AutomaticSize = Enum.AutomaticSize.X
    submitLabel.BackgroundTransparency = 1
    submitLabel.Text = 'Submit Key'
    submitLabel.TextColor3 = Config.Colors.Text
    submitLabel.TextSize = 15
    submitLabel.Font = Enum.Font.GothamBold
    submitLabel.LayoutOrder = 2
    submitLabel.Parent = submitContent
    
    -- Button interactions
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.15), {BackgroundColor3 = Config.Colors.AccentHover}):Play()
    end)
    
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.15), {BackgroundColor3 = Config.Colors.Accent}):Play()
    end)
    
    submitButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text
        if self.Callbacks.OnVerify(key) then
            self:Notify(Config.Icon, 'Success', 'Key validated successfully!', 2)
            task.wait(0.5)
            screenGui:Destroy()
            self.Callbacks.OnSuccess()
        else
            self:Notify(Config.Icon, 'Error', 'Invalid key, please try again.', 3)
            self.Callbacks.OnFailure()
        end
    end)
    
    -- Discord button
    local discordButton = Instance.new('TextButton')
    discordButton.Size = UDim2.new(0, 36, 0, 36)
    discordButton.Position = UDim2.new(0.5, 0, 0, 213)
    discordButton.AnchorPoint = Vector2.new(0.5, 0)
    discordButton.BackgroundColor3 = Config.Colors.Background
    discordButton.BorderSizePixel = 0
    discordButton.Text = ''
    discordButton.AutoButtonColor = false
    discordButton.Parent = mainFrame
    
    local discordCorner = Instance.new('UICorner', discordButton)
    discordCorner.CornerRadius = UDim.new(0, 4)
    
    local discordIcon = Instance.new('ImageLabel')
    discordIcon.Size = UDim2.new(0, 18, 0, 18)
    discordIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    discordIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Image = 'rbxassetid://83278450537116'
    discordIcon.ImageColor3 = Config.Colors.Discord
    discordIcon.ScaleType = Enum.ScaleType.Fit
    discordIcon.Parent = discordButton
    
    discordButton.MouseEnter:Connect(function()
        TweenService:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = Config.Colors.DiscordHover}):Play()
    end)
    
    discordButton.MouseLeave:Connect(function()
        TweenService:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = Config.Colors.Discord}):Play()
    end)
    
    discordButton.MouseButton1Click:Connect(function()
        if self.Links.Discord ~= '' then
            -- Open discord link logic here
        end
    end)
    
    -- Animate in
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    -- Blur effect
    if self.Options.Blur then
        local blur = Instance.new('BlurEffect')
        blur.Name = 'ArqelKeySystemBlur'
        blur.Size = 0
        blur.Parent = Lighting
        
        TweenService:Create(blur, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = 24}):Play()
    end
    
    return screenGui
end

-- Set global
genv.ArqelLoaded = true
genv.Arqel = Arqel

return Arqel
