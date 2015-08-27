local libChat = LibStub("libChat-1.0")
local LibScroll = LibStub("LibScroll")
local savedVars = nil

local function AddMute(playerName)
	--d("AddMute playerName: " .. playerName)
	savedVars.muted[playerName] = {}
end

local function IsMuted(playerName)
	--d("IsMuted playerName: " .. playerName)
	if savedVars.muted[playerName] then return true end
	return false
end

local function modifySenderName(channelId, senderName, isCustomerService)
	local formattedName = zo_strformat("<<1>>", senderName)
	--d("senderName: " .. formattedName)
	if IsMuted(formattedName) then return end
	return senderName
end

local function InitializeSlashCommands()
	SLASH_COMMANDS["/mutelist"] = function(args)
		for playerName, _ in pairs(savedVars.muted) do
			d(playerName)
		end
	end

	SLASH_COMMANDS["/unmute"] = function(playerName)
		if IsMuted(playerName) then
			savedVars.muted[playerName] = nil
			d("[" .. playerName .. "] removed from Mute List.")
		else
			d("[" .. playerName .. "] not muted.")
		end
	end
end

local function CreateScrollList()
	local function SortScrollList(objA, objB)
		return objA.data.name < objB.data.name
	end
	local function OnRowSelect(previouslySelectedData, selectedData, reselectingDuringRebuild)
		if not selectedData then return end
		d("you selected a row!")
	end
	local function setupDataRow(rowControl, data, scrollList)
		rowControl:SetText(data.name)
		rowControl:SetFont("ZoFontWinH4")

		rowControl:SetHandler("OnMouseUp", function()
			ZO_ScrollList_MouseClick(scrollList, rowControl)
		end)
	end

	local scrollData = {
		name = "MutePlayerScrollList",
		parent = MutePlayerList,
		width = 930,
		height = 690,

		rowHeight = 30,
		setupCallback = setupDataRow,
		selectCallback = OnRowSelect,
		dataTypeSelectSound = SOUNDS.BOOK_CLOSE,
		sortFunction = SortScrollList,
	}
	local scrollList = LibScroll:CreateScrollList(scrollData)
	scrollList:SetAnchor(TOPLEFT, MutePlayerList, TOPLEFT, 50, 50)

	local dataItems = {}
	for playerName, _ in pairs(savedVars.muted) do
		table.insert(dataItems, {name = playerName,})
	end
	scrollList:Update(dataItems)
end

local function OnAddonLoaded(eventCode, addonName)
	if addonName ~= "MutePlayer" then return end
	EVENT_MANAGER:UnregisterForEvent("MutePlayer_OnAddonLoaded", EVENT_ADD_ON_LOADED)

	savedVars = ZO_SavedVars:NewAccountWide("MutePlayerSavedVariables", 1, nil, { muted = {}, })

	libChat:registerName(modifySenderName, "MutePlayer")

	CreateScrollList()

	InitializeSlashCommands()
end

--override SharedChatSystem:ShowPlayerContextMenu(playerName, rawName) from line 2072 in sharedchatsystem.lua
function CHAT_SYSTEM:ShowPlayerContextMenu(playerName, rawName)
	ClearMenu()

    local otherPlayerIsDecoratedName = IsDecoratedDisplayName(playerName)

    local localPlayerIsGrouped = IsUnitGrouped("player")
    local localPlayerIsGroupLeader = IsUnitGroupLeader("player")
    local otherPlayerIsInPlayersGroup = not otherPlayerIsDecoratedName and IsPlayerInGroup(rawName)

    if not localPlayerIsGrouped or (localPlayerIsGroupLeader and not otherPlayerIsInPlayersGroup) then
        AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_ADD_GROUP), function()
            local SENT_FROM_CHAT = false
            local DISPLAY_INVITED_MESSAGE = true
            TryGroupInviteByName(playerName, SENT_FROM_CHAT, DISPLAY_INVITED_MESSAGE) end)
    elseif otherPlayerIsInPlayersGroup and localPlayerIsGroupLeader then
        AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_REMOVE_GROUP), function() GroupKickByName(rawName) end)
    end

    AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_WHISPER), function() self:StartTextEntry(nil, CHAT_CHANNEL_WHISPER, playerName) end)
    if(not IsIgnored(rawName)) then
        AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_ADD_IGNORE), function() AddIgnore(playerName) end)
    end
    --my code
    if not IsMuted(playerName) then
    	AddMenuItem("Mute", function() AddMute(playerName); d("[" .. playerName .. "] added to Mute List.") end)
    end
    --end my code
    if(not IsFriend(rawName)) then
        AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_ADD_FRIEND), function() ZO_Dialogs_ShowDialog("REQUEST_FRIEND", {name = rawName}) end)
    end

    AddMenuItem(zo_strformat(SI_CHAT_PLAYER_CONTEXT_REPORT, rawName), function() ZO_ReportPlayerDialog_Show(playerName, REPORT_PLAYER_REASON_CHAT_SPAM, rawName) end)

    if(ZO_Menu_GetNumMenuItems() > 0) then
        ShowMenu()
    end
end

EVENT_MANAGER:RegisterForEvent("MutePlayer_OnAddonLoaded", EVENT_ADD_ON_LOADED, OnAddonLoaded)
