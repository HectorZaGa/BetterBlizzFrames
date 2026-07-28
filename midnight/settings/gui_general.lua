if not BBF.isMidnight then return end
local L = BBF.L

local fontSmall = BBF.fontSmall
local fontMedium = BBF.fontMedium
local fontLarge = BBF.fontLarge
local anchorPoints = BBF.anchorPoints
local anchorPoints2 = BBF.anchorPoints2
local pixelsBetweenBoxes = BBF.pixelsBetweenBoxes
local pixelsOnFirstBox = BBF.pixelsOnFirstBox
local sliderUnderBoxX = BBF.sliderUnderBoxX
local sliderUnderBoxY = BBF.sliderUnderBoxY
local sliderUnderBox = BBF.sliderUnderBox
local playerClass = BBF.playerClass
local playerClassResourceScale = BBF.playerClassResourceScale

local LibDD = BBF.LibDD
local LSM = BBF.LSM
local CreateCheckbox = BBF.CreateCheckbox
local CreateSlider = BBF.CreateSlider
local CreateSimpleDropdown = BBF.CreateSimpleDropdown
local CreateFontDropdown = BBF.CreateFontDropdown
local CreateTextureDropdown = BBF.CreateTextureDropdown
local CreateColorBox = BBF.CreateColorBox
local CreateImportExportUI = BBF.CreateImportExportUI
local CreateTitle = BBF.CreateTitle
local CreateTooltip = BBF.CreateTooltip
local CreateTooltipTwo = BBF.CreateTooltipTwo
local CreateClassButton = BBF.CreateClassButton
local CreateCDManagerList = BBF.CreateCDManagerList
local CreateList = BBF.CreateList
local CreateAnchorDropdown = BBF.CreateAnchorDropdown
local CreateIconChangeWindow = BBF.CreateIconChangeWindow
local CreateBorderedFrame = BBF.CreateBorderedFrame
local OpenColorOptions = BBF.OpenColorOptions
local RecolorEntireAuraWhitelist = BBF.RecolorEntireAuraWhitelist
local UpdateColorSquare = BBF.UpdateColorSquare
local CreateSearchFrame = BBF.CreateSearchFrame
local CheckAndToggleCheckboxes = BBF.CheckAndToggleCheckboxes
local DisableElement = BBF.DisableElement
local EnableElement = BBF.EnableElement
local CreateBorderBox = BBF.CreateBorderBox
local FormatClassName = BBF.FormatClassName
local ShowProfileConfirmation = BBF.ShowProfileConfirmation
local HandleEditBoxInput = BBF.HandleEditBoxInput
local SetSliderValue = BBF.SetSliderValue
local UpdateSliderRange = BBF.UpdateSliderRange

function guiGeneralTab()
    ----------------------
    -- Main panel:
    ----------------------
    local mainGuiAnchor = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor:SetPoint("TOPLEFT", 15, -15)
    mainGuiAnchor:SetText(" ")

    BetterBlizzFrames.searchName = L["Search_Name_General"]

    local profilesFrame = guiProfiles()

    local bgImg = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", BetterBlizzFrames, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local midnightBeta = BetterBlizzFrames:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    midnightBeta:SetPoint("BOTTOM", SettingsPanel, "TOP", 0, 0)
    midnightBeta:SetText(L["Msg_Midnight_Early_Beta"])
    midnightBeta:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
    midnightBeta:Hide()
    BetterBlizzFrames:HookScript("OnShow",function()
        midnightBeta:Show()
    end)
    BetterBlizzFrames:HookScript("OnHide",function()
        midnightBeta:Hide()
    end)

    local newSearch = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearch:SetAtlas("NewCharacter-Horde", true)
    newSearch:SetPoint("BOTTOM", BetterBlizzFrames, "TOP", -70, 2)
    CreateTooltipTwo(newSearch, L["Search"], L["Tooltip_Search_Desc"])

    local newSearchPoint = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearchPoint:SetAtlas("auctionhouse-icon-buyallarrow", true)
    newSearchPoint:SetPoint("LEFT", newSearch, "RIGHT", -25, 0)
    newSearchPoint:SetRotation(math.pi / 2)

    CreateSearchFrame()
    CreateTitle(BetterBlizzFrames)

    if BetterBlizzFrames.titleText then
        BetterBlizzFrames.titleText:Hide()
        BetterBlizzFrames.loadGUI:Hide()
    end

    -------------------------------------------------------
    -- 2-COLUMN SIDEBAR & CATEGORY CONTENT SYSTEM
    -------------------------------------------------------
    local sidebar = CreateFrame("Frame", nil, BetterBlizzFrames, "BackdropTemplate")
    sidebar:SetSize(165, 545)
    sidebar:SetPoint("TOPLEFT", BetterBlizzFrames, "TOPLEFT", 15, -45)
    sidebar:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    sidebar:SetBackdropColor(0, 0, 0, 0.4)
    sidebar:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.6)

    local sidebarTitle = sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sidebarTitle:SetPoint("TOPLEFT", 10, -8)
    sidebarTitle:SetText("|cff00c0ff" .. (L["Categories"] or "Categorías") .. "|r")
    sidebarTitle:SetFont(fontSmall, 11, "OUTLINE")

    local contentParent = CreateFrame("Frame", nil, BetterBlizzFrames)
    contentParent:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 10, 0)
    contentParent:SetPoint("BOTTOMRIGHT", BetterBlizzFrames, "BOTTOMRIGHT", -15, 15)

    local categoryList = {
        { id = "general",     label = L["General_Settings"] or "General Settings", icon = "Interface\\Icons\\INV_Gizmo_02" },
        { id = "player",      label = L["Player_Frame"] or "Player Frame",         icon = "Interface\\Icons\\Achievement_GuildPerk_MobileBanking" },
        { id = "party",       label = L["Party_Frame"] or "Party Frame",           icon = "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend" },
        { id = "all",         label = L["All_Frames"] or "All Frames",             icon = "Interface\\Icons\\Ability_Warrior_ShieldWall" },
        { id = "targetFocus", label = L["Target_Focus_Frames"] or "Target & Focus",  icon = "Interface\\Icons\\Ability_Tracking" },
        { id = "tot",         label = L["ToT_Frames"] or "Target / Focus ToT",      icon = "Interface\\Icons\\Spell_Holy_MindVision" },
        { id = "chat",        label = L["Chat_Frame"] or "Chat Frame",             icon = "Interface\\Icons\\UI_Chat" },
        { id = "extra",       label = L["Extra_Features"] or "Extra Features",     icon = "Interface\\Icons\\Spell_Holy_PowerInfusion" },
        { id = "arenaNames",  label = L["Arena_Names"] or "Arena Names",           icon = "Interface\\Icons\\Achievement_Arena_3v3_7" },
        { id = "pet",         label = L["Pet_Frame"] or "Pet Frame",               icon = "Interface\\Icons\\Ability_Hunter_Pet_Raptor" },
    }

    local categoryFrames = {}
    local categoryButtons = {}

    local function SelectCategory(catId)
        for id, sf in pairs(categoryFrames) do
            sf:Hide()
        end
        for id, btn in pairs(categoryButtons) do
            btn.selectedTex:Hide()
            btn:GetFontString():SetTextColor(1, 0.82, 0)
        end
        if categoryFrames[catId] then
            categoryFrames[catId]:Show()
        end
        if categoryButtons[catId] then
            categoryButtons[catId].selectedTex:Show()
            categoryButtons[catId]:GetFontString():SetTextColor(0, 0.8, 1)
        end
    end

    for i, cat in ipairs(categoryList) do
        local sf = CreateFrame("ScrollFrame", "BBF_MidnightCat_" .. cat.id, contentParent, "UIPanelScrollFrameTemplate")
        sf:SetAllPoints(contentParent)
        sf:Hide()

        local cf = CreateFrame("Frame", nil, sf)
        cf:SetSize(470, 1400)
        sf:SetScrollChild(cf)

        categoryFrames[cat.id] = sf
        sf.contentFrame = cf

        local btn = CreateFrame("Button", nil, sidebar, "UIMenuButtonStretchTemplate")
        btn:SetSize(147, 28)
        btn:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 9, -24 - ((i - 1) * 31))
        btn:SetText(" " .. cat.label)
        btn:GetFontString():SetJustifyH("LEFT")
        btn:GetFontString():SetPoint("LEFT", 24, 0)

        local iconTex = btn:CreateTexture(nil, "ARTWORK")
        iconTex:SetSize(16, 16)
        iconTex:SetPoint("LEFT", 5, 0)
        iconTex:SetTexture(cat.icon)

        local sel = btn:CreateTexture(nil, "OVERLAY")
        sel:SetAtlas("Options_List_Hover")
        sel:SetAllPoints()
        sel:SetBlendMode("ADD")
        sel:SetAlpha(0.5)
        sel:Hide()
        btn.selectedTex = sel

        btn:SetScript("OnClick", function()
            SelectCategory(cat.id)
        end)

        categoryButtons[cat.id] = btn
    end

    -------------------------------------------------------
    -- CATEGORY 1: General settings
    -------------------------------------------------------
    local cfGen = categoryFrames["general"].contentFrame
    local settingsText = cfGen:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    settingsText:SetPoint("TOPLEFT", cfGen, "TOPLEFT", 10, -10)
    settingsText:SetText(L["General_Settings"])
    settingsText:SetFont(fontLarge, 16)
    settingsText:SetTextColor(1,1,1)

    local hideArenaFrames = CreateCheckbox("hideArenaFrames", L["Hide_Arena_Frames"], cfGen, nil, BBF.HideArenaFrames)
    hideArenaFrames:SetPoint("TOPLEFT", settingsText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    hideArenaFrames:HookScript("OnClick", function(self)
        if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end
    end)
    CreateTooltip(hideArenaFrames, L["Tooltip_Hide_Arena_Frames"])

    local hideBossFrames = CreateCheckbox("hideBossFrames", L["Hide_Boss_Frames"], cfGen, nil, BBF.HideArenaFrames)
    hideBossFrames:SetPoint("TOPLEFT", hideArenaFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideBossFrames, L["Tooltip_Hide_Boss_Frames"])

    local hideBossFramesParty = CreateCheckbox("hideBossFramesParty", L["Party"], cfGen, nil, BBF.HideArenaFrames)
    hideBossFramesParty:SetPoint("LEFT", hideBossFrames.text, "RIGHT", 0, 0)
    CreateTooltip(hideBossFramesParty, L["Tooltip_Hide_Boss_Frames_Party"], "ANCHOR_LEFT")

    local hideBossFramesRaid = CreateCheckbox("hideBossFramesRaid", L["Raid"], cfGen, nil, BBF.HideArenaFrames)
    hideBossFramesRaid:SetPoint("LEFT", hideBossFramesParty.text, "RIGHT", 0, 0)
    CreateTooltip(hideBossFramesRaid, L["Tooltip_Hide_Boss_Frames_Raid"], "ANCHOR_LEFT")

    hideBossFrames:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BetterBlizzFramesDB.overShieldsCompact = true
            BetterBlizzFramesDB.hideBossFramesParty = true
            hideBossFramesParty:SetAlpha(1); hideBossFramesParty:Enable(); hideBossFramesParty:SetChecked(true)
            hideBossFramesRaid:SetAlpha(1); hideBossFramesRaid:Enable(); hideBossFramesRaid:SetChecked(true)
        else
            BetterBlizzFramesDB.overShieldsCompact = false
            BetterBlizzFramesDB.hideBossFramesParty = false
            hideBossFramesParty:SetAlpha(0); hideBossFramesParty:Disable(); hideBossFramesParty:SetChecked(false)
            hideBossFramesRaid:SetAlpha(0); hideBossFramesRaid:Disable(); hideBossFramesRaid:SetChecked(false)
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    if not BetterBlizzFramesDB.hideBossFrames then
        hideBossFramesParty:SetAlpha(0); hideBossFramesParty:Disable()
        hideBossFramesRaid:SetAlpha(0); hideBossFramesRaid:Disable()
    end

    local playerFrameOCD = CreateCheckbox("playerFrameOCD", L["OCD_Tweaks"], cfGen, nil, BBF.FixStupidBlizzPTRShit)
    playerFrameOCD:SetPoint("TOPLEFT", hideBossFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(playerFrameOCD, L["Tooltip_OCD_Tweaks_Retail"])
    playerFrameOCD:HookScript("OnClick", function(self)
        BBF.AllNameChanges()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local hideLossOfControlFrameBg = CreateCheckbox("hideLossOfControlFrameBg", L["Hide_CC_Background"], cfGen, nil, BBF.HideFrames)
    hideLossOfControlFrameBg:SetPoint("TOPLEFT", playerFrameOCD, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideLossOfControlFrameBg, L["Tooltip_Hide_CC_Background"])
    hideLossOfControlFrameBg:HookScript("OnClick", function() BBF.ToggleLossOfControlTestMode() end)

    local hideLossOfControlFrameLines = CreateCheckbox("hideLossOfControlFrameLines", L["Hide_CC_Red_Lines"], cfGen, nil, BBF.HideFrames)
    hideLossOfControlFrameLines:SetPoint("TOPLEFT", hideLossOfControlFrameBg, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideLossOfControlFrameLines, L["Tooltip_Hide_CC_Red_Lines"])
    hideLossOfControlFrameLines:HookScript("OnClick", function() BBF.ToggleLossOfControlTestMode() end)

    local lossOfControlScale = CreateSlider(cfGen, L["CC_Scale"], 0.4, 1.4, 0.01, "lossOfControlScale", nil, 90)
    lossOfControlScale:SetPoint("LEFT", hideLossOfControlFrameBg.text, "RIGHT", 3, -16)
    CreateTooltipTwo(lossOfControlScale, L["Loss_of_Control_Scale"], L["Tooltip_LossOfControlScale_Desc"])

    local darkModeUi = CreateCheckbox("darkModeUi", L["Dark_Mode"], cfGen)
    darkModeUi:SetPoint("TOPLEFT", hideLossOfControlFrameLines, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeUi:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltip(darkModeUi, L["Tooltip_Dark_Mode"])

    local darkModeActionBars = CreateCheckbox("darkModeActionBars", L["ActionBars"], darkModeUi)
    darkModeActionBars:SetPoint("TOPLEFT", darkModeUi, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeActionBars:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltip(darkModeActionBars, L["Tooltip_Dark_Mode_ActionBars"])

    local darkModeMinimap = CreateCheckbox("darkModeMinimap", L["Minimap"], darkModeUi)
    darkModeMinimap:SetPoint("TOPLEFT", darkModeActionBars, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeMinimap:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltip(darkModeMinimap, L["Dark_Mode_Minimap"])

    local darkModeCastbars = CreateCheckbox("darkModeCastbars", L["Castbars"], darkModeUi)
    darkModeCastbars:SetPoint("LEFT", darkModeUi.Text, "RIGHT", 5, 0)
    darkModeCastbars:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltip(darkModeCastbars, L["Tooltip_Dark_Mode_Castbars"])

    local darkModeUiAura = CreateCheckbox("darkModeUiAura", L["Auras"], darkModeUi)
    darkModeUiAura:SetPoint("TOPLEFT", darkModeCastbars, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeUiAura:HookScript("OnClick", function() StaticPopup_Show("BBF_CONFIRM_RELOAD"); BBF.DarkmodeFrames(true) end)
    CreateTooltipTwo(darkModeUiAura, L["Tooltip_Dark_Mode_Auras"], L["Tooltip_Dark_Mode_Auras_Desc"])

    local darkModeNameplateResource = CreateCheckbox("darkModeNameplateResource", L["Nameplate_Resource"], darkModeUi)
    darkModeNameplateResource:SetPoint("TOPLEFT", darkModeUiAura, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeNameplateResource:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltip(darkModeNameplateResource, L["Dark_Mode_Nameplate_Resource"])

    local darkModeGameTooltip = CreateCheckbox("darkModeGameTooltip", L["Tooltip"], darkModeUi)
    darkModeGameTooltip:SetPoint("TOPLEFT", darkModeMinimap, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeGameTooltip:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltipTwo(darkModeGameTooltip, L["Dark_Mode_Tooltip"], L["Tooltip_Dark_Mode_GameTooltip_Desc"])

    local darkModeEliteTexture = CreateCheckbox("darkModeEliteTexture", L["Elite_Texture"], darkModeUi)
    darkModeEliteTexture:SetPoint("TOPLEFT", darkModeGameTooltip, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeEliteTexture:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltipTwo(darkModeEliteTexture, L["Dark_Mode_Elite_Texture"], L["Tooltip_Dark_Mode_Elite_Texture_Desc"])

    local darkModeObjectiveFrame = CreateCheckbox("darkModeObjectiveFrame", L["Objectives"], darkModeUi)
    darkModeObjectiveFrame:SetPoint("LEFT", darkModeGameTooltip.Text, "RIGHT", 5, 0)
    darkModeObjectiveFrame:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltipTwo(darkModeObjectiveFrame, L["Dark_Mode_Objectives"], L["Tooltip_Dark_Mode_Objectives_Desc"])

    local darkModeVigor = CreateCheckbox("darkModeVigor", L["Vigor"], darkModeUi)
    darkModeVigor:SetPoint("LEFT", darkModeObjectiveFrame.Text, "RIGHT", 5, 0)
    darkModeVigor:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
    CreateTooltipTwo(darkModeVigor, L["Dark_Mode_Vigor"], L["Tooltip_Dark_Mode_Vigor_Desc"])

    local darkModeColor = CreateSlider(darkModeUi, L["Darkness"], 0, 1, 0.01, "darkModeColor", nil, 90)
    darkModeColor:SetPoint("LEFT", darkModeUiAura.text, "RIGHT", 3, -1)
    CreateTooltipTwo(darkModeColor, L["Dark_Mode_Value"], L["Tooltip_Dark_Mode_Value_Desc"])

    darkModeUi:HookScript("OnClick", function(self) CheckAndToggleCheckboxes(darkModeUi, 0) end)
    if not BetterBlizzFramesDB.darkModeUi then CheckAndToggleCheckboxes(darkModeUi, 0) end

    -------------------------------------------------------
    -- CATEGORY 2: Player Frame
    -------------------------------------------------------
    local cfPlayer = categoryFrames["player"].contentFrame
    local playerFrameText = cfPlayer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerFrameText:SetPoint("TOPLEFT", cfPlayer, "TOPLEFT", 10, -10)
    playerFrameText:SetText(L["Player_Frame"])
    playerFrameText:SetFont(fontLarge, 16)
    playerFrameText:SetTextColor(1,1,1)

    BetterBlizzFrames.playerFrameHidden = CreateCheckbox("playerFrameHidden", L["Hide_Frame"], cfPlayer, nil, BBF.ClickthroughFrames)
    BetterBlizzFrames.playerFrameHidden:SetPoint("TOPLEFT", playerFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltipTwo(BetterBlizzFrames.playerFrameHidden, L["Hide_Frame"], L["Tooltip_Hide_Player_Frame"])
    BetterBlizzFrames.playerFrameHidden:HookScript("OnClick", function(self)
        BBF.HidePlayerFrame()
        if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end
    end)

    local playerFrameClickthrough = CreateCheckbox("playerFrameClickthrough", L["Clickthrough"], cfPlayer, nil, BBF.ClickthroughFrames)
    playerFrameClickthrough:SetPoint("LEFT", BetterBlizzFrames.playerFrameHidden.text, "RIGHT", 5, 0)
    CreateTooltip(playerFrameClickthrough, L["Tooltip_Clickthrough"])

    local playerReputationColor = CreateCheckbox("playerReputationColor", L["Add_Reputation_Color"], cfPlayer, nil, BBF.PlayerReputationColor)
    playerReputationColor:SetPoint("TOPLEFT", BetterBlizzFrames.playerFrameHidden, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local playerReputationClassColor = CreateCheckbox("playerReputationClassColor", L["Class_Color_Combo"], cfPlayer, nil, BBF.PlayerReputationColor)
    playerReputationClassColor:SetPoint("LEFT", playerReputationColor.text, "RIGHT", 5, 0)

    local hidePlayerName = CreateCheckbox("hidePlayerName", L["Hide_Names"], cfPlayer, nil, BBF.UpdateNameSettings)
    hidePlayerName:SetPoint("TOPLEFT", playerReputationColor, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    hidePlayerName:HookScript("OnClick", function() BBF.SetCenteredNamesCaller() end)

    local symmetricPlayerFrame = CreateCheckbox("symmetricPlayerFrame", L["Mirror_TargetFrame"], cfPlayer, nil, BBF.SymmetricPlayerFrame)
    symmetricPlayerFrame:SetPoint("LEFT", hidePlayerName.text, "RIGHT", 0, 0)

    local hidePlayerPower = CreateCheckbox("hidePlayerPower", L["Hide_Resource_Power"], cfPlayer, nil, BBF.HideFrames)
    hidePlayerPower:SetPoint("TOPLEFT", hidePlayerName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideResourceTooltip = CreateCheckbox("hideResourceTooltip", L["Hide_Resource_Tooltip"], cfPlayer, nil, BBF.HideClassResourceTooltip)
    hideResourceTooltip:SetPoint("TOPLEFT", hidePlayerPower, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideManaFeedback = CreateCheckbox("hideManaFeedback", L["Hide_Mana_Feedback"], cfPlayer, nil, BBF.HideFrames)
    hideManaFeedback:SetPoint("TOPLEFT", hideResourceTooltip, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePlayerRestAnimation = CreateCheckbox("hidePlayerRestAnimation", L["Hide_Zzz_Rest_Animation"], cfPlayer, nil, BBF.HideFrames)
    hidePlayerRestAnimation:SetPoint("TOPLEFT", hideManaFeedback, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePlayerCornerIcon = CreateCheckbox("hidePlayerCornerIcon", L["Hide_Corner_Icon"], cfPlayer, nil, BBF.HideFrames)
    hidePlayerCornerIcon:SetPoint("TOPLEFT", hidePlayerRestAnimation, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePlayerHealthLossAnim = CreateCheckbox("hidePlayerHealthLossAnim", L["Hide_Health_Loss_FX"], cfPlayer, nil, BBF.HideFrames)
    hidePlayerHealthLossAnim:SetPoint("LEFT", hidePlayerCornerIcon.text, "RIGHT", 0, 0)

    local hidePlayerRestGlow = CreateCheckbox("hidePlayerRestGlow", L["Hide_Rest_Glow"], cfPlayer, nil, BBF.HideFrames)
    hidePlayerRestGlow:SetPoint("TOPLEFT", hidePlayerCornerIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideFullPower = CreateCheckbox("hideFullPower", L["Hide_Full_Mana_FX"], cfPlayer, nil, BBF.HideFrames)
    hideFullPower:SetPoint("LEFT", hidePlayerRestGlow.text, "RIGHT", 0, 0)

    local hideCombatIcon = CreateCheckbox("hideCombatIcon", L["Hide_Combat_Icon"], cfPlayer, nil, BBF.HideFrames)
    hideCombatIcon:SetPoint("TOPLEFT", hidePlayerRestGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideHitIndicator = CreateCheckbox("hideHitIndicator", L["Hide_Hit_Indicator"], cfPlayer, nil, BBF.HideFrames)
    hideHitIndicator:SetPoint("LEFT", hideCombatIcon.text, "RIGHT", 0, 0)

    local hideGroupIndicator = CreateCheckbox("hideGroupIndicator", L["Hide_Group_Indicator"], cfPlayer, nil, BBF.HideFrames)
    hideGroupIndicator:SetPoint("TOPLEFT", hideCombatIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideTotemFrame = CreateCheckbox("hideTotemFrame", L["Hide_Totem_Frame"], cfPlayer, nil, BBF.HideFrames)
    hideTotemFrame:SetPoint("LEFT", hideGroupIndicator.text, "RIGHT", 0, 0)

    local hidePlayerLeaderIcon = CreateCheckbox("hidePlayerLeaderIcon", L["Hide_Leader_Icon"], cfPlayer, nil, BBF.HideFrames)
    hidePlayerLeaderIcon:SetPoint("TOPLEFT", hideGroupIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePlayerGuideIcon = CreateCheckbox("hidePlayerGuideIcon", L["Hide_Guide_Icon"], cfPlayer, nil, BBF.HideFrames)
    hidePlayerGuideIcon:SetPoint("LEFT", hidePlayerLeaderIcon.text, "RIGHT", 0, 0)

    local hidePlayerRoleIcon = CreateCheckbox("hidePlayerRoleIcon", L["Hide_Role_Icon"], cfPlayer, nil, BBF.HideFrames)
    hidePlayerRoleIcon:SetPoint("TOPLEFT", hidePlayerLeaderIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePvpTimerText = CreateCheckbox("hidePvpTimerText", L["Hide_PvP_Timer"], cfPlayer, nil, BBF.HideFrames)
    hidePvpTimerText:SetPoint("LEFT", hidePlayerRoleIcon.text, "RIGHT", 0, 0)

    -------------------------------------------------------
    -- CATEGORY 3: Party Frame
    -------------------------------------------------------
    local cfParty = categoryFrames["party"].contentFrame
    local partyFrameText = cfParty:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    partyFrameText:SetPoint("TOPLEFT", cfParty, "TOPLEFT", 10, -10)
    partyFrameText:SetText(L["Party_Frame"])
    partyFrameText:SetFont(fontLarge, 16)
    partyFrameText:SetTextColor(1,1,1)

    local showPartyCastbar = CreateCheckbox("showPartyCastbar", L["Party_Castbars"], cfParty, nil, BBF.UpdateCastbars)
    showPartyCastbar:SetPoint("TOPLEFT", partyFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local hidePartyRoles = CreateCheckbox("hidePartyRoles", L["Hide_Role_Icons"], cfParty)
    hidePartyRoles:SetPoint("LEFT", showPartyCastbar.text, "RIGHT", 0, 0)

    local hidePartyFramesInArena = CreateCheckbox("hidePartyFramesInArena", L["Hide_Party_in_Arena"], cfParty, nil, BBF.HidePartyInArena)
    hidePartyFramesInArena:SetPoint("TOPLEFT", showPartyCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local raidFramePixelBorder = CreateCheckbox("raidFramePixelBorder", L["Pixel_Border"], cfParty)
    raidFramePixelBorder:SetPoint("LEFT", hidePartyFramesInArena.text, "RIGHT", 0, 0)

    local hidePartyNames = CreateCheckbox("hidePartyNames", L["Hide_Names"], cfParty)
    hidePartyNames:SetPoint("TOPLEFT", hidePartyFramesInArena, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePartyAggroHighlight = CreateCheckbox("hidePartyAggroHighlight", L["Hide_Aggro_Highlight"], cfParty, nil, BBF.HideFrames)
    hidePartyAggroHighlight:SetPoint("LEFT", hidePartyNames.text, "RIGHT", 0, 0)

    local hidePartyFrameTitle = CreateCheckbox("hidePartyFrameTitle", L["Hide_CompactPartyFrame_Title"], cfParty, nil, BBF.HideFrames)
    hidePartyFrameTitle:SetPoint("TOPLEFT", hidePartyNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideCompactUnitFrameBackground = CreateCheckbox("hideCompactUnitFrameBackground", L["Hide_Bg"], cfParty, nil, BBF.HideCompactUnitFrameBackgrounds)
    hideCompactUnitFrameBackground:SetPoint("LEFT", hidePartyFrameTitle.Text, "RIGHT", 0, 0)

    local hideRaidFrameManager = CreateCheckbox("hideRaidFrameManager", L["Hide_RaidFrameManager"], cfParty, nil, BBF.HideFrames)
    hideRaidFrameManager:SetPoint("TOPLEFT", hidePartyFrameTitle, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local classColorPartyNames = CreateCheckbox("classColorPartyNames", L["Color_Names"], cfParty, nil, BBF.AllNameChanges)
    classColorPartyNames:SetPoint("LEFT", hideRaidFrameManager.Text, "RIGHT", 0, 0)

    local hideRaidFrameContainerBorder = CreateCheckbox("hideRaidFrameContainerBorder", L["Hide_Container_Border"], cfParty, nil, BBF.HideFrames)
    hideRaidFrameContainerBorder:SetPoint("TOPLEFT", hideRaidFrameManager, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePartyDispelOverlay = CreateCheckbox("hidePartyDispelOverlay", L["Hide_Dispel_Overlay"], cfParty, nil, BBF.HideFrames)
    hidePartyDispelOverlay:SetPoint("LEFT", hideRaidFrameContainerBorder.Text, "RIGHT", 0, 0)

    local hidePartyRangeIcon = CreateCheckbox("hidePartyRangeIcon", L["Hide_Range_Icon"], cfParty, nil, BBF.HideFrames)
    hidePartyRangeIcon:SetPoint("TOPLEFT", hidePartyDispelOverlay, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local newRaidFrameRoleIcons = CreateCheckbox("newRaidFrameRoleIcons", L["New_Role_Icons"], cfParty)
    newRaidFrameRoleIcons:SetPoint("TOPLEFT", hidePartyRangeIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local betterTargetHighlight = CreateCheckbox("betterTargetHighlight", L["Better_Target_Highlight"], cfParty)
    betterTargetHighlight:SetPoint("TOPLEFT", newRaidFrameRoleIcons, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local partyFrameScale = CreateSlider(cfParty, L["Party_Frame_Scale"], 0.7, 1.7, 0.01, "partyFrameScale", nil, 120)
    partyFrameScale:SetPoint("TOPLEFT", betterTargetHighlight, "BOTTOMLEFT", 24, -20)

    local changePartyFrameRangeAlpha = CreateCheckbox("changePartyFrameRangeAlpha", "", cfParty)
    local partyFrameRangeAlpha = CreateSlider(changePartyFrameRangeAlpha, L["Party_Frame_Range_Alpha"], 0, 1, 0.01, "partyFrameRangeAlpha", nil, 120)
    partyFrameRangeAlpha:SetPoint("TOP", partyFrameScale, "BOTTOM", -5, -19)
    changePartyFrameRangeAlpha:SetPoint("RIGHT", partyFrameRangeAlpha, "LEFT", 0, 0)

    -------------------------------------------------------
    -- CATEGORY 4: All Frames
    -------------------------------------------------------
    local cfAll = categoryFrames["all"].contentFrame
    local allFrameText = cfAll:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    allFrameText:SetPoint("TOPLEFT", cfAll, "TOPLEFT", 10, -10)
    allFrameText:SetText(L["All_Frames"])
    allFrameText:SetFont(fontLarge, 16)
    allFrameText:SetTextColor(1,1,1)

    local classicFrames = CreateCheckbox("classicFrames", L["Classic_Frames"], cfAll)
    classicFrames:SetPoint("TOPLEFT", allFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local noPortraitModes = CreateCheckbox("noPortraitModes", L["No_Portrait"], cfAll)
    noPortraitModes:SetPoint("LEFT", classicFrames.text, "RIGHT", 0, 0)

    local noPortraitPixelBorder = CreateCheckbox("noPortraitPixelBorder", L["NP_PixelBorder"], cfAll)
    noPortraitPixelBorder:SetPoint("BOTTOMLEFT", noPortraitModes, "TOPRIGHT", -14, -5)

    local classColorFrames = CreateCheckbox("classColorFrames", L["Class_Color_Health"], cfAll)
    classColorFrames:SetPoint("TOPLEFT", classicFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local customHealthbarColors = CreateCheckbox("customHealthbarColors", L["Custom_Color_Health_Mana"], cfAll)
    customHealthbarColors:SetPoint("TOPLEFT", classColorFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local classColorTargetNames = CreateCheckbox("classColorTargetNames", L["Class_Color_Names"], cfAll)
    classColorTargetNames:SetPoint("TOPLEFT", customHealthbarColors, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local classColorLevelText = CreateCheckbox("classColorLevelText", L["Level"], classColorTargetNames)
    classColorLevelText:SetPoint("LEFT", classColorTargetNames.text, "RIGHT", 0, 0)

    local classColorFrameTexture = CreateCheckbox("classColorFrameTexture", L["Class_Color_FrameTexture"], cfAll)
    classColorFrameTexture:SetPoint("TOPLEFT", classColorTargetNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local centerNames = CreateCheckbox("centerNames", L["Center_Name"], cfAll, nil, BBF.SetCenteredNamesCaller)
    centerNames:SetPoint("TOPLEFT", classColorFrameTexture, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local removeRealmNames = CreateCheckbox("removeRealmNames", L["Hide_Realm"], cfAll)
    removeRealmNames:SetPoint("LEFT", centerNames.text, "RIGHT", 0, 0)

    local formatStatusBarText = CreateCheckbox("formatStatusBarText", L["Format_Numbers"], cfAll, nil, BBF.HookStatusBarText)
    formatStatusBarText:SetPoint("TOPLEFT", centerNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local singleValueStatusBarText = CreateCheckbox("singleValueStatusBarText", L["No_Max"], formatStatusBarText)
    singleValueStatusBarText:SetPoint("LEFT", formatStatusBarText.text, "RIGHT", 0, 0)

    local hidePrestigeBadge = CreateCheckbox("hidePrestigeBadge", L["Tooltip_Hide_PvP_Icon"], cfAll, nil, BBF.HideFrames)
    hidePrestigeBadge:SetPoint("TOPLEFT", formatStatusBarText, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideCombatGlow = CreateCheckbox("hideCombatGlow", L["Hide_Combat_Glow"], cfAll, nil, BBF.HideFrames)
    hideCombatGlow:SetPoint("TOPLEFT", hidePrestigeBadge, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideUnitFrameShadow = CreateCheckbox("hideUnitFrameShadow", L["Hide_Shadow"], cfAll, nil, BBF.HideFrames)
    hideUnitFrameShadow:SetPoint("LEFT", hideCombatGlow.text, "RIGHT", 0, 0)

    local hideLevelText = CreateCheckbox("hideLevelText", L["Hide_Max_Level_Text"], cfAll, nil, BBF.HideFrames)
    hideLevelText:SetPoint("TOPLEFT", hideCombatGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideLevelTextAlways = CreateCheckbox("hideLevelTextAlways", L["Always"], cfAll, nil, BBF.HideFrames)
    hideLevelTextAlways:SetPoint("LEFT", hideLevelText.Text, "RIGHT", 0, 0)

    local hideRareDragonTexture = CreateCheckbox("hideRareDragonTexture", L["Hide_Dragon"], cfAll, nil, BBF.HideFrames)
    hideRareDragonTexture:SetPoint("TOPLEFT", hideLevelText, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideThreatOnFrame = CreateCheckbox("hideThreatOnFrame", L["Hide_Threat"], cfAll, nil, BBF.HideFrames)
    hideThreatOnFrame:SetPoint("LEFT", hideRareDragonTexture.Text, "RIGHT", 0, 0)

    local classPortraitsUseSpecIcons = CreateCheckbox("classPortraitsUseSpecIcons", L["Use_Spec_Icons"], cfAll, nil, BBF.SpecPortraits)
    classPortraitsUseSpecIcons:SetPoint("TOPLEFT", hideRareDragonTexture, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local classPortraitsUseSpecIconsSkipSelf = CreateCheckbox("classPortraitsUseSpecIconsSkipSelf", L["Skip_Self"], cfAll, nil, BBF.SpecPortraits)
    classPortraitsUseSpecIconsSkipSelf:SetPoint("LEFT", classPortraitsUseSpecIcons.Text, "RIGHT", 0, 0)

    -------------------------------------------------------
    -- CATEGORY 5: Target Frame & Focus Frame
    -------------------------------------------------------
    local cfTF = categoryFrames["targetFocus"].contentFrame
    local targetFrameText = cfTF:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    targetFrameText:SetPoint("TOPLEFT", cfTF, "TOPLEFT", 10, -10)
    targetFrameText:SetText(L["Target_Frame"])
    targetFrameText:SetFont(fontLarge, 16)
    targetFrameText:SetTextColor(1,1,1)

    local targetFrameClickthrough = CreateCheckbox("targetFrameClickthrough", L["Clickthrough"], cfTF, nil, BBF.ClickthroughFrames)
    targetFrameClickthrough:SetPoint("TOPLEFT", targetFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local hideTargetName = CreateCheckbox("hideTargetName", L["Hide_Names"], cfTF, nil, BBF.UpdateNameSettings)
    hideTargetName:SetPoint("TOPLEFT", targetFrameClickthrough, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideTargetLeaderIcon = CreateCheckbox("hideTargetLeaderIcon", L["Hide_Leader_Icon"], cfTF, nil, BBF.HideFrames)
    hideTargetLeaderIcon:SetPoint("TOPLEFT", hideTargetName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local classColorTargetReputationTexture = CreateCheckbox("classColorTargetReputationTexture", L["Reputation_Class_Color"], cfTF)
    classColorTargetReputationTexture:SetPoint("TOPLEFT", hideTargetLeaderIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideTargetReputationColor = CreateCheckbox("hideTargetReputationColor", L["Hide_Reputation_Color"], cfTF, nil, BBF.HideFrames)
    hideTargetReputationColor:SetPoint("TOPLEFT", classColorTargetReputationTexture, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local focusFrameText = cfTF:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    focusFrameText:SetPoint("TOPLEFT", hideTargetReputationColor, "BOTTOMLEFT", 24, -20)
    focusFrameText:SetText(L["Focus_Frame"])
    focusFrameText:SetFont(fontLarge, 16)
    focusFrameText:SetTextColor(1,1,1)

    local focusFrameClickthrough = CreateCheckbox("focusFrameClickthrough", L["Clickthrough"], cfTF, nil, BBF.ClickthroughFrames)
    focusFrameClickthrough:SetPoint("TOPLEFT", focusFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local hideFocusName = CreateCheckbox("hideFocusName", L["Hide_Names"], cfTF, nil, BBF.UpdateNameSettings)
    hideFocusName:SetPoint("TOPLEFT", focusFrameClickthrough, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideFocusLeaderIcon = CreateCheckbox("hideFocusLeaderIcon", L["Hide_Leader_Icon"], cfTF, nil, BBF.HideFrames)
    hideFocusLeaderIcon:SetPoint("TOPLEFT", hideFocusName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local classColorFocusReputationTexture = CreateCheckbox("classColorFocusReputationTexture", L["Reputation_Class_Color"], cfTF)
    classColorFocusReputationTexture:SetPoint("TOPLEFT", hideFocusLeaderIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideFocusReputationColor = CreateCheckbox("hideFocusReputationColor", L["Hide_Reputation_Color"], cfTF, nil, BBF.HideFrames)
    hideFocusReputationColor:SetPoint("TOPLEFT", classColorFocusReputationTexture, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    -------------------------------------------------------
    -- CATEGORY 6: Target of Target & Focus ToT
    -------------------------------------------------------
    local cfToT = categoryFrames["tot"].contentFrame
    local targetToTFrameText = cfToT:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    targetToTFrameText:SetPoint("TOPLEFT", cfToT, "TOPLEFT", 10, -10)
    targetToTFrameText:SetText(L["Target_of_Target"])
    targetToTFrameText:SetFont(fontLarge, 16)
    targetToTFrameText:SetTextColor(1,1,1)

    local hideTargetToT = CreateCheckbox("hideTargetToT", L["Hide_Frame"], cfToT, nil, BBF.HideFrames)
    hideTargetToT:SetPoint("TOPLEFT", targetToTFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local hideTargetToTName = CreateCheckbox("hideTargetToTName", L["Hide_Names"], cfToT)
    hideTargetToTName:SetPoint("LEFT", hideTargetToT.Text, "RIGHT", 0, 0)

    local hideTargetToTDebuffs = CreateCheckbox("hideTargetToTDebuffs", L["Hide_ToT_Debuffs"], cfToT, nil, BBF.HideFrames)
    hideTargetToTDebuffs:SetPoint("TOPLEFT", hideTargetToT, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local targetToTScale = CreateSlider(cfToT, L["Size"], 0.6, 2.5, 0.01, "targetToTScale", nil, 120)
    targetToTScale:SetPoint("TOPLEFT", hideTargetToTDebuffs, "BOTTOMLEFT", 24, -20)

    BBF.targetToTXPos = CreateSlider(cfToT, L["X_Offset"], -100, 100, 1, "targetToTXPos", "X", 120)
    BBF.targetToTXPos:SetPoint("TOP", targetToTScale, "BOTTOM", 0, -15)

    local targetToTYPos = CreateSlider(cfToT, L["Y_Offset"], -100, 100, 1, "targetToTYPos", "Y", 120)
    targetToTYPos:SetPoint("TOP", BBF.targetToTXPos, "BOTTOM", 0, -15)

    local focusToTFrameText = cfToT:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    focusToTFrameText:SetPoint("TOPLEFT", targetToTYPos, "BOTTOMLEFT", -4, -20)
    focusToTFrameText:SetText(L["Focus_ToT"])
    focusToTFrameText:SetFont(fontLarge, 16)
    focusToTFrameText:SetTextColor(1,1,1)

    local hideFocusToT = CreateCheckbox("hideFocusToT", L["Hide_Frame"], cfToT, nil, BBF.HideFrames)
    hideFocusToT:SetPoint("TOPLEFT", focusToTFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local hideFocusToTName = CreateCheckbox("hideFocusToTName", L["Hide_Names"], cfToT)
    hideFocusToTName:SetPoint("LEFT", hideFocusToT.Text, "RIGHT", 0, 0)

    local hideFocusToTDebuffs = CreateCheckbox("hideFocusToTDebuffs", L["Hide_FocusToT_Debuffs"], cfToT, nil, BBF.HideFrames)
    hideFocusToTDebuffs:SetPoint("TOPLEFT", hideFocusToT, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local focusToTScale = CreateSlider(cfToT, L["Size"], 0.6, 2.5, 0.01, "focusToTScale", nil, 120)
    focusToTScale:SetPoint("TOPLEFT", hideFocusToTDebuffs, "BOTTOMLEFT", 24, -20)

    BBF.focusToTXPos = CreateSlider(cfToT, L["X_Offset"], -100, 100, 1, "focusToTXPos", "X", 120)
    BBF.focusToTXPos:SetPoint("TOP", focusToTScale, "BOTTOM", 0, -15)

    local focusToTYPos = CreateSlider(cfToT, L["Y_Offset"], -100, 100, 1, "focusToTYPos", "Y", 120)
    focusToTYPos:SetPoint("TOP", BBF.focusToTXPos, "BOTTOM", 0, -15)

    -------------------------------------------------------
    -- CATEGORY 7: Chat Frame
    -------------------------------------------------------
    local cfChat = categoryFrames["chat"].contentFrame
    local chatFrameText = cfChat:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    chatFrameText:SetPoint("TOPLEFT", cfChat, "TOPLEFT", 10, -10)
    chatFrameText:SetText(L["Chat_Frame"])
    chatFrameText:SetFont(fontLarge, 16)
    chatFrameText:SetTextColor(1,1,1)

    local hideChatButtons = CreateCheckbox("hideChatButtons", L["Hide_Chat_Buttons"], cfChat, nil, BBF.HideFrames)
    hideChatButtons:SetPoint("TOPLEFT", chatFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local hideChatBackground = CreateCheckbox("hideChatBackground", L["Hide_Chat_Background"], cfChat, nil, BBF.HideFrames)
    hideChatBackground:SetPoint("LEFT", hideChatButtons.text, "RIGHT", 0, 0)

    local filterGladiusSpam = CreateCheckbox("filterGladiusSpam", L["Gladius_Spam"], cfChat, nil, BBF.ChatFilterCaller)
    filterGladiusSpam:SetPoint("TOPLEFT", hideChatButtons, "BOTTOMLEFT", 0, -15)

    local filterNpcArenaSpam = CreateCheckbox("filterNpcArenaSpam", L["Arena_Npc_Talk"], cfChat, nil, BBF.ChatFilterCaller)
    filterNpcArenaSpam:SetPoint("LEFT", filterGladiusSpam.text, "RIGHT", 0, 0)

    local filterTalentSpam = CreateCheckbox("filterTalentSpam", L["Talent_Spam"], cfChat, nil, BBF.ChatFilterCaller)
    filterTalentSpam:SetPoint("TOPLEFT", filterGladiusSpam, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local filterEmoteSpam = CreateCheckbox("filterEmoteSpam", L["Emote_Spam"], cfChat, nil, BBF.ChatFilterCaller)
    filterEmoteSpam:SetPoint("TOPLEFT", filterTalentSpam, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local filterSystemMessages = CreateCheckbox("filterSystemMessages", L["System_Messages"], cfChat, nil, BBF.ChatFilterCaller)
    filterSystemMessages:SetPoint("TOPLEFT", filterNpcArenaSpam, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local filterMiscInfo = CreateCheckbox("filterMiscInfo", L["Misc_Info"], cfChat, nil, BBF.ChatFilterCaller)
    filterMiscInfo:SetPoint("TOPLEFT", filterSystemMessages, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    -------------------------------------------------------
    -- CATEGORY 8: Extra Features
    -------------------------------------------------------
    local cfExtra = categoryFrames["extra"].contentFrame
    local extraFeaturesText = cfExtra:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    extraFeaturesText:SetPoint("TOPLEFT", cfExtra, "TOPLEFT", 10, -10)
    extraFeaturesText:SetText(L["Extra_Features"])
    extraFeaturesText:SetFont(fontLarge, 16)
    extraFeaturesText:SetTextColor(1,1,1)

    local combatIndicator = CreateCheckbox("combatIndicator", L["Combat_Indicator"], cfExtra)
    combatIndicator:SetPoint("TOPLEFT", extraFeaturesText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    combatIndicator:HookScript("OnClick", function() BBF.CombatIndicatorCaller() end)

    local healerIndicator = CreateCheckbox("healerIndicator", L["Healer_Indicator"], cfExtra)
    healerIndicator:SetPoint("TOPLEFT", combatIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    healerIndicator:HookScript("OnClick", function(self) BBF.HealerIndicatorCaller() end)

    local absorbIndicator = CreateCheckbox("absorbIndicator", L["Absorb_Indicator"], cfExtra, nil, BBF.AbsorbCaller)
    absorbIndicator:SetPoint("TOPLEFT", healerIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local racialIndicator = CreateCheckbox("racialIndicator", L["Racial_Indicator"], cfExtra, nil, BBF.RacialIndicatorCaller)
    racialIndicator:SetPoint("TOPLEFT", absorbIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local overShields = CreateCheckbox("overShields", L["Overshields"], cfExtra)
    overShields:SetPoint("TOPLEFT", racialIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local overShieldsUnitFrames = CreateCheckbox("overShieldsUnitFrames", L["A"], cfExtra)
    overShieldsUnitFrames:SetPoint("LEFT", overShields.text, "RIGHT", 0, 0)

    local overShieldsCompactUnitFrames = CreateCheckbox("overShieldsCompactUnitFrames", L["B"], cfExtra)
    overShieldsCompactUnitFrames:SetPoint("LEFT", overShieldsUnitFrames.text, "RIGHT", 0, 0)

    local queueTimer = CreateCheckbox("queueTimer", L["Queue_Timer"], cfExtra)
    queueTimer:SetPoint("TOPLEFT", overShields, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local queueTimerAudio = CreateCheckbox("queueTimerAudio", L["SFX"], queueTimer)
    queueTimerAudio:SetPoint("LEFT", queueTimer.text, "RIGHT", 0, 0)

    local queueTimerWarning = CreateCheckbox("queueTimerWarning", L["Queue_Timer_Warning"], queueTimer)
    queueTimerWarning:SetPoint("LEFT", queueTimerAudio.text, "RIGHT", 0, 0)

    local enableBigDebuffs = CreateCheckbox("enableBigDebuffs", L["Enable_Big_Debuffs"], cfExtra, nil, BBF.EnableBigDebuffs)
    enableBigDebuffs:SetPoint("TOPLEFT", queueTimer, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    BetterBlizzFrames.kickPopupEnabled = CreateCheckbox("kickPopupEnabled", L["Kick_Popup"], cfExtra, nil, function()
        BBF.ToggleKickPopup()
    end)
    BetterBlizzFrames.kickPopupEnabled:SetPoint("TOPLEFT", enableBigDebuffs, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    -------------------------------------------------------
    -- CATEGORY 9: Arena Names
    -------------------------------------------------------
    local cfArena = categoryFrames["arenaNames"].contentFrame
    local arenaNamesText = cfArena:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    arenaNamesText:SetPoint("TOPLEFT", cfArena, "TOPLEFT", 10, -10)
    arenaNamesText:SetText(L["Arena_Names"])
    arenaNamesText:SetFont(fontLarge, 16)
    arenaNamesText:SetTextColor(1,1,1)

    local targetAndFocusArenaNames = CreateCheckbox("targetAndFocusArenaNames", L["Target_And_Focus_Arena_Names"], cfArena)
    targetAndFocusArenaNames:SetPoint("TOPLEFT", arenaNamesText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local partyArenaNames = CreateCheckbox("partyArenaNames", L["Party"], cfArena)
    partyArenaNames:SetPoint("LEFT", targetAndFocusArenaNames.text, "RIGHT", 0, 0)

    local showSpecName = CreateCheckbox("showSpecName", L["Show_Spec_Name"], cfArena)
    showSpecName:SetPoint("TOPLEFT", targetAndFocusArenaNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local shortArenaSpecName = CreateCheckbox("shortArenaSpecName", L["Short"], cfArena)
    shortArenaSpecName:SetPoint("LEFT", showSpecName.Text, "RIGHT", 0, 0)

    local showArenaID = CreateCheckbox("showArenaID", L["Show_Arena_ID"], cfArena)
    showArenaID:SetPoint("TOPLEFT", showSpecName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    -------------------------------------------------------
    -- CATEGORY 10: Pet Frame
    -------------------------------------------------------
    local cfPet = categoryFrames["pet"].contentFrame
    local petFrameText = cfPet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    petFrameText:SetPoint("TOPLEFT", cfPet, "TOPLEFT", 10, -10)
    petFrameText:SetText(L["Pet_Frame"])
    petFrameText:SetFont(fontLarge, 16)
    petFrameText:SetTextColor(1,1,1)

    local hidePetFrame = CreateCheckbox("hidePetFrame", L["Hide_Pet_Frame"], cfPet, nil, BBF.HideFrames)
    hidePetFrame:SetPoint("TOPLEFT", petFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)

    local petCastbar = CreateCheckbox("petCastbar", L["Pet_Castbar"], cfPet, nil, BBF.UpdatePetCastbar)
    petCastbar:SetPoint("TOPLEFT", hidePetFrame, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePetName = CreateCheckbox("hidePetName", L["Hide_Pet_Name"], cfPet)
    hidePetName:SetPoint("TOPLEFT", petCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    hidePetName:HookScript("OnClick", function() BBF.AllNameChanges() end)

    local hidePetAuraTooltip = CreateCheckbox("hidePetAuraTooltip", L["Hide_Pet_Aura_Tooltip"], cfPet, nil, BBF.HideFrames)
    hidePetAuraTooltip:SetPoint("LEFT", hidePetName.text, "RIGHT", 0, 0)

    local colorPetAfterOwner = CreateCheckbox("colorPetAfterOwner", L["Color_Pet_After_Player_Class"], cfPet)
    colorPetAfterOwner:SetPoint("TOPLEFT", hidePetName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    colorPetAfterOwner:HookScript("OnClick", function() BBF.UpdateFrames() end)

    local hidePetText = CreateCheckbox("hidePetText", L["Hide_Pet_Statusbar_Text"], cfPet, nil, BBF.HideFrames)
    hidePetText:SetPoint("TOPLEFT", colorPetAfterOwner, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePetHitIndicator = CreateCheckbox("hidePetHitIndicator", L["Hide_Pet_Hit_Indicator"], cfPet, nil, BBF.HideFrames)
    hidePetHitIndicator:SetPoint("TOPLEFT", hidePetText, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    -------------------------------------------------------
    -- DEFAULT CATEGORY SELECTION
    -------------------------------------------------------
    SelectCategory("general")

    -------------------------------------------------------
    -- RELOAD & RESET BUTTONS
    -------------------------------------------------------
    local reloadUiButton = CreateFrame("Button", nil, BetterBlizzFrames, "UIPanelButtonTemplate")
    reloadUiButton:SetText(L["Reload_UI"])
    reloadUiButton:SetWidth(96)
    reloadUiButton:SetPoint("RIGHT", SettingsPanel.CloseButton, "LEFT", -3, 0)
    reloadUiButton:SetScript("OnClick", function()
        BetterBlizzFramesDB.reopenOptions = true
        ReloadUI()
    end)
end
