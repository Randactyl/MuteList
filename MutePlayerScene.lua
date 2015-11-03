local function CreateFragment()
    local MutePlayerList = WINDOW_MANAGER:CreateTopLevelWindow("MutePlayerList")
    MutePlayerList:SetAnchor(TOPLEFT, ZO_KeyboardIgnoreList, TOPLEFT)
    MutePlayerList:SetHidden(true)
    MutePlayerList:SetWidth(930)
    MutePlayerList:SetHeight(690)

    MUTE_PLAYER_FRAGMENT = ZO_FadeSceneFragment:New(MutePlayerList)
end

local function CreateScene()
    MUTE_PLAYER_SCENE = ZO_Scene:New("MutePlayer", SCENE_MANAGER)
    MUTE_PLAYER_SCENE:AddFragment(MOUSE_UI_MODE_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(KEYBIND_STRIP_FADE_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(KEYBIND_STRIP_MUNGE_BACKDROP_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(UI_SHORTCUTS_ACTION_LAYER_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(CLEAR_CURSOR_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(UI_COMBAT_OVERLAY_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(END_IN_WORLD_INTERACTIONS_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(FRAME_TARGET_STANDARD_RIGHT_PANEL_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(FRAME_TARGET_BLUR_STANDARD_RIGHT_PANEL_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(FRAME_PLAYER_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(PLAYER_PROGRESS_BAR_KEYBOARD_TEXTURE_SWAP_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(DISPLAY_NAME_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(MUTE_PLAYER_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(TITLE_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(CONTACTS_TITLE_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(FRAME_EMOTE_FRAGMENT_SOCIAL)
    MUTE_PLAYER_SCENE:AddFragment(CONTACTS_WINDOW_SOUNDS)
    MUTE_PLAYER_SCENE:AddFragment(FRIENDS_ONLINE_FRAGMENT)
    MUTE_PLAYER_SCENE:AddFragment(TOP_BAR_FRAGMENT)
end

do
    CreateFragment()
    CreateScene()

    ZO_CreateStringId("SI_MUTE_PLAYER", "Muted")

    local index = #MAIN_MENU_KEYBOARD.sceneGroupInfo.contactsSceneGroup.menuBarIconData + 1
    MAIN_MENU_KEYBOARD.sceneGroupInfo.contactsSceneGroup.menuBarIconData[index] = {
        categoryName = SI_MUTE_PLAYER,
        descriptor = "MutePlayer",
        normal = "EsoUI/Art/Campaign/campaign_tabIcon_summary_up.dds",
        pressed = "EsoUI/Art/Campaign/campaign_tabIcon_summary_down.dds",
        highlight = "EsoUI/Art/Campaign/campaign_tabIcon_summary_over.dds",
    }

    SCENE_MANAGER:GetSceneGroup("contactsSceneGroup").scenes[index] = "MutePlayer"
    MUTE_PLAYER_SCENE:AddFragment(ZO_FadeSceneFragment:New(MAIN_MENU_KEYBOARD.sceneGroupBar))

    MAIN_MENU_KEYBOARD:AddRawScene("MutePlayer", 10,
      MAIN_MENU_KEYBOARD.categoryInfo[10], "contactsSceneGroup")
end
