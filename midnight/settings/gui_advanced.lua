if not BBF.isMidnight then return end
local L = BBF.L

local fontSmall = BBF.fontSmall
local fontMedium = BBF.fontMedium
local fontLarge = BBF.fontLarge
local anchorPoints = BBF.anchorPoints
local anchorPoints2 = BBF.anchorPoints2
local pixelsBetweenBoxes = BBF.pixelsBetweenBoxes
local pixelsOnFirstBox = BBF.pixelsOnFirstBox

local LibDD = BBF.LibDD
local LSM = BBF.LSM
local CreateCheckbox = BBF.CreateCheckbox
local CreateSlider = BBF.CreateSlider
local CreateTitle = BBF.CreateTitle
local CreateTooltip = BBF.CreateTooltip
local CreateTooltipTwo = BBF.CreateTooltipTwo
local CreateAnchorDropdown = BBF.CreateAnchorDropdown
local CreateBorderedFrame = BBF.CreateBorderedFrame
local CreateColorBox = BBF.CreateColorBox
local CreateFontDropdown = BBF.CreateFontDropdown

function guiPositionAndScale()

    ----------------------
    -- Advanced Settings Panel Setup
    ----------------------
    local BetterBlizzFramesSubPanel = CreateFrame("Frame")
    BetterBlizzFramesSubPanel.name = L["Module_Name_Advanced"]
    BetterBlizzFramesSubPanel.parent = BetterBlizzFrames.name
    local advancedSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, BetterBlizzFramesSubPanel, BetterBlizzFramesSubPanel.name, BetterBlizzFramesSubPanel.name)
    advancedSubCategory.ID = BetterBlizzFramesSubPanel.name
    BBF.category.AdvancedSettings = BetterBlizzFramesSubPanel.name
    CreateTitle(BetterBlizzFramesSubPanel)

    local bgImg = BetterBlizzFramesSubPanel:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", BetterBlizzFramesSubPanel, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    -------------------------------------------------------
    -- SIDEBAR NAVIGATION & CARD CONTAINER DESIGN
    -------------------------------------------------------
    local sidebar = CreateFrame("Frame", nil, BetterBlizzFramesSubPanel)
    sidebar:SetSize(165, 545)
    sidebar:SetPoint("TOPLEFT", BetterBlizzFramesSubPanel, "TOPLEFT", 12, -45)

    local contentParent = CreateFrame("Frame", nil, BetterBlizzFramesSubPanel)
    contentParent:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 10, 0)
    contentParent:SetPoint("BOTTOMRIGHT", BetterBlizzFramesSubPanel, "BOTTOMRIGHT", -38, 15)

    local categoryList = {
        { id = "absorb",    label = L["Absorb_Indicator"],  atlas = "ParagonReputation_Glow", size = {22, 22} },
        { id = "combat",    label = L["Combat_Indicator"],  icon = "Interface\\Icons\\ABILITY_DUALWIELD", size = {20, 20} },
        { id = "healer",    label = L["Healer_Indicator"],  atlas = "bags-icon-addslots", size = {20, 20} },
        { id = "racial",    label = L["Racial_Indicator"],  icon = "Interface\\Icons\\ability_ambush", size = {20, 20} },
        { id = "interrupt", label = L["Interrupt_Icon_AS"], icon = "Interface\\Icons\\ability_kick", size = {20, 20} },
        { id = "kick",      label = L["Kick_Popup"],        icon = "Interface\\Icons\\ability_kick", size = {20, 20} },
    }

    local categoryFrames = {}
    local categoryButtons = {}

    local function SelectCategory(catId)
        for id, sf in pairs(categoryFrames) do sf:Hide() end
        for id, btn in pairs(categoryButtons) do
            btn:SetBackdropBorderColor(0.25, 0.25, 0.28, 0.8)
            btn:SetBackdropColor(0.1, 0.1, 0.12, 0.85)
            btn.Text:SetTextColor(0.8, 0.8, 0.8)
        end
        if categoryFrames[catId] then categoryFrames[catId]:Show() end
        if categoryButtons[catId] then
            categoryButtons[catId]:SetBackdropBorderColor(0.9, 0.75, 0.1, 1)
            categoryButtons[catId]:SetBackdropColor(0.25, 0.2, 0.05, 0.9)
            categoryButtons[catId].Text:SetTextColor(1, 0.85, 0.1)
        end
    end

    for i, cat in ipairs(categoryList) do
        local sf = CreateFrame("ScrollFrame", "BBF_MidnightAdvCat_" .. cat.id, contentParent, "ScrollFrameTemplate")
        sf:SetAllPoints(contentParent)
        sf:Hide()

        local cf = CreateFrame("Frame", nil, sf)
        cf:SetSize(435, 520)
        sf:SetScrollChild(cf)

        categoryFrames[cat.id] = sf
        sf.contentFrame = cf

        local btn = CreateFrame("Button", nil, sidebar, "BackdropTemplate")
        btn:SetSize(160, 34)
        btn:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 0, -((i - 1) * 38))
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        btn:SetBackdropColor(0.1, 0.1, 0.12, 0.85)
        btn:SetBackdropBorderColor(0.25, 0.25, 0.28, 0.8)

        local iconFrame = CreateFrame("Frame", nil, btn)
        iconFrame:SetSize(26, 26)
        iconFrame:SetPoint("LEFT", btn, "LEFT", 4, 0)

        local iconTex = iconFrame:CreateTexture(nil, "ARTWORK")
        local w, h = unpack(cat.size or {20, 20})
        iconTex:SetSize(w, h)
        iconTex:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)

        if cat.atlas then
            iconTex:SetAtlas(cat.atlas)
        elseif cat.icon then
            iconTex:SetTexture(cat.icon)
        end

        btn.Text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        btn.Text:SetPoint("LEFT", iconFrame, "RIGHT", 4, 0)
        btn.Text:SetText(cat.label)
        btn.Text:SetTextColor(0.8, 0.8, 0.8)

        btn:SetScript("OnClick", function() SelectCategory(cat.id) end)
        btn:SetScript("OnEnter", function(self)
            if categoryButtons[cat.id] and self ~= categoryButtons[cat.id] then
                self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
            end
        end)
        btn:SetScript("OnLeave", function(self)
            if categoryButtons[cat.id] and self ~= categoryButtons[cat.id] then
                self:SetBackdropBorderColor(0.25, 0.25, 0.28, 0.8)
            end
        end)

        categoryButtons[cat.id] = btn
    end

    -------------------------------------------------------
    -- CARD HELPERS WITH TOOLTIPS & EXPANDED SPACING
    -------------------------------------------------------
    local function CreateOptionCard(parentFrame, titleText, anchorFrame, yOffset, cardWidth)
        cardWidth = cardWidth or 430
        
        local header = parentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        if anchorFrame then
            header:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, yOffset or -22)
        else
            header:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 2, yOffset or -10)
        end
        header:SetText(titleText)
        header:SetTextColor(1, 0.82, 0)

        local card = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")
        card:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -6)
        card:SetWidth(cardWidth)
        card:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        card:SetBackdropColor(0.06, 0.06, 0.08, 0.85)
        card:SetBackdropBorderColor(0.2, 0.2, 0.25, 0.8)

        card.header = header
        card.currentY = -10
        card.cardWidth = cardWidth
        return card
    end

    local function FinalizeCardLayout(parentFrame, lastCard)
        if lastCard then
            local top = lastCard.header and lastCard.header:GetTop()
            local bottom = lastCard:GetBottom()
            if top and bottom then
                local totalH = math.abs(top - bottom) + 30
                parentFrame:SetHeight(math.max(totalH, 520))
            else
                local cardH = lastCard:GetHeight() or 300
                parentFrame:SetHeight(math.max(520, cardH + 200))
            end
        end
    end

    local function AddCardCheckbox(card, dbKey, titleStr, descStr, callback, cpuUsage, subText)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 6, card.currentY)
        local rowHeight = 34
        row:SetSize(card.cardWidth - 12, rowHeight)

        local rowHighlight = row:CreateTexture(nil, "BACKGROUND")
        rowHighlight:SetAllPoints()
        rowHighlight:SetAtlas("options-item-highlight")
        if not rowHighlight:GetTexture() then
            rowHighlight:SetColorTexture(1, 1, 1, 0.12)
        end
        rowHighlight:SetBlendMode("ADD")
        rowHighlight:Hide()

        local function UpdateHighlight()
            if MouseIsOver(row) then rowHighlight:Show() else rowHighlight:Hide() end
        end

        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("LEFT", row, "LEFT", 16, 0)
        title:SetText(titleStr)
        title:SetWidth(330)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 330), rowHeight)

        local cb = CreateCheckbox(dbKey, "", row, nil, callback)
        cb:SetSize(28, 28)
        cb:SetPoint("RIGHT", row, "RIGHT", -5, 0)

        titleFrame:EnableMouse(true)
        titleFrame:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                if cb:IsEnabled() then cb:Click("LeftButton") end
            elseif button == "RightButton" then
                if BBF.HandleRightClick then BBF.HandleRightClick(dbKey, titleStr, titleFrame) end
            end
        end)

        if descStr and descStr ~= "" then
            CreateTooltipTwo(titleFrame, titleStr, descStr, subText, nil, nil, cpuUsage)
            CreateTooltipTwo(cb, titleStr, descStr, subText, nil, nil, cpuUsage)
        end

        titleFrame:HookScript("OnEnter", UpdateHighlight)
        titleFrame:HookScript("OnLeave", UpdateHighlight)
        cb:HookScript("OnEnter", UpdateHighlight)
        cb:HookScript("OnLeave", UpdateHighlight)

        card.currentY = card.currentY - rowHeight - 8
        card:SetHeight(-card.currentY + 6)
        return cb
    end

    local function AddCardChildCheckbox(card, parentCb, dbKey, titleStr, descStr, callback)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 22, card.currentY)
        local rowHeight = 34
        row:SetSize(card.cardWidth - 28, rowHeight)

        local rowHighlight = row:CreateTexture(nil, "BACKGROUND")
        rowHighlight:SetAllPoints()
        rowHighlight:SetAtlas("options-item-highlight")
        if not rowHighlight:GetTexture() then
            rowHighlight:SetColorTexture(1, 1, 1, 0.12)
        end
        rowHighlight:SetBlendMode("ADD")
        rowHighlight:Hide()

        local function UpdateHighlight()
            if MouseIsOver(row) then rowHighlight:Show() else rowHighlight:Hide() end
        end
        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("LEFT", row, "LEFT", 16, 0)
        title:SetText(titleStr)
        title:SetWidth(310)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 310), rowHeight)

        local cb = CreateCheckbox(dbKey, "", row, nil, callback)
        cb:SetSize(28, 28)
        cb:SetPoint("RIGHT", row, "RIGHT", -5, 0)

        titleFrame:EnableMouse(true)
        titleFrame:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                if cb:IsEnabled() then cb:Click("LeftButton") end
            elseif button == "RightButton" then
                if BBF.HandleRightClick then BBF.HandleRightClick(dbKey, titleStr, titleFrame) end
            end
        end)

        if descStr and descStr ~= "" then
            CreateTooltipTwo(titleFrame, titleStr, descStr)
            CreateTooltipTwo(cb, titleStr, descStr)
        end

        local function UpdateChildState()
            if parentCb and parentCb:GetChecked() then
                cb:Enable()
                cb:SetAlpha(1)
                title:SetAlpha(1)
            else
                cb:Disable()
                cb:SetAlpha(0.4)
                title:SetAlpha(0.4)
            end
        end

        if parentCb then
            parentCb:HookScript("OnClick", UpdateChildState)
            UpdateChildState()
        end

        titleFrame:HookScript("OnEnter", UpdateHighlight)
        titleFrame:HookScript("OnLeave", UpdateHighlight)
        cb:HookScript("OnEnter", UpdateHighlight)
        cb:HookScript("OnLeave", UpdateHighlight)

        card.currentY = card.currentY - rowHeight - 8
        card:SetHeight(-card.currentY + 6)
        return cb
    end

    local function AddCardSlider(card, dbKey, titleStr, descStr, minVal, maxVal, stepVal, callback)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 6, card.currentY)
        local rowHeight = 40
        row:SetSize(card.cardWidth - 12, rowHeight)

        local rowHighlight = row:CreateTexture(nil, "BACKGROUND")
        rowHighlight:SetAllPoints()
        rowHighlight:SetAtlas("options-item-highlight")
        if not rowHighlight:GetTexture() then
            rowHighlight:SetColorTexture(1, 1, 1, 0.12)
        end
        rowHighlight:SetBlendMode("ADD")
        rowHighlight:Hide()

        local function UpdateHighlight()
            if MouseIsOver(row) then rowHighlight:Show() else rowHighlight:Hide() end
        end
        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("LEFT", row, "LEFT", 16, 0)
        title:SetText(titleStr)
        title:SetWidth(240)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 240), rowHeight)

        local slider = CreateSlider(row, "", minVal, maxVal, stepVal, dbKey, nil, 120)
        slider:SetPoint("RIGHT", row, "RIGHT", -20, 0)

        titleFrame:EnableMouse(true)
        titleFrame:SetScript("OnMouseDown", function(self, button)
            if button == "RightButton" then
                if BBF.HandleRightClick then
                    BBF.HandleRightClick(dbKey, titleStr, titleFrame)
                end
            end
        end)

        if descStr and descStr ~= "" then
            CreateTooltipTwo(titleFrame, titleStr, descStr)
            CreateTooltipTwo(slider, titleStr, descStr)
        end

        if callback then
            slider:HookScript("OnValueChanged", function() callback() end)
        end

        titleFrame:HookScript("OnEnter", UpdateHighlight)
        titleFrame:HookScript("OnLeave", UpdateHighlight)
        slider:HookScript("OnEnter", UpdateHighlight)
        slider:HookScript("OnLeave", UpdateHighlight)

        card.currentY = card.currentY - rowHeight - 8
        card:SetHeight(-card.currentY + 6)
        return slider
    end

    local function AddCardAnchorDropdown(card, dbKey, titleStr, anchorSettingKey, callback)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 6, card.currentY)
        local rowHeight = 36
        row:SetSize(card.cardWidth - 12, rowHeight)

        local rowHighlight = row:CreateTexture(nil, "BACKGROUND")
        rowHighlight:SetAllPoints()
        rowHighlight:SetAtlas("options-item-highlight")
        if not rowHighlight:GetTexture() then
            rowHighlight:SetColorTexture(1, 1, 1, 0.12)
        end
        rowHighlight:SetBlendMode("ADD")
        rowHighlight:Hide()

        local function UpdateHighlight()
            if MouseIsOver(row) then rowHighlight:Show() else rowHighlight:Hide() end
        end
        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("LEFT", row, "LEFT", 16, 0)
        title:SetText(titleStr)
        title:SetWidth(200)
        title:SetJustifyH("LEFT")

        local dropdown = CreateAnchorDropdown(
            dbKey,
            row,
            L["Select_Anchor_Point"],
            anchorSettingKey,
            function(arg1) if callback then callback(arg1) end end,
            { anchorFrame = row, x = card.cardWidth - 170, y = 8, label = "" }
        )
        dropdown:ClearAllPoints()
        dropdown:SetPoint("RIGHT", row, "RIGHT", -10, 0)
        dropdown:SetWidth(150)

        dropdown:HookScript("OnEnter", UpdateHighlight)
        dropdown:HookScript("OnLeave", UpdateHighlight)

        card.currentY = card.currentY - rowHeight - 8
        card:SetHeight(-card.currentY + 6)
        return dropdown
    end


    -------------------------------------------------------
    -- CATEGORY 1: Absorb Indicator
    -------------------------------------------------------
    local cfAbsorb = categoryFrames["absorb"].contentFrame

    local cardAbsorbPos = CreateOptionCard(cfAbsorb, L["Absorb_Indicator"], nil, -10)
    AddCardAnchorDropdown(cardAbsorbPos, "playerAbsorbAnchorDropdown", L["Anchor"], "playerAbsorbAnchor", BBF.AbsorbCaller)
    AddCardSlider(cardAbsorbPos, "absorbIndicatorScale", L["Size"], L["Tooltip_Absorb_Indicator"], 0.1, 1.9, 0.01)
    AddCardSlider(cardAbsorbPos, "playerAbsorbXPos", L["X_Offset"], "", -100, 100, 1)
    AddCardSlider(cardAbsorbPos, "playerAbsorbYPos", L["Y_Offset"], "", -100, 100, 1)
    AddCardCheckbox(cardAbsorbPos, "absorbIndicatorTestMode", L["Test"], "", BBF.AbsorbCaller)
    AddCardCheckbox(cardAbsorbPos, "absorbIndicatorFlipIconText", L["Flip_Icon_Text"], "", BBF.AbsorbCaller)

    local cardAbsorbTargets = CreateOptionCard(cfAbsorb, L["Display_Text"], cardAbsorbPos, -22)
    local cbPlayerAbs = AddCardCheckbox(cardAbsorbTargets, "playerAbsorbAmount", L["Player"], L["Tooltip_Absorb_Show_Player"], BBF.AbsorbCaller)
    AddCardChildCheckbox(cardAbsorbTargets, cbPlayerAbs, "playerAbsorbIcon", L["Icon"], L["Tooltip_Absorb_Icon"], BBF.AbsorbCaller)
    
    local cbTargetAbs = AddCardCheckbox(cardAbsorbTargets, "targetAbsorbAmount", L["Target"], L["Tooltip_Absorb_Show_Target"], BBF.AbsorbCaller)
    AddCardChildCheckbox(cardAbsorbTargets, cbTargetAbs, "targetAbsorbIcon", L["Icon"], L["Tooltip_Absorb_Icon"], BBF.AbsorbCaller)

    local cbFocusAbs = AddCardCheckbox(cardAbsorbTargets, "focusAbsorbAmount", L["Focus"], L["Tooltip_Absorb_Show_Focus"], BBF.AbsorbCaller)
    AddCardChildCheckbox(cardAbsorbTargets, cbFocusAbs, "focusAbsorbIcon", L["Icon"], L["Tooltip_Absorb_Icon"], BBF.AbsorbCaller)
    
    FinalizeCardLayout(cfAbsorb, cardAbsorbTargets)


    -------------------------------------------------------
    -- CATEGORY 2: Combat Indicator
    -------------------------------------------------------
    local cfCombat = categoryFrames["combat"].contentFrame

    local cardCombatPos = CreateOptionCard(cfCombat, L["Combat_Indicator"], nil, -10)
    AddCardAnchorDropdown(cardCombatPos, "combatIndicatorDropdown", L["Anchor"], "combatIndicatorAnchor", BBF.CombatIndicatorCaller)
    AddCardSlider(cardCombatPos, "combatIndicatorScale", L["Size"], L["Tooltip_Combat_Indicator"], 0.1, 1.9, 0.01)
    AddCardSlider(cardCombatPos, "combatIndicatorXPos", L["X_Offset"], "", -50, 50, 1)
    AddCardSlider(cardCombatPos, "combatIndicatorYPos", L["Y_Offset"], "", -50, 50, 1)

    local cardCombatFilters = CreateOptionCard(cfCombat, L["Filters"], cardCombatPos, -22)
    AddCardCheckbox(cardCombatFilters, "combatIndicatorArenaOnly", L["Arena_Only"], L["Tooltip_Arena_Only"], BBF.CombatIndicatorCaller)
    AddCardCheckbox(cardCombatFilters, "combatIndicatorPlayersOnly", L["Players_Only"], L["Tooltip_Players_Only"], BBF.CombatIndicatorCaller)
    AddCardCheckbox(cardCombatFilters, "combatIndicatorShowSap", L["No_Combat"], L["Tooltip_No_Combat"], BBF.CombatIndicatorCaller)
    AddCardCheckbox(cardCombatFilters, "combatIndicatorShowSwords", L["In_Combat"], L["Tooltip_In_Combat"], BBF.CombatIndicatorCaller)

    local cardCombatFrames = CreateOptionCard(cfCombat, L["All_Frames"], cardCombatFilters, -22)
    AddCardCheckbox(cardCombatFrames, "playerCombatIndicator", L["Player"], "", BBF.CombatIndicatorCaller)
    AddCardCheckbox(cardCombatFrames, "targetCombatIndicator", L["Target"], "", BBF.CombatIndicatorCaller)
    AddCardCheckbox(cardCombatFrames, "focusCombatIndicator", L["Focus"], "", BBF.CombatIndicatorCaller)

    FinalizeCardLayout(cfCombat, cardCombatFrames)


    -------------------------------------------------------
    -- CATEGORY 3: Healer Indicator
    -------------------------------------------------------
    local cfHealer = categoryFrames["healer"].contentFrame

    local cardHealerPos = CreateOptionCard(cfHealer, L["Healer_Indicator"], nil, -10)
    AddCardAnchorDropdown(cardHealerPos, "healerIndicatorDropdown", L["Anchor"], "healerIndicatorAnchor", BBF.HealerIndicatorCaller)
    AddCardSlider(cardHealerPos, "healerIndicatorScale", L["Size"], L["Tooltip_Healer_Indicator"], 0.8, 2.5, 0.01)
    AddCardSlider(cardHealerPos, "healerIndicatorXPos", L["X_Offset"], "", -50, 50, 1)
    AddCardSlider(cardHealerPos, "healerIndicatorYPos", L["Y_Offset"], "", -50, 50, 1)

    local cardHealerStyle = CreateOptionCard(cfHealer, L["Display_Text"], cardHealerPos, -22)
    AddCardCheckbox(cardHealerStyle, "healerIndicatorIcon", L["Icon"], L["Tooltip_Healer_Icon_Show"], function()
        if BetterBlizzFramesDB.healerIndicatorIcon and not BetterBlizzFramesDB.healerIndicator then
            BetterBlizzFramesDB.healerIndicator = true
        end
        BBF.HealerIndicatorCaller()
    end)
    AddCardCheckbox(cardHealerStyle, "healerIndicatorPortrait", L["Portrait"], L["Tooltip_Healer_Portrait_Change"], function()
        if BetterBlizzFramesDB.healerIndicatorPortrait and not BetterBlizzFramesDB.healerIndicator then
            BetterBlizzFramesDB.healerIndicator = true
        end
        BBF.HealerIndicatorCaller()
    end)

    FinalizeCardLayout(cfHealer, cardHealerStyle)


    -------------------------------------------------------
    -- CATEGORY 4: Racial Indicator
    -------------------------------------------------------
    local cfRacial = categoryFrames["racial"].contentFrame

    local cardRacialPos = CreateOptionCard(cfRacial, L["Racial_Indicator"], nil, -10)
    AddCardSlider(cardRacialPos, "racialIndicatorScale", L["Size"], L["Tooltip_Racial_Indicator_Enable"], 0.1, 1.9, 0.01)
    AddCardSlider(cardRacialPos, "racialIndicatorXPos", L["X_Offset"], "", -50, 50, 1)
    AddCardSlider(cardRacialPos, "racialIndicatorYPos", L["Y_Offset"], "", -50, 50, 1)

    local cardRacialsList = CreateOptionCard(cfRacial, L["Filters"], cardRacialPos, -22)
    AddCardCheckbox(cardRacialsList, "racialIndicatorOrc", L["Orc"], L["Tooltip_Show_Orc"], BBF.RacialIndicatorCaller)
    AddCardCheckbox(cardRacialsList, "racialIndicatorHuman", L["Human"], L["Tooltip_Show_Human"], BBF.RacialIndicatorCaller)
    AddCardCheckbox(cardRacialsList, "racialIndicatorDwarf", L["Dwarf"], L["Tooltip_Show_Dwarf"], BBF.RacialIndicatorCaller)
    AddCardCheckbox(cardRacialsList, "racialIndicatorNelf", L["Night_Elf"], L["Tooltip_Night_Elf"], BBF.RacialIndicatorCaller)
    AddCardCheckbox(cardRacialsList, "racialIndicatorUndead", L["Undead"], L["Tooltip_Undead"], BBF.RacialIndicatorCaller)
    AddCardCheckbox(cardRacialsList, "racialIndicatorDarkIronDwarf", L["DI_Dwarf"], L["Tooltip_DI_Dwarf"], BBF.RacialIndicatorCaller)

    local cardRacialTargets = CreateOptionCard(cfRacial, L["All_Frames"], cardRacialsList, -22)
    AddCardCheckbox(cardRacialTargets, "targetRacialIndicator", L["Target"], L["Tooltip_Target"], BBF.RacialIndicatorCaller)
    AddCardCheckbox(cardRacialTargets, "focusRacialIndicator", L["Focus"], L["Tooltip_Focus"], BBF.RacialIndicatorCaller)
    AddCardCheckbox(cardRacialTargets, "racialIndicatorRaceIcons", L["Race_Icon"], L["Tooltip_Race_Icon"], BBF.RacialIndicatorCaller)

    FinalizeCardLayout(cfRacial, cardRacialTargets)


    -------------------------------------------------------
    -- CATEGORY 5: Interrupt Icon
    -------------------------------------------------------
    local cfInterrupt = categoryFrames["interrupt"].contentFrame

    local cardInterruptPos = CreateOptionCard(cfInterrupt, L["Interrupt_Icon_AS"], nil, -10)
    AddCardAnchorDropdown(cardInterruptPos, "castBarInterruptIconAnchorDropdown", L["Anchor"], "castBarInterruptIconAnchor", BBF.UpdateInterruptIconSettings)
    AddCardSlider(cardInterruptPos, "castBarInterruptIconScale", L["Size"], L["Show_Interrupt_Icon_Next_Castbar"], 0.1, 1.9, 0.01)
    AddCardSlider(cardInterruptPos, "castBarInterruptIconXPos", L["X_Offset"], "", -100, 100, 1)
    AddCardSlider(cardInterruptPos, "castBarInterruptIconYPos", L["Y_Offset"], "", -100, 100, 1)

    local cardInterruptOpts = CreateOptionCard(cfInterrupt, L["All_Frames"], cardInterruptPos, -22)
    AddCardCheckbox(cardInterruptOpts, "castBarInterruptIconTarget", L["Target"], L["Show_On_Target"], BBF.UpdateInterruptIconSettings)
    AddCardCheckbox(cardInterruptOpts, "castBarInterruptIconFocus", L["Focus"], L["Show_On_Focus"], BBF.UpdateInterruptIconSettings)
    AddCardCheckbox(cardInterruptOpts, "castBarInterruptIconShowActiveOnly", L["Tooltip_Only_Show_If_Available_Desc"], L["Tooltip_Only_Show_If_Available_Desc"], BBF.UpdateInterruptIconSettings)
    AddCardCheckbox(cardInterruptOpts, "interruptIconBorder", L["Border_Status_Color"], L["Tooltip_Border_Status_Color_Desc"], BBF.UpdateInterruptIconSettings)

    FinalizeCardLayout(cfInterrupt, cardInterruptOpts)


    -------------------------------------------------------
    -- CATEGORY 6: Kick Popup
    -------------------------------------------------------
    local cfKick = categoryFrames["kick"].contentFrame

    local cardKickPos = CreateOptionCard(cfKick, L["Kick_Popup"], nil, -10)
    AddCardSlider(cardKickPos, "kickPopupScale", L["Size"], L["Tooltip_Kick_Popup_Desc"], 0.5, 2, 0.01)
    AddCardSlider(cardKickPos, "kickPopupIconScale", L["Icon"], "", 0.5, 2.5, 0.01)
    AddCardSlider(cardKickPos, "kickPopupXPos", L["X_Offset"], "", -500, 500, 1)
    AddCardSlider(cardKickPos, "kickPopupYPos", L["Y_Offset"], "", -500, 500, 1)

    local cardKickFont = CreateOptionCard(cfKick, L["Display_Text"], cardKickPos, -22)
    
    -- Font dropdown row
    local rowFont = CreateFrame("Frame", nil, cardKickFont)
    rowFont:SetPoint("TOPLEFT", cardKickFont, "TOPLEFT", 6, cardKickFont.currentY)
    local rowFontHeight = 36
    rowFont:SetSize(cardKickFont.cardWidth - 12, rowFontHeight)

    local rowFontHighlight = rowFont:CreateTexture(nil, "BACKGROUND")
    rowFontHighlight:SetAllPoints()
    rowFontHighlight:SetAtlas("options-item-highlight")
    if not rowFontHighlight:GetTexture() then
        rowFontHighlight:SetColorTexture(1, 1, 1, 0.12)
    end
    rowFontHighlight:SetBlendMode("ADD")
    rowFontHighlight:Hide()

    local function UpdateFontHighlight()
        if MouseIsOver(rowFont) then rowFontHighlight:Show() else rowFontHighlight:Hide() end
    end
    rowFont:EnableMouse(true)
    rowFont:SetScript("OnEnter", UpdateFontHighlight)
    rowFont:SetScript("OnLeave", UpdateFontHighlight)

    local fontLbl = rowFont:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fontLbl:SetPoint("LEFT", rowFont, "LEFT", 16, 0)
    fontLbl:SetText(L["Font"])

    local kickPopupFontDropdown = CreateFontDropdown(
        "kickPopupFont",
        rowFont,
        L["Select_Font"],
        "kickPopupFont",
        function(fontPath) BBF.UpdateKickPopupFont() end,
        { anchorFrame = rowFont, x = 0, y = 0, label = "" },
        150,
        nil,
        "NONE"
    )
    kickPopupFontDropdown:ClearAllPoints()
    kickPopupFontDropdown:SetPoint("RIGHT", rowFont, "RIGHT", -10, 0)
    kickPopupFontDropdown:SetWidth(150)

    kickPopupFontDropdown:HookScript("OnEnter", UpdateFontHighlight)
    kickPopupFontDropdown:HookScript("OnLeave", UpdateFontHighlight)

    cardKickFont.currentY = cardKickFont.currentY - rowFontHeight - 8
    cardKickFont:SetHeight(-cardKickFont.currentY + 6)

    AddCardCheckbox(cardKickFont, "kickPopupFontOutline", L["Outline_Label"], L["Tooltip_Outline_Toggle"], function() BBF.UpdateKickPopupFont() end)
    AddCardCheckbox(cardKickFont, "kickPopupFontShadow", L["Shadow"], "", function() BBF.UpdateKickPopupFont() end)

    -- Text Color row
    local rowColor = CreateFrame("Frame", nil, cardKickFont)
    rowColor:SetPoint("TOPLEFT", cardKickFont, "TOPLEFT", 6, cardKickFont.currentY)
    rowColor:SetSize(cardKickFont.cardWidth - 12, 34)

    local colorLbl = rowColor:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    colorLbl:SetPoint("LEFT", rowColor, "LEFT", 16, 0)
    colorLbl:SetText(L["Kick_Popup_Text_Color"])

    local colorBox = CreateColorBox(rowColor, "kickPopupTextColor", "", function() BBF.UpdateKickPopupFont() end)
    colorBox:SetPoint("RIGHT", rowColor, "RIGHT", -5, 0)

    cardKickFont.currentY = cardKickFont.currentY - 42
    cardKickFont:SetHeight(-cardKickFont.currentY + 6)

    AddCardCheckbox(cardKickFont, "kickPopupSauce", L["Kick_Popup_Sauce"], L["Tooltip_Kick_Popup_Sauce_Desc"], function()
        if BetterBlizzFramesDB.kickPopupTestMode then BBF.TestKickPopup(true) end
    end)

    local cardKickAudio = CreateOptionCard(cfKick, L["Sound_Effect"], cardKickFont, -22)
    AddCardCheckbox(cardKickAudio, "kickPopupTestMode", L["Test"], "", function()
        BBF.TestKickPopup(BetterBlizzFramesDB.kickPopupTestMode)
    end)
    
    local cbPlaySound = AddCardCheckbox(cardKickAudio, "kickPopupPlaySound", L["Kick_Popup_Play_Sound"], L["Tooltip_Kick_Popup_Play_Sound_Desc"], function()
        if BetterBlizzFramesDB.kickPopupPlaySound then
            local channel = BetterBlizzFramesDB.kickPopupSoundChannel or "Master"
            local soundName = BetterBlizzFramesDB.kickPopupSoundName
            if soundName then
                local path = LSM:Fetch(LSM.MediaType.SOUND, soundName)
                if path then PlaySoundFile(path, channel) end
            end
        end
    end)

    -- Sound dropdowns row
    local rowSound = CreateFrame("Frame", nil, cardKickAudio)
    rowSound:SetPoint("TOPLEFT", cardKickAudio, "TOPLEFT", 22, cardKickAudio.currentY)
    rowSound:SetSize(cardKickAudio.cardWidth - 28, 45)

    local kickPopupSoundNameDropdown = LibDD:Create_UIDropDownMenu("kickPopupSoundNameDropdown", rowSound)
    BBF.kickPopupSoundNameDropdown = kickPopupSoundNameDropdown
    LibDD:UIDropDownMenu_SetWidth(kickPopupSoundNameDropdown, 95)
    local fileID = BetterBlizzFramesDB.kickPopupSoundFileID
    if fileID and fileID ~= 0 then
        LibDD:UIDropDownMenu_SetText(kickPopupSoundNameDropdown, "ID: " .. fileID)
    else
        LibDD:UIDropDownMenu_SetText(kickPopupSoundNameDropdown, BetterBlizzFramesDB.kickPopupSoundName or "Lossa Countered")
    end
    LibDD:UIDropDownMenu_Initialize(kickPopupSoundNameDropdown, function(self, level, menuList)
        local sounds = LSM:HashTable(LSM.MediaType.SOUND)
        local sorted = {}
        for name in pairs(sounds) do table.insert(sorted, name) end
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
    kickPopupSoundNameDropdown:SetPoint("LEFT", rowSound, "LEFT", -15, -8)

    local kickPopupSoundNameLabel = rowSound:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    kickPopupSoundNameLabel:SetPoint("BOTTOM", kickPopupSoundNameDropdown, "TOP", 0, 3)
    kickPopupSoundNameLabel:SetText(L["Kick_Popup_Sound"])

    local kickPopupSoundRightClick = CreateFrame("Button", nil, kickPopupSoundNameDropdown)
    kickPopupSoundRightClick:SetAllPoints()
    kickPopupSoundRightClick:RegisterForClicks("RightButtonUp")
    kickPopupSoundRightClick:SetScript("OnClick", function()
        StaticPopup_Show("BBF_KICK_POPUP_SOUND_ID")
    end)
    CreateTooltip(kickPopupSoundRightClick, "Right-click to enter a custom Sound ID.")

    local kickPopupSoundChannelDropdown = LibDD:Create_UIDropDownMenu("kickPopupSoundChannelDropdown", rowSound)
    LibDD:UIDropDownMenu_SetWidth(kickPopupSoundChannelDropdown, 85)
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
    kickPopupSoundChannelDropdown:SetPoint("LEFT", kickPopupSoundNameDropdown, "RIGHT", -25, 0)

    local kickPopupSoundChannelLabel = rowSound:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    kickPopupSoundChannelLabel:SetPoint("BOTTOM", kickPopupSoundChannelDropdown, "TOP", 0, 3)
    kickPopupSoundChannelLabel:SetText(L["Kick_Popup_Output"])

    local function UpdateKickSoundDropdownState()
        if BetterBlizzFramesDB.kickPopupPlaySound and cbPlaySound:IsEnabled() then
            LibDD:UIDropDownMenu_EnableDropDown(kickPopupSoundNameDropdown)
            LibDD:UIDropDownMenu_EnableDropDown(kickPopupSoundChannelDropdown)
            kickPopupSoundNameDropdown:SetAlpha(1)
            kickPopupSoundChannelDropdown:SetAlpha(1)
            kickPopupSoundNameLabel:SetAlpha(1)
            kickPopupSoundChannelLabel:SetAlpha(1)
        else
            LibDD:UIDropDownMenu_DisableDropDown(kickPopupSoundNameDropdown)
            LibDD:UIDropDownMenu_DisableDropDown(kickPopupSoundChannelDropdown)
            kickPopupSoundNameDropdown:SetAlpha(0.4)
            kickPopupSoundChannelDropdown:SetAlpha(0.4)
            kickPopupSoundNameLabel:SetAlpha(0.4)
            kickPopupSoundChannelLabel:SetAlpha(0.4)
        end
    end

    cbPlaySound:HookScript("OnClick", UpdateKickSoundDropdownState)
    UpdateKickSoundDropdownState()

    cardKickAudio.currentY = cardKickAudio.currentY - 55
    cardKickAudio:SetHeight(-cardKickAudio.currentY + 6)

    FinalizeCardLayout(cfKick, cardKickAudio)


    -------------------------------------------------------
    -- DEFAULT CATEGORY SELECTION
    -------------------------------------------------------
    SelectCategory("absorb")

    -------------------------------------------------------
    -- RELOAD & RESET BUTTONS
    -------------------------------------------------------
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
