local BBF = _G.BBF
if not BBF or not BBF.isMidnight then return end
local L = BBF.L
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

local fontSmall, fontMedium, fontLarge = BBF.fontSmall, BBF.fontMedium, BBF.fontLarge
local pixelsBetweenBoxes = BBF.pixelsBetweenBoxes or 6
local pixelsOnFirstBox = -1
local sliderUnderBoxX, sliderUnderBoxY = 12, -10
local sliderUnderBox = BBF.sliderUnderBox or "12, -10"
local anchorPoints = BBF.anchorPoints
local anchorPoints2 = BBF.anchorPoints2
local checkBoxList = BBF.checkBoxList
local sliderList = BBF.sliderList
local CheckAndToggleCheckboxes = BBF.CheckAndToggleCheckboxes
local CreateAnchorDropdown = BBF.CreateAnchorDropdown
local CreateBorderBox = BBF.CreateBorderBox
local CreateBorderedFrame = BBF.CreateBorderedFrame
local CreateCDManagerList = BBF.CreateCDManagerList
local CreateCheckbox = BBF.CreateCheckbox
local CreateClassButton = BBF.CreateClassButton
local CreateColorBox = BBF.CreateColorBox
local CreateFontDropdown = BBF.CreateFontDropdown
local CreateIconChangeWindow = BBF.CreateIconChangeWindow
local CreateImportExportUI = BBF.CreateImportExportUI
local CreateList = BBF.CreateList
local CreateSearchFrame = BBF.CreateSearchFrame
local CreateSimpleDropdown = BBF.CreateSimpleDropdown
local CreateSlider = BBF.CreateSlider
local CreateTextureDropdown = BBF.CreateTextureDropdown
local CreateTitle = BBF.CreateTitle
local CreateTooltip = BBF.CreateTooltip
local CreateTooltipTwo = BBF.CreateTooltipTwo
local DisableElement = BBF.DisableElement
local EnableElement = BBF.EnableElement
local FormatClassName = BBF.FormatClassName
local GeneratorFunction = BBF.GeneratorFunction
local GetLocalizedText = BBF.GetLocalizedText
local HandleEditBoxInput = BBF.HandleEditBoxInput
local HideWipeButton = BBF.HideWipeButton
local OpenColorOptions = BBF.OpenColorOptions
local OpenColorPicker = BBF.OpenColorPicker
local RecolorEntireAuraWhitelist = BBF.RecolorEntireAuraWhitelist
local SearchElements = BBF.SearchElements
local SetChecked = BBF.SetChecked
local SetImportantBoxColor = BBF.SetImportantBoxColor
local SetSliderValue = BBF.SetSliderValue
local SetTextColor = BBF.SetTextColor
local ShowProfileConfirmation = BBF.ShowProfileConfirmation
local UpdateColorSquare = BBF.UpdateColorSquare
local UpdateIconTexture = BBF.UpdateIconTexture
local UpdateOption = BBF.UpdateOption
local UpdateSliderRange = BBF.UpdateSliderRange
local addOrUpdateEntry = BBF.addOrUpdateEntry
local applyRightClickScript = BBF.applyRightClickScript
local cancelFunc = BBF.cancelFunc
local cleanUpEntry = BBF.cleanUpEntry
local createOrUpdateTextLineButton = BBF.createOrUpdateTextLineButton
local deleteEntry = BBF.deleteEntry
local formatSliderValue = BBF.formatSliderValue
local getDisplayTextForSetting = BBF.getDisplayTextForSetting
local getSortedNpcList = BBF.getSortedNpcList
local matchesQuery = BBF.matchesQuery
local opacityFunc = BBF.opacityFunc
local processNextBatch = BBF.processNextBatch
local refreshList = BBF.refreshList
local searchList = BBF.searchList
local swatchFunc = BBF.swatchFunc
local updateBackgroundColors = BBF.updateBackgroundColors
local updateColors = BBF.updateColors
local updateRowPreview = BBF.updateRowPreview


-- Import cross-tab functions from BBF namespace
local guiProfiles = function(...) if BBF.guiProfiles then return BBF.guiProfiles(...) end end
local guiGeneralTab = function(...) if BBF.guiGeneralTab then return BBF.guiGeneralTab(...) end end
local guiPositionAndScale = function(...) if BBF.guiPositionAndScale then return BBF.guiPositionAndScale(...) end end
local guiFrameAuras = function(...) if BBF.guiFrameAuras then return BBF.guiFrameAuras(...) end end
local guiFrameLook = function(...) if BBF.guiFrameLook then return BBF.guiFrameLook(...) end end
local guiCastbars = function(...) if BBF.guiCastbars then return BBF.guiCastbars(...) end end
local guiImportAndExport = function(...) if BBF.guiImportAndExport then return BBF.guiImportAndExport(...) end end
local guiMisc = function(...) if BBF.guiMisc then return BBF.guiMisc(...) end end
local guiChatFrame = function(...) if BBF.guiChatFrame then return BBF.guiChatFrame(...) end end
local guiCooldownManager = function(...) if BBF.guiCooldownManager then return BBF.guiCooldownManager(...) end end
local guiCustomCode = function(...) if BBF.guiCustomCode then return BBF.guiCustomCode(...) end end
local guiSupport = function(...) if BBF.guiSupport then return BBF.guiSupport(...) end end
local guiMidnight = function(...) if BBF.guiMidnight then return BBF.guiMidnight(...) end end

local function guiPositionAndScale()

    ----------------------
    -- Advanced settings
    ----------------------
    local firstLineX = 53
    local firstLineY = -65
    local secondLineX = 222
    local secondLineY = -360
    local thirdLineX = 391
    local thirdLineY = -655
    local fourthLineX = 560

    local BetterBlizzFramesSubPanel = CreateFrame("Frame")
    BetterBlizzFramesSubPanel.name = L["Module_Name_Advanced"]
    BetterBlizzFramesSubPanel.parent = BetterBlizzFrames.name
    --InterfaceOptions_AddCategory(BetterBlizzFramesSubPanel)
    local advancedSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, BetterBlizzFramesSubPanel, BetterBlizzFramesSubPanel.name, BetterBlizzFramesSubPanel.name)
    advancedSubCategory.ID = BetterBlizzFramesSubPanel.name;
    BBF.category.AdvancedSettings = BetterBlizzFramesSubPanel.name
    CreateTitle(BetterBlizzFramesSubPanel)

    local bgImg = BetterBlizzFramesSubPanel:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", BetterBlizzFramesSubPanel, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)





    local scrollFrame = CreateFrame("ScrollFrame", nil, BetterBlizzFramesSubPanel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(700, 612)
    scrollFrame:SetPoint("CENTER", BetterBlizzFramesSubPanel, "CENTER", -20, 3)

    local contentFrame = CreateFrame("Frame", nil, scrollFrame)
    contentFrame.name = BetterBlizzFramesSubPanel.name
    contentFrame:SetSize(680, 520)
    scrollFrame:SetScrollChild(contentFrame)

    local mainGuiAnchor2 = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor2:SetPoint("TOPLEFT", 55, 20)
    mainGuiAnchor2:SetText(" ")

 --[[
    ----------------------
    -- Focus Target
    ----------------------
    local anchorFocusTarget = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorFocusTarget:SetPoint("CENTER", mainGuiAnchor2, "CENTER", secondLineX, firstLineY)
    anchorFocusTarget:SetText(L["Focus_ToT"])

    CreateBorderBox(anchorFocusTarget)

    local focusTargetFrameIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    focusTargetFrameIcon:SetAtlas("greencross")
    focusTargetFrameIcon:SetSize(32, 32)
    focusTargetFrameIcon:SetPoint("BOTTOM", anchorFocusTarget, "TOP", 0, 0)
    focusTargetFrameIcon:SetTexCoord(0.1953125, 0.8046875, 0.1953125, 0.8046875)

    local focusToTScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.1, "focusToTScale")
    focusToTScale:SetPoint("TOP", anchorFocusTarget, "BOTTOM", 0, -15)

    local focusToTXPos = CreateSlider(contentFrame, L["X_Offset"], -100, 100, 1, "focusToTXPos", "X")
    focusToTXPos:SetPoint("TOP", focusToTScale, "BOTTOM", 0, -15)

    local focusToTYPos = CreateSlider(contentFrame, L["Y_Offset"], -100, 100, 1, "focusToTYPos", "Y")
    focusToTYPos:SetPoint("TOP", focusToTXPos, "BOTTOM", 0, -15)

    local focusToTDropdown = CreateAnchorDropdown(
        "focusToTDropdown",
        contentFrame,
        L["Select_Anchor_Point"],
        "focusToTAnchor",
        function(arg1) 
            BBF.MoveToTFrames()
        end,
        { anchorFrame = focusToTYPos, x = -16, y = -35, label = L["Anchor"] }
    )

    local combatIndicatorEnemyOnly = CreateCheckbox("combatIndicatorEnemyOnly", L["Enemies_Only"], contentFrame)
    combatIndicatorEnemyOnly:SetPoint("TOPLEFT", focusToTDropdown, "BOTTOMLEFT", 16, pixelsBetweenBoxes)
 
 ]]
 


 --[[
    ----------------------
    -- Pet Frame
    ----------------------
    local anchorPetFrame = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorPetFrame:SetPoint("CENTER", mainGuiAnchor2, "CENTER", thirdLineX, firstLineY)
    anchorPetFrame:SetText(L["Pet_Frame"])

    CreateBorderBox(anchorPetFrame)

    local partyFrameIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    partyFrameIcon:SetAtlas("greencross")
    partyFrameIcon:SetSize(32, 32)
    partyFrameIcon:SetPoint("BOTTOM", anchorPetFrame, "TOP", 0, 0)
    partyFrameIcon:SetTexCoord(0.1953125, 0.8046875, 0.1953125, 0.8046875)

    local petFrameScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.1, "petFrameScale")
    petFrameScale:SetPoint("TOP", anchorPetFrame, "BOTTOM", 0, -15)

    local petFrameXPos = CreateSlider(contentFrame, L["X_Offset"], -100, 100, 1, "petFrameXPos", "X")
    petFrameXPos:SetPoint("TOP", petFrameScale, "BOTTOM", 0, -15)

    local petFrameYPos = CreateSlider(contentFrame, L["Y_Offset"], -100, 100, 1, "petFrameYPos", "Y")
    petFrameYPos:SetPoint("TOP", petFrameXPos, "BOTTOM", 0, -15)

    local petFrameDropdown = CreateAnchorDropdown(
        "petFrameDropdown",
        contentFrame,
        L["Select_Anchor_Point"],
        "petFrameAnchor",
        function(arg1) 
            BBF.MoveToTFrames()
        end,
        { anchorFrame = petFrameYPos, x = -16, y = -35, label = L["Anchor"] }
    )
 
 ]]
 



   ----------------------
    -- Absorb Indicator
    ----------------------
    local anchorSubAbsorb = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubAbsorb:SetPoint("CENTER", mainGuiAnchor2, "CENTER", fourthLineX - 30, firstLineY)
    anchorSubAbsorb:SetText(L["Absorb_Indicator"])

    --CreateBorderBox(anchorSubAbsorb)
    CreateBorderedFrame(anchorSubAbsorb, 200, 293, 0, -98, BetterBlizzFramesSubPanel)

    local absorbIndicator = contentFrame:CreateTexture(nil, "ARTWORK")
    absorbIndicator:SetAtlas("ParagonReputation_Glow")
    absorbIndicator:SetSize(56, 56)
    absorbIndicator:SetPoint("BOTTOM", anchorSubAbsorb, "TOP", -1, -10)
    CreateTooltip(absorbIndicator, L["Tooltip_Absorb_Indicator"])

    local absorbIndicatorScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.01, "absorbIndicatorScale")
    absorbIndicatorScale:SetPoint("TOP", anchorSubAbsorb, "BOTTOM", 0, -15)

    local absorbIndicatorXPos = CreateSlider(contentFrame, L["X_Offset"], -100, 100, 1, "playerAbsorbXPos", "X")
    absorbIndicatorXPos:SetPoint("TOP", absorbIndicatorScale, "BOTTOM", 0, -15)

    local absorbIndicatorYPos = CreateSlider(contentFrame, L["Y_Offset"], -100, 100, 1, "playerAbsorbYPos", "Y")
    absorbIndicatorYPos:SetPoint("TOP", absorbIndicatorXPos, "BOTTOM", 0, -15)

    local playerAbsorbAnchorDropdown = CreateAnchorDropdown(
        "playerAbsorbAnchorDropdown",
        contentFrame,
        L["Select_Anchor_Point"],
        "playerAbsorbAnchor",
        function(arg1)
        BBF.AbsorbCaller()
    end,
        { anchorFrame = absorbIndicatorYPos, x = -16, y = -35, label = L["Anchor"] }
    )

    local absorbIndicatorTestMode = CreateCheckbox("absorbIndicatorTestMode", L["Test"], contentFrame, nil, BBF.AbsorbCaller)
    absorbIndicatorTestMode:SetPoint("TOPLEFT", playerAbsorbAnchorDropdown, "BOTTOMLEFT", 10, pixelsBetweenBoxes)

    local absorbIndicatorFlipIconText = CreateCheckbox("absorbIndicatorFlipIconText", L["Flip_Icon_Text"], contentFrame, nil, BBF.AbsorbCaller)
    absorbIndicatorFlipIconText:SetPoint("LEFT", absorbIndicatorTestMode.text, "RIGHT", 5, 0)




--[[
    local absorbIndicatorEnemyOnly = CreateCheckbox("absorbIndicatorEnemyOnly", L["Enemy_Only"], contentFrame)
    absorbIndicatorEnemyOnly:SetPoint("TOPLEFT", absorbIndicatorTestMode, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local absorbIndicatorOnPlayersOnly = CreateCheckbox("absorbIndicatorOnPlayersOnly", L["Players_Only"], contentFrame)
    absorbIndicatorOnPlayersOnly:SetPoint("TOPLEFT", absorbIndicatorEnemyOnly, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

]]


    --
    local playerAbsorbAmount = CreateCheckbox("playerAbsorbAmount", L["Player"], contentFrame, nil, BBF.AbsorbCaller)
    playerAbsorbAmount:SetPoint("TOPLEFT", absorbIndicatorTestMode, "BOTTOMLEFT", -5, -14)
    CreateTooltip(playerAbsorbAmount, L["Tooltip_Absorb_Show_Player"])

    local playerAbsorbIcon = CreateCheckbox("playerAbsorbIcon", L["Icon"], contentFrame, nil, BBF.AbsorbCaller)
    playerAbsorbIcon:SetPoint("TOPLEFT", playerAbsorbAmount, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(playerAbsorbIcon, L["Tooltip_Absorb_Icon"])

    local targetAbsorbAmount = CreateCheckbox("targetAbsorbAmount", L["Target"], contentFrame, nil, BBF.AbsorbCaller)
    targetAbsorbAmount:SetPoint("LEFT", playerAbsorbAmount.Text, "RIGHT", 5, 0)
    CreateTooltip(targetAbsorbAmount, L["Tooltip_Absorb_Show_Target"])

    local targetAbsorbIcon = CreateCheckbox("targetAbsorbIcon", L["Icon"], contentFrame, nil, BBF.AbsorbCaller)
    targetAbsorbIcon:SetPoint("TOPLEFT", targetAbsorbAmount, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(targetAbsorbIcon, L["Tooltip_Absorb_Icon"])

    local focusAbsorbAmount = CreateCheckbox("focusAbsorbAmount", L["Focus"], contentFrame, nil, BBF.AbsorbCaller)
    focusAbsorbAmount:SetPoint("LEFT", targetAbsorbAmount.Text, "RIGHT", 5, 0)
    CreateTooltip(focusAbsorbAmount, L["Tooltip_Absorb_Show_Focus"])

    local focusAbsorbIcon = CreateCheckbox("focusAbsorbIcon", L["Icon"], contentFrame, nil, BBF.AbsorbCaller)
    focusAbsorbIcon:SetPoint("TOPLEFT", focusAbsorbAmount, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(focusAbsorbIcon, L["Tooltip_Absorb_Icon"])










    --------------------------
    -- Combat indicator
    ----------------------
    local anchorSubOutOfCombat = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubOutOfCombat:SetPoint("CENTER", mainGuiAnchor2, "CENTER", secondLineX-145, firstLineY)
    anchorSubOutOfCombat:SetText(L["Combat_Indicator"])

    --CreateBorderBox(anchorSubOutOfCombat)
    CreateBorderedFrame(anchorSubOutOfCombat, 200, 293, 0, -98, BetterBlizzFramesSubPanel)

    local combatIconSub = contentFrame:CreateTexture(nil, "ARTWORK")
    combatIconSub:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
    combatIconSub:SetSize(34, 34)
    combatIconSub:SetPoint("BOTTOM", anchorSubOutOfCombat, "TOP", 0, 1)
    CreateTooltip(combatIconSub, L["Tooltip_Combat_Indicator"])

    local combatIndicatorScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.01, "combatIndicatorScale")
    combatIndicatorScale:SetPoint("TOP", anchorSubOutOfCombat, "BOTTOM", 0, -15)

    local combatIndicatorXPos = CreateSlider(contentFrame, L["X_Offset"], -50, 50, 1, "combatIndicatorXPos", "X")
    combatIndicatorXPos:SetPoint("TOP", combatIndicatorScale, "BOTTOM", 0, -15)

    local combatIndicatorYPos = CreateSlider(contentFrame, L["Y_Offset"], -50, 50, 1, "combatIndicatorYPos", "Y")
    combatIndicatorYPos:SetPoint("TOP", combatIndicatorXPos, "BOTTOM", 0, -15)

    local combatIndicatorDropdown = CreateAnchorDropdown(
        "combatIndicatorDropdown",
        contentFrame,
        L["Select_Anchor_Point"],
        "combatIndicatorAnchor",
        function(arg1)
            BBF.CombatIndicatorCaller()
        end,
        { anchorFrame = combatIndicatorYPos, x = -16, y = -35, label = L["Anchor"] }
    )

    local combatIndicatorArenaOnly = CreateCheckbox("combatIndicatorArenaOnly", L["Arena_Only"], contentFrame)
    combatIndicatorArenaOnly:SetPoint("TOPLEFT", combatIndicatorDropdown, "BOTTOMLEFT", 5, pixelsBetweenBoxes)
    combatIndicatorArenaOnly:HookScript("OnClick", function(self)
        BBF.CombatIndicatorCaller()
    end)
    CreateTooltip(combatIndicatorArenaOnly, L["Tooltip_Arena_Only"])

    local combatIndicatorShowSap = CreateCheckbox("combatIndicatorShowSap", L["No_Combat"], contentFrame)
    combatIndicatorShowSap:SetPoint("TOPLEFT", combatIndicatorArenaOnly, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    combatIndicatorShowSap:HookScript("OnClick", function(self)
        BBF.CombatIndicatorCaller()
    end)
    CreateTooltip(combatIndicatorShowSap, L["Tooltip_No_Combat"])

    local combatIndicatorShowSwords = CreateCheckbox("combatIndicatorShowSwords", L["In_Combat"], contentFrame)
    combatIndicatorShowSwords:SetPoint("LEFT", combatIndicatorShowSap.Text, "RIGHT", 5, 0)
    combatIndicatorShowSwords:HookScript("OnClick", function(self)
        BBF.CombatIndicatorCaller()
    end)
    CreateTooltip(combatIndicatorShowSwords, L["Tooltip_In_Combat"])

    local combatIndicatorPlayersOnly = CreateCheckbox("combatIndicatorPlayersOnly", L["Players_Only"], contentFrame)
    combatIndicatorPlayersOnly:SetPoint("LEFT", combatIndicatorArenaOnly.Text, "RIGHT", 5, 0)
    combatIndicatorPlayersOnly:HookScript("OnClick", function(self)
        BBF.CombatIndicatorCaller()
    end)
    CreateTooltip(combatIndicatorPlayersOnly, L["Tooltip_Players_Only"])

    local playerCombatIndicator = CreateCheckbox("playerCombatIndicator", L["Player"], contentFrame)
    playerCombatIndicator:SetPoint("TOPLEFT", combatIndicatorShowSap, "BOTTOMLEFT", -5, -10)
    playerCombatIndicator:HookScript("OnClick", function(self)
        BBF.CombatIndicatorCaller()
    end)

    local targetCombatIndicator = CreateCheckbox("targetCombatIndicator", L["Target"], contentFrame)
    targetCombatIndicator:SetPoint("LEFT", playerCombatIndicator.Text, "RIGHT", 5, 0)
    targetCombatIndicator:HookScript("OnClick", function(self)
        BBF.CombatIndicatorCaller()
    end)

    local focusCombatIndicator = CreateCheckbox("focusCombatIndicator", L["Focus"], contentFrame)
    focusCombatIndicator:SetPoint("LEFT", targetCombatIndicator.Text, "RIGHT", 5, 0)
    focusCombatIndicator:HookScript("OnClick", function(self)
        BBF.CombatIndicatorCaller()
    end)


    --------------------------
    -- Healer Indicator
    ----------------------
    local anchorSubHealerIndicator = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubHealerIndicator:SetPoint("CENTER", mainGuiAnchor2, "CENTER", secondLineX+81, firstLineY)
    anchorSubHealerIndicator:SetText(L["Healer_Indicator"])

    --CreateBorderBox(anchorSubHealerIndicator)
    CreateBorderedFrame(anchorSubHealerIndicator, 200, 293, 0, -98, BetterBlizzFramesSubPanel)

    local healerIconSub = contentFrame:CreateTexture(nil, "ARTWORK")
    healerIconSub:SetAtlas("bags-icon-addslots")
    healerIconSub:SetSize(34, 34)
    healerIconSub:SetPoint("BOTTOM", anchorSubHealerIndicator, "TOP", 0, 1)
    CreateTooltip(healerIconSub, L["Tooltip_Healer_Indicator"])

    local healerIndicatorScale = CreateSlider(contentFrame, L["Size"], 0.8, 2.5, 0.01, "healerIndicatorScale")
    healerIndicatorScale:SetPoint("TOP", anchorSubHealerIndicator, "BOTTOM", 0, -15)

    local healerIndicatorXPos = CreateSlider(contentFrame, L["X_Offset"], -50, 50, 1, "healerIndicatorXPos", "X")
    healerIndicatorXPos:SetPoint("TOP", healerIndicatorScale, "BOTTOM", 0, -15)

    local healerIndicatorYPos = CreateSlider(contentFrame, L["Y_Offset"], -50, 50, 1, "healerIndicatorYPos", "Y")
    healerIndicatorYPos:SetPoint("TOP", healerIndicatorXPos, "BOTTOM", 0, -15)

    local healerIndicatorDropdown = CreateAnchorDropdown(
        "healerIndicatorDropdown",
        contentFrame,
        L["Select_Anchor_Point"],
        "healerIndicatorAnchor",
        function(arg1)
            BBF.HealerIndicatorCaller()
        end,
        { anchorFrame = healerIndicatorYPos, x = -16, y = -35, label = L["Anchor"] }
    )

    local healerIndicatorIcon = CreateCheckbox("healerIndicatorIcon", L["Icon"], contentFrame)
    healerIndicatorIcon:SetPoint("TOPLEFT", healerIndicatorDropdown, "BOTTOMLEFT", 24, pixelsBetweenBoxes)
    healerIndicatorIcon:HookScript("OnClick", function(self)
        if self:GetChecked() and not BetterBlizzFramesDB.healerIndicator then
            BetterBlizzFramesDB.healerIndicator = true
        end
        BBF.HealerIndicatorCaller()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltip(healerIndicatorIcon, L["Tooltip_Healer_Icon_Show"])

    local healerIndicatorPortrait = CreateCheckbox("healerIndicatorPortrait", L["Portrait"], contentFrame)
    healerIndicatorPortrait:SetPoint("LEFT", healerIndicatorIcon.Text, "RIGHT", 5, 0)
    healerIndicatorPortrait:HookScript("OnClick", function(self)
        if self:GetChecked() and not BetterBlizzFramesDB.healerIndicator then
            BetterBlizzFramesDB.healerIndicator = true
        end
        BBF.HealerIndicatorCaller()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltip(healerIndicatorPortrait, L["Tooltip_Healer_Portrait_Change"])



    --------------------------
    -- Racial indicator
    ----------------------
    local anchorSubracialIndicator = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubracialIndicator:SetPoint("CENTER", mainGuiAnchor2, "CENTER", secondLineX-145, secondLineY - 15)
    anchorSubracialIndicator:SetText(L["Racial_Indicator"])

    --CreateBorderBox(anchorSubracialIndicator)
    CreateBorderedFrame(anchorSubracialIndicator, 200, 293, 0, -98, BetterBlizzFramesSubPanel)

    local racialIndicatorIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    racialIndicatorIcon:SetTexture("Interface\\Icons\\ability_ambush")
    racialIndicatorIcon:SetSize(34, 34)
    racialIndicatorIcon:SetPoint("BOTTOM", anchorSubracialIndicator, "TOP", 0, 1)
    CreateTooltip(racialIndicatorIcon, L["Tooltip_Racial_Indicator_Enable"])

    local racialIndicatorScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.01, "racialIndicatorScale")
    racialIndicatorScale:SetPoint("TOP", anchorSubracialIndicator, "BOTTOM", 0, -15)

    local racialIndicatorXPos = CreateSlider(contentFrame, L["X_Offset"], -50, 50, 1, "racialIndicatorXPos", "X")
    racialIndicatorXPos:SetPoint("TOP", racialIndicatorScale, "BOTTOM", 0, -15)

    local racialIndicatorYPos = CreateSlider(contentFrame, L["Y_Offset"], -50, 50, 1, "racialIndicatorYPos", "Y")
    racialIndicatorYPos:SetPoint("TOP", racialIndicatorXPos, "BOTTOM", 0, -15)

    local racialIndicatorOrc = CreateCheckbox("racialIndicatorOrc", L["Orc"], contentFrame)
    racialIndicatorOrc:SetPoint("TOPLEFT", racialIndicatorYPos, "BOTTOMLEFT", 5, -5)
    racialIndicatorOrc:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(racialIndicatorOrc, L["Tooltip_Show_Orc"])

    local racialIndicatorHuman = CreateCheckbox("racialIndicatorHuman", L["Human"], contentFrame)
    racialIndicatorHuman:SetPoint("TOPLEFT", racialIndicatorOrc, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    racialIndicatorHuman:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(racialIndicatorHuman, L["Tooltip_Show_Human"])

    local racialIndicatorDwarf = CreateCheckbox("racialIndicatorDwarf", L["Dwarf"], contentFrame)
    racialIndicatorDwarf:SetPoint("TOPLEFT", racialIndicatorHuman, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    racialIndicatorDwarf:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(racialIndicatorDwarf, L["Tooltip_Show_Dwarf"])

    local racialIndicatorNelf = CreateCheckbox("racialIndicatorNelf", L["Night_Elf"], contentFrame)
    racialIndicatorNelf:SetPoint("LEFT", racialIndicatorOrc.Text, "RIGHT", 25, 0)
    racialIndicatorNelf:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(racialIndicatorNelf, L["Tooltip_Night_Elf"])

    local racialIndicatorUndead = CreateCheckbox("racialIndicatorUndead", L["Undead"], contentFrame)
    racialIndicatorUndead:SetPoint("TOPLEFT", racialIndicatorNelf, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    racialIndicatorUndead:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(racialIndicatorUndead, L["Tooltip_Undead"])

    local racialIndicatorDarkIronDwarf = CreateCheckbox("racialIndicatorDarkIronDwarf", L["DI_Dwarf"], contentFrame)
    racialIndicatorDarkIronDwarf:SetPoint("TOPLEFT", racialIndicatorUndead, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    racialIndicatorDarkIronDwarf:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(racialIndicatorDarkIronDwarf, L["Tooltip_DI_Dwarf"])

    local targetRacialIndicator = CreateCheckbox("targetRacialIndicator", L["Target"], contentFrame)
    targetRacialIndicator:SetPoint("TOPLEFT", racialIndicatorDwarf, "BOTTOMLEFT", 0, -10)
    targetRacialIndicator:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(targetRacialIndicator, L["Tooltip_Target"])

    local focusRacialIndicator = CreateCheckbox("focusRacialIndicator", L["Focus"], contentFrame)
    focusRacialIndicator:SetPoint("LEFT", targetRacialIndicator.Text, "RIGHT", 12, 0)
    focusRacialIndicator:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(focusRacialIndicator, L["Tooltip_Focus"])

    local racialIndicatorRaceIcons = CreateCheckbox("racialIndicatorRaceIcons", L["Race_Icon"], contentFrame)
    racialIndicatorRaceIcons:SetPoint("TOPLEFT", targetRacialIndicator, "BOTTOMLEFT", 12, pixelsBetweenBoxes)
    racialIndicatorRaceIcons:HookScript("OnClick", function(self)
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltip(racialIndicatorRaceIcons, L["Tooltip_Race_Icon"])

    ----------------------
    -- Castbar Interrupt Icon
    ----------------------
    local anchorSubInterruptIcon = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubInterruptIcon:SetPoint("CENTER", mainGuiAnchor2, "CENTER", secondLineX+81, secondLineY-15)
    anchorSubInterruptIcon:SetText(L["Interrupt_Icon_AS"])

    --CreateBorderBox(anchorSubInterruptIcon)
    CreateBorderedFrame(anchorSubInterruptIcon, 200, 293, 0, -98, BetterBlizzFramesSubPanel)

    local castBarInterruptIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    castBarInterruptIcon:SetTexture("Interface\\Icons\\ability_kick")
    castBarInterruptIcon:SetSize(34, 34)
    castBarInterruptIcon:SetPoint("BOTTOM", anchorSubInterruptIcon, "TOP", 0, 0)
    CreateTooltip(castBarInterruptIcon, L["Show_Interrupt_Icon_Next_Castbar"])

    local castBarInterruptIconScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.01, "castBarInterruptIconScale")
    castBarInterruptIconScale:SetPoint("TOP", anchorSubInterruptIcon, "BOTTOM", 0, -15)

    local castBarInterruptIconXPos = CreateSlider(contentFrame, L["X_Offset"], -100, 100, 1, "castBarInterruptIconXPos", "X")
    castBarInterruptIconXPos:SetPoint("TOP", castBarInterruptIconScale, "BOTTOM", 0, -15)

    local castBarInterruptIconYPos = CreateSlider(contentFrame, L["Y_Offset"], -100, 100, 1, "castBarInterruptIconYPos", "Y")
    castBarInterruptIconYPos:SetPoint("TOP", castBarInterruptIconXPos, "BOTTOM", 0, -15)

    local castBarInterruptIconAnchorDropdown = CreateAnchorDropdown(
        "castBarInterruptIconAnchorDropdown",
        contentFrame,
        L["Select_Anchor_Point"],
        "castBarInterruptIconAnchor",
        function(arg1)
        BBF.UpdateInterruptIconSettings()
    end,
        { anchorFrame = castBarInterruptIconYPos, x = -16, y = -35, label = L["Anchor"] }
    )

    local castBarInterruptIconTarget = CreateCheckbox("castBarInterruptIconTarget", L["Target"], contentFrame, nil, BBF.UpdateInterruptIconSettings)
    castBarInterruptIconTarget:SetPoint("TOPLEFT", castBarInterruptIconAnchorDropdown, "BOTTOMLEFT", 24, pixelsBetweenBoxes)
    CreateTooltipTwo(castBarInterruptIconTarget, L["Show_On_Target"])

    local castBarInterruptIconFocus = CreateCheckbox("castBarInterruptIconFocus", L["Focus"], contentFrame, nil, BBF.UpdateInterruptIconSettings)
    castBarInterruptIconFocus:SetPoint("LEFT", castBarInterruptIconTarget.text, "RIGHT", 5, 0)
    CreateTooltipTwo(castBarInterruptIconFocus, L["Show_On_Focus"])

    local castBarInterruptIconShowActiveOnly = CreateCheckbox("castBarInterruptIconShowActiveOnly", L["Tooltip_Only_Show_If_Available_Desc"], contentFrame, nil, BBF.UpdateInterruptIconSettings)
    castBarInterruptIconShowActiveOnly:SetPoint("TOPLEFT", castBarInterruptIconTarget, "BOTTOMLEFT", -28, pixelsBetweenBoxes)
    CreateTooltipTwo(castBarInterruptIconShowActiveOnly, L["Tooltip_Only_Show_If_Available_Desc"], L["Tooltip_Only_Show_If_Available_Desc"])

    local interruptIconBorder = CreateCheckbox("interruptIconBorder", L["Border_Status_Color"], contentFrame, nil, BBF.UpdateInterruptIconSettings)
    interruptIconBorder:SetPoint("TOPLEFT", castBarInterruptIconShowActiveOnly, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(interruptIconBorder, L["Border_Status_Color"], L["Tooltip_Border_Status_Color_Desc"])

    ----------------------
    -- Kick Popup
    ----------------------
    local anchorSubKickPopup = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubKickPopup:SetPoint("CENTER", mainGuiAnchor2, "CENTER", fourthLineX - 30, secondLineY - 15)
    anchorSubKickPopup:SetText(L["Kick_Popup"])

    CreateBorderedFrame(anchorSubKickPopup, 200, 293, 0, -98, BetterBlizzFramesSubPanel)

    local kickPopupIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    kickPopupIcon:SetTexture("Interface\\Icons\\ability_kick")
    kickPopupIcon:SetSize(34, 34)
    kickPopupIcon:SetPoint("BOTTOM", anchorSubKickPopup, "TOP", 0, 0)
    CreateTooltip(kickPopupIcon, L["Tooltip_Kick_Popup_Desc"])

    local kickPopupScale = CreateSlider(contentFrame, L["Size"], 0.5, 2, 0.01, "kickPopupScale", nil, 72)
    kickPopupScale:SetPoint("TOP", anchorSubKickPopup, "BOTTOM", -35, -15)

    local kickPopupIconScale = CreateSlider(contentFrame, L["Icon"], 0.5, 2.5, 0.01, "kickPopupIconScale", nil, 72)
    kickPopupIconScale:SetPoint("LEFT", kickPopupScale, "RIGHT", 0, 0)

    local kickPopupXPos = CreateSlider(contentFrame, L["X_Offset"], -500, 500, 1, "kickPopupXPos", "X")
    kickPopupXPos:SetPoint("TOP", kickPopupScale, "BOTTOM", 35, -15)

    local kickPopupYPos = CreateSlider(contentFrame, L["Y_Offset"], -500, 500, 1, "kickPopupYPos", "Y")
    kickPopupYPos:SetPoint("TOP", kickPopupXPos, "BOTTOM", 0, -15)

    local kickPopupFontDropdown = CreateFontDropdown(
        "kickPopupFont",
        contentFrame,
        L["Select_Font"],
        "kickPopupFont",
        function(fontPath)
            BBF.UpdateKickPopupFont()
        end,
        { anchorFrame = kickPopupYPos, x = -12, y = -13, label = L["Font"] },
        125,
        nil,
        "TOP"
    )

    local kickPopupFontOutline = CreateCheckbox("kickPopupFontOutline", L["Outline_Label"], contentFrame)
    kickPopupFontOutline:SetPoint("LEFT", kickPopupFontDropdown, "RIGHT", -2, 8)
    kickPopupFontOutline:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" and self:GetChecked() then
            local current = BetterBlizzFramesDB.kickPopupFontOutline
            if current == "THICKOUTLINE" then
                BetterBlizzFramesDB.kickPopupFontOutline = "OUTLINE"
            else
                BetterBlizzFramesDB.kickPopupFontOutline = "THICKOUTLINE"
            end
            BBF.UpdateKickPopupFont()
        end
    end)
    kickPopupFontOutline:HookScript("OnClick", function()
        BBF.UpdateKickPopupFont()
    end)
    CreateTooltip(kickPopupFontOutline, L["Tooltip_Outline_Toggle"])

    local kickPopupFontShadow = CreateCheckbox("kickPopupFontShadow", L["Shadow"], contentFrame, nil, function()
        BBF.UpdateKickPopupFont()
    end)
    kickPopupFontShadow:SetPoint("TOPLEFT", kickPopupFontOutline, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local kickPopupTestMode = CreateCheckbox("kickPopupTestMode", L["Test"], contentFrame, nil, function()
        BBF.TestKickPopup(BetterBlizzFramesDB.kickPopupTestMode)
    end)
    kickPopupTestMode:SetPoint("TOPLEFT", kickPopupFontDropdown, "BOTTOMLEFT", 26, -2)

    local kickPopupTextColor = CreateColorBox(contentFrame, "kickPopupTextColor", L["Kick_Popup_Text_Color"], function()
        BBF.UpdateKickPopupFont()
    end)
    kickPopupTextColor:SetPoint("LEFT", kickPopupTestMode.text, "RIGHT", 2, 0)

    local kickPopupPlaySound = CreateCheckbox("kickPopupPlaySound", L["Kick_Popup_Play_Sound"], contentFrame)
    kickPopupPlaySound:SetPoint("TOPLEFT", kickPopupTestMode, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(kickPopupPlaySound, L["Tooltip_Kick_Popup_Play_Sound_Desc"])
    kickPopupPlaySound:HookScript("OnClick", function(self)
        if self:GetChecked() then
            local channel = BetterBlizzFramesDB.kickPopupSoundChannel or "Master"
            local soundName = BetterBlizzFramesDB.kickPopupSoundName
            if soundName then
                local path = LSM:Fetch(LSM.MediaType.SOUND, soundName)
                if path then PlaySoundFile(path, channel) end
            end
        end
    end)

    local kickPopupSauce = CreateCheckbox("kickPopupSauce", L["Kick_Popup_Sauce"], contentFrame)
    kickPopupSauce:SetPoint("LEFT", kickPopupPlaySound.text, "RIGHT", 2, 0)
    CreateTooltipTwo(kickPopupSauce, L["Kick_Popup_Add_Sauce"], L["Tooltip_Kick_Popup_Sauce_Desc"])
    kickPopupSauce:HookScript("OnClick", function()
        if BetterBlizzFramesDB.kickPopupTestMode then
            BBF.TestKickPopup(true)
        end
    end)

    local kickPopupSoundNameDropdown = LibDD:Create_UIDropDownMenu("kickPopupSoundNameDropdown", contentFrame)
    BBF.kickPopupSoundNameDropdown = kickPopupSoundNameDropdown
    LibDD:UIDropDownMenu_SetWidth(kickPopupSoundNameDropdown, 65)
    local fileID = BetterBlizzFramesDB.kickPopupSoundFileID
    if fileID and fileID ~= 0 then
        LibDD:UIDropDownMenu_SetText(kickPopupSoundNameDropdown, "ID: " .. fileID)
    else
        LibDD:UIDropDownMenu_SetText(kickPopupSoundNameDropdown, BetterBlizzFramesDB.kickPopupSoundName or "Lossa Countered")
    end
    LibDD:UIDropDownMenu_Initialize(kickPopupSoundNameDropdown, function(self, level, menuList)
        local sounds = LSM:HashTable(LSM.MediaType.SOUND)
        local sorted = {}
        for name in pairs(sounds) do
            table.insert(sorted, name)
        end
        table.sort(sorted)
        for _, soundName in ipairs(sorted) do
            local info = LibDD:UIDropDownMenu_CreateInfo()
            info.text = soundName
            info.arg1 = soundName
            info.func = function(self, arg1)
                BetterBlizzFramesDB.kickPopupSoundName = arg1
                BetterBlizzFramesDB.kickPopupSoundFileID = nil
                LibDD:UIDropDownMenu_SetText(kickPopupSoundNameDropdown, arg1)
                local channel = BetterBlizzFramesDB.kickPopupSoundChannel or "Master"
                local path = LSM:Fetch(LSM.MediaType.SOUND, arg1)
                if path then PlaySoundFile(path, channel) end
            end
            info.checked = (BetterBlizzFramesDB.kickPopupSoundName == soundName)
            LibDD:UIDropDownMenu_AddButton(info)
        end
    end)
    kickPopupSoundNameDropdown:SetPoint("TOPLEFT", kickPopupPlaySound, "BOTTOMLEFT", -42, -14)

    local kickPopupSoundNameLabel = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    kickPopupSoundNameLabel:SetPoint("BOTTOM", kickPopupSoundNameDropdown, "TOP", 0, 3)
    kickPopupSoundNameLabel:SetText(L["Kick_Popup_Sound"])

    local kickPopupSoundRightClick = CreateFrame("Button", nil, kickPopupSoundNameDropdown)
    kickPopupSoundRightClick:SetAllPoints()
    kickPopupSoundRightClick:RegisterForClicks("RightButtonUp")
    kickPopupSoundRightClick:SetScript("OnClick", function()
        StaticPopup_Show("BBF_KICK_POPUP_SOUND_ID")
    end)
    CreateTooltip(kickPopupSoundRightClick, "Right-click to enter a custom Sound ID.")

    local kickPopupSoundChannelDropdown = LibDD:Create_UIDropDownMenu("kickPopupSoundChannelDropdown", contentFrame)
    LibDD:UIDropDownMenu_SetWidth(kickPopupSoundChannelDropdown, 65)
    LibDD:UIDropDownMenu_SetText(kickPopupSoundChannelDropdown, BetterBlizzFramesDB.kickPopupSoundChannel or "Master")
    LibDD:UIDropDownMenu_Initialize(kickPopupSoundChannelDropdown, function(self, level, menuList)
        local channels = {"Master", "SFX", "Music", "Ambience", "Dialog"}
        for _, ch in ipairs(channels) do
            local info = LibDD:UIDropDownMenu_CreateInfo()
            info.text = ch
            info.arg1 = ch
            info.func = function(self, arg1)
                BetterBlizzFramesDB.kickPopupSoundChannel = arg1
                LibDD:UIDropDownMenu_SetText(kickPopupSoundChannelDropdown, arg1)
            end
            info.checked = (BetterBlizzFramesDB.kickPopupSoundChannel == ch)
            LibDD:UIDropDownMenu_AddButton(info)
        end
    end)
    kickPopupSoundChannelDropdown:SetPoint("LEFT", kickPopupSoundNameDropdown, "RIGHT", -35, 0)

    local kickPopupSoundChannelLabel = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    kickPopupSoundChannelLabel:SetPoint("BOTTOM", kickPopupSoundChannelDropdown, "TOP", 0, 3)
    kickPopupSoundChannelLabel:SetText(L["Kick_Popup_Output"])

    local function UpdateKickSoundDropdownState()
        if BetterBlizzFramesDB.kickPopupPlaySound then
            LibDD:UIDropDownMenu_EnableDropDown(kickPopupSoundNameDropdown)
            LibDD:UIDropDownMenu_EnableDropDown(kickPopupSoundChannelDropdown)
            kickPopupSoundNameDropdown:SetAlpha(1)
            kickPopupSoundChannelDropdown:SetAlpha(1)
            kickPopupSoundNameLabel:SetAlpha(1)
            kickPopupSoundChannelLabel:SetAlpha(1)
        else
            LibDD:UIDropDownMenu_DisableDropDown(kickPopupSoundNameDropdown)
            LibDD:UIDropDownMenu_DisableDropDown(kickPopupSoundChannelDropdown)
            kickPopupSoundNameDropdown:SetAlpha(0.5)
            kickPopupSoundChannelDropdown:SetAlpha(0.5)
            kickPopupSoundNameLabel:SetAlpha(0.5)
            kickPopupSoundChannelLabel:SetAlpha(0.5)
        end
    end

    kickPopupPlaySound:HookScript("OnClick", function()
        UpdateKickSoundDropdownState()
    end)

    UpdateKickSoundDropdownState()

    local reloadUiButton2 = CreateFrame("Button", nil, BetterBlizzFramesSubPanel, "UIPanelButtonTemplate")
    reloadUiButton2:SetText(L["Label_Reload_Ui"])
    reloadUiButton2:SetWidth(85)
    reloadUiButton2:SetPoint("TOP", BetterBlizzFramesSubPanel, "BOTTOMRIGHT", -140, -9)
    reloadUiButton2:SetScript("OnClick", function()
        BetterBlizzFramesDB.reopenOptions = true
        ReloadUI()
    end)

    local resetBBFButton = CreateFrame("Button", nil, BetterBlizzFramesSubPanel, "UIPanelButtonTemplate")
    resetBBFButton:SetText(L["Reset_BetterBlizzFrames"])
    resetBBFButton:SetWidth(165)
    resetBBFButton:SetPoint("RIGHT", reloadUiButton2, "LEFT", -533, 0)
    resetBBFButton:SetScript("OnClick", function()
        StaticPopup_Show("CONFIRM_RESET_BETTERBLIZZFRAMESDB")
    end)
    CreateTooltip(resetBBFButton, L["Tooltip_Full_Reset"])

    BetterBlizzFramesSubPanel.rightClickTip = BetterBlizzFramesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    BetterBlizzFramesSubPanel.rightClickTip:SetPoint("RIGHT", reloadUiButton2, "LEFT", -80, -2)
    BetterBlizzFramesSubPanel.rightClickTip:SetText("|A:smallquestbang:20:20|a" .. L["Right_Click_Slider_Tip"])
end


-- Export tab function to BBF
BBF.guiPositionAndScale = guiPositionAndScale
