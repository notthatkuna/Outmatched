local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Lib = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Games/Da%20Hood/AntiCheatBypass.lua"))()
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character
local TpService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

local HoodID = 2788229376

local Blacklisted = {}

local Window = Lib:CreateWindow({
  Title = "Outmatched",
  Center = true,
  AutoShow = true,
})

local Tabs = {
  Welcome = Window:AddTab('Welcome'),
  Character = Window:AddTab('Character'),
  ['UI Settings'] = Window:AddTab('UI Settings'),
}

local WelcomingBox = Tabs.Welcome:AddLeftGroupbox('Welcome, ~'..tostring(Player.DisplayName)..'~!')

WelcomingBox:AddLabel('Thank you for using Outmatched!\nYou are whitelisted.\n\nDeveloper note: This is still heavily in-beta! Expect bugs.',true)
if game.PlaceId ~= HoodID then
  WelcomingBox:AddDivider()
  WelcomingBox:AddLabel('Warning: This game is not DaHood(PID 2788229376), meaning this script will most likely not work.', true)
end

local Fly = Tabs.Character:AddLeftGroupbox('Fly')

Fly:AddToggle('Fly', {
  Text = "Enable flying",
  Default = false,
  Tooltip = "Start flying",
})

spawn(function()
  local s,e = pcall(function()
    Player.CharacterAdded:Connect(function(char)
      Toggles.Fly:SetValue(false)
      Character = char
    end)
  end)
end)

local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local bg
local bv
local maxspeed = 50
local maxmaxspeed = 50
local speed = 0
local FlyConnection
local s,e = pcall(function()
  Toggles.Fly:OnChanged(function()
    local param = Toggles.Fly.Value
    if param == true then
      local torso = Character.HumanoidRootPart
      spawn(function()
        local s,e = pcall(function()
          bg           = Instance.new("BodyGyro")
          bg.Parent    = torso
          bg.P         = 9e4
          bg.maxTorque = Vector3.new(9e9,9e9,9e9)
          bg.CFrame    = torso.CFrame
          bv           = Instance.new("BodyVelocity")
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
        end)
      end)
    else
      if FlyConnection then FlyConnection:Disconnect() end
      ctrl = {f = 0, b = 0, l = 0, r = 0}
      lastctrl = {f = 0, b = 0, l = 0, r = 0}
      speed = 0
      if bg then bg:Destroy() end
      if bv then bv:Destroy() end
      Character.Humanoid.PlatformStand = false
    end
  end)
end)
UserInput.InputBegan:Connect(function(ipObj, gp)
  if gp then return end
  if ipObj.KeyCode == Enum.KeyCode.W then
    ctrl.f = 1
  elseif ipObj.KeyCode == Enum.KeyCode.S then
    ctrl.b = -1
  elseif ipObj.KeyCode == Enum.KeyCode.A then
    ctrl.l = -1
  elseif ipObj.KeyCode == Enum.KeyCode.D then
    ctrl.r = 1
  end
end)
UserInput.InputEnded:Connect(function(ipObj, gp)
  if ipObj.KeyCode == Enum.KeyCode.W then
    ctrl.f = 0
  elseif ipObj.KeyCode == Enum.KeyCode.S then
    ctrl.b = 0
  elseif ipObj.KeyCode == Enum.KeyCode.A then
    ctrl.l = 0
  elseif ipObj.KeyCode == Enum.KeyCode.D then
    ctrl.r = 0
  end
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

Lib.KeybindFrame.Visible = true; -- todo: add a function for this

Lib:OnUnload(function()
    print('Unloaded!')
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
