if not BBF.isMidnight then return end
local addonName, BBF = ...
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

local function guiProfiles()
    local parent = SettingsPanel
    local frame = CreateFrame("Frame", nil, BetterBlizzFrames, "SettingsFrameTemplate")
    frame.titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.titleText:SetPoint("TOP", frame, "TOP", 1, -4)
    frame.titleText:SetText("|A:gmchat-icon-blizz:16:16|a BBF")

    frame.descriptionText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.descriptionText:SetPoint("TOP", frame, "TOP", 2, -25)
    frame.descriptionText:SetText(L["Profile_Description"])
    frame.descriptionText:SetWidth(100)

    frame.coreText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.coreText:SetPoint("TOP", frame.descriptionText, "BOTTOM", 0, -3)
    frame.coreText:SetText(L["Profile_Core"])

    frame.streamerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.streamerText:SetPoint("TOP", frame.coreText, "BOTTOM", 0, -55)
    frame.streamerText:SetText(L["Profile_Streamers"])

    frame.infoText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.infoText:SetPoint("BOTTOM", frame, "BOTTOM", 2, 100)
    frame.infoText:SetText(L["Profile_Info_Message"])
    frame.infoText:SetWidth(100)

    frame:SetSize(130, parent:GetHeight())
    frame:SetPoint("TOPRIGHT", parent, "TOPLEFT", 7, 0)
    frame:SetFrameStrata("BACKGROUND")
    frame.ClosePanelButton:Hide()

    local function CopyNineSliceColors(fromFrame, toFrame)
        if not (fromFrame and toFrame and fromFrame.NineSlice and toFrame.NineSlice) then
            return
        end

        local parts = {
            "TopLeftCorner", "TopRightCorner",
            "BottomLeftCorner", "BottomRightCorner",
            "TopEdge", "BottomEdge",
            "LeftEdge", "RightEdge",
            "Center",
        }

        for _, name in ipairs(parts) do
            local src = fromFrame.NineSlice[name]
            local dst = toFrame.NineSlice[name]
            if src and dst and src.GetVertexColor and dst.SetVertexColor then
                local r, g, b, a = src:GetVertexColor()
                dst:SetVertexColor(r, g, b, a)

                if src.IsDesaturated and dst.SetDesaturated then
                    dst:SetDesaturated(src:IsDesaturated())
                end
            end
        end
    end

    CopyNineSliceColors(SettingsPanel, frame)

    BetterBlizzFrames.profilesFrame = frame
    return frame
end


-- Export tab function to BBF
BBF.guiProfiles = guiProfiles
