if BBF.isMidnight then return end
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

function guiFrameAuras()
    ----------------------
    -- Frame Auras
    ----------------------
    local guiFrameAuras = CreateFrame("Frame")
    guiFrameAuras.name = L["Module_Name_Auras"]
    guiFrameAuras.parent = BetterBlizzFrames.name
    --InterfaceOptions_AddCategory(guiFrameAuras)
    local aurasSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiFrameAuras, guiFrameAuras.name, guiFrameAuras.name)
    BBF.aurasSubCategory = guiFrameAuras.name
    CreateTitle(guiFrameAuras)

    local bgImg = guiFrameAuras:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", guiFrameAuras, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local scrollFrame = CreateFrame("ScrollFrame", nil, guiFrameAuras, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(700, 612)
    scrollFrame:SetPoint("CENTER", guiFrameAuras, "CENTER", -20, 3)

    local contentFrame = CreateFrame("Frame", nil, scrollFrame)
    contentFrame.name = guiFrameAuras.name
    contentFrame:SetSize(680, 520)
    scrollFrame:SetScrollChild(contentFrame)

    local auraWhitelistFrame = CreateFrame("Frame", nil, contentFrame)
    auraWhitelistFrame:SetSize(322, 390)
    auraWhitelistFrame:SetPoint("TOPLEFT", 346, -15)

    local auraBlacklistFrame = CreateFrame("Frame", nil, contentFrame)
    auraBlacklistFrame:SetSize(322, 390)
    auraBlacklistFrame:SetPoint("TOPLEFT", 6, -15)

    local whitelist = CreateList(auraBlacklistFrame, "auraBlacklist", BetterBlizzFramesDB.auraBlacklist, BBF.RefreshAllAuraFrames, nil, nil, 265)

    local blacklistText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    blacklistText:SetPoint("BOTTOM", auraBlacklistFrame, "TOP", -20, -5)
    blacklistText:SetText(L["Blacklist"])

    local blacklist = CreateList(auraWhitelistFrame, "auraWhitelist", BetterBlizzFramesDB.auraWhitelist, BBF.RefreshAllAuraFrames, true, true, 379, true)

    local whitelistText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    whitelistText:SetPoint("BOTTOM", auraWhitelistFrame, "TOP", -60, -5)
    whitelistText:SetText(L["Whitelist"])

    if not BetterBlizzFramesDB.playerAuraFiltering then
        auraWhitelistFrame:SetAlpha(0.3)
        auraBlacklistFrame:SetAlpha(0.3)
    end

    local onlyMeTexture = contentFrame:CreateTexture(nil, "OVERLAY")
    onlyMeTexture:SetAtlas("UI-HUD-UnitFrame-Player-Group-FriendOnlineIcon")
    onlyMeTexture:SetPoint("RIGHT", whitelist, "TOPRIGHT", 296, 9)
    onlyMeTexture:SetSize(18,20)
    CreateTooltip(onlyMeTexture, L["Only_My_Aura_Checkboxes"])

    local enlargeAuraTexture = contentFrame:CreateTexture(nil, "OVERLAY")
    enlargeAuraTexture:SetAtlas("ui-hud-minimap-zoom-in")
    enlargeAuraTexture:SetPoint("LEFT", onlyMeTexture, "RIGHT", 4, 0)
    enlargeAuraTexture:SetSize(18,18)
    CreateTooltip(enlargeAuraTexture, L["Enlarged_Aura_Checkboxes"])

    local compactAuraTexture = contentFrame:CreateTexture(nil, "OVERLAY")
    compactAuraTexture:SetAtlas("ui-hud-minimap-zoom-out")
    compactAuraTexture:SetPoint("LEFT", enlargeAuraTexture, "RIGHT", 3, 0)
    compactAuraTexture:SetSize(18,18)
    CreateTooltip(compactAuraTexture, L["Compact_Aura_Checkboxes"])

    local importantAuraTexture = contentFrame:CreateTexture(nil, "OVERLAY")
    importantAuraTexture:SetAtlas("importantavailablequesticon")
    importantAuraTexture:SetPoint("LEFT", compactAuraTexture, "RIGHT", 2, 0)
    importantAuraTexture:SetSize(17,16)
    importantAuraTexture:SetDesaturated(true)
    importantAuraTexture:SetVertexColor(0,1,0)
    CreateTooltip(importantAuraTexture, L["Important_Aura_Checkboxes"])

    local pandemicAuraTexture = contentFrame:CreateTexture(nil, "OVERLAY")
    pandemicAuraTexture:SetAtlas("elementalstorm-boss-air")
    pandemicAuraTexture:SetPoint("LEFT", importantAuraTexture, "RIGHT", -1, 1)
    pandemicAuraTexture:SetSize(26,26)
    pandemicAuraTexture:SetDesaturated(true)
    pandemicAuraTexture:SetVertexColor(1,0,0)
    CreateTooltip(pandemicAuraTexture, L["Pandemic_Aura_Checkboxes"])






    local playerAuraFiltering = CreateCheckbox("playerAuraFiltering", L["Enable_Aura_Settings"], contentFrame)
    playerAuraFiltering.name = guiFrameAuras.name
    CreateTooltipTwo(playerAuraFiltering, L["Enable_Aura_Settings"], L["Tooltip_Enable_Aura_Settings"], nil, nil, nil, 5)
    playerAuraFiltering:SetPoint("TOPLEFT", contentFrame, "BOTTOMLEFT", 50, 190)
    playerAuraFiltering:HookScript("OnClick", function (self)
        if self:GetChecked() then
            if BetterBlizzFramesDB.targetToTXPos == 0 then
                StaticPopup_Show("BBF_TOT_MESSAGE")
                BetterBlizzFramesDB.targetToTXPos = 31
                BBF.targetToTXPos:SetValue(31)
                BetterBlizzFramesDB.focusToTXPos = 31
                BBF.focusToTXPos:SetValue(31)
                BBF.MoveToTFrames()
                BBF.UpdateFilteredBuffsIcon()
            else
                StaticPopup_Show("BBF_CONFIRM_RELOAD")
            end
            auraWhitelistFrame:SetAlpha(1)
            auraBlacklistFrame:SetAlpha(1)
        else
            if BetterBlizzFramesDB.targetToTXPos == 31 then
                DEFAULT_CHAT_FRAME:AddMessage(L["Chat_Aura_Settings_Off"])
                BetterBlizzFramesDB.targetToTXPos = 0
                BBF.targetToTXPos:SetValue(0)
                BetterBlizzFramesDB.focusToTXPos = 0
                BBF.focusToTXPos:SetValue(0)
                BBF.MoveToTFrames()
            end
            auraWhitelistFrame:SetAlpha(0.3)
            auraBlacklistFrame:SetAlpha(0.3)
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local enableMasque = CreateCheckbox("enableMasque", L["Add_Masque_Support"], contentFrame)
    enableMasque:SetPoint("LEFT", playerAuraFiltering.Text, "RIGHT", 5, 0)
    CreateTooltipTwo(enableMasque, L["Add_Masque_Support"], L["Tooltip_Masque_Support"], L["Tooltip_Masque_Note"], nil, nil, 4)
    enableMasque:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local printAuraSpellIds = CreateCheckbox("printAuraSpellIds", L["Print_Spell_ID"], playerAuraFiltering)
    printAuraSpellIds:SetPoint("LEFT", enableMasque.Text, "RIGHT", 5, 0)
    CreateTooltip(printAuraSpellIds, L["Tooltip_Print_Spell_ID"])

    local importPVPWhitelist = CreateFrame("Button", nil, playerAuraFiltering, "UIPanelButtonTemplate")
    importPVPWhitelist:SetSize(138, 22)
    importPVPWhitelist:SetPoint("LEFT", printAuraSpellIds.text, "RIGHT", 3, 1)
    importPVPWhitelist:SetText(L["Import_PvP_Whitelist"])
    importPVPWhitelist:SetScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_PVP_WHITELIST")
    end)
    local coloredText = L["Whitelist_Colors"]

    CreateTooltipTwo(importPVPWhitelist, L["Import_PvP_Whitelist"], string.format(L["Tooltip_Import_PvP_Whitelist_Desc"], coloredText))
    importPVPWhitelist.Middle:SetDesaturated(true)
    importPVPWhitelist.Left:SetDesaturated(true)
    importPVPWhitelist.Right:SetDesaturated(true)

    local importPVPBlacklist = CreateFrame("Button", nil, playerAuraFiltering, "UIPanelButtonTemplate")
    importPVPBlacklist:SetSize(138, 22)
    importPVPBlacklist:SetPoint("LEFT", importPVPWhitelist, "RIGHT", 0, 0)
    importPVPBlacklist:SetText(L["Import_PvP_Blacklist"])
    importPVPBlacklist:SetScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_PVP_BLACKLIST")
    end)
    CreateTooltipTwo(importPVPBlacklist, L["Import_PvP_Blacklist"], L["Tooltip_Import_PvP_Blacklist_Desc"])
    importPVPBlacklist.Middle:SetDesaturated(true)
    importPVPBlacklist.Left:SetDesaturated(true)
    importPVPBlacklist.Right:SetDesaturated(true)

    -- local tipText = playerAuraFiltering:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- tipText:SetPoint("LEFT", printAuraSpellIds.Text, "RIGHT", 5, 0)
    -- tipText:SetText("Tip")

    --------------------------
    -- Target Frame
    --------------------------
    -- Target Buffs
    local targetBuffEnable = CreateCheckbox("targetBuffEnable", L["Show_BUFFS"], playerAuraFiltering)
    targetBuffEnable:SetPoint("TOPLEFT", contentFrame, "BOTTOMLEFT", 64, 140)
    targetBuffEnable:HookScript("OnClick", function ()
        CheckAndToggleCheckboxes(targetBuffEnable)
        TargetFrame:UpdateAuras()
        if BBF.HidingAllTargetAuras then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local bigEnemyBorderText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bigEnemyBorderText:SetPoint("LEFT", targetBuffEnable, "CENTER", 35, 25)
    bigEnemyBorderText:SetText(L["Target_Frame"])
    local targetFrameIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    targetFrameIcon:SetAtlas("groupfinder-icon-friend")
    targetFrameIcon:SetSize(28, 28)
    targetFrameIcon:SetPoint("RIGHT", bigEnemyBorderText, "LEFT", -3, 0)
    targetFrameIcon:SetDesaturated(1)
    targetFrameIcon:SetVertexColor(1, 0, 0)

    local targetAuraBorder = CreateBorderedFrame(targetBuffEnable, 185, 400, 65, -186, contentFrame)

    local targetBuffFilterWatchList = CreateCheckbox("targetBuffFilterWatchList", L["Whitelist"], targetBuffEnable)
    CreateTooltipTwo(targetBuffFilterWatchList, L["Whitelist"], L["Tooltip_Whitelist"], L["Tooltip_Whitelist_Desc"])
    targetBuffFilterWatchList:SetPoint("TOPLEFT", targetBuffEnable, "BOTTOMLEFT", 15, pixelsBetweenBoxes)

    local targetBuffFilterBlacklist = CreateCheckbox("targetBuffFilterBlacklist", L["Blacklist"], targetBuffEnable)
    targetBuffFilterBlacklist:SetPoint("TOPLEFT", targetBuffFilterWatchList, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetBuffFilterBlacklist, L["Tooltip_Blacklist"])

    local targetBuffFilterLessMinite = CreateCheckbox("targetBuffFilterLessMinite", L["Under_One_Min"], targetBuffEnable)
    targetBuffFilterLessMinite:SetPoint("TOPLEFT", targetBuffFilterBlacklist, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetBuffFilterLessMinite, L["Tooltip_Under_One_Min_Buff"])

    local targetBuffFilterOnlyMe = CreateCheckbox("targetBuffFilterOnlyMe", L["Only_Mine"], targetBuffEnable)
    targetBuffFilterOnlyMe:SetPoint("TOPLEFT", targetBuffFilterLessMinite, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetBuffFilterOnlyMe, L["Tooltip_Only_Mine_Buff"])

    local targetBuffFilterPurgeable = CreateCheckbox("targetBuffFilterPurgeable", L["Purgeable"], targetBuffEnable)
    targetBuffFilterPurgeable:SetPoint("TOPLEFT", targetBuffFilterOnlyMe, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local targetBuffFilterMount = CreateCheckbox("targetBuffFilterMount", L["Mount"], targetBuffEnable)
    targetBuffFilterMount:SetPoint("TOPLEFT", targetBuffFilterPurgeable, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(targetBuffFilterMount, L["Mount"], L["Tooltip_Mount"])


--[[targetBuffPurgeGlow
    local otherNpBuffBlueBorder = CreateCheckbox("otherNpBuffBlueBorder", L["Blue_Border_Buffs"], targetBuffEnable)
    otherNpBuffBlueBorder:SetPoint("TOPLEFT", targetBuffFilterOnlyMe, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local otherNpBuffEmphasisedBorder = CreateCheckbox("otherNpBuffEmphasisedBorder", L["Red_Glow_Whitelisted"], targetBuffEnable)
    otherNpBuffEmphasisedBorder:SetPoint("TOPLEFT", otherNpBuffBlueBorder, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

]]


    -- Target Debuffs
    local targetdeBuffEnable = CreateCheckbox("targetdeBuffEnable", L["Show_DEBUFFS"], playerAuraFiltering)
    targetdeBuffEnable:SetPoint("TOPLEFT", targetBuffFilterMount, "BOTTOMLEFT", -15, 0)
    targetdeBuffEnable:HookScript("OnClick", function ()
        CheckAndToggleCheckboxes(targetdeBuffEnable)
        if BBF.HidingAllTargetAuras then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local targetdeBuffFilterBlizzard = CreateCheckbox("targetdeBuffFilterBlizzard", L["Blizzard_Default_Filter"], targetdeBuffEnable)
    targetdeBuffFilterBlizzard:SetPoint("TOPLEFT", targetdeBuffEnable, "BOTTOMLEFT", 15, pixelsBetweenBoxes)

    local targetdeBuffFilterWatchList = CreateCheckbox("targetdeBuffFilterWatchList", L["Whitelist"], targetdeBuffEnable)
    CreateTooltipTwo(targetdeBuffFilterWatchList, L["Whitelist"], L["Tooltip_Whitelist"], L["Tooltip_Whitelist_Desc"])
    targetdeBuffFilterWatchList:SetPoint("TOPLEFT", targetdeBuffFilterBlizzard, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local targetdeBuffFilterBlacklist = CreateCheckbox("targetdeBuffFilterBlacklist", L["Blacklist"], targetdeBuffEnable)
    targetdeBuffFilterBlacklist:SetPoint("TOPLEFT", targetdeBuffFilterWatchList, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetdeBuffFilterBlacklist, L["Tooltip_Blacklist"])

    local targetdeBuffFilterLessMinite = CreateCheckbox("targetdeBuffFilterLessMinite", L["Under_One_Min"], targetdeBuffEnable)
    targetdeBuffFilterLessMinite:SetPoint("TOPLEFT", targetdeBuffFilterBlacklist, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetdeBuffFilterLessMinite, L["Tooltip_Under_One_Min_Debuff"])

    local targetdeBuffFilterOnlyMe = CreateCheckbox("targetdeBuffFilterOnlyMe", L["Only_Mine"], targetdeBuffEnable)
    targetdeBuffFilterOnlyMe:SetPoint("TOPLEFT", targetdeBuffFilterLessMinite, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local targetAuraGlows = CreateCheckbox("targetAuraGlows", L["Extra_Aura_Settings"], playerAuraFiltering)
    targetAuraGlows:SetPoint("TOPLEFT", targetdeBuffFilterOnlyMe, "BOTTOMLEFT", -15, 0)
    targetAuraGlows:HookScript("OnClick", function ()
        CheckAndToggleCheckboxes(targetAuraGlows)
    end)

    local targetEnlargeAura = CreateCheckbox("targetEnlargeAura", L["Enlarge_Aura"], targetAuraGlows)
    targetEnlargeAura:SetPoint("TOPLEFT", targetAuraGlows, "BOTTOMLEFT", 15, pixelsBetweenBoxes)
    CreateTooltip(targetEnlargeAura, L["Tooltip_Enlarge_Aura"])

    local targetEnlargeAuraEnemy = CreateCheckbox("targetEnlargeAuraEnemy", "", targetAuraGlows, nil, BBF.UpdateUserAuraSettings)
    targetEnlargeAuraEnemy:SetPoint("LEFT", targetEnlargeAura.Text, "RIGHT", 0, 0)
    CreateTooltip(targetEnlargeAuraEnemy, L["Tooltip_Enable_On_Enemy"])
    targetEnlargeAuraEnemy:SetSize(22,22)

    targetEnlargeAuraEnemy.texture = targetEnlargeAuraEnemy:CreateTexture(nil, "ARTWORK", nil, 1)
    targetEnlargeAuraEnemy.texture:SetTexture(BBF.squareGreenGlow)
    targetEnlargeAuraEnemy.texture:SetSize(46, 46)
    targetEnlargeAuraEnemy.texture:SetDesaturated(true)
    targetEnlargeAuraEnemy.texture:SetVertexColor(1,0,0)
    targetEnlargeAuraEnemy.texture:SetPoint("CENTER", targetEnlargeAuraEnemy, "CENTER", -0.5, 0)

    local targetEnlargeAuraFriendly = CreateCheckbox("targetEnlargeAuraFriendly", "", targetAuraGlows, nil, BBF.UpdateUserAuraSettings)
    targetEnlargeAuraFriendly:SetPoint("LEFT", targetEnlargeAuraEnemy, "RIGHT", 0, 0)
    CreateTooltip(targetEnlargeAuraFriendly, L["Tooltip_Enable_On_Friendly"])
    targetEnlargeAuraFriendly:SetSize(22,22)

    targetEnlargeAuraFriendly.texture = targetEnlargeAuraFriendly:CreateTexture(nil, "ARTWORK", nil, 1)
    targetEnlargeAuraFriendly.texture:SetTexture(BBF.squareGreenGlow)
    targetEnlargeAuraFriendly.texture:SetSize(46, 46)
    --targetEnlargeAuraFriendly.texture:SetDesaturated(true)
    targetEnlargeAuraFriendly.texture:SetPoint("CENTER", targetEnlargeAuraFriendly, "CENTER", -0.5, 0)

    local targetCompactAura = CreateCheckbox("targetCompactAura", L["Compact_Aura"], targetAuraGlows)
    targetCompactAura:SetPoint("TOPLEFT", targetEnlargeAura, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetCompactAura, L["Tooltip_Compact_Aura"])

    local targetdeBuffPandemicGlow = CreateCheckbox("targetdeBuffPandemicGlow", L["Pandemic_Glow"], targetAuraGlows)
    targetdeBuffPandemicGlow:SetPoint("TOPLEFT", targetCompactAura, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetdeBuffPandemicGlow, L["Tooltip_Pandemic_Glow"])

    local targetBuffPurgeGlow = CreateCheckbox("targetBuffPurgeGlow", L["Purge_Glow"], targetAuraGlows)
    targetBuffPurgeGlow:SetPoint("TOPLEFT", targetdeBuffPandemicGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetBuffPurgeGlow, L["Tooltip_Purge_Glow"])

    local targetImportantAuraGlow = CreateCheckbox("targetImportantAuraGlow", L["Important_Glow"], targetAuraGlows)
    targetImportantAuraGlow:SetPoint("TOPLEFT", targetBuffPurgeGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetImportantAuraGlow, L["Tooltip_Important_Glow"])



    --------------------------
    -- Focus Frame
    --------------------------
    -- Focus Buffs
    local focusBuffEnable = CreateCheckbox("focusBuffEnable", L["Show_BUFFS"], playerAuraFiltering)
    focusBuffEnable:SetPoint("TOPLEFT", contentFrame, "BOTTOMLEFT", 285, 140)
    focusBuffEnable:HookScript("OnClick", function ()
        CheckAndToggleCheckboxes(focusBuffEnable)
        if BBF.HidingAllFocusAuras then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local friendlyFramesText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    friendlyFramesText:SetPoint("LEFT", focusBuffEnable, "CENTER", 35, 25)
    friendlyFramesText:SetText(L["Focus_Frame"])
    local focusFrameIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    focusFrameIcon:SetAtlas("groupfinder-icon-friend")
    focusFrameIcon:SetSize(28, 28)
    focusFrameIcon:SetPoint("RIGHT", friendlyFramesText, "LEFT", -3, 0)
    focusFrameIcon:SetDesaturated(1)
    focusFrameIcon:SetVertexColor(0, 1, 0)

    CreateBorderedFrame(focusBuffEnable, 185, 400, 65, -186, contentFrame)

    local focusBuffFilterWatchList = CreateCheckbox("focusBuffFilterWatchList", L["Whitelist"], focusBuffEnable)
    CreateTooltipTwo(focusBuffFilterWatchList, L["Whitelist"], L["Tooltip_Whitelist"], L["Tooltip_Whitelist_Desc"])
    focusBuffFilterWatchList:SetPoint("TOPLEFT", focusBuffEnable, "BOTTOMLEFT", 15, pixelsBetweenBoxes)

    local focusBuffFilterBlacklist = CreateCheckbox("focusBuffFilterBlacklist", L["Blacklist"], focusBuffEnable)
    focusBuffFilterBlacklist:SetPoint("TOPLEFT", focusBuffFilterWatchList, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusBuffFilterBlacklist, L["Tooltip_Blacklist"])

    local focusBuffFilterLessMinite = CreateCheckbox("focusBuffFilterLessMinite", L["Under_One_Min"], focusBuffEnable)
    focusBuffFilterLessMinite:SetPoint("TOPLEFT", focusBuffFilterBlacklist, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusBuffFilterLessMinite, L["Tooltip_Under_One_Min_Buff"])

    local focusBuffFilterOnlyMe = CreateCheckbox("focusBuffFilterOnlyMe", L["Only_Mine"], focusBuffEnable)
    focusBuffFilterOnlyMe:SetPoint("TOPLEFT", focusBuffFilterLessMinite, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusBuffFilterOnlyMe, L["Tooltip_Only_Mine_Focus_Buff"])

    local focusBuffFilterPurgeable = CreateCheckbox("focusBuffFilterPurgeable", L["Purgeable"], focusBuffEnable)
    focusBuffFilterPurgeable:SetPoint("TOPLEFT", focusBuffFilterOnlyMe, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local focusBuffFilterMount = CreateCheckbox("focusBuffFilterMount", L["Mount"], focusBuffEnable)
    focusBuffFilterMount:SetPoint("TOPLEFT", focusBuffFilterPurgeable, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(focusBuffFilterMount, L["Mount"], L["Tooltip_Mount"])

    -- Focus Debuffs
    local focusdeBuffEnable = CreateCheckbox("focusdeBuffEnable", L["Show_DEBUFFS"], playerAuraFiltering)
    focusdeBuffEnable:SetPoint("TOPLEFT", focusBuffFilterMount, "BOTTOMLEFT", -15, 0)
    focusdeBuffEnable:HookScript("OnClick", function ()
        CheckAndToggleCheckboxes(focusdeBuffEnable)
        if BBF.HidingAllFocusAuras then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local focusdeBuffFilterBlizzard = CreateCheckbox("focusdeBuffFilterBlizzard", L["Blizzard_Default_Filter"], focusdeBuffEnable)
    focusdeBuffFilterBlizzard:SetPoint("TOPLEFT", focusdeBuffEnable, "BOTTOMLEFT", 15, pixelsBetweenBoxes)

    local focusdeBuffFilterWatchList = CreateCheckbox("focusdeBuffFilterWatchList", L["Whitelist"], focusdeBuffEnable)
    focusdeBuffFilterWatchList:SetPoint("TOPLEFT", focusdeBuffFilterBlizzard, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(focusdeBuffFilterWatchList, L["Whitelist"], L["Tooltip_Whitelist"], L["Tooltip_Whitelist_Desc"])

    local focusdeBuffFilterBlacklist = CreateCheckbox("focusdeBuffFilterBlacklist", L["Blacklist"], focusdeBuffEnable)
    focusdeBuffFilterBlacklist:SetPoint("TOPLEFT", focusdeBuffFilterWatchList, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusdeBuffFilterBlacklist, L["Tooltip_Blacklist"])

    local focusdeBuffFilterLessMinite = CreateCheckbox("focusdeBuffFilterLessMinite", L["Under_One_Min"], focusdeBuffEnable)
    focusdeBuffFilterLessMinite:SetPoint("TOPLEFT", focusdeBuffFilterBlacklist, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusdeBuffFilterLessMinite, L["Tooltip_Under_One_Min_Debuff"])

    local focusdeBuffFilterOnlyMe = CreateCheckbox("focusdeBuffFilterOnlyMe", L["Only_Mine"], focusdeBuffEnable)
    focusdeBuffFilterOnlyMe:SetPoint("TOPLEFT", focusdeBuffFilterLessMinite, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local focusAuraGlows = CreateCheckbox("focusAuraGlows", L["Extra_Aura_Settings"], playerAuraFiltering)
    focusAuraGlows:SetPoint("TOPLEFT", focusdeBuffFilterOnlyMe, "BOTTOMLEFT", -15, 0)
    focusAuraGlows:HookScript("OnClick", function ()
        CheckAndToggleCheckboxes(focusAuraGlows)
    end)

    local focusEnlargeAura = CreateCheckbox("focusEnlargeAura", L["Enlarge_Aura"], focusAuraGlows)
    focusEnlargeAura:SetPoint("TOPLEFT", focusAuraGlows, "BOTTOMLEFT", 15, pixelsBetweenBoxes)
    CreateTooltip(focusEnlargeAura, L["Tooltip_Enlarge_Aura"])

    local focusEnlargeAuraEnemy = CreateCheckbox("focusEnlargeAuraEnemy", "", focusAuraGlows, nil, BBF.UpdateUserAuraSettings)
    focusEnlargeAuraEnemy:SetPoint("LEFT", focusEnlargeAura.Text, "RIGHT", 0, 0)
    CreateTooltip(focusEnlargeAuraEnemy, L["Tooltip_Enable_On_Enemy"])
    focusEnlargeAuraEnemy:SetSize(22,22)

    focusEnlargeAuraEnemy.texture = focusEnlargeAuraEnemy:CreateTexture(nil, "ARTWORK", nil, 1)
    focusEnlargeAuraEnemy.texture:SetTexture(BBF.squareGreenGlow)
    focusEnlargeAuraEnemy.texture:SetSize(46, 46)
    focusEnlargeAuraEnemy.texture:SetDesaturated(true)
    focusEnlargeAuraEnemy.texture:SetVertexColor(1,0,0)
    focusEnlargeAuraEnemy.texture:SetPoint("CENTER", focusEnlargeAuraEnemy, "CENTER", -0.5, 0)

    local focusEnlargeAuraFriendly = CreateCheckbox("focusEnlargeAuraFriendly", "", focusAuraGlows, nil, BBF.UpdateUserAuraSettings)
    focusEnlargeAuraFriendly:SetPoint("LEFT", focusEnlargeAuraEnemy, "RIGHT", 0, 0)
    CreateTooltip(focusEnlargeAuraFriendly, L["Tooltip_Enable_On_Friendly"])
    focusEnlargeAuraFriendly:SetSize(22,22)

    focusEnlargeAuraFriendly.texture = focusEnlargeAuraFriendly:CreateTexture(nil, "ARTWORK", nil, 1)
    focusEnlargeAuraFriendly.texture:SetTexture(BBF.squareGreenGlow)
    focusEnlargeAuraFriendly.texture:SetSize(46, 46)
    --focusEnlargeAuraFriendly.texture:SetDesaturated(true)
    focusEnlargeAuraFriendly.texture:SetPoint("CENTER", focusEnlargeAuraFriendly, "CENTER", -0.5, 0)

    local focusCompactAura = CreateCheckbox("focusCompactAura", L["Compact_Aura"], focusAuraGlows)
    focusCompactAura:SetPoint("TOPLEFT", focusEnlargeAura, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusCompactAura, L["Tooltip_Compact_Aura"])

    local focusdeBuffPandemicGlow = CreateCheckbox("focusdeBuffPandemicGlow", L["Pandemic_Glow"], focusAuraGlows)
    focusdeBuffPandemicGlow:SetPoint("TOPLEFT", focusCompactAura, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusdeBuffPandemicGlow, L["Tooltip_Pandemic_Glow"])

    local focusBuffPurgeGlow = CreateCheckbox("focusBuffPurgeGlow", L["Purge_Glow"], focusAuraGlows)
    focusBuffPurgeGlow:SetPoint("TOPLEFT", focusdeBuffPandemicGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusBuffPurgeGlow, L["Tooltip_Purge_Glow"])

    local focusImportantAuraGlow = CreateCheckbox("focusImportantAuraGlow", L["Important_Glow"], focusAuraGlows)
    focusImportantAuraGlow:SetPoint("TOPLEFT", focusBuffPurgeGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusImportantAuraGlow, L["Tooltip_Important_Glow"])

    --------------------------
    -- Player Auras
    --------------------------
    -- Player Auras

    local enablePlayerBuffFiltering = CreateCheckbox("enablePlayerBuffFiltering", L["Enable_Buff_Filtering"], playerAuraFiltering)
    enablePlayerBuffFiltering:SetPoint("TOPLEFT", contentFrame, "BOTTOMLEFT", 503, 140)
    enablePlayerBuffFiltering:HookScript("OnClick", function (self)
        CheckAndToggleCheckboxes(enablePlayerBuffFiltering)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local PlayerAuraFrameBuffEnable = CreateCheckbox("PlayerAuraFrameBuffEnable", L["Show_BUFFS"], enablePlayerBuffFiltering)
    PlayerAuraFrameBuffEnable:SetPoint("TOPLEFT", enablePlayerBuffFiltering, "BOTTOMLEFT", 15, pixelsBetweenBoxes)
    PlayerAuraFrameBuffEnable:HookScript("OnClick", function (self)
        CheckAndToggleCheckboxes(PlayerAuraFrameBuffEnable)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltipTwo(PlayerAuraFrameBuffEnable, L["Show_Player_Buffs"], L["Tooltip_Show_Player_Buffs"], L["Tooltip_Show_Player_Buffs_Desc"])

    local personalBarText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    personalBarText:SetPoint("LEFT", enablePlayerBuffFiltering, "CENTER", 35, 25)
    personalBarText:SetText(L["Label_Player_Auras"])
    local personalBarIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    personalBarIcon:SetAtlas("groupfinder-icon-friend")
    personalBarIcon:SetSize(28, 28)
    personalBarIcon:SetPoint("RIGHT", personalBarText, "LEFT", -3, 0)

    local PlayerAuraBorder = CreateBorderedFrame(enablePlayerBuffFiltering, 185, 400, 65, -186, contentFrame)

    local PlayerAuraFrameBuffFilterWatchList = CreateCheckbox("PlayerAuraFrameBuffFilterWatchList", L["Whitelist"], PlayerAuraFrameBuffEnable)
    CreateTooltipTwo(PlayerAuraFrameBuffFilterWatchList, L["Whitelist"], L["Tooltip_Whitelist"], L["Tooltip_Whitelist_Desc"])
    PlayerAuraFrameBuffFilterWatchList:SetPoint("TOPLEFT", PlayerAuraFrameBuffEnable, "BOTTOMLEFT", 15, pixelsBetweenBoxes)

    local playerBuffFilterBlacklist = CreateCheckbox("playerBuffFilterBlacklist", L["Blacklist"], PlayerAuraFrameBuffEnable)
    playerBuffFilterBlacklist:SetPoint("TOPLEFT", PlayerAuraFrameBuffFilterWatchList, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(playerBuffFilterBlacklist, L["Tooltip_Blacklist"])

    local PlayerAuraFrameBuffFilterLessMinite = CreateCheckbox("PlayerAuraFrameBuffFilterLessMinite", L["Under_One_Min"], PlayerAuraFrameBuffEnable)
    PlayerAuraFrameBuffFilterLessMinite:SetPoint("TOPLEFT", playerBuffFilterBlacklist, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(PlayerAuraFrameBuffFilterLessMinite, L["Tooltip_Under_One_Min_Buff"])

    local showHiddenAurasIcon = CreateCheckbox("showHiddenAurasIcon", L["Filtered_Buffs_Icon"], PlayerAuraFrameBuffEnable)
    showHiddenAurasIcon:SetPoint("TOPLEFT", PlayerAuraFrameBuffFilterLessMinite, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(showHiddenAurasIcon, L["Tooltip_Filtered_Buffs_Icon"])

    -- Create a button next to the checkbox
    local changeIconButton = CreateFrame("Button", "ChangeIconButton", showHiddenAurasIcon, "UIPanelButtonTemplate")
    changeIconButton:SetPoint("RIGHT", showHiddenAurasIcon, "LEFT", 0, 0)
    changeIconButton:SetSize(37, 20)  -- Adjust size as needed
    changeIconButton:SetText(L["Icon"])
    local iconChangeWindow

    changeIconButton:SetScript("OnClick", function()
        if not iconChangeWindow then
            iconChangeWindow = CreateIconChangeWindow()
        end
        iconChangeWindow:Show()
    end)

    showHiddenAurasIcon:HookScript("OnClick", function(self)
        if self:GetChecked() then
            changeIconButton:SetAlpha(1)
            changeIconButton:Enable()
        else
            changeIconButton:SetAlpha(0)
            changeIconButton:Disable()
            BetterBlizzFramesDB.toggleIconPosition = nil
            BBF.UpdateHiddenAuraButtonPos()
        end
    end)

    if not BetterBlizzFramesDB.showHiddenAurasIcon then
        changeIconButton:SetAlpha(0)
        changeIconButton:Disable()
    end

    local playerBuffFilterMount = CreateCheckbox("playerBuffFilterMount", L["Mount"], PlayerAuraFrameBuffEnable)
    playerBuffFilterMount:SetPoint("TOPLEFT", showHiddenAurasIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(playerBuffFilterMount, L["Mount"], L["Tooltip_Mount"])

    -- Personal Bar Debuffs
    local enablePlayerDebuffFiltering = CreateCheckbox("enablePlayerDebuffFiltering", L["Tooltip_Enable_Player_Debuff_Filtering"], playerAuraFiltering)
    enablePlayerDebuffFiltering:SetPoint("TOPLEFT", playerBuffFilterMount, "BOTTOMLEFT", -30, 0)
    enablePlayerDebuffFiltering:HookScript("OnClick", function (self)
        CheckAndToggleCheckboxes(enablePlayerDebuffFiltering)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltip(enablePlayerDebuffFiltering, L["Tooltip_Enable_Debuff_Filtering"])

    local PlayerAuraFramedeBuffEnable = CreateCheckbox("PlayerAuraFramedeBuffEnable", L["Show_DEBUFFS"], enablePlayerDebuffFiltering)
    PlayerAuraFramedeBuffEnable:SetPoint("TOPLEFT", enablePlayerDebuffFiltering, "BOTTOMLEFT", 15, pixelsBetweenBoxes)
    PlayerAuraFramedeBuffEnable:HookScript("OnClick", function (self)
        CheckAndToggleCheckboxes(PlayerAuraFramedeBuffEnable)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltipTwo(PlayerAuraFramedeBuffEnable, L["Show_Player_Debuffs"], L["Tooltip_Show_Player_Debuffs"], L["Tooltip_Show_Player_Debuffs_Desc"])

    local PlayerAuraFramedeBuffFilterWatchList = CreateCheckbox("PlayerAuraFramedeBuffFilterWatchList", L["Whitelist"], PlayerAuraFramedeBuffEnable)
    CreateTooltipTwo(PlayerAuraFramedeBuffFilterWatchList, L["Whitelist"], L["Tooltip_Whitelist"], L["Tooltip_Whitelist_Desc"])
    PlayerAuraFramedeBuffFilterWatchList:SetPoint("TOPLEFT", PlayerAuraFramedeBuffEnable, "BOTTOMLEFT", 15, pixelsBetweenBoxes)

    local playerdeBuffFilterBlacklist = CreateCheckbox("playerdeBuffFilterBlacklist", L["Blacklist"], PlayerAuraFramedeBuffEnable)
    playerdeBuffFilterBlacklist:SetPoint("TOPLEFT", PlayerAuraFramedeBuffFilterWatchList, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(playerdeBuffFilterBlacklist, L["Tooltip_Blacklist"])

    local PlayerAuraFramedeBuffFilterLessMinite = CreateCheckbox("PlayerAuraFramedeBuffFilterLessMinite", L["Under_One_Min"], PlayerAuraFramedeBuffEnable)
    PlayerAuraFramedeBuffFilterLessMinite:SetPoint("TOPLEFT", playerdeBuffFilterBlacklist, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(PlayerAuraFramedeBuffFilterLessMinite, L["Tooltip_Under_One_Min_Debuff"])

--[=[
    local debuffDotChecker = CreateCheckbox("debuffDotChecker", L["DoT_Indicator"], PlayerAuraFramedeBuffEnable)
    debuffDotChecker:SetPoint("TOPLEFT", PlayerAuraFramedeBuffFilterLessMinite, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(debuffDotChecker, L["Tooltip_Debuff_Dot_Checker"])

]=]



    local playerAuraGlows = CreateCheckbox("playerAuraGlows", L["Extra_Aura_Settings"], playerAuraFiltering)
    playerAuraGlows:SetPoint("TOPLEFT", PlayerAuraFramedeBuffFilterLessMinite, "BOTTOMLEFT", -30, -20)
    playerAuraGlows:HookScript("OnClick", function ()
        CheckAndToggleCheckboxes(playerAuraGlows)
    end)
    --playerAuraGlows:Disable()
    --playerAuraGlows:SetAlpha(0.5)

--[=[
    local playerAuraPandemicGlow = CreateCheckbox("playerAuraPandemicGlow", L["Pandemic_Glow"], playerAuraGlows)
    playerAuraPandemicGlow:SetPoint("TOPLEFT", playerAuraGlows, "BOTTOMLEFT", 15, pixelsBetweenBoxes)
    CreateTooltip(playerAuraPandemicGlow, L["Tooltip_Pandemic_Glow"])

]=]


    local playerAuraImportantGlow = CreateCheckbox("playerAuraImportantGlow", L["Important_Glow"], playerAuraGlows)
    playerAuraImportantGlow:SetPoint("TOPLEFT", playerAuraGlows, "BOTTOMLEFT", 15, pixelsBetweenBoxes)
    CreateTooltip(playerAuraImportantGlow, L["Tooltip_Important_Glow"])

    local addCooldownFramePlayerBuffs = CreateCheckbox("addCooldownFramePlayerBuffs", L["Buff_Cooldown"], playerAuraGlows)
    addCooldownFramePlayerBuffs:SetPoint("TOPLEFT", playerAuraImportantGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(addCooldownFramePlayerBuffs, L["Buff_Cooldown"], L["Tooltip_Player_Aura_Spacing"])

    local addCooldownFramePlayerDebuffs = CreateCheckbox("addCooldownFramePlayerDebuffs", L["Debuff_Cooldown"], playerAuraGlows)
    addCooldownFramePlayerDebuffs:SetPoint("TOPLEFT", addCooldownFramePlayerBuffs, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(addCooldownFramePlayerDebuffs, L["Debuff_Cooldown"], L["Tooltip_Debuff_Cooldown"])

    local hideDefaultPlayerAuraDuration = CreateCheckbox("hideDefaultPlayerAuraDuration", L["Hide_Duration_Text"], playerAuraGlows)
    hideDefaultPlayerAuraDuration:SetPoint("TOPLEFT", addCooldownFramePlayerDebuffs, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideDefaultPlayerAuraDuration, L["Hide_Duration_Text"], L["Tooltip_Hide_Duration_Text"])

    local hideDefaultPlayerAuraCdText = CreateCheckbox("hideDefaultPlayerAuraCdText", L["Hide_CD_Duration_Text"], playerAuraGlows)
    hideDefaultPlayerAuraCdText:SetPoint("TOPLEFT", hideDefaultPlayerAuraDuration, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideDefaultPlayerAuraCdText, L["Hide_CD_Duration_Text"], L["Tooltip_Hide_CD_Duration_Text_Desc"], L["Tooltip_Hide_CD_Duration_Text_Extra"])


    local personalAuraSettings = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    personalAuraSettings:SetPoint("TOP", PlayerAuraBorder, "BOTTOM", 0, -5)
    personalAuraSettings:SetText(L["Label_Player_Aura_Settings"])



    local targetAndFocusAuraSettings = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    targetAndFocusAuraSettings:SetPoint("TOP", targetAuraBorder, "BOTTOMRIGHT", 20, -5)
    targetAndFocusAuraSettings:SetText(L["Target_And_Focus_Aura_Settings"])

    --------------------------
    -- Frame settings
    --------------------------






    local targetAndFocusAuraScale = CreateSlider(playerAuraFiltering, L["All_Aura_Size"], 0.7, 2, 0.01, "targetAndFocusAuraScale")
    targetAndFocusAuraScale:SetPoint("TOP", targetAndFocusAuraSettings, "BOTTOM", 0, -20)
    CreateTooltip(targetAndFocusAuraScale, L["Tooltip_All_Aura_Size"])

    local targetAndFocusSmallAuraScale = CreateSlider(playerAuraFiltering, L["Small_Aura_Size"], 0.7, 2, 0.01, "targetAndFocusSmallAuraScale")
    targetAndFocusSmallAuraScale:SetPoint("TOP", targetAndFocusAuraScale, "BOTTOM", 0, -20)
    CreateTooltip(targetAndFocusSmallAuraScale, L["Tooltip_Small_Aura_Size"])

    local sameSizeAuras = CreateCheckbox("sameSizeAuras", L["Same_Size"], playerAuraFiltering)
    sameSizeAuras:SetPoint("LEFT", targetAndFocusSmallAuraScale, "RIGHT", 3, 0)
    CreateTooltipTwo(sameSizeAuras, L["Same_Size"], L["Tooltip_Same_Size"])
    sameSizeAuras:HookScript("OnClick", function(self)
        if self:GetChecked() then
            DisableElement(targetAndFocusSmallAuraScale)
        else
            EnableElement(targetAndFocusSmallAuraScale)
        end
    end)
    if BetterBlizzFramesDB.sameSizeAuras then
        DisableElement(targetAndFocusSmallAuraScale)
    end

    local enlargedAuraSize = CreateSlider(playerAuraFiltering, L["Enlarged_Aura_Scale"], 1, 2, 0.01, "enlargedAuraSize")
    enlargedAuraSize:SetPoint("TOP", targetAndFocusSmallAuraScale, "BOTTOM", 0, -20)
    CreateTooltip(enlargedAuraSize, L["Tooltip_Enlarged_Aura_Scale"])

    local compactedAuraSize = CreateSlider(playerAuraFiltering, L["Compacted_Aura_Scale"], 0.3, 1.5, 0.01, "compactedAuraSize")
    compactedAuraSize:SetPoint("TOP", enlargedAuraSize, "BOTTOM", 0, -20)
    CreateTooltip(compactedAuraSize, L["Tooltip_Compacted_Aura_Scale"])

    local targetAndFocusAurasPerRow = CreateSlider(playerAuraFiltering, L["Max_Auras_Per_Row"], 1, 12, 1, "targetAndFocusAurasPerRow")
    targetAndFocusAurasPerRow:SetPoint("TOPLEFT", compactedAuraSize, "BOTTOMLEFT", 0, -17)

    local targetAndFocusAuraOffsetX = CreateSlider(playerAuraFiltering, L["X_Offset"], -50, 50, 1, "targetAndFocusAuraOffsetX", "X")
    targetAndFocusAuraOffsetX:SetPoint("TOPLEFT", targetAndFocusAurasPerRow, "BOTTOMLEFT", 0, -17)

    local targetAndFocusAuraOffsetY = CreateSlider(playerAuraFiltering, L["Y_Offset"], -50, 50, 1, "targetAndFocusAuraOffsetY", "Y")
    targetAndFocusAuraOffsetY:SetPoint("TOPLEFT", targetAndFocusAuraOffsetX, "BOTTOMLEFT", 0, -17)

    local targetAndFocusHorizontalGap = CreateSlider(playerAuraFiltering, L["Horizontal_Gap"], 0, 18, 0.5, "targetAndFocusHorizontalGap", "X")
    targetAndFocusHorizontalGap:SetPoint("TOPLEFT", targetAndFocusAuraOffsetY, "BOTTOMLEFT", 0, -17)

    local targetAndFocusVerticalGap = CreateSlider(playerAuraFiltering, L["Vertical_Gap"], 0, 18, 0.5, "targetAndFocusVerticalGap", "Y")
    targetAndFocusVerticalGap:SetPoint("TOPLEFT", targetAndFocusHorizontalGap, "BOTTOMLEFT", 0, -17)

    local auraTypeGap = CreateSlider(playerAuraFiltering, L["Aura_Type_Gap"], 0, 30, 1, "auraTypeGap", "Y")
    auraTypeGap:SetPoint("TOPLEFT", targetAndFocusVerticalGap, "BOTTOMLEFT", 0, -17)
    CreateTooltip(auraTypeGap, L["Tooltip_Aura_Type_Gap"])

    local auraStackSize = CreateSlider(playerAuraFiltering, L["Aura_Stack_Size"], 0.4, 2, 0.01, "auraStackSize")
    auraStackSize:SetPoint("TOPLEFT", auraTypeGap, "BOTTOMLEFT", 0, -17)
    CreateTooltipTwo(auraStackSize, L["Aura_Stack_Size"], L["Tooltip_Aura_Stack_Size"])

--[=[
    local maxTargetBuffs = CreateSlider(playerAuraFiltering, L["Max_Buffs"], 1, 32, 1, "maxTargetBuffs")
    maxTargetBuffs:SetPoint("TOPLEFT", targetAndFocusVerticalGap, "BOTTOMLEFT", 0, -17)
    maxTargetBuffs:Disable()
    maxTargetBuffs:SetAlpha(0.5)

    local maxTargetDebuffs = CreateSlider(playerAuraFiltering, L["Max_Debuffs"], 1, 32, 1, "maxTargetDebuffs")
    maxTargetDebuffs:SetPoint("TOPLEFT", maxTargetBuffs, "BOTTOMLEFT", 0, -17)
    maxTargetDebuffs:Disable()
    maxTargetDebuffs:SetAlpha(0.5)

]=]



    local playerAuraSpacingX = CreateSlider(playerAuraFiltering, L["Horizontal_Padding"], 0, 10, 1, "playerAuraSpacingX", "X")
    playerAuraSpacingX:SetPoint("TOP", PlayerAuraBorder, "BOTTOM", 0, -35)
    CreateTooltip(playerAuraSpacingX, L["Tooltip_Horizontal_Aura_Padding"], "ANCHOR_LEFT")

    local playerAuraSpacingY = CreateSlider(playerAuraFiltering, L["Vertical_Padding"], -10, 10, 1, "playerAuraSpacingY", "Y")
    playerAuraSpacingY:SetPoint("TOP", playerAuraSpacingX, "BOTTOM", 0, -15)

    local useEditMode = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    useEditMode:SetPoint("TOP", PlayerAuraBorder, "BOTTOM", 0, -90)
    useEditMode:SetText(L["Use_Edit_Mode"])

    local moreAuraSettings = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    moreAuraSettings:SetPoint("TOP", PlayerAuraBorder, "BOTTOM", -100, -125)
    moreAuraSettings:SetText(L["Label_More_Aura_Settings"])

    local displayDispelGlowAlways = CreateCheckbox("displayDispelGlowAlways", L["Always_Show_Purge_Texture"], playerAuraFiltering)
    displayDispelGlowAlways:SetPoint("TOPLEFT", moreAuraSettings, "BOTTOMLEFT", -10, -3)
    CreateTooltip(displayDispelGlowAlways, L["Tooltip_Always_Show_Purge_Texture"])

    local changePurgeTextureColor = CreateCheckbox("changePurgeTextureColor", L["Change_Purge_Texture_Color"], playerAuraFiltering)
    changePurgeTextureColor:SetPoint("TOPLEFT", displayDispelGlowAlways, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(changePurgeTextureColor, L["Change_Purge_Texture_Color"])

    local showPurgeTextureOnSelf = CreateCheckbox("showPurgeTextureOnSelf", L["Show_Purge_Texture_On_Player"], playerAuraFiltering)
    showPurgeTextureOnSelf:SetPoint("TOPLEFT", changePurgeTextureColor, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(showPurgeTextureOnSelf, L["Show_Purge_Texture_On_Player"], L["Tooltip_Show_Purge_Texture_On_Player"])

    local onlyPandemicAuraMine = CreateCheckbox("onlyPandemicAuraMine", L["Only_Pandemic_Mine"], playerAuraFiltering)
    onlyPandemicAuraMine:SetPoint("TOPLEFT", showPurgeTextureOnSelf, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(onlyPandemicAuraMine, L["Tooltip_Ignore_Self"], "ANCHOR_LEFT")

    local increaseAuraStrata = CreateCheckbox("increaseAuraStrata", L["Increase_Aura_Frame_Strata"], playerAuraFiltering)
    increaseAuraStrata:SetPoint("TOPLEFT", onlyPandemicAuraMine, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(increaseAuraStrata, L["Increase_Aura_Frame_Strata"], L["Tooltip_Increase_Aura_Frame_Strata"])
    increaseAuraStrata:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local clickthroughAuras = CreateCheckbox("clickthroughAuras", L["Clickthrough_Auras"], playerAuraFiltering)
    clickthroughAuras:SetPoint("TOPLEFT", increaseAuraStrata, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(clickthroughAuras, L["Clickthrough_Auras"], L["Tooltip_Clickthrough_Auras"])
    clickthroughAuras:HookScript("OnClick", function(self)
        if self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local auraImportantDispelIcon = CreateCheckbox("auraImportantDispelIcon", L["Important_Glow_Dispel_Icon"], playerAuraFiltering)
    auraImportantDispelIcon:SetPoint("TOPLEFT", clickthroughAuras, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(auraImportantDispelIcon, L["Important_Glow_Dispel_Icon"], L["Tooltip_Important_Glow_Dispel_Icon"])

    local function OpenColorPicker(entryColors)
        local colorData = entryColors or {0, 1, 0, 1}
        local r, g, b = colorData[1] or 1, colorData[2] or 1, colorData[3] or 1
        local a = colorData[4] or 1

        local function updateColors(newR, newG, newB, newA)
            entryColors[1] = newR
            entryColors[2] = newG
            entryColors[3] = newB
            entryColors[4] = newA or 1

            BBF.RefreshAllAuraFrames()
        end

        local function swatchFunc()
            r, g, b = ColorPickerFrame:GetColorRGB()
            updateColors(r, g, b, a)
        end

        local function opacityFunc()
            a = ColorPickerFrame:GetColorAlpha()
            updateColors(r, g, b, a)
        end

        local function cancelFunc(previousValues)
            if previousValues then
                r, g, b, a = previousValues.r, previousValues.g, previousValues.b, previousValues.a
                updateColors(r, g, b, a)
            end
        end

        ColorPickerFrame.previousValues = { r = r, g = g, b = b, a = a }

        ColorPickerFrame:SetupColorPickerAndShow({
            r = r, g = g, b = b, opacity = a, hasOpacity = true,
            swatchFunc = swatchFunc, opacityFunc = opacityFunc, cancelFunc = cancelFunc
        })
    end

    local dispelGlowButton = CreateFrame("Button", nil, playerAuraFiltering, "UIPanelButtonTemplate")
    dispelGlowButton:SetText(L["Color"])
    dispelGlowButton:SetPoint("LEFT", changePurgeTextureColor.text, "RIGHT", -1, 0)
    dispelGlowButton:SetSize(43, 18)
    dispelGlowButton:SetScript("OnClick", function()
        OpenColorPicker(BetterBlizzFramesDB.purgeTextureColorRGB)
    end)
    CreateTooltip(dispelGlowButton, L["Tooltip_Dispel_Glow_Color"])

    local sortingSettings = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sortingSettings:SetPoint("TOPLEFT", auraImportantDispelIcon, "BOTTOMLEFT", 10, -4)
    sortingSettings:SetText(L["Label_Sorting"])

    local customImportantAuraSorting = CreateCheckbox("customImportantAuraSorting", L["Sort_Important_Auras"], playerAuraFiltering)
    customImportantAuraSorting:SetPoint("TOPLEFT", auraImportantDispelIcon, "BOTTOMLEFT", 0, -20)
    CreateTooltip(customImportantAuraSorting, L["Tooltip_Sort_Important_Auras"])

    local customLargeSmallAuraSorting = CreateCheckbox("customLargeSmallAuraSorting", L["Sort_Enlarged_Compact"], playerAuraFiltering)
    customLargeSmallAuraSorting:SetPoint("TOPLEFT", customImportantAuraSorting, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(customLargeSmallAuraSorting, L["Tooltip_Sort_Enlarged_Compact"])

    local allowLargeAuraFirst = CreateCheckbox("allowLargeAuraFirst", L["Sort_Enlarged_Before_Important"], playerAuraFiltering)
    allowLargeAuraFirst:SetPoint("TOPLEFT", customLargeSmallAuraSorting, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(allowLargeAuraFirst, L["Tooltip_Sort_Enlarged_Before_Important"])

    local purgeableBuffSorting = CreateCheckbox("purgeableBuffSorting", L["Sort_Purgeable_Auras"], playerAuraFiltering)
    purgeableBuffSorting:SetPoint("TOPLEFT", allowLargeAuraFirst, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(purgeableBuffSorting, L["Sort_Purgeable_Auras"], L["Tooltip_Sort_Purgeable_Auras"])

    local purgeableBuffSortingFirst = CreateCheckbox("purgeableBuffSortingFirst", L["Sort_Purgeable_Before_Enlarged"], purgeableBuffSorting)
    purgeableBuffSortingFirst:SetPoint("TOPLEFT", purgeableBuffSorting, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(purgeableBuffSortingFirst, L["Sort_Purgeable_Before_Enlarged"], L["Tooltip_Sort_Purgeable_Before_Enlarged"])
    purgeableBuffSorting:HookScript("OnClick", function(self)
        CheckAndToggleCheckboxes(purgeableBuffSorting)
    end)

    -- local customPandemicAuraSorting = CreateCheckbox("customPandemicAuraSorting", "Sort Pandemic Auras before all", playerAuraFiltering)
    -- customPandemicAuraSorting:SetPoint("TOPLEFT", allowLargeAuraFirst, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    -- CreateTooltip(customPandemicAuraSorting, L["Tooltip_Sort_Pandemic_Auras"])




    playerAuraFiltering:HookScript("OnClick", function (self)
        if self:GetChecked() then
            --asd
        else
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end

        CheckAndToggleCheckboxes(playerAuraFiltering)
    end)

    local betaHighlightIcon = playerAuraFiltering:CreateTexture(nil, "BACKGROUND")
    betaHighlightIcon:SetAtlas("CharacterCreate-NewLabel")
    betaHighlightIcon:SetSize(42, 34)
    betaHighlightIcon:SetPoint("RIGHT", playerAuraFiltering, "LEFT", 8, 0)
end

