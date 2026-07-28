local BBF = _G.BBF
if not BBF or not BBF.isMidnight then return end
local L = BBF.L
local LSM = BBF.LSM or LibStub:GetLibrary('LibSharedMedia-3.0', true) or LibStub('LibSharedMedia-3.0', true)
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

local function guiFrameAuras()
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

    local playerAuraFiltering = CreateCheckbox("playerAuraFiltering", L["Enable_Aura_Settings"], contentFrame)
    playerAuraFiltering.name = guiFrameAuras.name
    CreateTooltipTwo(playerAuraFiltering, L["Enable_Aura_Settings"], L["Tooltip_Enable_Aura_Settings_TargetFocus_Desc"])
    playerAuraFiltering:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 50, -20)
    playerAuraFiltering:HookScript("OnClick", function (self)
        if self:GetChecked() then
            if BetterBlizzFramesDB.targetToTXPos == 0 then
                StaticPopup_Show("BBF_TOT_MESSAGE")
                BetterBlizzFramesDB.targetToTXPos = 31
                BBF.targetToTXPos:SetValue(31)
                BetterBlizzFramesDB.focusToTXPos = 31
                BBF.focusToTXPos:SetValue(31)
                BBF.MoveToTFrames()
            else
                StaticPopup_Show("BBF_CONFIRM_RELOAD")
            end
        else
            if BetterBlizzFramesDB.targetToTXPos == 31 then
                BBF.Print(L["Chat_Aura_Settings_Off"])
                BetterBlizzFramesDB.targetToTXPos = 0
                BBF.targetToTXPos:SetValue(0)
                BetterBlizzFramesDB.focusToTXPos = 0
                BBF.focusToTXPos:SetValue(0)
                BBF.MoveToTFrames()
            end
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local enableMasque = CreateCheckbox("enableMasque", L["Add_Masque_Support"], contentFrame)
    enableMasque:SetPoint("LEFT", playerAuraFiltering.Text, "RIGHT", 5, 0)
    CreateTooltipTwo(enableMasque, L["Add_Masque_Support"], L["Tooltip_Masque_Support"], L["Tooltip_Masque_Support_Extra"], nil, nil, 4)
    enableMasque:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    enableMasque:Disable()
    enableMasque:SetAlpha(0.5)


    local targetAndFocusAuraSettings = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    targetAndFocusAuraSettings:SetPoint("TOP", playerAuraFiltering, "BOTTOMRIGHT", 50, -5)
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
    sameSizeAuras:SetPoint("LEFT", targetAndFocusSmallAuraScale, "RIGHT", 3, 2)
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

    local targetAndFocusAurasPerRow = CreateSlider(playerAuraFiltering, L["Max_Auras_Per_Row"], 1, 12, 1, "targetAndFocusAurasPerRow")
    targetAndFocusAurasPerRow:SetPoint("TOPLEFT", targetAndFocusSmallAuraScale, "BOTTOMLEFT", 0, -17)

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

    local showAuraCdText = CreateCheckbox("showAuraCdText", L["Show_Aura_Timer_Text"], playerAuraFiltering)
    CreateTooltipTwo(showAuraCdText, L["Show_Aura_Timer_Text"], L["Tooltip_Show_Aura_Timer_Text"])

    local auraCdTextSize = CreateSlider(showAuraCdText, L["Aura_CD_Text_Size"], 0.25, 1.5, 0.01, "auraCdTextSize")
    auraCdTextSize:SetPoint("TOPLEFT", auraStackSize, "BOTTOMLEFT", 0, -17)
    CreateTooltip(auraCdTextSize, L["Tooltip_Aura_CD_Text_Size"])

    showAuraCdText:SetPoint("LEFT", auraCdTextSize, "RIGHT", 3, 2)

    local auraCdTextOnlyMine = CreateCheckbox("auraCdTextOnlyMine", L["Only_Mine"], showAuraCdText)
    auraCdTextOnlyMine:SetPoint("LEFT", showAuraCdText.text, "RIGHT", 3, 0)
    CreateTooltipTwo(auraCdTextOnlyMine, L["Aura_CD_Text_Only_Mine"], L["Tooltip_Aura_CD_Text_Only_Mine"])

    showAuraCdText:HookScript("OnClick", function(self)
        if self:GetChecked() then
            EnableElement(auraCdTextSize)
            EnableElement(auraCdTextOnlyMine)
        else
            DisableElement(auraCdTextSize)
            DisableElement(auraCdTextOnlyMine)
        end
    end)

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



    local changePurgeTextureColor = CreateCheckbox("changePurgeTextureColor", L["Change_Purge_Texture_Color"], playerAuraFiltering)
    changePurgeTextureColor:SetPoint("TOPLEFT", auraCdTextSize, "BOTTOMLEFT", 0, -2)
    CreateTooltip(changePurgeTextureColor, L["Change_Purge_Texture_Color"])

    local increaseAuraStrata = CreateCheckbox("increaseAuraStrata", L["Increase_Aura_Frame_Strata"], playerAuraFiltering)
    increaseAuraStrata:SetPoint("TOPLEFT", changePurgeTextureColor, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(increaseAuraStrata, L["Increase_Aura_Frame_Strata"], L["Tooltip_Increase_Aura_Frame_Strata"])
    increaseAuraStrata:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local hideUnitframeAuraTooltips = CreateCheckbox("hideUnitframeAuraTooltips", L["Hide_UnitFrame_Aura_Tooltips"], playerAuraFiltering)
    hideUnitframeAuraTooltips:SetPoint("TOPLEFT", increaseAuraStrata, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideUnitframeAuraTooltips, L["Hide_UnitFrame_Aura_Tooltips"], L["Tooltip_Hide_UnitFrame_Aura_Tooltips"])

    local pixelBorderAuras = CreateCheckbox("pixelBorderAuras", L["Pixel_Border_Auras"], playerAuraFiltering)
    pixelBorderAuras:SetPoint("TOPLEFT", hideUnitframeAuraTooltips, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(pixelBorderAuras, L["Pixel_Border_Auras"], L["Tooltip_Pixel_Border_Auras_Desc"])
    pixelBorderAuras:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local removeDebuffColorBorder = CreateCheckbox("removeDebuffColorBorder", L["Remove_Debuff_Color_Border"], playerAuraFiltering)
    removeDebuffColorBorder:SetPoint("TOPLEFT", pixelBorderAuras, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(removeDebuffColorBorder, L["Remove_Debuff_Color_Border"], L["Tooltip_Remove_Debuff_Color_Border"])
    removeDebuffColorBorder:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local hideTargetBuffs = CreateCheckbox("hideTargetBuffs", L["Hide_Target_Buffs"], playerAuraFiltering)
    hideTargetBuffs:SetPoint("TOPLEFT", removeDebuffColorBorder, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideTargetBuffs, L["Hide_Target_Buffs"], L["Tooltip_Hide_Target_Buffs_Desc"])
    hideTargetBuffs:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local hideTargetDebuffs = CreateCheckbox("hideTargetDebuffs", L["Hide_Target_Debuffs"], playerAuraFiltering)
    hideTargetDebuffs:SetPoint("TOPLEFT", hideTargetBuffs, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideTargetDebuffs, L["Hide_Target_Debuffs"], L["Tooltip_Hide_Target_Debuffs_Desc"])
    hideTargetDebuffs:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local hideFocusBuffs = CreateCheckbox("hideFocusBuffs", L["Hide_Focus_Buffs"], playerAuraFiltering)
    hideFocusBuffs:SetPoint("TOPLEFT", hideTargetDebuffs, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideFocusBuffs, L["Hide_Focus_Buffs"], L["Tooltip_Hide_Focus_Buffs_Desc"])
    hideFocusBuffs:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local hideFocusDebuffs = CreateCheckbox("hideFocusDebuffs", L["Hide_Focus_Debuffs"], playerAuraFiltering)
    hideFocusDebuffs:SetPoint("TOPLEFT", hideFocusBuffs, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideFocusDebuffs, L["Hide_Focus_Debuffs"], L["Tooltip_Hide_Focus_Debuffs_Desc"])
    hideFocusDebuffs:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local enableMaxTargetFocusBuffs = CreateCheckbox("enableMaxTargetFocusBuffs", L["Max_Buffs"], playerAuraFiltering)
    enableMaxTargetFocusBuffs:SetPoint("TOPLEFT", hideFocusDebuffs, "BOTTOMLEFT", 0, 3)
    CreateTooltip(enableMaxTargetFocusBuffs, L["Max_Buffs"])

    local maxTargetFocusBuffsSlider = CreateSlider(enableMaxTargetFocusBuffs, "", 1, 100, 1, "maxTargetFocusBuffs", nil, 80)
    maxTargetFocusBuffsSlider:SetPoint("LEFT", enableMaxTargetFocusBuffs.text, "RIGHT", 5, -3)
    maxTargetFocusBuffsSlider:SetScale(0.9)
    maxTargetFocusBuffsSlider.integerOnly = true

    enableMaxTargetFocusBuffs:HookScript("OnClick", function(self)
        if self:GetChecked() then
            EnableElement(maxTargetFocusBuffsSlider)
        else
            DisableElement(maxTargetFocusBuffsSlider)
        end
        BBF.RefreshAllAuraFrames()
    end)

    if not BetterBlizzFramesDB.enableMaxTargetFocusBuffs then
        DisableElement(maxTargetFocusBuffsSlider)
    end

    local enableMaxTargetFocusDebuffs = CreateCheckbox("enableMaxTargetFocusDebuffs", L["Max_Debuffs"], playerAuraFiltering)
    enableMaxTargetFocusDebuffs:SetPoint("TOPLEFT", enableMaxTargetFocusBuffs, "BOTTOMLEFT", 0, 1)
    CreateTooltip(enableMaxTargetFocusDebuffs, L["Max_Debuffs"])

    local maxTargetFocusDebuffsSlider = CreateSlider(enableMaxTargetFocusDebuffs, "", 1, 100, 1, "maxTargetFocusDebuffs", nil, 80)
    maxTargetFocusDebuffsSlider:SetPoint("LEFT", enableMaxTargetFocusDebuffs.text, "RIGHT", 5, -3)
    maxTargetFocusDebuffsSlider:SetScale(0.9)
    maxTargetFocusDebuffsSlider.integerOnly = true

    enableMaxTargetFocusDebuffs:HookScript("OnClick", function(self)
        if self:GetChecked() then
            EnableElement(maxTargetFocusDebuffsSlider)
        else
            DisableElement(maxTargetFocusDebuffsSlider)
        end
        BBF.RefreshAllAuraFrames()
    end)

    if not BetterBlizzFramesDB.enableMaxTargetFocusDebuffs then
        DisableElement(maxTargetFocusDebuffsSlider)
    end


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
    CreateTooltip(dispelGlowButton, L["Change_Purge_Texture_Color"])


    playerAuraFiltering:HookScript("OnClick", function (self)
        if self:GetChecked() then
            --asd
        else
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end

        CheckAndToggleCheckboxes(playerAuraFiltering)
    end)

    local playerAuraSettings = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerAuraSettings:SetPoint("TOP", playerAuraFiltering, "BOTTOMRIGHT", 350, -5)
    playerAuraSettings:SetText(L["Player_Aura_Settings"])

    local enablePlayerBuffFiltering = CreateCheckbox("enablePlayerBuffFiltering", L["Enable_Player_Aura_Adjustments"], playerAuraFiltering)
    enablePlayerBuffFiltering:SetPoint("TOPLEFT", playerAuraSettings, "BOTTOMLEFT", -10, 0)

    local clickthroughPlayerAuras = CreateCheckbox("clickthroughPlayerAuras", L["Clickthrough_Player_Auras"], enablePlayerBuffFiltering)
    clickthroughPlayerAuras:SetPoint("TOPLEFT", enablePlayerBuffFiltering, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(clickthroughPlayerAuras, L["Tooltip_Clickthrough_Player_Auras"], "ANCHOR_LEFT")

    local hidePlayerAuraTooltips = CreateCheckbox("hidePlayerAuraTooltips", L["Hide_Player_Aura_Tooltips"], enablePlayerBuffFiltering)
    hidePlayerAuraTooltips:SetPoint("TOPLEFT", clickthroughPlayerAuras, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hidePlayerAuraTooltips, L["Tooltip_Hide_Player_Aura_Tooltips"], "ANCHOR_LEFT")

    local playerAuraSpacingX = CreateSlider(enablePlayerBuffFiltering, L["Horizontal_Padding"], 0, 10, 1, "playerAuraSpacingX", "X")
    playerAuraSpacingX:SetPoint("TOPLEFT", hidePlayerAuraTooltips, "BOTTOMLEFT", 0, -20)
    CreateTooltip(playerAuraSpacingX, L["Tooltip_Horizontal_Aura_Padding"], "ANCHOR_LEFT")

    local playerAuraSpacingY = CreateSlider(enablePlayerBuffFiltering, L["Vertical_Padding"], -10, 10, 1, "playerAuraSpacingY", "Y")
    playerAuraSpacingY:SetPoint("TOP", playerAuraSpacingX, "BOTTOM", 0, -15)

    enablePlayerBuffFiltering:HookScript("OnClick", function (self)
        CheckAndToggleCheckboxes(enablePlayerBuffFiltering)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local betaHighlightIcon = playerAuraFiltering:CreateTexture(nil, "BACKGROUND")
    betaHighlightIcon:SetAtlas("CharacterCreate-NewLabel")
    betaHighlightIcon:SetSize(42, 34)
    betaHighlightIcon:SetPoint("RIGHT", playerAuraFiltering, "LEFT", 8, 0)
end


-- Export tab function to BBF
BBF.guiFrameAuras = guiFrameAuras
