local BBF = _G.BBF
if not BBF or BBF.isMidnight then return end
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

local function guiCastbars()

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

    local BetterBlizzFramesCastbars = CreateFrame("Frame")
    BetterBlizzFramesCastbars.name = L["Castbars"]
    BetterBlizzFramesCastbars.parent = BetterBlizzFrames.name
    --InterfaceOptions_AddCategory(BetterBlizzFramesCastbars)
    local castbarsSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, BetterBlizzFramesCastbars, BetterBlizzFramesCastbars.name, BetterBlizzFramesCastbars.name)
    castbarsSubCategory.ID = BetterBlizzFramesCastbars.name;
    CreateTitle(BetterBlizzFramesCastbars)

    local bgImg = BetterBlizzFramesCastbars:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", BetterBlizzFramesCastbars, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local scrollFrame = CreateFrame("ScrollFrame", nil, BetterBlizzFramesCastbars, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(700, 612)
    scrollFrame:SetPoint("CENTER", BetterBlizzFramesCastbars, "CENTER", -20, 3)

    local contentFrame = CreateFrame("Frame", nil, scrollFrame)
    contentFrame.name = BetterBlizzFramesCastbars.name
    contentFrame:SetSize(680, 520)
    scrollFrame:SetScrollChild(contentFrame)

    local mainGuiAnchor2 = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor2:SetPoint("TOPLEFT", 55, 20)
    mainGuiAnchor2:SetText(" ")

   ----------------------
    -- Party Castbars
    ----------------------
    local anchorSubPartyCastbar = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubPartyCastbar:SetPoint("CENTER", mainGuiAnchor2, "CENTER", secondLineX, firstLineY)
    anchorSubPartyCastbar:SetText(L["Party_Castbars"])

    local partyCastbarBorder = CreateBorderedFrame(anchorSubPartyCastbar, 157, 386, 0, -145, contentFrame)

    local partyCastbars = contentFrame:CreateTexture(nil, "ARTWORK")
    partyCastbars:SetAtlas("ui-castingbar-filling-channel")
    partyCastbars:SetSize(110, 13)
    partyCastbars:SetPoint("BOTTOM", anchorSubPartyCastbar, "TOP", -1, 10)

    local partyCastBarScale = CreateSlider(contentFrame, L["Size"], 0.5, 1.9, 0.01, "partyCastBarScale")
    partyCastBarScale:SetPoint("TOP", anchorSubPartyCastbar, "BOTTOM", 0, -15)

    local partyCastBarXPos = CreateSlider(contentFrame, L["X_Offset"], -200, 200, 1, "partyCastBarXPos", "X")
    partyCastBarXPos:SetPoint("TOP", partyCastBarScale, "BOTTOM", 0, -15)

    local partyCastBarYPos = CreateSlider(contentFrame, L["Y_Offset"], -200, 200, 1, "partyCastBarYPos", "Y")
    partyCastBarYPos:SetPoint("TOP", partyCastBarXPos, "BOTTOM", 0, -15)

    local partyCastBarWidth = CreateSlider(contentFrame, L["Width"], 20, 200, 1, "partyCastBarWidth")
    partyCastBarWidth:SetPoint("TOP", partyCastBarYPos, "BOTTOM", 0, -15)

    local partyCastBarHeight = CreateSlider(contentFrame, L["Height"], 5, 30, 1, "partyCastBarHeight")
    partyCastBarHeight:SetPoint("TOP", partyCastBarWidth, "BOTTOM", 0, -15)

    local partyCastBarIconScale = CreateSlider(contentFrame, L["Icon_Size"], 0.4, 2, 0.01, "partyCastBarIconScale")
    partyCastBarIconScale:SetPoint("TOP", partyCastBarHeight, "BOTTOM", 0, -15)

    local partyCastbarIconXPos = CreateSlider(contentFrame, L["Icon_x_offset"], -50, 50, 1, "partyCastbarIconXPos")
    partyCastbarIconXPos:SetPoint("TOP", partyCastBarIconScale, "BOTTOM", 0, -15)

    local partyCastbarIconYPos = CreateSlider(contentFrame, L["Icon_y_offset"], -50, 50, 1, "partyCastbarIconYPos")
    partyCastbarIconYPos:SetPoint("TOP", partyCastbarIconXPos, "BOTTOM", 0, -15)

    local partyCastBarTestMode = CreateCheckbox("partyCastBarTestMode", L["Test"], contentFrame, nil, BBF.partyCastBarTestMode)
    partyCastBarTestMode:SetPoint("TOPLEFT", partyCastbarIconYPos, "BOTTOMLEFT", 10, -4)
    CreateTooltip(partyCastBarTestMode, L["Tooltip_Castbar_Test"])

    local partyCastBarTimer = CreateCheckbox("partyCastBarTimer", L["Timer"], contentFrame, nil, BBF.partyCastBarTestMode)
    partyCastBarTimer:SetPoint("LEFT", partyCastBarTestMode.Text, "RIGHT", 10, 0)
    CreateTooltip(partyCastBarTimer, L["Tooltip_Castbar_Timer"])

    local partyCastbarSelf = CreateCheckbox("partyCastbarSelf", L["Self"], contentFrame, nil, BBF.partyCastBarTestMode)
    partyCastbarSelf:SetPoint("TOPLEFT", partyCastBarTimer, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(partyCastbarSelf, L["Tooltip_Show_Party_Castbar"])

    local showPartyCastBarIcon = CreateCheckbox("showPartyCastBarIcon", L["Icon"], contentFrame, nil, BBF.partyCastBarTestMode)
    showPartyCastBarIcon:SetPoint("TOPLEFT", partyCastBarTestMode, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    anchorSubPartyCastbar.classicCastbarsParty = CreateCheckbox("classicCastbarsParty", L["Castbar_Classic"], contentFrame, nil, BBF.partyCastBarTestMode)
    anchorSubPartyCastbar.classicCastbarsParty:SetPoint("TOPLEFT", showPartyCastBarIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(anchorSubPartyCastbar.classicCastbarsParty, L["Castbar_Classic"], L["Tooltip_Castbar_Classic_Desc"])

    anchorSubPartyCastbar.classicCastbarsParty:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local resetPartyCastbar = CreateFrame("Button", nil, contentFrame, "UIPanelButtonTemplate")
    resetPartyCastbar:SetText(L["Reset"])
    resetPartyCastbar:SetWidth(70)
    resetPartyCastbar:SetPoint("TOP", partyCastbarBorder, "BOTTOM", 0, -2)
    resetPartyCastbar:SetScript("OnClick", function()
        partyCastBarScale:SetMinMaxValues(0.5, 1.9)
        partyCastBarXPos:SetMinMaxValues(-200, 200)
        partyCastBarYPos:SetMinMaxValues(-200, 200)
        partyCastBarWidth:SetMinMaxValues(20, 200)
        partyCastBarHeight:SetMinMaxValues(5, 30)
        partyCastBarIconScale:SetMinMaxValues(0.4, 2)
        partyCastbarIconXPos:SetMinMaxValues(-50, 50)
        partyCastbarIconYPos:SetMinMaxValues(-50, 50)
        partyCastBarScale:SetValue(1)
        partyCastBarIconScale:SetValue(1)
        partyCastBarXPos:SetValue(0)
        partyCastBarYPos:SetValue(0)
        partyCastbarIconXPos:SetValue(0)
        partyCastbarIconYPos:SetValue(0)
        partyCastBarWidth:SetValue(100)
        partyCastBarHeight:SetValue(12)
        partyCastBarTimer:SetChecked(true)
        BetterBlizzFramesDB.partyCastBarTimer = true
        BBF.CastBarTimerCaller()
    end)


   ----------------------
    -- Target Castbar
    ----------------------
    local anchorSubTargetCastbar = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubTargetCastbar:SetPoint("CENTER", mainGuiAnchor2, "CENTER", thirdLineX, firstLineY)
    anchorSubTargetCastbar:SetText(L["Target_Castbar"])

    local targetCastbarBorder = CreateBorderedFrame(anchorSubTargetCastbar, 157, 386, 0, -145, contentFrame)

    local targetCastBar = contentFrame:CreateTexture(nil, "ARTWORK")
    targetCastBar:SetAtlas("ui-castingbar-tier1-empower-2x")
    targetCastBar:SetSize(110, 13)
    targetCastBar:SetPoint("BOTTOM", anchorSubTargetCastbar, "TOP", -1, 10)

    local targetCastBarScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.01, "targetCastBarScale")
    targetCastBarScale:SetPoint("TOP", anchorSubTargetCastbar, "BOTTOM", 0, -15)

    local targetCastBarXPos = CreateSlider(contentFrame, L["X_Offset"], -130, 130, 1, "targetCastBarXPos", "X")
    targetCastBarXPos:SetPoint("TOP", targetCastBarScale, "BOTTOM", 0, -15)

    local targetCastBarYPos = CreateSlider(contentFrame, L["Y_Offset"], -130, 130, 1, "targetCastBarYPos", "Y")
    targetCastBarYPos:SetPoint("TOP", targetCastBarXPos, "BOTTOM", 0, -15)

    local targetCastBarWidth = CreateSlider(contentFrame, L["Width"], 60, 220, 1, "targetCastBarWidth")
    targetCastBarWidth:SetPoint("TOP", targetCastBarYPos, "BOTTOM", 0, -15)

    local targetCastBarHeight = CreateSlider(contentFrame, L["Height"], 5, 30, 1, "targetCastBarHeight")
    targetCastBarHeight:SetPoint("TOP", targetCastBarWidth, "BOTTOM", 0, -15)

    local targetCastBarIconScale = CreateSlider(contentFrame, L["Icon_Size"], 0.4, 2, 0.01, "targetCastBarIconScale")
    targetCastBarIconScale:SetPoint("TOP", targetCastBarHeight, "BOTTOM", 0, -15)

    local targetCastbarIconXPos = CreateSlider(contentFrame, L["Icon_x_offset"], -160, 160, 1, "targetCastbarIconXPos", "X")
    targetCastbarIconXPos:SetPoint("TOP", targetCastBarIconScale, "BOTTOM", 0, -15)

    local targetCastbarIconYPos = CreateSlider(contentFrame, L["Icon_y_offset"], -160, 160, 1, "targetCastbarIconYPos", "Y")
    targetCastbarIconYPos:SetPoint("TOP", targetCastbarIconXPos, "BOTTOM", 0, -15)

    local targetStaticCastbar = CreateCheckbox("targetStaticCastbar", L["Static"], contentFrame)
    targetStaticCastbar:SetPoint("TOPLEFT", targetCastbarIconYPos, "BOTTOMLEFT", 10, -4)
    CreateTooltip(targetStaticCastbar, L["Tooltip_Castbar_Static"])

    local targetCastBarTimer = CreateCheckbox("targetCastBarTimer", L["Timer"], contentFrame, nil, BBF.CastBarTimerCaller)
    targetCastBarTimer:SetPoint("LEFT", targetStaticCastbar.Text, "RIGHT", 10, 0)
    CreateTooltip(targetCastBarTimer, L["Tooltip_Castbar_Timer"])

    local targetToTCastbarAdjustment = CreateCheckbox("targetToTCastbarAdjustment", L["ToT_Offset"], contentFrame)
    targetToTCastbarAdjustment:SetPoint("TOPLEFT", targetStaticCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(targetToTCastbarAdjustment, L["Enable_ToT_Offset"], L["Tooltip_Castbar_ToT_Offset_Desc"])

    local targetToTAdjustmentOffsetY = CreateSlider(targetToTCastbarAdjustment, L["extra"], -20, 50, 1, "targetToTAdjustmentOffsetY", "Y", 55)
    targetToTAdjustmentOffsetY:SetPoint("LEFT", targetToTCastbarAdjustment.text, "RIGHT", 2, -5)
    CreateTooltipTwo(targetToTAdjustmentOffsetY, L["Tooltip_ToT_Adjustment_Offset_Y"], L["Tooltip_Castbar_ToT_Extra_Desc"])

    targetToTCastbarAdjustment:HookScript("OnClick", function(self)
        if self:GetChecked() then
            targetToTAdjustmentOffsetY:Enable()
            targetToTAdjustmentOffsetY:SetAlpha(1)
        else
            targetToTAdjustmentOffsetY:Disable()
            targetToTAdjustmentOffsetY:SetAlpha(0.5)
        end
    end)

    local targetDetachCastbar = CreateCheckbox("targetDetachCastbar", L["Castbar_Detach"], contentFrame)
    targetDetachCastbar:SetPoint("TOPLEFT", targetToTCastbarAdjustment, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    targetDetachCastbar:HookScript("OnClick", function(self)
        if self:GetChecked() then
            targetCastBarXPos:SetMinMaxValues(-900, 900)
            targetCastBarXPos:SetValue(0)
            targetCastBarYPos:SetMinMaxValues(-900, 900)
            targetCastBarYPos:SetValue(0)
            targetToTCastbarAdjustment:Disable()
            targetToTCastbarAdjustment:SetAlpha(0.5)
            targetToTAdjustmentOffsetY:Disable()
            targetToTAdjustmentOffsetY:SetAlpha(0.5)
            targetStaticCastbar:SetChecked(false)
            BetterBlizzFramesDB.targetStaticCastbar = false
        else
            targetCastBarXPos:SetMinMaxValues(-130, 130)
            targetCastBarXPos:SetValue(0)
            targetToTCastbarAdjustment:Enable()
            targetToTCastbarAdjustment:SetAlpha(1)
            targetToTAdjustmentOffsetY:Enable()
            targetToTAdjustmentOffsetY:SetAlpha(1)
        end
        BBF.ChangeCastbarSizes()
    end)
    CreateTooltip(targetDetachCastbar, L["Tooltip_Detach_From_Frame"])

    if BetterBlizzFramesDB.targetDetachCastbar then
        targetCastBarXPos:SetMinMaxValues(-900, 900)
        targetCastBarYPos:SetMinMaxValues(-900, 900)
        targetToTCastbarAdjustment:Disable()
        targetToTCastbarAdjustment:SetAlpha(0.5)
        targetToTAdjustmentOffsetY:Disable()
        targetToTAdjustmentOffsetY:SetAlpha(0.5)
        targetStaticCastbar:SetChecked(false)
        BetterBlizzFramesDB.targetStaticCastbar = false
    end
    targetStaticCastbar:HookScript("OnClick", function(self)
        if self:GetChecked() then
            targetToTCastbarAdjustment:Disable()
            targetToTCastbarAdjustment:SetAlpha(0.5)
            targetToTAdjustmentOffsetY:Disable()
            targetToTAdjustmentOffsetY:SetAlpha(0.5)
            targetDetachCastbar:SetChecked(false)
            BetterBlizzFramesDB.targetDetachCastbar = false
        else
            targetToTCastbarAdjustment:Enable()
            targetToTCastbarAdjustment:SetAlpha(1)
            targetToTAdjustmentOffsetY:Enable()
            targetToTAdjustmentOffsetY:SetAlpha(1)
        end
    end)
    if BetterBlizzFramesDB.targetStaticCastbar then
        targetToTCastbarAdjustment:Disable()
        targetToTCastbarAdjustment:SetAlpha(0.5)
        targetToTAdjustmentOffsetY:Disable()
        targetToTAdjustmentOffsetY:SetAlpha(0.5)
        targetDetachCastbar:SetChecked(false)
        BetterBlizzFramesDB.targetDetachCastbar = false
    end

    local hideTargetCastbar = CreateCheckbox("hideTargetCastbar", L["Hide_Bar"], contentFrame, nil, BBF.ChangeCastbarSizes)
    hideTargetCastbar:SetPoint("TOPLEFT", targetDetachCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideTargetCastbar, L["Hide_Target_Castbar"], L["Hide_Target_Castbar"])

    local hideTargetCastbarIcon = CreateCheckbox("hideTargetCastbarIcon", L["Hide_Icon"], contentFrame, nil, BBF.ChangeCastbarSizes)
    hideTargetCastbarIcon:SetPoint("LEFT", hideTargetCastbar.text, "RIGHT", 0, 0)
    CreateTooltipTwo(hideTargetCastbarIcon, L["Hide_Target_Castbar_Icon"], L["Hide_Target_Castbar_Icon"])

    local resetTargetCastbar = CreateFrame("Button", nil, contentFrame, "UIPanelButtonTemplate")
    resetTargetCastbar:SetText(L["Reset"])
    resetTargetCastbar:SetWidth(70)
    resetTargetCastbar:SetPoint("TOP", targetCastbarBorder, "BOTTOM", 0, -2)
    resetTargetCastbar:SetScript("OnClick", function()
        targetCastBarScale:SetMinMaxValues(0.1, 1.9)
        targetCastBarXPos:SetMinMaxValues(-130, 130)
        targetCastBarYPos:SetMinMaxValues(-130, 130)
        targetCastBarWidth:SetMinMaxValues(60, 220)
        targetCastBarHeight:SetMinMaxValues(5, 30)
        targetCastBarIconScale:SetMinMaxValues(0.4, 2)
        targetCastbarIconXPos:SetMinMaxValues(-160, 160)
        targetCastbarIconYPos:SetMinMaxValues(-160, 160)
        targetToTAdjustmentOffsetY:SetMinMaxValues(-20, 50)
        targetCastBarScale:SetValue(1)
        targetCastBarIconScale:SetValue(1)
        targetCastBarXPos:SetValue(0)
        targetCastBarYPos:SetValue(0)
        targetCastbarIconXPos:SetValue(0)
        targetCastbarIconYPos:SetValue(0)
        targetCastBarWidth:SetValue(150)
        targetCastBarHeight:SetValue(10)
        targetCastBarTimer:SetChecked(false)
        BetterBlizzFramesDB.targetCastBarTimer = false
        targetStaticCastbar:SetChecked(false)
        BetterBlizzFramesDB.targetStaticCastbar = false
        targetDetachCastbar:SetChecked(false)
        BetterBlizzFramesDB.targetDetachCastbar = false
        targetToTCastbarAdjustment:Enable()
        targetToTCastbarAdjustment:SetAlpha(1)
        targetToTCastbarAdjustment:SetChecked(true)
        targetToTAdjustmentOffsetY:Enable()
        targetToTAdjustmentOffsetY:SetValue(0)
        BetterBlizzFramesDB.targetToTCastbarAdjustment = true
        BBF.CastBarTimerCaller()
        BBF.ChangeCastbarSizes()
    end)


    ----------------------
    -- Pet Castbars
    ----------------------
    local anchorSubPetCastbar = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubPetCastbar:SetPoint("CENTER", mainGuiAnchor2, "CENTER", firstLineX, secondLineY - 75)
    anchorSubPetCastbar:SetText(L["Pet_Castbar"])

    local petCastbarBorder = CreateBorderedFrame(anchorSubPetCastbar, 157, 320, 0, -112, contentFrame)

    local petCastbars = contentFrame:CreateTexture(nil, "ARTWORK")
    petCastbars:SetAtlas("ui-castingbar-filling-channel")
    petCastbars:SetDesaturated(true)
    petCastbars:SetVertexColor(1, 0.25, 0.98)
    petCastbars:SetSize(110, 13)
    petCastbars:SetPoint("BOTTOM", anchorSubPetCastbar, "TOP", -1, 10)

    local petCastBarScale = CreateSlider(contentFrame, L["Size"], 0.5, 1.9, 0.01, "petCastBarScale")
    petCastBarScale:SetPoint("TOP", anchorSubPetCastbar, "BOTTOM", 0, -15)

    local petCastBarXPos = CreateSlider(contentFrame, L["X_Offset"], -200, 200, 1, "petCastBarXPos", "X")
    petCastBarXPos:SetPoint("TOP", petCastBarScale, "BOTTOM", 0, -15)

    local petCastBarYPos = CreateSlider(contentFrame, L["Y_Offset"], -200, 200, 1, "petCastBarYPos", "Y")
    petCastBarYPos:SetPoint("TOP", petCastBarXPos, "BOTTOM", 0, -15)

    local petCastBarWidth = CreateSlider(contentFrame, L["Width"], 20, 200, 1, "petCastBarWidth")
    petCastBarWidth:SetPoint("TOP", petCastBarYPos, "BOTTOM", 0, -15)

    local petCastBarHeight = CreateSlider(contentFrame, L["Height"], 5, 30, 1, "petCastBarHeight")
    petCastBarHeight:SetPoint("TOP", petCastBarWidth, "BOTTOM", 0, -15)

    local petCastBarIconScale = CreateSlider(contentFrame, L["Icon_Size"], 0.4, 2, 0.01, "petCastBarIconScale")
    petCastBarIconScale:SetPoint("TOP", petCastBarHeight, "BOTTOM", 0, -15)

    local petCastBarTestMode = CreateCheckbox("petCastBarTestMode", L["Test"], contentFrame, nil, BBF.petCastBarTestMode)
    petCastBarTestMode:SetPoint("TOPLEFT", petCastBarIconScale, "BOTTOMLEFT", 10, -4)
    CreateTooltip(petCastBarTestMode, L["Tooltip_Need_Pet"])

    local petCastBarTimer = CreateCheckbox("petCastBarTimer", L["Timer"], contentFrame, nil, BBF.petCastBarTestMode)
    petCastBarTimer:SetPoint("LEFT", petCastBarTestMode.Text, "RIGHT", 10, 0)
    CreateTooltip(petCastBarTimer, L["Tooltip_Castbar_Timer"])

    local showPetCastBarIcon = CreateCheckbox("showPetCastBarIcon", L["Icon"], contentFrame, nil, BBF.petCastBarTestMode)
    showPetCastBarIcon:SetPoint("TOPLEFT", petCastBarTestMode, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local petDetachCastbar = CreateCheckbox("petDetachCastbar", L["Castbar_Detach"], contentFrame, nil, BBF.petCastBarTestMode)
    petDetachCastbar:SetPoint("TOPLEFT", showPetCastBarIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    petDetachCastbar:HookScript("OnClick", function(self)
        if self:GetChecked() then
            petCastBarXPos:SetMinMaxValues(-900, 900)
            petCastBarXPos:SetValue(0)
            petCastBarYPos:SetMinMaxValues(-900, 900)
            petCastBarYPos:SetValue(0)
        else
            petCastBarXPos:SetMinMaxValues(-130, 130)
            petCastBarXPos:SetValue(0)
        end
        BBF.petCastBarTestMode()
        BBF.ChangeCastbarSizes()
    end)
    CreateTooltip(petDetachCastbar, L["Tooltip_Detach_From_Frame"])

    if BetterBlizzFramesDB.petDetachCastbar then
        petCastBarXPos:SetMinMaxValues(-900, 900)
        petCastBarXPos:SetValue(0)
        petCastBarYPos:SetMinMaxValues(-900, 900)
        petCastBarYPos:SetValue(0)
    end

    local resetpetCastbar = CreateFrame("Button", nil, contentFrame, "UIPanelButtonTemplate")
    resetpetCastbar:SetText(L["Reset"])
    resetpetCastbar:SetWidth(70)
    resetpetCastbar:SetPoint("TOP", petCastbarBorder, "BOTTOM", 0, -2)
    resetpetCastbar:SetScript("OnClick", function()
        petCastBarScale:SetMinMaxValues(0.5, 1.9)
        petCastBarXPos:SetMinMaxValues(-200, 200)
        petCastBarYPos:SetMinMaxValues(-200, 200)
        petCastBarWidth:SetMinMaxValues(20, 200)
        petCastBarHeight:SetMinMaxValues(5, 30)
        petCastBarIconScale:SetMinMaxValues(0.4, 2)
        petCastBarScale:SetValue(1)
        petCastBarIconScale:SetValue(1)
        petCastBarXPos:SetValue(0)
        petCastBarYPos:SetValue(0)
        petCastBarWidth:SetValue(100)
        petCastBarHeight:SetValue(12)
        petCastBarTimer:SetChecked(true)
        petDetachCastbar:SetChecked(false)
        BetterBlizzFramesDB.petDetachCastbar = false
        BetterBlizzFramesDB.petCastBarTimer = true
        BBF.CastBarTimerCaller()
        BBF.ChangeCastbarSizes()
    end)

   ----------------------
    -- Focus Castbar
    ----------------------
    local anchorSubFocusCastbar = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubFocusCastbar:SetPoint("CENTER", mainGuiAnchor2, "CENTER", fourthLineX, firstLineY)
    anchorSubFocusCastbar:SetText(L["Focus_Castbar"])

    local focusCastbarBorder = CreateBorderedFrame(anchorSubFocusCastbar, 157, 386, 0, -145, contentFrame)

    local focusCastBar = contentFrame:CreateTexture(nil, "ARTWORK")
    focusCastBar:SetAtlas("ui-castingbar-full-applyingcrafting")
    focusCastBar:SetSize(110, 16)
    focusCastBar:SetPoint("BOTTOM", anchorSubFocusCastbar, "TOP", -1, 8.5)

    local focusCastBarScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.01, "focusCastBarScale")
    focusCastBarScale:SetPoint("TOP", anchorSubFocusCastbar, "BOTTOM", 0, -15)

    local focusCastBarXPos = CreateSlider(contentFrame, L["X_Offset"], -130, 130, 1, "focusCastBarXPos", "X")
    focusCastBarXPos:SetPoint("TOP", focusCastBarScale, "BOTTOM", 0, -15)

    local focusCastBarYPos = CreateSlider(contentFrame, L["Y_Offset"], -130, 130, 1, "focusCastBarYPos", "Y")
    focusCastBarYPos:SetPoint("TOP", focusCastBarXPos, "BOTTOM", 0, -15)

    local focusCastBarWidth = CreateSlider(contentFrame, L["Width"], 60, 220, 1, "focusCastBarWidth")
    focusCastBarWidth:SetPoint("TOP", focusCastBarYPos, "BOTTOM", 0, -15)

    local focusCastBarHeight = CreateSlider(contentFrame, L["Height"], 5, 30, 1, "focusCastBarHeight")
    focusCastBarHeight:SetPoint("TOP", focusCastBarWidth, "BOTTOM", 0, -15)

    local focusCastBarIconScale = CreateSlider(contentFrame, L["Icon_Size"], 0.4, 2, 0.01, "focusCastBarIconScale")
    focusCastBarIconScale:SetPoint("TOP", focusCastBarHeight, "BOTTOM", 0, -15)

    local focusCastbarIconXPos = CreateSlider(contentFrame, L["Icon_x_offset"], -160, 160, 1, "focusCastbarIconXPos", "X")
    focusCastbarIconXPos:SetPoint("TOP", focusCastBarIconScale, "BOTTOM", 0, -15)

    local focusCastbarIconYPos = CreateSlider(contentFrame, L["Icon_y_offset"], -160, 160, 1, "focusCastbarIconYPos", "Y")
    focusCastbarIconYPos:SetPoint("TOP", focusCastbarIconXPos, "BOTTOM", 0, -15)

    local focusStaticCastbar = CreateCheckbox("focusStaticCastbar", L["Static"], contentFrame)
    focusStaticCastbar:SetPoint("TOPLEFT", focusCastbarIconYPos, "BOTTOMLEFT", 10, -4)
    CreateTooltip(focusStaticCastbar, L["Tooltip_Castbar_Static"])

    local focusCastBarTimer = CreateCheckbox("focusCastBarTimer", L["Timer"], contentFrame, nil, BBF.CastBarTimerCaller)
    focusCastBarTimer:SetPoint("LEFT", focusStaticCastbar.Text, "RIGHT", 10, 0)
    CreateTooltip(focusCastBarTimer, L["Tooltip_Castbar_Timer"])

    local focusToTCastbarAdjustment = CreateCheckbox("focusToTCastbarAdjustment", L["ToT_Offset"], contentFrame)
    focusToTCastbarAdjustment:SetPoint("TOPLEFT", focusStaticCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(focusToTCastbarAdjustment, L["Enable_ToT_Offset"], L["Tooltip_Castbar_ToT_Offset_Desc"])

    local focusToTAdjustmentOffsetY = CreateSlider(focusToTCastbarAdjustment, L["extra"], -20, 50, 1, "focusToTAdjustmentOffsetY", "Y", 55)
    focusToTAdjustmentOffsetY:SetPoint("LEFT", focusToTCastbarAdjustment.text, "RIGHT", 2, -5)
    CreateTooltipTwo(focusToTAdjustmentOffsetY, L["Tooltip_ToT_Adjustment_Offset_Y"], L["Tooltip_Castbar_ToT_Extra_Desc"])

    focusToTCastbarAdjustment:HookScript("OnClick", function(self)
        if self:GetChecked() then
            focusToTAdjustmentOffsetY:Enable()
            focusToTAdjustmentOffsetY:SetAlpha(1)
        else
            focusToTAdjustmentOffsetY:Disable()
            focusToTAdjustmentOffsetY:SetAlpha(0.5)
        end
    end)

    local focusDetachCastbar = CreateCheckbox("focusDetachCastbar", L["Castbar_Detach"], contentFrame)
    focusDetachCastbar:SetPoint("TOPLEFT", focusToTCastbarAdjustment, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    focusDetachCastbar:HookScript("OnClick", function(self)
        if self:GetChecked() then
            focusCastBarXPos:SetMinMaxValues(-900, 900)
            focusCastBarXPos:SetValue(0)
            focusCastBarYPos:SetMinMaxValues(-900, 900)
            focusCastBarYPos:SetValue(0)
            focusToTCastbarAdjustment:Disable()
            focusToTCastbarAdjustment:SetAlpha(0.5)
            focusToTAdjustmentOffsetY:Disable()
            focusToTAdjustmentOffsetY:SetAlpha(0.5)
            focusStaticCastbar:SetChecked(false)
            BetterBlizzFramesDB.focusStaticCastbar = false
        else
            focusCastBarXPos:SetMinMaxValues(-130, 130)
            focusCastBarXPos:SetValue(0)
            focusToTCastbarAdjustment:Enable()
            focusToTCastbarAdjustment:SetAlpha(1)
            focusToTAdjustmentOffsetY:Enable()
            focusToTAdjustmentOffsetY:SetAlpha(1)
        end
        BBF.ChangeCastbarSizes()
    end)
    CreateTooltip(focusDetachCastbar, L["Tooltip_Detach_From_Frame"])

    if BetterBlizzFramesDB.focusDetachCastbar then
        focusCastBarXPos:SetMinMaxValues(-900, 900)
        focusCastBarYPos:SetMinMaxValues(-900, 900)
        focusToTCastbarAdjustment:Disable()
        focusToTCastbarAdjustment:SetAlpha(0.5)
        focusToTAdjustmentOffsetY:Disable()
        focusToTAdjustmentOffsetY:SetAlpha(0.5)
        focusStaticCastbar:SetChecked(false)
        BetterBlizzFramesDB.focusStaticCastbar = false
    end
    focusStaticCastbar:HookScript("OnClick", function(self)
        if self:GetChecked() then
            focusToTCastbarAdjustment:Disable()
            focusToTCastbarAdjustment:SetAlpha(0.5)
            focusToTAdjustmentOffsetY:Disable()
            focusToTAdjustmentOffsetY:SetAlpha(0.5)
            focusDetachCastbar:SetChecked(false)
        else
            focusToTCastbarAdjustment:Enable()
            focusToTCastbarAdjustment:SetAlpha(1)
            focusToTAdjustmentOffsetY:Enable()
            focusToTAdjustmentOffsetY:SetAlpha(1)
        end
    end)
    if BetterBlizzFramesDB.focusStaticCastbar then
        focusToTCastbarAdjustment:Disable()
        focusToTCastbarAdjustment:SetAlpha(0.5)
        focusToTAdjustmentOffsetY:Disable()
        focusToTAdjustmentOffsetY:SetAlpha(0.5)
        focusDetachCastbar:SetChecked(false)
        BetterBlizzFramesDB.focusDetachCastbar = false
    end

    local hideFocusCastbar = CreateCheckbox("hideFocusCastbar", L["Hide_Bar"], contentFrame, nil, BBF.ChangeCastbarSizes)
    hideFocusCastbar:SetPoint("TOPLEFT", focusDetachCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideFocusCastbar, L["Hide_Bar"], L["Tooltip_Hide_Focus_Castbar"])

    local hideFocusCastbarIcon = CreateCheckbox("hideFocusCastbarIcon", L["Hide_Icon"], contentFrame, nil, BBF.ChangeCastbarSizes)
    hideFocusCastbarIcon:SetPoint("LEFT", hideFocusCastbar.text, "RIGHT", 0, 0)
    CreateTooltipTwo(hideFocusCastbarIcon, L["Hide_Icon"], L["Tooltip_Hide_Focus_Castbar_Icon"])

    local resetFocusCastbar = CreateFrame("Button", nil, contentFrame, "UIPanelButtonTemplate")
    resetFocusCastbar:SetText(L["Reset"])
    resetFocusCastbar:SetWidth(70)
    resetFocusCastbar:SetPoint("TOP", focusCastbarBorder, "BOTTOM", 0, -2)
    resetFocusCastbar:SetScript("OnClick", function()
        focusCastBarScale:SetMinMaxValues(0.1, 1.9)
        focusCastBarXPos:SetMinMaxValues(-130, 130)
        focusCastBarYPos:SetMinMaxValues(-130, 130)
        focusCastBarWidth:SetMinMaxValues(60, 220)
        focusCastBarHeight:SetMinMaxValues(5, 30)
        focusCastBarIconScale:SetMinMaxValues(0.4, 2)
        focusCastbarIconXPos:SetMinMaxValues(-160, 160)
        focusCastbarIconYPos:SetMinMaxValues(-160, 160)
        focusToTAdjustmentOffsetY:SetMinMaxValues(-20, 50)
        focusCastBarScale:SetValue(1)
        focusCastBarIconScale:SetValue(1)
        focusCastBarXPos:SetValue(0)
        focusCastBarYPos:SetValue(0)
        focusCastbarIconXPos:SetValue(0)
        focusCastbarIconYPos:SetValue(0)
        focusCastBarWidth:SetValue(150)
        focusCastBarHeight:SetValue(10)
        focusCastBarTimer:SetChecked(false)
        BetterBlizzFramesDB.focusCastBarTimer = false
        focusStaticCastbar:SetChecked(false)
        BetterBlizzFramesDB.focusStaticCastbar = false
        focusDetachCastbar:SetChecked(false)
        BetterBlizzFramesDB.focusDetachCastbar = false
        focusToTCastbarAdjustment:Enable()
        focusToTCastbarAdjustment:SetAlpha(1)
        focusToTCastbarAdjustment:SetChecked(true)
        focusToTAdjustmentOffsetY:Enable()
        focusToTAdjustmentOffsetY:SetValue(0)
        BetterBlizzFramesDB.focusToTCastbarAdjustment = true
        BBF.CastBarTimerCaller()
        BBF.ChangeCastbarSizes()
    end)


   ----------------------
    -- Player Castbar
    ----------------------
    local anchorSubPlayerCastbar = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorSubPlayerCastbar:SetPoint("CENTER", mainGuiAnchor2, "CENTER", firstLineX, firstLineY)
    anchorSubPlayerCastbar:SetText(L["Player_Castbar"])

    local playerCastbarBorder = CreateBorderedFrame(anchorSubPlayerCastbar, 157, 450, 0, -77, contentFrame)

    local playerCastBar = contentFrame:CreateTexture(nil, "ARTWORK")
    playerCastBar:SetAtlas("ui-castingbar-filling-standard")
    playerCastBar:SetSize(110, 13)
    playerCastBar:SetPoint("BOTTOM", anchorSubPlayerCastbar, "TOP", -1, 10)


    local playerCastBarScale = CreateSlider(contentFrame, L["Size"], 0.1, 1.9, 0.01, "playerCastBarScale")
    playerCastBarScale:SetPoint("TOP", anchorSubPlayerCastbar, "BOTTOM", 0, -15)

    local playerCastbarIconXPos = CreateSlider(contentFrame, L["X_Offset"], -200, 200, 1, "playerCastbarIconXPos", "X")
    playerCastbarIconXPos:SetPoint("TOP", playerCastBarScale, "BOTTOM", 0, -15)

    local playerCastbarIconYPos = CreateSlider(contentFrame, L["Y_Offset"], -200, 200, 1, "playerCastbarIconYPos", "Y")
    playerCastbarIconYPos:SetPoint("TOP", playerCastbarIconXPos, "BOTTOM", 0, -15)

    local playerCastBarIconScale = CreateSlider(contentFrame, L["Icon_Size"], 0.4, 2, 0.01, "playerCastBarIconScale")
    playerCastBarIconScale:SetPoint("TOP", playerCastbarIconYPos, "BOTTOM", 0, -15)

    local playerCastBarWidth = CreateSlider(contentFrame, L["Width"], 60, 230, 1, "playerCastBarWidth")
    --playerCastBarWidth:SetPoint("TOP", playerCastBarYPos, "BOTTOM", 0, -15)
    playerCastBarWidth:SetPoint("TOP", playerCastBarIconScale, "BOTTOM", 0, -15)

    local playerCastBarHeight = CreateSlider(contentFrame, L["Height"], 5, 30, 1, "playerCastBarHeight")
    playerCastBarHeight:SetPoint("TOP", playerCastBarWidth, "BOTTOM", 0, -15)

    local playerCastBarShowIcon = CreateCheckbox("playerCastBarShowIcon", L["Icon"], contentFrame, nil, BBF.ShowPlayerCastBarIcon)
    playerCastBarShowIcon:SetPoint("TOPLEFT", playerCastBarHeight, "BOTTOMLEFT", 10, -4)
    CreateTooltip(playerCastBarShowIcon, L["Tooltip_Player_Castbar_Icon"])

    local playerCastBarTimer = CreateCheckbox("playerCastBarTimer", L["Timer"], contentFrame, nil, BBF.CastBarTimerCaller)
    playerCastBarTimer:SetPoint("LEFT", playerCastBarShowIcon.Text, "RIGHT", 7, 0)
    CreateTooltip(playerCastBarTimer, L["Tooltip_Castbar_Timer"])

    local playerCastBarTimerCentered = CreateCheckbox("playerCastBarTimerCentered", L["Center"], contentFrame, nil, BBF.CastBarTimerCaller)
    --playerStaticCastbar:SetPoint("TOPLEFT", playerCastBarIconScale, "BOTTOMLEFT", 10, -4)
    playerCastBarTimerCentered:SetPoint("LEFT", playerCastBarTimer.Text, "RIGHT", 2, 0)
    CreateTooltip(playerCastBarTimerCentered, L["Tooltip_Player_Castbar_Timer_Center"])

    local playerCastBarNoTextBorder = CreateCheckbox("playerCastBarNoTextBorder", L["Player_Castbar_Simple"], contentFrame, nil, BBF.ChangeCastbarSizes)
    --playerStaticCastbar:SetPoint("TOPLEFT", playerCastBarIconScale, "BOTTOMLEFT", 10, -4)
    playerCastBarNoTextBorder:SetPoint("TOPLEFT", playerCastBarShowIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(playerCastBarNoTextBorder, L["Player_Castbar_Simple"], L["Tooltip_Simple_Castbar"])

    local classicCastbarsPlayer = CreateCheckbox("classicCastbarsPlayer", L["Classic_Castbar"], contentFrame, nil, BBF.ChangeCastbarSizes)
    classicCastbarsPlayer:SetPoint("TOPLEFT", playerCastBarNoTextBorder, "BOTTOMLEFT", -15, pixelsBetweenBoxes)
    CreateTooltipTwo(classicCastbarsPlayer, L["Classic_Castbar"], L["Tooltip_Player_Castbar_Classic_Desc"])

    local hidePlayerCastbar = CreateCheckbox("hidePlayerCastbar", L["Hide_Bar"], contentFrame, nil, BBF.ChangeCastbarSizes)
    hidePlayerCastbar:SetPoint("TOPLEFT", classicCastbarsPlayer, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hidePlayerCastbar, L["Hide_Player_Castbar"], L["Hide_Player_Castbar"])

    local hidePlayerCastbarIcon = CreateCheckbox("hidePlayerCastbarIcon", L["Hide_Icon"], contentFrame, nil, BBF.ChangeCastbarSizes)
    hidePlayerCastbarIcon:SetPoint("LEFT", hidePlayerCastbar.text, "RIGHT", 0, 0)
    CreateTooltipTwo(hidePlayerCastbarIcon, L["Hide_Player_Castbar_Icon"], L["Hide_Player_Castbar_Icon"])
    hidePlayerCastbar:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local classicCastbarsPlayerBorder = CreateCheckbox("classicCastbarsPlayerBorder", L["Border"], classicCastbarsPlayer, nil, BBF.ChangeCastbarSizes)
    classicCastbarsPlayerBorder:SetPoint("LEFT", classicCastbarsPlayer.text, "RIGHT", 0, 0)
    CreateTooltipTwo(classicCastbarsPlayerBorder, L["Classic_Border"], L["Tooltip_Player_Castbar_Border_Desc"])

    classicCastbarsPlayer:HookScript("OnClick", function(self)
        CheckAndToggleCheckboxes(self)
    end)

    local resetPlayerCastbar = CreateFrame("Button", nil, contentFrame, "UIPanelButtonTemplate")
    resetPlayerCastbar:SetText(L["Reset"])
    resetPlayerCastbar:SetWidth(70)
    resetPlayerCastbar:SetPoint("TOP", playerCastbarBorder, "BOTTOM", 0, -2)
    resetPlayerCastbar:SetScript("OnClick", function()
        playerCastBarScale:SetMinMaxValues(0.1, 1.9)
        playerCastbarIconXPos:SetMinMaxValues(-200, 200)
        playerCastbarIconYPos:SetMinMaxValues(-200, 200)
        playerCastBarIconScale:SetMinMaxValues(0.4, 2)
        playerCastBarWidth:SetMinMaxValues(60, 230)
        playerCastBarHeight:SetMinMaxValues(5, 30)
        playerCastbarIconXPos:SetValue(0)
        playerCastbarIconYPos:SetValue(0)
        playerCastBarScale:SetValue(1)
        playerCastBarIconScale:SetValue(1)
        playerCastBarWidth:SetValue(208)
        playerCastBarHeight:SetValue(11)
        playerCastBarShowIcon:SetChecked(false)
        playerCastBarTimer:SetChecked(false)
        playerCastBarTimerCentered:SetChecked(false)
        BetterBlizzFramesDB.playerCastBarShowIcon = false
        BetterBlizzFramesDB.playerCastBarTimer = false
        BetterBlizzFramesDB.playerStaticCastbar = false
        BetterBlizzFramesDB.playerCastBarTimerCentered = false
        --PlayerCastingBarFrame.showShield = false
        BBF.CastBarTimerCaller()
        BBF.ShowPlayerCastBarIcon()
        BBF.ChangeCastbarSizes()
    end)

    local function UpdateColorSquare(icon, r, g, b, a)
        if r and g and b and a then
            icon:SetVertexColor(r, g, b, a)
        else
            icon:SetVertexColor(r, g, b)
        end
    end

    local function OpenColorPicker(colorType, icon)
        -- Ensure originalColorData has four elements, defaulting alpha (a) to 1 if not present
        local originalColorData = BetterBlizzFramesDB[colorType] or {1, 1, 1, 1}
        if #originalColorData == 3 then
            table.insert(originalColorData, 1) -- Add default alpha value if not present
        end
        local r, g, b, a = unpack(originalColorData)

        local function updateColors()
            UpdateColorSquare(icon, r, g, b, a)
            ColorPickerFrame.Content.ColorSwatchCurrent:SetAlpha(a)
        end

        local function swatchFunc()
            r, g, b = ColorPickerFrame:GetColorRGB()
            BetterBlizzFramesDB[colorType] = {r, g, b, a}
            updateColors()
        end

        local function opacityFunc()
            a = ColorPickerFrame:GetColorAlpha()
            BetterBlizzFramesDB[colorType] = {r, g, b, a}
            updateColors()
        end

        local function cancelFunc()
            r, g, b, a = unpack(originalColorData)
            BetterBlizzFramesDB[colorType] = {r, g, b, a}
            updateColors()
        end

        ColorPickerFrame:SetupColorPickerAndShow({
            r = r, g = g, b = b, opacity = a, hasOpacity = true,
            swatchFunc = swatchFunc, opacityFunc = opacityFunc, cancelFunc = cancelFunc
        })
    end

    local castBarInterruptHighlighterText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    castBarInterruptHighlighterText:SetPoint("LEFT", contentFrame, "TOPRIGHT", -235, -465)
    castBarInterruptHighlighterText:SetText(L["Label_Castbar_Edge_Highlight_Settings"])

    local castBarInterruptHighlighter = CreateCheckbox("castBarInterruptHighlighter", L["Castbar_Edge_Highlight"], contentFrame, nil, BBF.CastbarRecolorWidgets)
    castBarInterruptHighlighter:SetPoint("TOPLEFT", castBarInterruptHighlighterText, "BOTTOMLEFT", 0, pixelsOnFirstBox)
    CreateTooltip(castBarInterruptHighlighter, L["Tooltip_Edge_Highlight"])

    local targetCastbarEdgeHighlight = CreateCheckbox("targetCastbarEdgeHighlight", L["Target"], castBarInterruptHighlighter, nil, BBF.CastbarRecolorWidgets)
    targetCastbarEdgeHighlight:SetPoint("TOPLEFT", castBarInterruptHighlighter, "BOTTOMLEFT", 15, pixelsBetweenBoxes)
    CreateTooltip(targetCastbarEdgeHighlight, L["Tooltip_Target_Castbar"])

    local focusCastbarEdgeHighlight = CreateCheckbox("focusCastbarEdgeHighlight", L["Focus"], castBarInterruptHighlighter, nil, BBF.CastbarRecolorWidgets)
    focusCastbarEdgeHighlight:SetPoint("LEFT", targetCastbarEdgeHighlight.text, "RIGHT", 0, 0)
    CreateTooltip(focusCastbarEdgeHighlight, L["Tooltip_Focus_Castbar"])

    local castBarInterruptHighlighterColorDontInterrupt = CreateCheckbox("castBarInterruptHighlighterColorDontInterrupt", L["Recolor_Between_Portion"], castBarInterruptHighlighter, nil, BBF.CastbarRecolorWidgets)
    castBarInterruptHighlighterColorDontInterrupt:SetPoint("TOPLEFT", targetCastbarEdgeHighlight, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(castBarInterruptHighlighterColorDontInterrupt, L["Tooltip_Castbar_Between_Color"])

    local castBarInterruptHighlighterDontInterruptRGB = CreateFrame("Button", nil, castBarInterruptHighlighterColorDontInterrupt, "UIPanelButtonTemplate")
    castBarInterruptHighlighterDontInterruptRGB:SetText(L["Color"])
    castBarInterruptHighlighterDontInterruptRGB:SetPoint("LEFT", castBarInterruptHighlighterColorDontInterrupt.text, "RIGHT", 2, 0)
    castBarInterruptHighlighterDontInterruptRGB:SetSize(50, 20)
    CreateTooltip(castBarInterruptHighlighterDontInterruptRGB, L["Tooltip_Castbar_Color_Between"])
    local castBarInterruptHighlighterDontInterruptRGBIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    castBarInterruptHighlighterDontInterruptRGBIcon:SetAtlas("newplayertutorial-icon-key")
    castBarInterruptHighlighterDontInterruptRGBIcon:SetSize(18, 17)
    castBarInterruptHighlighterDontInterruptRGBIcon:SetPoint("LEFT", castBarInterruptHighlighterDontInterruptRGB, "RIGHT", 0, -1)
    UpdateColorSquare(castBarInterruptHighlighterDontInterruptRGBIcon, unpack(BetterBlizzFramesDB["castBarInterruptHighlighterDontInterruptRGB"] or {1, 1, 1}))
    castBarInterruptHighlighterDontInterruptRGB:SetScript("OnClick", function()
        OpenColorPicker("castBarInterruptHighlighterDontInterruptRGB", castBarInterruptHighlighterDontInterruptRGBIcon)
    end)

    local castBarInterruptHighlighterStartTime = CreateSlider(castBarInterruptHighlighter, L["Start_Seconds"], 0, 2, 0.01, "castBarInterruptHighlighterStartTime", "Height")
    castBarInterruptHighlighterStartTime:SetPoint("TOPLEFT", castBarInterruptHighlighterColorDontInterrupt, "BOTTOMLEFT", 10, -6)
    CreateTooltip(castBarInterruptHighlighterStartTime, L["Tooltip_Interrupt_Highlighter_Start"])

    local castBarInterruptHighlighterEndTime = CreateSlider(castBarInterruptHighlighter, L["End_Seconds"], 0, 2, 0.01, "castBarInterruptHighlighterEndTime", "Height")
    castBarInterruptHighlighterEndTime:SetPoint("TOPLEFT", castBarInterruptHighlighterStartTime, "BOTTOMLEFT", 0, -10)
    CreateTooltip(castBarInterruptHighlighterEndTime, L["Tooltip_Interrupt_Highlighter_End"])

    local castBarInterruptHighlighterInterruptRGB = CreateFrame("Button", nil, castBarInterruptHighlighter, "UIPanelButtonTemplate")
    castBarInterruptHighlighterInterruptRGB:SetText(L["Color"])
    castBarInterruptHighlighterInterruptRGB:SetPoint("LEFT", castBarInterruptHighlighterEndTime, "RIGHT", 0, 15)
    castBarInterruptHighlighterInterruptRGB:SetSize(50, 20)
    CreateTooltip(castBarInterruptHighlighterInterruptRGB, L["Tooltip_Castbar_Edge_Color"])
    local castBarInterruptHighlighterInterruptRGBIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    castBarInterruptHighlighterInterruptRGBIcon:SetAtlas("newplayertutorial-icon-key")
    castBarInterruptHighlighterInterruptRGBIcon:SetSize(18, 17)
    castBarInterruptHighlighterInterruptRGBIcon:SetPoint("LEFT", castBarInterruptHighlighterInterruptRGB, "RIGHT", 0, -1)
    UpdateColorSquare(castBarInterruptHighlighterInterruptRGBIcon, unpack(BetterBlizzFramesDB["castBarInterruptHighlighterInterruptRGB"] or {1, 1, 1}))
    castBarInterruptHighlighterInterruptRGB:SetScript("OnClick", function()
        OpenColorPicker("castBarInterruptHighlighterInterruptRGB", castBarInterruptHighlighterInterruptRGBIcon)
    end)

    castBarInterruptHighlighter:HookScript("OnClick", function(self)
        CheckAndToggleCheckboxes(castBarInterruptHighlighter)
        if self:GetChecked() then
            if BetterBlizzFramesDB.castBarInterruptHighlighterColorDontInterrupt then
                castBarInterruptHighlighterDontInterruptRGBIcon:SetAlpha(1)
            end
            castBarInterruptHighlighterInterruptRGBIcon:SetAlpha(1)
        else
            castBarInterruptHighlighterDontInterruptRGBIcon:SetAlpha(0)
            castBarInterruptHighlighterInterruptRGBIcon:SetAlpha(0)
        end
    end)

    castBarInterruptHighlighterColorDontInterrupt:HookScript("OnClick", function(self)
        CheckAndToggleCheckboxes(castBarInterruptHighlighter)
        if self:GetChecked() then
            castBarInterruptHighlighterDontInterruptRGBIcon:SetAlpha(1)
        else
            castBarInterruptHighlighterDontInterruptRGBIcon:SetAlpha(0)
        end
    end)



    local castBarRecolorInterrupt = CreateCheckbox("castBarRecolorInterrupt", L["Interrupt_CD_Color"], contentFrame, nil, BBF.CastbarRecolorWidgets)
    castBarRecolorInterrupt:SetPoint("LEFT", contentFrame, "TOPRIGHT", -455, -449)
    CreateTooltipTwo(castBarRecolorInterrupt, L["Interrupt_CD_Color"], L["Tooltip_Interrupt_CD_Color_Desc"])

    local castBarRecolorInterruptArenaFrames = CreateCheckbox("castBarRecolorInterruptArenaFrames", L["Arena"], contentFrame, nil, BBF.CastbarRecolorWidgets)
    castBarRecolorInterruptArenaFrames:SetPoint("LEFT", castBarRecolorInterrupt.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(castBarRecolorInterruptArenaFrames, L["Interrupt_CD_Color_Arena_Frames"], L["Tooltip_Interrupt_Arena_Desc"])

    local castBarInterruptIconEnabled = CreateCheckbox("castBarInterruptIconEnabled", L["Interrupt_CD_Icon"], contentFrame, nil, BBF.UpdateInterruptIconSettings)
    castBarInterruptIconEnabled:SetPoint("BOTTOMLEFT", castBarRecolorInterrupt, "TOPLEFT", 0, -pixelsBetweenBoxes)
    CreateTooltipTwo(castBarInterruptIconEnabled, L["Interrupt_CD_Icon"], L["Tooltip_Interrupt_CD_Icon_Desc"], L["Tooltip_Interrupt_CD_Icon_Extra"])

    local castBarNoInterruptColor = CreateFrame("Button", nil, castBarRecolorInterrupt, "UIPanelButtonTemplate")
    castBarNoInterruptColor:SetText(L["Interrupt_On_CD"])
    castBarNoInterruptColor:SetPoint("TOPLEFT", castBarRecolorInterrupt, "BOTTOMRIGHT", -35, 3)
    castBarNoInterruptColor:SetSize(139, 20)
    CreateTooltip(castBarNoInterruptColor, L["Tooltip_Interrupt_On_CD"])
    local castBarNoInterruptColorIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    castBarNoInterruptColorIcon:SetAtlas("newplayertutorial-icon-key")
    castBarNoInterruptColorIcon:SetSize(18, 17)
    castBarNoInterruptColorIcon:SetPoint("LEFT", castBarNoInterruptColor, "RIGHT", 0, -1)
    UpdateColorSquare(castBarNoInterruptColorIcon, unpack(BetterBlizzFramesDB["castBarNoInterruptColor"] or {1, 1, 1}))
    castBarNoInterruptColor:SetScript("OnClick", function()
        OpenColorPicker("castBarNoInterruptColor", castBarNoInterruptColorIcon)
    end)

    local castBarDelayedInterruptColor = CreateFrame("Button", nil, castBarRecolorInterrupt, "UIPanelButtonTemplate")
    castBarDelayedInterruptColor:SetText(L["Interrupt_CD_Soon"])
    castBarDelayedInterruptColor:SetPoint("TOPLEFT", castBarNoInterruptColor, "BOTTOMLEFT", 0, -5)
    castBarDelayedInterruptColor:SetSize(139, 20)
    CreateTooltip(castBarDelayedInterruptColor, L["Tooltip_Interrupt_CD_Soon"])
    local castBarDelayedInterruptColorIcon = contentFrame:CreateTexture(nil, "ARTWORK")
    castBarDelayedInterruptColorIcon:SetAtlas("newplayertutorial-icon-key")
    castBarDelayedInterruptColorIcon:SetSize(18, 17)
    castBarDelayedInterruptColorIcon:SetPoint("LEFT", castBarDelayedInterruptColor, "RIGHT", 0, -1)
    UpdateColorSquare(castBarDelayedInterruptColorIcon, unpack(BetterBlizzFramesDB["castBarDelayedInterruptColor"] or {1, 1, 1}))
    castBarDelayedInterruptColor:SetScript("OnClick", function()
        OpenColorPicker("castBarDelayedInterruptColor", castBarDelayedInterruptColorIcon)
    end)


    local buffsOnTopReverseCastbarMovement = CreateCheckbox("buffsOnTopReverseCastbarMovement", L["Buffs_On_Top_Reverse"], contentFrame, nil, BBF.CastbarAdjustCaller)
    buffsOnTopReverseCastbarMovement:SetPoint("LEFT", contentFrame, "TOPRIGHT", -470, -517)
    CreateTooltipTwo(buffsOnTopReverseCastbarMovement, L["Buffs_On_Top_Reverse"], L["Tooltip_Buffs_On_Top_Reverse"])

    local normalCastbarForEmpoweredCasts = CreateCheckbox("normalCastbarForEmpoweredCasts", L["Normal_Evoker_Castbar"], contentFrame, nil, BBF.HookCastbarsForEvoker)
    normalCastbarForEmpoweredCasts:SetPoint("TOPLEFT", buffsOnTopReverseCastbarMovement, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(normalCastbarForEmpoweredCasts, L["Normal_Evoker_Castbar"], L["Tooltip_Normal_Evoker_Castbar"])
    normalCastbarForEmpoweredCasts:HookScript("OnClick", function(self)
        if BetterBlizzPlatesDB then
            if self:GetChecked() then
                BetterBlizzPlatesDB.normalCastbarForEmpoweredCasts = true
            else
                BetterBlizzPlatesDB.normalCastbarForEmpoweredCasts = false
            end
        end
    end)

    local quickHideCastbars = CreateCheckbox("quickHideCastbars", L["Quick_Hide_Castbars"], contentFrame)
    quickHideCastbars:SetPoint("TOPLEFT", normalCastbarForEmpoweredCasts, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(quickHideCastbars, L["Quick_Hide_Castbars"], L["Tooltip_Quick_Hide_Castbars"])
    quickHideCastbars:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local classicCastbars = CreateCheckbox("classicCastbars", L["Castbar_Classic"], contentFrame, nil, BBF.ChangeCastbarSizes)
    classicCastbars:SetPoint("TOPLEFT", quickHideCastbars, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(classicCastbars, L["Castbar_Classic"], L["Tooltip_Classic_Castbars"])

    local classicCastbarsModernSpark = CreateCheckbox("classicCastbarsModernSpark", L["Modern_Spark"], contentFrame, nil, BBF.ChangeCastbarSizes)
    classicCastbarsModernSpark:SetPoint("LEFT", classicCastbars.text, "RIGHT", 0, 0)
    CreateTooltipTwo(classicCastbarsModernSpark, L["Modern_Spark"], L["Tooltip_Modern_Spark"])
    classicCastbarsModernSpark:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local unitframeCastBarNoTextBorder = CreateCheckbox("unitframeCastBarNoTextBorder", L["Player_Castbar_Simple"], contentFrame, nil, BBF.ChangeCastbarSizes)
    unitframeCastBarNoTextBorder:SetPoint("TOPLEFT", classicCastbars, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(unitframeCastBarNoTextBorder, L["Player_Castbar_Simple"], L["Tooltip_Simple_Castbar"])
    unitframeCastBarNoTextBorder:HookScript("OnClick", function()
        if classicCastbars:GetChecked() then
            BetterBlizzFrames.classicCastbars = nil
            classicCastbars:SetChecked(false)
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
        if anchorSubPartyCastbar.classicCastbarsParty:GetChecked() then
            anchorSubPartyCastbar.classicCastbarsParty:SetChecked(false)
            BetterBlizzFrames.classicCastbarsParty = nil
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    classicCastbars:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
            DisableElement(classicCastbarsModernSpark)
        else
            EnableElement(classicCastbarsModernSpark)
        end
        if unitframeCastBarNoTextBorder:GetChecked() then
            BetterBlizzFrames.unitframeCastBarNoTextBorder = nil
            unitframeCastBarNoTextBorder:SetChecked(false)
        end
    end)

    if not BetterBlizzFramesDB.classicCastbars then
        DisableElement(classicCastbarsModernSpark)
    end

    local recolorCastbars = CreateCheckbox("recolorCastbars", L["Recolor_Castbars"], contentFrame)
    recolorCastbars:SetPoint("TOPLEFT", unitframeCastBarNoTextBorder, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(recolorCastbars, L["Recolor_Castbars"], L["Tooltip_Recolor_Castbars"])

    local castbarCastColor = CreateColorBox(recolorCastbars, "castbarCastColor", L["Cast"])
    castbarCastColor:SetPoint("LEFT", recolorCastbars.text, "RIGHT", 0, 0)

    local castbarChannelColor = CreateColorBox(recolorCastbars, "castbarChannelColor", L["Channel"])
    castbarChannelColor:SetPoint("LEFT", castbarCastColor.text, "RIGHT", 0, 0)

    local castbarUninterruptableColor = CreateColorBox(recolorCastbars, "castbarUninterruptableColor", L["Uninterruptable"])
    castbarUninterruptableColor:SetPoint("LEFT", castbarChannelColor.text, "RIGHT", 0, 0)

    recolorCastbars:HookScript("OnClick", function(self)
        local enable = self:GetChecked() and 1 or 0.5
        castbarCastColor:SetAlpha(enable)
        castbarChannelColor:SetAlpha(enable)
        castbarUninterruptableColor:SetAlpha(enable)
        BBF.CastbarRecolorWidgets()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    BetterBlizzFramesCastbars.rightClickTip = BetterBlizzFramesCastbars:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    BetterBlizzFramesCastbars.rightClickTip:SetPoint("BOTTOMLEFT", bgImg, "BOTTOM", -231, -36)
    BetterBlizzFramesCastbars.rightClickTip:SetText("|A:smallquestbang:20:20|a" .. L["Right_Click_Slider_Tip"])
end


-- Export tab function to BBF
BBF.guiCastbars = guiCastbars
