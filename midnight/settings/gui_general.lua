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
    BetterBlizzFrames:HookScript("OnShow",function() midnightBeta:Show() end)
    BetterBlizzFrames:HookScript("OnHide",function() midnightBeta:Hide() end)

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
    -- SIDEBAR NAVIGATION & CARD CONTAINER DESIGN (IMAGE 1)
    -------------------------------------------------------
    local sidebar = CreateFrame("Frame", nil, BetterBlizzFrames)
    sidebar:SetSize(175, 545)
    sidebar:SetPoint("TOPLEFT", BetterBlizzFrames, "TOPLEFT", 15, -45)

    local contentParent = CreateFrame("Frame", nil, BetterBlizzFrames)
    contentParent:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 15, 0)
    contentParent:SetPoint("BOTTOMRIGHT", BetterBlizzFrames, "BOTTOMRIGHT", -15, 15)

    local categoryList = {
        { id = "general",     label = L["General"] or "General",                 icon = "Interface\\Icons\\INV_Gizmo_02" },
        { id = "player",      label = L["Player_Frame"] or "Player Frame",       icon = "Interface\\Icons\\Achievement_GuildPerk_MobileBanking" },
        { id = "party",       label = L["Party_Frame"] or "Party Frame",         icon = "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend" },
        { id = "all",         label = L["All_Frames"] or "All Frames",           icon = "Interface\\Icons\\Ability_Warrior_ShieldWall" },
        { id = "target",      label = L["Target_Frame"] or "Target Frame",       icon = "Interface\\Icons\\Ability_Tracking" },
        { id = "tot",         label = L["Target_of_Target"] or "Target of Target",icon = "Interface\\Icons\\Spell_Holy_MindVision" },
        { id = "chat",        label = L["Chat_Frame"] or "Chat Frame",           icon = "Interface\\Icons\\UI_Chat" },
        { id = "extra",       label = L["Extra_Features"] or "Extra Features",   icon = "Interface\\Icons\\Spell_Holy_PowerInfusion" },
        { id = "arenaNames",  label = L["Arena_Names"] or "Arena Names",         icon = "Interface\\Icons\\Achievement_Arena_3v3_7" },
        { id = "focus",       label = L["Focus_Frame"] or "Focus Frame",         icon = "Interface\\Icons\\Spell_Holy_MindVision" },
        { id = "focusToT",    label = L["Focus_ToT"] or "Focus ToT",             icon = "Interface\\Icons\\Spell_Holy_MindVision" },
        { id = "pet",         label = L["Pet_Frame"] or "Pet Frame",             icon = "Interface\\Icons\\Ability_Hunter_Pet_Raptor" },
    }

    local categoryFrames = {}
    local categoryButtons = {}

    local function SelectCategory(catId)
        for id, sf in pairs(categoryFrames) do sf:Hide() end
        for id, btn in pairs(categoryButtons) do
            btn:SetBackdropBorderColor(0.25, 0.25, 0.28, 0.8)
            btn:SetBackdropColor(0.1, 0.1, 0.12, 0.85)
            btn.Text:SetTextColor(0.8, 0.8, 0.8)
        end
        if categoryFrames[catId] then categoryFrames[catId]:Show() end
        if categoryButtons[catId] then
            categoryButtons[catId]:SetBackdropBorderColor(0.9, 0.75, 0.1, 1)
            categoryButtons[catId]:SetBackdropColor(0.25, 0.2, 0.05, 0.9)
            categoryButtons[catId].Text:SetTextColor(1, 0.85, 0.1)
        end
    end

    for i, cat in ipairs(categoryList) do
        local sf = CreateFrame("ScrollFrame", "BBF_MidnightCat_" .. cat.id, contentParent, "UIPanelScrollFrameTemplate")
        sf:SetAllPoints(contentParent)
        sf:Hide()

        local cf = CreateFrame("Frame", nil, sf)
        cf:SetSize(470, 1500)
        sf:SetScrollChild(cf)

        categoryFrames[cat.id] = sf
        sf.contentFrame = cf

        local btn = CreateFrame("Button", nil, sidebar, "BackdropTemplate")
        btn:SetSize(170, 34)
        btn:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 0, -((i - 1) * 38))
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        btn:SetBackdropColor(0.1, 0.1, 0.12, 0.85)
        btn:SetBackdropBorderColor(0.25, 0.25, 0.28, 0.8)

        local iconTex = btn:CreateTexture(nil, "ARTWORK")
        iconTex:SetSize(20, 20)
        iconTex:SetPoint("LEFT", 8, 0)
        iconTex:SetTexture(cat.icon)

        btn.Text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        btn.Text:SetPoint("LEFT", iconTex, "RIGHT", 8, 0)
        btn.Text:SetText(cat.label)
        btn.Text:SetFont(fontMedium, 12)
        btn.Text:SetTextColor(0.8, 0.8, 0.8)

        btn:SetScript("OnClick", function() SelectCategory(cat.id) end)
        btn:SetScript("OnEnter", function(self)
            if categoryButtons[cat.id] and self ~= categoryButtons[cat.id] then
                self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
            end
        end)
        btn:SetScript("OnLeave", function(self)
            if categoryButtons[cat.id] and self ~= categoryButtons[cat.id] then
                self:SetBackdropBorderColor(0.25, 0.25, 0.28, 0.8)
            end
        end)

        categoryButtons[cat.id] = btn
    end

    -------------------------------------------------------
    -- CARD UI CREATION HELPERS (MATCHING IMAGE 1)
    -------------------------------------------------------
    local function CreateOptionCard(parentFrame, titleText, yOffset, cardWidth)
        cardWidth = cardWidth or 460
        local header = parentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        header:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 5, yOffset)
        header:SetText(titleText)
        header:SetTextColor(1, 0.82, 0)

        local card = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")
        card:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -8)
        card:SetWidth(cardWidth)
        card:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        card:SetBackdropColor(0.06, 0.06, 0.08, 0.85)
        card:SetBackdropBorderColor(0.2, 0.2, 0.25, 0.8)

        card.header = header
        card.currentY = -10
        card.cardWidth = cardWidth
        return card
    end

    local function AddCardCheckbox(card, dbKey, titleStr, descStr, callback)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 12, card.currentY)
        row:SetSize(card.cardWidth - 24, 42)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -2)
        title:SetText(titleStr)
        title:SetFont(fontMedium, 13)

        if descStr and descStr ~= "" then
            local desc = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
            desc:SetText(descStr)
            desc:SetTextColor(0.65, 0.65, 0.65)
        end

        local cb = CreateCheckbox(dbKey, "", row, nil, callback)
        cb:SetPoint("RIGHT", row, "RIGHT", -5, 0)

        card.currentY = card.currentY - 46
        card:SetHeight(-card.currentY + 8)
        return cb
    end

    local function AddCardSlider(card, dbKey, titleStr, descStr, minVal, maxVal, stepVal, callback)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 12, card.currentY)
        row:SetSize(card.cardWidth - 24, 48)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -2)
        title:SetText(titleStr)
        title:SetFont(fontMedium, 13)

        if descStr and descStr ~= "" then
            local desc = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
            desc:SetText(descStr)
            desc:SetTextColor(0.65, 0.65, 0.65)
        end

        local slider = CreateSlider(row, "", minVal, maxVal, stepVal, dbKey, nil, 120)
        slider:SetPoint("RIGHT", row, "RIGHT", -5, -4)

        card.currentY = card.currentY - 52
        card:SetHeight(-card.currentY + 8)
        return slider
    end

    -------------------------------------------------------
    -- CATEGORY 1: General
    -------------------------------------------------------
    local cfGen = categoryFrames["general"].contentFrame
    local cardGen = CreateOptionCard(cfGen, L["General_Settings"] or "General Settings", -10)
    
    AddCardCheckbox(cardGen, "hideArenaFrames", L["Hide_Arena_Frames"] or "Hide Arena Frames", L["Tooltip_Hide_Arena_Frames"] or "Hides default Blizzard Arena Frames.", BBF.HideArenaFrames)
    AddCardCheckbox(cardGen, "hideBossFrames", L["Hide_Boss_Frames"] or "Hide Boss Frames", L["Tooltip_Hide_Boss_Frames"] or "Hides default Boss Frames in Raids/Dungeons.", BBF.HideArenaFrames)
    AddCardCheckbox(cardGen, "playerFrameOCD", L["OCD_Tweaks"] or "OCD Tweaks", L["Tooltip_OCD_Tweaks_Retail"] or "Fixes micro pixel alignment issues on frames.", BBF.FixStupidBlizzPTRShit)
    AddCardCheckbox(cardGen, "removeRealmNames", L["Hide_Realm"] or "Remove Realm Names", L["Tooltip_Hide_Realm_Indicator_Desc"] or "Hides realm names next to character names.")
    AddCardCheckbox(cardGen, "hideLossOfControlFrameBg", L["Hide_CC_Background"] or "Hide CC Background", L["Tooltip_Hide_CC_Background"] or "Hides loss of control frame background.", BBF.HideFrames)
    AddCardCheckbox(cardGen, "hideLossOfControlFrameLines", L["Hide_CC_Red_Lines"] or "Hide CC Red-lines", L["Tooltip_Hide_CC_Red_Lines"] or "Hides loss of control frame red lines.", BBF.HideFrames)
    AddCardSlider(cardGen, "lossOfControlScale", L["CC_Scale"] or "Loss of Control Scale", L["Tooltip_LossOfControlScale_Desc"] or "Adjust scale of loss of control frame.", 0.4, 1.4, 0.01)

    local cardDark = CreateOptionCard(cfGen, L["Dark_Mode"] or "Dark Mode Options", -cardGen:GetHeight() - 35)
    AddCardCheckbox(cardDark, "darkModeUi", L["Dark_Mode"] or "Dark Mode UI", L["Tooltip_Dark_Mode"] or "Applies sleek dark textures to frames.", function() BBF.DarkmodeFrames(true) end)
    AddCardCheckbox(cardDark, "darkModeCastbars", L["Castbars"], L["Tooltip_Dark_Mode_Castbars"], function() BBF.DarkmodeFrames(true) end)
    AddCardCheckbox(cardDark, "darkModeActionBars", L["ActionBars"], L["Tooltip_Dark_Mode_ActionBars"], function() BBF.DarkmodeFrames(true) end)
    AddCardCheckbox(cardDark, "darkModeUiAura", L["Auras"], L["Tooltip_Dark_Mode_Auras_Desc"], function() BBF.DarkmodeFrames(true) end)
    AddCardCheckbox(cardDark, "darkModeMinimap", L["Minimap"], L["Dark_Mode_Minimap"], function() BBF.DarkmodeFrames(true) end)
    AddCardCheckbox(cardDark, "darkModeNameplateResource", L["Nameplate_Resource"], L["Dark_Mode_Nameplate_Resource"], function() BBF.DarkmodeFrames(true) end)
    AddCardCheckbox(cardDark, "darkModeGameTooltip", L["Tooltip"], L["Tooltip_Dark_Mode_GameTooltip_Desc"], function() BBF.DarkmodeFrames(true) end)
    AddCardCheckbox(cardDark, "darkModeObjectiveFrame", L["Objectives"], L["Tooltip_Dark_Mode_Objectives_Desc"], function() BBF.DarkmodeFrames(true) end)
    AddCardCheckbox(cardDark, "darkModeVigor", L["Vigor"], L["Tooltip_Dark_Mode_Vigor_Desc"], function() BBF.DarkmodeFrames(true) end)
    AddCardSlider(cardDark, "darkModeColor", L["Darkness"] or "Darkness Level", L["Tooltip_Dark_Mode_Value_Desc"] or "Adjust the darkness scale value.", 0, 1, 0.01)

    -------------------------------------------------------
    -- CATEGORY 2: Player Frame
    -------------------------------------------------------
    local cfPlayer = categoryFrames["player"].contentFrame
    local cardPlayer = CreateOptionCard(cfPlayer, L["Player_Frame"] or "Player Frame", -10)
    AddCardCheckbox(cardPlayer, "playerFrameHidden", L["Hide_Frame"], L["Tooltip_Hide_Player_Frame"], function() BBF.HidePlayerFrame() end)
    AddCardCheckbox(cardPlayer, "playerFrameClickthrough", L["Clickthrough"], L["Tooltip_Clickthrough"])
    AddCardCheckbox(cardPlayer, "playerReputationColor", L["Add_Reputation_Color"], L["Tooltip_Add_Reputation_Color"], BBF.PlayerReputationColor)
    AddCardCheckbox(cardPlayer, "playerReputationClassColor", L["Class_Color_Combo"], L["Tooltip_Class_Color_Reputation"], BBF.PlayerReputationColor)
    AddCardCheckbox(cardPlayer, "hidePlayerName", L["Hide_Names"], L["Tooltip_Hide_Player_Name"], function() BBF.SetCenteredNamesCaller() end)
    AddCardCheckbox(cardPlayer, "symmetricPlayerFrame", L["Mirror_TargetFrame"], L["Tooltip_Mirror_TargetFrame_Desc"])
    AddCardCheckbox(cardPlayer, "hidePlayerPower", L["Hide_Resource_Power"], L["Tooltip_Hide_Resource_Power_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hideResourceTooltip", L["Hide_Resource_Tooltip"], L["Tooltip_Hide_Resource_Tooltip_Desc"], BBF.HideClassResourceTooltip)
    AddCardCheckbox(cardPlayer, "hideManaFeedback", L["Hide_Mana_Feedback"], L["Tooltip_Hide_Mana_Feedback_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hidePlayerRestAnimation", L["Hide_Zzz_Rest_Animation"], L["Tooltip_Hide_Zzz_Rest"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hidePlayerCornerIcon", L["Hide_Corner_Icon"], L["Tooltip_Hide_Corner_Icon"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hidePlayerHealthLossAnim", L["Hide_Health_Loss_FX"], L["Tooltip_Hide_Health_Loss_FX_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hidePlayerRestGlow", L["Hide_Rest_Glow"], L["Tooltip_Hide_Rest_Glow"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hideFullPower", L["Hide_Full_Mana_FX"], L["Tooltip_Hide_Full_Mana_FX_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hideCombatIcon", L["Hide_Combat_Icon"], L["Tooltip_Hide_Combat_Icon"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hideHitIndicator", L["Hide_Hit_Indicator"], L["Tooltip_Hide_Hit_Indicator_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hideGroupIndicator", L["Hide_Group_Indicator"], L["Tooltip_Hide_Group_Indicator"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hideTotemFrame", L["Hide_Totem_Frame"], L["Tooltip_Hide_Totem_Frame"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hidePlayerLeaderIcon", L["Hide_Leader_Icon"], L["Tooltip_Hide_Leader_Icon"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hidePlayerGuideIcon", L["Hide_Guide_Icon"], L["Tooltip_Hide_Guide_Icon"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hidePlayerRoleIcon", L["Hide_Role_Icon"], L["Tooltip_Hide_Role_Icon"], BBF.HideFrames)
    AddCardCheckbox(cardPlayer, "hidePvpTimerText", L["Hide_PvP_Timer"], L["Tooltip_Hide_PvP_Timer_Desc"], BBF.HideFrames)

    -------------------------------------------------------
    -- CATEGORY 3: Party Frame
    -------------------------------------------------------
    local cfParty = categoryFrames["party"].contentFrame
    local cardParty = CreateOptionCard(cfParty, L["Party_Frame"] or "Party Frame", -10)
    AddCardCheckbox(cardParty, "showPartyCastbar", L["Party_Castbars"], L["Tooltip_Show_Party_Castbar"], BBF.UpdateCastbars)
    AddCardCheckbox(cardParty, "hidePartyRoles", L["Hide_Role_Icons"], L["Tooltip_Hide_Party_Role_Icons"], function() BBF.PartyNameChange() end)
    AddCardCheckbox(cardParty, "hidePartyFramesInArena", L["Hide_Party_in_Arena"], L["Tooltip_Hide_Party_in_Arena_GEX"], BBF.HidePartyInArena)
    AddCardCheckbox(cardParty, "raidFramePixelBorder", L["Pixel_Border"], L["Tooltip_Pixel_Border_RaidFrames_Desc"])
    AddCardCheckbox(cardParty, "hidePartyNames", L["Hide_Names"], "", function() BBF.AllNameChanges() end)
    AddCardCheckbox(cardParty, "hidePartyAggroHighlight", L["Hide_Aggro_Highlight"], L["Tooltip_Hide_Party_Aggro_Highlight"], BBF.HideFrames)
    AddCardCheckbox(cardParty, "hidePartyFrameTitle", L["Hide_CompactPartyFrame_Title"], L["Tooltip_Hide_CompactPartyFrame_Title"], BBF.HideFrames)
    AddCardCheckbox(cardParty, "hideCompactUnitFrameBackground", L["Hide_Bg"], L["Tooltip_Hide_Compact_Frame_Backgrounds"], BBF.HideCompactUnitFrameBackgrounds)
    AddCardCheckbox(cardParty, "hideRaidFrameManager", L["Hide_RaidFrameManager"], L["Tooltip_Hide_RaidFrameManager"], BBF.HideFrames)
    AddCardCheckbox(cardParty, "classColorPartyNames", L["Color_Names"], L["Tooltip_Class_Color_Names_Party_Raid"], BBF.AllNameChanges)
    AddCardCheckbox(cardParty, "hideRaidFrameContainerBorder", L["Hide_Container_Border"], L["Tooltip_Hide_Container_Border_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardParty, "hidePartyDispelOverlay", L["Hide_Dispel_Overlay"], L["Tooltip_Hide_Dispel_Overlay"], BBF.HideFrames)
    AddCardCheckbox(cardParty, "hidePartyRangeIcon", L["Hide_Range_Icon"], L["Tooltip_Hide_Range_Icon"], BBF.HideFrames)
    AddCardCheckbox(cardParty, "newRaidFrameRoleIcons", L["New_Role_Icons"], L["Tooltip_New_Role_Icons_Desc"])
    AddCardCheckbox(cardParty, "betterTargetHighlight", L["Better_Target_Highlight"], L["Tooltip_Better_Target_Highlight"])
    AddCardSlider(cardParty, "partyFrameScale", L["Party_Frame_Scale"], "", 0.7, 1.7, 0.01)
    AddCardSlider(cardParty, "partyFrameRangeAlpha", L["Party_Frame_Range_Alpha"], L["Tooltip_Party_Frame_Range_Alpha"], 0, 1, 0.01)

    -------------------------------------------------------
    -- CATEGORY 4: All Frames
    -------------------------------------------------------
    local cfAll = categoryFrames["all"].contentFrame
    local cardAll = CreateOptionCard(cfAll, L["All_Frames"] or "All Frames", -10)
    AddCardCheckbox(cardAll, "classicFrames", L["Classic_Frames"], L["Tooltip_Classic_Frames_Desc"])
    AddCardCheckbox(cardAll, "noPortraitModes", L["No_Portrait"], L["Tooltip_No_Portrait_Desc"])
    AddCardCheckbox(cardAll, "noPortraitPixelBorder", L["NP_PixelBorder"], L["Tooltip_No_Portrait_PixelBorder_Desc"])
    AddCardCheckbox(cardAll, "classColorFrames", L["Class_Color_Health"], L["Tooltip_Class_Color_Frames_Desc"])
    AddCardCheckbox(cardAll, "customHealthbarColors", L["Custom_Color_Health_Mana"], L["Tooltip_Custom_Colors_Desc"])
    AddCardCheckbox(cardAll, "classColorTargetNames", L["Class_Color_Names"], L["Tooltip_Class_Color_Names_Desc"])
    AddCardCheckbox(cardAll, "classColorLevelText", L["Level"], L["Tooltip_Level"])
    AddCardCheckbox(cardAll, "classColorFrameTexture", L["Class_Color_FrameTexture"], L["Tooltip_Class_Color_FrameTexture_Desc"])
    AddCardCheckbox(cardAll, "centerNames", L["Center_Name"], L["Center_Names"], BBF.SetCenteredNamesCaller)
    AddCardCheckbox(cardAll, "removeRealmNames", L["Hide_Realm"], L["Tooltip_Hide_Realm_Indicator_Desc"])
    AddCardCheckbox(cardAll, "formatStatusBarText", L["Format_Numbers"], L["Tooltip_Format_Numbers_Desc"], BBF.HookStatusBarText)
    AddCardCheckbox(cardAll, "singleValueStatusBarText", L["No_Max"], L["Tooltip_No_Max_Value_Desc"])
    AddCardCheckbox(cardAll, "hidePrestigeBadge", L["Tooltip_Hide_PvP_Icon"], L["Tooltip_Hide_Prestige_Badge_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardAll, "hideCombatGlow", L["Hide_Combat_Glow"], L["Tooltip_Hide_Combat_Glow"], BBF.HideFrames)
    AddCardCheckbox(cardAll, "hideUnitFrameShadow", L["Hide_Shadow"], L["Tooltip_Hide_Shadow_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardAll, "hideLevelText", L["Hide_Max_Level_Text"], L["Tooltip_Hide_Max_Level_Text"], BBF.HideFrames)
    AddCardCheckbox(cardAll, "hideRareDragonTexture", L["Hide_Dragon"], L["Tooltip_Hide_Dragon"], BBF.HideFrames)
    AddCardCheckbox(cardAll, "hideThreatOnFrame", L["Hide_Threat"], L["Tooltip_Hide_Threat_Meter_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardAll, "classPortraitsUseSpecIcons", L["Use_Spec_Icons"], L["Tooltip_Use_Spec_Icons"], BBF.SpecPortraits)

    -------------------------------------------------------
    -- CATEGORY 5: Target Frame
    -------------------------------------------------------
    local cfTarget = categoryFrames["target"].contentFrame
    local cardTarget = CreateOptionCard(cfTarget, L["Target_Frame"] or "Target Frame", -10)
    AddCardCheckbox(cardTarget, "targetFrameClickthrough", L["Clickthrough"], L["Tooltip_Target_Clickthrough"], BBF.ClickthroughFrames)
    AddCardCheckbox(cardTarget, "hideTargetName", L["Hide_Names"], L["Tooltip_Hide_Target_Name"], BBF.UpdateNameSettings)
    AddCardCheckbox(cardTarget, "hideTargetLeaderIcon", L["Hide_Leader_Icon"], L["Tooltip_Hide_Target_Leader_Icon"], BBF.HideFrames)
    AddCardCheckbox(cardTarget, "classColorTargetReputationTexture", L["Reputation_Class_Color"], L["Tooltip_Target_Reputation_Class_Color"])
    AddCardCheckbox(cardTarget, "hideTargetReputationColor", L["Hide_Reputation_Color"], L["Tooltip_Hide_Target_Reputation_Color"], BBF.HideFrames)

    -------------------------------------------------------
    -- CATEGORY 6: Target of Target
    -------------------------------------------------------
    local cfToT = categoryFrames["tot"].contentFrame
    local cardToT = CreateOptionCard(cfToT, L["Target_of_Target"] or "Target of Target", -10)
    AddCardCheckbox(cardToT, "hideTargetToT", L["Hide_Frame"], L["Tooltip_Hide_ToT_Frame"], BBF.HideFrames)
    AddCardCheckbox(cardToT, "hideTargetToTName", L["Hide_Names"], L["Tooltip_Hide_ToT_Name"])
    AddCardCheckbox(cardToT, "hideTargetToTDebuffs", L["Hide_ToT_Debuffs"], L["Tooltip_Hide_ToT_Debuffs"], BBF.HideFrames)
    AddCardSlider(cardToT, "targetToTScale", L["Size"], L["Tooltip_ToT_Size"], 0.6, 2.5, 0.01)
    AddCardSlider(cardToT, "targetToTXPos", L["X_Offset"], L["Tooltip_ToT_X_Offset"], -100, 100, 1)
    AddCardSlider(cardToT, "targetToTYPos", L["Y_Offset"], L["Tooltip_ToT_Y_Offset"], -100, 100, 1)

    -------------------------------------------------------
    -- CATEGORY 7: Chat Frame
    -------------------------------------------------------
    local cfChat = categoryFrames["chat"].contentFrame
    local cardChat = CreateOptionCard(cfChat, L["Chat_Frame"] or "Chat Frame", -10)
    AddCardCheckbox(cardChat, "hideChatButtons", L["Hide_Chat_Buttons"], L["Tooltip_Hide_Chat_Buttons"], BBF.HideFrames)
    AddCardCheckbox(cardChat, "hideChatBackground", L["Hide_Chat_Background"], L["Tooltip_Hide_Chat_Background"], BBF.HideFrames)
    AddCardCheckbox(cardChat, "filterGladiusSpam", L["Gladius_Spam"], L["Tooltip_Filter_Gladius_Spam"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterNpcArenaSpam", L["Arena_Npc_Talk"], L["Tooltip_Filter_Arena_Npc_Talk"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterTalentSpam", L["Talent_Spam"], L["Tooltip_Filter_Talent_Spam"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterEmoteSpam", L["Emote_Spam"], L["Tooltip_Filter_Emote_Spam"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterSystemMessages", L["System_Messages"], L["Tooltip_Filter_System_Messages"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterMiscInfo", L["Misc_Info"], L["Tooltip_Filter_Misc_Info"], BBF.ChatFilterCaller)

    -------------------------------------------------------
    -- CATEGORY 8: Extra Features
    -------------------------------------------------------
    local cfExtra = categoryFrames["extra"].contentFrame
    local cardExtra = CreateOptionCard(cfExtra, L["Extra_Features"] or "Extra Features", -10)
    AddCardCheckbox(cardExtra, "combatIndicator", L["Combat_Indicator"], L["Tooltip_Combat_Indicator_Desc"], function() BBF.CombatIndicatorCaller() end)
    AddCardCheckbox(cardExtra, "healerIndicator", L["Healer_Indicator"], L["Tooltip_Healer_Indicator_Desc"], function() BBF.HealerIndicatorCaller() end)
    AddCardCheckbox(cardExtra, "absorbIndicator", L["Absorb_Indicator"], L["Tooltip_Absorb_Indicator_Desc"], BBF.AbsorbCaller)
    AddCardCheckbox(cardExtra, "racialIndicator", L["Racial_Indicator"], L["Tooltip_Racial_Indicator_Desc"], BBF.RacialIndicatorCaller)
    AddCardCheckbox(cardExtra, "overShields", L["Overshields"], L["Tooltip_Overshields_Desc"])
    AddCardCheckbox(cardExtra, "queueTimer", L["Queue_Timer"], L["Tooltip_Queue_Timer_Desc"])
    AddCardCheckbox(cardExtra, "queueTimerAudio", L["SFX"], L["Tooltip_Sound_Effect_Desc"])
    AddCardCheckbox(cardExtra, "queueTimerWarning", L["Queue_Timer_Warning"], L["Tooltip_Sound_Alert_Desc"])
    AddCardCheckbox(cardExtra, "enableBigDebuffs", L["Enable_Big_Debuffs"], L["Tooltip_Big_Debuffs_Desc"], BBF.EnableBigDebuffs)
    AddCardCheckbox(cardExtra, "kickPopupEnabled", L["Kick_Popup"], L["Tooltip_Kick_Popup_Desc"], function() BBF.ToggleKickPopup() end)

    -------------------------------------------------------
    -- CATEGORY 9: Arena Names
    -------------------------------------------------------
    local cfArena = categoryFrames["arenaNames"].contentFrame
    local cardArena = CreateOptionCard(cfArena, L["Arena_Names"] or "Arena Names", -10)
    AddCardCheckbox(cardArena, "targetAndFocusArenaNames", L["Target_And_Focus_Arena_Names"], L["Tooltip_Arena_Names_Target_Focus_Desc"])
    AddCardCheckbox(cardArena, "partyArenaNames", L["Party"], L["Tooltip_Arena_Names_Desc"])
    AddCardCheckbox(cardArena, "showSpecName", L["Show_Spec_Name"], L["Tooltip_Show_Spec_Name_Desc"])
    AddCardCheckbox(cardArena, "shortArenaSpecName", L["Short"], L["Tooltip_Short_Arena_Spec_Name"])
    AddCardCheckbox(cardArena, "showArenaID", L["Show_Arena_ID"], L["Tooltip_Show_Arena_ID"])

    -------------------------------------------------------
    -- CATEGORY 10: Focus Frame
    -------------------------------------------------------
    local cfFocus = categoryFrames["focus"].contentFrame
    local cardFocus = CreateOptionCard(cfFocus, L["Focus_Frame"] or "Focus Frame", -10)
    AddCardCheckbox(cardFocus, "focusFrameClickthrough", L["Clickthrough"], L["Tooltip_Focus_Clickthrough"], BBF.ClickthroughFrames)
    AddCardCheckbox(cardFocus, "hideFocusName", L["Hide_Names"], L["Tooltip_Hide_Focus_Name"], BBF.UpdateNameSettings)
    AddCardCheckbox(cardFocus, "hideFocusLeaderIcon", L["Hide_Leader_Icon"], L["Tooltip_Hide_Focus_Leader_Icon"], BBF.HideFrames)
    AddCardCheckbox(cardFocus, "classColorFocusReputationTexture", L["Reputation_Class_Color"], L["Tooltip_Focus_Reputation_Class_Color"])
    AddCardCheckbox(cardFocus, "hideFocusReputationColor", L["Hide_Reputation_Color"], L["Tooltip_Hide_Focus_Reputation_Color"], BBF.HideFrames)

    -------------------------------------------------------
    -- CATEGORY 11: Focus ToT
    -------------------------------------------------------
    local cfFToT = categoryFrames["focusToT"].contentFrame
    local cardFToT = CreateOptionCard(cfFToT, L["Focus_ToT"] or "Focus ToT", -10)
    AddCardCheckbox(cardFToT, "hideFocusToT", L["Hide_Frame"], L["Tooltip_Hide_FocusToT_Frame"], BBF.HideFrames)
    AddCardCheckbox(cardFToT, "hideFocusToTName", L["Hide_Names"], L["Tooltip_Hide_FocusToT_Name"])
    AddCardCheckbox(cardFToT, "hideFocusToTDebuffs", L["Hide_FocusToT_Debuffs"], L["Tooltip_Hide_ToT_Debuffs"], BBF.HideFrames)
    AddCardSlider(cardFToT, "focusToTScale", L["Size"], L["Tooltip_FocusToT_Size"], 0.6, 2.5, 0.01)
    AddCardSlider(cardFToT, "focusToTXPos", L["X_Offset"], L["Tooltip_FocusToT_X_Offset"], -100, 100, 1)
    AddCardSlider(cardFToT, "focusToTYPos", L["Y_Offset"], L["Tooltip_FocusToT_Y_Offset"], -100, 100, 1)

    -------------------------------------------------------
    -- CATEGORY 12: Pet Frame
    -------------------------------------------------------
    local cfPet = categoryFrames["pet"].contentFrame
    local cardPet = CreateOptionCard(cfPet, L["Pet_Frame"] or "Pet Frame", -10)
    AddCardCheckbox(cardPet, "hidePetFrame", L["Hide_Pet_Frame"], L["Tooltip_Hide_Pet_Frame_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPet, "petCastbar", L["Pet_Castbar"], L["Tooltip_Pet_Castbar"], BBF.UpdatePetCastbar)
    AddCardCheckbox(cardPet, "hidePetName", L["Hide_Pet_Name"], L["Tooltip_Hide_Pet_Name_Desc"], function() BBF.AllNameChanges() end)
    AddCardCheckbox(cardPet, "hidePetAuraTooltip", L["Hide_Pet_Aura_Tooltip"], L["Tooltip_Hide_Pet_Aura_Tooltip_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPet, "colorPetAfterOwner", L["Color_Pet_After_Player_Class"], "", function() BBF.UpdateFrames() end)
    AddCardCheckbox(cardPet, "hidePetText", L["Hide_Pet_Statusbar_Text"], L["Tooltip_Hide_Pet_Statusbar_Text_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPet, "hidePetHitIndicator", L["Hide_Pet_Hit_Indicator"], L["Tooltip_Hide_Pet_Hit_Indicator_Desc"], BBF.HideFrames)

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
