-- ============================================================
-- UNIVERSAL ADMIN COMMAND [ULTIMATE VERSION 2.3 + UNIFIED ANIM SPEED & ATTACK]
-- ============================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local player = Players.LocalPlayer

-- ค่าตัวแปรควบคุมระบบเสริม
_G.AnimSpeedPercent = 100 -- ค่าความเร็วอนิเมชั่นเริ่มต้น (เปอร์เซ็นต์)
_G.FastAttackActive = false -- สถานะระบบโจมตีรวดเร็วตามความเร็วอนิเมชั่น

-- ป้องกัน UI ซ้อนทับ
if CoreGui:FindFirstChild("AdminCommandUltimate") then
    CoreGui.AdminCommandUltimate:Destroy()
end

-- สร้างหน้าต่าง UI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminCommandUltimate"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ปุ่มเปิด-ปิดลอยตัว (Floating Toggle Button)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
toggleBtn.Text = ">_"
toggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.Code
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(0, 255, 150)
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggleBtn

-- กรอบหลัก (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleBtn.BackgroundColor3 = mainFrame.Visible and Color3.fromRGB(15, 15, 22) or Color3.fromRGB(0, 255, 150)
    toggleBtn.TextColor3 = mainFrame.Visible and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(12, 12, 18)
end)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.Text = "  >_ ULTIMATE ADMIN [V2.3 + UNIFIED ANIM/ATTACK]"
titleBar.TextColor3 = Color3.fromRGB(0, 255, 150)
titleBar.TextSize, titleBar.Font = 11, Enum.Font.Code
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Output Console Log
local outputBox = Instance.new("TextLabel")
outputBox.Size = UDim2.new(0, 480, 0, 190)
outputBox.Position = UDim2.new(0, 20, 0, 45)
outputBox.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
outputBox.Text = "SYSTEM: โหลด ULTIMATE V2.3 สำเร็จ!\n- พิมพ์ 'help' เพื่อดูคำสั่งทั้งหมด\n- พิมพ์ 'fastattack' หรือ 'fast' เพื่อเปิดระบบโจมตีรวดเร็ว\n- พิมพ์ 'animspeed [val]' เพื่อเร่งสปีดอนิเมชั่นและการออกท่า\n--------------------------------------------------"
outputBox.TextColor3 = Color3.fromRGB(0, 255, 120)
outputBox.TextSize, outputBox.Font = 11, Enum.Font.Code
outputBox.TextXAlignment = Enum.TextXAlignment.Left
outputBox.TextYAlignment = Enum.TextYAlignment.Top
outputBox.TextWrapped = true
outputBox.Parent = mainFrame

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 6)
outputCorner.Parent = outputBox

-- Player Queue Dropdown
local queueDropdown = Instance.new("ScrollingFrame")
queueDropdown.Size = UDim2.new(0, 480, 0, 0)
queueDropdown.Position = UDim2.new(0, 20, 0, 240)
queueDropdown.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
queueDropdown.BorderSizePixel = 0
queueDropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
queueDropdown.ScrollBarThickness, queueDropdown.Visible = 4, false
queueDropdown.Parent = mainFrame

local queueCorner = Instance.new("UICorner")
queueCorner.CornerRadius = UDim.new(0, 6)
queueCorner.Parent = queueDropdown

-- Command Input Box
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0, 480, 0, 35)
inputBox.Position = UDim2.new(0, 20, 0, 305)
inputBox.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
inputBox.Text = ""
inputBox.PlaceholderText = "พิมพ์คำสั่ง เช่น help, fastattack, animspeed 200..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize, inputBox.Font = 12, Enum.Font.Code
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.ClearTextOnFocus = false
inputBox.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

-- ============================================================
-- AUTO-RUN BACKGROUND PROTECTIONS & UNIFIED SPEED SYSTEM
-- ============================================================

-- 1. Anti-Collision (ป้องกันผู้เล่นอื่นชนหรือผลักตกแมพ)
RunService.Stepped:Connect(function()
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- 2. Fast Regeneration, Resource Boost, AnimSpeed & Fast Attack Integration
RunService.Heartbeat:Connect(function()
    pcall(function()
        local character = player.Character
        if character then
            -- ฟื้นฟูเลือดอัตโนมัติ
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            
            -- ปรับความเร็วอนิเมชั่นทั้งหมดตามเปอร์เซ็นต์ที่ตั้งไว้
            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    track:AdjustSpeed(_G.AnimSpeedPercent / 100)
                end
            end
            
            -- ระบบโจมตีรวดเร็วอัตโนมัติ (ผูกกับสถานะ FastAttack)
            if _G.FastAttackActive then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
            
            -- ฟื้นฟูมานา/พลังงาน และลดคูลดาวน์
            local function boostValues(container)
                if not container then return end
                for _, v in ipairs(container:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local nameLower = v.Name:lower()
                        if nameLower:find("mana") or nameLower:find("energy") or nameLower:find("stamina") or nameLower:find("chi") or nameLower:find("blood") then
                            if v.Value < 999 then v.Value = 999999 end
                        elseif nameLower:find("cooldown") or nameLower:find("cd") or nameLower:find("reload") or nameLower:find("delay") then
                            v.Value = 0.01
                        end
                    end
                end
            end
            boostValues(character)
            if player:FindFirstChild("Backpack") then
                boostValues(player.Backpack)
            end
        end
    end)
end)

-- ============================================================
-- COMMAND PARSER & EXECUTION LOGIC
-- ============================================================
local function log(message)
    outputBox.Text = outputBox.Text .. "\n> " .. message
end

local function updatePlayerQueue(cmdType)
    queueDropdown:ClearAllChildren()
    local playersList = Players:GetPlayers()
    local yPos = 0
    
    for _, p in ipairs(playersList) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.Position = UDim2.new(0, 0, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            btn.Text = "  ⚡ " .. p.Name .. " (" .. p.DisplayName .. ")"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize, btn.Font = 11, Enum.Font.Code
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = queueDropdown
            
            btn.MouseButton1Click:Connect(function()
                inputBox.Text = cmdType .. " " .. p.Name
                queueDropdown.Visible = false
                mainFrame.Size = UDim2.new(0, 520, 0, 360)
                inputBox.Position = UDim2.new(0, 20, 0, 305)
            end)
            yPos = yPos + 30
        end
    end
    
    if yPos > 0 then
        queueDropdown.CanvasSize = UDim2.new(0, 0, 0, yPos)
        queueDropdown.Size = UDim2.new(0, 480, 0, math.min(yPos, 60))
        queueDropdown.Visible = true
        mainFrame.Size = UDim2.new(0, 520, 0, 420)
        inputBox.Position = UDim2.new(0, 20, 0, 365)
    else
        queueDropdown.Visible = false
    end
end

inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = inputBox.Text:lower()
    if text:sub(1, 3) == "to " or text:sub(1, 6) == "bring " or text:sub(1, 5) == "lock " then
        local cmd = text:sub(1, 3) == "to " and "to" or (text:sub(1, 6) == "bring " and "bring" or "lock")
        updatePlayerQueue(cmd)
    else
        queueDropdown.Visible = false
        mainFrame.Size = UDim2.new(0, 520, 0, 360)
        inputBox.Position = UDim2.new(0, 20, 0, 305)
    end
end)

local function executeCommand(text)
    local args = {}
    for word in text:gmatch("%S+") do
        table.insert(args, word)
    end
    
    local cmd = args[1] and args[1]:lower() or ""
    local targetName = args[2] or ""
    local val = tonumber(args[2]) or 0
    
    if cmd == "help" then
        log("--- รายชื่อคำสั่งทั้งหมด (Ultimate V2.3) ---")
        log(" fastattack      - เปิด/ปิดระบบโจมตีรวดเร็วต่อเนื่อง")
        log(" animspeed [val] - ปรับความเร็วอนิเมชั่นเป็น % (เช่น animspeed 200)")
        log(" speed [num]     - ปรับความเร็วเดินตัวละคร")
        log(" tracers         - เปิด/ปิดเส้นโยงเรืองรองหาผู้เล่น")
        log(" esp             - เปิด/ปิดกล่องมองทะลุผู้เล่น")
        log(" hack            - แฮกสภาพแวดล้อมแมพ (Fullbright & Clear)")
        log(" lock [ชื่อ]     - ล็อกเกาะติดเป้าหมาย 100%")
        log(" unlock          - ยกเลิกการล็อกเป้าหมาย")
        log(" to [ชื่อ]        - วาร์ปไปหาผู้เล่นเป้าหมาย")
        log(" bring [ชื่อ]     - ดึงผู้เล่นเป้าหมายมาหาคุณ")
        log(" jump            - เปิด/ปิดกระโดดกลางอากาศ")
        log(" noclip          - เดินทะลุกำแพง")
        log(" fps             - ปลดล็อก FPS สูงสุด")
        log(" clear           - ล้างหน้าจอเทอร์มินัล")
        log(" exit            - ปิดเทอร์มินัลและล้างระบบทั้งหมด")
        
    elseif cmd == "fastattack" or cmd == "fast" then
        _G.FastAttackActive = not _G.FastAttackActive
        if _G.FastAttackActive then
            log("SUCCESS: เปิดระบบโจมตีรวดเร็วต่อเนื่องแล้ว")
        else
            log("SUCCESS: ปิดระบบโจมตีรวดเร็วแล้ว")
        end
        
    elseif cmd == "animspeed" or cmd == "aspeed" then
        if val > 0 then
            _G.AnimSpeedPercent = val
            log("SUCCESS: ตั้งค่าความเร็วอนิเมชั่นเป็น " .. val .. "% (" .. (val/100) .. "x)")
        else
            log("ERROR: กรุณาระบุค่าเปอร์เซ็นต์ที่ถูกต้อง เช่น animspeed 150")
        end
        
    elseif cmd == "tracers" or cmd == "trace" then
        _G.TracersActive = not _G.TracersActive
        if _G.TracersActive then
            log("SUCCESS: เปิดระบบ Tracers ESP")
            _G.TracerLines = _G.TracerLines or {}
            if _G.TracersConn then _G.TracersConn:Disconnect() end
            _G.TracersConn = RunService.RenderStepped:Connect(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        local line = _G.TracerLines[p]
                        if not line and Drawing then
                            line = Drawing.new("Line")
                            line.Thickness = 1.5
                            line.Color = Color3.fromRGB(255, 50, 50)
                            line.Transparency = 0.8
                            _G.TracerLines[p] = line
                        end
                        if line then
                            if onScreen then
                                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                line.To = Vector2.new(vector.X, vector.Y)
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        end
                    else
                        if _G.TracerLines[p] then _G.TracerLines[p].Visible = false end
                    end
                end
            end)
        else
            log("SUCCESS: ปิดระบบ Tracers ESP แล้ว")
            if _G.TracersConn then _G.TracersConn:Disconnect() end
            if _G.TracerLines then
                for _, line in pairs(_G.TracerLines) do
                    if line and typeof(line) == "table" and line.Remove then line:Remove() end
                end
                _G.TracerLines = {}
            end
        end
        
    elseif cmd == "esp" then
        _G.EspActive = not _G.EspActive
        if _G.EspActive then
            log("SUCCESS: เปิดระบบ ESP Box")
            _G.EspConn = RunService.RenderStepped:Connect(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        if not hrp:FindFirstChild("UniversalESP") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "UniversalESP"
                            hl.Adornee = p.Character
                            hl.FillColor = Color3.fromRGB(255, 50, 50)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.Parent = hrp
                        end
                    end
                end
            end)
        else
            log("SUCCESS: ปิดระบบ ESP Box")
            if _G.EspConn then _G.EspConn:Disconnect() end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local esp = p.Character.HumanoidRootPart:FindFirstChild("UniversalESP")
                    if esp then esp:Destroy() end
                end
            end
        end
        
    elseif cmd == "hack" then
        pcall(function()
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 999999
            Lighting.GlobalShadows = false
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then v.Enabled = false end
            end
            log("SUCCESS: แฮกสภาพแวดล้อมแมพสำเร็จ (Fullbright & Clear)")
        end)
        
    elseif cmd == "lock" then
        pcall(function()
            local target = Players:FindFirstChild(targetName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                _G.LockTarget = target
                _G.LockActive = true
                log("SUCCESS: ล็อกเกาะติดเป้าหมาย " .. target.Name)
                if _G.LockConn then _G.LockConn:Disconnect() end
                _G.LockConn = RunService.RenderStepped:Connect(function()
                    pcall(function()
                        if _G.LockActive and _G.LockTarget and _G.LockTarget.Character and _G.LockTarget.Character:FindFirstChild("HumanoidRootPart") then
                            local targetHrp = _G.LockTarget.Character.HumanoidRootPart
                            local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if myHrp then myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3) end
                        end
                    end)
                end)
            else
                log("ERROR: ไม่พบเป้าหมาย '" .. targetName .. "'")
            end
        end)
        
    elseif cmd == "unlock" then
        _G.LockActive = false
        if _G.LockConn then _G.LockConn:Disconnect() end
        log("SUCCESS: ยกเลิกการล็อกเป้าหมายแล้ว")
        
    elseif cmd == "fps" then
        pcall(function()
            if setfpscap then setfpscap(120) end
            settings():GetService("RenderSettings").QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            log("SUCCESS: ปลดล็อก FPS สูงสุดสำเร็จ")
        end)
        
    elseif cmd == "to" then
        pcall(function()
            local target = Players:FindFirstChild(targetName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                log("SUCCESS: วาร์ปไปหา " .. target.Name)
            else
                log("ERROR: ไม่พบเป้าหมาย '" .. targetName .. "'")
            end
        end)
        
    elseif cmd == "bring" then
        pcall(function()
            local target = Players:FindFirstChild(targetName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                log("SUCCESS: ดึง " .. target.Name .. " เข้ามาหาคุณ")
            else
                log("ERROR: ไม่พบเป้าหมาย '" .. targetName .. "'")
            end
        end)
        
    elseif cmd == "speed" then
        pcall(function()
            player.Character.Humanoid.WalkSpeed = val ~= 0 and val or 30
            log("SUCCESS: ตั้งค่า WalkSpeed เป็น " .. (val ~= 0 and val or 30))
        end)
        
    elseif cmd == "jump" then
        _G.InfJumpActive = not _G.InfJumpActive
        if _G.InfJumpActive then
            log("SUCCESS: เปิดระบบกระโดดกลางอากาศ")
            _G.JumpConn = UserInputService.JumpRequest:Connect(function()
                pcall(function() player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end)
        else
            log("SUCCESS: ปิดระบบกระโดดกลางอากาศ")
            if _G.JumpConn then _G.JumpConn:Disconnect() end
        end
        
    elseif cmd == "noclip" then
        _G.NoclipActive = not _G.NoclipActive
        if _G.NoclipActive then
            log("SUCCESS: เปิดโหมด Noclip")
            _G.NoclipConn = RunService.Stepped:Connect(function()
                pcall(function()
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end)
            end)
        else
            log("SUCCESS: ปิดโหมด Noclip")
            if _G.NoclipConn then _G.NoclipConn:Disconnect() end
        end
        
    elseif cmd == "clear" then
        outputBox.Text = "SYSTEM CONSOLE CLEARED."
        
    elseif cmd == "exit" then
        _G.LockActive = false
        _G.FastAttackActive = false
        if _G.LockConn then _G.LockConn:Disconnect() end
        if _G.TracersConn then _G.TracersConn:Disconnect() end
        if _G.TracerLines then
            for _, line in pairs(_G.TracerLines) do
                if line and typeof(line) == "table" and line.Remove then line:Remove() end
            end
        end
        if _G.JumpConn then _G.JumpConn:Disconnect() end
        if _G.NoclipConn then _G.NoclipConn:Disconnect() end
        if _G.EspConn then _G.EspConn:Disconnect() end
        screenGui:Destroy()
        
    else
        log("ERROR: ไม่พบคำสั่ง '" .. cmd .. "' (พิมพ์ 'help' เพื่อดูคำสั่ง)")
    end
end

inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and inputBox.Text ~= "" then
        local commandText = inputBox.Text
        inputBox.Text = ""
        queueDropdown.Visible = false
        mainFrame.Size = UDim2.new(0, 520, 0, 360)
        inputBox.Position = UDim2.new(0, 20, 0, 305)
        executeCommand(commandText)
    end
end)

