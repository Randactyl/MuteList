local ML = MuteList
ML.util = {}

local settings = ML.settings
local util = ML.util
util.commands = {}
util.LC = LibStub("libChat-1.0")
util.LSC = LibStub("LibSlashCommander")

function util.InitializeSlashCommands()
    local function muteList()
        local list = settings.GetMuteList()
        local empty = true

        for playerName, _ in pairs(settings.GetMuteList()) do
            d(playerName)
            empty = false
        end

        if empty then d(GetString(SI_MUTELIST_EMPTY_MESSAGE)) end
    end
    util.commands.list = util.LSC:Register(GetString(SI_MUTELIST_LSC_LIST_COMMAND), muteList, GetString(SI_MUTELIST_LSC_LIST_DESCRIPTION))

    local function unmute(playerName)
        local result = settings.Unmute(playerName)

        if result then
            util.RefreshUnmuteAutoCompleteData()
            df(GetString(SI_MUTELIST_UNMUTE_MESSAGE), playerName)
        else
            df(GetString(SI_MUTELIST_UNMUTE_ERROR), playerName)
        end
    end
    util.commands.unmute = util.LSC:Register(GetString(SI_MUTELIST_LSC_UNMUTE_COMMAND), unmute, GetString(SI_MUTELIST_LSC_UNMUTE_DESCRIPTION))
end

function util.RefreshUnmuteAutoCompleteData()
    local autoCompleteData = {}
    for playerName, _ in pairs(settings.GetMuteList()) do
        table.insert(autoCompleteData, playerName)
    end
    table.sort(autoCompleteData)

    util.commands.unmute:SetAutoComplete(autoCompleteData)
end

--override SharedChatSystem:ShowPlayerContextMenu(playerName, rawName) from line 2076 in sharedchatsystem.lua
function CHAT_SYSTEM:ShowPlayerContextMenu(playerName, rawName)
    ClearMenu()

    local otherPlayerIsDecoratedName = IsDecoratedDisplayName(playerName)

    local localPlayerIsGrouped = IsUnitGrouped("player")
    local localPlayerIsGroupLeader = IsUnitGroupLeader("player")
    local otherPlayerIsInPlayersGroup = not otherPlayerIsDecoratedName and IsPlayerInGroup(rawName)

    if IsGroupModificationAvailable() then
        if not localPlayerIsGrouped or (localPlayerIsGroupLeader and not otherPlayerIsInPlayersGroup) then
            AddCustomMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_ADD_GROUP), function()
                local SENT_FROM_CHAT = false
                local DISPLAY_INVITED_MESSAGE = true
                TryGroupInviteByName(playerName, SENT_FROM_CHAT, DISPLAY_INVITED_MESSAGE)
            end)
        elseif otherPlayerIsInPlayersGroup and localPlayerIsGroupLeader then
            AddCustomMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_REMOVE_GROUP), function()
                GroupKickByName(rawName)
            end)
        end
    end

    local function IgnoreSelectedPlayer()
        if not IsIgnored(rawName) then
            AddIgnore(playerName)
        end
    end

    AddCustomMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_WHISPER), function()
        self:StartTextEntry(nil, CHAT_CHANNEL_WHISPER, playerName)
    end)

    if(not IsIgnored(rawName)) then
        AddCustomMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_ADD_IGNORE), IgnoreSelectedPlayer)
    end

    if not settings.IsMuted(playerName) then
        AddCustomMenuItem(GetString(SI_MUTELIST_MUTE_OPTION), function()
            settings.Mute(playerName)
            util.RefreshUnmuteAutoCompleteData()
            df(GetString(SI_MUTELIST_MUTE_MESSAGE), playerName)
        end)
    end

    if(not IsFriend(rawName)) then
        AddCustomMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_ADD_FRIEND), function()
            ZO_Dialogs_ShowDialog("REQUEST_FRIEND", {name = rawName})
        end)
    end

    AddCustomMenuItem(zo_strformat(SI_CHAT_PLAYER_CONTEXT_REPORT, rawName), function()
        ZO_HELP_GENERIC_TICKET_SUBMISSION_MANAGER:OpenReportPlayerTicketScene(playerName, IgnoreSelectedPlayer)
    end)

    if(ZO_Menu_GetNumMenuItems() > 0) then
        ShowMenu()
    end
end