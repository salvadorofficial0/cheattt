-- =============================================
-- SALVADOR CHEAT MENU - EN BASİT HALİ
-- Discord: 4wmy
-- =============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ==================== KEY SYSTEM ====================
local KeyGist = "https://gist.githubusercontent.com/salvadorofficial0/65ce32e8042803ef99cc386e1c376f9d/raw/keys.txt"

local ValidKeys = {}
local success, data = pcall(function()
    return game:HttpGet(KeyGist)
end)

if success then
    for line in data:gmatch("[^\r\n]+") do
        local k = line:gsub("%s+", "")
        if k ~= "" then table.insert(ValidKeys, k) end
    end
else
    Rayfield:Notify({Title = "Hata", Content = "Key listesi yüklenemedi.", Duration = 10})
    return
end

-- Key Giriş Ekranı
local KeyWindow = Rayfield:CreateWindow({
    Name = "Salvador Key System",
    LoadingTitle = "Key Doğrulama",
    LoadingSubtitle = "Discord: 4wmy"
})

local KeyTab = KeyWindow:CreateTab("Key Giriş")

KeyTab:CreateParagraph({
    Title = "Salvador Cheat Menu",
    Content = "Key Almak İçin: https://salvador-key.vercel.app\n\nKeyinizi aşağıya girin."
})

local enteredKey = ""
KeyTab:CreateInput({
    Name = "Key Giriniz",
    PlaceholderText = "Keyinizi buraya yazın...",
    Callback = function(txt) enteredKey = txt end
})

KeyTab:CreateButton({
    Name = "Keyi Doğrula",
    Callback = function()
        for _, key in ipairs(ValidKeys) do
            if enteredKey == key then
                Rayfield:Notify({Title = "Başarılı", Content = "Menü açılıyor...", Duration = 4})
                task.wait(1)
                LoadMenu()   -- Ana menü
                return
            end
        end
        Rayfield:Notify({Title = "Hatalı Key", Content = "Key geçersiz.", Duration = 6})
    end
})

-- ==================== ANA MENÜ (ESKİ GİBİ) ====================
function LoadMenu()
    local Window = Rayfield:CreateWindow({
        Name = "Salvador Cheat Menu",
        LoadingTitle = "Developed by Salvador",
        LoadingSubtitle = "Discord: 4wmy",
        ConfigurationSaving = { Enabled = false }
    })

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")
    local VirtualUser = game:GetService("VirtualUser")

    local player = Players.LocalPlayer
    local camera = workspace.CurrentCamera

    local character, humanoid, rootPart
    local currentTarget = nil
    local lastVelocity = Vector3.new()

    local Settings = {
        Fly = false, FlySpeed = 150,
        Noclip = false,
        InfiniteJump = false,
        BunnyHop = false,
        WalkSpeed = 70,
        JumpPower = 170,
        Aimbot = false,
        AimSmooth = 0.14,
        AimFOV = 380,
        AimPrediction = 0.14,
        KillAura = false,
        KillAuraRange = 38,
        ESP = false,
        RainbowChar = false,
        Fullbright = false,
        NoFog = false,
        GodMode = false,
        AutoHeal = false,
        Spinbot = false,
        SpinSpeed = 65,
        AntiAFK = false,
        HitboxExpander = false,
        HitboxSize = 12
    }

    local function UpdateCharacter()
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
        if Settings.GodMode and humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end

    player.CharacterAdded:Connect(UpdateCharacter)
    UpdateCharacter()

    local function GetBestHeadTarget()
        if currentTarget and currentTarget.Parent and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
            if (currentTarget.Position - rootPart.Position).Magnitude < Settings.AimFOV * 1.5 then return currentTarget end
        end

        local best, bestScore = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local head = p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChild("Humanoid")
                if head and hum and hum.Health > 0 then
                    local vec = (head.Position - camera.CFrame.Position)
                    local dist = vec.Magnitude
                    local dot = vec.Unit:Dot(camera.CFrame.LookVector)
                    if dot > 0.73 and dist < bestScore and dist < Settings.AimFOV then
                        bestScore = dist
                        best = head
                    end
                end
            end
        end
        currentTarget = best
        return best
    end

    local function PredictHead(head)
        if not head then return Vector3.new() end
        local vel = head.Velocity or Vector3.new()
        lastVelocity = lastVelocity:Lerp(vel, 0.85)
        return head.Position + lastVelocity * Settings.AimPrediction + Vector3.new(0, 0.3, 0)
    end

    local function ApplyHitbox()
        if not Settings.HitboxExpander then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    root.Transparency = 0.7
                    root.CanCollide = false
                end
            end
        end
    end

    RunService.RenderStepped:Connect(function()
        if not character or not humanoid or not rootPart then return end

        if Settings.GodMode then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end

        if Settings.AutoHeal and humanoid.Health < humanoid.MaxHealth * 0.6 then
            humanoid.Health = humanoid.MaxHealth
        end

        if Settings.Noclip then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        if Settings.InfiniteJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        if Settings.BunnyHop and humanoid:GetState() == Enum.HumanoidStateType.Landed then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        if humanoid then
            humanoid.WalkSpeed = Settings.WalkSpeed
            humanoid.JumpPower = Settings.JumpPower
        end

        if Settings.Aimbot then
            local targetHead = GetBestHeadTarget()
            if targetHead then
                local predicted = PredictHead(targetHead)
                camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, predicted), Settings.AimSmooth)
            end
        end

        if Settings.KillAura then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (p.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if dist <= Settings.KillAuraRange then
                        local hum = p.Character:FindFirstChild("Humanoid")
                        if hum then hum:TakeDamage(999) end
                    end
                end
            end
        end

        if Settings.Spinbot and rootPart then
            rootPart.CFrame *= CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
        end

        if Settings.RainbowChar and character then
            local hue = (tick() % 7) / 7
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = Color3.fromHSV(hue, 1, 1)
                end
            end
        end

        if Settings.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end

        ApplyHitbox()
    end)

    local flyBody = nil
    local function ToggleFly(state)
        Settings.Fly = state
        if not state and flyBody then
            flyBody.bv:Destroy()
            flyBody.bg:Destroy()
            flyBody = nil
            return
        end
        if state and rootPart then
            local bv = Instance.new("BodyVelocity")
            local bg = Instance.new("BodyGyro")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P = 165000
            bv.Parent = rootPart
            bg.Parent = rootPart
            flyBody = {bv = bv, bg = bg}

            spawn(function()
                while Settings.Fly and rootPart do
                    local dir = Vector3.new()
                    local cf = camera.CFrame
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

                    bv.Velocity = dir.Unit * Settings.FlySpeed
                    bg.CFrame = cf
                    task.wait()
                end
            end)
        end
    end

    RunService.Heartbeat:Connect(function()
        if Settings.Fullbright then
            Lighting.Brightness = 4
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        end
        if Settings.NoFog then Lighting.FogEnd = 10000000 end
    end)

    local espFolder = Instance.new("Folder", game.CoreGui)
    espFolder.Name = "SalvadorESP"

    local function CreateESP(plr)
        if plr == player then return end
        local bb = Instance.new("BillboardGui", espFolder)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 240, 0, 80)
        bb.StudsOffset = Vector3.new(0, 5, 0)

        local nameLabel = Instance.new("TextLabel", bb)
        nameLabel.Size = UDim2.new(1,0,0.4,0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold

        local infoLabel = Instance.new("TextLabel", bb)
        infoLabel.Size = UDim2.new(1,0,0.6,0)
        infoLabel.Position = UDim2.new(0,0,0.4,0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
        infoLabel.TextScaled = true

        RunService.RenderStepped:Connect(function()
            if not Settings.ESP or not plr.Character or not plr.Character:FindFirstChild("Head") then
                bb.Adornee = nil
                return
            end
            local head = plr.Character.Head
            bb.Adornee = head
            nameLabel.Text = plr.Name
            local hum = plr.Character:FindFirstChild("Humanoid")
            infoLabel.Text = hum and string.format("HP: %.0f | %.0f m", hum.Health, (head.Position - rootPart.Position).Magnitude) or "Dead"
        end)
    end

    for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
    Players.PlayerAdded:Connect(CreateESP)

    -- MENÜ (ESKİ GİBİ)
    local movTab = Window:CreateTab("Movement")
    local comTab = Window:CreateTab("Combat")
    local visTab = Window:CreateTab("Visual")
    local miscTab = Window:CreateTab("Misc")
    local infoTab = Window:CreateTab("Info")

    movTab:CreateSlider({Name = "WalkSpeed", Range = {16, 800}, Increment = 1, CurrentValue = 70, Callback = function(v) Settings.WalkSpeed = v end})
    movTab:CreateSlider({Name = "JumpPower", Range = {50, 800}, Increment = 1, CurrentValue = 170, Callback = function(v) Settings.JumpPower = v end})
    movTab:CreateSlider({Name = "Fly Speed", Range = {80, 600}, Increment = 1, CurrentValue = 150, Callback = function(v) Settings.FlySpeed = v end})
    movTab:CreateToggle({Name = "Fly", CurrentValue = false, Callback = ToggleFly})
    movTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) Settings.Noclip = v end})
    movTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) Settings.InfiniteJump = v end})
    movTab:CreateToggle({Name = "Bunny Hop", CurrentValue = false, Callback = function(v) Settings.BunnyHop = v end})

    comTab:CreateToggle({Name = "Aimbot (Headshot Mode)", CurrentValue = false, Callback = function(v) Settings.Aimbot = v end})
    comTab:CreateSlider({Name = "Smoothness", Range = {0.05, 0.95}, Increment = 0.01, CurrentValue = 0.14, Callback = function(v) Settings.AimSmooth = v end})
    comTab:CreateSlider({Name = "FOV", Range = {100, 800}, Increment = 10, CurrentValue = 380, Callback = function(v) Settings.AimFOV = v end})
    comTab:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) Settings.KillAura = v end})
    comTab:CreateSlider({Name = "Kill Aura Range", Range = {10, 90}, Increment = 1, CurrentValue = 38, Callback = function(v) Settings.KillAuraRange = v end})

    visTab:CreateToggle({Name = "ESP", CurrentValue = false, Callback = function(v) Settings.ESP = v end})
    visTab:CreateToggle({Name = "Rainbow Character", CurrentValue = false, Callback = function(v) Settings.RainbowChar = v end})
    visTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) Settings.Fullbright = v end})
    visTab:CreateToggle({Name = "No Fog", CurrentValue = false, Callback = function(v) Settings.NoFog = v end})

    miscTab:CreateToggle({Name = "God Mode", CurrentValue = false, Callback = function(v) Settings.GodMode = v end})
    miscTab:CreateToggle({Name = "Auto Heal", CurrentValue = false, Callback = function(v) Settings.AutoHeal = v end})
    miscTab:CreateToggle({Name = "Spinbot", CurrentValue = false, Callback = function(v) Settings.Spinbot = v end})
    miscTab:CreateSlider({Name = "Spin Speed", Range = {20, 250}, Increment = 1, CurrentValue = 65, Callback = function(v) Settings.SpinSpeed = v end})
    miscTab:CreateToggle({Name = "Hitbox Expander", CurrentValue = false, Callback = function(v) Settings.HitboxExpander = v end})
    miscTab:CreateSlider({Name = "Hitbox Size", Range = {5, 25}, Increment = 0.5, CurrentValue = 12, Callback = function(v) Settings.HitboxSize = v end})
    miscTab:CreateToggle({Name = "Anti-AFK", CurrentValue = false, Callback = function(v) Settings.AntiAFK = v end})

    infoTab:CreateParagraph({Title = "Salvador", Content = "Discord: 4wmy\nMenü başarıyla yüklendi."})
    infoTab:CreateButton({Name = "Copy Discord", Callback = function() setclipboard("4wmy") end})

    Rayfield:Notify({
        Title = "Salvador Cheat Menu",
        Content = "Hoş geldin!",
        Duration = 8
    })
end
