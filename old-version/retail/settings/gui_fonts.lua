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

function guiFrameLook()
    ----------------------
    -- Frame Auras
    ----------------------
    local guiFrameLook = CreateFrame("Frame")
    guiFrameLook.name = L["Module_Name_Font_Texture"]
    guiFrameLook.parent = BetterBlizzFrames.name
    --InterfaceOptions_AddCategory(guiFrameAuras)
    local aurasSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiFrameLook, guiFrameLook.name, guiFrameLook.name)
    aurasSubCategory.ID = guiFrameLook.name;
    CreateTitle(guiFrameLook)

    local bgImg = guiFrameLook:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", guiFrameLook, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local mainGuiAnchor = guiFrameLook:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor:SetPoint("TOPLEFT", 15, -15)
    mainGuiAnchor:SetText(" ")

    local settingsText = guiFrameLook:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    settingsText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 0, 30)
    settingsText:SetText(L["Font_And_Texture_WIP"])
    local generalSettingsIcon = guiFrameLook:CreateTexture(nil, "ARTWORK")
    generalSettingsIcon:SetAtlas("optionsicon-brown")
    generalSettingsIcon:SetSize(22, 22)
    generalSettingsIcon:SetPoint("RIGHT", settingsText, "LEFT", -3, -1)

    local howToImport = guiFrameLook:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    howToImport:SetFont(fontLarge, 16)
    howToImport:SetPoint("CENTER", mainGuiAnchor, "BOTTOMLEFT", 415, -365)
    howToImport:SetText(L["How_To_Import"])

    local howStepOne = guiFrameLook:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    howStepOne:SetJustifyH("LEFT")
    howStepOne:SetFont(fontMedium, 12)
    howStepOne:SetPoint("TOPLEFT", howToImport, "BOTTOMLEFT", -20, -10)
    howStepOne:SetText(L["How_Custom_Media"])

    local fontEditBox = CreateFrame("EditBox", nil, guiFrameLook, "InputBoxTemplate")
    fontEditBox:SetSize(330, 20)
    fontEditBox:SetPoint("TOPLEFT", howStepOne, "BOTTOMLEFT", 5, -5)
    fontEditBox:SetAutoFocus(false)
    fontEditBox:SetText("BBF.AddFont(\"MyFontName\")")
    fontEditBox:HighlightText()
    fontEditBox:SetCursorPosition(0)
    fontEditBox:SetScript("OnTextChanged", function(self)
        fontEditBox:SetText("BBF.AddFont(\"MyFontName\")")
    end)
    fontEditBox:SetScript("OnMouseUp", function(self)
        self:SetFocus()
        self:HighlightText()
    end)

    local howStepTwo = guiFrameLook:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    howStepTwo:SetJustifyH("LEFT")
    howStepTwo:SetFont(fontMedium, 12)
    howStepTwo:SetPoint("TOPLEFT", fontEditBox, "BOTTOMLEFT", -5, -13)
    howStepTwo:SetText(L["How_Custom_Media_2"])

    local textureEditBox = CreateFrame("EditBox", nil, guiFrameLook, "InputBoxTemplate")
    textureEditBox:SetSize(330, 20)
    textureEditBox:SetPoint("TOPLEFT", howStepTwo, "BOTTOMLEFT", 5, -5)
    textureEditBox:SetAutoFocus(false)
    textureEditBox:SetText("BBF.AddTexture(\"MyTextureName\")")
    textureEditBox:HighlightText()
    textureEditBox:SetCursorPosition(0)
    textureEditBox:SetScript("OnTextChanged", function(self)
        textureEditBox:SetText("BBF.AddTexture(\"MyTextureName\")")
    end)
    textureEditBox:SetScript("OnMouseUp", function(self)
        self:SetFocus()
        self:HighlightText()
    end)

    local howStepThree = guiFrameLook:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    howStepThree:SetJustifyH("LEFT")
    howStepThree:SetFont(fontMedium, 12)
    howStepThree:SetPoint("TOPLEFT", textureEditBox, "BOTTOMLEFT", -5, -13)
    howStepThree:SetText(L["How_Custom_Media_3"])
    howStepThree:SetWidth(330)

    local changeUnitFrameFont = CreateCheckbox("changeUnitFrameFont", L["Tooltip_Change_UnitFrame_Font_Desc"], guiFrameLook)
    changeUnitFrameFont:SetPoint("TOPLEFT", settingsText, "BOTTOMLEFT", -4, pixelsOnFirstBox)
    CreateTooltipTwo(changeUnitFrameFont, L["Tooltip_Change_UnitFrame_Font_Desc"], L["Tooltip_Change_ActionBar_Font"])

    local unitFrameFontColor = CreateCheckbox("unitFrameFontColor", L["Color"], guiFrameLook)
    unitFrameFontColor:SetPoint("LEFT", changeUnitFrameFont.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(unitFrameFontColor, L["Color"], L["Tooltip_Font_Color"])
    unitFrameFontColor:HookScript("OnClick", function()
        BBF.FontColors()
    end)
    unitFrameFontColor:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            OpenColorOptions(BetterBlizzFramesDB.unitFrameFontColorRGB,  BBF.FontColors)
        end
    end)

    local unitFrameFontColorLvl = CreateCheckbox("unitFrameFontColorLvl", L["FontTexture_Color_Level"], guiFrameLook)
    unitFrameFontColorLvl:SetPoint("LEFT", unitFrameFontColor.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(unitFrameFontColorLvl, L["FontTexture_Color_Level"], L["Tooltip_Color_Level_Font_Desc"])
    unitFrameFontColorLvl:HookScript("OnClick", function()
        BBF.FontColors()
    end)

    local unitFrameFont = CreateFontDropdown(
        "unitFrameFont",
        guiFrameLook,
        "Select Font",
        "unitFrameFont",
        function(arg1)
            BBF.SetCustomFonts()
        end,
        { anchorFrame = changeUnitFrameFont, x = 55, y = 1, label = L["Font"] }
    )

    -- For font outline
    local unitFrameFontOutline = CreateSimpleDropdown("FontOutlineDropdown", guiFrameLook, L["Outline_Label"], "unitFrameFontOutline", {
        "THICKOUTLINE", "OUTLINE", ""
    }, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = unitFrameFont, x = 0, y = -5 }, 155)

    -- For font size
    local fontSizeOptions = {}
    for i = 6, 24 do
        table.insert(fontSizeOptions, tostring(i))
    end

    local unitFrameFontSize = CreateSimpleDropdown("FontSizeDropdown", guiFrameLook, L["Size"], "unitFrameFontSize", fontSizeOptions, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = unitFrameFontOutline, x = 0, y = -5 }, 155)

    changeUnitFrameFont:HookScript("OnClick", function(self)
        BBF.SetCustomFonts()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
            unitFrameFont:Disable()
            unitFrameFontOutline:Disable()
            unitFrameFontSize:Disable()
        else
            unitFrameFont:Enable()
            unitFrameFontOutline:Enable()
            unitFrameFontSize:Enable()
        end
    end)

    if not changeUnitFrameFont:GetChecked() then
        unitFrameFont:Disable()
        unitFrameFontOutline:Disable()
        unitFrameFontSize:Disable()
    end





    local changeUnitFrameValueFont = CreateCheckbox("changeUnitFrameValueFont", L["Tooltip_Change_UnitFrame_Number_Font_Desc"], guiFrameLook)
    changeUnitFrameValueFont:SetPoint("TOPLEFT", changeUnitFrameFont, "BOTTOMLEFT", 0, -100)
    CreateTooltipTwo(changeUnitFrameValueFont, L["Tooltip_Change_UnitFrame_Number_Font_Desc"], L["Tooltip_Change_Number_Font"])

    local unitFrameValueFontColor = CreateCheckbox("unitFrameValueFontColor", L["Color"], guiFrameLook)
    unitFrameValueFontColor:SetPoint("LEFT", changeUnitFrameValueFont.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(unitFrameValueFontColor, L["UnitFrame_Numbers_Font_Color"], L["Tooltip_UnitFrame_Numbers_Font_Color_Desc"])
    unitFrameValueFontColor:HookScript("OnClick", function()
        BBF.FontColors()
    end)
    unitFrameValueFontColor:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            OpenColorOptions(BetterBlizzFramesDB.unitFrameValueFontColorRGB,  BBF.FontColors)
        end
    end)

    local unitFrameValueFont = CreateFontDropdown(
        "unitFrameValueFont",
        guiFrameLook,
        "Select Font",
        "unitFrameValueFont",
        function(arg1)
            BBF.SetCustomFonts()
        end,
        { anchorFrame = changeUnitFrameValueFont, x = 55, y = 1, label = L["Font"] }
    )

    -- For font outline
    local unitFrameValueFontOutline = CreateSimpleDropdown("FontOutlineDropdown", guiFrameLook, L["Outline_Label"], "unitFrameValueFontOutline", {
        "THICKOUTLINE", "OUTLINE", ""
    }, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = unitFrameValueFont, x = 0, y = -5 }, 155)

    local unitFrameValueFontSize = CreateSimpleDropdown("FontSizeDropdown", guiFrameLook, L["Size"], "unitFrameValueFontSize", fontSizeOptions, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = unitFrameValueFontOutline, x = 0, y = -5 }, 155)

    changeUnitFrameValueFont:HookScript("OnClick", function(self)
        BBF.SetCustomFonts()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
            unitFrameValueFont:Disable()
            unitFrameValueFontOutline:Disable()
            unitFrameValueFontSize:Disable()
        else
            unitFrameValueFont:Enable()
            unitFrameValueFontOutline:Enable()
            unitFrameValueFontSize:Enable()
        end
    end)

    if not changeUnitFrameValueFont:GetChecked() then
        unitFrameValueFont:Disable()
        unitFrameValueFontOutline:Disable()
        unitFrameValueFontSize:Disable()
    end





    local changePartyFrameFont = CreateCheckbox("changePartyFrameFont", L["Change_Party_Font"], guiFrameLook)
    changePartyFrameFont:SetPoint("TOPLEFT", changeUnitFrameValueFont, "BOTTOMLEFT", 0, -100)
    CreateTooltipTwo(changePartyFrameFont, L["Change_Party_Font"], L["Tooltip_Change_Party_Font"])

    local partyFrameFontColor = CreateCheckbox("partyFrameFontColor", L["Color"], guiFrameLook)
    partyFrameFontColor:SetPoint("LEFT", changePartyFrameFont.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(partyFrameFontColor, L["Color"], L["Tooltip_Party_Font_Color"])
    partyFrameFontColor:HookScript("OnClick", function()
        BBF.FontColors()
    end)
    partyFrameFontColor:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            OpenColorOptions(BetterBlizzFramesDB.partyFrameFontColorRGB,  BBF.FontColors)
        end
    end)

    local partyFrameFont = CreateFontDropdown(
        "partyFrameFont",
        guiFrameLook,
        "Select Font",
        "partyFrameFont",
        function(arg1)
            BBF.SetCustomFonts()
        end,
        { anchorFrame = changePartyFrameFont, x = 55, y = 1, label = L["Font"] }
    )

    -- For font outline
    local partyFrameFontOutline = CreateSimpleDropdown("FontOutlineDropdown", guiFrameLook, L["Outline_Label"], "partyFrameFontOutline", {
        "THICKOUTLINE", "OUTLINE", ""
    }, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = partyFrameFont, x = 0, y = -5 }, 155)

    local partyFrameFontSize = CreateSimpleDropdown("FontSizeDropdown", guiFrameLook, L["Size"], "partyFrameFontSize", fontSizeOptions, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = partyFrameFontOutline, x = 0, y = -5 }, 77.5)
    CreateTooltipTwo(partyFrameFontSize, L["Tooltip_Name_Size"])

    local partyFrameStatusFontSize = CreateSimpleDropdown("FontSizeDropdown", guiFrameLook, "", "partyFrameStatusFontSize", fontSizeOptions, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = partyFrameFontSize, x = 77.5, y = 25 }, 77.5)
    CreateTooltipTwo(partyFrameStatusFontSize, L["Tooltip_Status_Text_Size"])

    changePartyFrameFont:HookScript("OnClick", function(self)
        BBF.SetCustomFonts()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
            partyFrameFont:Disable()
            partyFrameFontOutline:Disable()
            partyFrameFontSize:Disable()
            partyFrameStatusFontSize:Disable()
        else
            partyFrameFont:Enable()
            partyFrameFontOutline:Enable()
            partyFrameFontSize:Enable()
            partyFrameStatusFontSize:Enable()
        end
    end)

    if not changePartyFrameFont:GetChecked() then
        partyFrameFont:Disable()
        partyFrameFontOutline:Disable()
        partyFrameFontSize:Disable()
        partyFrameStatusFontSize:Disable()
    end


    local changeActionBarFont = CreateCheckbox("changeActionBarFont", L["Change_ActionBar_Font"], guiFrameLook)
    changeActionBarFont:SetPoint("TOPLEFT", changePartyFrameFont, "BOTTOMLEFT", 0, -100)
    CreateTooltipTwo(changeActionBarFont, L["Change_ActionBar_Font"], L["Tooltip_Change_ActionBar_Font"])

    local actionBarFontColor = CreateCheckbox("actionBarFontColor", L["Color"], guiFrameLook)
    actionBarFontColor:SetPoint("LEFT", changeActionBarFont.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(actionBarFontColor, L["Color"], L["Tooltip_ActionBar_Font_Color"])
    actionBarFontColor:HookScript("OnClick", function()
        BBF.FontColors()
    end)
    actionBarFontColor:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            OpenColorOptions(BetterBlizzFramesDB.actionBarFontColorRGB,  BBF.FontColors)
        end
    end)

    local actionBarChangeCharge = CreateCheckbox("actionBarChangeCharge", L["Charges"], guiFrameLook)
    actionBarChangeCharge:SetPoint("LEFT", actionBarFontColor.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(actionBarChangeCharge, L["Charges"], L["Tooltip_Charges"])

    local actionBarFont = CreateFontDropdown(
        "actionBarFont",
        guiFrameLook,
        "Select Font",
        "actionBarFont",
        function(arg1)
            BBF.SetCustomFonts()
        end,
        { anchorFrame = changeActionBarFont, x = 55, y = 1, label = L["Font"] }
    )

    -- For font outline
    local actionBarFontOutline = CreateSimpleDropdown("FontOutlineDropdown", guiFrameLook, L["Outline_Label"], "actionBarFontOutline", {
        "THICKOUTLINE", "OUTLINE", ""
    }, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = actionBarFont, x = 0, y = -5 }, 77.5)
    CreateTooltipTwo(actionBarFontOutline, L["Tooltip_Macro_Text_Outline"])

    local actionBarKeyFontOutline = CreateSimpleDropdown("FontOutlineDropdown", guiFrameLook, "", "actionBarKeyFontOutline", {
        "THICKOUTLINE", "OUTLINE", ""
    }, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = actionBarFontOutline, x = 77.5, y = 25 }, 77.5)
    CreateTooltipTwo(actionBarKeyFontOutline, L["Tooltip_Keybinding_Text_Outline"])

    local actionBarFontSize = CreateSimpleDropdown("FontSizeDropdown", guiFrameLook, L["Size"], "actionBarFontSize", fontSizeOptions, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = actionBarFontOutline, x = 0, y = -5 }, 77.5)
    CreateTooltipTwo(actionBarFontSize, L["Tooltip_Macro_Text_Size"])

    local actionBarKeyFontSize = CreateSimpleDropdown("FontSizeDropdown", guiFrameLook, "", "actionBarKeyFontSize", fontSizeOptions, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = actionBarFontSize, x = 77.5, y = 25 }, 77.5)
    CreateTooltipTwo(actionBarKeyFontSize, L["Tooltip_Keybinding_Text_Size"])

    local actionBarChargeFontSize = CreateSimpleDropdown("FontSizeDropdown", guiFrameLook, "", "actionBarChargeFontSize", fontSizeOptions, function(selectedSize)
        BBF.SetCustomFonts()
    end, { anchorFrame = actionBarFontSize, x = 77.5, y = 0 }, 77.5)
    CreateTooltipTwo(actionBarChargeFontSize, L["Tooltip_Charge_Text_Size"])

    local function ToggleDropdowns(enable)
        for _, dd in ipairs({
            actionBarFont,
            actionBarFontOutline,
            actionBarKeyFontOutline,
            actionBarFontSize,
            actionBarKeyFontSize
        }) do
            dd:SetEnabled(enable)
        end
        actionBarChargeFontSize:SetEnabled(enable and actionBarChangeCharge:GetChecked())
    end

    changeActionBarFont:HookScript("OnClick", function(self)
        BBF.SetCustomFonts()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
        ToggleDropdowns(self:GetChecked())
    end)

    actionBarChangeCharge:HookScript("OnClick", function(self)
        BBF.FontColors()
        actionBarChargeFontSize:SetEnabled(changeActionBarFont:GetChecked() and self:GetChecked())
    end)

    ToggleDropdowns(changeActionBarFont:GetChecked())










    local changeAllFontsIngame = CreateCheckbox("changeAllFontsIngame", L["Tooltip_One_Font_All_Text_Desc"], guiFrameLook)
    changeAllFontsIngame:SetPoint("TOPLEFT", changeActionBarFont, "BOTTOMLEFT", 0, -115)
    CreateTooltipTwo(changeAllFontsIngame, L["Tooltip_One_Font_All_Text_Desc"], L["Tooltip_One_Font"], L["Tooltip_One_Font_Note"])

    local allIngameFont = CreateFontDropdown(
        "allIngameFont",
        guiFrameLook,
        "Select Font",
        "allIngameFont",
        function(arg1)
            BBF.SetCustomFonts()
        end,
        { anchorFrame = changeAllFontsIngame, x = 55, y = 1, label = L["Font"] }
    )

    changeAllFontsIngame:HookScript("OnClick", function(self)
        BBF.SetCustomFonts()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
        allIngameFont:SetEnabled(self:GetChecked())
    end)
    allIngameFont:SetEnabled(changeAllFontsIngame:GetChecked())







    local changeUnitFrameHealthbarTexture = CreateCheckbox("changeUnitFrameHealthbarTexture", L["Tooltip_Change_UnitFrame_Healthbar_Texture_Desc"], guiFrameLook)
    changeUnitFrameHealthbarTexture:SetPoint("TOPLEFT", settingsText, "BOTTOMLEFT", 260, pixelsOnFirstBox)
    if not BetterBlizzFramesDB.classicFrames then
        CreateTooltipTwo(changeUnitFrameHealthbarTexture, L["Tooltip_Change_UnitFrame_Healthbar_Texture_Desc"], L["Tooltip_Healthbar_Texture"])
    else
        CreateTooltipTwo(changeUnitFrameHealthbarTexture, L["Tooltip_Change_UnitFrame_Healthbar_Texture_Desc"], L["Tooltip_Healthbar_Texture_Classic"])
            changeUnitFrameHealthbarTexture:HookScript("OnMouseDown", function(self, button)
            if button == "RightButton" then
                if not BetterBlizzFramesDB.changeUnitFrameHealthbarTextureRepColor then
                    BetterBlizzFramesDB.changeUnitFrameHealthbarTextureRepColor = true
                else
                    BetterBlizzFramesDB.changeUnitFrameHealthbarTextureRepColor = nil
                end
                local function retexture(tex)
                    if not tex then return end
                    tex:SetTexture((BetterBlizzFramesDB.changeUnitFrameHealthbarTextureRepColor and LSM:Fetch(LSM.MediaType.STATUSBAR, BetterBlizzFramesDB.unitFrameHealthbarTexture) or "Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground"))
                end
                retexture(PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ReputationColor)
                retexture(TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor)
                retexture(FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor)
            end
        end)
    end

    if BetterBlizzFramesDB.classicFrames then
        local text = guiFrameLook:CreateFontString(nil, "OVERLAY")
        text:SetFont(fontSmall, 12)
        text:SetText(L["Classic_Frames_Label"])
        text:SetTextColor(1,0,0)
        CreateTooltipTwo(text, L["Classic_Frames_Healthbar"], L["Tooltip_Classic_Frames_Healthbar_Desc"], nil, "ANCHOR_BOTTOMRIGHT")
        text:SetPoint("LEFT", changeUnitFrameHealthbarTexture.Text, "RIGHT", 5, 0)
    end

    local unitFrameHealthbarTexture = CreateTextureDropdown(
        "unitFrameHealthbarTexture",
        guiFrameLook,
        "Select Texture",
        "unitFrameHealthbarTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
        end,
        { anchorFrame = changeUnitFrameHealthbarTexture, x = 5, y = 3, label = "Texture" }
    )

    changeUnitFrameHealthbarTexture:HookScript("OnClick", function(self)
        unitFrameHealthbarTexture:SetEnabled(self:GetChecked())
        BBF.UpdateCustomTextures()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    unitFrameHealthbarTexture:SetEnabled(changeUnitFrameHealthbarTexture:GetChecked())

    local changeUnitFrameManabarTexture = CreateCheckbox("changeUnitFrameManabarTexture", L["Tooltip_Change_UnitFrame_Manabar_Texture_Desc"], guiFrameLook)
    changeUnitFrameManabarTexture:SetPoint("TOPLEFT", changeUnitFrameHealthbarTexture, "BOTTOMLEFT", 0, -25)
    CreateTooltipTwo(changeUnitFrameManabarTexture, L["Tooltip_Change_UnitFrame_Manabar_Texture_Desc"], L["Tooltip_Manabar_Texture"])

    local changeUnitFrameManaBarTextureKeepFancy = CreateCheckbox("changeUnitFrameManaBarTextureKeepFancy", L["Keep_Fancy_Manabars"], changeUnitFrameManabarTexture)
    changeUnitFrameManaBarTextureKeepFancy:SetPoint("LEFT", changeUnitFrameManabarTexture.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(changeUnitFrameManaBarTextureKeepFancy, L["Keep_Fancy_Manabars"], L["Tooltip_Keep_Fancy"])
    changeUnitFrameManaBarTextureKeepFancy:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local unitFrameManabarTexture = CreateTextureDropdown(
        "unitFrameManabarTexture",
        guiFrameLook,
        "Select Texture",
        "unitFrameManabarTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
        end,
        { anchorFrame = changeUnitFrameManabarTexture, x = 5, y = 3, label = "Texture" }
    )
    changeUnitFrameManabarTexture:HookScript("OnClick", function(self)
        unitFrameManabarTexture:SetEnabled(self:GetChecked())
        BBF.UpdateCustomTextures()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
        CheckAndToggleCheckboxes(self)
    end)
    unitFrameManabarTexture:SetEnabled(changeUnitFrameManabarTexture:GetChecked())

    if BetterBlizzFramesDB.classicFrames then

        local changeUnitFrameNameBgTexture = CreateCheckbox("changeUnitFrameNameBgTexture", L["Change_Name_Bg_Texture"], guiFrameLook)
        changeUnitFrameNameBgTexture:SetPoint("TOPLEFT", settingsText, "BOTTOMLEFT", 465, -23)
        CreateTooltipTwo(changeUnitFrameNameBgTexture, L["Change_Name_Bg_Texture"], L["Tooltip_Name_Bg_Texture"])

        local unitFrameNameBgTexture = CreateTextureDropdown(
            "unitFrameNameBgTexture",
            guiFrameLook,
            "Select Texture",
            "unitFrameNameBgTexture",
            function(arg1)
                BBF.UpdateCustomTextures()
            end,
            { anchorFrame = changeUnitFrameNameBgTexture, x = 5, y = 3, label = "Texture" }
        )
        changeUnitFrameNameBgTexture:HookScript("OnClick", function(self)
            unitFrameNameBgTexture:SetEnabled(self:GetChecked())
            BBF.UpdateCustomTextures()
            if not self:GetChecked() then
                StaticPopup_Show("BBF_CONFIRM_RELOAD")
            end
        end)
        unitFrameNameBgTexture:SetEnabled(changeUnitFrameNameBgTexture:GetChecked())
    end

    local changeUnitFrameCastbarTexture = CreateCheckbox("changeUnitFrameCastbarTexture", L["Change_Castbar_Texture"], guiFrameLook)
    changeUnitFrameCastbarTexture:SetPoint("TOPLEFT", changeUnitFrameManabarTexture, "BOTTOMLEFT", 0, -25)
    CreateTooltipTwo(changeUnitFrameCastbarTexture, L["Change_Castbar_Texture"], L["Tooltip_Castbar_Texture"])

    local unitFrameCastbarTexture = CreateTextureDropdown(
        "unitFrameCastbarTexture",
        guiFrameLook,
        "Select Texture",
        "unitFrameCastbarTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
        end,
        { anchorFrame = changeUnitFrameCastbarTexture, x = 5, y = 3, label = "Texture" }
    )
    changeUnitFrameCastbarTexture:HookScript("OnClick", function(self)
        unitFrameCastbarTexture:SetEnabled(self:GetChecked())
        BBF.UpdateCustomTextures()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    unitFrameCastbarTexture:SetEnabled(changeUnitFrameCastbarTexture:GetChecked())

    local changeUnitFrameBackgroundTexture = CreateCheckbox("addUnitFrameBgTexture", L["Change_UnitFrame_Background_Texture"], guiFrameLook)
    changeUnitFrameBackgroundTexture:SetPoint("TOPLEFT", changeUnitFrameCastbarTexture, "BOTTOMLEFT", 0, -25)
    CreateTooltipTwo(changeUnitFrameBackgroundTexture, L["Change_UnitFrame_Background_Texture"], L["Tooltip_Change_UnitFrame_Background_Texture_Desc"])

    local unitFrameBgTexture = CreateTextureDropdown(
        "unitFrameBgTexture",
        guiFrameLook,
        "Select Texture",
        "unitFrameBgTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
            BBF.UnitFrameBackgroundTexture()
        end,
        { anchorFrame = changeUnitFrameBackgroundTexture, x = 5, y = 3, label = "Texture" }
    )

    local unitFrameBgTextureColorFL = CreateColorBox(guiFrameLook, "unitFrameBgTextureColor", "Health BG", function() BBF.UnitFrameBackgroundTexture() end)
    unitFrameBgTextureColorFL:SetPoint("LEFT", unitFrameBgTexture, "RIGHT", 10, 0)
    CreateTooltipTwo(unitFrameBgTextureColorFL, "Health Bar Background Color", "Left-click to change.\n\n|cff32f795Shift+Right-click to reset to default.|r")

    local unitFrameBgTextureManaColorFL = CreateColorBox(guiFrameLook, "unitFrameBgTextureManaColor", "Mana BG", function() BBF.UnitFrameBackgroundTexture() end)
    unitFrameBgTextureManaColorFL:SetPoint("LEFT", unitFrameBgTextureColorFL.text, "RIGHT", 4, 0)
    CreateTooltipTwo(unitFrameBgTextureManaColorFL, "Mana Bar Background Color", "Left-click to change.\n\n|cff32f795Shift+Right-click to reset to default.|r")

    changeUnitFrameBackgroundTexture:HookScript("OnClick", function(self)
        local alpha = self:GetChecked() and 1 or 0.5
        unitFrameBgTextureColorFL:SetAlpha(alpha)
        unitFrameBgTextureManaColorFL:SetAlpha(alpha)
        unitFrameBgTexture:SetEnabled(self:GetChecked())
        BBF.UpdateCustomTextures()
        BBF.UnitFrameBackgroundTexture()
        BBF.UpdateFrames()
        
        if BBF.addUnitFrameBgTexture then
            BBF.addUnitFrameBgTexture:SetChecked(self:GetChecked())
            if BBF.addUnitFrameBgTexture.parent then
                local clrFx = BBF.addUnitFrameBgTexture.parent
                if clrFx.unitFrameBgTextureColor then
                    clrFx.unitFrameBgTextureColor:SetAlpha(alpha)
                end
                if clrFx.unitFrameBgTextureManaColor then
                    clrFx.unitFrameBgTextureManaColor:SetAlpha(alpha)
                end
                if clrFx.unitFrameBgTexture then
                    clrFx.unitFrameBgTexture:SetEnabled(self:GetChecked())
                end
            end
        end
        
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    BBF.changeUnitFrameBackgroundColorTexture = changeUnitFrameBackgroundTexture
    BBF.unitFrameBgTextureDropdown = unitFrameBgTexture
    unitFrameBgTexture:SetEnabled(changeUnitFrameBackgroundTexture:GetChecked())
    local unitFrameBgAlpha = changeUnitFrameBackgroundTexture:GetChecked() and 1 or 0.5
    unitFrameBgTextureColorFL:SetAlpha(unitFrameBgAlpha)
    unitFrameBgTextureManaColorFL:SetAlpha(unitFrameBgAlpha)

    local changeRaidFrameHealthbarTexture = CreateCheckbox("changeRaidFrameHealthbarTexture", L["Tooltip_Change_RaidFrame_Healthbar_Texture_Desc"], guiFrameLook)
    changeRaidFrameHealthbarTexture:SetPoint("TOPLEFT", changeUnitFrameBackgroundTexture, "BOTTOMLEFT", 0, -40)
    CreateTooltipTwo(changeRaidFrameHealthbarTexture, L["Tooltip_Change_RaidFrame_Healthbar_Texture_Desc"], L["Tooltip_RaidFrame_Healthbar"])

    local raidFrameHealthbarTexture = CreateTextureDropdown(
        "raidFrameHealthbarTexture",
        guiFrameLook,
        "Select Texture",
        "raidFrameHealthbarTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
        end,
        { anchorFrame = changeRaidFrameHealthbarTexture, x = 5, y = 3, label = "Texture" }
    )

    changeRaidFrameHealthbarTexture:HookScript("OnClick", function(self)
        raidFrameHealthbarTexture:SetEnabled(self:GetChecked())
        BBF.UpdateCustomTextures()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    raidFrameHealthbarTexture:SetEnabled(changeRaidFrameHealthbarTexture:GetChecked())

    local changeRaidFrameManabarTexture = CreateCheckbox("changeRaidFrameManabarTexture", L["Tooltip_Change_RaidFrame_Manabar_Texture_Desc"], guiFrameLook)
    changeRaidFrameManabarTexture:SetPoint("TOPLEFT", changeRaidFrameHealthbarTexture, "BOTTOMLEFT", 0, -25)
    CreateTooltipTwo(changeRaidFrameManabarTexture, L["Tooltip_Change_RaidFrame_Manabar_Texture_Desc"], L["Tooltip_RaidFrame_Manabar"])

    local raidFrameManabarTexture = CreateTextureDropdown(
        "raidFrameManabarTexture",
        guiFrameLook,
        "Select Texture",
        "raidFrameManabarTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
        end,
        { anchorFrame = changeRaidFrameManabarTexture, x = 5, y = 3, label = "Texture" }
    )

    changeRaidFrameManabarTexture:HookScript("OnClick", function(self)
        raidFrameManabarTexture:SetEnabled(self:GetChecked())
        BBF.UpdateCustomTextures()
    end)
    raidFrameManabarTexture:SetEnabled(changeRaidFrameManabarTexture:GetChecked())


    local changePartyRaidFrameBackgroundColor = CreateCheckbox("changePartyRaidFrameBackgroundColor", L["Change_RaidFrame_Background_Texture"], guiFrameLook)
    changePartyRaidFrameBackgroundColor:SetPoint("TOPLEFT", changeRaidFrameManabarTexture, "BOTTOMLEFT", 0, -25)
    CreateTooltipTwo(changePartyRaidFrameBackgroundColor, L["Change_RaidFrame_Background_Texture"], L["Tooltip_Change_RaidFrame_Background_Texture_Desc"])

    local raidFrameBgTexture = CreateTextureDropdown(
        "raidFrameBgTexture",
        guiFrameLook,
        "Select Texture",
        "raidFrameBgTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
            BBF.SetCompactUnitFramesBackground()
        end,
        { anchorFrame = changePartyRaidFrameBackgroundColor, x = 5, y = 3, label = "Texture" }
    )

    local partyRaidFrameBackgroundHealthColorFL = CreateColorBox(guiFrameLook, "partyRaidFrameBackgroundHealthColor", "Health BG", function() BBF.SetCompactUnitFramesBackground() end)
    partyRaidFrameBackgroundHealthColorFL:SetPoint("LEFT", raidFrameBgTexture, "RIGHT", 10, 0)
    CreateTooltipTwo(partyRaidFrameBackgroundHealthColorFL, "Party/Raid Health Bar Background Color", "Left-click to change.\n\n|cff32f795Shift+Right-click to reset to default.|r")

    local partyRaidFrameBackgroundManaColorFL = CreateColorBox(guiFrameLook, "partyRaidFrameBackgroundManaColor", "Mana BG", function() BBF.SetCompactUnitFramesBackground() end)
    partyRaidFrameBackgroundManaColorFL:SetPoint("LEFT", partyRaidFrameBackgroundHealthColorFL.text, "RIGHT", 4, 0)
    CreateTooltipTwo(partyRaidFrameBackgroundManaColorFL, "Party/Raid Mana Bar Background Color", "Left-click to change.\n\n|cff32f795Shift+Right-click to reset to default.|r")

    changePartyRaidFrameBackgroundColor:HookScript("OnClick", function(self)
        local alpha = self:GetChecked() and 1 or 0.5
        partyRaidFrameBackgroundHealthColorFL:SetAlpha(alpha)
        partyRaidFrameBackgroundManaColorFL:SetAlpha(alpha)
        raidFrameBgTexture:SetEnabled(self:GetChecked())
        BBF.UpdateCustomTextures()
        BBF.SetCompactUnitFramesBackground()
        BBF.UpdateFrames()
        
        if BBF.changePartyRaidFrameBackgroundColor then
            BBF.changePartyRaidFrameBackgroundColor:SetChecked(self:GetChecked())
            if BBF.changePartyRaidFrameBackgroundColor.parent then
                local clrFx = BBF.changePartyRaidFrameBackgroundColor.parent
                if clrFx.partyRaidFrameBackgroundHealthColor then
                    clrFx.partyRaidFrameBackgroundHealthColor:SetAlpha(alpha)
                end
                if clrFx.partyRaidFrameBackgroundManaColor then
                    clrFx.partyRaidFrameBackgroundManaColor:SetAlpha(alpha)
                end
                if clrFx.raidFrameBgTexture then
                    clrFx.raidFrameBgTexture:SetEnabled(self:GetChecked())
                end
            end
        end
        
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    BBF.changePartyRaidFrameBackgroundColorTexture = changePartyRaidFrameBackgroundColor
    BBF.raidFrameBgTextureDropdown = raidFrameBgTexture
    raidFrameBgTexture:SetEnabled(changePartyRaidFrameBackgroundColor:GetChecked())
    local raidFrameBgAlpha = changePartyRaidFrameBackgroundColor:GetChecked() and 1 or 0.5
    partyRaidFrameBackgroundHealthColorFL:SetAlpha(raidFrameBgAlpha)
    partyRaidFrameBackgroundManaColorFL:SetAlpha(raidFrameBgAlpha)

end

