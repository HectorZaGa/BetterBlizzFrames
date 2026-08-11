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

function guiCooldownManager()
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

