-- ============================================================
-- BetterBlizzFrames: midnight/gui_builder.lua
-- Schema-driven settings UI engine.
-- Inspired by WaypointUI's Settings_Constructor pattern.
-- All imperative WoW API code lives here.
-- Schema files (gui_general.lua etc.) are pure data tables.
-- ============================================================
if not BBF.isMidnight then return end

BBF.GUI = BBF.GUI or {}
local GUI = BBF.GUI

-- ============================================================
-- THEME -- Single source of truth for all visual constants
-- ============================================================
GUI.Theme = {
    -- Sidebar
    Sidebar = {
        width   = 165,
        height  = 545,
        offsetX = 12,
        offsetY = -45,
    },
    -- Content area
    Content = {
        gapLeft      = 10,
        marginRight  = -38,
        marginBottom = 15,
    },
    -- Scroll child (card container)
    ScrollChild = {
        width     = 435,
        minHeight = 520,
    },
    -- Tab buttons
    Tab = {
        width         = 160,
        height        = 36,
        stride        = 40,
        iconFrameSize = 26,
        iconOffsetLeft = 4,
        textOffsetLeft = 4,
        bgColor       = { 0.1,  0.1,  0.12, 0.85 },
        borderColor   = { 0.25, 0.25, 0.28, 0.8  },
        textColor     = { 0.8,  0.8,  0.8,  1    },
        bgColorActive       = { 0.25, 0.2,  0.05, 0.9 },
        borderColorActive   = { 0.9,  0.75, 0.1,  1   },
        textColorActive     = { 1,    0.85, 0.1,  1   },
        borderColorHover    = { 0.5,  0.5,  0.5,  1   },
        textColorHover      = { 1,    1,    1,    1   },
        backdrop = {
            bgFile   = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        },
    },
    -- Cards
    Card = {
        defaultWidth = 435,
        cursorStart  = -10,
        bgColor      = { 0.06, 0.06, 0.08, 0.85 },
        borderColor  = { 0.2,  0.2,  0.25, 0.8  },
        backdrop = {
            bgFile   = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        },
        header = {
            font           = "GameFontNormalLarge",
            color          = { 1, 0.82, 0 },
            gapBelowHeader = -6,
            firstCardY     = -10,
            betweenCards   = -22,
        },
    },
    -- Rows
    -- Tooltips
    Tooltip = {
        anchor          = "ANCHOR_RIGHT",
        titleFont       = "GameTooltipHeaderText",
        titleColor      = { 1, 0.82, 0, 1 },
        bodyFont        = "GameTooltipText",
        bodyColor       = { 1, 1, 1, 1 },
        subtextFont     = "GameTooltipTextSmall",
        subtextColor    = { 0.8, 0.8, 0.8, 1 },
        cvarColor       = { 0.2, 1, 0.6, 1 },
        dividerColor    = { 0.8, 0.8, 0.8, 1 },
        defaultIconSize = { 16, 16 },
        starAtlas       = "UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare-Star",
        noStarAtlas     = "UI-HUD-UnitFrame-Target-PortraitOn-Boss-IconRing",
        checkmarkAtlas  = "ParagonReputation_Checkmark",
    },
    Row = {
        checkbox = {
            height            = 34,
            gap               = 8,
            leftInset         = 6,
            leftInsetChild    = 22,
            widthShrink       = 12,
            widthShrinkChild  = 28,
            titleFont         = "GameFontHighlight",
            titleFontChild    = "GameFontHighlightSmall",
            titleWidth        = 330,
            titleWidthChild   = 314,
            titleOffsetLeft   = 16,
            cbSize            = 28,
            cbOffsetRight     = -5,
        },
        slider = {
            height            = 40,
            gap               = 10,
            leftInset         = 6,
            leftInsetChild    = 22,
            widthShrink       = 12,
            widthShrinkChild  = 28,
            titleFont         = "GameFontHighlight",
            titleFontChild    = "GameFontHighlightSmall",
            titleWidth        = 240,
            titleWidthChild   = 224,
            titleOffsetLeft   = 16,
            sliderWidth       = 120,
            sliderOffsetRight = -20,
        },
        dualChild = {
            height      = 30,
            gap         = 6,
            leftInset   = 22,
            widthShrink = 28,
            titleFont   = "GameFontHighlightSmall",
            cbSize      = 24,
            spacing     = 35,
        },
        header = {
            height          = 22,
            gap             = 4,
            leftInset       = 6,
            titleOffsetLeft = 14,
            font            = "GameFontNormal",
        },
        highlight = {
            atlas     = "options-item-highlight",
            blendMode = "ADD",
        },
    },
    -- Popup Windows (e.g. Class Options, Custom Colors)
    Popup = {
        template        = "ButtonFrameTemplate",
        bgColor         = { 0.0784, 0.0784, 0.0784, 1 },
        titleFont       = "GameFontHighlight",
        titleOffsetY    = -5,
        defaultWidth    = 260,
        defaultHeight   = 310,
        strata          = "DIALOG",
        rowHeight       = 30,
        rowGap          = 33,
        insetX          = 16,
        startY          = -32,
        checkboxSize    = 24,
        highlightAtlas  = "options-item-highlight",
        highlightBlend  = "ADD",
    },
}

-- ============================================================
-- WIDGET TYPE ENUM
-- ============================================================
GUI.WidgetType = {
    Checkbox          = 1,
    ChildCheckbox     = 2,
    Slider            = 3,
    ChildSlider       = 4,
    DualChildCheckbox = 5,
    MultiParentChild  = 6,
    SectionHeader     = 7,
    ColorSwatch       = 8,
    Dropdown          = 9,
    AnchorDropdown    = 10,
    Preview           = 11,
}

-- ============================================================
-- INTERNAL HELPERS
-- ============================================================
local T = GUI.Theme

local function AddRowHighlight(row)
    local hl = row:CreateTexture(nil, "BACKGROUND")
    hl:SetAllPoints()
    hl:SetAtlas(T.Row.highlight.atlas)
    if not hl:GetTexture() then
        hl:SetColorTexture(1, 1, 1, 0.12)
    end
    hl:SetBlendMode(T.Row.highlight.blendMode)
    hl:Hide()
    local function Update()
        if MouseIsOver(row) then hl:Show() else hl:Hide() end
    end
    row:EnableMouse(true)
    row:SetScript("OnEnter", Update)
    row:SetScript("OnLeave", Update)
    return hl, Update
end

local function HookHighlight(frame, updateFn)
    if frame then
        frame:HookScript("OnEnter", updateFn)
        frame:HookScript("OnLeave", updateFn)
    end
end

local function SetWidgetState(widget, enabled)
    if not widget then return end
    local alpha = enabled and 1.0 or (T.Row and T.Row.disabledAlpha or 0.4)
    local isDesaturated = not enabled

    -- 1. Outer Row Frame (only use explicit associatedRow — never fall back to GetParent()
    --    to avoid accidentally dimming the entire popup panel for color swatches)
    local row = widget.associatedRow
    if row and row ~= UIParent and row.SetAlpha then
        row:SetAlpha(alpha)
    end

    -- Widget itself (for standalone widgets with no associatedRow, e.g. color swatches)
    if not row and widget.SetAlpha then
        widget:SetAlpha(alpha)
    end

    local sliderFrame = widget.sliderFrame or widget
    if sliderFrame and sliderFrame ~= row and sliderFrame ~= widget and sliderFrame.SetAlpha then
        sliderFrame:SetAlpha(alpha)
    end

    -- 2. Interactivity (Enable/Disable mouse & buttons)
    if enabled then
        if widget.Enable then widget:Enable() end
        if widget.associatedTitleFrame and widget.associatedTitleFrame.EnableMouse then
            widget.associatedTitleFrame:EnableMouse(true)
        end
    else
        if widget.Disable then widget:Disable() end
        if widget.associatedTitleFrame and widget.associatedTitleFrame.EnableMouse then
            widget.associatedTitleFrame:EnableMouse(false)
        end
    end

    -- 3. MinimalSliderWithSteppersTemplate stepper buttons enablement
    local sliderFrame = widget.sliderFrame or widget
    if sliderFrame and sliderFrame ~= widget then
        if sliderFrame.Back and sliderFrame.Back.SetEnabled then
            sliderFrame.Back:SetEnabled(enabled)
        end
        if sliderFrame.Forward and sliderFrame.Forward.SetEnabled then
            sliderFrame.Forward:SetEnabled(enabled)
        end
    end

    -- 4. Desaturate texture elements if available
    if widget.GetNormalTexture and widget:GetNormalTexture() then
        local tex = widget:GetNormalTexture()
        if tex and tex.SetDesaturated then tex:SetDesaturated(isDesaturated) end
    end
end

local function WireChildToParent(parentCb, widget, title, row, info)
    if not parentCb then return end
    
    -- Check if child explicitly ignores parent state
    if info and (info.ignoreParentState or info.ignoreParent) then
        SetWidgetState(widget, true)
        return
    end

    local function UpdateState()
        local isParentEnabled = parentCb:GetChecked() and (not parentCb.IsEnabled or parentCb:IsEnabled())
        SetWidgetState(widget, isParentEnabled)
    end

    parentCb:HookScript("OnClick", UpdateState)
    UpdateState()
end

-- ============================================================
-- ROW BUILDERS
-- ============================================================


--- Apply modern Blizzard settings checkbox visual styling (SettingsCheckBoxControlTemplate style).
local function StyleCheckbox(cb)
    if not cb then return end
    local rc = T.Row.checkbox
    local sz = rc.cbSize or 24
    cb:SetSize(sz, sz)

    if cb:GetHighlightTexture() then
        cb:GetHighlightTexture():SetTexture("")
        cb:GetHighlightTexture():SetAlpha(0)
        cb:GetHighlightTexture():Hide()
        cb:GetHighlightTexture().Show = function() end
    end
    if cb.HoverBackground then
        cb.HoverBackground:SetAlpha(0)
        cb.HoverBackground:Hide()
        cb.HoverBackground.Show = function() end
    end
end


--- Trigger right-click action from schema onRightClick or BBF.HandleRightClick fallback.
local function TriggerRightClick(info, widget, keyOverride, labelOverride)
    local key   = keyOverride   or info.key
    local label = labelOverride or info.label
    local isShift = IsShiftKeyDown()
    local isCtrl  = IsControlKeyDown()
    local isAlt   = IsAltKeyDown()

    if info.onRightClick then
        info.onRightClick(isShift, isCtrl, isAlt, widget, key, label)
    elseif BBF.HandleRightClick then
        BBF.HandleRightClick(key, label, widget)
    end

    -- Refresh GameTooltip immediately if hovering over the widget
    if widget and widget.IsMouseOver and widget:IsMouseOver() then
        local onEnter = widget:GetScript("OnEnter")
        if onEnter then
            onEnter(widget)
        end
    end
end

local function BuildCheckboxRow(card, info, parentCb)
    local isChild      = (parentCb ~= nil) or (info.inverseParent ~= nil) or (info.disableTarget ~= nil)
    local rc           = T.Row.checkbox
    local leftInset    = isChild and rc.leftInsetChild   or rc.leftInset
    local widthShrink  = isChild and rc.widthShrinkChild  or rc.widthShrink
    local titleFont    = isChild and rc.titleFontChild    or rc.titleFont
    local titleWidth   = isChild and rc.titleWidthChild   or rc.titleWidth

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", leftInset, card.currentY)
    row:SetSize(card.cardWidth - widthShrink, rc.height)
    local _, updateHL = AddRowHighlight(row)

    local title = row:CreateFontString(nil, "OVERLAY", titleFont)
    title:SetPoint("LEFT", row, "LEFT", rc.titleOffsetLeft, 0)
    title:SetText(info.label)
    title:SetWidth(titleWidth)
    title:SetJustifyH("LEFT")

    local titleFrame = CreateFrame("Frame", nil, row)
    titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
    titleFrame:SetSize(math.min(title:GetStringWidth() + 10, titleWidth), rc.height)

    local cb = BBF.CreateCheckbox(info.key, "", parentCb or row, nil, info.onChange)
    cb:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    cb:HookScript("OnClick", function(self, btn)
        if btn == "RightButton" then
            self:SetChecked(not self:GetChecked()) -- Revert automatic check toggle on right-click
            TriggerRightClick(info, titleFrame or self)
        end
    end)
    StyleCheckbox(cb)
    cb:SetPoint("RIGHT", row, "RIGHT", rc.cbOffsetRight, 0)

    cb.associatedTitle      = title
    cb.associatedRow        = row
    cb.associatedTitleFrame = titleFrame

    if isChild then
        if info.inverseParent or info.disableTarget then
            -- Inverse parent child: child controls target enablement in reverse
        elseif cb.UpdateEnabledState then
            cb:UpdateEnabledState()
        else
            WireChildToParent(parentCb, cb, title, row, info)
        end
    end

    titleFrame:EnableMouse(true)
    titleFrame:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" and cb:IsEnabled() then
            cb:Click("LeftButton")
        elseif btn == "RightButton" then
            TriggerRightClick(info, titleFrame)
        end
    end)

    if info.tooltip and info.tooltip ~= "" then
        BBF.CreateTooltipTwo(titleFrame, info.label, info.tooltip, info.subText, nil, nil, info.cpuUsage)
        BBF.CreateTooltipTwo(cb,         info.label, info.tooltip, info.subText, nil, nil, info.cpuUsage)
    end

    HookHighlight(titleFrame, updateHL)
    HookHighlight(cb, updateHL)

    card.currentY = card.currentY - rc.height - rc.gap
    card:SetHeight(-card.currentY + 6)
    return cb
end

local function BuildSliderRow(card, info, parentCb)
    local isChild      = parentCb ~= nil
    local rs           = T.Row.slider
    local leftInset    = isChild and rs.leftInsetChild   or rs.leftInset
    local widthShrink  = isChild and rs.widthShrinkChild  or rs.widthShrink
    local titleFont    = isChild and rs.titleFontChild    or rs.titleFont
    local titleWidth   = isChild and rs.titleWidthChild   or rs.titleWidth

    local isPercent    = info.percent == true
    local minVal       = info.min or (isPercent and 0 or 0)
    local maxVal       = info.max or (isPercent and 100 or 100)
    local stepVal      = info.step or (isPercent and 1 or 1)

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", leftInset, card.currentY)
    row:SetSize(card.cardWidth - widthShrink, rs.height)
    local _, updateHL = AddRowHighlight(row)

    local title = row:CreateFontString(nil, "OVERLAY", titleFont)
    title:SetPoint("LEFT", row, "LEFT", rs.titleOffsetLeft, 0)
    title:SetText(info.label)
    title:SetWidth(titleWidth)
    title:SetJustifyH("LEFT")

    local titleFrame = CreateFrame("Frame", nil, row)
    titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
    titleFrame:SetSize(math.min(title:GetStringWidth() + 10, titleWidth), rs.height)

    local slider = BBF.CreateSlider(row, "", minVal, maxVal, stepVal, info.key, nil, rs.sliderWidth, isPercent)
    slider:SetPoint("RIGHT", row, "RIGHT", rs.sliderOffsetRight, 0)
    slider:EnableMouse(true)
    slider:HookScript("OnMouseDown", function(self, btn)
        if btn == "RightButton" then
            TriggerRightClick(info, slider)
        end
    end)

    slider.associatedTitle      = title
    slider.associatedRow        = row
    slider.associatedTitleFrame = titleFrame

    if isChild then
        if slider.UpdateEnabledState then
            slider:UpdateEnabledState()
        else
            WireChildToParent(parentCb, slider, title, row, info)
        end
    end

    titleFrame:EnableMouse(true)
    titleFrame:SetScript("OnMouseDown", function(self, btn)
        if btn == "RightButton" then
            TriggerRightClick(info, titleFrame)
        end
    end)

    if info.tooltip and info.tooltip ~= "" then
        BBF.CreateTooltipTwo(titleFrame, info.label, info.tooltip)
        BBF.CreateTooltipTwo(slider,     info.label, info.tooltip)
    end

    HookHighlight(titleFrame, updateHL)
    HookHighlight(slider, updateHL)

    card.currentY = card.currentY - rs.height - rs.gap
    card:SetHeight(-card.currentY + 6)
    return slider
end

local function BuildDualChildCheckboxRow(card, info, parentCb)
    local rd = T.Row.dualChild

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", rd.leftInset, card.currentY)
    row:SetSize(card.cardWidth - rd.widthShrink, rd.height)
    local _, updateHL = AddRowHighlight(row)

    local title1 = row:CreateFontString(nil, "OVERLAY", rd.titleFont)
    title1:SetPoint("LEFT", row, "LEFT", 6, 0)
    title1:SetText(info.label1)

    local tf1 = CreateFrame("Frame", nil, row)
    tf1:SetPoint("LEFT", row, "LEFT", 0, 0)
    tf1:SetSize(title1:GetStringWidth() + 6, rd.height)

    local cb1 = BBF.CreateCheckbox(info.key1, "", parentCb or row, nil)
    cb1:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    cb1:HookScript("OnClick", function(self, btn)
        if btn == "RightButton" then
            self:SetChecked(not self:GetChecked())
            TriggerRightClick(info, tf1 or self, info.key1, info.label1)
        end
    end)
    cb1.associatedTitle = title1
    StyleCheckbox(cb1)
    cb1:SetPoint("LEFT", title1, "RIGHT", 6, 0)
    if cb1.UpdateEnabledState then cb1:UpdateEnabledState() end

    tf1:EnableMouse(true)
    tf1:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" and cb1:IsEnabled() then cb1:Click("LeftButton")
        elseif btn == "RightButton" and BBF.HandleRightClick then BBF.HandleRightClick(info.key1, info.label1, tf1) end
    end)
    if info.tooltip1 and info.tooltip1 ~= "" then
        BBF.CreateTooltipTwo(tf1, info.label1, info.tooltip1)
        BBF.CreateTooltipTwo(cb1, info.label1, info.tooltip1)
    end

    local title2 = row:CreateFontString(nil, "OVERLAY", rd.titleFont)
    title2:SetPoint("LEFT", cb1, "RIGHT", rd.spacing, 0)
    title2:SetText(info.label2)

    local tf2 = CreateFrame("Frame", nil, row)
    tf2:SetPoint("LEFT", cb1, "RIGHT", rd.spacing, 0)
    tf2:SetSize(title2:GetStringWidth() + 6, rd.height)

    local cb2 = BBF.CreateCheckbox(info.key2, "", parentCb or row, nil)
    cb2:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    cb2:HookScript("OnClick", function(self, btn)
        if btn == "RightButton" then
            self:SetChecked(not self:GetChecked())
            TriggerRightClick(info, tf2 or self, info.key2, info.label2)
        end
    end)
    cb2.associatedTitle = title2
    StyleCheckbox(cb2)
    cb2:SetPoint("LEFT", title2, "RIGHT", 6, 0)
    if cb2.UpdateEnabledState then cb2:UpdateEnabledState() end

    tf2:EnableMouse(true)
    tf2:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" and cb2:IsEnabled() then cb2:Click("LeftButton")
        elseif btn == "RightButton" and BBF.HandleRightClick then BBF.HandleRightClick(info.key2, info.label2, tf2) end
    end)
    if info.tooltip2 and info.tooltip2 ~= "" then
        BBF.CreateTooltipTwo(tf2, info.label2, info.tooltip2)
        BBF.CreateTooltipTwo(cb2, info.label2, info.tooltip2)
    end

    HookHighlight(tf1, updateHL) HookHighlight(cb1, updateHL)
    HookHighlight(tf2, updateHL) HookHighlight(cb2, updateHL)

    card.currentY = card.currentY - rd.height - rd.gap
    card:SetHeight(-card.currentY + 6)
    return cb1, cb2
end

local function BuildMultiParentChildRow(card, info, parentCbs)
    local rc = T.Row.checkbox

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", rc.leftInsetChild, card.currentY)
    row:SetSize(card.cardWidth - rc.widthShrinkChild, rc.height)
    local _, updateHL = AddRowHighlight(row)

    local title = row:CreateFontString(nil, "OVERLAY", rc.titleFontChild)
    title:SetPoint("LEFT", row, "LEFT", rc.titleOffsetLeft, 0)
    title:SetText(info.label)
    title:SetWidth(rc.titleWidthChild)
    title:SetJustifyH("LEFT")

    local titleFrame = CreateFrame("Frame", nil, row)
    titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
    titleFrame:SetSize(math.min(title:GetStringWidth() + 10, rc.titleWidthChild), rc.height)

    local cb = BBF.CreateCheckbox(info.key, "", row, nil, info.onChange)
    cb.associatedTitle    = title
    cb.associatedRow      = row
    cb.parentCheckButtons = parentCbs
    for _, parentCB in ipairs(parentCbs) do
        parentCB.childrenCheckButtons = parentCB.childrenCheckButtons or {}
        table.insert(parentCB.childrenCheckButtons, cb)
    end
    StyleCheckbox(cb)
    cb:SetPoint("RIGHT", row, "RIGHT", rc.cbOffsetRight, 0)
    if cb.UpdateEnabledState then cb:UpdateEnabledState() end

    titleFrame:EnableMouse(true)
    titleFrame:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" and cb:IsEnabled() then cb:Click("LeftButton")
        elseif btn == "RightButton" and BBF.HandleRightClick then BBF.HandleRightClick(info.key, info.label, titleFrame) end
    end)
    if info.tooltip and info.tooltip ~= "" then
        BBF.CreateTooltipTwo(titleFrame, info.label, info.tooltip)
        BBF.CreateTooltipTwo(cb,         info.label, info.tooltip)
    end

    HookHighlight(titleFrame, updateHL)
    HookHighlight(cb, updateHL)

    card.currentY = card.currentY - rc.height - rc.gap
    card:SetHeight(-card.currentY + 6)
    return cb
end

local function BuildSectionHeaderRow(card, info)
    local rh = T.Row.header
    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", rh.leftInset, card.currentY)
    row:SetSize(card.cardWidth - 12, rh.height)
    local title = row:CreateFontString(nil, "OVERLAY", rh.font)
    title:SetPoint("LEFT", row, "LEFT", rh.titleOffsetLeft, 0)
    title:SetText(info.label or "")
    card.currentY = card.currentY - (rh.height + rh.gap)
    card:SetHeight(-card.currentY + 6)
    return title
end

local function ResolveTextureFromInfo(info)
    if not info then return nil, nil end
    if info.atlas then
        return "atlas", info.atlas
    elseif info.icon or info.texture then
        return "texture", info.icon or info.texture
    elseif info.spell then
        local spellID = tonumber(info.spell) or info.spell
        local tex = (C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(spellID)) or (GetSpellTexture and GetSpellTexture(spellID))
        if tex then
            return "texture", tex
        end
    end
    return nil, nil
end

local function BuildPreviewRow(card, info)
    local cw = info.previewWidth  or 260
    local ch = info.previewHeight or 56

    local frame = CreateFrame("Frame", nil, card, "BackdropTemplate")
    frame:SetSize(cw, ch)
    frame:SetPoint("TOP", card, "TOP", 0, card.currentY - 4)
    frame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    frame:SetBackdropColor(0, 0, 0, 0.6)
    frame:SetBackdropBorderColor(0.3, 0.3, 0.35, 0.8)

    local tex = frame:CreateTexture(nil, "ARTWORK")
    local tType, tVal = ResolveTextureFromInfo(info)
    if tType == "atlas" then
        tex:SetAtlas(tVal)
    elseif tType == "texture" then
        tex:SetTexture(tVal)
    end
    tex:SetSize(info.texWidth or 180, info.texHeight or 18)
    tex:SetPoint("CENTER", frame, "CENTER", 0, 0)
    if info.desaturated then tex:SetDesaturated(true) end
    if info.color then tex:SetVertexColor(unpack(info.color)) end

    card.currentY = card.currentY - ch - 12
    card:SetHeight(-card.currentY + 6)
    return tex
end

-- ============================================================
-- CARD BUILDER
-- ============================================================

local function BuildCard(parentFrame, titleText, anchorFrame, yOffset)
    local tc = T.Card
    local cardWidth = tc.defaultWidth

    local header = parentFrame:CreateFontString(nil, "OVERLAY", tc.header.font)
    if anchorFrame then
        header:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, yOffset or tc.header.betweenCards)
    else
        header:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 2, yOffset or tc.header.firstCardY)
    end
    header:SetText(titleText)
    header:SetTextColor(unpack(tc.header.color))

    local card = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")
    card:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, tc.header.gapBelowHeader)
    card:SetWidth(cardWidth)
    card:SetBackdrop(tc.backdrop)
    card:SetBackdropColor(unpack(tc.bgColor))
    card:SetBackdropBorderColor(unpack(tc.borderColor))

    card.header    = header
    card.currentY  = tc.cursorStart
    card.cardWidth = cardWidth
    return card
end

local function FinalizeCardLayout(cf, lastCard)
    local sf = cf:GetParent()
    local function UpdateHeight()
        if cf:GetTop() and lastCard and lastCard:GetBottom() then
            local contentHeight = (cf:GetTop() - lastCard:GetBottom()) + 20
            cf:SetHeight(math.max(contentHeight, T.ScrollChild.minHeight))
        end
    end
    UpdateHeight()
    C_Timer.After(0.01, UpdateHeight)
    C_Timer.After(0.1, UpdateHeight)
    if sf then sf:HookScript("OnShow", UpdateHeight) end
end

-- ============================================================
-- OPTION DISPATCHER
-- ============================================================

local function BuildOption(card, info, resolvedRefs)
    local t = info.type

    if t == "checkbox" or t == "childcheckbox" or t == "multiparentchild" then
        local parents = {}
        if info.parents then
            for _, pid in ipairs(info.parents) do
                if resolvedRefs[pid] then table.insert(parents, resolvedRefs[pid]) end
            end
        end

        local targetKey
        if type(info.inverseParent) == "string" then
            targetKey = info.inverseParent
        elseif type(info.disableTarget) == "string" then
            targetKey = info.disableTarget
        elseif info.inverseParent == true or info.disableTarget == true then
            targetKey = info.parent
        end

        local targetWidget = targetKey and resolvedRefs[targetKey]
        local parentCb = info._parentCb or (not info.inverseParent and not info.disableTarget and info.parent and resolvedRefs[info.parent])

        local cb
        if #parents > 0 then
            cb = BuildMultiParentChildRow(card, info, parents)
        else
            cb = BuildCheckboxRow(card, info, parentCb)
        end

        if info.id then resolvedRefs[info.id] = cb end
        if info.key then resolvedRefs[info.key] = cb end

        if targetWidget then
            local function UpdateInverseState()
                local isChecked = cb:GetChecked()
                SetWidgetState(cb, true)
                SetWidgetState(targetWidget, not isChecked)
            end
            cb:HookScript("OnClick", UpdateInverseState)
            UpdateInverseState()
        end

        -- Recurse into nested children
        if info.children then
            for _, childInfo in ipairs(info.children) do
                local merged = {}
                for k, v in pairs(childInfo) do merged[k] = v end
                merged._parentCb = cb
                BuildOption(card, merged, resolvedRefs)
            end
        end
        return cb

    elseif t == "slider" then
        local parentCb = info._parentCb or (info.parent and resolvedRefs[info.parent]) 
        local sl = BuildSliderRow(card, info, parentCb)
        if info.id then resolvedRefs[info.id] = sl end
        if info.key then resolvedRefs[info.key] = sl end
        return sl

    elseif t == "dualchild" then
        local parentCb = info._parentCb or (info.parent and resolvedRefs[info.parent]) 
        local cb1, cb2 = BuildDualChildCheckboxRow(card, info, parentCb)
        if info.id1 then resolvedRefs[info.id1] = cb1 end
        if info.id2 then resolvedRefs[info.id2] = cb2 end
        return cb1, cb2

    elseif t == "header" then
        return BuildSectionHeaderRow(card, info)

    elseif t == "preview" or t == "frameBox" or t == "previewBox" then
        return BuildPreviewRow(card, info)
    end
end

-- ============================================================
-- ICON HELPER
-- ============================================================

local function ResolveTextureFromInfo(info)
    if info.atlas then
        return "atlas", info.atlas
    elseif info.icon or info.texture then
        return "texture", info.icon or info.texture
    elseif info.spell then
        local spellID = tonumber(info.spell) or info.spell
        local tex = (C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(spellID)) or (GetSpellTexture and GetSpellTexture(spellID))
        if tex then
            return "texture", tex
        end
    end
    return nil, nil
end

local function ApplyIconToFrame(iconFrame, cat)
    local iconTex = iconFrame:CreateTexture(nil, "ARTWORK")
    local w, h = unpack(cat.atlasSize or cat.size or {20, 20})
    iconTex:SetSize(w, h)
    iconTex:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)

    local tType, tVal = ResolveTextureFromInfo(cat)
    if tType == "atlas" then
        iconTex:SetAtlas(tVal)
    elseif tType == "texture" then
        iconTex:SetTexture(tVal)
    end

    if cat.atlasDesaturated or cat.desaturated then iconTex:SetDesaturated(true) end
    if cat.atlasColor or cat.color then iconTex:SetVertexColor(unpack(cat.atlasColor or cat.color)) end

    if cat.overlays then
        for _, ov in ipairs(cat.overlays) do
            local ovTex = iconFrame:CreateTexture(nil, ov.layer or "OVERLAY")
            local ow, oh = unpack(ov.size or {20, 20})
            ovTex:SetSize(ow, oh)
            local ox, oy = unpack(ov.offset or {0, 0})
            ovTex:SetPoint("CENTER", iconTex, "CENTER", ox, oy)
            local ovType, ovVal = ResolveTextureFromInfo(ov)
            if ovType == "atlas" then
                ovTex:SetAtlas(ovVal)
            elseif ovType == "texture" then
                ovTex:SetTexture(ovVal)
            end
            if ov.desaturated then ovTex:SetDesaturated(true) end
            if ov.color then ovTex:SetVertexColor(unpack(ov.color)) end
        end
    end
end

-- ============================================================
-- MAIN ENTRY POINT
-- ============================================================


-- ============================================================
-- POPUP WINDOW SCHEMA ENGINE
-- ============================================================



local function ParseMargin(opt)
    local mTop, mRight, mBottom, mLeft = 0, 0, 0, 0
    if type(opt.margin) == "table" then
        mTop    = tonumber(opt.margin[1] or opt.margin.top)    or 0
        mRight  = tonumber(opt.margin[2] or opt.margin.right)  or 0
        mBottom = tonumber(opt.margin[3] or opt.margin.bottom) or 0
        mLeft   = tonumber(opt.margin[4] or opt.margin.left)   or 0
    elseif type(opt.margin) == "number" then
        mTop, mRight, mBottom, mLeft = opt.margin, opt.margin, opt.margin, opt.margin
    end
    mTop    = mTop    + (tonumber(opt.marginTop)    or 0)
    mRight  = mRight  + (tonumber(opt.marginRight)  or 0)
    mBottom = mBottom + (tonumber(opt.marginBottom) or 0)
    mLeft   = mLeft   + (tonumber(opt.marginLeft)   or 0)
    return mTop, mRight, mBottom, mLeft
end



local function CalculateGridCoords(cIdx, cData, numItems, opt)
    local specifiedRows = tonumber(opt.rows or opt.row)
    local specifiedCols = tonumber(opt.cols or opt.columns)

    local numCols = specifiedCols
    if not numCols then
        if specifiedRows and specifiedRows > 0 then
            numCols = math.ceil(numItems / specifiedRows)
        else
            numCols = 3
        end
    end
    numCols = math.max(1, numCols)

    local colIndex
    if tonumber(cData.col or cData.column) then
        colIndex = tonumber(cData.col or cData.column) - 1
    else
        colIndex = math.floor((cIdx - 1) % numCols)
    end

    local rowIndex
    if tonumber(cData.row or cData.rows) then
        rowIndex = tonumber(cData.row or cData.rows) - 1
    else
        rowIndex = math.floor((cIdx - 1) / numCols)
    end

    return colIndex, rowIndex, numCols
end

local popupFrames = {}


local function BuildColorSwatchBtn(parent, posX, posY, dbKey, labelStr, defaultColor, maxTextWidth, callback, ttTitle, ttDesc)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(18, 18)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    local swatch = btn:CreateTexture(nil, "OVERLAY")
    swatch:SetAllPoints()
    swatch:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")

    local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    txt:SetPoint("LEFT", btn, "RIGHT", 4, 0)
    if maxTextWidth then
        txt:SetWidth(maxTextWidth)
        txt:SetWordWrap(true)
        txt:SetJustifyH("LEFT")
    end
    txt:SetText(labelStr)
    btn:SetHitRectInsets(0, -(maxTextWidth or 70), 0, 0)

    local titleText = ttTitle or labelStr
    local descText  = ttDesc  or BBF.L["Tooltip_Color_Picker_Desc"]
    if BBF.CreateTooltipTwo then
        BBF.CreateTooltipTwo(btn, titleText, descText, nil, "ANCHOR_RIGHT")
    end

    local function RefreshSwatch()
        local col = BetterBlizzFramesDB[dbKey] or defaultColor or {r = 1, g = 1, b = 1}
        local r = col.r or col[1] or 1
        local g = col.g or col[2] or 1
        local b = col.b or col[3] or 1
        swatch:SetVertexColor(r, g, b)
    end
    RefreshSwatch()

    btn:SetScript("OnClick", function(self, mouseButton)
        if mouseButton == "RightButton" and IsShiftKeyDown() then
            BetterBlizzFramesDB[dbKey] = nil
            RefreshSwatch()
            if callback then callback() end
            if BBF.UpdateFrames then BBF.UpdateFrames() end
            return
        end

        local col = BetterBlizzFramesDB[dbKey] or defaultColor or {r = 1, g = 1, b = 1}
        local r = col.r or col[1] or 1
        local g = col.g or col[2] or 1
        local b = col.b or col[3] or 1

        local info = {
            r = r, g = g, b = b,
            hasOpacity = false,
            swatchFunc = function()
                local nr, ng, nb = ColorPickerFrame:GetColorRGB()
                BetterBlizzFramesDB[dbKey] = { nr, ng, nb, r = nr, g = ng, b = nb }
                swatch:SetVertexColor(nr, ng, nb)
                if callback then callback() end
                if BBF.UpdateFrames then BBF.UpdateFrames() end
            end,
            cancelFunc = function(prev)
                local pr, pg, pb = prev.r or prev[1], prev.g or prev[2], prev.b or prev[3]
                BetterBlizzFramesDB[dbKey] = { pr, pg, pb, r = pr, g = pg, b = pb }
                swatch:SetVertexColor(pr, pg, pb)
                if callback then callback() end
                if BBF.UpdateFrames then BBF.UpdateFrames() end
            end
        }
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end)

    return btn, RefreshSwatch
end

function GUI.OpenPopup(popupId, schema)
    schema = schema or (GUI.Popups and GUI.Popups[popupId])
    if not schema then return end
    local tp = T.Popup
    local L  = BBF.L

    if not popupFrames[popupId] then
        local frameTemplate = schema.template or tp.template
        local frame = CreateFrame("Frame", schema.id or ("BBF_Popup_" .. popupId), UIParent, frameTemplate)
        tinsert(UISpecialFrames, frame:GetName())
        ButtonFrameTemplate_HidePortrait(frame)
        if frame.Inset then frame.Inset:Hide() end
        if frame.Bg then frame.Bg:SetColorTexture(unpack(tp.bgColor)) end
        frame:SetSize(schema.width or tp.defaultWidth, schema.height or tp.defaultHeight)
        frame:SetPoint("CENTER")
        frame:SetFrameStrata(tp.strata)
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
        if frame.SetTitle then
            frame:SetTitle(schema.title or "")
        else
            frame.title = frame:CreateFontString(nil, "OVERLAY", tp.titleFont)
            frame.title:SetPoint("TOP", frame, "TOP", 0, tp.titleOffsetY)
            frame.title:SetText(schema.title or "")
        end

        local contentParent = frame
        if schema.scrollable then
            local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "ScrollFrameTemplate")
            scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -30)
            scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)
            contentParent = CreateFrame("Frame", nil, scrollFrame)
            contentParent:SetSize(schema.width and (schema.width - 45) or 315, 780)
            scrollFrame:SetScrollChild(contentParent)
        end

        local currentY = schema.scrollable and -10 or tp.startY
        local createdWidgets = {}

        local function RenderPopupOption(opt, parentCb)
            local t = opt.type
            local mTop, mRight, mBottom, mLeft = ParseMargin(opt)
            if mTop > 0 then currentY = currentY - mTop end

            local parentKey = opt.parent
            if not parentCb and parentKey and createdWidgets[parentKey] then
                parentCb = createdWidgets[parentKey]
            end
            local isChild = parentCb ~= nil
            local indentX = (isChild and ((parentCb.indentX or 0) + 16) or 0) + mLeft

            if t == "header" then
                local header = contentParent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                header:SetPoint("TOPLEFT", contentParent, "TOPLEFT", 10 + indentX, currentY)
                header:SetText(opt.label)
                currentY = currentY - 22

            elseif t == "checkbox" or t == "classCheckbox" then
                local rowFrame = CreateFrame("Frame", nil, contentParent)
                rowFrame:SetHeight(30)
                rowFrame:SetPoint("TOPLEFT", contentParent, "TOPLEFT", 10 + indentX, currentY)
                rowFrame:SetPoint("TOPRIGHT", contentParent, "TOPRIGHT", -10, currentY)

                local rowHighlight = rowFrame:CreateTexture(nil, "BACKGROUND")
                rowHighlight:SetAllPoints()
                rowHighlight:SetAtlas(tp.highlightAtlas)
                if not rowHighlight:GetTexture() then rowHighlight:SetColorTexture(1, 1, 1, 0.12) end
                rowHighlight:SetBlendMode(tp.highlightBlend)
                rowHighlight:Hide()

                local cb = CreateFrame("CheckButton", nil, rowFrame, "SettingsCheckboxTemplate")
                if cb:GetHighlightTexture() then
                    cb:GetHighlightTexture():SetTexture("")
                    cb:GetHighlightTexture():SetAlpha(0)
                    cb:GetHighlightTexture():Hide()
                    cb:GetHighlightTexture().Show = function() end
                end
                if cb.HoverBackground then
                    cb.HoverBackground:SetAlpha(0)
                    cb.HoverBackground:Hide()
                    cb.HoverBackground.Show = function() end
                end

                local function UpdateHighlight()
                    if MouseIsOver(rowFrame) then rowHighlight:Show() else rowHighlight:Hide() end
                end

                cb:SetSize(tp.checkboxSize, tp.checkboxSize)
                cb:SetPoint("LEFT", rowFrame, "LEFT", 5, 0)

                local labelText = opt.label
                local textColor = nil
                if t == "classCheckbox" and opt.classID then
                    local localizedClassName, classTag = GetClassInfo(opt.classID)
                    labelText = string.format(L["Ignore_Class"], localizedClassName or "")
                    textColor = RAID_CLASS_COLORS[classTag] or opt.color
                end

                if not cb.Text then
                    cb.Text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    cb.Text:SetPoint("LEFT", cb, "RIGHT", 6, 0)
                end
                cb.Text:SetText(labelText or "")
                if textColor then
                    cb.Text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1)
                end

                cb:SetChecked(BetterBlizzFramesDB[opt.key])
                cb:SetScript("OnClick", function(self)
                    BetterBlizzFramesDB[opt.key] = self:GetChecked() or nil
                    if opt.onChange then opt.onChange() end
                    if BBF.UpdateFrames then BBF.UpdateFrames() end
                    if BBF.HideFrames then BBF.HideFrames() end
                end)

                cb.indentX = indentX
                cb.lastPosY = currentY
                if opt.key then createdWidgets[opt.key] = cb end
                if opt.id then createdWidgets[opt.id] = cb end

                if isChild then
                    cb.associatedTitle = cb.Text
                    cb.associatedRow   = rowFrame
                    WireChildToParent(parentCb, cb, cb.Text)
                end

                if opt.tooltip then
                    if BBF.CreateTooltipTwo then
                        BBF.CreateTooltipTwo(cb, opt.label, opt.tooltip, nil, "ANCHOR_RIGHT")
                        BBF.CreateTooltipTwo(rowFrame, opt.label, opt.tooltip, nil, "ANCHOR_RIGHT")
                    end
                end

                rowFrame:EnableMouse(true)
                rowFrame:SetScript("OnEnter", UpdateHighlight)
                rowFrame:SetScript("OnLeave", UpdateHighlight)
                rowFrame:SetScript("OnMouseDown", function() if cb:IsEnabled() then cb:Click() end end)
                cb:HookScript("OnEnter", UpdateHighlight)
                cb:HookScript("OnLeave", UpdateHighlight)

                currentY = currentY - 32

                if opt.children then
                    for _, childOpt in ipairs(opt.children) do
                        RenderPopupOption(childOpt, cb)
                    end
                end

            elseif t == "colorGrid" then
                local isInline = opt.inline ~= nil and opt.inline ~= false
                local refWidget = (type(opt.inline) == "string" and createdWidgets[opt.inline]) or parentCb

                local vMidOffset = 0
                if isInline and refWidget then
                    local refH = (refWidget.associatedRow and refWidget.associatedRow:GetHeight()) or (refWidget.GetHeight and refWidget:GetHeight()) or 30
                    local itemH = 18
                    vMidOffset = math.floor((refH - itemH) / 2)
                end

                local startY = (isInline and refWidget and (refWidget.lastPosY - vMidOffset)) or currentY
                local savedY = currentY
                local basePosX = (isInline and (opt.inlineX or (160 + indentX))) or (10 + indentX)

                local cols = opt.options or {}
                local numItems = #cols
                local rowHeight = tonumber(opt.rowHeight) or 28
                local maxRow = 0

                for cIdx, cData in ipairs(cols) do
                    local colIndex, rowIndex, numCols = CalculateGridCoords(cIdx, cData, numItems, opt)
                    if rowIndex > maxRow then maxRow = rowIndex end

                    local availWidth = (315 - indentX) - 20
                    local colWidth = tonumber(opt.colWidth) or math.floor(availWidth / numCols)
                    local posX = basePosX + colIndex * colWidth
                    local posY = startY - rowIndex * rowHeight
                    local labelW = opt.maxTextWidth or (colWidth - 26)

                    local dbKey = cData.key
                    if RAID_CLASS_COLORS[dbKey] and not dbKey:find("^classColor") then
                        dbKey = "classColor" .. dbKey
                    elseif (dbKey == "MANA" or dbKey == "RAGE" or dbKey == "FOCUS" or dbKey == "ENERGY" or dbKey == "RUNIC_POWER" or dbKey == "LUNAR_POWER" or dbKey == "MAELSTROM" or dbKey == "INSANITY" or dbKey == "CHI" or dbKey == "FURY" or dbKey == "EBON_MIGHT" or dbKey == "STAGGER" or dbKey == "SOUL_FRAGMENTS" or dbKey == "SOUL_SHARDS") and not dbKey:find("^powerColor") then
                        dbKey = "powerColor" .. dbKey
                    end
                    local defColor = cData.default or cData.color
                    if not defColor and RAID_CLASS_COLORS[cData.key] then
                        local rc = RAID_CLASS_COLORS[cData.key]
                        defColor = { r = rc.r, g = rc.g, b = rc.b }
                    end
                    local btn = BuildColorSwatchBtn(contentParent, posX, posY, dbKey, cData.label or cData.key, defColor, labelW, cData.onChange, cData.tooltipTitle or opt.tooltipTitle, cData.tooltip or opt.tooltip)
                    if isChild and parentCb then
                        WireChildToParent(parentCb, btn, nil)
                    end
                end
                if isInline then
                    currentY = savedY
                else
                    currentY = startY - (maxRow + 1) * rowHeight
                end

            elseif t == "allClassSwatches" then
                local classes = opt.classes or opt.options
                if not classes then
                    classes = {}
                    for classID = 1, GetNumClasses() do
                        local localizedClassName, classTag = GetClassInfo(classID)
                        if classTag and localizedClassName then
                            table.insert(classes, {key = classTag, name = localizedClassName, classID = classID})
                        end
                    end
                    table.sort(classes, function(a, b) return a.classID < b.classID end)
                end

                local numItems  = #classes
                local rowHeight = tonumber(opt.rowHeight) or 28
                local gridStartY = currentY
                local maxRow    = 0

                for cIdx, classData in ipairs(classes) do
                    local classTag = classData.key
                    local className = classData.name or classData.label
                    if not className then
                        local locName = GetClassInfo(classData.classID or cIdx)
                        className = locName or classTag
                    end

                    local colIndex, rowIndex, numCols = CalculateGridCoords(cIdx, classData, numItems, opt)
                    if rowIndex > maxRow then maxRow = rowIndex end

                    local colWidth = tonumber(opt.colWidth) or math.floor(((315 - indentX) - 20) / numCols)
                    local posX = 10 + indentX + colIndex * colWidth
                    local posY = gridStartY - rowIndex * rowHeight
                    local rawColor = classData.default or classData.color or RAID_CLASS_COLORS[classTag] or {r = 1, g = 1, b = 1}
                    local classDefColor = { r = rawColor.r or rawColor[1] or 1, g = rawColor.g or rawColor[2] or 1, b = rawColor.b or rawColor[3] or 1 }

                    local btn = BuildColorSwatchBtn(contentParent, posX, posY, "classColor" .. classTag, className, classDefColor, colWidth - 26, classData.onChange)
                    if isChild and parentCb then
                        WireChildToParent(parentCb, btn, nil)
                    end
                end
                currentY = gridStartY - (maxRow + 1) * rowHeight - 12

            elseif t == "allPowerSwatches" then
                local powerTypes = opt.powers or opt.options
                if not powerTypes then
                    powerTypes = {
                        { key = "MANA", color = {r = 0, g = 0.5, b = 1} },
                        { key = "RAGE", color = {r = 1, g = 0, b = 0} },
                        { key = "FOCUS", color = {r = 1, g = 0.5, b = 0.25} },
                        { key = "ENERGY", color = {r = 1, g = 1, b = 0} },
                        { key = "RUNIC_POWER", color = {r = 0, g = 0.82, b = 1} },
                        { key = "LUNAR_POWER", color = {r = 0, g = 0.9, b = 1} },
                        { key = "MAELSTROM", color = {r = 0, g = 0.5, b = 1} },
                        { key = "INSANITY", color = {r = 0.4, g = 0, b = 0.8} },
                        { key = "CHI", color = {r = 0.71, g = 1, b = 0.92} },
                        { key = "FURY", color = {r = 0.788, g = 0.259, b = 0.992} },
                        { key = "EBON_MIGHT", spellID = 395152, color = {r = 0.2, g = 0.58, b = 0.5} },
                        { key = "STAGGER", color = {r = 0.52, g = 1, b = 0.52} },
                        { key = "SOUL_FRAGMENTS", spellID = 71905, color = {r = 0.35, g = 0.25, b = 0.73} },
                        --{ key = "SOUL_SHARDS", spellID = 246985, color = {r = 0.64, g = 0.2, b = 0.93} },
                    }
                end

                local numItems  = #powerTypes
                local rowHeight = tonumber(opt.rowHeight) or 28
                local pGridStartY = currentY
                local maxRow    = 0

                for pIdx, pData in ipairs(powerTypes) do
                    local colIndex, rowIndex, numCols = CalculateGridCoords(pIdx, pData, numItems, opt)
                    if rowIndex > maxRow then maxRow = rowIndex end

                    local colWidth = tonumber(opt.colWidth) or math.floor(((315 - indentX) - 20) / numCols)
                    local posX = 10 + indentX + colIndex * colWidth
                    local posY = pGridStartY - rowIndex * rowHeight

                    local labelName = pData.name or pData.label or pData.key
                    if _G[pData.key] then labelName = _G[pData.key]
                    elseif _G["POWER_TYPE_" .. pData.key] then labelName = _G["POWER_TYPE_" .. pData.key]
                    elseif pData.spellID and C_Spell and C_Spell.GetSpellName then
                        local sn = C_Spell.GetSpellName(pData.spellID)
                        if sn then labelName = sn end
                    end

                    local rawColor = pData.default or pData.color or {r = 1, g = 1, b = 1}
                    local pDefColor = { r = rawColor.r or rawColor[1] or 1, g = rawColor.g or rawColor[2] or 1, b = rawColor.b or rawColor[3] or 1 }
                    local powerOnChange = pData.onChange or function()
                        if BBF.UpdatePowerColorCache then BBF.UpdatePowerColorCache() end
                        if BBF.UpdateFrames then BBF.UpdateFrames() end
                    end
                    local btn = BuildColorSwatchBtn(contentParent, posX, posY, "powerColor" .. pData.key, labelName, pDefColor, colWidth - 26, powerOnChange)
                    if isChild and parentCb then
                        WireChildToParent(parentCb, btn, nil)
                    end
                end
                currentY = pGridStartY - (maxRow + 1) * rowHeight - 14

            elseif t == "colorSwatchDual" then
                local b1 = BuildColorSwatchBtn(contentParent, 26 + indentX, currentY, opt.key1, opt.label1, opt.default1, 100)
                local b2 = BuildColorSwatchBtn(contentParent, 146 + indentX, currentY, opt.key2, opt.label2, opt.default2, 100)
                if isChild and parentCb then
                    WireChildToParent(parentCb, b1, nil)
                    WireChildToParent(parentCb, b2, nil)
                end
                currentY = currentY - 28
            end
        end

        local function RenderPopupOptionWrapper(opt, parentCb)
            RenderPopupOption(opt, parentCb)
            local _, _, mBottom = ParseMargin(opt)
            if mBottom > 0 then currentY = currentY - mBottom end
        end

        for i, opt in ipairs(schema.options or {}) do
            RenderPopupOptionWrapper(opt, nil)
        end

if schema.scrollable and contentParent.SetHeight then
            contentParent:SetHeight(math.abs(currentY) + 30)
        end

        popupFrames[popupId] = frame
        frame:Show()
    else
        if popupFrames[popupId]:IsShown() then
            popupFrames[popupId]:Hide()
        else
            popupFrames[popupId]:Show()
        end
    end
end


function GUI.BuildPanel(panelFrame, schema)
    if schema.popups then
        GUI.Popups = GUI.Popups or {}
        for popId, popDef in pairs(schema.popups) do
            GUI.Popups[popId] = popDef
        end
    end

    local tt = T.Tab
    local ts = T.Sidebar
    local tc = T.Content

    local sidebar = CreateFrame("Frame", nil, panelFrame)
    sidebar:SetSize(ts.width, ts.height)
    sidebar:SetPoint("TOPLEFT", panelFrame, "TOPLEFT", ts.offsetX, ts.offsetY)

    local contentParent = CreateFrame("Frame", nil, panelFrame)
    contentParent:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", tc.gapLeft, 0)
    contentParent:SetPoint("BOTTOMRIGHT", panelFrame, "BOTTOMRIGHT", tc.marginRight, tc.marginBottom)

    local categoryFrames  = {}
    local categoryButtons = {}
    local tabs = schema.tabs or {}

    local function SelectCategory(catId)
        for id, sf in pairs(categoryFrames) do sf:Hide() end
        for id, btn in pairs(categoryButtons) do
            btn:SetBackdropBorderColor(unpack(tt.borderColor))
            btn:SetBackdropColor(unpack(tt.bgColor))
            btn.Text:SetTextColor(unpack(tt.textColor))
        end
        if categoryFrames[catId] then categoryFrames[catId]:Show() end
        if categoryButtons[catId] then
            categoryButtons[catId]:SetBackdropBorderColor(unpack(tt.borderColorActive))
            categoryButtons[catId]:SetBackdropColor(unpack(tt.bgColorActive))
            categoryButtons[catId].Text:SetTextColor(unpack(tt.textColorActive))
        end
    end

    for i, tab in ipairs(tabs) do
        local sf = CreateFrame("ScrollFrame", "BBF_MidnightGUI_" .. tab.id, contentParent, "ScrollFrameTemplate")
        sf:SetAllPoints(contentParent)
        sf:Hide()

        local cf = CreateFrame("Frame", nil, sf)
        cf:SetSize(T.ScrollChild.width, T.ScrollChild.minHeight)
        sf:SetScrollChild(cf)

        categoryFrames[tab.id] = sf
        sf.contentFrame = cf

        local btn = CreateFrame("Button", nil, sidebar, "BackdropTemplate")
        btn:SetSize(tt.width, tt.height)
        btn:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 0, -((i - 1) * tt.stride))
        btn:SetBackdrop(tt.backdrop)
        btn:SetBackdropColor(unpack(tt.bgColor))
        btn:SetBackdropBorderColor(unpack(tt.borderColor))

        local iconFrame = CreateFrame("Frame", nil, btn)
        iconFrame:SetSize(tt.iconFrameSize, tt.iconFrameSize)
        iconFrame:SetPoint("LEFT", btn, "LEFT", tt.iconOffsetLeft, 0)
        ApplyIconToFrame(iconFrame, tab)

        local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        txt:SetPoint("LEFT", iconFrame, "RIGHT", tt.textOffsetLeft, 0)
        txt:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
        txt:SetJustifyH("LEFT")
        txt:SetText(tab.label)
        txt:SetTextColor(unpack(tt.textColor))
        btn.Text = txt

        btn:SetScript("OnEnter", function(self)
            if categoryButtons[tab.id] ~= self then
                self:SetBackdropBorderColor(unpack(tt.borderColorHover))
                self.Text:SetTextColor(unpack(tt.textColorHover))
            end
        end)
        btn:SetScript("OnLeave", function(self)
            if categoryButtons[tab.id] ~= self then
                self:SetBackdropBorderColor(unpack(tt.borderColor))
                self.Text:SetTextColor(unpack(tt.textColor))
            end
        end)
        btn:SetScript("OnClick", function() SelectCategory(tab.id) end)

        categoryButtons[tab.id] = btn

        local lastCard    = nil
        local resolvedRefs = {}

        for _, cardDef in ipairs(tab.cards or {}) do
            local card = BuildCard(cf, cardDef.title, lastCard)
            for _, optInfo in ipairs(cardDef.options or {}) do
                BuildOption(card, optInfo, resolvedRefs)
            end
            lastCard = card
        end

        if lastCard then
            FinalizeCardLayout(cf, lastCard)
        end
    end

    if tabs[1] then
        SelectCategory(tabs[1].id)
    end

    schema._selectCategory  = SelectCategory
    schema._categoryFrames  = categoryFrames
    schema._categoryButtons = categoryButtons

    return sidebar, contentParent, categoryFrames, categoryButtons
end
