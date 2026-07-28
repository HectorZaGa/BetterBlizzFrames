if BBF.isMidnight then return end
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

local function guiGeneralTab()
    ----------------------
    -- Main panel:
    ----------------------
    local mainGuiAnchor = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor:SetPoint("TOPLEFT", 15, -15)
    mainGuiAnchor:SetText(" ")

    BetterBlizzFrames.searchName = L["Search_Name_General"]

    local profilesFrame = guiProfiles()

    local midnightBeta = BetterBlizzFrames:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    midnightBeta:SetPoint("BOTTOM", SettingsPanel, "TOP", 0, 0)
    midnightBeta:SetText(L["Msg_Midnight_Available"])
    -- Use locale-aware font system instead of hardcoded font
    if useCustomFonts then
        midnightBeta:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
    else
        local gameFont = GameFontNormal:GetFont()
        midnightBeta:SetFont(gameFont, 24, "OUTLINE")
    end
    midnightBeta:Hide()
    BetterBlizzFrames:HookScript("OnShow",function()
        midnightBeta:Show()
    end)
    BetterBlizzFrames:HookScript("OnHide",function()
        midnightBeta:Hide()
    end)

    local bgImg = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", BetterBlizzFrames, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local newSearch = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearch:SetAtlas("NewCharacter-Horde", true)
    newSearch:SetPoint("BOTTOM", BetterBlizzFrames, "TOP", -70, 2)
    CreateTooltipTwo(newSearch, L["Tooltip_Search_New"] .. " |A:shop-games-magnifyingglass:17:17|a", L["Tooltip_Search_Desc"])

    local newSearchPoint = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearchPoint:SetAtlas("auctionhouse-icon-buyallarrow", true)
    newSearchPoint:SetPoint("LEFT", newSearch, "RIGHT", -25, 0)
    newSearchPoint:SetRotation(math.pi / 2)

    CreateSearchFrame()
    -- local addonNameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    -- addonNameText:SetPoint("TOPLEFT", mainGuiAnchor, "TOPLEFT", -20, 47)
    -- addonNameText:SetText("BetterBlizzFrames"])
    -- local addonNameIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    -- addonNameIcon:SetAtlas("gmchat-icon-blizz")
    -- addonNameIcon:SetSize(22, 22)
    -- addonNameIcon:SetPoint("LEFT", addonNameText, "RIGHT", -2, -1)
    -- local verNumber = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- verNumber:SetPoint("LEFT", addonNameText, "RIGHT", 25, 0)
    -- verNumber:SetText(BBF.VersionNumber)
    CreateTitle(BetterBlizzFrames)

    ----------------------
    -- General:
    ----------------------
    -- "General:" text
    local settingsText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    settingsText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 0, 30)
    settingsText:SetText(L["General_Settings"])
    settingsText:SetFont(fontLarge, 16)
    settingsText:SetTextColor(1,1,1)
    local generalSettingsIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    generalSettingsIcon:SetAtlas("optionsicon-brown")
    generalSettingsIcon:SetSize(22, 22)
    generalSettingsIcon:SetPoint("RIGHT", settingsText, "LEFT", -3, -1)


    if BetterBlizzFrames.titleText then
        BetterBlizzFrames.titleText:Hide()
        BetterBlizzFrames.loadGUI:Hide()
    end



    local hideArenaFrames = CreateCheckbox("hideArenaFrames", L["Hide_Arena_Frames"], BetterBlizzFrames, nil, BBF.HideArenaFrames)
    hideArenaFrames:SetPoint("TOPLEFT", settingsText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    hideArenaFrames:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltip(hideArenaFrames, L["Tooltip_Hide_Arena_Frames"])

    local hideBossFrames = CreateCheckbox("hideBossFrames", L["Hide_Boss_Frames"], BetterBlizzFrames, nil, BBF.HideArenaFrames)
    hideBossFrames:SetPoint("TOPLEFT", hideArenaFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideBossFrames, L["Tooltip_Hide_Boss_Frames"])

    local hideBossFramesParty = CreateCheckbox("hideBossFramesParty", L["Party"], BetterBlizzFrames, nil, BBF.HideArenaFrames)
    hideBossFramesParty:SetPoint("LEFT", hideBossFrames.text, "RIGHT", 0, 0)
    CreateTooltip(hideBossFramesParty, L["Tooltip_Hide_Boss_Frames_Party"], "ANCHOR_LEFT")

    local hideBossFramesRaid = CreateCheckbox("hideBossFramesRaid", L["Raid"], BetterBlizzFrames, nil, BBF.HideArenaFrames)
    hideBossFramesRaid:SetPoint("LEFT", hideBossFramesParty.text, "RIGHT", 0, 0)
    CreateTooltip(hideBossFramesRaid, L["Tooltip_Hide_Boss_Frames_Raid"], "ANCHOR_LEFT")

    hideBossFrames:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BetterBlizzFramesDB.overShieldsCompact = true
            BetterBlizzFramesDB.hideBossFramesParty = true
            hideBossFramesParty:SetAlpha(1)
            hideBossFramesParty:Enable()
            hideBossFramesParty:SetChecked(true)
            hideBossFramesRaid:SetAlpha(1)
            hideBossFramesRaid:Enable()
            hideBossFramesRaid:SetChecked(true)
        else
            BetterBlizzFramesDB.overShieldsCompact = false
            BetterBlizzFramesDB.hideBossFramesParty = false
            hideBossFramesParty:SetAlpha(0)
            hideBossFramesParty:Disable()
            hideBossFramesParty:SetChecked(false)
            hideBossFramesRaid:SetAlpha(0)
            hideBossFramesRaid:Disable()
            hideBossFramesRaid:SetChecked(false)
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    if not BetterBlizzFramesDB.hideBossFrames then
        hideBossFramesParty:SetAlpha(0)
        hideBossFramesParty:Disable()
        hideBossFramesRaid:SetAlpha(0)
        hideBossFramesRaid:Disable()
    end

    local playerFrameOCD = CreateCheckbox("playerFrameOCD", L["OCD_Tweaks"], BetterBlizzFrames, nil, BBF.FixStupidBlizzPTRShit)
    playerFrameOCD:SetPoint("TOPLEFT", hideBossFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(playerFrameOCD, L["Tooltip_OCD_Tweaks_Retail"])

    -- local playerFrameOCDTextureBypass = CreateCheckbox("playerFrameOCDTextureBypass", L["OCD_Skip_Bars"], BetterBlizzFrames, nil, BBF.HideFrames)
    -- playerFrameOCDTextureBypass:SetPoint("LEFT", playerFrameOCD.text, "RIGHT", 0, 0)
    -- CreateTooltip(playerFrameOCDTextureBypass, L["Tooltip_OCD_Skip_Bars"])

    playerFrameOCD:HookScript("OnClick", function(self)
        BBF.AllNameChanges()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    -- if not BetterBlizzFramesDB.playerFrameOCD then
    --     playerFrameOCDTextureBypass:Disable()
    --     playerFrameOCDTextureBypass:SetAlpha(0)
    -- end

    local hideLossOfControlFrameBg = CreateCheckbox("hideLossOfControlFrameBg", L["Hide_CC_Background"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideLossOfControlFrameBg:SetPoint("TOPLEFT", playerFrameOCD, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideLossOfControlFrameBg, L["Tooltip_Hide_CC_Background"])
    hideLossOfControlFrameBg:HookScript("OnClick", function()
        BBF.ToggleLossOfControlTestMode()
    end)

    local hideLossOfControlFrameLines = CreateCheckbox("hideLossOfControlFrameLines", L["Hide_CC_Red_Lines"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideLossOfControlFrameLines:SetPoint("TOPLEFT", hideLossOfControlFrameBg, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideLossOfControlFrameLines, L["Tooltip_Hide_CC_Red_Lines"])
    hideLossOfControlFrameLines:HookScript("OnClick", function()
        BBF.ToggleLossOfControlTestMode()
    end)

    local lossOfControlScale = CreateSlider(BetterBlizzFrames, L["CC_Scale"], 0.4, 1.4, 0.01, "lossOfControlScale", nil, 90)
    lossOfControlScale:SetPoint("LEFT", hideLossOfControlFrameBg.text, "RIGHT", 3, -16)
    CreateTooltipTwo(lossOfControlScale, L["Loss_of_Control_Scale"], L["Tooltip_CC_Scale_Desc"])

    local darkModeUi = CreateCheckbox("darkModeUi", L["Dark_Mode"], BetterBlizzFrames)
    darkModeUi:SetPoint("TOPLEFT", hideLossOfControlFrameLines, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeUi:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltip(darkModeUi, L["Tooltip_Dark_Mode"])

    local darkModeActionBars = CreateCheckbox("darkModeActionBars", L["ActionBars"], darkModeUi)
    darkModeActionBars:SetPoint("TOPLEFT", darkModeUi, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeActionBars:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltip(darkModeActionBars, L["Dark_Borders_ActionBars"])

    local darkModeMinimap = CreateCheckbox("darkModeMinimap", L["Minimap"], darkModeUi)
    darkModeMinimap:SetPoint("TOPLEFT", darkModeActionBars, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeMinimap:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltip(darkModeMinimap, L["Dark_Mode_Minimap"])

    local darkModeCastbars = CreateCheckbox("darkModeCastbars", L["Castbars"], darkModeUi)
    darkModeCastbars:SetPoint("LEFT", darkModeUi.Text, "RIGHT", 5, 0)
    darkModeCastbars:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltip(darkModeCastbars, L["Dark_Borders_Castbars"])

    local darkModeUiAura = CreateCheckbox("darkModeUiAura", L["Auras"], darkModeUi)
    darkModeUiAura:SetPoint("TOPLEFT", darkModeCastbars, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeUiAura:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltip(darkModeUiAura, L["Dark_Borders_Aura_Icons"])

    local darkModeNameplateResource = CreateCheckbox("darkModeNameplateResource", L["Nameplate_Resource"], darkModeUi)
    darkModeNameplateResource:SetPoint("TOPLEFT", darkModeUiAura, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeNameplateResource:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltip(darkModeNameplateResource, L["Dark_Mode_Nameplate_Resource"])

    local darkModeGameTooltip = CreateCheckbox("darkModeGameTooltip", L["Tooltip"], darkModeUi)
    darkModeGameTooltip:SetPoint("TOPLEFT", darkModeMinimap, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeGameTooltip:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltipTwo(darkModeGameTooltip, L["Tooltip_Dark_Mode_Tooltip_Title"], L["Tooltip_Dark_Mode_Tooltip_Desc"])

    local darkModeEliteTexture = CreateCheckbox("darkModeEliteTexture", L["Elite_Texture"], darkModeUi)
    darkModeEliteTexture:SetPoint("TOPLEFT", darkModeGameTooltip, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    darkModeEliteTexture:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltipTwo(darkModeEliteTexture, L["Tooltip_Dark_Mode_Elite_Title"], L["Tooltip_Dark_Mode_Elite_Desc"])
    darkModeEliteTexture:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if not BetterBlizzFramesDB.darkModeEliteTextureDesaturated then
                BetterBlizzFramesDB.darkModeEliteTextureDesaturated = true
            else
                BetterBlizzFramesDB.darkModeEliteTextureDesaturated = nil
            end
            BBF.DarkmodeFrames(true)
        end
    end)

    local darkModeObjectiveFrame = CreateCheckbox("darkModeObjectiveFrame", L["Objectives"], darkModeUi)
    darkModeObjectiveFrame:SetPoint("LEFT", darkModeGameTooltip.Text, "RIGHT", 5, 0)
    darkModeObjectiveFrame:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltipTwo(darkModeObjectiveFrame, L["Tooltip_Dark_Mode_Objectives_Title"], L["Tooltip_Dark_Mode_Objectives_Desc"])

    local darkModeVigor = CreateCheckbox("darkModeVigor", L["Vigor"], darkModeUi)
    darkModeVigor:SetPoint("LEFT", darkModeObjectiveFrame.Text, "RIGHT", 5, 0)
    darkModeVigor:HookScript("OnClick", function()
        BBF.DarkmodeFrames(true)
    end)
    CreateTooltipTwo(darkModeVigor, L["Tooltip_Dark_Mode_Vigor_Title"], L["Tooltip_Dark_Mode_Vigor_Desc"])

    local darkModeColor = CreateSlider(darkModeUi, L["Darkness"], 0, 1, 0.01, "darkModeColor", nil, 90)
    darkModeColor:SetPoint("LEFT", darkModeUiAura.text, "RIGHT", 3, -1)
    CreateTooltipTwo(darkModeColor, L["Dark_Mode_Value"], L["Tooltip_Dark_Mode_Value"])

    darkModeUi:HookScript("OnClick", function(self)
        CheckAndToggleCheckboxes(darkModeUi, 0)
    end)
    if not BetterBlizzFramesDB.darkModeUi then
        CheckAndToggleCheckboxes(darkModeUi, 0)
    end










    local playerFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 0, -173)
    playerFrameText:SetText(L["Player_Frame"])
    playerFrameText:SetFont(fontLarge, 16)
    playerFrameText:SetTextColor(1,1,1)
    local playerFrameIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    playerFrameIcon:SetAtlas("groupfinder-icon-friend")
    playerFrameIcon:SetSize(28, 28)
    playerFrameIcon:SetPoint("RIGHT", playerFrameText, "LEFT", -0.5, 0)

    local playerFrameClickthrough = CreateCheckbox("playerFrameClickthrough", L["Clickthrough"], BetterBlizzFrames, nil, BBF.ClickthroughFrames)
    playerFrameClickthrough:SetPoint("TOPLEFT", playerFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltip(playerFrameClickthrough, L["Tooltip_Clickthrough"])
    playerFrameClickthrough:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local textures = BetterBlizzFramesDB.classicFrames and 7 or 4
    local playerEliteFrame = CreateCheckbox("playerEliteFrame", L["Elite_Texture"], BetterBlizzFrames)
    playerEliteFrame:SetPoint("LEFT", playerFrameClickthrough.text, "RIGHT", 5, 0)
    playerEliteFrame:HookScript("OnClick", function(self)
        BBF.PlayerElite(BetterBlizzFramesDB.playerEliteFrameMode)
    end)
    playerEliteFrame:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" and IsShiftKeyDown() then
            if not BetterBlizzFramesDB.playerEliteFrameDarkmode then
                BetterBlizzFramesDB.playerEliteFrameDarkmode = true
            else
                BetterBlizzFramesDB.playerEliteFrameDarkmode = nil
            end
            if GameTooltip:IsShown() and GameTooltip:GetOwner() == self then
                self:GetScript("OnEnter")(self)
            end
            BBF.PlayerElite(BetterBlizzFramesDB["playerEliteFrameMode"])
        elseif button == "RightButton" then
            BetterBlizzFramesDB["playerEliteFrameMode"] = BetterBlizzFramesDB["playerEliteFrameMode"] % textures + 1
            BBF.PlayerElite(BetterBlizzFramesDB["playerEliteFrameMode"])
        end
    end)
    CreateTooltipTwo(playerEliteFrame, L["Show_Elite_Texture"], string.format(L["Tooltip_Elite_Texture_Desc"], textures))

    local playerReputationColor = CreateCheckbox("playerReputationColor", L["Add_Reputation_Color"], BetterBlizzFrames, nil, BBF.PlayerReputationColor)
    playerReputationColor:SetPoint("TOPLEFT", playerFrameClickthrough, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(playerReputationColor, L["Tooltip_Add_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:18:98|a")

    local playerReputationClassColor = CreateCheckbox("playerReputationClassColor", L["Class_Color_Combo"], BetterBlizzFrames, nil, BBF.PlayerReputationColor)
    playerReputationClassColor:SetPoint("LEFT", playerReputationColor.text, "RIGHT", 5, 0)
    CreateTooltip(playerReputationClassColor, L["Tooltip_Class_Color_Reputation"])
    playerReputationColor:HookScript("OnClick", function(self)
        if self:GetChecked() then
            playerReputationClassColor:Enable()
            playerReputationClassColor:SetAlpha(1)
        else
            playerReputationClassColor:Disable()
            playerReputationClassColor:SetAlpha(0)
        end
    end)
    if not BetterBlizzFramesDB.playerReputationColor then
        playerReputationClassColor:SetAlpha(0)
        playerReputationClassColor:Disable()
    end

    local hidePlayerName = CreateCheckbox("hidePlayerName", L["Hide_Names"], BetterBlizzFrames, nil, BBF.UpdateNameSettings)
    hidePlayerName:SetPoint("TOPLEFT", playerReputationColor, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    hidePlayerName:HookScript("OnClick", function(self)
        -- if self:GetChecked() then
        --     PlayerFrame.name:SetAlpha(0)
        --     if PlayerFrame.bbfName then
        --         PlayerFrame.bbfName:SetAlpha(0)
        --     end
        -- else
        --     PlayerFrame.name:SetAlpha(0)
        --     if PlayerFrame.bbfName then
        --         PlayerFrame.bbfName:SetAlpha(1)
        --     else
        --         PlayerFrame.name:SetAlpha(1)
        --     end
        -- end
        BBF.SetCenteredNamesCaller()
    end)

    local symmetricPlayerFrame = CreateCheckbox("symmetricPlayerFrame", L["Mirror_TargetFrame"], BetterBlizzFrames, nil, BBF.SymmetricPlayerFrame)
    symmetricPlayerFrame:SetPoint("LEFT", hidePlayerName.text, "RIGHT", 0, 0)
    CreateTooltipTwo(symmetricPlayerFrame, L["Mirror_TargetFrame"], L["Tooltip_Mirror_TargetFrame_Desc"])
    -- symmetricPlayerFrame:HookScript("OnClick", function(self)
    --     if not self:GetChecked() then
    --         StaticPopup_Show("BBF_CONFIRM_RELOAD")
    --         BetterBlizzFramesDB.playerFrameOCD = nil
    --     end
    -- end)
    symmetricPlayerFrame:SetScript("OnClick", function(self)
        self:SetChecked(BetterBlizzFramesDB.symmetricPlayerFrame or false)
    end)

    symmetricPlayerFrame:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
            if BetterBlizzFramesDB.symmetricPlayerFrame then
                BetterBlizzFramesDB.symmetricPlayerFrame = nil
                symmetricPlayerFrame:SetChecked(false)
                return
            end
            symmetricPlayerFrame:SetChecked(true)
            BetterBlizzFramesDB.symmetricPlayerFrame = true
        end
    end)

    -- local hidePlayerMaxHpReduction = CreateCheckbox("hidePlayerMaxHpReduction", "Hide Reduced HP", BetterBlizzFrames, nil, BBF.HideFrames)
    -- hidePlayerMaxHpReduction:SetPoint("LEFT", hidePlayerName.text, "RIGHT", 0, 0)
    -- CreateTooltipTwo(hidePlayerMaxHpReduction, L["Hide_Reduced_HP"], L["Tooltip_Hide_Reduced_HP_Player"])

    local hidePlayerPower = CreateCheckbox("hidePlayerPower", L["Hide_Resource_Power"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePlayerPower:SetPoint("TOPLEFT", hidePlayerName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hidePlayerPower, L["Hide_Resource_Power"], L["Tooltip_Hide_Resource_Power_Desc"])

    local classOptionsFrame
    local function OpenClassSpecificWindow()
        if not classOptionsFrame then
            classOptionsFrame = CreateFrame("Frame", "ClassOptionsFrame", UIParent, "BasicFrameTemplateWithInset")
            classOptionsFrame:SetSize(185, 210)
            classOptionsFrame:SetPoint("CENTER")
            classOptionsFrame:SetFrameStrata("DIALOG")
            classOptionsFrame:SetMovable(true)
            classOptionsFrame:EnableMouse(true)
            classOptionsFrame:RegisterForDrag("LeftButton")
            classOptionsFrame:SetScript("OnDragStart", classOptionsFrame.StartMoving)
            classOptionsFrame:SetScript("OnDragStop", classOptionsFrame.StopMovingOrSizing)
            classOptionsFrame.title = classOptionsFrame:CreateFontString(nil, "OVERLAY")
            classOptionsFrame.title:SetFontObject("GameFontHighlight")
            classOptionsFrame.title:SetPoint("LEFT", classOptionsFrame.TitleBg, "LEFT", 5, 0)
            classOptionsFrame.title:SetText(L["Class_Specific_Options"])

            local classes = {
                { classID = 11, var = "hidePlayerPowerNoDruid", color = RAID_CLASS_COLORS["DRUID"] },
                { classID = 4, var = "hidePlayerPowerNoRogue", color = RAID_CLASS_COLORS["ROGUE"] },
                { classID = 9, var = "hidePlayerPowerNoWarlock", color = RAID_CLASS_COLORS["WARLOCK"] },
                { classID = 2, var = "hidePlayerPowerNoPaladin", color = RAID_CLASS_COLORS["PALADIN"] },
                { classID = 6, var = "hidePlayerPowerNoDeathKnight", color = RAID_CLASS_COLORS["DEATHKNIGHT"] },
                { classID = 13, var = "hidePlayerPowerNoEvoker", color = RAID_CLASS_COLORS["EVOKER"] },
                { classID = 10, var = "hidePlayerPowerNoMonk", color = RAID_CLASS_COLORS["MONK"] },
                { classID = 8, var = "hidePlayerPowerNoMage", color = RAID_CLASS_COLORS["MAGE"] },
            }

            local previousCheckbox
            for i, classData in ipairs(classes) do
                local classCheckbox = CreateFrame("CheckButton", nil, classOptionsFrame, "UICheckButtonTemplate")
                classCheckbox:SetSize(24, 24)
                local localizedClassName = GetClassInfo(classData.classID)
                classCheckbox.Text:SetText(string.format(L["Ignore_Class"], localizedClassName))

                -- Set the color of the checkbox label to the class color
                local r, g, b = classData.color.r, classData.color.g, classData.color.b
                classCheckbox.Text:SetTextColor(r, g, b)

                -- Position the checkboxes
                if i == 1 then
                    classCheckbox:SetPoint("TOPLEFT", classOptionsFrame, "TOPLEFT", 10, -30)
                else
                    classCheckbox:SetPoint("TOPLEFT", previousCheckbox, "BOTTOMLEFT", 0, 3)
                end

                -- Set the state from the DB
                classCheckbox:SetChecked(BetterBlizzFramesDB[classData.var])

                -- Save the state back to the DB when toggled
                classCheckbox:SetScript("OnClick", function(self)
                    BetterBlizzFramesDB[classData.var] = self:GetChecked() or nil
                    BBF.HideFrames()
                end)

                previousCheckbox = classCheckbox
            end
            classOptionsFrame:Show()
        else
            -- Toggle visibility of the frame when the function is called
            if classOptionsFrame:IsShown() then
                classOptionsFrame:Hide()
            else
                classOptionsFrame:Show()
            end
        end
    end

    hidePlayerPower:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            OpenClassSpecificWindow()
        end
    end)

    local hideResourceTooltip = CreateCheckbox("hideResourceTooltip", L["Hide_Resource_Tooltip"], BetterBlizzFrames, nil, BBF.HideClassResourceTooltip)
    hideResourceTooltip:SetPoint("TOPLEFT", hidePlayerPower, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideResourceTooltip, L["Hide_Resource_Tooltip"], L["Tooltip_Hide_Resource_Tooltip_Desc"])

    local hideManaFeedback = CreateCheckbox("hideManaFeedback", L["Hide_Mana_Feedback"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideManaFeedback:SetPoint("TOPLEFT", hideResourceTooltip, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideManaFeedback, L["Hide_Mana_Feedback"], L["Tooltip_Hide_Mana_Feedback_Desc"])

    local hidePlayerRestAnimation = CreateCheckbox("hidePlayerRestAnimation", L["Hide_Zzz_Rest_Animation"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePlayerRestAnimation:SetPoint("TOPLEFT", hideManaFeedback, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hidePlayerRestAnimation, L["Tooltip_Hide_Zzz_Rest"])

    local hidePlayerCornerIcon = CreateCheckbox("hidePlayerCornerIcon", L["Hide_Corner_Icon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePlayerCornerIcon:SetPoint("TOPLEFT", hidePlayerRestAnimation, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hidePlayerCornerIcon, L["Tooltip_Hide_Corner_Icon"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment:22:22|a")

    local hidePlayerHealthLossAnim = CreateCheckbox("hidePlayerHealthLossAnim", L["Hide_Health_Loss_FX"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePlayerHealthLossAnim:SetPoint("LEFT", hidePlayerCornerIcon.text, "RIGHT", 0, 0)
    CreateTooltipTwo(hidePlayerHealthLossAnim, L["Tooltip_Hide_Health_Loss_FX"], L["Tooltip_Hide_Health_Loss_FX_Desc"])

    local hidePlayerRestGlow = CreateCheckbox("hidePlayerRestGlow", L["Hide_Rest_Glow"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePlayerRestGlow:SetPoint("TOPLEFT", hidePlayerCornerIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hidePlayerRestGlow, L["Tooltip_Hide_Rest_Glow"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-Status:30:80|a")

    local hideFullPower = CreateCheckbox("hideFullPower", L["Hide_Full_Mana_FX"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideFullPower:SetPoint("LEFT", hidePlayerRestGlow.text, "RIGHT", 0, 0)
    CreateTooltipTwo(hideFullPower, L["Tooltip_Hide_Full_Mana_FX"] .. " |A:FullAlert-FrameGlow:27:51|a", L["Tooltip_Hide_Full_Mana_FX_Desc"])

    local hideCombatIcon = CreateCheckbox("hideCombatIcon", L["Hide_Combat_Icon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideCombatIcon:SetPoint("TOPLEFT", hidePlayerRestGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideCombatIcon, L["Tooltip_Hide_Combat_Icon"] .. " |A:UI-HUD-UnitFrame-Player-CombatIcon:22:22|a")

    local hideHitIndicator = CreateCheckbox("hideHitIndicator", L["Hide_Hit_Indicator"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideHitIndicator:SetPoint("LEFT", hideCombatIcon.text, "RIGHT", 0, 0)
    CreateTooltipTwo(hideHitIndicator, L["Hide_Hit_Indicator"], L["Tooltip_Hide_Hit_Indicator_Desc"])

    local hideGroupIndicator = CreateCheckbox("hideGroupIndicator", L["Hide_Group_Indicator"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideGroupIndicator:SetPoint("TOPLEFT", hideCombatIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideGroupIndicator, L["Tooltip_Hide_Group_Indicator"])

    local hideTotemFrame = CreateCheckbox("hideTotemFrame", L["Hide_Totem_Frame"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideTotemFrame:SetPoint("LEFT", hideGroupIndicator.text, "RIGHT", 0, 0)
    CreateTooltip(hideTotemFrame, L["Tooltip_Hide_Totem_Frame"])

    local hidePlayerLeaderIcon = CreateCheckbox("hidePlayerLeaderIcon", L["Hide_Leader_Icon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePlayerLeaderIcon:SetPoint("TOPLEFT", hideGroupIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hidePlayerLeaderIcon, L["Tooltip_Hide_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:22:22|a")

    local hidePlayerGuideIcon = CreateCheckbox("hidePlayerGuideIcon", L["Hide_Guide_Icon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePlayerGuideIcon:SetPoint("LEFT", hidePlayerLeaderIcon.text, "RIGHT", 0, 0)
    CreateTooltip(hidePlayerGuideIcon, L["Tooltip_Hide_Guide_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-GuideIcon:22:22|a")

    local hidePlayerRoleIcon = CreateCheckbox("hidePlayerRoleIcon", L["Hide_Role_Icon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePlayerRoleIcon:SetPoint("TOPLEFT", hidePlayerLeaderIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hidePlayerRoleIcon, L["Tooltip_Hide_Role_Icon"] .. " |A:roleicon-tiny-dps:22:22|a")

    local hidePvpTimerText = CreateCheckbox("hidePvpTimerText", L["Hide_PvP_Timer"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePvpTimerText:SetPoint("LEFT", hidePlayerRoleIcon.text, "RIGHT", 0, 0)
    CreateTooltipTwo(hidePvpTimerText, L["Hide_PvP_Timer"], L["Tooltip_Hide_PvP_Timer_Desc"])





    local petFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    petFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 460, -455)
    petFrameText:SetText(L["Pet_Frame"])
    petFrameText:SetFont(fontLarge, 16)
    petFrameText:SetTextColor(1,1,1)
    local petFrameIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    petFrameIcon:SetAtlas("newplayerchat-chaticon-newcomer")
    petFrameIcon:SetSize(21, 21)
    petFrameIcon:SetPoint("RIGHT", petFrameText, "LEFT", -2, 0)

    local hidePetFrame = CreateCheckbox("hidePetFrame", L["Hide_Pet_Frame"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePetFrame:SetPoint("TOPLEFT", petFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltipTwo(hidePetFrame, L["Hide_Pet_Frame"], L["Tooltip_Hide_Pet_Frame_Desc"])

    local petCastbar = CreateCheckbox("petCastbar", L["Pet_Castbar"], BetterBlizzFrames, nil, BBF.UpdatePetCastbar)
    petCastbar:SetPoint("TOPLEFT", hidePetFrame, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(petCastbar, L["Tooltip_Pet_Castbar"])

    local hidePetName = CreateCheckbox("hidePetName", L["Hide_Pet_Name"], BetterBlizzFrames)
    hidePetName:SetPoint("TOPLEFT", petCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    hidePetName:HookScript("OnClick", function (self)
        BBF.AllNameChanges()
    end)
    CreateTooltipTwo(hidePetName, L["Hide_Pet_Name"], L["Tooltip_Hide_Pet_Name_Desc"])

    local colorPetAfterOwner = CreateCheckbox("colorPetAfterOwner", L["Color_Pet_After_Player_Class"], BetterBlizzFrames)
    colorPetAfterOwner:SetPoint("TOPLEFT", hidePetName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    colorPetAfterOwner:HookScript("OnClick", function (self)
        BBF.UpdateFrames()
    end)

    local hidePetText = CreateCheckbox("hidePetText", L["Hide_Pet_Statusbar_Text"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePetText:SetPoint("TOPLEFT", colorPetAfterOwner, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hidePetText, L["Hide_Pet_Statusbar_Text"], L["Tooltip_Hide_Pet_Statusbar_Text_Desc"])

    local hidePetHitIndicator = CreateCheckbox("hidePetHitIndicator", L["Hide_Pet_Hit_Indicator"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePetHitIndicator:SetPoint("TOPLEFT", hidePetText, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hidePetHitIndicator, L["Hide_Pet_Hit_Indicator"], L["Tooltip_Hide_Pet_Hit_Indicator_Desc"])

    local partyFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    partyFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 0, -423)
    partyFrameText:SetText(L["Party_Frame"])
    partyFrameText:SetFont(fontLarge, 16)
    partyFrameText:SetTextColor(1,1,1)
    local partyFrameIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    partyFrameIcon:SetAtlas("groupfinder-icon-friend")
    partyFrameIcon:SetSize(25, 25)
    partyFrameIcon:SetPoint("RIGHT", partyFrameText, "LEFT", -4, -1)
    local partyFrameIcon2 = BetterBlizzFrames:CreateTexture(nil, "BORDER")
    partyFrameIcon2:SetAtlas("groupfinder-icon-friend")
    partyFrameIcon2:SetSize(20, 20)
    partyFrameIcon2:SetPoint("RIGHT", partyFrameText, "LEFT", 0, 4)

    local showPartyCastbar = CreateCheckbox("showPartyCastbar", L["Party_Castbars"], BetterBlizzFrames, nil, BBF.UpdateCastbars)
    showPartyCastbar:SetPoint("TOPLEFT", partyFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    showPartyCastbar:HookScript("OnClick", function(self)
        --BBF.AbsorbCaller()
    end)
    CreateTooltip(showPartyCastbar, L["Tooltip_Party_Castbars"])

    local hidePartyRoles = CreateCheckbox("hidePartyRoles", L["Hide_Role_Icons"], BetterBlizzFrames)
    hidePartyRoles:SetPoint("LEFT", showPartyCastbar.text, "RIGHT", 0, 0)
    hidePartyRoles:HookScript("OnClick", function()
        BBF.PartyNameChange()
    end)
    CreateTooltip(hidePartyRoles, L["Tooltip_Hide_Party_Role_Icons"])

--[=[
    local sortGroup = CreateCheckbox("sortGroup", L["Sort_Group"], BetterBlizzFrames, nil, BBF.SortGroup)
    sortGroup:SetPoint("TOPLEFT", showPartyCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(sortGroup, L["Tooltip_Sort_Group"])

    local sortGroupPlayerTop = CreateCheckbox("sortGroupPlayerTop", L["Player_On_Top"], BetterBlizzFrames, nil, BBF.SortGroup)
    sortGroupPlayerTop:SetPoint("LEFT", sortGroup.text, "RIGHT", 0, 0)

    local sortGroupPlayerBottom = CreateCheckbox("sortGroupPlayerBottom", L["Player_On_Bottom"], BetterBlizzFrames, nil, BBF.SortGroup)
    sortGroupPlayerBottom:SetPoint("LEFT", sortGroupPlayerTop.text, "RIGHT", 0, 0)

    sortGroupPlayerTop:HookScript("OnClick", function(self)
        if self:GetChecked() then
            sortGroupPlayerBottom:SetChecked(false)
            BetterBlizzFramesDB.sortGroupPlayerBottom = false
        end
    end)

    sortGroupPlayerBottom:HookScript("OnClick", function(self)
        if self:GetChecked() then
            sortGroupPlayerTop:SetChecked(false)
            BetterBlizzFramesDB.sortGroupPlayerTop = false
        end
    end)

    sortGroup:HookScript("OnClick", function(self)
        if self:GetChecked() then
            sortGroupPlayerTop:Enable()
            sortGroupPlayerTop:SetAlpha(1)
            sortGroupPlayerBottom:Enable()
            sortGroupPlayerBottom:SetAlpha(1)
        else
            sortGroupPlayerTop:Disable()
            sortGroupPlayerTop:SetAlpha(0)
            sortGroupPlayerBottom:Disable()
            sortGroupPlayerBottom:SetAlpha(0)
        end
    end)
    if not BetterBlizzFramesDB.sortGroup then
        sortGroupPlayerTop:SetAlpha(0)
        sortGroupPlayerBottom:SetAlpha(0)
    end

]=]


    local hidePartyFramesInArena = CreateCheckbox("hidePartyFramesInArena", L["Hide_Party_in_Arena"], BetterBlizzFrames, nil, BBF.HidePartyInArena)
    hidePartyFramesInArena:SetPoint("TOPLEFT", showPartyCastbar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hidePartyFramesInArena, L["Tooltip_Hide_Party_in_Arena_GEX"])

    local raidFramePixelBorder = CreateCheckbox("raidFramePixelBorder", L["Pixel_Border"], BetterBlizzFrames)
    raidFramePixelBorder:SetPoint("LEFT", hidePartyFramesInArena.text, "RIGHT", 0, 0)
    raidFramePixelBorder:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    raidFramePixelBorder:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if not BetterBlizzFramesDB.raidFramePixelBorderSize then
                BetterBlizzFramesDB.raidFramePixelBorderSize = 1.5
            else
                BetterBlizzFramesDB.raidFramePixelBorderSize = nil
            end
            if GameTooltip:IsShown() and GameTooltip:GetOwner() == self then
                self:GetScript("OnEnter")(self)
            end
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltipTwo(raidFramePixelBorder, L["Tooltip_Pixel_Border_RaidFrames_Title"], L["Tooltip_Pixel_Border_RaidFrames_Desc"])

    local hidePartyNames = CreateCheckbox("hidePartyNames", L["Hide_Names"], BetterBlizzFrames, nil, BBF.AllNameChanges)
    hidePartyNames:SetPoint("TOPLEFT", hidePartyFramesInArena, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hidePartyAggroHighlight = CreateCheckbox("hidePartyAggroHighlight", L["Hide_Aggro_Highlight"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePartyAggroHighlight:SetPoint("LEFT", hidePartyNames.text, "RIGHT", 0, 0)
    CreateTooltip(hidePartyAggroHighlight, L["Tooltip_Hide_Party_Aggro_Highlight"])

    -- local hidePartyMaxHpReduction = CreateCheckbox("hidePartyMaxHpReduction", "Hide Reduced HP", BetterBlizzFrames, nil, BBF.HideFrames)
    -- hidePartyMaxHpReduction:SetPoint("LEFT", hidePartyRoles.text, "RIGHT", 0, 0)
    -- CreateTooltipTwo(hidePartyMaxHpReduction, L["Hide_Reduced_HP"], L["Tooltip_Hide_Reduced_HP_Party"])

    local hidePartyFrameTitle = CreateCheckbox("hidePartyFrameTitle", L["Hide_CompactPartyFrame_Title"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePartyFrameTitle:SetPoint("TOPLEFT", hidePartyNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hidePartyFrameTitle, L["Tooltip_Hide_CompactPartyFrame_Title"])

    local hideRaidFrameManager = CreateCheckbox("hideRaidFrameManager", L["Hide_RaidFrameManager"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideRaidFrameManager:SetPoint("TOPLEFT", hidePartyFrameTitle, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideRaidFrameManager, L["Tooltip_Hide_RaidFrameManager"])

    local classColorPartyNames = CreateCheckbox("classColorPartyNames", L["Color_Names"], BetterBlizzFrames, nil, BBF.AllNameChanges)
    classColorPartyNames:SetPoint("LEFT", hideRaidFrameManager.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(classColorPartyNames, L["Class_Color_Names"], L["Tooltip_Class_Color_Names_Party_Raid"])

    local hideRaidFrameContainerBorder = CreateCheckbox("hideRaidFrameContainerBorder", L["Hide_Container_Border"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideRaidFrameContainerBorder:SetPoint("TOPLEFT", hideRaidFrameManager, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideRaidFrameContainerBorder, L["Hide_CompactRaidFrame_Container_Border"], L["Tooltip_Hide_Container_Border_Desc"])

    local newRaidFrameRoleIcons = CreateCheckbox("newRaidFrameRoleIcons", L["New_Role_Icons"], BetterBlizzFrames)
    newRaidFrameRoleIcons:SetPoint("LEFT", hideRaidFrameContainerBorder.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(newRaidFrameRoleIcons, L["New_Role_Icons"], L["Tooltip_New_Role_Icons_Desc"])
    newRaidFrameRoleIcons:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local partyFrameScale = CreateSlider(BetterBlizzFrames, L["Party_Frame_Scale"], 0.7, 1.7, 0.01, "partyFrameScale", nil, 120)
    partyFrameScale:SetPoint("TOPLEFT", hideRaidFrameContainerBorder, "BOTTOMLEFT", 15, -9)









    local targetFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    targetFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 250, -197)
    targetFrameText:SetText(L["Target_Frame"])
    targetFrameText:SetFont(fontLarge, 16)
    targetFrameText:SetTextColor(1,1,1)
    local targetFrameIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    targetFrameIcon:SetAtlas("groupfinder-icon-friend")
    targetFrameIcon:SetSize(28, 28)
    targetFrameIcon:SetPoint("RIGHT", targetFrameText, "LEFT", -0.5, 0)
    targetFrameIcon:SetDesaturated(1)
    targetFrameIcon:SetVertexColor(1, 0, 0)

    local targetFrameClickthrough = CreateCheckbox("targetFrameClickthrough", L["Clickthrough"], BetterBlizzFrames, nil, BBF.ClickthroughFrames)
    targetFrameClickthrough:SetPoint("TOPLEFT", targetFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltip(targetFrameClickthrough, L["Tooltip_Target_Clickthrough"])
    targetFrameClickthrough:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local hideTargetName = CreateCheckbox("hideTargetName", L["Hide_Names"], BetterBlizzFrames, nil, BBF.UpdateNameSettings)
    hideTargetName:SetPoint("TOPLEFT", targetFrameClickthrough, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideTargetName, L["Tooltip_Hide_Target_Name"])
    hideTargetName:HookScript("OnClick", function(self)
        -- if self:GetChecked() then
        --     TargetFrame.name:SetAlpha(0)
        --     if TargetFrame.bbfName then
        --         TargetFrame.bbfName:SetAlpha(0)
        --     end
        -- else
        --     TargetFrame.name:SetAlpha(0)
        --     if TargetFrame.bbfName then
        --         TargetFrame.bbfName:SetAlpha(1)
        --     else
        --         TargetFrame.name:SetAlpha(1)
        --     end
        -- end
        BBF.AllNameChanges()
    end)

    -- local hideTargetMaxHpReduction = CreateCheckbox("hideTargetMaxHpReduction", "Hide Reduced HP", BetterBlizzFrames, nil, BBF.HideFrames)
    -- hideTargetMaxHpReduction:SetPoint("LEFT", hideTargetName.text, "RIGHT", 0, 0)
    -- CreateTooltipTwo(hideTargetMaxHpReduction, L["Hide_Reduced_HP"], L["Tooltip_Hide_Reduced_HP_Target"])

    local hideTargetLeaderIcon = CreateCheckbox("hideTargetLeaderIcon", L["Hide_Leader_Icon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideTargetLeaderIcon:SetPoint("TOPLEFT", hideTargetName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideTargetLeaderIcon, L["Tooltip_Hide_Target_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:22:22|a")

    local classColorTargetReputationTexture = CreateCheckbox("classColorTargetReputationTexture", L["Reputation_Class_Color"], BetterBlizzFrames)
    classColorTargetReputationTexture:SetPoint("TOPLEFT", hideTargetLeaderIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(classColorTargetReputationTexture, L["Tooltip_Target_Reputation_Class_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:18:98|a")
    classColorTargetReputationTexture:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BBF.ClassColorReputation(TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "target")
        else
            BBF.ResetClassColorReputation(TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "target")
        end
    end)

    local hideTargetReputationColor = CreateCheckbox("hideTargetReputationColor", L["Hide_Reputation_Color"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideTargetReputationColor:SetPoint("TOPLEFT", classColorTargetReputationTexture, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideTargetReputationColor, L["Tooltip_Hide_Target_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:18:98|a")






    local targetToTFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    targetToTFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 250, -308)
    targetToTFrameText:SetText(L["Target_of_Target"])
    targetToTFrameText:SetFont(fontLarge, 16)
    targetToTFrameText:SetTextColor(1,1,1)
    local targetToTFrameIcon = BetterBlizzFrames:CreateTexture(nil, "BORDER")
    targetToTFrameIcon:SetAtlas("groupfinder-icon-friend")
    targetToTFrameIcon:SetSize(28, 28)
    targetToTFrameIcon:SetPoint("RIGHT", targetToTFrameText, "LEFT", -0.5, 0)
    targetToTFrameIcon:SetDesaturated(1)
    targetToTFrameIcon:SetVertexColor(1, 0, 0)
    local targetToTFrameIcon2 = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    targetToTFrameIcon2:SetAtlas("TargetCrosshairs")
    targetToTFrameIcon2:SetSize(28, 28)
    targetToTFrameIcon2:SetPoint("TOPLEFT", targetToTFrameIcon, "TOPLEFT", 13.5, -13)

    local hideTargetToT = CreateCheckbox("hideTargetToT", L["Hide_Frame"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideTargetToT:SetPoint("TOPLEFT", targetToTFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltipTwo(hideTargetToT, L["Tooltip_Hide_ToT_Frame"])

    local hideTargetToTName = CreateCheckbox("hideTargetToTName", L["Hide_Names"], BetterBlizzFrames)
    hideTargetToTName:SetPoint("LEFT", hideTargetToT.Text, "RIGHT", 0, 0)
    hideTargetToTName:HookScript("OnClick", function(self)
        if self:GetChecked() then
            TargetFrame.totFrame.Name:SetAlpha(0)
            if TargetFrame.totFrame.bbfName then
                TargetFrame.totFrame.bbfName:SetAlpha(0)
            end
        else
            TargetFrame.totFrame.Name:SetAlpha(0)
            if TargetFrame.totFrame.bbfName then
                TargetFrame.totFrame.bbfName:SetAlpha(1)
            end
        end
    end)
    CreateTooltipTwo(hideTargetToTName, L["Tooltip_Hide_ToT_Name"])

    local hideTargetToTDebuffs = CreateCheckbox("hideTargetToTDebuffs", L["Hide_ToT_Debuffs"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideTargetToTDebuffs:SetPoint("TOPLEFT", hideTargetToT, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideTargetToTDebuffs, L["Tooltip_Hide_ToT_Debuffs"])

    local targetToTScale = CreateSlider(BetterBlizzFrames, L["Size"], 0.6, 2.5, 0.01, "targetToTScale", nil, 120)
    targetToTScale:SetPoint("TOPLEFT", targetToTFrameText, "BOTTOMLEFT", -20, -50)
    CreateTooltip(targetToTScale, L["Tooltip_ToT_Size"])

    BBF.targetToTXPos = CreateSlider(BetterBlizzFrames, L["X_Offset"], -100, 100, 1, "targetToTXPos", "X", 120)
    BBF.targetToTXPos:SetPoint("TOP", targetToTScale, "BOTTOM", 0, -15)
    CreateTooltip(BBF.targetToTXPos, L["Tooltip_ToT_X_Offset"])

    local targetToTYPos = CreateSlider(BetterBlizzFrames, L["Y_Offset"], -100, 100, 1, "targetToTYPos", "Y", 120)
    targetToTYPos:SetPoint("TOP", BBF.targetToTXPos, "BOTTOM", 0, -15)
    CreateTooltip(targetToTYPos, L["Tooltip_ToT_Y_Offset"])




    local chatFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    chatFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 250, -467)
    chatFrameText:SetText(L["Chat_Frame"])
    chatFrameText:SetFont(fontLarge, 16)
    chatFrameText:SetTextColor(1,1,1)
    local chatFrameIcon = BetterBlizzFrames:CreateTexture(nil, "BORDER")
    chatFrameIcon:SetAtlas("transmog-icon-chat")
    chatFrameIcon:SetSize(18, 16)
    chatFrameIcon:SetPoint("RIGHT", chatFrameText, "LEFT", -4, 0)

    local hideChatButtons = CreateCheckbox("hideChatButtons", L["Hide_Chat_Buttons"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideChatButtons:SetPoint("TOPLEFT", chatFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltip(hideChatButtons, L["Tooltip_Hide_Chat_Buttons"])

    local chatFrameFilters = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    chatFrameFilters:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 232, -507)
    chatFrameFilters:SetText(L["Filters"])
    chatFrameFilters:SetFont(fontLarge, 12)
    chatFrameFilters:SetTextColor(1,1,1)

    local filterGladiusSpam = CreateCheckbox("filterGladiusSpam", L["Gladius_Spam"], BetterBlizzFrames, nil, BBF.ChatFilterCaller)
    filterGladiusSpam:SetPoint("TOPLEFT", hideChatButtons, "BOTTOMLEFT", 0, -10)
    CreateTooltip(filterGladiusSpam, L["Tooltip_Filter_Gladius_Spam"])

    local filterNpcArenaSpam = CreateCheckbox("filterNpcArenaSpam", L["Arena_Npc_Talk"], BetterBlizzFrames, nil, BBF.ChatFilterCaller)
    filterNpcArenaSpam:SetPoint("LEFT", filterGladiusSpam.text, "RIGHT", 0, 0)
    CreateTooltip(filterNpcArenaSpam, L["Tooltip_Filter_Arena_Npc_Talk"])

    local filterTalentSpam = CreateCheckbox("filterTalentSpam", L["Talent_Spam"], BetterBlizzFrames, nil, BBF.ChatFilterCaller)
    filterTalentSpam:SetPoint("TOPLEFT", filterGladiusSpam, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(filterTalentSpam, L["Tooltip_Filter_Talent_Spam"])

    local filterEmoteSpam = CreateCheckbox("filterEmoteSpam", L["Emote_Spam"], BetterBlizzFrames, nil, BBF.ChatFilterCaller)
    filterEmoteSpam:SetPoint("TOPLEFT", filterTalentSpam, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(filterEmoteSpam, L["Tooltip_Filter_Emote_Spam"])

    local filterSystemMessages = CreateCheckbox("filterSystemMessages", L["System_Messages"], BetterBlizzFrames, nil, BBF.ChatFilterCaller)
    filterSystemMessages:SetPoint("TOPLEFT", filterNpcArenaSpam, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(filterSystemMessages, L["Tooltip_Filter_System_Messages"])

    local filterMiscInfo = CreateCheckbox("filterMiscInfo", L["Misc_Info"], BetterBlizzFrames, nil, BBF.ChatFilterCaller)
    filterMiscInfo:SetPoint("TOPLEFT", filterSystemMessages, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(filterMiscInfo, L["Tooltip_Filter_Misc_Info"])

    local arenaNamesText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    arenaNamesText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 460, -98)
    arenaNamesText:SetText(L["Arena_Names"])
    arenaNamesText:SetFont(fontLarge, 16)
    arenaNamesText:SetTextColor(1,1,1)
    CreateTooltip(arenaNamesText, L["Change_player_names_into_spec"], "ANCHOR_LEFT")
    local arenaNamesIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    arenaNamesIcon:SetAtlas("questlog-questtypeicon-pvp")
    arenaNamesIcon:SetSize(19, 22)
    arenaNamesIcon:SetPoint("RIGHT", arenaNamesText, "LEFT", -3.5, 0)

    local targetAndFocusArenaNames = CreateCheckbox("targetAndFocusArenaNames", L["Target_And_Focus_Arena_Names"], BetterBlizzFrames)
    targetAndFocusArenaNames:SetPoint("TOPLEFT", arenaNamesText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltipTwo(targetAndFocusArenaNames, L["Arena_Names"], L["Tooltip_Target_And_Focus_Arena_Names_Desc"], nil, "ANCHOR_LEFT")

    local partyArenaNames = CreateCheckbox("partyArenaNames", L["Party"], BetterBlizzFrames)
    partyArenaNames:SetPoint("LEFT", targetAndFocusArenaNames.text, "RIGHT", 0, 0)
    CreateTooltipTwo(partyArenaNames, L["Arena_Names"], L["Tooltip_Party_Arena_Names_Desc"], nil, "ANCHOR_LEFT")

    local showSpecName = CreateCheckbox("showSpecName", L["Show_Spec_Name"], BetterBlizzFrames)
    showSpecName:SetPoint("TOPLEFT", targetAndFocusArenaNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(showSpecName, L["Show_Spec_Name"], string.format(L["Tooltip_Show_Spec_Name_Desc"], (BetterBlizzFramesDB.targetAndFocusArenaNamePartyOverride and L["True"] or L["False"])))
    showSpecName:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if BetterBlizzFramesDB.targetAndFocusArenaNamePartyOverride then
                BetterBlizzFramesDB.targetAndFocusArenaNamePartyOverride = false
            else
                BetterBlizzFramesDB.targetAndFocusArenaNamePartyOverride = true
            end
            local value = (BetterBlizzFramesDB.targetAndFocusArenaNamePartyOverride and L["True"] or L["False"])
            local showSpecNameTip = string.format(L["Tooltip_Show_Spec_Name_Desc"], value)
            GameTooltip:ClearLines()
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(L["Show_Spec_Name"])
            GameTooltip:AddLine(showSpecNameTip, 1, 1, 1, true)
            GameTooltip:Show()
            CreateTooltipTwo(showSpecName, L["Show_Spec_Name"], string.format(L["Tooltip_Show_Spec_Name_Desc"], (BetterBlizzFramesDB.targetAndFocusArenaNamePartyOverride and L["True"] or L["False"])))
            BBF.AllNameChanges()
        end
    end)

    local shortArenaSpecName = CreateCheckbox("shortArenaSpecName", L["Short"], BetterBlizzFrames)
    shortArenaSpecName:SetPoint("LEFT", showSpecName.Text, "RIGHT", 0, 0)
    CreateTooltip(shortArenaSpecName, L["Tooltip_Short_Arena_Spec_Name"], "ANCHOR_LEFT")

    local showArenaID = CreateCheckbox("showArenaID", L["Show_Arena_ID"], BetterBlizzFrames)
    showArenaID:SetPoint("TOPLEFT", showSpecName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(showArenaID, L["Tooltip_Show_Arena_ID"])

    local function ToggleDependentCheckboxes()
        local enable = targetAndFocusArenaNames:GetChecked() or partyArenaNames:GetChecked()

        if enable then
            EnableElement(showSpecName)
            EnableElement(shortArenaSpecName)
            EnableElement(showArenaID)
        else
            DisableElement(showSpecName)
            DisableElement(shortArenaSpecName)
            DisableElement(showArenaID)
        end
    end
    -- Initial setup to ensure correct state upon UI load/reload
    ToggleDependentCheckboxes()
    -- Hook into the OnClick event of targetAndFocusArenaNames
    targetAndFocusArenaNames:HookScript("OnClick", ToggleDependentCheckboxes)
    -- Hook into the OnClick event of partyArenaNames
    partyArenaNames:HookScript("OnClick", ToggleDependentCheckboxes)

    local focusFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    focusFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 460, -183)
    focusFrameText:SetText(L["Focus_Frame"])
    focusFrameText:SetFont(fontLarge, 16)
    focusFrameText:SetTextColor(1,1,1)
    local focusFrameIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    focusFrameIcon:SetAtlas("groupfinder-icon-friend")
    focusFrameIcon:SetSize(28, 28)
    focusFrameIcon:SetPoint("RIGHT", focusFrameText, "LEFT", -0.5, 0)
    focusFrameIcon:SetDesaturated(1)
    focusFrameIcon:SetVertexColor(0, 1, 0)

    local focusFrameClickthrough = CreateCheckbox("focusFrameClickthrough", L["Clickthrough"], BetterBlizzFrames, nil, BBF.ClickthroughFrames)
    focusFrameClickthrough:SetPoint("TOPLEFT", focusFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltip(focusFrameClickthrough, L["Tooltip_Focus_Clickthrough"])
    focusFrameClickthrough:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local hideFocusName = CreateCheckbox("hideFocusName", L["Hide_Names"], BetterBlizzFrames, nil, BBF.UpdateNameSettings)
    hideFocusName:SetPoint("TOPLEFT", focusFrameClickthrough, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideFocusName, L["Tooltip_Hide_Focus_Name"])
    hideFocusName:HookScript("OnClick", function(self)
        -- if self:GetChecked() then
        --     FocusFrame.name:SetAlpha(0)
        --     if FocusFrame.bbfName then
        --         FocusFrame.bbfName:SetAlpha(0)
        --     end
        -- else
        --     FocusFrame.name:SetAlpha(0)
        --     if FocusFrame.bbfName then
        --         FocusFrame.bbfName:SetAlpha(1)
        --     else
        --         FocusFrame.name:SetAlpha(1)
        --     end
        -- end
        BBF.AllNameChanges()
    end)

    -- local hideFocusMaxHpReduction = CreateCheckbox("hideFocusMaxHpReduction", "Hide Reduced HP", BetterBlizzFrames, nil, BBF.HideFrames)
    -- hideFocusMaxHpReduction:SetPoint("LEFT", hideFocusName.text, "RIGHT", 0, 0)
    -- CreateTooltipTwo(hideFocusMaxHpReduction, L["Hide_Reduced_HP"], L["Tooltip_Hide_Reduced_HP_Focus"])

    local hideFocusLeaderIcon = CreateCheckbox("hideFocusLeaderIcon", L["Hide_Leader_Icon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideFocusLeaderIcon:SetPoint("TOPLEFT", hideFocusName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideFocusLeaderIcon, L["Tooltip_Hide_Focus_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:22:22|a")

    local classColorFocusReputationTexture = CreateCheckbox("classColorFocusReputationTexture", L["Reputation_Class_Color"], BetterBlizzFrames)
    classColorFocusReputationTexture:SetPoint("TOPLEFT", hideFocusLeaderIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(classColorFocusReputationTexture, L["Tooltip_Focus_Reputation_Class_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:18:98|a")
    classColorFocusReputationTexture:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BBF.ClassColorReputation(FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "focus")
        else
            BBF.ResetClassColorReputation(FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "focus")
        end
    end)

    local hideFocusReputationColor = CreateCheckbox("hideFocusReputationColor", L["Hide_Reputation_Color"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideFocusReputationColor:SetPoint("TOPLEFT", classColorFocusReputationTexture, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideFocusReputationColor, L["Tooltip_Hide_Focus_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:18:98|a")







    local focusToTFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    focusToTFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 460, -298)
    focusToTFrameText:SetText(L["Focus_ToT"])
    focusToTFrameText:SetFont(fontLarge, 16)
    focusToTFrameText:SetTextColor(1,1,1)
    local focusToTFrameIcon = BetterBlizzFrames:CreateTexture(nil, "BORDER")
    focusToTFrameIcon:SetAtlas("groupfinder-icon-friend")
    focusToTFrameIcon:SetSize(28, 28)
    focusToTFrameIcon:SetPoint("RIGHT", focusToTFrameText, "LEFT", -0.5, 0)
    focusToTFrameIcon:SetDesaturated(1)
    focusToTFrameIcon:SetVertexColor(0, 1, 0)
    local focusToTFrameIcon2 = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    focusToTFrameIcon2:SetAtlas("TargetCrosshairs")
    focusToTFrameIcon2:SetSize(28, 28)
    focusToTFrameIcon2:SetPoint("TOPLEFT", focusToTFrameIcon, "TOPLEFT", 13.5, -13)

    local hideFocusToT = CreateCheckbox("hideFocusToT", L["Hide_Frame"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideFocusToT:SetPoint("TOPLEFT", focusToTFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltipTwo(hideFocusToT, L["Tooltip_Hide_FocusToT_Frame"])

    local hideFocusToTName = CreateCheckbox("hideFocusToTName", L["Hide_Names"], BetterBlizzFrames)
    hideFocusToTName:SetPoint("LEFT", hideFocusToT.Text, "RIGHT", 0, 0)
    hideFocusToTName:HookScript("OnClick", function(self)
        if self:GetChecked() then
            FocusFrame.totFrame.Name:SetAlpha(0)
            if FocusFrame.totFrame.bbfName then
                FocusFrame.totFrame.bbfName:SetAlpha(0)
            end
        else
            FocusFrame.totFrame.Name:SetAlpha(0)
            if FocusFrame.totFrame.bbfName then
                FocusFrame.totFrame.bbfName:SetAlpha(1)
            end
        end
    end)
    CreateTooltipTwo(hideFocusToTName, L["Tooltip_Hide_FocusToT_Name"])

    local hideFocusToTDebuffs = CreateCheckbox("hideFocusToTDebuffs", L["Hide_FocusToT_Debuffs"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideFocusToTDebuffs:SetPoint("TOPLEFT", hideFocusToT, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideFocusToTDebuffs, L["Tooltip_Hide_ToT_Debuffs"])

    local focusToTScale = CreateSlider(BetterBlizzFrames, L["Size"], 0.6, 2.5, 0.01, "focusToTScale", nil, 120)
    focusToTScale:SetPoint("TOPLEFT", focusToTFrameText, "BOTTOMLEFT", -20, -50)
    CreateTooltip(focusToTScale, L["Tooltip_FocusToT_Size"])

    BBF.focusToTXPos = CreateSlider(BetterBlizzFrames, L["X_Offset"], -100, 100, 1, "focusToTXPos", "X", 120)
    BBF.focusToTXPos:SetPoint("TOP", focusToTScale, "BOTTOM", 0, -15)
    CreateTooltip(BBF.focusToTXPos, L["Tooltip_FocusToT_X_Offset"])

    local focusToTYPos = CreateSlider(BetterBlizzFrames, L["Y_Offset"], -100, 100, 1, "focusToTYPos", "Y", 120)
    focusToTYPos:SetPoint("TOP", BBF.focusToTXPos, "BOTTOM", 0, -15)
    CreateTooltip(focusToTYPos, L["Tooltip_FocusToT_Y_Offset"])





    local allFrameText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    allFrameText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 250, 30)
    allFrameText:SetText(L["All_Frames"])
    allFrameText:SetFont(fontLarge, 16)
    allFrameText:SetTextColor(1,1,1)
    local allFrameIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    allFrameIcon:SetAtlas("groupfinder-icon-friend")
    allFrameIcon:SetSize(25, 25)
    allFrameIcon:SetPoint("RIGHT", allFrameText, "LEFT", -2, -1)
    local allFrameIcon2 = BetterBlizzFrames:CreateTexture(nil, "BORDER")
    allFrameIcon2:SetAtlas("groupfinder-icon-friend")
    allFrameIcon2:SetSize(20, 20)
    allFrameIcon2:SetPoint("RIGHT", allFrameText, "LEFT", 2, 4)
    allFrameIcon2:SetDesaturated(1)
    allFrameIcon2:SetVertexColor(0, 1, 0)
    local allFrameIcon3 = BetterBlizzFrames:CreateTexture(nil, "BORDER")
    allFrameIcon3:SetAtlas("groupfinder-icon-friend")
    allFrameIcon3:SetSize(20, 20)
    allFrameIcon3:SetPoint("RIGHT", allFrameText, "LEFT", -10, 4)
    allFrameIcon3:SetDesaturated(1)
    allFrameIcon3:SetVertexColor(1, 0, 0)

    local classicFrames = CreateCheckbox("classicFrames", L["Classic_Frames"], BetterBlizzFrames)
    classicFrames:SetPoint("TOPLEFT", allFrameText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    CreateTooltipTwo(classicFrames, L["Classic_Frames"], L["Tooltip_Classic_Frames_Desc"])
    classicFrames:HookScript("OnClick", function(self)
        BetterBlizzFramesDB.noPortraitModes = false
        if self:GetChecked() and C_AddOns.IsAddOnLoaded("ClassicFrames") then
            C_AddOns.DisableAddOn("ClassicFrames")
        end
        if self:GetChecked() then
            if not BBF.ClassicReloadWindow then
                local statusText = classicFrames:GetChecked() and "|cff00ff00ON|r" or "|cffff0000OFF|r"
                StaticPopupDialogs["BBF_CLASSIC_RELOAD"] = {
                    text = titleText..string.format(L["Classic_Frames_Status_Text"], statusText),
                    button1 = L["Reload_UI"],
                    button2 = L["No"],
                    OnAccept = function()
                        BetterBlizzFramesDB.reopenOptions = true
                        if BBF.ChangesOnReload then
                            for key, value in pairs(BBF.ChangesOnReload) do
                                BetterBlizzFramesDB[key] = value
                                if key == "comboPointLocation" and value ~= nil and not InCombatLockdown() then
                                    C_CVar.SetCVar("comboPointLocation", value)
                                end
                            end
                        end
                        C_AddOns.DisableAddOn("ClassicFrames")
                        ReloadUI()
                    end,
                    OnShow = function(self)
                        local statusText = classicFrames:GetChecked() and "|cff00ff00ON|r" or "|cffff0000OFF|r"
                        self.Text:SetText(titleText..string.format(L["Classic_Frames_Status_Text"], statusText))
                        if not self.classicSettings then
                            BBF.ChangesOnReload = {}
                            self.cfTextures = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate")
                            self.cfTextures:SetSize(26, 26)
                            CreateTooltipTwo(self.cfTextures, L["Use_Classic_Textures"], L["Tooltip_Use_Classic_Textures"])
                            self.cfTextures.Text:SetText(L["Classic_Health_Mana_Textures"])

                            self.cfCastbars = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate")
                            self.cfCastbars:SetSize(26, 26)
                            CreateTooltipTwo(self.cfCastbars, L["Use_Classic_Castbars"], L["Tooltip_Use_Classic_Castbars"])
                            self.cfCastbars.Text:SetText(L["Castbar_Classic"])

                            self.cfComboPoints = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate")
                            self.cfComboPoints:SetSize(26, 26)
                            CreateTooltipTwo(self.cfComboPoints, L["Use_Classic_Combo_Points"], L["Tooltip_Use_Classic_Combo_Points"])
                            self.cfComboPoints.Text:SetText(L["Classic_Combo_Points"])

                            local firstClick = BetterBlizzFramesDB.classicFramesClicked == nil
                            BetterBlizzFramesDB.classicFramesClicked = true

                            self.cfCastbars:SetChecked((firstClick and true) or BetterBlizzFramesDB.classicCastbars or false)
                            self.cfComboPoints:SetChecked(C_CVar.GetCVar("comboPointLocation") == "1" and true or false)
                            self.cfTextures:SetChecked(BetterBlizzFramesDB.changeUnitFrameHealthbarTexture or false)

                            self.classicSettings = true
                        end

                        local function CheckBoxes()
                            local castbarsEnabled = self.cfCastbars:GetChecked()
                            if castbarsEnabled then
                                BBF.ChangesOnReload["classicCastbarsParty"] = castbarsEnabled
                                BBF.ChangesOnReload["classicCastbarsPlayer"] = castbarsEnabled
                                BBF.ChangesOnReload["classicCastbarsPlayerBorder"] = castbarsEnabled
                                BBF.ChangesOnReload["classicCastbars"] = castbarsEnabled
                                BBF.ChangesOnReload["classicCastbarsParty"] = castbarsEnabled
                                BBF.ChangesOnReload["targetToTXPos"] = -1
                                BBF.ChangesOnReload["targetToTYPos"] = 17
                                BBF.ChangesOnReload["focusToTXPos"] = -1
                                BBF.ChangesOnReload["focusToTYPos"] = 17
                                BBF.ChangesOnReload["targetToTScale"] = 0.97
                                BBF.ChangesOnReload["focusToTScale"] = 0.97
                                BBF.ChangesOnReload["targetCastBarXPos"] = 5
                                BBF.ChangesOnReload["focusCastBarXPos"] = 5
                                BBF.ChangesOnReload["targetCastBarWidth"] = 143
                                BBF.ChangesOnReload["focusCastBarWidth"] = 143
                                BBF.ChangesOnReload["playerCastBarWidth"] = 205
                                BBF.ChangesOnReload["playerCastBarHeight"] = 12.5
                            end

                            local comboPointsEnabled = self.cfComboPoints:GetChecked()
                            BBF.ChangesOnReload["comboPointLocation"] = comboPointsEnabled and "1" or nil
                            BBF.ChangesOnReload["enableLegacyComboPoints"] = comboPointsEnabled and true or nil
                            BBF.ChangesOnReload["legacyCombosTurnedOff"] = comboPointsEnabled and nil or true

                            local statusBarsEnabled = self.cfTextures:GetChecked()
                            BBF.ChangesOnReload["changeUnitFrameHealthbarTexture"] = statusBarsEnabled or false
                            BBF.ChangesOnReload["changeUnitFrameManabarTexture"] = statusBarsEnabled or false
                            BBF.ChangesOnReload["unitFrameHealthbarTexture"] = statusBarsEnabled and "Blizzard CF" or nil
                            BBF.ChangesOnReload["unitFrameManabarTexture"] = statusBarsEnabled and "Blizzard CF" or nil
                            BBF.ChangesOnReload["hidePlayerHealthLossAnim"] = statusBarsEnabled and true or nil
                        end
                        CheckBoxes()

                        self.cfCastbars:SetScript("OnClick", function()
                            CheckBoxes()
                        end)
                        self.cfComboPoints:SetScript("OnClick", function()
                            CheckBoxes()
                        end)
                        self.cfTextures:SetScript("OnClick", function()
                            CheckBoxes()
                        end)
                        self.cfCastbars:SetPoint("BOTTOMLEFT", self.ButtonContainer.Button1, "TOPLEFT", 15, 43)
                        self.cfComboPoints:SetPoint("TOPLEFT", self.cfCastbars, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
                        self.cfTextures:SetPoint("TOPLEFT", self.cfComboPoints, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
                        self.cfTextures:Show()
                    end,
                    OnHide = function(self)
                        if self.cfTextures then
                            self.cfTextures:Hide()
                        end
                        if self.cfComboPoints then
                            self.cfComboPoints:Hide()
                        end
                        if self.cfCastbars then
                            self.cfCastbars:Hide()
                        end
                    end,
                    timeout = 0,
                    whileDead = true,
                }
                BBF.ClassicReloadWindow = true
            end
            StaticPopup_Show("BBF_CLASSIC_RELOAD")
        else
            local db = BetterBlizzFramesDB
            db.classicCastbarsParty = false
            db.classicCastbarsPlayer = false
            db.classicCastbarsPlayerBorder = false
            db.classicCastbars = false
            db.classicCastbarsParty = false
            db.changeUnitFrameHealthbarTexture = false
            db.changeUnitFrameManabarTexture = false
            db.comboPointLocation = nil
            db.targetToTXPos = -1
            db.targetToTYPos = 17
            db.focusToTXPos = -1
            db.focusToTYPos = 17
            db.targetToTScale = 0.97
            db.focusToTScale = 0.97
            db.targetCastBarXPos = 5
            db.focusCastBarXPos = 5
            db.targetCastBarWidth = 143
            db.focusCastBarWidth = 143
            db.playerCastBarWidth = 205
            db.playerCastBarHeight = 12.5
            db.hidePlayerHealthLossAnim = nil
            if not InCombatLockdown() then
                C_CVar.SetCVar("comboPointLocation", "2")
            end
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local noPortraitModes = CreateCheckbox("noPortraitModes", L["No_Portrait"], BetterBlizzFrames)
    noPortraitModes:SetPoint("LEFT", classicFrames.text, "RIGHT", 0, 0)
    CreateTooltipTwo(noPortraitModes, L["No_Portrait"], L["Tooltip_No_Portrait_Desc"])
    noPortraitModes:HookScript("OnClick", function(self)
        BetterBlizzFramesDB.classicFrames = false
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local noPortraitPixelBorder = CreateCheckbox("noPortraitPixelBorder", L["NP_PixelBorder"], BetterBlizzFrames)
    noPortraitPixelBorder:SetPoint("BOTTOMLEFT", noPortraitModes, "TOPRIGHT", -14, -5)
    CreateTooltipTwo(noPortraitPixelBorder, L["No_Portrait_PixelBorder"], L["Tooltip_NP_PixelBorder_Desc"])
    noPortraitPixelBorder:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BetterBlizzFramesDB.classicFrames = false
            BetterBlizzFramesDB.noPortraitModes = true
            if not BetterBlizzFramesDB.changeUnitFrameHealthbarTexture then
                BetterBlizzFramesDB.changeUnitFrameHealthbarTexture = true
                BetterBlizzFramesDB.unitFrameHealthbarTexture = "Smooth"
            end
            if not BetterBlizzFramesDB.changeUnitFrameManabarTexture then
                BetterBlizzFramesDB.changeUnitFrameManabarTexture = true
                BetterBlizzFramesDB.unitFrameManabarTexture = BetterBlizzFramesDB.unitFrameHealthbarTexture or "Smooth"
            end
        end
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local classColorFrames = CreateCheckbox("classColorFrames", L["Class_Color_Health"], BetterBlizzFrames)
    classColorFrames:SetPoint("TOPLEFT", classicFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    classColorFrames:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    classColorFrames:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if IsShiftKeyDown() and not IsControlKeyDown() then
                if not BetterBlizzFramesDB.classColorFramesSkipFriendly then
                    BetterBlizzFramesDB.classColorFramesSkipFriendly = true
                else
                    BetterBlizzFramesDB.classColorFramesSkipFriendly = nil
                end
            elseif IsControlKeyDown() and not IsShiftKeyDown() then
                if not BetterBlizzFramesDB.classColorFramesSkipPlayer then
                    BetterBlizzFramesDB.classColorFramesSkipPlayer = true
                else
                    BetterBlizzFramesDB.classColorFramesSkipPlayer = nil
                end
            end
            if BetterBlizzFramesDB.classColorFramesSkipPlayer then
                if PlayerFrame and PlayerFrame.healthbar then
                    PlayerFrame.healthbar:SetStatusBarDesaturated(false)
                    PlayerFrame.healthbar:SetStatusBarColor(1, 1, 1)
                end
                if CfPlayerFrameHealthBar then
                    BBF.updateFrameColorToggleVer(CfPlayerFrameHealthBar, "player")
                end
            else
                if PlayerFrame and PlayerFrame.healthbar then
                    BBF.updateFrameColorToggleVer(PlayerFrame.healthbar, "player")
                end
                if CfPlayerFrameHealthBar then
                    BBF.updateFrameColorToggleVer(CfPlayerFrameHealthBar, "player")
                end
            end
            if GameTooltip:IsShown() and GameTooltip:GetOwner() == self then
                self:GetScript("OnEnter")(self)
            end
            BBF.UpdateFrames()
        end
    end)

    classColorFrames:HookScript("OnClick", function (self)
        local function UpdateCVar()
            if not InCombatLockdown() then
                if BetterBlizzFramesDB.classColorFrames then
                    SetCVar("raidFramesDisplayClassColor", 1)
                end
            else
                C_Timer.After(1, function()
                    UpdateCVar()
                end)
            end
        end
        UpdateCVar()
        BBF.UpdateFrames()
    end)
    CreateTooltipTwo(classColorFrames, L["Tooltip_Class_Color_Healthbars_Title"], L["Tooltip_Class_Color_Healthbars"])

     local customHealthbarColors = CreateCheckbox("customHealthbarColors", L["Custom_Color_Health_Mana"], BetterBlizzFrames)
    customHealthbarColors:SetPoint("TOPLEFT", classColorFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(customHealthbarColors, L["Custom_Colors"], L["Tooltip_Custom_Colors_Desc"])
    customHealthbarColors:HookScript("OnClick", function(self)
        BBF.UpdateFrames()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    customHealthbarColors.extendedSettings = CreateFrame("Frame", nil, BetterBlizzFrames, "DefaultPanelFlatTemplate")
    customHealthbarColors.extendedSettings:SetSize(345, 560)
    customHealthbarColors.extendedSettings:SetPoint("TOPLEFT", classColorFrames, "BOTTOMLEFT", 0, -10)
    customHealthbarColors.extendedSettings:SetFrameStrata("DIALOG")
    customHealthbarColors.extendedSettings:SetIgnoreParentAlpha(true)
    customHealthbarColors.extendedSettings:Hide()
    customHealthbarColors.extendedSettings:SetTitle(L["Custom_Health_Colors"])
    customHealthbarColors.extendedSettings:EnableMouse(true)
    customHealthbarColors.extendedSettings:SetMovable(true)
    customHealthbarColors.extendedSettings:SetClampedToScreen(true)
    customHealthbarColors.extendedSettings:RegisterForDrag("LeftButton")
    customHealthbarColors.extendedSettings:SetScript("OnDragStart", function(self) self:StartMoving() end)
    customHealthbarColors.extendedSettings:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    customHealthbarColors.closeButton = CreateFrame("Button", nil, customHealthbarColors.extendedSettings, "UIPanelCloseButton")
    customHealthbarColors.closeButton:SetPoint("TOPRIGHT", customHealthbarColors.extendedSettings, "TOPRIGHT", 0, 0)
    customHealthbarColors.closeButton:SetScript("OnClick", function()
        customHealthbarColors.extendedSettings:Hide()
        BetterBlizzFrames:SetAlpha(1)
    end)

    customHealthbarColors.bg = customHealthbarColors.extendedSettings:CreateTexture(nil, "BACKGROUND")
    customHealthbarColors.bg:SetPoint("TOPLEFT", customHealthbarColors.extendedSettings, "TOPLEFT", 7, -3)
    customHealthbarColors.bg:SetPoint("BOTTOMRIGHT", customHealthbarColors.extendedSettings, "BOTTOMRIGHT", -3, 3)
    customHealthbarColors.bg:SetColorTexture(0.08, 0.08, 0.08, 1)

    customHealthbarColors:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if IsShiftKeyDown() and not IsControlKeyDown() then
                if not BetterBlizzFramesDB.classColorFramesSkipFriendly then
                    BetterBlizzFramesDB.classColorFramesSkipFriendly = true
                else
                    BetterBlizzFramesDB.classColorFramesSkipFriendly = nil
                end
                BBF.UpdateFrames()
            elseif IsControlKeyDown() and not IsShiftKeyDown() then
                if not BetterBlizzFramesDB.classColorFramesSkipPlayer then
                    BetterBlizzFramesDB.classColorFramesSkipPlayer = true
                else
                    BetterBlizzFramesDB.classColorFramesSkipPlayer = nil
                end
                if BetterBlizzFramesDB.classColorFramesSkipPlayer then
                    if PlayerFrame and PlayerFrame.healthbar then
                        PlayerFrame.healthbar:SetStatusBarDesaturated(false)
                        PlayerFrame.healthbar:SetStatusBarColor(1, 1, 1)
                    end
                    if CfPlayerFrameHealthBar then
                        BBF.updateFrameColorToggleVer(CfPlayerFrameHealthBar, "player")
                    end
                else
                    if PlayerFrame and PlayerFrame.healthbar then
                        BBF.updateFrameColorToggleVer(PlayerFrame.healthbar, "player")
                    end
                    if CfPlayerFrameHealthBar then
                        BBF.updateFrameColorToggleVer(CfPlayerFrameHealthBar, "player")
                    end
                end
            elseif not IsShiftKeyDown() and not IsControlKeyDown() then
                customHealthbarColors.extendedSettings:SetShown(not customHealthbarColors.extendedSettings:IsShown())
                BetterBlizzFrames:SetAlpha(customHealthbarColors.extendedSettings:IsShown() and 0.5 or 1)
            end
        end
    end)

    local clrFx = customHealthbarColors.extendedSettings
    clrFx.customColorsHeader = clrFx:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    clrFx.customColorsHeader:SetPoint("TOPLEFT", clrFx, "TOPLEFT", 11, -28)
    clrFx.customColorsHeader:SetText(L["Custom_Colors"])
    clrFx.customColorsHeader:SetFont(fontLarge, 14)
    clrFx.customColorsHeader:SetTextColor(1, 1, 1)

    clrFx.customColorsUnitFrames = CreateCheckbox("customColorsUnitFrames", L["Enable_On_UnitFrames"], clrFx)
    clrFx.customColorsUnitFrames:SetPoint("TOPLEFT", clrFx.customColorsHeader, "BOTTOMLEFT", 0, -1)
    CreateTooltipTwo(clrFx.customColorsUnitFrames, L["Enable_On_UnitFrames"], L["Tooltip_Enable_On_UnitFrames_Desc"])
    clrFx.customColorsUnitFrames:HookScript("OnClick", function(self)
        BBF.UpdateFrames()
    end)

    clrFx.customColorsRaidFrames = CreateCheckbox("customColorsRaidFrames", L["Enable_On_Raid_Party_Frames"], clrFx)
    clrFx.customColorsRaidFrames:SetPoint("TOPLEFT", clrFx.customColorsUnitFrames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(clrFx.customColorsRaidFrames, L["Enable_On_Raid_Party_Frames"], L["Tooltip_Enable_On_Raid_Party_Frames_Desc"])
    clrFx.customColorsRaidFrames:HookScript("OnClick", function(self)
        BBF.UpdateFrames()
    end)

    clrFx.reactionColorsSeparator = clrFx:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    clrFx.reactionColorsSeparator:SetPoint("TOPLEFT", clrFx.customColorsRaidFrames, "BOTTOMLEFT", 0, -2)
    clrFx.reactionColorsSeparator:SetText(L["Reaction_Colors"])
    clrFx.reactionColorsSeparator:SetFont(fontLarge, 14)
    clrFx.reactionColorsSeparator:SetTextColor(1, 1, 1)

    clrFx.enemyHealthColor = CreateColorBox(clrFx, "enemyHealthColor", L["Enemy"], function() BBF.UpdateFrames() end)
    clrFx.enemyHealthColor:SetPoint("TOPLEFT", clrFx.reactionColorsSeparator, "BOTTOMLEFT", 0, -1)
    CreateTooltipTwo(clrFx.enemyHealthColor, L["Enemy_Health_Color"], L["Tooltip_Color_Picker_Desc"])

    clrFx.friendlyHealthColor = CreateColorBox(clrFx, "friendlyHealthColor", L["Friendly"], function() BBF.UpdateFrames() end)
    clrFx.friendlyHealthColor:SetPoint("LEFT", clrFx.enemyHealthColor.text, "RIGHT", 0, 0)
    CreateTooltipTwo(clrFx.friendlyHealthColor, L["Friendly_Health_Color"], L["Tooltip_Color_Picker_Desc"])

    clrFx.neutralHealthColor = CreateColorBox(clrFx, "neutralHealthColor", L["Neutral"], function() BBF.UpdateFrames() end)
    clrFx.neutralHealthColor:SetPoint("LEFT", clrFx.friendlyHealthColor.text, "RIGHT", 0, 0)
    CreateTooltipTwo(clrFx.neutralHealthColor, L["Neutral_Health_Color"], L["Tooltip_Color_Picker_Desc"])

    clrFx.classColorsSeparator = clrFx:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    clrFx.classColorsSeparator:SetPoint("TOPLEFT", clrFx.enemyHealthColor, "BOTTOMLEFT", 0, -3)
    clrFx.classColorsSeparator:SetText(L["Class_Colors"])
    clrFx.classColorsSeparator:SetFont(fontLarge, 14)
    clrFx.classColorsSeparator:SetTextColor(1, 1, 1)

    clrFx.overrideClassColors = CreateCheckbox("overrideClassColors", L["Override_Class_Colors"], clrFx)
    clrFx.overrideClassColors:SetPoint("TOPLEFT", clrFx.classColorsSeparator, "BOTTOMLEFT", 0, -1)
    CreateTooltipTwo(clrFx.overrideClassColors, L["Override_Class_Colors"], L["Tooltip_Override_Class_Colors_Desc"])

    clrFx.useOneClassColor = CreateCheckbox("useOneClassColor", L["Use_One_Color"], clrFx)
    clrFx.useOneClassColor:SetPoint("TOPLEFT", clrFx.overrideClassColors, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(clrFx.useOneClassColor, L["Use_One_Color_For_All_Classes"], L["Tooltip_Use_One_Color_For_All_Classes_Desc"])
    clrFx.useOneClassColor:HookScript("OnClick", function(self)
        local enabled = not self:GetChecked()
        if self:GetChecked() then
            clrFx.singleClassColor:SetAlpha(1)
        else
            clrFx.singleClassColor:SetAlpha(0.5)
        end
        for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
            if enabled then
                classData.colorBox:SetAlpha(1)
            else
                classData.colorBox:SetAlpha(0.5)
            end
        end
        BBF.UpdateFrames()
    end)

    clrFx.singleClassColor = CreateColorBox(clrFx, "singleClassColor", L["All_Classes"], function() BBF.UpdateFrames() end)
    clrFx.singleClassColor:SetPoint("LEFT", clrFx.useOneClassColor.Text, "RIGHT", 4, 0)
    CreateTooltipTwo(clrFx.singleClassColor, L["Single_Class_Color"], L["Tooltip_Color_Picker_Desc"])

    if not BetterBlizzFramesDB.useOneClassColor then
        clrFx.singleClassColor:SetAlpha(0.5)
    end

    customHealthbarColors.classColorBoxes = {}
    
    local classes = {}
    for classID = 1, GetNumClasses() do
        local _, classTag, classID = GetClassInfo(classID)
        if classTag then
            table.insert(classes, {key = classTag, name = FormatClassName(classTag)})
        end
    end
    
    table.sort(classes, function(a, b) return a.name < b.name end)

    local lastClassColorRow1
    local lastClassColorRow2
    local lastClassColorRow3
    local thirdCount = math.ceil(#classes / 3)
    
    for i, classData in ipairs(classes) do
        local classColor = CreateColorBox(clrFx, "classColor"..classData.key, classData.name, function() BBF.UpdateFrames() end)
        
        if i <= thirdCount then
            if i == 1 then
                classColor:SetPoint("TOPLEFT", clrFx.useOneClassColor, "BOTTOMLEFT", 0, 1)
            else
                classColor:SetPoint("TOPLEFT", lastClassColorRow1, "BOTTOMLEFT", 0, 1)
            end
            lastClassColorRow1 = classColor
        elseif i <= thirdCount * 2 then
            if i == thirdCount + 1 then
                classColor:SetPoint("TOPLEFT", clrFx.useOneClassColor, "BOTTOMLEFT", 105, 1)
            else
                classColor:SetPoint("TOPLEFT", lastClassColorRow2, "BOTTOMLEFT", 0, 1)
            end
            lastClassColorRow2 = classColor
        else
            if i == thirdCount * 2 + 1 then
                classColor:SetPoint("TOPLEFT", clrFx.useOneClassColor, "BOTTOMLEFT", 210, 1)
            else
                classColor:SetPoint("TOPLEFT", lastClassColorRow3, "BOTTOMLEFT", 0, 1)
            end
            lastClassColorRow3 = classColor
        end
        
        CreateTooltipTwo(classColor, classData.name.." "..L["Class_Colors"], L["Tooltip_Color_Picker_Desc"])
        table.insert(customHealthbarColors.classColorBoxes, {colorBox = classColor, class = classData.key})
    end

    if not BetterBlizzFramesDB.overrideClassColors then
        clrFx.useOneClassColor:Disable()
        clrFx.useOneClassColor:SetAlpha(0.5)
        clrFx.singleClassColor:SetAlpha(0.5)
        for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
            classData.colorBox:SetAlpha(0.5)
        end
    else
        if BetterBlizzFramesDB.useOneClassColor then
            clrFx.singleClassColor:SetAlpha(1)
            for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
                classData.colorBox:SetAlpha(0.5)
            end
        else
            clrFx.singleClassColor:SetAlpha(0.5)
            for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
                classData.colorBox:SetAlpha(1)
            end
        end
    end

    clrFx.useOneClassColor:HookScript("OnShow", function(self)
        local enabled = not BetterBlizzFramesDB.useOneClassColor
        local classColorsEnabled = BetterBlizzFramesDB.overrideClassColors
        for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
            if classColorsEnabled and enabled then
                classData.colorBox:SetAlpha(1)
            else
                classData.colorBox:SetAlpha(0.5)
            end
        end
    end)
    
    clrFx.powerColorsSeparator = clrFx:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    clrFx.powerColorsSeparator:SetPoint("TOPLEFT", lastClassColorRow1 or clrFx.useOneClassColor, "BOTTOMLEFT", 0, -3)
    clrFx.powerColorsSeparator:SetText(L["Power_Colors"])
    clrFx.powerColorsSeparator:SetFont(fontLarge, 14)
    clrFx.powerColorsSeparator:SetTextColor(1, 1, 1)

    clrFx.customPowerColors = CreateCheckbox("customPowerColors", L["Enable_Power_Colors"], clrFx)
    clrFx.customPowerColors:SetPoint("TOPLEFT", clrFx.powerColorsSeparator, "BOTTOMLEFT", 0, -1)
    CreateTooltipTwo(clrFx.customPowerColors, L["Enable_Power_Colors"], L["Tooltip_Enable_Power_Colors_Desc"])

    clrFx.useOnePowerColor = CreateCheckbox("useOnePowerColor", L["Use_One_Color"], clrFx)
    clrFx.useOnePowerColor:SetPoint("TOPLEFT", clrFx.customPowerColors, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(clrFx.useOnePowerColor, L["Use_One_Color_For_All_Powers"], L["Tooltip_Use_One_Color_For_All_Powers_Desc"])
    clrFx.useOnePowerColor:HookScript("OnClick", function(self)
        local enabled = not self:GetChecked()
        if self:GetChecked() then
            clrFx.singlePowerColor:SetAlpha(1)
        else
            clrFx.singlePowerColor:SetAlpha(0.5)
        end
        for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
            if enabled then
                powerData.colorBox:SetAlpha(1)
            else
                powerData.colorBox:SetAlpha(0.5)
            end
        end
        if BetterBlizzFramesDB.useOnePowerColor and not BetterBlizzFramesDB.changeUnitFrameManabarTexture and BetterBlizzFramesDB.useOnePowerColor and BetterBlizzFramesDB.customPowerColors then
            clrFx.singlePowerColorNote:Show()
        else
            clrFx.singlePowerColorNote:Hide()
        end
        BBF.UpdateFrames()
    end)

    clrFx.singlePowerColor = CreateColorBox(clrFx, "singlePowerColor", L["All_Powers"], function() BBF.UpdateFrames() end)
    clrFx.singlePowerColor:SetPoint("LEFT", clrFx.useOnePowerColor.Text, "RIGHT", 4, 0)
    CreateTooltipTwo(clrFx.singlePowerColor, L["Single_Power_Color"], L["Tooltip_Color_Picker_Desc"])

    clrFx.singlePowerColorNote = clrFx:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    clrFx.singlePowerColorNote:SetPoint("LEFT", clrFx.singlePowerColor.text, "RIGHT", 2, 1)
    clrFx.singlePowerColorNote:SetText("|cffff0000"..L["Texture_Change_Recommended"].."|r")
    clrFx.singlePowerColorNote:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Texture_Change_Recommended"], 1, 1, 1, 1, true)
        GameTooltip:AddLine(L["Tooltip_Texture_Change_Recommended_Desc"], nil, nil, nil, true)
        GameTooltip:Show()
    end)
    clrFx.singlePowerColorNote:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    if BetterBlizzFramesDB.useOnePowerColor and not BetterBlizzFramesDB.changeUnitFrameManabarTexture and BetterBlizzFramesDB.useOnePowerColor and BetterBlizzFramesDB.customPowerColors then
        clrFx.singlePowerColorNote:Show()
    else
        clrFx.singlePowerColorNote:Hide()
    end

    if not BetterBlizzFramesDB.useOnePowerColor then
        clrFx.singlePowerColor:SetAlpha(0.5)
    end


    local powerColors = {
        {key = "MANA", name = L["Power_Mana"]},
        {key = "RAGE", name = L["Power_Rage"]},
        {key = "FOCUS", name = L["Power_Focus"]},
        {key = "ENERGY", name = L["Power_Energy"]},
        {key = "RUNIC_POWER", name = L["Power_Runic_Power"]},
        {key = "LUNAR_POWER", name = L["Power_Lunar_Power"]},
        {key = "MAELSTROM", name = L["Power_Maelstrom"]},
        {key = "INSANITY", name = L["Power_Insanity"]},
        {key = "CHI", name = L["Power_Chi"]},
        {key = "FURY", name = L["Power_Fury"]},
        {key = "EBON_MIGHT", name = L["Power_Ebon_Might"]},
        {key = "STAGGER", name = L["Power_Stagger"]},
        {key = "SOUL_FRAGMENTS", name = L["Power_Soul_Fragments"]},
    }

    customHealthbarColors.powerColorBoxes = {}
    local lastPowerColorRow1
    local lastPowerColorRow2
    local lastPowerColorRow3
    local thirdCount = 4
    
    for i, powerData in ipairs(powerColors) do
        local powerColor = CreateColorBox(clrFx, "powerColor"..powerData.key, powerData.name, function() BBF.UpdateFrames() end)

        if i <= thirdCount then
            if i == 1 then
                powerColor:SetPoint("TOPLEFT", clrFx.useOnePowerColor, "BOTTOMLEFT", 0, 1)
            else
                powerColor:SetPoint("TOPLEFT", lastPowerColorRow1, "BOTTOMLEFT", 0, 1)
            end
            lastPowerColorRow1 = powerColor
        elseif i <= thirdCount * 2 then
            if i == thirdCount + 1 then
                powerColor:SetPoint("TOPLEFT", clrFx.useOnePowerColor, "BOTTOMLEFT", 105, 1)
            else
                powerColor:SetPoint("TOPLEFT", lastPowerColorRow2, "BOTTOMLEFT", 0, 1)
            end
            lastPowerColorRow2 = powerColor
        else
            if i == thirdCount * 2 + 1 then
                powerColor:SetPoint("TOPLEFT", clrFx.useOnePowerColor, "BOTTOMLEFT", 210, 1)
            else
                powerColor:SetPoint("TOPLEFT", lastPowerColorRow3, "BOTTOMLEFT", 0, 1)
            end
            lastPowerColorRow3 = powerColor
        end
        
        CreateTooltipTwo(powerColor, powerData.name.." "..L["Color"], L["Tooltip_Color_Picker_Desc"])
        table.insert(customHealthbarColors.powerColorBoxes, {colorBox = powerColor, power = powerData.key})
    end
    
    if not BetterBlizzFramesDB.customPowerColors then
        clrFx.useOnePowerColor:Disable()
        clrFx.useOnePowerColor:SetAlpha(0.5)
        clrFx.singlePowerColor:SetAlpha(0.5)
        for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
            powerData.colorBox:SetAlpha(0.5)
        end
    else
        if BetterBlizzFramesDB.useOnePowerColor then
            clrFx.singlePowerColor:SetAlpha(1)
            for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
                powerData.colorBox:SetAlpha(0.5)
            end
        else
            clrFx.singlePowerColor:SetAlpha(0.5)
            for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
                powerData.colorBox:SetAlpha(1)
            end
        end
    end

    clrFx.useOnePowerColor:HookScript("OnShow", function(self)
        local enabled = not BetterBlizzFramesDB.useOnePowerColor
        local powerColorsEnabled = BetterBlizzFramesDB.customPowerColors
        for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
            if powerColorsEnabled and enabled then
                powerData.colorBox:SetAlpha(1)
            else
                powerData.colorBox:SetAlpha(0.5)
            end
        end
    end)
    
    clrFx.customPowerColors:HookScript("OnShow", function(self)
        local enabled = BetterBlizzFramesDB.customPowerColors
        if enabled then
            clrFx.useOnePowerColor:Enable()
            clrFx.useOnePowerColor:SetAlpha(1)
            clrFx.singlePowerColor:SetAlpha(BetterBlizzFramesDB.useOnePowerColor and 1 or 0.5)
            for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
                powerData.colorBox:SetAlpha(BetterBlizzFramesDB.useOnePowerColor and 0.5 or 1)
            end
        else
            clrFx.useOnePowerColor:Disable()
            clrFx.useOnePowerColor:SetAlpha(0.5)
            clrFx.singlePowerColor:SetAlpha(0.5)
            for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
                powerData.colorBox:SetAlpha(0.5)
            end
        end
    end)
    
    clrFx.customPowerColors:HookScript("OnClick", function(self)
        local enabled = self:GetChecked()
        if enabled then
            clrFx.useOnePowerColor:Enable()
            clrFx.useOnePowerColor:SetAlpha(1)
            clrFx.singlePowerColor:SetAlpha(BetterBlizzFramesDB.useOnePowerColor and 1 or 0.5)
            for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
                powerData.colorBox:SetAlpha(BetterBlizzFramesDB.useOnePowerColor and 0.5 or 1)
            end
        else
            clrFx.useOnePowerColor:Disable()
            clrFx.useOnePowerColor:SetAlpha(0.5)
            clrFx.singlePowerColor:SetAlpha(0.5)
            for _, powerData in ipairs(customHealthbarColors.powerColorBoxes) do
                powerData.colorBox:SetAlpha(0.5)
            end
        end
        if BetterBlizzFramesDB.useOnePowerColor and not BetterBlizzFramesDB.changeUnitFrameManabarTexture and BetterBlizzFramesDB.useOnePowerColor and BetterBlizzFramesDB.customPowerColors then
            clrFx.singlePowerColorNote:Show()
        else
            clrFx.singlePowerColorNote:Hide()
        end
        BBF.UpdateFrames()
    end)

    clrFx.backgroundColorsSeparator = clrFx:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    clrFx.backgroundColorsSeparator:SetPoint("TOPLEFT", lastPowerColorRow1 or clrFx.useOnePowerColor, "BOTTOMLEFT", 0, -3)
    clrFx.backgroundColorsSeparator:SetText(L["Background_Colors"])
    clrFx.backgroundColorsSeparator:SetFont(fontLarge, 14)
    clrFx.backgroundColorsSeparator:SetTextColor(1, 1, 1)

    clrFx.addUnitFrameBgTexture = CreateCheckbox("addUnitFrameBgTexture", L["Change_UnitFrame_Background_Color"], clrFx)
    clrFx.addUnitFrameBgTexture:SetPoint("TOPLEFT", clrFx.backgroundColorsSeparator, "BOTTOMLEFT", 0, -1)
    CreateTooltipTwo(clrFx.addUnitFrameBgTexture, L["Change_UnitFrame_Background_Color"], L["Tooltip_Change_UnitFrame_Background_Color_Desc"])

    clrFx.unitFrameBgTextureColor = CreateColorBox(clrFx, "unitFrameBgTextureColor", L["Health_BG"], function() BBF.UnitFrameBackgroundTexture() end)
    clrFx.unitFrameBgTextureColor:SetPoint("TOPLEFT", clrFx.addUnitFrameBgTexture, "BOTTOMLEFT", 16, 5)
    CreateTooltipTwo(clrFx.unitFrameBgTextureColor, L["Health_Bar_Background_Color"], L["Tooltip_Color_Picker_Desc"])

    clrFx.unitFrameBgTextureManaColor = CreateColorBox(clrFx, "unitFrameBgTextureManaColor", L["Mana_BG"], function() BBF.UnitFrameBackgroundTexture() end)
    clrFx.unitFrameBgTextureManaColor:SetPoint("LEFT", clrFx.unitFrameBgTextureColor.text, "RIGHT", 4, 0)
    CreateTooltipTwo(clrFx.unitFrameBgTextureManaColor, L["Mana_Bar_Background_Color"], L["Tooltip_Color_Picker_Desc"])

    clrFx.unitFrameBgTexture = CreateTextureDropdown(
        "unitFrameBgTexture",
        clrFx,
        "Select Texture",
        "unitFrameBgTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
            BBF.UnitFrameBackgroundTexture()
        end,
        { anchorFrame = clrFx.unitFrameBgTextureColor, x = 2, y = 4, label = "Texture" }
    )

    clrFx.changePartyRaidFrameBackgroundColor = CreateCheckbox("changePartyRaidFrameBackgroundColor", L["Change_Party_RaidFrame_Background_Color"], clrFx)
    clrFx.changePartyRaidFrameBackgroundColor:SetPoint("TOPLEFT", clrFx.unitFrameBgTextureColor, "BOTTOMLEFT", -16, pixelsBetweenBoxes-31)
    CreateTooltipTwo(clrFx.changePartyRaidFrameBackgroundColor, L["Change_Party_RaidFrame_Background_Color"], L["Tooltip_Change_Party_RaidFrame_Background_Color_Desc"])

    clrFx.partyRaidFrameBackgroundHealthColor = CreateColorBox(clrFx, "partyRaidFrameBackgroundHealthColor", L["Health_BG"], function() BBF.SetCompactUnitFramesBackground() end)
    clrFx.partyRaidFrameBackgroundHealthColor:SetPoint("TOPLEFT", clrFx.changePartyRaidFrameBackgroundColor, "BOTTOMLEFT", 16, 5)
    CreateTooltipTwo(clrFx.partyRaidFrameBackgroundHealthColor, L["Party_Raid_Health_Bar_Background_Color"], L["Tooltip_Color_Picker_Desc"])

    clrFx.partyRaidFrameBackgroundManaColor = CreateColorBox(clrFx, "partyRaidFrameBackgroundManaColor", L["Mana_BG"], function() BBF.SetCompactUnitFramesBackground() end)
    clrFx.partyRaidFrameBackgroundManaColor:SetPoint("LEFT", clrFx.partyRaidFrameBackgroundHealthColor.text, "RIGHT", 4, 0)
    CreateTooltipTwo(clrFx.partyRaidFrameBackgroundManaColor, L["Party_Raid_Mana_Bar_Background_Color"], L["Tooltip_Color_Picker_Desc"])

    clrFx.raidFrameBgTexture = CreateTextureDropdown(
        "raidFrameBgTexture",
        clrFx,
        "Select Texture",
        "raidFrameBgTexture",
        function(arg1)
            BBF.UpdateCustomTextures()
            BBF.SetCompactUnitFramesBackground()
        end,
        { anchorFrame = clrFx.partyRaidFrameBackgroundHealthColor, x = 2, y = 4, label = "Texture" }
    )

    clrFx.addUnitFrameBgTexture:HookScript("OnClick", function(self)
        if self:GetChecked() then
            clrFx.unitFrameBgTextureColor:SetAlpha(1)
            clrFx.unitFrameBgTextureManaColor:SetAlpha(1)
            clrFx.unitFrameBgTexture:SetEnabled(true)
        else
            clrFx.unitFrameBgTextureColor:SetAlpha(0.5)
            clrFx.unitFrameBgTextureManaColor:SetAlpha(0.5)
            clrFx.unitFrameBgTexture:SetEnabled(false)
        end
        BBF.UnitFrameBackgroundTexture()
        BBF.UpdateCustomTextures()

        if BBF.changeUnitFrameBackgroundColorTexture then
            BBF.changeUnitFrameBackgroundColorTexture:SetChecked(self:GetChecked())
            if BBF.unitFrameBgTextureDropdown then
                BBF.unitFrameBgTextureDropdown:SetEnabled(self:GetChecked())
            end
        end
    end)
    BBF.addUnitFrameBgTexture = clrFx.addUnitFrameBgTexture

    clrFx.changePartyRaidFrameBackgroundColor:HookScript("OnClick", function(self)
        if self:GetChecked() then
            clrFx.partyRaidFrameBackgroundHealthColor:SetAlpha(1)
            clrFx.partyRaidFrameBackgroundManaColor:SetAlpha(1)
            clrFx.raidFrameBgTexture:SetEnabled(true)
        else
            clrFx.partyRaidFrameBackgroundHealthColor:SetAlpha(0.5)
            clrFx.partyRaidFrameBackgroundManaColor:SetAlpha(0.5)
            clrFx.raidFrameBgTexture:SetEnabled(false)
        end
        BBF.SetCompactUnitFramesBackground()
        BBF.UpdateFrames()
        BBF.UpdateCustomTextures()

        if BBF.changePartyRaidFrameBackgroundColorTexture then
            BBF.changePartyRaidFrameBackgroundColorTexture:SetChecked(self:GetChecked())
            if BBF.raidFrameBgTextureDropdown then
                BBF.raidFrameBgTextureDropdown:SetEnabled(self:GetChecked())
            end
        end
    end)
    BBF.changePartyRaidFrameBackgroundColor = clrFx.changePartyRaidFrameBackgroundColor

    clrFx.overrideClassColors:HookScript("OnClick", function(self)
        local enabled = self:GetChecked()
        if enabled then
            clrFx.useOneClassColor:Enable()
            clrFx.useOneClassColor:SetAlpha(1)
            clrFx.singleClassColor:SetAlpha(BetterBlizzFramesDB.useOneClassColor and 1 or 0.5)
            for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
                classData.colorBox:SetAlpha(BetterBlizzFramesDB.useOneClassColor and 0.5 or 1)
            end
        else
            clrFx.useOneClassColor:Disable()
            clrFx.useOneClassColor:SetAlpha(0.5)
            clrFx.singleClassColor:SetAlpha(0.5)
            for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
                classData.colorBox:SetAlpha(0.5)
            end
        end
        BBF.UpdateFrames()
    end)
    
    clrFx.overrideClassColors:HookScript("OnShow", function(self)
        local enabled = BetterBlizzFramesDB.overrideClassColors
        if enabled then
            clrFx.useOneClassColor:Enable()
            clrFx.useOneClassColor:SetAlpha(1)
            clrFx.singleClassColor:SetAlpha(BetterBlizzFramesDB.useOneClassColor and 1 or 0.5)
            for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
                classData.colorBox:SetAlpha(BetterBlizzFramesDB.useOneClassColor and 0.5 or 1)
            end
        else
            clrFx.useOneClassColor:Disable()
            clrFx.useOneClassColor:SetAlpha(0.5)
            clrFx.singleClassColor:SetAlpha(0.5)
            for _, classData in ipairs(customHealthbarColors.classColorBoxes) do
                classData.colorBox:SetAlpha(0.5)
            end
        end
    end)

    local classColorTargetNames = CreateCheckbox("classColorTargetNames", L["Class_Color_Names"], BetterBlizzFrames)
    classColorTargetNames:SetPoint("TOPLEFT", customHealthbarColors, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(classColorTargetNames, L["Class_Color_Names"], L["Tooltip_Class_Color_Names"])

    local classColorLevelText = CreateCheckbox("classColorLevelText", L["Level"], classColorTargetNames)
    classColorLevelText:SetPoint("LEFT", classColorTargetNames.text, "RIGHT", 0, 0)
    CreateTooltip(classColorLevelText, L["Tooltip_Level"])

    classColorTargetNames:HookScript("OnClick", function(self)
        BBF.AllNameChanges()
        if self:GetChecked() then
            classColorLevelText:Enable()
            classColorLevelText:SetAlpha(1)
        else
            classColorLevelText:Disable()
            classColorLevelText:SetAlpha(0)
        end
    end)
    if not BetterBlizzFramesDB.classColorTargetNames then
        classColorLevelText:SetAlpha(0)
    end

    local classColorFrameTexture = CreateCheckbox("classColorFrameTexture", L["Class_Color_FrameTexture"], BetterBlizzFrames)
    classColorFrameTexture:SetPoint("TOPLEFT", classColorTargetNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    classColorFrameTexture:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        else
            BBF.HookFrameTextureColor()
        end
    end)
    CreateTooltipTwo(classColorFrameTexture, L["Class_Color_FrameTexture"], L["Tooltip_Border_Status_Color_Desc"])


    local centerNames = CreateCheckbox("centerNames", L["Center_Name"], BetterBlizzFrames, nil, BBF.SetCenteredNamesCaller)
    centerNames:SetPoint("TOPLEFT", classColorFrameTexture, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(centerNames, L["Center_Names"], L["Tooltip_Center_Name_Desc"])
    centerNames:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local removeRealmNames = CreateCheckbox("removeRealmNames", L["Hide_Realm"], BetterBlizzFrames)
    removeRealmNames:SetPoint("LEFT", centerNames.text, "RIGHT", 0, 0)
    CreateTooltipTwo(removeRealmNames, L["Tooltip_Hide_Realm_Indicator_Desc"], L["Tooltip_Hide_Realm_Desc"])

    local formatStatusBarText = CreateCheckbox("formatStatusBarText", L["Format_Numbers"], BetterBlizzFrames, nil, BBF.HookStatusBarText)
    formatStatusBarText:SetPoint("TOPLEFT", centerNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(formatStatusBarText, L["Format_Numbers"], L["Tooltip_Format_Numbers_Desc"], L["Requires_Reload"])
    formatStatusBarText:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if not BetterBlizzFramesDB.formatStatusBarTextExtraDecimals then
                BetterBlizzFramesDB.formatStatusBarTextExtraDecimals = true
            else
                BetterBlizzFramesDB.formatStatusBarTextExtraDecimals = nil
            end
            if GameTooltip:IsShown() and GameTooltip:GetOwner() == self then
                self:GetScript("OnEnter")(self)
            end
            if formatStatusBarText:GetChecked() then
                BBF.HookStatusBarText()
            end
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local singleValueStatusBarText = CreateCheckbox("singleValueStatusBarText", L["No_Max"], formatStatusBarText)
    singleValueStatusBarText:SetPoint("LEFT", formatStatusBarText.text, "RIGHT", 0, 0)
    CreateTooltipTwo(singleValueStatusBarText, L["No_Max_Value"], "|A:glueannouncementpopup-arrow:20:20|a " .. L["Tooltip_No_Max_Desc"], L["Requires_Reload"])
    singleValueStatusBarText:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    formatStatusBarText:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
        CheckAndToggleCheckboxes(self)
    end)

    local hidePrestigeBadge = CreateCheckbox("hidePrestigeBadge", L["Tooltip_Hide_PvP_Icon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hidePrestigeBadge:SetPoint("TOPLEFT", formatStatusBarText, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hidePrestigeBadge, L["Hide_Prestige_Honor_Badge_PvP_Icon"], L["Tooltip_Hide_Prestige_PvP_Icon_Desc"])

    local hideCombatGlow = CreateCheckbox("hideCombatGlow", L["Hide_Combat_Glow"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideCombatGlow:SetPoint("TOPLEFT", hidePrestigeBadge, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideCombatGlow, L["Tooltip_Hide_Combat_Glow"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-InCombat:30:80|a")

    local hideUnitFrameShadow = CreateCheckbox("hideUnitFrameShadow", L["Hide_Shadow"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideUnitFrameShadow:SetPoint("LEFT", hideCombatGlow.text, "RIGHT", 0, 0)
    CreateTooltipTwo(hideUnitFrameShadow, L["Hide_Shadow"], L["Tooltip_Hide_Shadow_Desc"])
    hideUnitFrameShadow:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        else
            BetterBlizzFramesDB.hideTargetReputationColor = true
            BetterBlizzFramesDB.hideFocusReputationColor = true
            hideTargetReputationColor:SetChecked(true)
            hideFocusReputationColor:SetChecked(true)
            BBF.HideFrames()
        end
    end)

    local hideLevelText = CreateCheckbox("hideLevelText", L["Hide_Max_Level_Text"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideLevelText:SetPoint("TOPLEFT", hideCombatGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideLevelText, L["Tooltip_Hide_Max_Level_Text"])
    hideLevelText:HookScript("OnClick", function()
        if BetterBlizzFramesDB.classicFrames then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local hideLevelTextAlways = CreateCheckbox("hideLevelTextAlways", L["Always"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideLevelTextAlways:SetPoint("LEFT", hideLevelText.Text, "RIGHT", 0, 0)
    CreateTooltip(hideLevelTextAlways, L["Tooltip_Always"])
    hideLevelTextAlways:HookScript("OnClick", function()
        if BetterBlizzFramesDB.classicFrames then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    hideLevelText:HookScript("OnClick", function(self)
        if self:GetChecked() then
            hideLevelTextAlways:Enable()
            hideLevelTextAlways:Show()
        else
            hideLevelTextAlways:Disable()
            hideLevelTextAlways:Hide()
        end
    end)

    if not BetterBlizzFramesDB.hideLevelText then
        hideLevelTextAlways:Hide()
        hideLevelTextAlways:Disable()
    end

    -- local hidePvpIcon = CreateCheckbox("hidePvpIcon", "Hide PvP Icon", BetterBlizzFrames, nil, BBF.HideFrames)
    -- hidePvpIcon:SetPoint("TOPLEFT", hideLevelText, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    -- CreateTooltip(hidePvpIcon, L["Tooltip_Hide_PvP_Icon"])

    local hideRareDragonTexture = CreateCheckbox("hideRareDragonTexture", L["Hide_Dragon"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideRareDragonTexture:SetPoint("TOPLEFT", hideLevelText, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideRareDragonTexture, L["Tooltip_Hide_Dragon"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Boss-Gold:38:28|a")
    hideRareDragonTexture:HookScript("OnClick", function()
        if BetterBlizzFramesDB.classicFrames then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local hideThreatOnFrame = CreateCheckbox("hideThreatOnFrame", L["Hide_Threat"], BetterBlizzFrames, nil, BBF.HideFrames)
    hideThreatOnFrame:SetPoint("LEFT", hideRareDragonTexture.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(hideThreatOnFrame, L["Hide_Threat_Meter"], L["Tooltip_Hide_Threat_Desc"])

    local classPortraitsUseSpecIcons = CreateCheckbox("classPortraitsUseSpecIcons", L["Use_Spec_Icons"], BetterBlizzFrames, nil, BBF.SpecPortraits)
    classPortraitsUseSpecIcons:SetPoint("TOPLEFT", hideRareDragonTexture, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(classPortraitsUseSpecIcons, L["Tooltip_Use_Spec_Icons"])
    classPortraitsUseSpecIcons:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local classPortraitsUseSpecIconsSkipSelf = CreateCheckbox("classPortraitsUseSpecIconsSkipSelf", L["Skip_Self"], BetterBlizzFrames, nil, BBF.SpecPortraits)
    classPortraitsUseSpecIconsSkipSelf:SetPoint("LEFT", classPortraitsUseSpecIcons.Text, "RIGHT", 0, 0)
    CreateTooltipTwo(classPortraitsUseSpecIconsSkipSelf, L["Use_spec_icons_Skip_Self"], L["Tooltip_Skip_Self_Desc"])

    classPortraitsUseSpecIcons:HookScript("OnClick", function(self)
        if self:GetChecked() then
            classPortraitsUseSpecIconsSkipSelf:Enable()
            classPortraitsUseSpecIconsSkipSelf:Show()
        else
            classPortraitsUseSpecIconsSkipSelf:Disable()
            classPortraitsUseSpecIconsSkipSelf:Hide()
        end
    end)

    if not BetterBlizzFramesDB.classPortraitsUseSpecIcons then
        classPortraitsUseSpecIconsSkipSelf:Hide()
        classPortraitsUseSpecIconsSkipSelf:Disable()
    end

    local extraFeaturesText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    extraFeaturesText:SetPoint("TOPLEFT", mainGuiAnchor, "BOTTOMLEFT", 460, 30)
    extraFeaturesText:SetText(L["Extra_Features"])
    extraFeaturesText:SetFont(fontLarge, 16)
    extraFeaturesText:SetTextColor(1,1,1)
    local extraFeaturesIcon = BetterBlizzFrames:CreateTexture(nil, "ARTWORK")
    extraFeaturesIcon:SetAtlas("Campaign-QuestLog-LoreBook")
    extraFeaturesIcon:SetSize(24, 24)
    extraFeaturesIcon:SetPoint("RIGHT", extraFeaturesText, "LEFT", -1, 0)

    local combatIndicator = CreateCheckbox("combatIndicator", L["Combat_Indicator"], BetterBlizzFrames)
    combatIndicator:SetPoint("TOPLEFT", extraFeaturesText, "BOTTOMLEFT", -24, pixelsOnFirstBox)
    combatIndicator:HookScript("OnClick", function()
        BBF.CombatIndicatorCaller()
    end)
    CreateTooltipTwo(combatIndicator, L["Tooltip_Combat_Indicator"], L["Tooltip_Combat_Indicator_Desc"], nil, nil, nil, 1)

    local healerIndicator = CreateCheckbox("healerIndicator", L["Healer_Indicator"], BetterBlizzFrames)
    healerIndicator:SetPoint("TOPLEFT", combatIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    healerIndicator:HookScript("OnClick", function(self)
        BBF.HealerIndicatorCaller()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltipTwo(healerIndicator, L["Tooltip_Healer_Indicator"], L["Tooltip_Healer_Indicator_Desc"])

    local absorbIndicator = CreateCheckbox("absorbIndicator", L["Absorb_Indicator"], BetterBlizzFrames, nil, BBF.AbsorbCaller)
    absorbIndicator:SetPoint("TOPLEFT", healerIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    absorbIndicator:HookScript("OnClick", function()
        BBF.AbsorbCaller()
    end)
    CreateTooltipTwo(absorbIndicator, L["Tooltip_Absorb_Indicator"], L["Tooltip_Absorb_Indicator_Desc"], nil, nil, nil, 1)

    local racialIndicator = CreateCheckbox("racialIndicator", L["Racial_Indicator"], BetterBlizzFrames, nil, BBF.RacialIndicatorCaller)
    racialIndicator:SetPoint("TOPLEFT", absorbIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    racialIndicator:HookScript("OnClick", function()
        BBF.RacialIndicatorCaller()
    end)
    CreateTooltipTwo(racialIndicator, L["Racial_Indicator"], L["Tooltip_Racial_Indicator_Desc"], nil, nil, nil, 1)

    local overShields = CreateCheckbox("overShields", L["Overshields"], BetterBlizzFrames)
    overShields:SetPoint("TOPLEFT", racialIndicator, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(overShields, L["Overshields"], L["Tooltip_Overshields_Desc"], nil, "ANCHOR_LEFT", nil, 2)

    local overShieldsUnitFrames = CreateCheckbox("overShieldsUnitFrames", L["A"], BetterBlizzFrames)
    overShieldsUnitFrames:SetPoint("LEFT", overShields.text, "RIGHT", 0, 0)
    CreateTooltipTwo(overShieldsUnitFrames, L["UnitFrame_Overshields"], L["Tooltip_Overshields_A_Desc"], nil, "ANCHOR_LEFT", nil, 1)
    overShieldsUnitFrames:HookScript("OnClick", function(self)
        BBF.HookOverShields()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local overShieldsCompactUnitFrames = CreateCheckbox("overShieldsCompactUnitFrames", L["B"], BetterBlizzFrames)
    overShieldsCompactUnitFrames:SetPoint("LEFT", overShieldsUnitFrames.text, "RIGHT", 0, 0)
    CreateTooltipTwo(overShieldsCompactUnitFrames, L["Compact_UnitFrames_Overshields"], L["Tooltip_Overshields_B_Desc"], nil, "ANCHOR_LEFT", nil, 2)
    overShieldsCompactUnitFrames:HookScript("OnClick", function(self)
        BBF.HookOverShields()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    overShields:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BetterBlizzFramesDB.overShieldsCompact = true
            BetterBlizzFramesDB.overShieldsUnitFrames = true
            BBF.HookOverShields()
            overShieldsUnitFrames:SetAlpha(1)
            overShieldsUnitFrames:Enable()
            overShieldsUnitFrames:SetChecked(true)
            overShieldsCompactUnitFrames:SetAlpha(1)
            overShieldsCompactUnitFrames:Enable()
            overShieldsCompactUnitFrames:SetChecked(true)
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        else
            BetterBlizzFramesDB.overShieldsCompact = false
            BetterBlizzFramesDB.overShieldsUnitFrames = false
            overShieldsUnitFrames:SetAlpha(0)
            overShieldsUnitFrames:Disable()
            overShieldsUnitFrames:SetChecked(false)
            overShieldsCompactUnitFrames:SetAlpha(0)
            overShieldsCompactUnitFrames:Disable()
            overShieldsCompactUnitFrames:SetChecked(false)
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    if BetterBlizzFramesDB.overShields then
        overShieldsUnitFrames:SetAlpha(1)
        overShieldsUnitFrames:Enable()
        overShieldsCompactUnitFrames:SetAlpha(1)
        overShieldsCompactUnitFrames:Enable()
    else
        overShieldsUnitFrames:SetAlpha(0)
        overShieldsUnitFrames:Disable()
        overShieldsCompactUnitFrames:SetAlpha(0)
        overShieldsCompactUnitFrames:Disable()
    end

    local queueTimer = CreateCheckbox("queueTimer", L["Queue_Timer"], BetterBlizzFrames)
    queueTimer:SetPoint("TOPLEFT", overShields, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(queueTimer, L["Queue_Timer"], L["Tooltip_Queue_Timer_Desc"], nil, "ANCHOR_LEFT")

    local queueTimerAudio = CreateCheckbox("queueTimerAudio", L["SFX"], queueTimer)
    queueTimerAudio:SetPoint("LEFT", queueTimer.text, "RIGHT", 0, 0)
    CreateTooltipTwo(queueTimerAudio, L["Sound_Effect"], L["Tooltip_Queue_Timer_SFX_Desc"], L["Tooltip_Queue_Timer_SFX_Note"], "ANCHOR_LEFT")

    local queueTimerWarning = CreateCheckbox("queueTimerWarning", L["Queue_Timer_Warning"], queueTimer)
    queueTimerWarning:SetPoint("LEFT", queueTimerAudio.text, "RIGHT", 0, 0)
    CreateTooltipTwo(queueTimerWarning, L["Sound_Alert"], L["Tooltip_Queue_Timer_Warning_Desc"], L["Tooltip_Queue_Timer_Warning_Note"], "ANCHOR_LEFT")

    queueTimerAudio:HookScript("OnClick", function(self)
        if self:GetChecked() then
            EnableElement(queueTimerWarning)
        else
            DisableElement(queueTimerWarning)
        end
    end)

    if not BetterBlizzFramesDB.queueTimerAudio then
        DisableElement(queueTimerWarning)
    end

    queueTimer:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
        CheckAndToggleCheckboxes(queueTimer)
        if not BetterBlizzFramesDB.queueTimerAudio then
            DisableElement(queueTimerWarning)
        end
        if self:GetChecked() then
            BBF.SBUncheck()
            if C_AddOns.IsAddOnLoaded("SafeQueue") then
                C_AddOns.DisableAddOn("SafeQueue")
            end
        end
    end)



    local btnGap = -2
    local lastCoreButton = profilesFrame.coreText
    local lastStreamerButton = profilesFrame.streamerText

    for _, profile in ipairs(BBF.ProfileData) do
        local additionalNote = profile.name == "Starter" and "|cff808080(If you want to completely reset BBF there\nis a button in Advanced Settings)|r\n\n" or nil
        local button = CreateClassButton(BetterBlizzFrames, profile.class, profile.name, profile.twitchName, function()
            ShowProfileConfirmation(profile.name, profile.class, function() BBF.ApplyProfile(profile.name) end, additionalNote)
        end)
        if profile.core then
            button:SetPoint("TOP", lastCoreButton, "BOTTOM", 0, lastCoreButton == profilesFrame.coreText and -3 or btnGap)
            lastCoreButton = button
        else
            button:SetPoint("TOP", lastStreamerButton, "BOTTOM", 0, lastStreamerButton == profilesFrame.streamerText and -3 or btnGap)
            lastStreamerButton = button
        end
    end

    local resetBBFButton = CreateFrame("Button", nil, BetterBlizzFrames, "UIPanelButtonTemplate")
    resetBBFButton:SetText(L["Full_Reset"])
    resetBBFButton:SetWidth(100)
    resetBBFButton:SetPoint("BOTTOM", profilesFrame, "BOTTOM", 2, 15)
    resetBBFButton:SetScript("OnClick", function()
        StaticPopup_Show("CONFIRM_RESET_BETTERBLIZZFRAMESDB")
    end)
    CreateTooltip(resetBBFButton, L["Tooltip_Full_Reset"], "ANCHOR_TOP")




    ----------------------
    -- Reload etc
    ----------------------
    local reloadUiButton = CreateFrame("Button", nil, BetterBlizzFrames, "UIPanelButtonTemplate")
    reloadUiButton:SetText(L["Reload_UI"])
    reloadUiButton:SetWidth(96)
    reloadUiButton:SetPoint("RIGHT", SettingsPanel.CloseButton, "LEFT", -3, 0)
    reloadUiButton:SetScript("OnClick", function()
        BetterBlizzFramesDB.reopenOptions = true
        ReloadUI()
    end)

    -- if not SettingsPanel.CloseButton.origPoint then
    --     SettingsPanel.CloseButton.origPoint, SettingsPanel.CloseButton.origRel, SettingsPanel.CloseButton.origAnchor, SettingsPanel.CloseButton.origX, SettingsPanel.CloseButton.origY = SettingsPanel.CloseButton:GetPoint()
    -- end
    -- SettingsPanel.CloseButton:ClearAllPoints()
    -- SettingsPanel.CloseButton:SetPoint("TOPRIGHT", BetterBlizzFrames, "BOTTOMRIGHT", 6, -41)
    -- BetterBlizzFrames:HookScript("OnShow", function()
    --     SettingsPanel.CloseButton:ClearAllPoints()
    --     SettingsPanel.CloseButton:SetPoint("TOPRIGHT", BetterBlizzFrames, "BOTTOMRIGHT", 6, -41)
    -- end)
    -- BetterBlizzFrames:HookScript("OnHide", function()
    --     if BetterBlizzPlates and BetterBlizzPlates:IsShown() then return end
    --     SettingsPanel.CloseButton:ClearAllPoints()
    --     SettingsPanel.CloseButton:SetPoint(SettingsPanel.CloseButton.origPoint, SettingsPanel.CloseButton.origRel, SettingsPanel.CloseButton.origAnchor, SettingsPanel.CloseButton.origX, SettingsPanel.CloseButton.origY)
    -- end)
end


-- Export tab function to BBF
BBF.guiGeneralTab = guiGeneralTab
