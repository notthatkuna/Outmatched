local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Lib = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local Notifications = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Games/Da%20Hood/AntiCheatBypass.lua"))()
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character
local TpService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

local cons = {}

local Enabled_Keypressed = {
  FalseMacro = {
    Key = Enum.KeyCode.L,
    Enabled = false,
    Exec = function()
      local s,e = pcall(function()
        local animid = "rbxassetid://3189777795"
        local animator = Character.Humanoid.Animator

        local anim = Instance.new("Animation")
        anim.AnimationId = animid
        print(1)

        local track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action
        track.Looped = false
        track:Play()
        print(2)
        task.wait(1.2)
        local wallet = Player.Backpack:FindFirstChild("Wallet")
        if not wallet then
          local Notification = Notifications.new("error", "Error running false macro", "Must be holding nothing in your hand for this function to work.")
          Notification:deleteTimeout(6)
        end
        wallet.Parent = Character
        task.wait(.3)
        wallet.Parent = Player.Backpack
      end)
      print(s,e)
    end,
  },
}
table.insert(cons, UserInput.InputBegan:Connect(function(ip, gp)
  if gp then return end
  for i,v in pairs(Enabled_Keypressed) do
    print(i, v.Key, ip.KeyCode)
    print(i, v.Enabled)
    if v.Key == ip.KeyCode and v.Enabled == true then print('running',i) v.Exec() end
  end
end))
local HoodID = 2788229376
local TargetedPlayerID = Player.UserId

local Blacklisted = {}
local Window = Lib:CreateWindow({
  Title = "Outmatched",
  Center = true,
  AutoShow = true,
})

local Tabs = {
  Welcome = Window:AddTab('Welcome'),
  Character = Window:AddTab('Character'),
  Target = Window:AddTab('Target'),
  ['UI Settings'] = Window:AddTab('UI Settings'),
}

local WelcomingBox = Tabs.Welcome:AddLeftGroupbox('Welcome, ~'..tostring(Player.DisplayName)..'~!')

WelcomingBox:AddLabel('Thank you for using Outmatched!\nYou are whitelisted.\n\nDeveloper note: This is still heavily in-beta! Expect bugs.',true)
if game.PlaceId ~= HoodID then
  WelcomingBox:AddDivider()
  WelcomingBox:AddLabel('Warning: This game is not DaHood(PID 2788229376), meaning this script will most likely not work.', true)
end

local Emergency_Disable = { -- disable for things like force resetting to prevent anticheat kicking
  Toggles = {
    "Fly"
  }
}

local Fly = Tabs.Character:AddLeftGroupbox('Fly')
local CharacterMisc = Tabs.Character:AddRightGroupbox('CharacterMisc')

CharacterMisc:AddButton('Force Reset', function()
  for topicname, topiccontent in pairs(Emergency_Disable) do
    for _, content in pairs(topiccontent) do
      getgenv()[topicname][content]:SetValue(false)
    end
  end
  Character.Head:Destroy()
end)

CharacterMisc:AddButton('Initialize Macro[L]', function()
  Enabled_Keypressed.FalseMacro.Enabled = true
end)

Fly:AddToggle('Fly', {
  Text = "Enable flying",
  Default = false,
  Tooltip = "Start flying",
})

table.insert(cons, Player.CharacterAdded:Connect(function(char)
  Toggles.Fly:SetValue(false)
  Character = char
end))
table.insert(cons, RunService.RenderStepped:Connect(function()
  if Player.Character then Character = Player.Character end
end))

local flytype = "Physics-Based"
local cftbl = {f = false, b = false, l = false, r = false}
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local bg
local bv
local maxspeed = 50
local maxmaxspeed = 50
local speed = 0
local FlyConnection
Toggles.Fly:OnChanged(function()
  local param = Toggles.Fly.Value
  if param == true then
    if flytype == "Physics-Based" then
      local torso = Character.HumanoidRootPart
      bg           = Instance.new("BodyGyro")
      bg.Name = "kZZuHAShaJUznU12313.xxx"
      bg.Parent    = torso
      bg.P         = 9e4
      bg.maxTorque = Vector3.new(9e9,9e9,9e9)
      bg.CFrame    = torso.CFrame
      bv           = Instance.new("BodyVelocity")
      bv.Name = "kZZuHAShaJUznU123132.xxx"
      bv.Parent    = torso
      bv.Velocity  = Vector3.new(0,0.1,0)
      bv.maxForce  = Vector3.new(9e9,9e9,9e9)
      FlyConnection = RunService.RenderStepped:Connect(function(dt)
        Character.Humanoid.PlatformStand = true
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
          speed = speed+.5+(speed/maxspeed)
          if speed > maxspeed then
              speed = maxspeed
          end
        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
          speed = speed-1
          if speed < 0 then
            speed = 0
          end
        end
        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
          bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
          lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
          bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
        else
          bv.velocity = Vector3.new(0,0.1,0)
        end
        bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
      end)
    elseif flytype == "CFrame-Based" then
      --Character.Head.Anchored = true
      Character.HumanoidRootPart.Anchored = true
      local CalculatedNext = Character.HumanoidRootPart.CFrame
      FlyConnection = RunService.RenderStepped:Connect(function(dt)
        Character.Humanoid.PlatformStand = true
        if cftbl.l then
          CalculatedNext *= CFrame.new(-maxspeed/100,0,0)
        end
        if cftbl.r then
          CalculatedNext *= CFrame.new(maxspeed/100,0,0)
        end
        if cftbl.f then
          CalculatedNext *= CFrame.new(0,0,-maxspeed/100)
        end
        if cftbl.b then
          CalculatedNext *= CFrame.new(0,0,maxspeed/100)
        end
        CalculatedNext = CFrame.new(CalculatedNext.Position, CalculatedNext.Position + workspace.CurrentCamera.CFrame.LookVector)
        Character.HumanoidRootPart.CFrame = CalculatedNext
      end)
    end
  else
    if FlyConnection then FlyConnection:Disconnect() end
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    speed = 0
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    Character.Humanoid.PlatformStand = false
    Character.Head.Anchored = false
    Character.HumanoidRootPart.Anchored = false
  end
end)
table.insert(cons, UserInput.InputBegan:Connect(function(ipObj, gp)
  if gp then return end
  if ipObj.KeyCode == Enum.KeyCode.W then
    ctrl.f = 1
    cftbl.f = true
  elseif ipObj.KeyCode == Enum.KeyCode.S then
    ctrl.b = -1
    cftbl.b = true
  elseif ipObj.KeyCode == Enum.KeyCode.A then
    ctrl.l = -1
    cftbl.l = true
  elseif ipObj.KeyCode == Enum.KeyCode.D then
    ctrl.r = 1
    cftbl.r = true
  end
end))
table.insert(cons, UserInput.InputEnded:Connect(function(ipObj, gp)
  if ipObj.KeyCode == Enum.KeyCode.W then
    ctrl.f = 0
    cftbl.f = false
  elseif ipObj.KeyCode == Enum.KeyCode.S then
    ctrl.b = 0
    cftbl.b = false
  elseif ipObj.KeyCode == Enum.KeyCode.A then
    ctrl.l = 0
    cftbl.l = false
  elseif ipObj.KeyCode == Enum.KeyCode.D then
    ctrl.r = 0
    cftbl.r = false
  end
end))

Fly:AddDropdown('Fly Type', {
  Values = { 'Physics-Based', 'CFrame-Based' },
  Default = 1,
  Multi = false,
  Text = 'Fly Type',
  Tooltip = 'Choose which type of flying you want to use'
})

Options['Fly Type']:OnChanged(function()
  flytype = Options['Fly Type'].Value
  task.spawn(function()
    if Toggles.Fly.Value == true then
      Toggles.Fly:SetValue(false)
      task.wait(0.01)
      Toggles.Fly:SetValue(true)
    end
  end)
end)

Fly:AddSlider('Fly Speed', {
  Text = 'Fly Speed',
  Default = 50,
  Min = 5,
  Max = 400,
  Rounding = 1,

  Compact = false
})

Options['Fly Speed']:OnChanged(function()
  maxspeed = Options['Fly Speed'].Value
end)

function find_player(subname)
  local s,e = pcall(function()
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
      if v.Name:sub(1,subname:len()) == subname or v.DisplayName:sub(1,subname:len()) == subname then return v end
    end
  end)
  return s
end

function MatchID(id)
  for i,v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.UserId == id then return v end
  end
  return nil
end

local TargetGroup = Tabs.Target:AddLeftGroupbox('Target')
local matched = MatchID(TargetedPlayerID)

local TargetLabel = TargetGroup:AddLabel('Target: '..tostring(matched.Name or "[Targeted ID not found]"), false)
local InfoLabel = TargetGroup:AddLabel('Username: '..tostring(matched.Name or "[Targeted ID not found]")..'\n'..
'DisplayName: '..tostring(matched.DisplayName or "[Targeted ID not found]")..'\n'..
'UserID: '..tostring(matched.UserId), true)

function update_target()
  local matched = MatchID(TargetedPlayerID)

  local name
  local dispname
  local id
  if matched ~= nil then
    name = matched.Name
    dispname = matched.DisplayName
    id = matched.UserId
  else
    name = ""
    dispname = ""
    id = ""
  end

  TargetLabel.Text = 'Target: '..tostring(name or "[Targeted ID not found]")
  InfoLabel.Text = 'Username: '..tostring(name or "[Targeted ID not found]")..'\n'..
  'DisplayName: '..tostring(dispname or "[Targeted ID not found]")..'\n'..
  'UserID: '..tostring(id)
end

TargetGroup:AddDivider()

local adjectives = {
  "Sparkly",
  "Shining",
  "Glittering",
  "Hazerdous"
}

local nouns = {
  "Banana",
  "Computer",
  "Bottle",
  "Cake"
}

TargetGroup:AddInput('Username', {
  Default = Player.Name,
  Numeric = false,
  Finished = false,

  Text = 'User',
  Tooltip = 'The user to target',

  Placeholder = adjectives[math.random(1,#adjectives)]..nouns[math.random(1,#nouns)]..tostring(math.random(1111,9999))
})
local s,e = pcall(function()
  Options.Username:OnChanged(function()
    print(Options.Username.Value)
    TargetedPlayerID = find_player(Options.Username.Value)
    update_target()
  end)
end)
print(s,e)
Lib.KeybindFrame.Visible = true; -- todo: add a function for this

Lib:OnUnload(function()
    print('Unloaded!')
    for i,v in pairs(cons) do
      print('disconnecting connection '..tostring(i))
      v:Disconnect()
    end
    Lib.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Lib:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'V', NoUI = true, Text = 'Menu keybind' })

Lib.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Lib)
SaveManager:SetLibrary(Lib)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('Outmatched')
SaveManager:SetFolder('Outmatched/saves')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])
