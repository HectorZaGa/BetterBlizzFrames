if not BBF.isMidnight then return end
local L = BBF.L

local fontSmall = BBF.fontSmall
local fontMedium = BBF.fontMedium
local fontLarge = BBF.fontLarge
local anchorPoints = BBF.anchorPoints
local anchorPoints2 = BBF.anchorPoints2

local CreateCheckbox = BBF.CreateCheckbox
local CreateSlider = BBF.CreateSlider
local CreateFontDropdown = BBF.CreateFontDropdown
local CreateColorBox = BBF.CreateColorBox
local CreateTitle = BBF.CreateTitle
local CreateTooltip = BBF.CreateTooltip
local CreateTooltipTwo = BBF.CreateTooltipTwo
local CreateAnchorDropdown = BBF.CreateAnchorDropdown
local OpenColorOptions = BBF.OpenColorOptions
local DisableElement = BBF.DisableElement
local EnableElement = BBF.EnableElement

function guiFrameAuras()
    ----------------------
    -- Frame Auras
    ----------------------
    local guiFrameAuras = CreateFrame("Frame")
    guiFrameAuras.name = L["Module_Name_Auras"]
    guiFrameAuras.parent = BetterBlizzFrames.name
    local aurasSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiFrameAuras, guiFrameAuras.name, guiFrameAuras.name)
    BBF.aurasSubCategory = guiFrameAuras.name
    CreateTitle(guiFrameAuras)

    -------------------------------------------------------
    -- SIDEBAR NAVIGATION CONTAINER
    -------------------------------------------------------
    local sidebar = CreateFrame("Frame", nil, guiFrameAuras)
    sidebar:SetSize(165, 545)
    sidebar:SetPoint("TOPLEFT", guiFrameAuras, "TOPLEFT", 12, -45)

    local contentParent = CreateFrame("Frame", nil, guiFrameAuras)
    contentParent:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 10, 0)
    contentParent:SetPoint("BOTTOMRIGHT", guiFrameAuras, "BOTTOMRIGHT", -38, 15)

    -- Top bar for global toggles (Enable Aura Settings & Add Masque Support)
    local topBar = CreateFrame("Frame", nil, guiFrameAuras)
    topBar:SetPoint("BOTTOMLEFT", sidebar, "TOPLEFT", 0, 5)
    topBar:SetPoint("BOTTOMRIGHT", contentParent, "TOPRIGHT", 0, 5)
    topBar:SetHeight(32)

    local playerAuraFiltering = CreateCheckbox("playerAuraFiltering", L["Enable_Aura_Settings"], topBar)
    playerAuraFiltering.name = guiFrameAuras.name
    CreateTooltipTwo(playerAuraFiltering, L["Enable_Aura_Settings"], L["Tooltip_Enable_Aura_Settings_TargetFocus_Desc"])
    playerAuraFiltering:SetPoint("LEFT", topBar, "LEFT", 0, 0)
    playerAuraFiltering:HookScript("OnClick", function (self)
        if self:GetChecked() then
            if BetterBlizzFramesDB.targetToTXPos == 0 then
                StaticPopup_Show("BBF_TOT_MESSAGE")
                BetterBlizzFramesDB.targetToTXPos = 31
                if BBF.targetToTXPos and BBF.targetToTXPos.SetValue then
                    BBF.targetToTXPos:SetValue(31)
                end
                BetterBlizzFramesDB.focusToTXPos = 31
                if BBF.focusToTXPos and BBF.focusToTXPos.SetValue then
                    BBF.focusToTXPos:SetValue(31)
                end
                BBF.MoveToTFrames()
            else
                StaticPopup_Show("BBF_CONFIRM_RELOAD")
            end
        else
            if BetterBlizzFramesDB.targetToTXPos == 31 then
                BBF.Print(L["Chat_Aura_Settings_Off"])
                BetterBlizzFramesDB.targetToTXPos = 0
                if BBF.targetToTXPos and BBF.targetToTXPos.SetValue then
                    BBF.targetToTXPos:SetValue(0)
                end
                BetterBlizzFramesDB.focusToTXPos = 0
                if BBF.focusToTXPos and BBF.focusToTXPos.SetValue then
                    BBF.focusToTXPos:SetValue(0)
                end
                BBF.MoveToTFrames()
            end
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)

    local enableMasque = CreateCheckbox("enableMasque", L["Add_Masque_Support"], topBar)
    enableMasque:SetPoint("LEFT", playerAuraFiltering.Text, "RIGHT", 15, 0)
    CreateTooltipTwo(enableMasque, L["Add_Masque_Support"], L["Tooltip_Masque_Support"], L["Tooltip_Masque_Support_Extra"], nil, nil, 4)
    enableMasque:HookScript("OnClick", function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    enableMasque:Disable()
    enableMasque:SetAlpha(0.5)

    local categoryList = {
        { id = "player",      label = L["Player_Auras"],             atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {0.1, 0.6, 1} },
        { id = "targetfocus", label = L["Target_And_Focus_Auras"],   atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {0, 1, 0},
          overlays = { { atlas = "TargetCrosshairs", size = {22, 22}, offset = {8, -8} } } },
        { id = "display",     label = L["Display_And_Visibility"],   atlas = "optionsicon-brown", size = {20, 20} },
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
        local sf = CreateFrame("ScrollFrame", "BBF_MidnightAurasCat_" .. cat.id, contentParent, "ScrollFrameTemplate")
        sf:SetAllPoints(contentParent)
        sf:Hide()

        local cf = CreateFrame("Frame", nil, sf)
        cf:SetSize(435, 520)
        sf:SetScrollChild(cf)

        categoryFrames[cat.id] = sf
        sf.contentFrame = cf

        local btn = CreateFrame("Button", nil, sidebar, "BackdropTemplate")
        btn:SetSize(160, 36)
        btn:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 0, -((i - 1) * 40))
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

        if cat.desaturated then
            iconTex:SetDesaturated(true)
        end
        if cat.color then
            iconTex:SetVertexColor(unpack(cat.color))
        end

        if cat.overlays then
            for _, ov in ipairs(cat.overlays) do
                local ovTex = iconFrame:CreateTexture(nil, ov.layer or "OVERLAY")
                local ow, oh = unpack(ov.size or {20, 20})
                ovTex:SetSize(ow, oh)
                local ox, oy = unpack(ov.offset or {0, 0})
                ovTex:SetPoint("CENTER", iconTex, "CENTER", ox, oy)
                if ov.atlas then
                    ovTex:SetAtlas(ov.atlas)
                elseif ov.icon then
                    ovTex:SetTexture(ov.icon)
                end
                if ov.desaturated then
                    ovTex:SetDesaturated(true)
                end
                if ov.color then
                    ovTex:SetVertexColor(unpack(ov.color))
                end
            end
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
        cardWidth = cardWidth or 435
        
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
                parentFrame:SetHeight(math.max(math.abs(lastCard:GetHeight()) + 150, 520))
            end
        end
    end

    local function AddCardCheckbox(card, dbKey, titleStr, descStr, callback, cpuUsage)
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
            CreateTooltipTwo(titleFrame, titleStr, descStr, nil, nil, nil, cpuUsage)
            CreateTooltipTwo(cb, titleStr, descStr, nil, nil, nil, cpuUsage)
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

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
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

        local function UpdateState()
            if parentCb and parentCb.GetChecked then
                local isParentActive = parentCb:GetChecked() and parentCb:IsEnabled()
                if isParentActive then
                    EnableElement(cb)
                    title:SetTextColor(0.9, 0.9, 0.9)
                    row:SetAlpha(1.0)
                else
                    DisableElement(cb)
                    title:SetTextColor(0.5, 0.5, 0.5)
                    row:SetAlpha(0.5)
                end
            end
        end

        if parentCb then
            parentCb:HookScript("OnClick", UpdateState)
            C_Timer.After(0.05, UpdateState)
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

    local function AddCardChildSlider(card, parentCb, dbKey, titleStr, descStr, minVal, maxVal, stepVal, callback)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 22, card.currentY)
        local rowHeight = 40
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

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title:SetPoint("LEFT", row, "LEFT", 16, 0)
        title:SetText(titleStr)
        title:SetWidth(224)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 224), rowHeight)

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

        local function UpdateState()
            if parentCb and parentCb.GetChecked then
                local isParentActive = parentCb:GetChecked() and parentCb:IsEnabled()
                if isParentActive then
                    EnableElement(slider)
                    title:SetTextColor(0.9, 0.9, 0.9)
                    row:SetAlpha(1.0)
                else
                    DisableElement(slider)
                    title:SetTextColor(0.5, 0.5, 0.5)
                    row:SetAlpha(0.5)
                end
            end
        end

        if parentCb then
            parentCb:HookScript("OnClick", UpdateState)
            C_Timer.After(0.05, UpdateState)
        end

        titleFrame:HookScript("OnEnter", UpdateHighlight)
        titleFrame:HookScript("OnLeave", UpdateHighlight)
        slider:HookScript("OnEnter", UpdateHighlight)
        slider:HookScript("OnLeave", UpdateHighlight)

        card.currentY = card.currentY - rowHeight - 8
        card:SetHeight(-card.currentY + 6)
        return slider
    end

    -------------------------------------------------------
    -- CATEGORY 1: Player Aura Settings
    -------------------------------------------------------
    local cfPlayer = categoryFrames["player"].contentFrame

    local cardPlayer = CreateOptionCard(cfPlayer, L["Player_Aura_Settings"], nil, -10)
    local cbPlayerEnable = AddCardCheckbox(cardPlayer, "enablePlayerBuffFiltering", L["Enable_Player_Aura_Adjustments"], "")
    local cbPlayerClickthrough = AddCardChildCheckbox(cardPlayer, cbPlayerEnable, "clickthroughPlayerAuras", L["Clickthrough_Player_Auras"], L["Tooltip_Clickthrough_Player_Auras"])
    local cbPlayerTooltips = AddCardChildCheckbox(cardPlayer, cbPlayerEnable, "hidePlayerAuraTooltips", L["Hide_Player_Aura_Tooltips"], L["Tooltip_Hide_Player_Aura_Tooltips"])
    local sliderPlayerX = AddCardChildSlider(cardPlayer, cbPlayerEnable, "playerAuraSpacingX", L["Horizontal_Padding"], L["Tooltip_Horizontal_Aura_Padding"], 0, 10, 1)
    local sliderPlayerY = AddCardChildSlider(cardPlayer, cbPlayerEnable, "playerAuraSpacingY", L["Vertical_Padding"], "", -10, 10, 1)

    cbPlayerEnable:HookScript("OnClick", function(self)
        if self:GetChecked() then
            EnableElement(cbPlayerClickthrough)
            EnableElement(cbPlayerTooltips)
            EnableElement(sliderPlayerX)
            EnableElement(sliderPlayerY)
        else
            DisableElement(cbPlayerClickthrough)
            DisableElement(cbPlayerTooltips)
            DisableElement(sliderPlayerX)
            DisableElement(sliderPlayerY)
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    if not BetterBlizzFramesDB.enablePlayerBuffFiltering then
        DisableElement(cbPlayerClickthrough)
        DisableElement(cbPlayerTooltips)
        DisableElement(sliderPlayerX)
        DisableElement(sliderPlayerY)
    end

    FinalizeCardLayout(cfPlayer, cardPlayer)

    -------------------------------------------------------
    -- CATEGORY 2: Target & Focus Aura Settings
    -------------------------------------------------------
    local cfTargetFocus = categoryFrames["targetfocus"].contentFrame

    local cardLayout = CreateOptionCard(cfTargetFocus, L["Dimensions_And_Layout"], nil, -10)
    AddCardSlider(cardLayout, "targetAndFocusAuraScale", L["All_Aura_Size"], L["Tooltip_All_Aura_Size"], 0.7, 2, 0.01)
    local sliderSmall = AddCardSlider(cardLayout, "targetAndFocusSmallAuraScale", L["Small_Aura_Size"], L["Tooltip_Small_Aura_Size"], 0.7, 2, 0.01)
    local cbSameSize = AddCardChildCheckbox(cardLayout, nil, "sameSizeAuras", L["Same_Size"], L["Tooltip_Same_Size"], function()
        if BetterBlizzFramesDB.sameSizeAuras then
            DisableElement(sliderSmall)
        else
            EnableElement(sliderSmall)
        end
    end)
    if BetterBlizzFramesDB.sameSizeAuras then
        DisableElement(sliderSmall)
    end
    AddCardSlider(cardLayout, "targetAndFocusAurasPerRow", L["Max_Auras_Per_Row"], "", 1, 12, 1)
    AddCardSlider(cardLayout, "targetAndFocusAuraOffsetX", L["X_Offset"], "", -50, 50, 1)
    AddCardSlider(cardLayout, "targetAndFocusAuraOffsetY", L["Y_Offset"], "", -50, 50, 1)
    AddCardSlider(cardLayout, "targetAndFocusHorizontalGap", L["Horizontal_Gap"], "", 0, 18, 0.5)
    AddCardSlider(cardLayout, "targetAndFocusVerticalGap", L["Vertical_Gap"], "", 0, 18, 0.5)
    AddCardSlider(cardLayout, "auraTypeGap", L["Aura_Type_Gap"], L["Tooltip_Aura_Type_Gap"], 0, 30, 1)

    local cardText = CreateOptionCard(cfTargetFocus, L["Text_And_Timers"], cardLayout, -22)
    AddCardSlider(cardText, "auraStackSize", L["Aura_Stack_Size"], L["Tooltip_Aura_Stack_Size"], 0.4, 2, 0.01)
    local cbShowCd = AddCardCheckbox(cardText, "showAuraCdText", L["Show_Aura_Timer_Text"], L["Tooltip_Show_Aura_Timer_Text"])
    local sliderCdSize = AddCardChildSlider(cardText, cbShowCd, "auraCdTextSize", L["Aura_CD_Text_Size"], L["Tooltip_Aura_CD_Text_Size"], 0.25, 1.5, 0.01)
    local cbOnlyMine = AddCardChildCheckbox(cardText, cbShowCd, "auraCdTextOnlyMine", L["Only_Mine"], L["Tooltip_Aura_CD_Text_Only_Mine"])
    
    cbShowCd:HookScript("OnClick", function(self)
        if self:GetChecked() then
            EnableElement(sliderCdSize)
            EnableElement(cbOnlyMine)
        else
            DisableElement(sliderCdSize)
            DisableElement(cbOnlyMine)
        end
    end)
    if not BetterBlizzFramesDB.showAuraCdText then
        DisableElement(sliderCdSize)
        DisableElement(cbOnlyMine)
    end

    FinalizeCardLayout(cfTargetFocus, cardText)

    -------------------------------------------------------
    -- CATEGORY 3: Display & Visibility
    -------------------------------------------------------
    local cfDisplay = categoryFrames["display"].contentFrame

    local cardStyle = CreateOptionCard(cfDisplay, L["Aura_Styling"], nil, -10)
    
    -- Change Purge Texture Color row
    local rowPurge = CreateFrame("Frame", nil, cardStyle)
    rowPurge:SetPoint("TOPLEFT", cardStyle, "TOPLEFT", 6, cardStyle.currentY)
    local rowPurgeHeight = 36
    rowPurge:SetSize(cardStyle.cardWidth - 12, rowPurgeHeight)

    local rowPurgeHighlight = rowPurge:CreateTexture(nil, "BACKGROUND")
    rowPurgeHighlight:SetAllPoints()
    rowPurgeHighlight:SetAtlas("options-item-highlight")
    if not rowPurgeHighlight:GetTexture() then
        rowPurgeHighlight:SetColorTexture(1, 1, 1, 0.12)
    end
    rowPurgeHighlight:SetBlendMode("ADD")
    rowPurgeHighlight:Hide()

    local function UpdatePurgeHighlight()
        if MouseIsOver(rowPurge) then rowPurgeHighlight:Show() else rowPurgeHighlight:Hide() end
    end
    rowPurge:EnableMouse(true)
    rowPurge:SetScript("OnEnter", UpdatePurgeHighlight)
    rowPurge:SetScript("OnLeave", UpdatePurgeHighlight)

    local cbPurge = AddCardCheckbox(cardStyle, "changePurgeTextureColor", L["Change_Purge_Texture_Color"], L["Change_Purge_Texture_Color"])
    local colorBoxPurge = CreateColorBox(rowPurge, "purgeTextureColorRGB", "", function() BBF.RefreshAllAuraFrames() end)
    colorBoxPurge:SetPoint("RIGHT", rowPurge, "RIGHT", -5, 0)
    colorBoxPurge:HookScript("OnEnter", UpdatePurgeHighlight)
    colorBoxPurge:HookScript("OnLeave", UpdatePurgeHighlight)

    AddCardCheckbox(cardStyle, "increaseAuraStrata", L["Increase_Aura_Frame_Strata"], L["Tooltip_Increase_Aura_Frame_Strata"], function(self)
        if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end
    end)
    AddCardCheckbox(cardStyle, "hideUnitframeAuraTooltips", L["Hide_UnitFrame_Aura_Tooltips"], L["Tooltip_Hide_UnitFrame_Aura_Tooltips"])
    AddCardCheckbox(cardStyle, "pixelBorderAuras", L["Pixel_Border_Auras"], L["Tooltip_Pixel_Border_Auras_Desc"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    AddCardCheckbox(cardStyle, "removeDebuffColorBorder", L["Remove_Debuff_Color_Border"], L["Tooltip_Remove_Debuff_Color_Border"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local cardHide = CreateOptionCard(cfDisplay, L["Hide_Auras"], cardStyle, -22)
    AddCardCheckbox(cardHide, "hideTargetBuffs", L["Hide_Target_Buffs"], L["Tooltip_Hide_Target_Buffs_Desc"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    AddCardCheckbox(cardHide, "hideTargetDebuffs", L["Hide_Target_Debuffs"], L["Tooltip_Hide_Target_Debuffs_Desc"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    AddCardCheckbox(cardHide, "hideFocusBuffs", L["Hide_Focus_Buffs"], L["Tooltip_Hide_Focus_Buffs_Desc"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    AddCardCheckbox(cardHide, "hideFocusDebuffs", L["Hide_Focus_Debuffs"], L["Tooltip_Hide_Focus_Debuffs_Desc"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local cardLimits = CreateOptionCard(cfDisplay, L["Aura_Limits"], cardHide, -22)
    local cbMaxBuffs = AddCardCheckbox(cardLimits, "enableMaxTargetFocusBuffs", L["Max_Buffs"], L["Max_Buffs"])
    local sliderMaxBuffs = AddCardChildSlider(cardLimits, cbMaxBuffs, "maxTargetFocusBuffs", L["Max_Buffs"], "", 1, 100, 1, function()
        BBF.RefreshAllAuraFrames()
    end)
    sliderMaxBuffs.integerOnly = true
    cbMaxBuffs:HookScript("OnClick", function(self)
        if self:GetChecked() then EnableElement(sliderMaxBuffs) else DisableElement(sliderMaxBuffs) end
        BBF.RefreshAllAuraFrames()
    end)
    if not BetterBlizzFramesDB.enableMaxTargetFocusBuffs then DisableElement(sliderMaxBuffs) end

    local cbMaxDebuffs = AddCardCheckbox(cardLimits, "enableMaxTargetFocusDebuffs", L["Max_Debuffs"], L["Max_Debuffs"])
    local sliderMaxDebuffs = AddCardChildSlider(cardLimits, cbMaxDebuffs, "maxTargetFocusDebuffs", L["Max_Debuffs"], "", 1, 100, 1, function()
        BBF.RefreshAllAuraFrames()
    end)
    sliderMaxDebuffs.integerOnly = true
    cbMaxDebuffs:HookScript("OnClick", function(self)
        if self:GetChecked() then EnableElement(sliderMaxDebuffs) else DisableElement(sliderMaxDebuffs) end
        BBF.RefreshAllAuraFrames()
    end)
    if not BetterBlizzFramesDB.enableMaxTargetFocusDebuffs then DisableElement(sliderMaxDebuffs) end

    FinalizeCardLayout(cfDisplay, cardLimits)

    SelectCategory("player")
end
