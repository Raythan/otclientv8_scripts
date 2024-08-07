setDefaultTab("Tools")

local autopartyui = setupUI([[
Panel
  height: 38

  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    height: 18
    text: Auto Party

  Button
    id: editPlayerList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 18
    text: Setup

  Button
    id: ptLeave
    text: Leave Party
    anchors.left: parent.left
    anchors.top: prev.bottom
    width: 86
    height: 17
    margin-top: 3
    color: #ee0000
    font: verdana-11px-rounded

  BotSwitch
    id: ptShare
    text: Auto Share
    anchors.left: prev.right
    anchors.bottom: prev.bottom
    margin-left: 4
    height: 17
    width: 86
  ]], parent)

g_ui.loadUIFromString([[
AutoPartyName < Label
  background-color: alpha
  text-offset: 2 0
  focusable: true
  height: 16

  $focus:
    background-color: #00000055

  Button
    id: remove
    text: x
    anchors.right: parent.right
    margin-right: 15
    width: 15
    height: 15

AutoPartyListWindow < MainWindow
  text: Auto Party
  size: 200 315
  @onEscape: self:hide()

  Label
    id: lblLeader
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.right: parent.right
    text-align: center
    text: Leader Name

  TextEdit
    id: txtLeader
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5

  Label
    id: lblParty
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Party List

  TextList
    id: lstAutoParty
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    margin-bottom: 5
    padding: 1
    height: 100
    vertical-scrollbar: AutoPartyListListScrollBar

  VerticalScrollBar
    id: AutoPartyListListScrollBar
    anchors.top: lstAutoParty.top
    anchors.bottom: lstAutoParty.bottom
    anchors.right: lstAutoParty.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: playerName
    anchors.left: parent.left
    anchors.top: lstAutoParty.bottom
    margin-top: 5
    width: 120

  Button
    id: addPlayer
    text: +
    font: verdana-11px-rounded
    anchors.right: parent.right
    anchors.left: prev.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    margin-left: 3

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 8

  CheckBox
    id: inviteMsg
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 6
    text: Invite/Accept on Msg:
    tooltip: If you are the leader, invite player that said this msg, else, accept party when someone say this.\n

  TextEdit
    id: inviteTxt
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: inviteMsg.bottom
    margin-top: 5
    width: 148

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 6

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21

  Button
    id: info
    text: Credits
    font: cipsoftFont
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    size: 45 21
    color: yellow
    !tooltip: tr('Original made by Lee#7225\nModified by F.Almeida#8019')
    @onClick: g_platform.openUrl("https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD")
]])

local panelName = "autoParty"

if not storage[panelName] then
  storage[panelName] = {
    leaderName = 'Leader',
    autoPartyList = {},
    enabled = false,
    inviteTxt = 'party me',
    autoShare = false,
    onMsg = false,
  }
end

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then
  tcAutoParty = autopartyui.status
  tcAutoShare = autopartyui.ptShare

  autoPartyListWindow = UI.createWindow('AutoPartyListWindow', rootWidget)
  autoPartyListWindow:hide()

  autopartyui.editPlayerList.onClick = function(widget)
    autoPartyListWindow:show()
    autoPartyListWindow:raise()
    autoPartyListWindow:focus()
  end

  autopartyui.ptLeave.onClick = function(widget)
    g_game.partyLeave()
  end

  autoPartyListWindow.closeButton.onClick = function(widget)
    autoPartyListWindow:hide()
  end

  if config.autoPartyList and #config.autoPartyList > 0 then
    for _, pName in ipairs(config.autoPartyList) do
      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function(widget)
        table.removevalue(config.autoPartyList, label:getText())
        label:destroy()
      end
      label:setText(pName)
    end
  end
  autoPartyListWindow.addPlayer.onClick = function(widget)
    local playerName = autoPartyListWindow.playerName:getText()
    if playerName:len() > 0 and not (table.contains(config.autoPartyList, playerName, true) or config.leaderName == playerName) then
      table.insert(config.autoPartyList, playerName)
      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function(widget)
        table.removevalue(config.autoPartyList, label:getText())
        label:destroy()
      end
      label:setText(playerName)
      autoPartyListWindow.playerName:setText('')
    end
  end

  autopartyui.status:setOn(config.enabled)
  autopartyui.status.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
  end

  autopartyui.ptShare:setOn(config.autoShare)
  autopartyui.ptShare.onClick = function(widget)
    config.autoShare = not config.autoShare
    widget:setOn(config.autoShare)
  end

  autoPartyListWindow.inviteMsg:setChecked(config.onMsg)
  autoPartyListWindow.inviteMsg.onClick = function(widget)
    config.onMsg = not config.onMsg
    widget:setChecked(config.onMsg)
  end

  autoPartyListWindow.playerName.onKeyPress = function(self, keyCode, keyboardModifiers)
    if not (keyCode == 5) then
      return false
    end
    autoPartyListWindow.addPlayer.onClick()
    return true
  end

  autoPartyListWindow.playerName.onTextChange = function(widget, text)
    if table.contains(config.autoPartyList, text, true) then
      autoPartyListWindow.addPlayer:setColor("red")
    else
      autoPartyListWindow.addPlayer:setColor("green")
    end
  end

  autoPartyListWindow.txtLeader.onTextChange = function(widget, text)
    config.leaderName = text
  end
  autoPartyListWindow.txtLeader:setText(config.leaderName)

  autoPartyListWindow.inviteTxt.onTextChange = function(widget, text)
    config.inviteTxt = text
  end
  autoPartyListWindow.inviteTxt:setText(config.inviteTxt)
  
  -- main loop
  macro(500,function()
    if not config.enabled then return true end
    local lider = player:getName():lower() == config.leaderName:lower()
    for s, spec in pairs(getSpectators()) do
      if spec:isPlayer() and spec ~= player then
        if lider then
          if spec:getShield() == 0 then
            if table.find(config.autoPartyList,spec:getName(),true) then
              g_game.partyInvite(spec:getId())
            end
          end
        else
          if spec:getShield() == 1 then
           if spec:getName():lower() == config.leaderName:lower() then
            g_game.partyJoin(spec:getId())
           end
          end
        end
      end
    end
    if lider and config.autoShare then
      if not player:isPartySharedExperienceActive() then
        g_game.partyShareExperience(true)
      end
    end
  end)

  -- invite on msg
  onTalk(function(name, level, mode, text, channelId, pos)
    if not config.enabled then return true end
    if not config.onMsg or not string.find(text, config.inviteTxt) then return true end
    local c = getCreatureByName(name)
    if c then 
      if c:isPlayer() and c ~= player then
        if c:getShield() == 0 then
          g_game.partyInvite(c:getId())
        elseif c:getShield() == 1 then
          g_game.partyJoin(c:getId())
        end
      end
    end
  end)
end

UI.Separator()






UI.Label("Mana training")
if type(storage.manaTrain) ~= "table" then
  storage.manaTrain = {on=false, title="MP%", text="utevo lux", min=80, max=100}
end

local manatrainmacro = macro(1000, function()
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  local mana = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain.max >= mana and mana >= storage.manaTrain.min then
    say(storage.manaTrain.text)
  end
end)
manatrainmacro.setOn(storage.manaTrain.on)

UI.DualScrollPanel(storage.manaTrain, function(widget, newParams) 
  storage.manaTrain = newParams
  manatrainmacro.setOn(storage.manaTrain.on)
end)

macro(1000, "Stack items", function()
  local containers = g_game.getContainers()
  local toStack = {}
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:isStackable() and item:getCount() < 100 then
          local stackWith = toStack[item:getId()]
          if stackWith then
            g_game.move(item, stackWith[1], math.min(stackWith[2], item:getCount()))
            return
          end
          toStack[item:getId()] = {container:getSlotPosition(i - 1), 100 - item:getCount()}
        end
      end
    end
  end
end)

local idz = {3031, 3035, 3043, 14112, 10386, 10384, 3428} -- adicionar ID dos itens
macro(400, "Coletar", function()
local z = posz()
for _, tile in ipairs(g_map.getTiles(z)) do
    if z ~= posz() then return end
        if getDistanceBetween(pos(), tile:getPosition()) <= 1 then -- distância que quer coletar
            if table.find(idz, tile:getTopLookThing():getId()) then
                g_game.move(tile:getTopLookThing(), {x = 65535, y=SlotBack, z=0}, tile:getTopLookThing():getCount())
            end
        end
    end
end)

macro(1000, "Close Channels", function()
	modules.game_console.removeTab("Trade")
	modules.game_console.removeTab("Help")
	modules.game_console.removeTab("Quests")
	modules.game_console.removeTab("Game-Chat")
end)


macro(200, "Empurrar Itens", function()
  push(0, -1)  -- Empurra o item ao norte para 1 sqm ao norte
  push(0, 1)   -- Empurra o item ao sul para 1 sqm ao sul
  push(-1, 0)  -- Empurra o item a oeste para 1 sqm a oeste
  push(1, 0)   -- Empurra o item a leste para 1 sqm a leste
end)

function push(x, y)
  local playerPos = player:getPosition()
  local targetPos = {x = playerPos.x + x, y = playerPos.y + y, z = playerPos.z}
  local pushPos = {x = targetPos.x + x, y = targetPos.y + y, z = targetPos.z}

  local tile = g_map.getTile(targetPos)
  local thing = tile and tile:getTopThing()
  
  if thing and thing:isItem() then
    g_game.move(thing, pushPos, thing:getCount())
  end
end

UI.Separator()