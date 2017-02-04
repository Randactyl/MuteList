local ML = MuteList
ML.util = {}

local settings = ML.settings
local util = ML.util
util.LC = LibStub("libChat-1.0")

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
            TryGroupInviteByName(playerName, SENT_FROM_CHAT, DISPLAY_INVITED_MESSAGE)
        end)
    elseif otherPlayerIsInPlayersGroup and localPlayerIsGroupLeader then
        AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_REMOVE_GROUP), function()
            GroupKickByName(rawName)
        end)
    end

    AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_WHISPER), function()
        self:StartTextEntry(nil, CHAT_CHANNEL_WHISPER, playerName)
    end)

    if(not IsIgnored(rawName)) then
        AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_ADD_IGNORE), function()
            AddIgnore(playerName)
        end)
    end

    if not settings.IsMuted(playerName) then
        AddMenuItem(GetString(SI_MUTELIST_MUTE_OPTION), function()
            settings.Mute(playerName)
            df(GetString(SI_MUTELIST_MUTE_MESSAGE), playerName)
        end)
    end

    if(not IsFriend(rawName)) then
        AddMenuItem(GetString(SI_CHAT_PLAYER_CONTEXT_ADD_FRIEND), function()
            ZO_Dialogs_ShowDialog("REQUEST_FRIEND", {name = rawName})
        end)
    end

    AddMenuItem(zo_strformat(SI_CHAT_PLAYER_CONTEXT_REPORT, rawName), function()
        ZO_ReportPlayerDialog_Show(playerName, REPORT_PLAYER_REASON_CHAT_SPAM, rawName)
    end)

    if(ZO_Menu_GetNumMenuItems() > 0) then
        ShowMenu()
    end
end