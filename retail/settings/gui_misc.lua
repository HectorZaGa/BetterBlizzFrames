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

local function guiMisc()
    local guiMisc = CreateFrame("Frame")
    guiMisc.name = L["Module_Name_Misc"]
    guiMisc.parent = BetterBlizzFrames.name
    --InterfaceOptions_AddCategory(guiMisc)
    local guiMiscSubcategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiMisc, guiMisc.name, guiMisc.name)
    guiMiscSubcategory.ID = guiMisc.name;
    CreateTitle(guiMisc)

    local bgImg = guiMisc:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", guiMisc, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local settingsText = guiMisc:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    settingsText:SetPoint("TOPLEFT", guiMisc, "TOPLEFT", 20, 0)
    settingsText:SetText(L["Misc_Settings"])
    local miscSettingsIcon = guiMisc:CreateTexture(nil, "ARTWORK")
    miscSettingsIcon:SetAtlas("optionsicon-brown")
    miscSettingsIcon:SetSize(22, 22)
    miscSettingsIcon:SetPoint("RIGHT", settingsText, "LEFT", -3, -1)

    local normalizeGameMenu = CreateCheckbox("normalizeGameMenu", L["Normal_Size_Game_Menu"], guiMisc)
    normalizeGameMenu:SetPoint("TOPLEFT", settingsText, "BOTTOMLEFT", -4, pixelsOnFirstBox)
    CreateTooltipTwo(normalizeGameMenu, L["Normal_Size_Game_Menu"], L["Tooltip_Normal_Size"])
    normalizeGameMenu:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BBF.NormalizeGameMenu(true)
        else
            BBF.NormalizeGameMenu(false)
        end
    end)

    local classColorFriendlist = CreateCheckbox("classColorFriendlist", L["Class_Color_Friendlist"], guiMisc)
    classColorFriendlist:SetPoint("TOPLEFT", normalizeGameMenu, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(classColorFriendlist, L["Class_Color_Friendlist"], L["Tooltip_Class_Color_Friendlist_Desc"])
    classColorFriendlist:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local minimizeObjectiveTracker = CreateCheckbox("minimizeObjectiveTracker", L["Minimize_Objective_Better"], guiMisc, nil, BBF.MinimizeObjectiveTracker)
    minimizeObjectiveTracker:SetPoint("TOPLEFT", classColorFriendlist, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(minimizeObjectiveTracker, L["Minimize_Objective_Better"], L["Tooltip_Minimize_Objective"] .. " |A:UI-QuestTrackerButton-Collapse-All:19:19|a")

    local hideUiErrorFrame = CreateCheckbox("hideUiErrorFrame", L["Hide_UI_Error_Frame"], guiMisc, nil, BBF.HideFrames)
    hideUiErrorFrame:SetPoint("TOPLEFT", minimizeObjectiveTracker, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideUiErrorFrame, L["Hide_UI_Error_Frame"], L["Tooltip_Hide_UI_Error"])

    local fadeMicroMenu = CreateCheckbox("fadeMicroMenu", L["Fade_Micro_Menu"], guiMisc, nil, BBF.FadeMicroMenu)
    fadeMicroMenu:SetPoint("TOPLEFT", hideUiErrorFrame, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(fadeMicroMenu, L["Fade_Micro_Menu"], L["Tooltip_Fade_Micro"])

    local fadeMicroMenuExceptQueue = CreateCheckbox("fadeMicroMenuExceptQueue", L["Except_Queue_Eye"], fadeMicroMenu, nil, BBF.FadeMicroMenu)
    fadeMicroMenuExceptQueue:SetPoint("LEFT", fadeMicroMenu.text, "RIGHT", 0, 0)
    CreateTooltipTwo(fadeMicroMenuExceptQueue, L["Except_Queue_Eye"], L["Tooltip_Except_Queue"])

    fadeMicroMenu:HookScript("OnClick", function(self)
        CheckAndToggleCheckboxes(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local moveQueueStatusEye = CreateCheckbox("moveQueueStatusEye", L["Move_Queue_Eye"], guiMisc, nil, BBF.MoveQueueStatusEye)
    moveQueueStatusEye:SetPoint("TOPLEFT", fadeMicroMenu, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(moveQueueStatusEye, L["Move_Queue_Eye"], L["Tooltip_Move_Queue"])

    moveQueueStatusEye:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local reduceEditModeSelectionAlpha = CreateCheckbox("reduceEditModeSelectionAlpha", L["Reduce_Edit_Mode_Glow"], guiMisc)
    reduceEditModeSelectionAlpha:SetPoint("TOPLEFT", moveQueueStatusEye, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(reduceEditModeSelectionAlpha, L["Reduce_Edit_Mode_Glow"], L["Tooltip_Reduce_Glow"])
    reduceEditModeSelectionAlpha:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BetterBlizzFramesDB.editModeSelectionAlpha = 0.15
            BBF.ReduceEditModeAlpha()
            if BBF.EditModeAlphaSlider then
                BBF.EditModeAlphaSlider:SetValue(0.15)
            end
        else
            BetterBlizzFramesDB.editModeSelectionAlpha = 1
            BBF.ReduceEditModeAlpha(true)
            if BBF.EditModeAlphaSlider then
                BBF.EditModeAlphaSlider:SetValue(1)
            end
        end
    end)

    local hideBagsBar = CreateCheckbox("hideBagsBar", L["Hide_Bags_Bar"], guiMisc, nil, BBF.HideFrames)
    hideBagsBar:SetPoint("TOPLEFT", reduceEditModeSelectionAlpha, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideBagsBar, L["Hide_Bags_Bar"], L["Tooltip_Hide_Bags"])

    hideBagsBar:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local showLastNameNpc = CreateCheckbox("showLastNameNpc", L["Tooltip_Only_Last_Name_NPCs_Desc"], guiMisc, nil, BBF.AllNameChanges)
    showLastNameNpc:SetPoint("TOPLEFT", hideBagsBar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(showLastNameNpc, L["Tooltip_Only_Last_Name_NPCs_Desc"], L["Tooltip_Last_Name"])


    local moveableFPSCounter = CreateCheckbox("moveableFPSCounter", L["Moveable_FPS_Counter"], guiMisc, nil, BBF.MoveableFPSCounter)
    moveableFPSCounter:SetPoint("TOPLEFT", showLastNameNpc, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(moveableFPSCounter, L["Moveable_FPS_Counter"], L["Tooltip_FPS_Counter"])
    moveableFPSCounter:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if IsShiftKeyDown() then
                BetterBlizzFramesDB.fpsCounterFontOutline = true
                BBF.MoveableFPSCounter(false, true)
            else
                BetterBlizzFramesDB.fpsCounterFontOutline = nil
                BBF.MoveableFPSCounter(true)
            end
        end
    end)

    local removeAddonListCategories = CreateCheckbox("removeAddonListCategories", L["Improved_AddonList"], guiMisc, nil, BBF.RemoveAddonCategories)
    removeAddonListCategories:SetPoint("TOPLEFT", moveableFPSCounter, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(removeAddonListCategories, L["Improved_AddonList"], L["Tooltip_AddonList"])

    local hideMinimap = CreateCheckbox("hideMinimap", L["Hide_Minimap"], guiMisc, nil, BBF.MinimapHider)
    hideMinimap:SetPoint("TOPLEFT", removeAddonListCategories, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideMinimapButtons = CreateCheckbox("hideMinimapButtons", L["Hide_Minimap_Buttons"], guiMisc, nil, BBF.HideFrames)
    hideMinimapButtons:SetPoint("TOPLEFT", hideMinimap, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    hideMinimapButtons:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local hideMinimapAuto = CreateCheckbox("hideMinimapAuto", L["Hide_Minimap_Arena"], guiMisc)
    hideMinimapAuto:SetPoint("TOPLEFT", hideMinimapButtons, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideMinimapAuto, L["Tooltip_Minimap_Arena"])
    hideMinimapAuto:HookScript("OnClick", function()
        CheckAndToggleCheckboxes(hideMinimapAuto)
        BBF.MinimapHider()
    end)

    local hideMinimapAutoQueueEye = CreateCheckbox("hideMinimapAutoQueueEye", L["Hide_Queue_Eye_Arena"], guiMisc)
    hideMinimapAutoQueueEye:SetPoint("TOPLEFT", hideMinimapAuto, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideMinimapAutoQueueEye, L["Tooltip_Queue_Eye_Arena"])
    hideMinimapAutoQueueEye:HookScript("OnClick", function()
        BBF.MinimapHider()
    end)

    local hideObjectiveTracker = CreateCheckbox("hideObjectiveTracker", L["Hide_Objective_Arena"], guiMisc)
    hideObjectiveTracker:SetPoint("TOPLEFT", hideMinimapAutoQueueEye, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideObjectiveTracker, L["Tooltip_Objective_Arena"])
    hideObjectiveTracker:HookScript("OnClick", function()
        BBF.MinimapHider()
    end)

    local recolorTempHpLoss = CreateCheckbox("recolorTempHpLoss", L["Recolor_Temp_HP"], guiMisc)
    recolorTempHpLoss:SetPoint("TOPLEFT", hideObjectiveTracker, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(recolorTempHpLoss, L["Recolor_Temp_HP"], L["Tooltip_Recolor_HP"])
    recolorTempHpLoss:HookScript("OnClick", function()
        BBF.RecolorHpTempLoss()
    end)

    local hideAllAbsorbGlow = CreateCheckbox("hideAllAbsorbGlow", L["Hide_All_Absorb_Glow"], guiMisc)
    hideAllAbsorbGlow:SetPoint("TOPLEFT", recolorTempHpLoss, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideAllAbsorbGlow, L["Hide_All_Absorb_Glow"], L["Tooltip_Hide_All_Absorb_Glow_Desc"])
    hideAllAbsorbGlow:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local zoomActionBarIcons = CreateCheckbox("zoomActionBarIcons", "Zoom ActionBar Icons", guiMisc)
    zoomActionBarIcons:SetPoint("TOPLEFT", hideAllAbsorbGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(zoomActionBarIcons, "Zoom ActionBar Icons", "Zoom in on the icons on the action bar icons a little.")
    zoomActionBarIcons:HookScript("OnClick", function()
        BBF.ZoomDefaultActionbarIcons(zoomActionBarIcons:GetChecked())
    end)

    local hideActionBarHotKey = CreateCheckbox("hideActionBarHotKey", L["Hide_ActionBar_Keybinds"], guiMisc, nil, BBF.HideFrames)
    hideActionBarHotKey:SetPoint("TOPLEFT", zoomActionBarIcons, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideActionBarHotKey, L["Tooltip_Hide_Keybinds"])

    local hideActionBarMacroName = CreateCheckbox("hideActionBarMacroName", L["Hide_ActionBar_Macro"], guiMisc, nil, BBF.HideFrames)
    hideActionBarMacroName:SetPoint("TOPLEFT", hideActionBarHotKey, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideActionBarMacroName, L["Tooltip_Hide_Macro"])

    local hideActionBarQualityIcon = CreateCheckbox("hideActionBarQualityIcon", L["Hide_ActionBar_Quality"], guiMisc, nil, BBF.HideFrames)
    hideActionBarQualityIcon:SetPoint("TOPLEFT", hideActionBarMacroName, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideActionBarQualityIcon, L["Tooltip_Hide_Quality"])

    local hideStanceBar = CreateCheckbox("hideStanceBar", L["Hide_StanceBar"], guiMisc, nil, BBF.HideFrames)
    hideStanceBar:SetPoint("TOPLEFT", hideActionBarQualityIcon, "BOTTOMLEFT", 0, pixelsBetweenBoxes)

    local hideDragonFlying = CreateCheckbox("hideDragonFlying", L["Auto_Hide_Dragonriding"], guiMisc)
    hideDragonFlying:SetPoint("TOPLEFT", hideStanceBar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(hideDragonFlying, L["Tooltip_Dragonriding"])

    local stealthIndicatorPlayer = CreateCheckbox("stealthIndicatorPlayer", L["Tooltip_Stealth_Indicator"], guiMisc, nil, BBF.StealthIndicator)
    stealthIndicatorPlayer:SetPoint("TOPLEFT", hideDragonFlying, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    stealthIndicatorPlayer:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    CreateTooltip(stealthIndicatorPlayer, L["Tooltip_Stealth"])

    local useMiniPlayerFrame = CreateCheckbox("useMiniPlayerFrame", L["Mini_PlayerFrame"], guiMisc)
    useMiniPlayerFrame:SetPoint("TOPLEFT", stealthIndicatorPlayer, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(useMiniPlayerFrame, L["Tooltip_Mini_Player"])
    useMiniPlayerFrame:HookScript("OnClick", function(self)
        BBF.MiniFrame(PlayerFrame)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local useMiniTargetFrame = CreateCheckbox("useMiniTargetFrame", L["Mini_TargetFrame"], guiMisc)
    useMiniTargetFrame:SetPoint("LEFT", useMiniPlayerFrame.Text, "RIGHT", 0, 0)
    CreateTooltip(useMiniTargetFrame, L["Tooltip_Mini_Target"])
    useMiniTargetFrame:HookScript("OnClick", function(self)
        BBF.MiniFrame(TargetFrame)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local useMiniFocusFrame = CreateCheckbox("useMiniFocusFrame", L["Mini_FocusFrame"], guiMisc)
    useMiniFocusFrame:SetPoint("LEFT", useMiniTargetFrame.Text, "RIGHT", 0, 0)
    CreateTooltip(useMiniFocusFrame, L["Tooltip_Mini_Focus"])
    useMiniFocusFrame:HookScript("OnClick", function(self)
        BBF.MiniFrame(FocusFrame)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local surrenderArena = CreateCheckbox("surrenderArena", L["Surrender_Arena"], guiMisc)
    surrenderArena:SetPoint("TOPLEFT", useMiniPlayerFrame, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(surrenderArena, L["Surrender_Arena"], L["Tooltip_Surrender"])

    local druidOverstacks = CreateCheckbox("druidOverstacks", L["Druid_Berserk_Blue"], guiMisc)
    druidOverstacks:SetPoint("TOPLEFT", surrenderArena, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(druidOverstacks, L["Druid_Berserk_Blue"], L["Tooltip_Druid_Berserk"])
    druidOverstacks:HookScript("OnClick", function(self)
        BBF.DruidBlueComboPoints()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local druidAlwaysShowCombos = CreateCheckbox("druidAlwaysShowCombos", L["Druid_Always_Combos"], guiMisc)
    druidAlwaysShowCombos:SetPoint("TOPLEFT", druidOverstacks, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(druidAlwaysShowCombos, L["Druid_Always_Combos"], L["Tooltip_Druid_Combos"])
    druidAlwaysShowCombos:HookScript("OnClick", function(self)
        BBF.DruidAlwaysShowCombos()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local createAltManaBarDruid = CreateCheckbox("createAltManaBarDruid", L["Druid_Manabar_CatBear"], guiMisc)
    createAltManaBarDruid:SetPoint("TOPLEFT", druidAlwaysShowCombos, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(createAltManaBarDruid, L["Druid_Manabar_CatBear"], L["Tooltip_Druid_Manabar"])
        createAltManaBarDruid:HookScript("OnClick", function(self)
        BBF.CreateAltManaBar()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local hideTalkingHeads = CreateCheckbox("hideTalkingHeads", L["Hide_Talking_Heads"], guiMisc, nil, BBF.HideTalkingHeads)
    hideTalkingHeads:SetPoint("TOPLEFT", createAltManaBarDruid, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideTalkingHeads, L["Hide_Talking_Heads"], L["Tooltip_Talking_Heads"])
    hideTalkingHeads:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local hideExpAndHonorBar = CreateCheckbox("hideExpAndHonorBar", L["Hide_XP_Honor"], guiMisc, nil, BBF.HideFrames)
    hideExpAndHonorBar:SetPoint("TOPLEFT", hideTalkingHeads, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideExpAndHonorBar, L["Hide_XP_Honor"], L["Tooltip_XP_Honor"])
    hideExpAndHonorBar:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local disableCastbarMovement = CreateCheckbox("disableCastbarMovement", L["Disable_Castbar_Movement"], guiMisc, nil, BBF.HideFrames)
    disableCastbarMovement:SetPoint("TOPLEFT", hideExpAndHonorBar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(disableCastbarMovement, L["Disable_Castbar_Movement"], L["Tooltip_Disable_Castbar_Movement_Desc"])
    disableCastbarMovement:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    -- local disableAddonProfiling = CreateCheckbox("disableAddonProfiling", "Disable AddOn Profiler", guiMisc)
    -- disableAddonProfiling:SetPoint("TOPLEFT", hideExpAndHonorBar, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    -- CreateTooltipTwo(disableAddonProfiling, L["Disable_AddOn_Profiler"], L["Tooltip_Disable_AddOn_Profiler"])
    -- disableAddonProfiling:HookScript("OnClick", function(self)
    --     StaticPopup_Show("BBF_CONFIRM_RELOAD")
    -- end)

    local arenaOptimizer = CreateCheckbox("arenaOptimizer", L["Arena_Optimizer"], guiMisc)
    arenaOptimizer:SetPoint("TOPLEFT", disableCastbarMovement, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(arenaOptimizer, L["Arena_Optimizer"], L["Tooltip_Arena_Optimizer"])
    arenaOptimizer:HookScript("OnClick", function(self)
        BBF.ArenaOptimizer(not self:GetChecked(), true)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local gladWinTracker = CreateCheckbox("gladWinTracker", L["Glad_Win_Tracker"], guiMisc)
    gladWinTracker:SetPoint("TOPLEFT", arenaOptimizer, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(gladWinTracker, L["Glad_Win_Tracker"], L["Tooltip_Glad_Tracker"])
    gladWinTracker:HookScript("OnClick", function(self)
        BBF.GladWinTracker()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local uiWidgetPowerBarScale = CreateSlider(guiMisc, L["UIWidgetPowerBarFrame_Scale"], 0.4, 1.8, 0.01, "uiWidgetPowerBarScale")
    uiWidgetPowerBarScale:SetPoint("LEFT", gladWinTracker.text, "RIGHT", 55, 0)
    CreateTooltipTwo(uiWidgetPowerBarScale, L["UIWidgetPowerBarFrame_Scale"], L["Tooltip_UIWidgetPowerBar_Scale_Desc"])

    local hideUnitFramePlayerMana = CreateCheckbox("hideUnitFramePlayerMana", L["Hide_PlayerFrame_Mana"], guiMisc, nil, BBF.UpdateNoPortraitManaVisibility)
    hideUnitFramePlayerMana:SetPoint("TOPLEFT", settingsText, "BOTTOMLEFT", 320, pixelsOnFirstBox)
    CreateTooltipTwo(hideUnitFramePlayerMana, L["Hide_PlayerFrame_Mana"], L["Tooltip_Hide_Player_Mana"])

    local hideUnitFramePlayerSecondResource = CreateCheckbox("hideUnitFramePlayerSecondResource", L["Hide_PlayerFrame_2nd_Bar"], guiMisc, nil, BBF.UpdateNoPortraitManaVisibility)
    hideUnitFramePlayerSecondResource:SetPoint("TOPLEFT", hideUnitFramePlayerMana, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideUnitFramePlayerSecondResource, L["Hide_PlayerFrame_2nd_Bar"], L["Tooltip_Hide_2nd_Bar"])

    local hideUnitFrameTargetMana = CreateCheckbox("hideUnitFrameTargetMana", L["Hide_TargetFrame_Mana"], guiMisc, nil, BBF.UpdateNoPortraitManaVisibility)
    hideUnitFrameTargetMana:SetPoint("TOPLEFT", hideUnitFramePlayerSecondResource, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideUnitFrameTargetMana, L["Hide_TargetFrame_Mana"], L["Tooltip_Hide_Target_Mana"])

    local hideUnitFrameFocusMana = CreateCheckbox("hideUnitFrameFocusMana", L["Hide_FocusFrame_Mana"], guiMisc, nil, BBF.UpdateNoPortraitManaVisibility)
    hideUnitFrameFocusMana:SetPoint("TOPLEFT", hideUnitFrameTargetMana, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideUnitFrameFocusMana, L["Hide_FocusFrame_Mana"], L["Tooltip_Hide_Focus_Mana"])

    local hideDefaultPartyFramesMana = CreateCheckbox("hideDefaultPartyFramesMana", L["Hide_Default_PartyFrames_Mana"], guiMisc, nil, BBF.UpdateNoPortraitManaVisibility)
    hideDefaultPartyFramesMana:SetPoint("TOPLEFT", hideUnitFrameFocusMana, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideDefaultPartyFramesMana, L["Hide_Default_PartyFrames_Mana"], L["Tooltip_Hide_Default_PartyFrames_Mana_Desc"])

    local hideOgRaidFrameBg = CreateCheckbox("hideOgRaidFrameBg", "Hide Party/RaidFrame Background", guiMisc, nil, BBF.HideFrames)
    hideOgRaidFrameBg:SetPoint("TOPLEFT", hideDefaultPartyFramesMana, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideOgRaidFrameBg, "Hide Party/RaidFrame Background", "Hide the background on the default party/raidframes. Combo with Pixel Border.")

    local hideActionBar1 = CreateCheckbox("hideActionBar1", L["Hide_ActionBar1"], guiMisc, nil, BBF.HideFrames)
    hideActionBar1:SetPoint("TOPLEFT", hideOgRaidFrameBg, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideActionBar1, L["Hide_ActionBar1"], L["Tooltip_Hide_ActionBar1"])

    local hideActionBarBigProcGlow = CreateCheckbox("hideActionBarBigProcGlow", L["Hide_ActionBar_Big_Proc_Glow"], guiMisc, nil, BBF.ActionBarMods)
    hideActionBarBigProcGlow:SetPoint("TOPLEFT", hideActionBar1, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideActionBarBigProcGlow, L["Hide_Actionbar_Big_Proc_Glow"], L["Tooltip_Hide_ActionBar_Big_Proc_Glow_Desc"])

    local hideActionBarCastAnimation = CreateCheckbox("hideActionBarCastAnimation", L["Hide_ActionBar_Cast_Animation"], guiMisc, nil, BBF.ActionBarMods)
    hideActionBarCastAnimation:SetPoint("TOPLEFT", hideActionBarBigProcGlow, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideActionBarCastAnimation, L["Hide_ActionBar_Cast_Animation"], L["Tooltip_Hide_ActionBar_Cast_Animation_Desc"])

    local hideActionBarActiveOverlay = CreateCheckbox("hideActionBarActiveOverlay", L["Hide_ActionBar_Active_Overlay"], guiMisc, nil, BBF.HideFrames)
    hideActionBarActiveOverlay:SetPoint("TOPLEFT", hideActionBarCastAnimation, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(hideActionBarActiveOverlay, L["Hide_ActionBar_Active_Overlay"], L["Tooltip_Hide_ActionBar_Active_Overlay"])

    local fixActionBarCDs = CreateCheckbox("fixActionBarCDs", L["Fix_ActionBar_Cooldowns_CC"], guiMisc, nil, BBF.ShowCooldownDuringCC)
    fixActionBarCDs:SetPoint("TOPLEFT", hideActionBarActiveOverlay, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(fixActionBarCDs, L["Fix_ActionBar_Cooldowns_CC"], L["Tooltip_Fix_ActionBar_CDs_Desc"])

    fixActionBarCDs:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local raiseTargetFrameLevel = CreateCheckbox("raiseTargetFrameLevel", L["Raise_TargetFrame_Layer"], guiMisc, nil, BBF.RaiseTargetFrameLevel)
    raiseTargetFrameLevel:SetPoint("TOPLEFT", fixActionBarCDs, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(raiseTargetFrameLevel, L["Raise_TargetFrame_Layer"], L["Tooltip_Raise_TargetFrame_Layer_Desc"])

    local raiseTargetCastbarStrata = CreateCheckbox("raiseTargetCastbarStrata", L["Raise_Castbar_Stratas"], guiMisc, nil, BBF.RaiseTargetCastbarStratas)
    raiseTargetCastbarStrata:SetPoint("TOPLEFT", raiseTargetFrameLevel, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(raiseTargetCastbarStrata, L["Raise_Castbar_Stratas"], L["Tooltip_Raise_Castbar_Stratas_Desc"])

    local enableLegacyComboPoints = CreateCheckbox("enableLegacyComboPoints", L["Legacy_Combo_Points"], guiMisc)
    enableLegacyComboPoints:SetPoint("TOPLEFT", raiseTargetCastbarStrata, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(enableLegacyComboPoints, L["Legacy_Combo_Points"], L["Tooltip_Legacy_Combo_Points_Desc"])
    enableLegacyComboPoints:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
        if not self:GetChecked() then
            BetterBlizzFramesDB.legacyCombosTurnedOff = true
        else
            BetterBlizzFramesDB.legacyCombosTurnedOff = nil
        end
        if not InCombatLockdown() then
            BBF.FixLegacyComboPointsLocation()
        end
        CheckAndToggleCheckboxes(self)
    end)

    function BBF.OpenLegacyComboSliderWindow(launch)
        if not BBF.ComboSliderWindow then
            local f = CreateFrame("Frame", "BBFComboSliderWindow", UIParent, "BasicFrameTemplateWithInset")
            f:SetSize(210, 165)
            f:SetPoint("RIGHT", enableLegacyComboPoints, "LEFT", -10, 0)
            f:SetMovable(true)
            f:EnableMouse(true)
            f:RegisterForDrag("LeftButton")
            f:SetScript("OnDragStart", f.StartMoving)
            f:SetScript("OnDragStop", f.StopMovingOrSizing)
            f:SetFrameStrata("DIALOG")
            f:SetClampedToScreen(true)
            f:SetToplevel(true)

            f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            f.title:SetPoint("TOP", f, "TOP", 0, -6)
            f.title:SetText(L["Legacy_Combo_Position"])

            BBF.ComboSliderWindow = f

            local sizeSlider = CreateSlider(f, L["Size"], 0.6, 1.3, 0.01, "legacyComboScale", nil, 140)
            sizeSlider:SetPoint("TOP", f, "TOP", 0, -45)
            CreateTooltipTwo(sizeSlider, L["Tooltip_Legacy_Combo_Points_Size"])

            local xOffsetSlider = CreateSlider(f, L["X_Offset"], -60, 10, 0.5, "legacyComboXPos", true, 140)
            xOffsetSlider:SetPoint("TOP", sizeSlider, "TOP", 0, -30)
            CreateTooltipTwo(xOffsetSlider, L["Tooltip_Legacy_Combo_Points_X_Offset"])

            local yOffsetSlider = CreateSlider(f, L["Y_Offset"], -60, 10, 0.5, "legacyComboYPos", true, 140)
            yOffsetSlider:SetPoint("TOP", xOffsetSlider, "TOP", 0, -30)
            CreateTooltipTwo(yOffsetSlider, L["Tooltip_FocusToT_Adjustment_Offset_Y"])

            local defaultButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
            defaultButton:SetSize(80, 22)
            defaultButton:SetText(L["Default"])
            defaultButton:SetPoint("BOTTOM", f, "BOTTOM", 0, 10)

            defaultButton:SetScript("OnClick", function()
                BetterBlizzFramesDB.legacyComboXPos = -28
                BetterBlizzFramesDB.legacyComboYPos = -25
                BetterBlizzFramesDB.legacyComboScale = 0.85
                BBF.UpdateLegacyComboPosition()
                sizeSlider:SetValue(0.85)
                xOffsetSlider:SetValue(-28)
                yOffsetSlider:SetValue(-25)
            end)

            f:Hide()
        end

        if launch then
            BBF.ComboSliderWindow:Hide()
            return
        end

        if BBF.ComboSliderWindow:IsShown() then
            BBF.ComboSliderWindow:Hide()
        else
            BBF.ComboSliderWindow:Show()
        end
    end
    BBF.OpenLegacyComboSliderWindow(true)

    enableLegacyComboPoints:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            BBF.OpenLegacyComboSliderWindow()
        end
    end)

    local legacyBlueComboPoints = CreateCheckbox("legacyBlueComboPoints", L["Blue_Combos"], enableLegacyComboPoints)
    legacyBlueComboPoints:SetPoint("LEFT", enableLegacyComboPoints.text, "RIGHT", 0, 0)
    legacyBlueComboPoints:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    CreateTooltipTwo(legacyBlueComboPoints, L["Blue_Legacy_Combo_Points"], L["Tooltip_Blue_Legacy_Combo_Points_Desc"])

    local alwaysShowLegacyComboPoints = CreateCheckbox("alwaysShowLegacyComboPoints", L["Show_Always"], enableLegacyComboPoints)
    alwaysShowLegacyComboPoints:SetPoint("LEFT", legacyBlueComboPoints.text, "RIGHT", 0, 0)
    alwaysShowLegacyComboPoints:HookScript("OnClick", function()
        BBF.AlwaysShowLegacyComboPoints()
    end)
    CreateTooltipTwo(alwaysShowLegacyComboPoints, L["Show_Always"], L["Tooltip_Always_Show_Legacy_Combo_Desc"])

    local enableLegacyComboPointsMulticlass = CreateCheckbox("enableLegacyComboPointsMulticlass", L["Tooltip_Legacy_Combo_Points_More_Classes_Desc"], enableLegacyComboPoints)
    enableLegacyComboPointsMulticlass:SetPoint("TOPLEFT", enableLegacyComboPoints, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(enableLegacyComboPointsMulticlass, L["Tooltip_Legacy_Combo_Points_More_Classes_Desc"], L["Tooltip_Legacy_Combo_Multiclass_Desc"])
    enableLegacyComboPointsMulticlass:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
        BBF.GenericLegacyComboSupport()
    end)

    local legacyMulticlassComboClassColor = CreateCheckbox("legacyMulticlassComboClassColor", L["Class_Color_Combo"], enableLegacyComboPointsMulticlass)
    legacyMulticlassComboClassColor:SetPoint("LEFT", enableLegacyComboPointsMulticlass.text, "RIGHT", 0, 0)
    legacyMulticlassComboClassColor:HookScript("OnClick", function()
        BBF.ClassColorLegacyCombos()
    end)
    CreateTooltipTwo(legacyMulticlassComboClassColor, L["Class_Color_Legacy_Combos"], L["Tooltip_Class_Color_Legacy_Combos_Desc"])


    local instantComboPoints = CreateCheckbox("instantComboPoints", L["Instant_Combo_Points"], guiMisc, nil, BBF.InstantComboPoints)
    instantComboPoints:SetPoint("TOPLEFT", enableLegacyComboPointsMulticlass, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(instantComboPoints, L["Instant_Combo_Points"], L["Tooltip_Instant_Combo_Points_Desc"])
    instantComboPoints:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
            if BetterBlizzPlatesDB then
                BetterBlizzPlatesDB.instantComboPoints = false
            end
        end
    end)

    local moveResource = CreateCheckbox("moveResource", L["Move_Resource"], guiMisc)
    moveResource:SetPoint("TOPLEFT", instantComboPoints, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(moveResource, L["Move_Resource"], string.format(L["Tooltip_Move_Resource_Desc"], playerClass), L["Tooltip_Move_Resource_SubText"])
    moveResource:HookScript("OnClick", function(self)
        if self:GetChecked() then
            BBF.EnableResourceMovement()
        end
    end)
    if BetterBlizzFramesDB.moveResourceStackPos and not BetterBlizzFramesDB.moveResourceStackPos[playerClass] then
        moveResource:SetChecked(false)
    elseif not BetterBlizzFramesDB.moveResourceStackPos then
        moveResource:SetChecked(false)
    end

    local moveResourceToTarget = CreateCheckbox("moveResourceToTarget", L["Move_Resource_To_TargetFrame"], guiMisc)
    moveResourceToTarget:SetPoint("TOPLEFT", moveResource, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTarget, L["Tooltip_Move_Resource_To_Target"])

    local moveResourceToTargetCustom = CreateCheckbox("moveResourceToTargetCustom", L["Free_Move"], moveResourceToTarget)
    moveResourceToTargetCustom:SetPoint("LEFT", moveResourceToTarget.text, "RIGHT", 0, 0)
    moveResourceToTargetCustom:HookScript("OnClick", function(self)
        if self:GetChecked() then
            if BBF.ToggleEditMode then
                BBF.ToggleEditMode(true)
            end
            BBF.UpdateClassComboPoints()
        else
            if BBF.ToggleEditMode then
                BBF.ToggleEditMode(false)
            end
            BBF.UpdateClassComboPoints()
        end
    end)
    CreateTooltipTwo(moveResourceToTargetCustom, L["Free_Move_Resource_Tooltip"], L["Tooltip_Free_Move_Resource_Desc"] .. playerClass, L["Tooltip_Free_Move_Resource_SubText"])

    local moveResourceToTargetRogue = CreateCheckbox("moveResourceToTargetRogue", L["Rogue_Combo_Points"], moveResourceToTarget)
    moveResourceToTargetRogue:SetPoint("TOPLEFT", moveResourceToTarget, "BOTTOMLEFT", 12, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTargetRogue, L["Tooltip_Move_Resource_Rogue"])
    moveResourceToTargetRogue:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local moveResourceToTargetDruid = CreateCheckbox("moveResourceToTargetDruid", L["Druid_Combo_Points"], moveResourceToTarget)
    moveResourceToTargetDruid:SetPoint("TOPLEFT", moveResourceToTargetRogue, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTargetDruid, L["Tooltip_Move_Resource_Druid"])
    moveResourceToTargetDruid:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local moveResourceToTargetMonk = CreateCheckbox("moveResourceToTargetMonk", L["Monk_Chi_Points"], moveResourceToTarget)
    moveResourceToTargetMonk:SetPoint("TOPLEFT", moveResourceToTargetDruid, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTargetMonk, L["Tooltip_Move_Resource_Monk"])
    moveResourceToTargetMonk:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local moveResourceToTargetWarlock = CreateCheckbox("moveResourceToTargetWarlock", L["Warlock_Shards"], moveResourceToTarget)
    moveResourceToTargetWarlock:SetPoint("TOPLEFT", moveResourceToTargetMonk, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTargetWarlock, L["Tooltip_Move_Resource_Warlock"])
    moveResourceToTargetWarlock:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local moveResourceToTargetEvoker = CreateCheckbox("moveResourceToTargetEvoker", L["Evoker_Essence"], moveResourceToTarget)
    moveResourceToTargetEvoker:SetPoint("TOPLEFT", moveResourceToTargetWarlock, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTargetEvoker, L["Tooltip_Move_Resource_Evoker"])
    moveResourceToTargetEvoker:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local moveResourceToTargetMage = CreateCheckbox("moveResourceToTargetMage", L["Mage_Arcane_Charges"], moveResourceToTarget)
    moveResourceToTargetMage:SetPoint("TOPLEFT", moveResourceToTargetEvoker, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTargetMage, L["Tooltip_Move_Resource_Mage"])
    moveResourceToTargetMage:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local moveResourceToTargetDK = CreateCheckbox("moveResourceToTargetDK", L["Death_Knight_Runes"], moveResourceToTarget)
    moveResourceToTargetDK:SetPoint("TOPLEFT", moveResourceToTargetMage, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTargetDK, L["Tooltip_Move_Resource_DK"])
    moveResourceToTargetDK:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local moveResourceToTargetPaladin = CreateCheckbox("moveResourceToTargetPaladin", L["Paladin_Holy_Charges"], moveResourceToTarget)
    moveResourceToTargetPaladin:SetPoint("TOPLEFT", moveResourceToTargetDK, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltip(moveResourceToTargetPaladin, L["Tooltip_Move_Resource_Paladin"])
    moveResourceToTargetPaladin:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local moveResourceToTargetPaladinBG = CreateCheckbox("moveResourceToTargetPaladinBG", L["BG"], moveResourceToTargetPaladin)
    moveResourceToTargetPaladinBG:SetPoint("LEFT", moveResourceToTargetPaladin.text, "RIGHT", 0, 0)
    CreateTooltipTwo(moveResourceToTargetPaladinBG, L["Background"], L["Tooltip_Resource_Background_Desc"])

    moveResourceToTargetPaladinBG:HookScript("OnClick", function(self)
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    moveResourceToTargetPaladin:HookScript("OnClick", function(self)
        CheckAndToggleCheckboxes(self)
    end)

    local key = "classResource" .. playerClass .. "Scale"
    local classResourceScale = CreateSlider(guiMisc, L["Class_Resource_Scale"], 0.4, 2, 0.01, key)
    classResourceScale:SetPoint("TOPLEFT", moveResourceToTargetPaladin, "BOTTOMLEFT", 5, -15)
    CreateTooltipTwo(classResourceScale, L["Class_Resource_Scale"], L["Tooltip_Class_Resource_Scale_Desc"], L["Tooltip_Class_Resource_Scale_Extra"])

    moveResource:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if BetterBlizzFramesDB.moveResourceStackPos then
                BetterBlizzFramesDB.moveResourceStackPos[playerClass] = nil
            end
            classResourceScale:SetValue(1)
            BBF.Print(string.format(L["Print_Combo_Points_Reset"], playerClass))
            BBF.ResetResourcePosition()
        end
    end)

    moveResourceToTargetCustom:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if BetterBlizzFramesDB.customComboPositions then
                BetterBlizzFramesDB.customComboPositions[playerClass] = nil
            end
            classResourceScale:SetValue(1)
            BBF.Print(string.format(L["Print_Combo_Points_Reset"], playerClass))
            BBF.UpdateClassComboPoints()
        end
    end)

    moveResourceToTarget:HookScript("OnClick", function(self)
        if self:GetChecked() then
            classResourceScale:SetValue(1)
        end
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
        CheckAndToggleCheckboxes(moveResourceToTarget)
    end)



    local rpNames = CreateCheckbox("rpNames", L["Roleplay_Names_TRP3"], guiMisc)
    rpNames:SetPoint("BOTTOMRIGHT", guiMisc, "BOTTOMRIGHT", -220, 50)
    CreateTooltipTwo(rpNames, L["Roleplay_Names_Tooltip"], L["Tooltip_Roleplay_Names_Desc"])

    local rpNamesFirst = CreateCheckbox("rpNamesFirst", L["First"], rpNames)
    rpNamesFirst:SetPoint("LEFT", rpNames.text, "RIGHT", 0, 0)
    CreateTooltipTwo(rpNamesFirst, L["First_Name_TRP3"], L["Tooltip_RP_First_Name_Desc"])

    local rpNamesLast = CreateCheckbox("rpNamesLast", L["Last"], rpNames)
    rpNamesLast:SetPoint("LEFT", rpNamesFirst.text, "RIGHT", 0, 0)
    CreateTooltipTwo(rpNamesLast, L["Last_Name_TRP3"], L["Tooltip_RP_Last_Name_Desc"])

    local rpNamesColor = CreateCheckbox("rpNamesColor", L["RP_Name_Text_Color"], guiMisc)
    rpNamesColor:SetPoint("TOPLEFT", rpNames, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(rpNamesColor, L["Roleplay_Name_Text_Color"], L["Tooltip_RP_Name_Color_Desc"])

    rpNames:HookScript("OnClick", function(self)
        CheckAndToggleCheckboxes(self)
        BBF.AllNameChanges()
    end)

    rpNamesFirst:HookScript("OnClick", function(self)
        BBF.AllNameChanges()
    end)

    rpNamesLast:HookScript("OnClick", function(self)
        BBF.AllNameChanges()
    end)

    rpNamesColor:HookScript("OnClick", function(self)
        BBF.AllNameChanges()
    end)

    local rpNamesHealthbarColor = CreateCheckbox("rpNamesHealthbarColor", L["RP_Healthbar_Color"], guiMisc)
    rpNamesHealthbarColor:SetPoint("TOPLEFT", rpNamesColor, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(rpNamesHealthbarColor, L["Roleplay_Healthbar_Color"], L["Tooltip_RP_Healthbar_Color_Desc"])

    rpNamesHealthbarColor:HookScript("OnClick", function(self)
        BBF.HookHealthbarColors()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local rpNamesFrameTextureColor = CreateCheckbox("rpNamesFrameTextureColor", L["RP_FrameTexture_Color"], guiMisc)
    rpNamesFrameTextureColor:SetPoint("TOPLEFT", rpNamesHealthbarColor, "BOTTOMLEFT", 0, pixelsBetweenBoxes)
    CreateTooltipTwo(rpNamesFrameTextureColor, L["Roleplay_FrameTexture_Color"], L["Tooltip_RP_FrameTexture_Color_Desc"])

    rpNamesFrameTextureColor:HookScript("OnClick", function(self)
        BBF.HookFrameTextureColor()
        if not self:GetChecked() then
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

end


-- Export tab function to BBF
BBF.guiMisc = guiMisc
