local ML = MuteList
ML.settings = {}

local settings = ML.settings
settings.varsVersion = 1

local vars

function settings.InitializeSettings()
    local defaultVars = {
        muteList = {},
    }
    settings.vars = ZO_SavedVars:NewAccountWide("MuteList_Data", settings.varsVersion, nil, defaultVars)
    vars = settings.vars
end

function settings.GetMuteList()
    return ZO_ShallowTableCopy(vars.muteList)
end

function settings.IsMuted(playerName)
    return vars.muteList[playerName] or false
end

function settings.Mute(playerName)
    vars.muteList[playerName] = true
end

function settings.Unmute(playerName)
    if settings.IsMuted(playerName) then
        vars.muteList[playerName] = nil
        return true
    end

    return false
end