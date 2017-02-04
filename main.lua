MuteList = {}
local ML = MuteList

local settings, util

local function onAddonLoaded(eventCode, addonName)
    if addonName ~= "MuteList" then return end
    EVENT_MANAGER:UnregisterForEvent("MuteList_OnAddonLoaded", EVENT_ADD_ON_LOADED)

    util = ML.util
    settings = ML.settings

    settings.InitializeSettings()

    local function modifySenderName(channelId, senderName, isCustomerService)
        local formattedName = zo_strformat("<<1>>", senderName)

        if settings.IsMuted(formattedName) then return end
        return senderName
    end
    util.LC:registerName(modifySenderName, "MuteList")

    local function initializeSlashCommands()
        SLASH_COMMANDS["/mutelist"] = function(args)
            for playerName, _ in pairs(settings.GetMuteList()) do
                d(playerName)
            end
        end

        SLASH_COMMANDS["/unmute"] = function(playerName)
            local result = settings.Unmute(playerName)

            if result then
                df(GetString(SI_MUTELIST_UNMUTE_MESSAGE), playerName)
            else
                df(GetString(SI_MUTELIST_UNMUTE_ERROR), playerName)
            end
        end
    end
    initializeSlashCommands()
end
EVENT_MANAGER:RegisterForEvent("MuteList_OnAddonLoaded", EVENT_ADD_ON_LOADED, onAddonLoaded)