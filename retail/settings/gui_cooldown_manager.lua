local BBF = _G.BBF
if not BBF or BBF.isMidnight then return end
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

local function guiCooldownManager()
    local guiCdManager = CreateFrame("Frame")
    guiCdManager.name = L["Module_Name_CD_Manager"]
    guiCdManager.parent = BetterBlizzFrames.name
    --InterfaceOptions_AddCategory(guiCdManager)
    local guiCdManagerSubcategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiCdManager, guiCdManager.name, guiCdManager.name)
    guiCdManagerSubcategory.ID = guiCdManager.name;
    CreateTitle(guiCdManager)

    local bgImg = guiCdManager:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", guiCdManager, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local settingsText = guiCdManager:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    settingsText:SetPoint("TOPLEFT", guiCdManager, "TOPLEFT", 20, 0)
    settingsText:SetText(L["Cooldown_Manager"])
    local cdIcon = guiCdManager:CreateTexture(nil, "ARTWORK")
    cdIcon:SetAtlas("questlog-questtypeicon-clockorange")
    cdIcon:SetSize(22, 22)
    cdIcon:SetPoint("RIGHT", settingsText, "LEFT", -3, -1)

    local cdNote = guiCdManager:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cdNote:SetPoint("BOTTOMLEFT", bgImg, "BOTTOMLEFT", 10, 5)
    cdNote:SetFont(fontSmall, 11)
    cdNote:SetText(L["CD_Manager_WIP"])

    local list = CreateCDManagerList(guiCdManager)

    local cooldownViewerEnabled = CreateCheckbox("cooldownViewerEnabled", L["Enable_Cooldown_Manager"], guiCdManager, "cooldownViewerEnabled")
    cooldownViewerEnabled:SetPoint("TOPLEFT", settingsText, "BOTTOMLEFT", -4, pixelsOnFirstBox)
    cooldownViewerEnabled:HookScript("OnClick", function(self)
        local enabled = self:GetChecked()
        if not InCombatLockdown() then
            C_CVar.SetCVar("cooldownViewerEnabled", enabled and "1" or "0")
        end
    end)
    CreateTooltipTwo(cooldownViewerEnabled, L["Enable_Cooldown_Manager"], L["Enable_Cooldown_Manager_11_1_5"])
    cooldownViewerEnabled:SetChecked(C_CVar.GetCVarBool("cooldownViewerEnabled"))

    local cdManagerSorting = CreateCheckbox("cdManagerSorting", L["Filter_Sort_Icons"], guiCdManager, nil, BBF.HookCooldownManagerTweaks)
    cdManagerSorting:SetPoint("TOPLEFT", cooldownViewerEnabled, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(cdManagerSorting, L["Filter_Sort_Icons"], L["Filter_Sort_CDM_Icons"])
    list:SetAlpha(BetterBlizzFramesDB.cdManagerSorting and 1 or 0.3)


    local cdManagerCenterIcons = CreateCheckbox("cdManagerCenterIcons", L["CDM_Center_Icons"], guiCdManager, nil, BBF.HookCooldownManagerTweaks)
    cdManagerCenterIcons:SetPoint("TOPLEFT", cdManagerSorting, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(cdManagerCenterIcons, L["CDM_Center_Icons"], L["CDM_Center_Icons_Tooltip"])
    cdManagerCenterIcons:HookScript("OnClick", function(self)
        if not self:GetChecked() and not cdManagerCenterIcons:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    cdManagerSorting:HookScript("OnClick", function(self)
        local enabled = self:GetChecked()
        if not enabled and not cdManagerCenterIcons:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
        list:SetAlpha(enabled and 1 or 0.3)
    end)
end


-- Export tab function to BBF
BBF.guiCooldownManager = guiCooldownManager
