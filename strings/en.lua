local strings = {
    SI_MUTELIST_EMPTY_MESSAGE = "Mute list is empty.",
    SI_MUTELIST_MUTE_OPTION = "Mute",
    SI_MUTELIST_MUTE_MESSAGE = "[%s] added to mute list.",
    SI_MUTELIST_UNMUTE_MESSAGE = "[%s] removed from mute list.",
    SI_MUTELIST_UNMUTE_ERROR = "[%s] not muted.",

    SI_MUTELIST_LSC_LIST_COMMAND = "/mutelist",
    SI_MUTELIST_LSC_LIST_DESCRIPTION = "Print mute list to chat",
    SI_MUTELIST_LSC_UNMUTE_COMMAND = "/unmute",
    SI_MUTELIST_LSC_UNMUTE_DESCRIPTION = "Enter name to unmute",
}

for stringId, stringValue in pairs(strings) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end

strings = nil