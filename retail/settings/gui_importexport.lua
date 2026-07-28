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

function guiImportAndExport()
    local guiImportAndExport = CreateFrame("Frame")
    guiImportAndExport.name = L["Module_Name_Import_Export"]
    guiImportAndExport.parent = BetterBlizzFrames.name
    --InterfaceOptions_AddCategory(guiImportAndExport)
    local guiImportSubcategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiImportAndExport, guiImportAndExport.name, guiImportAndExport.name)
    guiImportSubcategory.ID = guiImportAndExport.name;
    CreateTitle(guiImportAndExport)

    local bgImg = guiImportAndExport:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", guiImportAndExport, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local fullProfile = CreateImportExportUI(guiImportAndExport, L["Full_Profile"], BetterBlizzFramesDB, 20, -20, "fullProfile")

    local auraWhitelist = CreateImportExportUI(fullProfile, L["Aura_Whitelist"], BetterBlizzFramesDB.auraWhitelist, 0, -100, "auraWhitelist")
    local auraBlacklist = CreateImportExportUI(auraWhitelist, L["Aura_Blacklist"], BetterBlizzFramesDB.auraBlacklist, 210, 0, "auraBlacklist")

    local importPVPWhitelist = CreateFrame("Button", nil, guiImportAndExport, "UIPanelButtonTemplate")
    importPVPWhitelist:SetSize(150, 35)
    importPVPWhitelist:SetPoint("TOP", auraWhitelist, "BOTTOM", 0, -25)
    importPVPWhitelist:SetText(L["Import_PvP_Whitelist"])
    importPVPWhitelist:SetScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_PVP_WHITELIST")
    end)
    local coloredText = L["Whitelist_Colors"]

    CreateTooltipTwo(importPVPWhitelist, L["Import_PvP_Whitelist"], string.format(L["Tooltip_Import_PvP_Whitelist_Desc"], coloredText))

    local importPVPBlacklist = CreateFrame("Button", nil, guiImportAndExport, "UIPanelButtonTemplate")
    importPVPBlacklist:SetSize(150, 35)
    importPVPBlacklist:SetPoint("TOP", auraBlacklist, "BOTTOM", 0, -25)
    importPVPBlacklist:SetText(L["Import_PvP_Blacklist"])
    importPVPBlacklist:SetScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_PVP_BLACKLIST")
    end)
    CreateTooltipTwo(importPVPBlacklist, L["Import_PvP_Blacklist"], L["Tooltip_Import_PvP_Blacklist_Desc"])

end

