-- ============================================================
-- LibMidnightGUI-1.0: Pure Standalone Declarative WoW UI Engine
-- Designed for Modern WoW (Midnight / Retail) UI panels.
-- Clean, declarative, standalone UI constructor library.
-- ============================================================
local MAJOR = "LibMidnightGUI-1.0"
local MINOR = 1

local LibStub = _G.LibStub
local GUI
if LibStub then
    GUI = LibStub:NewLibrary(MAJOR, MINOR)
    if not GUI then return end
else
    GUI = _G.LibMidnightGUI or {}
end

_G.LibMidnightGUI = GUI
if _G.BBF then
    _G.BBF.GUI = GUI
end

GUI.Providers = GUI.Providers or {}

function GUI.RegisterProvider(name, providerFunc)
    GUI.Providers[name] = providerFunc
end

-- ============================================================
-- UNIVERSAL DATABASE & LOCALIZATION ACCESSORS
-- ============================================================

local function GetOptionValue(schema, key, defaultVal)
    if not key then return defaultVal end
    if schema and schema.get then
        local v = schema.get(key)
        if v ~= nil then return v end
    end
    if schema and schema.db and type(schema.db) == "table" then
        local v = schema.db[key]
        if v ~= nil then return v end
    end
    if _G.BetterBlizzFramesDB and type(_G.BetterBlizzFramesDB) == "table" then
        local v = _G.BetterBlizzFramesDB[key]
        if v ~= nil then return v end
    end
    return defaultVal
end

local function SetOptionValue(schema, key, val)
    if not key then return end
    if schema and schema.set then
        schema.set(key, val)
        return
    end
    if schema and schema.db and type(schema.db) == "table" then
        schema.db[key] = val
        return
    end
    if _G.BetterBlizzFramesDB and type(_G.BetterBlizzFramesDB) == "table" then
        _G.BetterBlizzFramesDB[key] = val
    end
end

local function ResolveText(schema, textOrKey)
    if not textOrKey then return "" end
    if type(textOrKey) ~= "string" then return tostring(textOrKey) end
    if schema and schema.L and schema.L[textOrKey] then
        return schema.L[textOrKey]
    end
    if schema and schema.locale and schema.locale[textOrKey] then
        return schema.locale[textOrKey]
    end
    if _G.BBF and _G.BBF.L and _G.BBF.L[textOrKey] then
        return _G.BBF.L[textOrKey]
    end
    return textOrKey
end

-- ============================================================
-- UNIVERSAL RELOAD POPUP & TOOLTIP ENGINE
-- ============================================================

if not _G.StaticPopupDialogs["MIDNIGHT_GUI_CONFIRM_RELOAD"] then
    _G.StaticPopupDialogs["MIDNIGHT_GUI_CONFIRM_RELOAD"] = {
        text = "Changing this setting requires a UI reload to take effect.",
        button1 = "Reload UI",
        button2 = "Later",
        OnAccept = function() _G.ReloadUI() end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1,
        preferredIndex = 3,
    }
end

local function ShowReloadPrompt()
    if _G.StaticPopup_Show then
        _G.StaticPopup_Show("MIDNIGHT_GUI_CONFIRM_RELOAD")
    end
end

local function GetDynamicTooltipExtra(key, label, info, tooltipExtra)
    if type(tooltipExtra) == "function" then
        local customText = tooltipExtra()
        if customText and customText ~= "" then
            return customText
        end
    end

    local L = _G.BBF and _G.BBF.L
    if not L then return nil end

    local DB = _G.BetterBlizzFramesDB
    if not DB then return nil end

    local green    = "|cff32f795"
    local babyBlue = "|cff7fc6ff"
    local yellow   = "|cffffff00"
    local orange   = "|cffffaa00"
    local reset    = "|r"
    local check    = " |A:ParagonReputation_Checkmark:15:15|a"

    -- 1. Format Numbers
    if key == "formatStatusBarText" or label == L["Format_Numbers"] then
        local text = "\n\n18800 K |A:glueannouncementpopup-arrow:20:20|a 18.8 M\n" .. green .. (L["Right_Click_Show_Extra_Decimal"] or "Right-click to show one extra decimal.") .. reset
        if DB.formatStatusBarTextExtraDecimals then
            text = text .. check
        end
        return text
    end

    -- 2. Class Color Health
    if key == "classColorFrames" or label == L["Class_Color_Health"] or label == L["Tooltip_Class_Color_Healthbars_Title"] then
        local text = "\n" .. green .. (L["Tooltip_Class_Color_Keep_Player"] or "Ctrl+Right-Click to keep PlayerFrame green.") .. reset
        if DB.classColorFramesSkipPlayer then
            text = text .. check
        end
        text = text .. "\n\n" .. babyBlue .. (L["Tooltip_Class_Color_Keep_Friendly"] or "Shift+Right-Click to keep Friendly units green.") .. reset
        if DB.classColorFramesSkipFriendly then
            text = text .. check
        end
        return text
    end

    -- 3. Custom Color Health & Mana
    if key == "customHealthbarColors" or label == L["Custom_Color_Health_Mana"] or label == L["Custom_Colors"] then
        local text = "\n" .. yellow .. (L["Right_Click_To_Open_Options"] or "Right-click to open options.") .. reset
        text = text .. "\n\n" .. green .. (L["Tooltip_Class_Color_Keep_Player"] or "Ctrl+Right-Click to keep PlayerFrame green.") .. reset
        if DB.classColorFramesSkipPlayer then
            text = text .. check
        end
        text = text .. "\n\n" .. babyBlue .. (L["Tooltip_Class_Color_Keep_Friendly"] or "Shift+Right-Click to keep Friendly units green.") .. reset
        if DB.classColorFramesSkipFriendly then
            text = text .. check
        end
        return text
    end

    -- 4. Hide Dispel Overlay
    if key == "hidePartyDispelOverlay" or label == L["Hide_Dispel_Overlay"] then
        local text = "\n" .. green .. (L["Right_Click_Keep_Dispel_Border"] or "Right-Click to Keep Dispel Border.") .. " |A:RaidFrame-DispelHighlight:15:30|a" .. reset
        if DB.hidePartyDispelOverlayKeepBorder then
            text = text .. check
        end
        text = text .. "\n\n" .. babyBlue .. (L["Shift_Right_Click_Keep_Dispel_Gradient"] or "Shift+Right-Click to Keep Dispel Gradient.") .. " |A:_RaidFrame-Dispel-Highlight-Horizontal:15:30|a" .. reset
        if DB.hidePartyDispelOverlayKeepGradient then
            text = text .. check
        end
        text = text .. "\n\n" .. orange .. (L["Ctrl_Right_Click_Hide_Dispel_Icons"] or "Ctrl+Right-Click to also Hide Dispel Icons.") .. " |A:RaidFrame-Icon-DebuffCurse:15:15|a" .. reset
        if DB.hidePartyDispelOverlayHideIcons then
            text = text .. check
        end
        return text
    end

    -- 5. Show Elite Texture (Player Frame)
    if key == "playerEliteFrame" or label == L["Show_Elite_Texture"] then
        if DB.playerEliteFrameDarkmode then
            return "\n" .. (L["Tooltip_Elite_Texture_Dark_Mode_Check"] or "Shift + Right-click to allow Dark Mode to color Elite texture") .. check
        else
            return "\n" .. (L["Tooltip_Elite_Texture_Dark_Mode"] or "Shift + Right-click to allow Dark Mode to color Elite texture")
        end
    end

    -- 6. Pixel Border (Raid / Party Frames)
    if key == "raidFramePixelBorder" or label == L["Pixel_Border"] or label == L["Tooltip_Pixel_Border_RaidFrames_Title"] then
        local activeSize = DB.raidFramePixelBorderSize and "1.5px" or "1px"
        return "\n" .. green .. "Right-click to toggle between 1px and 1.5px. Active: " .. activeSize .. reset
    end

    -- 7. Change Party Frame Alpha
    if key == "partyFrameRangeAlpha" or label == L["Change_Party_Frame_Alpha"] or label == L["Party_Frame_Alpha"] then
        local checkMark = DB.partyFrameRangeAlphaSolidBackground and check or ""
        return "\n" .. green .. (L["Tooltip_Party_Frame_Range_Alpha_Solid_Bg"] or "Right-click to toggle solid background") .. reset .. checkMark
    end

    -- 8. Dark Mode Auras
    if key == "darkModeUiAura" or (label == L["Auras"] and info and info.popup == nil) then
        local checkMark = DB.removeDebuffColorBorder and check or ""
        return "\n" .. green .. (L["Tooltip_Remove_Debuff_Color_Border_Toggle"] or "Right-click to remove debuff color border") .. reset .. checkMark
    end

    -- 9. Hide Player Power (onRightClick opens class specific window)
    if key == "hidePlayerPower" or label == L["Hide_Resource_Power"] then
        return "\n" .. yellow .. (L["Right_Click_To_Open_Options"] or "Right-click to open options.") .. reset
    end

    return nil
end

local function AttachTooltip(targetFrame, label, tooltip, subText, anchor, requiresReload, tooltipExtra, cpuUsage, cvarName, key, info)
    if not targetFrame then return end
    if not label and not tooltip then return end

    targetFrame:HookScript("OnEnter", function(self)
        _G.GameTooltip:SetOwner(self, anchor or "ANCHOR_RIGHT")
        _G.GameTooltip:ClearLines()
        if label and label ~= "" then
            _G.GameTooltip:AddLine(label, 1, 0.82, 0, true)
        end
        if tooltip and tooltip ~= "" then
            _G.GameTooltip:AddLine(tooltip, 1, 1, 1, true)
        end

        -- Dynamic extra tooltip lines (Right-click, Shift+Right-click, Ctrl+Right-click hints, etc.)
        local extraText = GetDynamicTooltipExtra(key, label, info, tooltipExtra)
        if extraText and extraText ~= "" then
            _G.GameTooltip:AddLine(extraText, 1, 1, 1, true)
        end

        if subText and subText ~= "" then
            _G.GameTooltip:AddLine("____________________________", 0.8, 0.8, 0.8, true)
            _G.GameTooltip:AddLine(subText, 0.8, 0.8, 0.8, true)
        end

        -- CVar name info line
        if cvarName and cvarName ~= "" then
            local L = _G.BBF and _G.BBF.L
            local cvarLabel = (L and L["Tooltip_Changes_CVar"]) or "Changes CVar: "
            _G.GameTooltip:AddDoubleLine(cvarLabel, cvarName, 0.2, 1, 0.6, 0.2, 1, 0.6)
        end

        -- CPU usage star rating
        if cpuUsage and cpuUsage > 0 then
            local star   = "|A:UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare-Star:16:16|a"
            local noStar = "|A:UI-HUD-UnitFrame-Target-PortraitOn-Boss-IconRing:16:16|a"
            local starString = ""
            for i = 1, 5 do
                starString = starString .. (i <= cpuUsage and star or noStar)
            end
            local L = _G.BBF and _G.BBF.L
            local cpuLabel = (L and L["CPU_Usage"]) or "CPU Usage:"
            _G.GameTooltip:AddDoubleLine(" ", " ")
            _G.GameTooltip:AddDoubleLine(cpuLabel, starString, 0.2, 1, 0.6, 0.2, 1, 0.6)
        end

        if requiresReload then
            _G.GameTooltip:AddLine("Requires UI Reload", 1, 0.2, 0.2, true)
        end
        _G.GameTooltip:Show()
    end)
    targetFrame:HookScript("OnLeave", function()
        _G.GameTooltip:Hide()
    end)
end


-- ============================================================
-- AUTONOMOUS WIDGET CONSTRUCTORS
-- ============================================================

local function CreateNativeCheckbox(parent, key, schema, onChange, extraOnClick)
    local cb = CreateFrame("CheckButton", nil, parent, "SettingsCheckboxTemplate")
    if StyleCheckbox then StyleCheckbox(cb) end
    cb:SetSize(28, 28)

    local initialVal = GetOptionValue(schema, key)
    cb:SetChecked(initialVal == true or initialVal == 1)

    cb:SetScript("OnClick", function(self, btn)
        local val = self:GetChecked()
        SetOptionValue(schema, key, val)
        if onChange then onChange(val) end
        if extraOnClick then extraOnClick(self, btn, val) end
    end)
    return cb
end

local function CreateNativeSlider(parent, minVal, maxVal, stepVal, key, schema, sliderWidth, isPercent, onChange, info)
    minVal  = minVal or (isPercent and 0 or 0)
    maxVal  = maxVal or (isPercent and 100 or 100)
    stepVal = stepVal or (isPercent and 1 or 1)

    local width  = (info and (info.width or info.size)) or sliderWidth or 145
    local height = (info and info.height) or 20

    local numSteps = math.max(1, math.floor(((maxVal - minVal) / stepVal) + 0.5))
    local initialVal = tonumber(GetOptionValue(schema, key, minVal)) or minVal

    local function FormatValue(val)
        val = tonumber(val) or 0
        if isPercent then
            return string.format("%d%%", math.floor(val + 0.5))
        elseif stepVal < 1 then
            return string.format("%.2f", val)
        else
            return tostring(math.floor(val + 0.5))
        end
    end

    local sliderFrame = CreateFrame("Frame", nil, parent, "MinimalSliderWithSteppersTemplate")
    sliderFrame:SetSize(width, height)

    -- Determine indicator text position (TOP, LEFT, RIGHT, BOTTOM)
    local rawPos = info and (info.indicatorPosition or info.labelPosition or info.textPosition or info.position or info.indicatorPoint)
    local indicatorPos = "TOP"
    if rawPos then
        if type(rawPos) == "string" then
            indicatorPos = rawPos:upper()
        else
            indicatorPos = tostring(rawPos):upper()
        end
    end

    local labelEnum
    if _G.MinimalSliderWithSteppersMixin and _G.MinimalSliderWithSteppersMixin.Label then
        if indicatorPos == "BOTTOM" then
            labelEnum = _G.MinimalSliderWithSteppersMixin.Label.Bottom or _G.MinimalSliderWithSteppersMixin.Label.Top
        elseif indicatorPos == "RIGHT" then
            labelEnum = _G.MinimalSliderWithSteppersMixin.Label.Right or _G.MinimalSliderWithSteppersMixin.Label.Top
        elseif indicatorPos == "LEFT" then
            labelEnum = _G.MinimalSliderWithSteppersMixin.Label.Left or _G.MinimalSliderWithSteppersMixin.Label.Top
        else
            labelEnum = _G.MinimalSliderWithSteppersMixin.Label.Top
        end
    end

    -- Formatters table for Blizzard's MinimalSliderWithSteppersMixin
    local formatters = {}
    if labelEnum then
        formatters[labelEnum] = function(val)
            return FormatValue(val)
        end
    end

    if sliderFrame.Init then
        sliderFrame:Init(initialVal, minVal, maxVal, numSteps, formatters)
    end
-- Direct numeric input EditBox on right-click
    local editBox = CreateFrame("EditBox", nil, sliderFrame, "InputBoxTemplate")
    editBox:SetAutoFocus(false)
    editBox:SetSize(48, 18)
    editBox:SetMultiLine(false)
    editBox:SetPoint("CENTER", sliderFrame, "CENTER", 0, 0)
    editBox:SetFrameStrata("DIALOG")
    editBox:Hide()

    -- Position indicator text on TOP, RIGHT, LEFT, or BOTTOM
    -- Recursively finds all FontStrings inside sliderFrame and subframes (e.g. sliderFrame.Slider)
    local function ApplyCustomPositionToLabel(lbl)
        if not lbl or lbl.inCustomSetPoint then return end
        if editBox and (lbl == editBox.Text or (lbl.GetParent and lbl:GetParent() == editBox)) then return end

        lbl.inCustomSetPoint = true
        lbl:ClearAllPoints()

        if indicatorPos == "RIGHT" then
            lbl:SetPoint("LEFT", sliderFrame, "RIGHT", 6, 0)
            lbl:SetJustifyH("LEFT")
        elseif indicatorPos == "LEFT" then
            lbl:SetPoint("RIGHT", sliderFrame, "LEFT", -6, 0)
            lbl:SetJustifyH("RIGHT")
        elseif indicatorPos == "BOTTOM" then
            lbl:SetPoint("TOP", sliderFrame, "BOTTOM", 0, -5)
            lbl:SetJustifyH("CENTER")
        else -- TOP (default)
            -- Positioned 5px above the sliderFrame (clean separation, no overlap)
            lbl:SetPoint("BOTTOM", sliderFrame, "TOP", 0, 5)
            lbl:SetJustifyH("CENTER")
        end
        lbl.inCustomSetPoint = nil
    end

    local function HookAndPositionAllLabels()
        local function Traverse(f)
            if not f then return end
            if f.GetRegions then
                for _, reg in ipairs({ f:GetRegions() }) do
                    if reg and reg:IsObjectType("FontString") then
                        ApplyCustomPositionToLabel(reg)
                        if not reg.isPositionHooked then
                            reg.isPositionHooked = true
                            hooksecurefunc(reg, "SetPoint", function(self)
                                ApplyCustomPositionToLabel(self)
                            end)
                        end
                    end
                end
            end
            if f.GetChildren then
                for _, child in ipairs({ f:GetChildren() }) do
                    Traverse(child)
                end
            end
        end
        Traverse(sliderFrame)
    end

    HookAndPositionAllLabels()
    sliderFrame:HookScript("OnShow", HookAndPositionAllLabels)

    local innerSlider = sliderFrame.Slider or sliderFrame

    if sliderFrame.RegisterCallback then
        sliderFrame:RegisterCallback("OnValueChanged", function(_, val)
            val = math.max(minVal, math.min(maxVal, val))
            SetOptionValue(schema, key, val)
            HookAndPositionAllLabels()
            if onChange then onChange(val) end
        end, sliderFrame)
    elseif innerSlider.SetScript then
        innerSlider:SetScript("OnValueChanged", function(self, val)
            SetOptionValue(schema, key, val)
            HookAndPositionAllLabels()
            if onChange then onChange(val) end
        end)
    end

    editBox:SetScript("OnEnterPressed", function(self)
        local num = tonumber(self:GetText())
        if num then
            num = math.max(minVal, math.min(maxVal, num))
            if sliderFrame.SetValue then
                sliderFrame:SetValue(num)
            elseif innerSlider.SetValue then
                innerSlider:SetValue(num)
            end
            SetOptionValue(schema, key, num)
            HookAndPositionAllLabels()
            if onChange then onChange(num) end
        end
        self:Hide()
    end)
    editBox:SetScript("OnEscapePressed", function(self) self:Hide() end)
    editBox:SetScript("OnEditFocusLost", function(self) self:Hide() end)

    sliderFrame:EnableMouse(true)
    sliderFrame:HookScript("OnMouseDown", function(self, btn)
        if btn == "RightButton" then
            local current = GetOptionValue(schema, key, initialVal)
            editBox:SetText(tostring(current))
            editBox:Show()
            editBox:SetFocus()
            editBox:HighlightText()
        end
    end)

return sliderFrame
end

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
        marginRight  = -12,
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
            sliderWidth       = 145,
            sliderOffsetRight = -8,
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

local classColors = RAID_CLASS_COLORS
local classKeys = {}
if classColors then
    for class in pairs(classColors) do
        table.insert(classKeys, class)
    end
end


local T = GUI.Theme

--------------------------------------------------------
-- UTILIDADES DE LAYOUT (margenes, altura, ancho disponible)
--------------------------------------------------------

local function ParseMargin(opt)
    local mTop, mRight, mBottom, mLeft = 0, 0, 0, 0
    if not opt then return mTop, mRight, mBottom, mLeft end
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

local function UpdateCardHeight(card)
    if not card then return end
    local extraPad = card.isSection and 0 or 6
    local mBottom = card.marginBottom or 0
    card:SetHeight(-card.currentY + extraPad + mBottom)
end

local function AdjustScrollBar(sf, offsetX)
    local sb = sf and (sf.ScrollBar or _G[(sf:GetName() or "") .. "ScrollBar"])
    if sb then
        sb:ClearAllPoints()
        sb:SetPoint("TOPLEFT", sf, "TOPRIGHT", offsetX or -5, -16)
        sb:SetPoint("BOTTOMLEFT", sf, "BOTTOMRIGHT", offsetX or -5, 16)
    end
end

local function GetAvailableContentWidth(panelFrame, hasTabs)
    local pWidth = (panelFrame and panelFrame:GetWidth() > 0) and panelFrame:GetWidth() or 650
    local ts = T.Sidebar
    local tc = T.Content

    if hasTabs then
        local leftOffset = ts.offsetX + ts.width + tc.gapLeft
        local rightMargin = math.abs(tc.marginRight)
        return math.max(300, pWidth - leftOffset - rightMargin)
    else
        local rightMargin = math.abs(tc.marginRight)
        return math.max(300, pWidth - 12 - rightMargin)
    end
end

--------------------------------------------------------
-- RESALTADO Y ESTADO DE WIDGETS (hover, enable/disable, padre-hijo)
--------------------------------------------------------


-- Recursively desaturates all textures within a slider frame tree
local function SetSliderDesaturated(sliderFrame, isDesaturated)
    if not sliderFrame then return end
    local function DesaturateTree(f)
        if not f then return end
        for _, reg in ipairs(f.GetRegions and { f:GetRegions() } or {}) do
            if reg and reg:IsObjectType("Texture") and reg.SetDesaturated then
                reg:SetDesaturated(isDesaturated)
            end
        end
        for _, child in ipairs(f.GetChildren and { f:GetChildren() } or {}) do
            DesaturateTree(child)
        end
    end
    DesaturateTree(sliderFrame)
end

-- Desaturates the checkbox box and check-mark textures
local function SetCheckboxDesaturated(cb, isDesaturated)
    if not cb then return end
    local function DesatTex(getter)
        local tex = cb[getter] and cb[getter](cb)
        if tex and tex.SetDesaturated then tex:SetDesaturated(isDesaturated) end
    end
    DesatTex("GetNormalTexture")
    DesatTex("GetCheckedTexture")
    for _, reg in ipairs(cb.GetRegions and { cb:GetRegions() } or {}) do
        if reg and reg:IsObjectType("Texture") and reg.SetDesaturated then
            reg:SetDesaturated(isDesaturated)
        end
    end
end

-- Shared: apply enable/disable interaction to a widget
local function ApplyWidgetEnabled(widget, enabled, titleFrame)
    if enabled then
        if widget.Enable        then widget:Enable()               end
        if widget.SetEnabled    then widget:SetEnabled(true)       end
    else
        if widget.Disable       then widget:Disable()              end
        if widget.SetEnabled    then widget:SetEnabled(false)      end
    end
    if widget.UpdateEnabledState              then widget:UpdateEnabledState()           end
    if titleFrame and titleFrame.EnableMouse  then titleFrame:EnableMouse(enabled)       end
end

local function SetWidgetState(widget, enabled)
    if not widget then return end
    local alpha        = enabled and 1.0 or ((T.Row and T.Row.disabledAlpha) or 0.6)
    local isDesaturated = not enabled
    local objType      = widget.GetObjectType and widget:GetObjectType() or ""
    local isSlider     = (widget.sliderFrame ~= nil) or (widget.Slider ~= nil) or (objType == "Slider")
    local isCheckbox   = (objType == "CheckButton") or (widget.GetChecked ~= nil)
    local tf           = widget.associatedTitleFrame

    if isSlider then
        -- Row and slider controls stay at full alpha; only label dims
        local row = widget.associatedRow
        if row and row ~= UIParent and row.SetAlpha then row:SetAlpha(1.0) end
        if widget.associatedTitle and widget.associatedTitle.SetAlpha then widget.associatedTitle:SetAlpha(alpha) end
        if tf and tf.SetAlpha then tf:SetAlpha(alpha) end
        if widget.SetAlpha then widget:SetAlpha(1.0) end

        local sf = widget.sliderFrame or widget
        if sf and sf.SetAlpha then sf:SetAlpha(1.0) end

        ApplyWidgetEnabled(widget, enabled, tf)
        if sf and sf ~= widget then
            if sf.SetEnabled                               then sf:SetEnabled(enabled)              end
            if sf.Back    and sf.Back.SetEnabled           then sf.Back:SetEnabled(enabled)         end
            if sf.Forward and sf.Forward.SetEnabled        then sf.Forward:SetEnabled(enabled)      end
        end
        SetSliderDesaturated(sf, isDesaturated)

    elseif isCheckbox then
        -- Checkbox box stays full alpha; only label dims
        local row = widget.associatedRow
        if row and row ~= UIParent and row.SetAlpha then row:SetAlpha(1.0) end
        if widget.associatedTitle and widget.associatedTitle.SetAlpha then widget.associatedTitle:SetAlpha(alpha) end
        if tf and tf.SetAlpha then tf:SetAlpha(alpha) end
        if widget.SetAlpha then widget:SetAlpha(1.0) end

        ApplyWidgetEnabled(widget, enabled, tf)
        SetCheckboxDesaturated(widget, isDesaturated)

    else
        -- Standard widgets (dropdowns, buttons, etc.): entire row dims
        local row = widget.associatedRow
        if row and row ~= UIParent and row.SetAlpha then row:SetAlpha(alpha) end
        if widget.SetAlpha then widget:SetAlpha(alpha) end

        ApplyWidgetEnabled(widget, enabled, tf)
        local tex = widget.GetNormalTexture and widget:GetNormalTexture()
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
    widget.UpdateParentDependency = UpdateState
    UpdateState()
end

-- ============================================================
-- ROW BUILDERS
-- ============================================================

--------------------------------------------------------
-- HELPERS DE CHECKBOX Y CLICK DERECHO
--------------------------------------------------------

--- Set checkbox size to match theme.
local function StyleCheckbox(cb)
    if not cb then return end
    cb:SetSize(T.Row.checkbox.cbSize or 24, T.Row.checkbox.cbSize or 24)
end


--- Trigger right-click action from schema onRightClick or popup or host addon fallback.
local function TriggerRightClick(info, widget, keyOverride, labelOverride)
    local key   = keyOverride   or info.key
    local label = labelOverride or info.label
    local isShift = IsShiftKeyDown()
    local isCtrl  = IsControlKeyDown()
    local isAlt   = IsAltKeyDown()

    if info.onRightClick then
        info.onRightClick(isShift, isCtrl, isAlt, widget, key, label)
    elseif info.popup and GUI.OpenPopup then
        GUI.OpenPopup(info.popup)
    elseif _G.BBF and _G.BBF.HandleRightClick then
        _G.BBF.HandleRightClick(key, label, widget)
    end

    -- Refresh GameTooltip immediately if hovering over the widget
    if widget and widget.IsMouseOver and widget:IsMouseOver() then
        local onEnter = widget:GetScript("OnEnter")
        if onEnter then
            onEnter(widget)
        end
    end
end

-- Forward declare so BuildCheckboxRow (and BuildDropdownRow) can call it
-- before the full definition further below.
local BuildColorSwatchBtn

--------------------------------------------------------
-- FILA: CHECKBOX (simple e hija)
--------------------------------------------------------

local function BuildCheckboxRow(card, info, parentCb, schema)
    local isChild      = (parentCb ~= nil) or (info.inverseParent ~= nil) or (info.disableTarget ~= nil)
    local rc           = T.Row.checkbox
    local leftInset    = isChild and rc.leftInsetChild   or rc.leftInset
    local widthShrink  = isChild and rc.widthShrinkChild  or rc.widthShrink
    local titleFont    = isChild and rc.titleFontChild    or rc.titleFont
    local titleWidth   = isChild and rc.titleWidthChild   or rc.titleWidth
    card.optionCount   = (card.optionCount or 0) + 1

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", leftInset, card.currentY)
    row:SetSize(card.cardWidth - widthShrink, rc.height)

    local title = row:CreateFontString(nil, "OVERLAY", titleFont)
    title:SetPoint("LEFT", row, "LEFT", rc.titleOffsetLeft, 0)
    title:SetText(ResolveText(schema, info.label))
    title:SetWidth(titleWidth)
    title:SetJustifyH("LEFT")

    local titleFrame = CreateFrame("Frame", nil, row)
    titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
    titleFrame:SetSize(math.min(title:GetStringWidth() + 10, titleWidth), rc.height)

    local cb = CreateNativeCheckbox(row, info.key, schema, info.onChange, function(self, btn, val)
        if btn == "RightButton" then
            self:SetChecked(not self:GetChecked())
            TriggerRightClick(info, titleFrame or self)
        else
            if info.requiresReload or info.reload then
                ShowReloadPrompt()
            end
        end
    end)
    cb:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    cb:SetPoint("RIGHT", row, "RIGHT", rc.cbOffsetRight, 0)

    -- colorPicker = {r, g, b} — inline color swatch anchored left of the checkbox toggle
    if info.colorPicker then
        local cpDefault = info.colorPicker
        local cpKey     = info.colorPickerKey or (info.key .. "Color")
        local swatchBtn = BuildColorSwatchBtn(row, 0, 0, cpKey, nil, {r = cpDefault.r or cpDefault[1] or 1, g = cpDefault.g or cpDefault[2] or 1, b = cpDefault.b or cpDefault[3] or 1}, nil, info.onChange, nil, nil, schema)
        swatchBtn:ClearAllPoints()
        swatchBtn:SetPoint("RIGHT", cb, "LEFT", -6, 0)
        swatchBtn:SetSize(16, 16)
        cb.colorSwatchBtn = swatchBtn
    end

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
        AttachTooltip(titleFrame, ResolveText(schema, info.label), ResolveText(schema, info.tooltip), ResolveText(schema, info.subText), nil, info.requiresReload or info.reload, info.tooltipExtra, info.cpuUsage, info.cvarName, info.key, info)
        AttachTooltip(cb,         ResolveText(schema, info.label), ResolveText(schema, info.tooltip), ResolveText(schema, info.subText), nil, info.requiresReload or info.reload, info.tooltipExtra, info.cpuUsage, info.cvarName, info.key, info)
    end



    card.currentY = card.currentY - rc.height - rc.gap
    UpdateCardHeight(card)
    return cb
end

--------------------------------------------------------
-- FILA: SLIDER
--------------------------------------------------------

local function BuildSliderRow(card, info, parentCb, schema)
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

    local isFirstOption = (card.optionCount == nil or card.optionCount == 0)
    card.optionCount    = (card.optionCount or 0) + 1

    local rawPos        = info and (info.indicatorPosition or info.labelPosition or info.textPosition or info.position or info.indicatorPoint)
    local indicatorPos  = rawPos and tostring(rawPos):upper() or "TOP"

    local topPadding    = (isFirstOption and indicatorPos == "TOP") and 14 or 0
    card.currentY       = card.currentY - topPadding

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", leftInset, card.currentY)
    row:SetSize(card.cardWidth - widthShrink, rs.height)

    local title = row:CreateFontString(nil, "OVERLAY", titleFont)
    title:SetPoint("LEFT", row, "LEFT", rs.titleOffsetLeft, 0)
    title:SetText(ResolveText(schema, info.label))
    title:SetWidth(titleWidth)
    title:SetJustifyH("LEFT")

    local titleFrame = CreateFrame("Frame", nil, row)
    titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
    titleFrame:SetSize(math.min(title:GetStringWidth() + 10, titleWidth), rs.height)

    local customWidth = info.width or info.size or rs.sliderWidth
    local slider = CreateNativeSlider(row, minVal, maxVal, stepVal, info.key, schema, customWidth, isPercent, function(val)
        if info.onChange then info.onChange(val) end
        if info.requiresReload or info.reload then ShowReloadPrompt() end
    end, info)

    local sliderRightOffset = rs.sliderOffsetRight
    if indicatorPos == "RIGHT" then
        sliderRightOffset = sliderRightOffset - 38
    end
    slider:SetPoint("RIGHT", row, "RIGHT", sliderRightOffset, 0)
    slider:EnableMouse(true)

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
        AttachTooltip(titleFrame, ResolveText(schema, info.label), ResolveText(schema, info.tooltip), ResolveText(schema, info.subText), nil, info.requiresReload or info.reload, info.tooltipExtra, info.cpuUsage, info.cvarName, info.key, info)
        AttachTooltip(slider,     ResolveText(schema, info.label), ResolveText(schema, info.tooltip), ResolveText(schema, info.subText), nil, info.requiresReload or info.reload, info.tooltipExtra, info.cpuUsage, info.cvarName, info.key, info)
    end



    card.currentY = card.currentY - rs.height - rs.gap
    UpdateCardHeight(card)
    return slider
end

--------------------------------------------------------
-- FILA: DROPDOWN (con soporte de fuentes/texturas via LSM)
--------------------------------------------------------

-- Anchor point presets (mirrors CreateAnchorDropdown in gui.lua)
local ANCHOR_PRESET_CHOICES = {
    { value = "CENTER", label = "Anchor_CENTER" },
    { value = "TOP",    label = "Anchor_TOP"    },
    { value = "LEFT",   label = "Anchor_LEFT"   },
    { value = "RIGHT",  label = "Anchor_RIGHT"  },
    { value = "BOTTOM", label = "Anchor_BOTTOM" },
}
local ANCHOR_INNER_OUTER_CHOICES = {
    { value = "TOP",    label = "Anchor_TOP"   },
    { value = "LEFT",   label = "Anchor_INNER" },
    { value = "RIGHT",  label = "Anchor_OUTER" },
    { value = "BOTTOM", label = "Anchor_BOTTOM"},
}

local function BuildDropdownRow(card, info, parentCb, schema)
    local isChild     = parentCb ~= nil
    local rs          = T.Row.slider   -- reuse slider row metrics
    local leftInset   = isChild and rs.leftInsetChild  or rs.leftInset
    local widthShrink = isChild and rs.widthShrinkChild or rs.widthShrink
    local titleFont   = isChild and rs.titleFontChild  or rs.titleFont
    local titleWidth  = isChild and rs.titleWidthChild or rs.titleWidth
    local L = (schema and schema.L) or (_G.BBF and _G.BBF.L)

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", leftInset, card.currentY)
    row:SetSize(card.cardWidth - widthShrink, rs.height)

    local title = row:CreateFontString(nil, "OVERLAY", titleFont)
    title:SetPoint("LEFT", row, "LEFT", rs.titleOffsetLeft, 0)
    title:SetText(info.label)
    title:SetWidth(titleWidth)
    title:SetJustifyH("LEFT")

    local titleFrame = CreateFrame("Frame", nil, row)
    titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
    titleFrame:SetSize(math.min(title:GetStringWidth() + 10, titleWidth), rs.height)

    -- Resolve choices list from Provider, Preset, or inline choices/options
    local rawChoices
    if type(info.provider) == "function" then
        rawChoices = info.provider()
    elseif type(info.provider) == "string" and GUI.Providers and GUI.Providers[info.provider] then
        rawChoices = GUI.Providers[info.provider]()
    elseif info.kind and GUI.Providers and GUI.Providers[info.kind] then
        rawChoices = GUI.Providers[info.kind]()
    elseif info.preset and GUI.Providers and GUI.Providers[info.preset] then
        rawChoices = GUI.Providers[info.preset]()
    elseif info.preset == "anchor" then
        rawChoices = ANCHOR_PRESET_CHOICES
    elseif info.preset == "anchorInnerOuter" then
        rawChoices = ANCHOR_INNER_OUTER_CHOICES
    elseif info.kind == "font" or info.preset == "font" then
        rawChoices = {}
        local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
        if LSM then
            local fonts = LSM:HashTable(LSM.MediaType.FONT)
            local sorted = {}
            for name in pairs(fonts) do table.insert(sorted, name) end
            table.sort(sorted)
            for _, name in ipairs(sorted) do
                table.insert(rawChoices, { value = name, label = name })
            end
        end
    elseif info.kind == "texture" or info.preset == "texture" or info.preset == "statusbar" then
        rawChoices = {}
        local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
        if LSM then
            local textures = LSM:HashTable(LSM.MediaType.STATUSBAR)
            local sorted = {}
            for name in pairs(textures) do table.insert(sorted, name) end
            table.sort(sorted)
            for _, name in ipairs(sorted) do
                table.insert(rawChoices, { value = name, label = name })
            end
        end
    else
        rawChoices = info.choices or info.options or {}
    end

    -- Normalize choices to standard { value = ..., label = ... } format
    local choices = {}
    if type(rawChoices) == "table" then
        for _, item in ipairs(rawChoices) do
            if type(item) == "table" then
                table.insert(choices, {
                    value = item.value ~= nil and item.value or item[1],
                    label = item.label ~= nil and item.label or item[2] or item.value or item[1]
                })
            else
                table.insert(choices, { value = tostring(item), label = tostring(item) })
            end
        end
    end

    -- Build native WoW DropdownButton
    local dropdownWidth = info.width or info.size or 130
    local dropdown = CreateFrame("DropdownButton", nil, row, "WowStyle1DropdownTemplate")
    dropdown:SetWidth(dropdownWidth)
    dropdown:SetPoint("RIGHT", row, "RIGHT", -8, 0)

    local function GetChoiceLabel(value)
        for _, c in ipairs(choices) do
            if c.value == value then
                return (L and L[c.label]) or c.label
            end
        end
        return value
    end

    local function RefreshText()
        local current = GetOptionValue(schema, info.key)
        dropdown:SetDefaultText(GetChoiceLabel(current) or (L and L["Select"] or "Select"))
    end

    local isFontDropdown = (info.kind == "font" or info.preset == "font" or info.preview == "font" or (info.preview == true and info.kind == "font"))
    local isTextureDropdown = (info.kind == "texture" or info.preset == "texture" or info.preset == "statusbar" or info.preview == "texture" or (info.preview == true and (info.kind == "texture" or info.preset == "texture" or info.preset == "statusbar")))

    if isFontDropdown then
        dropdown.fontPool = dropdown.fontPool or {}
    end
    if isTextureDropdown then
        dropdown.texturePool = dropdown.texturePool or {}
    end

    dropdown:SetupMenu(function(owner, rootDescription)
        if #choices > 20 then
            rootDescription:SetScrollMode(20 * 20)
        end
        local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
        local lsmTextures = isTextureDropdown and LSM and LSM:HashTable(LSM.MediaType.STATUSBAR)
        local lsmFonts    = isFontDropdown and LSM and LSM:HashTable(LSM.MediaType.FONT)

        for index, c in ipairs(choices) do
            local displayText = (L and L[c.label]) or c.label
            local button = rootDescription:CreateButton(displayText, function()
                SetOptionValue(schema, info.key, c.value)
                dropdown:SetDefaultText(displayText)
                if info.onChange then info.onChange(c.value) end
                if _G.BBF and _G.BBF.UpdateCustomTextures then _G.BBF.UpdateCustomTextures() end
                if _G.BBF and _G.BBF.SetCustomFonts then _G.BBF.SetCustomFonts() end
                if _G.BBF and _G.BBF.UpdateFrames then _G.BBF.UpdateFrames() end
            end)

            if isTextureDropdown and lsmTextures and lsmTextures[c.value] then
                local texturePath = lsmTextures[c.value]
                button:AddInitializer(function(btnFrame)
                    local textureBg = dropdown.texturePool[index]
                    if not textureBg then
                        textureBg = dropdown:CreateTexture(nil, "BACKGROUND")
                        dropdown.texturePool[index] = textureBg
                    end
                    textureBg:SetParent(btnFrame)
                    textureBg:SetAllPoints(btnFrame)
                    textureBg:SetTexture(texturePath)

                    if classKeys and #classKeys > 0 then
                        local randomClass = classKeys[math.random(#classKeys)]
                        local col = classColors[randomClass]
                        if col then
                            textureBg:SetVertexColor(col.r, col.g, col.b)
                        end
                    end
                    textureBg:Show()
                end)
            elseif isFontDropdown and lsmFonts and lsmFonts[c.value] then
                local fontPath = lsmFonts[c.value]
                button:AddInitializer(function(btnFrame)
                    local defaultFS = btnFrame.fontString or btnFrame.Text
                    if defaultFS then
                        defaultFS:SetAlpha(0)
                    end

                    local fs = dropdown.fontPool[index]
                    if not fs then
                        fs = dropdown:CreateFontString(nil, "OVERLAY")
                        dropdown.fontPool[index] = fs
                    end
                    fs:SetParent(btnFrame)
                    fs:ClearAllPoints()
                    fs:SetPoint("LEFT", btnFrame, "LEFT", 19, 0)
                    fs:SetPoint("RIGHT", btnFrame, "RIGHT", -10, 0)
                    fs:SetJustifyH("LEFT")

                    if fontPath and fs then
                        pcall(function()
                            fs:SetFont(fontPath, 13, "OUTLINE")
                        end)
                    end
                    fs:SetText(displayText)
                    fs:Show()
                end)
            end
        end
    end)

    RefreshText()

    hooksecurefunc(dropdown, "OnMenuClosed", function()
        if dropdown.texturePool then
            for _, texture in pairs(dropdown.texturePool) do
                texture:Hide()
            end
        end
        if dropdown.fontPool then
            for _, fs in pairs(dropdown.fontPool) do
                fs:Hide()
            end
        end
        RefreshText()
    end)


    dropdown.associatedRow        = row
    dropdown.associatedTitle      = title
    dropdown.associatedTitleFrame = titleFrame

    if isChild then
        WireChildToParent(parentCb, dropdown, title, row, info)
    end

    if info.tooltip and info.tooltip ~= "" then
        AttachTooltip(titleFrame, ResolveText(schema, info.label), ResolveText(schema, info.tooltip), nil, "ANCHOR_RIGHT", info.requiresReload or info.reload, info.tooltipExtra, info.cpuUsage, info.cvarName, info.key, info)
        AttachTooltip(dropdown,   ResolveText(schema, info.label), ResolveText(schema, info.tooltip), nil, "ANCHOR_RIGHT", info.requiresReload or info.reload, info.tooltipExtra, info.cpuUsage, info.cvarName, info.key, info)
    end


    card.currentY = card.currentY - rs.height - rs.gap
    UpdateCardHeight(card)
    return dropdown
end

--------------------------------------------------------
-- FILA: DOBLE CHECKBOX HIJO (dos opciones en una sola fila)
--------------------------------------------------------

local function BuildDualChildCheckboxRow(card, info, parentCb, schema)
    local rd = T.Row.dualChild

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", rd.leftInset, card.currentY)
    row:SetSize(card.cardWidth - rd.widthShrink, rd.height)

    local title1 = row:CreateFontString(nil, "OVERLAY", rd.titleFont)
    title1:SetPoint("LEFT", row, "LEFT", 6, 0)
    title1:SetText(info.label1)

    local tf1 = CreateFrame("Frame", nil, row)
    tf1:SetPoint("LEFT", row, "LEFT", 0, 0)
    tf1:SetSize(title1:GetStringWidth() + 6, rd.height)

    local cb1 = CreateNativeCheckbox(row, info.key1, schema, info.onChange1)
    cb1:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    cb1:HookScript("OnClick", function(self, btn)
        if btn == "RightButton" then
            self:SetChecked(not self:GetChecked())
            TriggerRightClick(info, tf1 or self, info.key1, info.label1)
        end
    end)
    cb1.associatedTitle = title1
    cb1:SetPoint("LEFT", title1, "RIGHT", 6, 0)
    if cb1.UpdateEnabledState then cb1:UpdateEnabledState() end

    tf1:EnableMouse(true)
    tf1:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" and cb1:IsEnabled() then cb1:Click("LeftButton")
        elseif btn == "RightButton" then TriggerRightClick(info, tf1, info.key1, info.label1) end
    end)
    if info.tooltip1 and info.tooltip1 ~= "" then
        AttachTooltip(tf1, ResolveText(schema, info.label1), ResolveText(schema, info.tooltip1), nil, "ANCHOR_RIGHT")
        AttachTooltip(cb1, ResolveText(schema, info.label1), ResolveText(schema, info.tooltip1), nil, "ANCHOR_RIGHT")
    end

    local title2 = row:CreateFontString(nil, "OVERLAY", rd.titleFont)
    title2:SetPoint("LEFT", cb1, "RIGHT", rd.spacing, 0)
    title2:SetText(ResolveText(schema, info.label2))

    local tf2 = CreateFrame("Frame", nil, row)
    tf2:SetPoint("LEFT", cb1, "RIGHT", rd.spacing, 0)
    tf2:SetSize(title2:GetStringWidth() + 6, rd.height)

    local cb2 = CreateNativeCheckbox(row, info.key2, schema, info.onChange2)
    cb2:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    cb2:HookScript("OnClick", function(self, btn)
        if btn == "RightButton" then
            self:SetChecked(not self:GetChecked())
            TriggerRightClick(info, tf2 or self, info.key2, info.label2)
        end
    end)
    cb2.associatedTitle = title2
    cb2:SetPoint("LEFT", title2, "RIGHT", 6, 0)
    if cb2.UpdateEnabledState then cb2:UpdateEnabledState() end

    tf2:EnableMouse(true)
    tf2:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" and cb2:IsEnabled() then cb2:Click("LeftButton")
        elseif btn == "RightButton" then TriggerRightClick(info, tf2, info.key2, info.label2) end
    end)
    if info.tooltip2 and info.tooltip2 ~= "" then
        AttachTooltip(tf2, ResolveText(schema, info.label2), ResolveText(schema, info.tooltip2), nil, "ANCHOR_RIGHT")
        AttachTooltip(cb2, ResolveText(schema, info.label2), ResolveText(schema, info.tooltip2), nil, "ANCHOR_RIGHT")
    end



    card.currentY = card.currentY - rd.height - rd.gap
    UpdateCardHeight(card)
    return cb1, cb2
end

--------------------------------------------------------
-- FILA: CHECKBOX CON MULTIPLES PADRES
--------------------------------------------------------

local function BuildMultiParentChildRow(card, info, parentCbs, schema)
    local rc = T.Row.checkbox

    local row = CreateFrame("Frame", nil, card)
    row:SetPoint("TOPLEFT", card, "TOPLEFT", rc.leftInsetChild, card.currentY)
    row:SetSize(card.cardWidth - rc.widthShrinkChild, rc.height)

    local title = row:CreateFontString(nil, "OVERLAY", rc.titleFontChild)
    title:SetPoint("LEFT", row, "LEFT", rc.titleOffsetLeft, 0)
    title:SetText(info.label)
    title:SetWidth(rc.titleWidthChild)
    title:SetJustifyH("LEFT")

    local titleFrame = CreateFrame("Frame", nil, row)
    titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
    titleFrame:SetSize(math.min(title:GetStringWidth() + 10, rc.titleWidthChild), rc.height)

    local cb = CreateNativeCheckbox(row, info.key, schema, info.onChange)
    cb.associatedTitle    = title
    cb.associatedRow      = row
    cb.parentCheckButtons = parentCbs
    for _, parentCB in ipairs(parentCbs) do
        parentCB.childrenCheckButtons = parentCB.childrenCheckButtons or {}
        table.insert(parentCB.childrenCheckButtons, cb)
    end
    cb:SetPoint("RIGHT", row, "RIGHT", rc.cbOffsetRight, 0)
    if cb.UpdateEnabledState then cb:UpdateEnabledState() end

    titleFrame:EnableMouse(true)
    titleFrame:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" and cb:IsEnabled() then cb:Click("LeftButton")
        elseif btn == "RightButton" then TriggerRightClick(info, titleFrame) end
    end)
    if info.tooltip and info.tooltip ~= "" then
        AttachTooltip(titleFrame, ResolveText(schema, info.label), ResolveText(schema, info.tooltip), nil, "ANCHOR_RIGHT", info.requiresReload or info.reload, info.tooltipExtra, info.cpuUsage, info.cvarName, info.key, info)
        AttachTooltip(cb,         ResolveText(schema, info.label), ResolveText(schema, info.tooltip), nil, "ANCHOR_RIGHT", info.requiresReload or info.reload, info.tooltipExtra, info.cpuUsage, info.cvarName)
    end



    card.currentY = card.currentY - rc.height - rc.gap
    UpdateCardHeight(card)
    return cb
end

--------------------------------------------------------
-- FILA: ENCABEZADO DE SECCION (subtitulo dentro de una card)
--------------------------------------------------------

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

--------------------------------------------------------
-- FILA: VISTA PREVIA (icono/textura suelta dentro de una card)
--------------------------------------------------------

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
-- Internal: builds a container frame. isSection=true → plain frame, isSection=false → with backdrop.
local function CreateContainer(parentFrame, titleText, anchorFrame, yOffset, containerDef, isSection)
    local tc = T.Card

    local cardWidth
    if containerDef and type(containerDef.width) == "number" then
        cardWidth = containerDef.width
    elseif containerDef and type(containerDef.size) == "number" then
        cardWidth = containerDef.size
    else
        local parentW       = (parentFrame and parentFrame:GetWidth() > 0) and parentFrame:GetWidth() or nil
        local parentParentW = (parentFrame and parentFrame:GetParent() and parentFrame:GetParent():GetWidth() > 0) and parentFrame:GetParent():GetWidth() or nil
        cardWidth = math.max(100, parentW or parentParentW or 620)
    end

    local mTop, mRight, mBottom, mLeft = 0, 0, 0, 0
    if containerDef then mTop, mRight, mBottom, mLeft = ParseMargin(containerDef) end

    local defaultSpacing = isSection and -12 or tc.header.betweenCards
    local effectiveYOff  = (yOffset or defaultSpacing) - mTop
    local finalWidth     = cardWidth - mLeft - mRight
    local hasTitle       = titleText and titleText ~= ""

    local header
    if hasTitle then
        header = parentFrame:CreateFontString(nil, "OVERLAY", tc.header.font)
        if anchorFrame then
            header:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", mLeft, effectiveYOff)
        else
            header:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 2 + mLeft, tc.header.firstCardY - mTop)
        end
        header:SetText(titleText)
        header:SetTextColor(unpack(tc.header.color))
    end

    local template = isSection and nil or "BackdropTemplate"
    local frame    = CreateFrame("Frame", nil, parentFrame, template)

    if hasTitle then
        frame:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, tc.header.gapBelowHeader)
    elseif anchorFrame then
        frame:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", mLeft, effectiveYOff)
    else
        frame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 2 + mLeft, tc.header.firstCardY - mTop)
    end
    frame:SetWidth(finalWidth)

    if not isSection then
        frame:SetBackdrop(tc.backdrop)
        frame:SetBackdropColor(unpack(tc.bgColor))
        frame:SetBackdropBorderColor(unpack(tc.borderColor))
    end

    frame.titleLabel   = header
    frame.cardWidth    = finalWidth
    frame.isSection    = isSection
    frame.marginBottom = mBottom
    frame.currentY     = isSection and 0 or tc.cursorStart
    return frame
end

local function BuildSection(parentFrame, titleText, anchorFrame, yOffset, containerDef)
    return CreateContainer(parentFrame, titleText, anchorFrame, yOffset, containerDef, true)
end

local function BuildCard(parentFrame, titleText, anchorFrame, yOffset, containerDef)
    return CreateContainer(parentFrame, titleText, anchorFrame, yOffset, containerDef, false)
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

local function BuildOption(card, info, resolvedRefs, schema)
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
            cb = BuildMultiParentChildRow(card, info, parents, schema)
        else
            cb = BuildCheckboxRow(card, info, parentCb, schema)
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
                local cw1, cw2 = BuildOption(card, merged, resolvedRefs, schema)
                local pf = card.panelFrame or (card:GetParent() and card:GetParent().panelFrame)
                if pf and pf.allWidgets then
                    if cw1 then table.insert(pf.allWidgets, cw1) end
                    if cw2 then table.insert(pf.allWidgets, cw2) end
                end
            end
        end
        return cb

    elseif t == "slider" then
        local parentCb = info._parentCb or (info.parent and resolvedRefs[info.parent]) 
        local sl = BuildSliderRow(card, info, parentCb, schema)
        if info.id then resolvedRefs[info.id] = sl end
        if info.key then resolvedRefs[info.key] = sl end
        return sl

    elseif t == "dropdown" then
        local parentCb = info._parentCb or (info.parent and resolvedRefs[info.parent])
        local dd = BuildDropdownRow(card, info, parentCb, schema)
        if info.id  then resolvedRefs[info.id]  = dd end
        if info.key then resolvedRefs[info.key] = dd end
        return dd

    elseif t == "dualchild" then
        local parentCb = info._parentCb or (info.parent and resolvedRefs[info.parent]) 
        local cb1, cb2 = BuildDualChildCheckboxRow(card, info, parentCb, schema)
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

local function ApplyIconToFrame(iconFrame, info)
    local function SetupTex(tex, cfg)
        local tType, tVal = ResolveTextureFromInfo(cfg)
        if tType == "atlas" then tex:SetAtlas(tVal) elseif tType == "texture" then tex:SetTexture(tVal) end
        tex._origColor = cfg.atlasColor or cfg.color
        tex._origDesat = cfg.atlasDesaturated or cfg.desaturated
        if tex._origDesat then tex:SetDesaturated(true) end
        if tex._origColor then tex:SetVertexColor(unpack(tex._origColor)) end
    end

    local iconTex = iconFrame:CreateTexture(nil, "ARTWORK")
    iconTex:SetSize(unpack(info.atlasSize or info.size or {20, 20}))
    iconTex:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
    SetupTex(iconTex, info)

    if info.overlays then
        for _, ov in ipairs(info.overlays) do
            local ovTex = iconFrame:CreateTexture(nil, ov.layer or "OVERLAY")
            ovTex:SetSize(unpack(ov.size or {20, 20}))
            ovTex:SetPoint("CENTER", iconTex, "CENTER", unpack(ov.offset or {0, 0}))
            SetupTex(ovTex, ov)
        end
    end
end

-- Desaturates all textures on an iconFrame (base + overlays), stripping color tints when disabled
local function SetIconFrameDesaturated(iconFrame, isDesaturated)
    if not iconFrame then return end
    for _, reg in ipairs({ iconFrame:GetRegions() }) do
        if reg:IsObjectType("Texture") then
            reg:SetDesaturated(isDesaturated or reg._origDesat or false)
            if reg._origColor then
                reg:SetVertexColor(unpack(isDesaturated and {1, 1, 1} or reg._origColor))
            end
        end
    end
end



-- ============================================================
-- POPUP WINDOW SCHEMA ENGINE
-- ============================================================

--------------------------------------------------------
-- GRILLA DE COLORES (calculo de filas/columnas)
--------------------------------------------------------
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

--------------------------------------------------------
-- BOTON DE SELECCION DE COLOR (color swatch)
--------------------------------------------------------

BuildColorSwatchBtn = function(parent, posX, posY, dbKey, labelStr, defaultColor, maxTextWidth, callback, ttTitle, ttDesc, schema)
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
    txt:SetText(labelStr or "")
    btn:SetHitRectInsets(0, -(maxTextWidth or 70), 0, 0)

    local titleText = ttTitle or labelStr
    local descText  = ttDesc  or ResolveText(schema, "Tooltip_Color_Picker_Desc")
    AttachTooltip(btn, titleText, descText, nil, "ANCHOR_RIGHT")

    local function RefreshSwatch()
        local col = GetOptionValue(schema, dbKey, defaultColor or {r = 1, g = 1, b = 1})
        local r = (type(col) == "table" and (col.r or col[1])) or 1
        local g = (type(col) == "table" and (col.g or col[2])) or 1
        local b = (type(col) == "table" and (col.b or col[3])) or 1
        swatch:SetVertexColor(r, g, b)
    end
    RefreshSwatch()

    btn:SetScript("OnClick", function(self, mouseButton)
        if mouseButton == "RightButton" and IsShiftKeyDown() then
            SetOptionValue(schema, dbKey, nil)
            RefreshSwatch()
            if callback then callback() end
            if _G.BBF and _G.BBF.UpdateFrames then _G.BBF.UpdateFrames() end
            return
        end

        local col = GetOptionValue(schema, dbKey, defaultColor or {r = 1, g = 1, b = 1})
        local r = (type(col) == "table" and (col.r or col[1])) or 1
        local g = (type(col) == "table" and (col.g or col[2])) or 1
        local b = (type(col) == "table" and (col.b or col[3])) or 1

        local info = {
            r = r, g = g, b = b,
            hasOpacity = false,
            swatchFunc = function()
                local nr, ng, nb = ColorPickerFrame:GetColorRGB()
                SetOptionValue(schema, dbKey, { nr, ng, nb, r = nr, g = ng, b = nb })
                swatch:SetVertexColor(nr, ng, nb)
                if callback then callback() end
                if _G.BBF and _G.BBF.UpdateFrames then _G.BBF.UpdateFrames() end
            end,
            cancelFunc = function(prev)
                local pr = (type(prev) == "table" and (prev.r or prev[1])) or 1
                local pg = (type(prev) == "table" and (prev.g or prev[2])) or 1
                local pb = (type(prev) == "table" and (prev.b or prev[3])) or 1
                SetOptionValue(schema, dbKey, { pr, pg, pb, r = pr, g = pg, b = pb })
                swatch:SetVertexColor(pr, pg, pb)
                if callback then callback() end
                if _G.BBF and _G.BBF.UpdateFrames then _G.BBF.UpdateFrames() end
            end
        }
        if ColorPickerFrame.SetupColorPickerAndShow then
            ColorPickerFrame:SetupColorPickerAndShow(info)
        elseif OpenColorPicker then
            OpenColorPicker(info)
        end
    end)

    return btn, RefreshSwatch
end

--------------------------------------------------------
-- VENTANA EMERGENTE (popup): construccion y render de opciones
--------------------------------------------------------

function GUI.OpenPopup(popupId, schema)
    schema = schema or (GUI.Popups and GUI.Popups[popupId])
    if not schema then return end
    local tp = T.Popup
    local L = schema.L or (BBF and BBF.L)

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

            -- Tipo: encabezado de texto simple
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
                else
                    cb.Text:SetFontObject("GameFontHighlight")
                end
                cb.Text:SetPoint("LEFT", cb, "RIGHT", 6, 0)
                cb.Text:SetText(labelText or "")
                if textColor then
                    cb.Text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1)
                end

                cb:SetChecked(GetOptionValue(schema, opt.key))
                cb:SetScript("OnClick", function(self)
                    SetOptionValue(schema, opt.key, self:GetChecked() or nil)
                    if opt.onChange then opt.onChange() end
                    if (opt.requiresReload or opt.reload) and StaticPopup_Show then
                        ShowReloadPrompt()
                    end
                    if _G.BBF and _G.BBF.UpdateFrames then _G.BBF.UpdateFrames() end
                    if _G.BBF and _G.BBF.HideFrames then _G.BBF.HideFrames() end
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
                    AttachTooltip(cb, ResolveText(schema, opt.label), ResolveText(schema, opt.tooltip), nil, "ANCHOR_RIGHT")
                    AttachTooltip(rowFrame, ResolveText(schema, opt.label), ResolveText(schema, opt.tooltip), nil, "ANCHOR_RIGHT")
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

            -- Tipo: grilla de swatches de color (columnas/filas configurables)
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

            -- Tipo: grilla automatica de swatches por clase
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

            -- Tipo: grilla automatica de swatches por tipo de poder (mana, ira, etc.)
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
                        if _G.BBF and _G.BBF.UpdatePowerColorCache then _G.BBF.UpdatePowerColorCache() end
                        if _G.BBF and _G.BBF.UpdateFrames then _G.BBF.UpdateFrames() end
                    end
                    local btn = BuildColorSwatchBtn(contentParent, posX, posY, "powerColor" .. pData.key, labelName, pDefColor, colWidth - 26, powerOnChange)
                    if isChild and parentCb then
                        WireChildToParent(parentCb, btn, nil)
                    end
                end
                currentY = pGridStartY - (maxRow + 1) * rowHeight - 14

            -- Tipo: dos swatches de color lado a lado
            elseif t == "colorSwatchDual" then
                local b1 = BuildColorSwatchBtn(contentParent, 26 + indentX, currentY, opt.key1, opt.label1, opt.default1, 100)
                local b2 = BuildColorSwatchBtn(contentParent, 146 + indentX, currentY, opt.key2, opt.label2, opt.default2, 100)
                if isChild and parentCb then
                    WireChildToParent(parentCb, b1, nil)
                    WireChildToParent(parentCb, b2, nil)
                end
                currentY = currentY - 28

            -- Tipo: dropdown (texturas, anchors, o lista de opciones custom)
            elseif t == "textureDropdown" or t == "dropdown" then
                local dropdownWidth = opt.width or 180
                local posX = opt.posX or (26 + indentX)
                local dropdown = CreateFrame("DropdownButton", nil, contentParent, "WowStyle1DropdownTemplate")
                dropdown:SetWidth(dropdownWidth)
                dropdown:SetPoint("TOPLEFT", contentParent, "TOPLEFT", posX, currentY)

                local choices = {}
                if opt.preset == "texture" or opt.preset == "statusbar" or t == "textureDropdown" then
                    local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
                    if LSM then
                        local textures = LSM:HashTable(LSM.MediaType.STATUSBAR)
                        local sorted = {}
                        for name in pairs(textures) do table.insert(sorted, name) end
                        table.sort(sorted)
                        for _, name in ipairs(sorted) do
                            table.insert(choices, { value = name, label = name })
                        end
                    end
                elseif opt.preset == "anchor" then
                    choices = ANCHOR_PRESET_CHOICES
                elseif opt.preset == "anchorInnerOuter" then
                    choices = ANCHOR_INNER_OUTER_CHOICES
                else
                    choices = opt.choices or {}
                end

                local function GetChoiceLabel(val)
                    for _, c in ipairs(choices) do
                        if c.value == val then return (L and L[c.label]) or c.label end
                    end
                    return val
                end

                local function RefreshText()
                    local current = GetOptionValue(schema, opt.key)
                    dropdown:SetDefaultText(GetChoiceLabel(current) or (L and L["Select_Texture"] or "Select Texture"))
                end

                local isFontDropdown = (opt.kind == "font" or opt.preset == "font" or opt.preview == "font" or (opt.preview == true and opt.kind == "font"))
                local isTextureDropdown = (opt.kind == "texture" or opt.preset == "texture" or opt.preset == "statusbar" or opt.preview == "texture" or (opt.preview == true and (opt.kind == "texture" or opt.preset == "texture" or opt.preset == "statusbar")) or t == "textureDropdown")

                if isFontDropdown then
                    dropdown.fontPool = dropdown.fontPool or {}
                end
                if isTextureDropdown then
                    dropdown.texturePool = dropdown.texturePool or {}
                end

                dropdown:SetupMenu(function(owner, rootDescription)
                    if #choices > 20 then rootDescription:SetScrollMode(20 * 20) end
                    local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
                    local lsmTextures = isTextureDropdown and LSM and LSM:HashTable(LSM.MediaType.STATUSBAR)
                    local lsmFonts    = isFontDropdown and LSM and LSM:HashTable(LSM.MediaType.FONT)

                    for index, c in ipairs(choices) do
                        local displayText = (L and L[c.label]) or c.label
                        local button = rootDescription:CreateButton(displayText, function()
                            SetOptionValue(schema, opt.key, c.value)
                            dropdown:SetDefaultText(displayText)
                            if opt.onChange then opt.onChange(c.value) end
                            if _G.BBF and _G.BBF.UpdateCustomTextures then _G.BBF.UpdateCustomTextures() end
                            if _G.BBF and _G.BBF.SetCustomFonts then _G.BBF.SetCustomFonts() end
                            if _G.BBF and _G.BBF.UpdateFrames then _G.BBF.UpdateFrames() end
                        end)

                        if isTextureDropdown and lsmTextures and lsmTextures[c.value] then
                            local texturePath = lsmTextures[c.value]
                            button:AddInitializer(function(btnFrame)
                                local textureBg = dropdown.texturePool[index]
                                if not textureBg then
                                    textureBg = dropdown:CreateTexture(nil, "BACKGROUND")
                                    dropdown.texturePool[index] = textureBg
                                end
                                textureBg:SetParent(btnFrame)
                                textureBg:SetAllPoints(btnFrame)
                                textureBg:SetTexture(texturePath)

                                if classKeys and #classKeys > 0 then
                                    local randomClass = classKeys[math.random(#classKeys)]
                                    local col = classColors[randomClass]
                                    if col then
                                        textureBg:SetVertexColor(col.r, col.g, col.b)
                                    end
                                end
                                textureBg:Show()
                            end)
                        elseif isFontDropdown and lsmFonts and lsmFonts[c.value] then
                            local fontPath = lsmFonts[c.value]
                            button:AddInitializer(function(btnFrame)
                                local defaultFS = btnFrame.fontString or btnFrame.Text
                                if defaultFS then
                                    defaultFS:SetAlpha(0)
                                end

                                local fs = dropdown.fontPool[index]
                                if not fs then
                                    fs = dropdown:CreateFontString(nil, "OVERLAY")
                                    dropdown.fontPool[index] = fs
                                end
                                fs:SetParent(btnFrame)
                                fs:ClearAllPoints()
                                fs:SetPoint("LEFT", btnFrame, "LEFT", 19, 0)
                                fs:SetPoint("RIGHT", btnFrame, "RIGHT", -10, 0)
                                fs:SetJustifyH("LEFT")

                                if fontPath and fs then
                                    pcall(function()
                                        fs:SetFont(fontPath, 13, "OUTLINE")
                                    end)
                                end
                                fs:SetText(displayText)
                                fs:Show()
                            end)
                        end
                    end
                end)
                RefreshText()

                hooksecurefunc(dropdown, "OnMenuClosed", function()
                    if dropdown.texturePool then
                        for _, texture in pairs(dropdown.texturePool) do
                            texture:Hide()
                        end
                    end
                    if dropdown.fontPool then
                        for _, fs in pairs(dropdown.fontPool) do
                            fs:Hide()
                        end
                    end
                    RefreshText()
                end)


                if isChild and parentCb then
                    WireChildToParent(parentCb, dropdown, nil)
                end

                currentY = currentY - 32
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


-- ============================================================
-- PANEL PRINCIPAL (sidebar de tabs + contenido con scroll)
-- ============================================================

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

    local categoryFrames  = {}
    local categoryButtons = {}
    local hasTabs = schema.tabs and #schema.tabs > 0
    panelFrame.allWidgets = {}

    local sidebar, contentParent
    local optionGridHeight = 0
    local panelRefs = {}   -- panel-level widget registry for cross-level parent wiring

    if schema.optionGrid and #schema.optionGrid > 0 then
        local gridParent = CreateFrame("Frame", nil, panelFrame)
        gridParent:SetPoint("TOPLEFT", panelFrame, "TOPLEFT", 12, -10)
        gridParent:SetPoint("TOPRIGHT", panelFrame, "TOPRIGHT", -12, -10)

        local currentGridY = 0

        for _, gridDef in ipairs(schema.optionGrid) do
            local cols = tonumber(gridDef.cols or gridDef.columns or 2)
            local gap = tonumber(gridDef.gap or 12)
            local mTop, mRight, mBottom, mLeft = ParseMargin(gridDef)
            local opts = gridDef.options or {}

            currentGridY = currentGridY - mTop

            local panelWidth = (panelFrame:GetWidth() > 0 and panelFrame:GetWidth() or 650)
            local availWidth = panelWidth - 24 - mLeft - mRight
            local colWidth = math.floor((availWidth - ((cols - 1) * gap)) / cols)

            for oIdx, opt in ipairs(opts) do
                local col    = (oIdx - 1) % cols
                local rowIdx = math.floor((oIdx - 1) / cols)
                local posX   = mLeft + (col * (colWidth + gap))
                local posY   = currentGridY - (rowIdx * 34)

                local cb = CreateNativeCheckbox(gridParent, opt.key, schema, opt.onChange, function(self, btn, val)
                    if opt.requiresReload or opt.reload then
                        ShowReloadPrompt()
                    end
                end)
                cb:SetPoint("TOPLEFT", gridParent, "TOPLEFT", posX, posY)
                cb.dbKey = opt.key

                local txt = cb.Text
                if not txt then
                    txt = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    cb.Text = txt
                else
                    txt:SetFontObject("GameFontHighlight")
                end
                txt:SetPoint("LEFT", cb, "RIGHT", 6, 0)
                txt:SetText(ResolveText(schema, opt.label))

                if opt.tooltip and opt.tooltip ~= "" then
                    AttachTooltip(cb,  ResolveText(schema, opt.label), ResolveText(schema, opt.tooltip), nil, "ANCHOR_RIGHT", opt.requiresReload or opt.reload)
                    AttachTooltip(txt, ResolveText(schema, opt.label), ResolveText(schema, opt.tooltip), nil, "ANCHOR_RIGHT", opt.requiresReload or opt.reload)
                end

                -- Register in panelRefs for cross-level parent wiring
                cb.associatedTitle = txt
                panelRefs[opt.key] = cb

                -- Single-pass parent wiring (parent must appear before child in list)
                if opt.parent and panelRefs[opt.parent] then
                    WireChildToParent(panelRefs[opt.parent], cb, txt, nil, opt)
                end
            end

            local numRows = math.ceil(#opts / cols)
            currentGridY = currentGridY - (numRows * 34) - mBottom

        end

        gridParent:SetHeight(math.abs(currentGridY))

        local firstGrid = schema.optionGrid[1]
        local isOverlay = firstGrid and (firstGrid.overlayMode == true or firstGrid.overlayMode == "true")
        if not isOverlay then
            optionGridHeight = math.abs(currentGridY) + 6
        end
    end

    local sidebarOffsetY = ts.offsetY - optionGridHeight
    local contentOffsetY = -45 - optionGridHeight

    if hasTabs then
        sidebar = CreateFrame("Frame", nil, panelFrame)
        sidebar:SetSize(ts.width, ts.height - optionGridHeight)
        sidebar:SetPoint("TOPLEFT", panelFrame, "TOPLEFT", ts.offsetX, sidebarOffsetY)

        contentParent = CreateFrame("Frame", nil, panelFrame)
        contentParent:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", tc.gapLeft, 0)
        contentParent:SetPoint("BOTTOMRIGHT", panelFrame, "BOTTOMRIGHT", tc.marginRight, tc.marginBottom)
    else
        contentParent = CreateFrame("Frame", nil, panelFrame)
        contentParent:SetPoint("TOPLEFT", panelFrame, "TOPLEFT", 12, contentOffsetY)
        contentParent:SetPoint("BOTTOMRIGHT", panelFrame, "BOTTOMRIGHT", tc.marginRight, tc.marginBottom)
    end

    --------------------------------------------------------
    -- POBLAR CARDS/SECCIONES DENTRO DE UN SCROLL CHILD
    --------------------------------------------------------
    local function SetTextEnabled(fs, enabled, defaultColor)
        if fs then fs:SetTextColor(unpack(enabled and defaultColor or {0.45, 0.45, 0.45, 1})) end
    end

    -- Wires a tab button to a parent checkbox
    local function WireTabToParent(parentCb, btn, iconFrame, tabWidgets, tabCards, tabHeaderFrame)
        if not parentCb then return end
        local function UpdateTabState()
            local enabled = parentCb:GetChecked() and (not parentCb.IsEnabled or parentCb:IsEnabled())
            btn.isParentDisabled = not enabled
            SetIconFrameDesaturated(iconFrame, not enabled)
            SetTextEnabled(btn.Text, enabled, tt.textColor)

            if tabHeaderFrame then
                SetTextEnabled(tabHeaderFrame.titleFontString, enabled, {1, 0.82, 0})
                SetIconFrameDesaturated(tabHeaderFrame.iconFrame, not enabled)
            end
            if tabCards then
                for _, card in ipairs(tabCards) do SetTextEnabled(card.titleLabel, enabled, T.Card.header.color) end
            end
            if tabWidgets then
                for _, w in ipairs(tabWidgets) do SetWidgetState(w, enabled) end
            end
        end
        parentCb:HookScript("OnClick", UpdateTabState)
        UpdateTabState()
    end

    -- Wires a card/section titleLabel to a parent checkbox
    local function WireContainerToParent(parentCb, card, containerWidgets)
        if not parentCb then return end
        local function UpdateContainerState()
            local enabled = parentCb:GetChecked() and (not parentCb.IsEnabled or parentCb:IsEnabled())
            SetTextEnabled(card.titleLabel, enabled, T.Card.header.color)
            if containerWidgets then
                for _, w in ipairs(containerWidgets) do SetWidgetState(w, enabled) end
            end
        end
        parentCb:HookScript("OnClick", UpdateContainerState)
        UpdateContainerState()
    end


    local function PopulateContainers(cf, containerList, parentSchema)
        local lastCard = nil
        local resolvedRefs = {}
        local createdCards = {}
        local topHeaderFrame = nil

        -- Render Top-Level Header & Divider if header/title is defined on parentSchema
        if parentSchema and (parentSchema.header or parentSchema.title) then
            local headerText = parentSchema.header or parentSchema.title
            local headerFrame = CreateFrame("Frame", nil, cf)
            headerFrame:SetPoint("TOPLEFT", cf, "TOPLEFT", 2, -6)
            headerFrame:SetPoint("RIGHT", cf, "RIGHT", 0, 0)

            local iconWidth, iconHeight = 22, 22
            if parentSchema.size then
                iconWidth, iconHeight = unpack(parentSchema.size)
            end

            local hasIcon = parentSchema.atlas or parentSchema.icon or parentSchema.texture or parentSchema.spell
            local titleFontString = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")

            if hasIcon then
                local iconFrame = CreateFrame("Frame", nil, headerFrame)
                iconFrame:SetSize(iconWidth, iconHeight)
                iconFrame:SetPoint("LEFT", headerFrame, "LEFT", 0, 0)
                ApplyIconToFrame(iconFrame, parentSchema)
                titleFontString:SetPoint("LEFT", iconFrame, "RIGHT", 6, 0)
                headerFrame.iconFrame = iconFrame
            else
                titleFontString:SetPoint("LEFT", headerFrame, "LEFT", 0, 0)
            end

            titleFontString:SetText(headerText)
            titleFontString:SetTextColor(1, 0.82, 0) -- Gold
            headerFrame.titleFontString = titleFontString
            topHeaderFrame = headerFrame

            local headerHeight = math.max(iconHeight, (titleFontString:GetStringHeight() or 24))
            headerFrame:SetHeight(headerHeight)
            lastCard = headerFrame

            if parentSchema.divider then
                local dividerFrame = CreateFrame("Frame", nil, cf)
                dividerFrame:SetPoint("TOPLEFT", headerFrame, "BOTTOMLEFT", 0, -8)
                dividerFrame:SetPoint("RIGHT", cf, "RIGHT", -10, 0)
                dividerFrame:SetHeight(2)

                local dividerTex = dividerFrame:CreateTexture(nil, "ARTWORK")
                dividerTex:SetAllPoints(dividerFrame)
                dividerTex:SetColorTexture(1, 1, 1, 0.15)
                lastCard = dividerFrame
            end
        end

        for _, containerDef in ipairs(containerList) do
            local isSection = containerDef.isSection or (containerDef.type == "section") or (containerDef.section == true)
            local card = isSection
                and BuildSection(cf, containerDef.title, lastCard, containerDef.yOffset, containerDef)
                or  BuildCard(cf, containerDef.title, lastCard, containerDef.yOffset, containerDef)
            table.insert(createdCards, card)

            local cardWidgets = {}
            for _, optInfo in ipairs(containerDef.options or {}) do
                local w1, w2 = BuildOption(card, optInfo, resolvedRefs, parentSchema or schema)
                if w1 then
                    table.insert(panelFrame.allWidgets, w1)
                    table.insert(cardWidgets, w1)
                end
                if w2 then
                    table.insert(panelFrame.allWidgets, w2)
                    table.insert(cardWidgets, w2)
                end
            end

            -- Wire card/section to parent checkbox if defined
            if containerDef.parent then
                local parentCb = panelRefs[containerDef.parent] or resolvedRefs[containerDef.parent]
                WireContainerToParent(parentCb, card, cardWidgets)
            end

            lastCard = card
        end

        if lastCard then
            FinalizeCardLayout(cf, lastCard)
        end

        return createdCards, topHeaderFrame
    end

    --------------------------------------------------------
    -- MODO CON TABS: sidebar + un ScrollFrame por pestaña
    --------------------------------------------------------
    if hasTabs then
        local tabs = schema.tabs
        local function SelectCategory(catId)
            for id, sf in pairs(categoryFrames) do sf:Hide() end
            for id, btn in pairs(categoryButtons) do
                btn:SetBackdropBorderColor(unpack(tt.borderColor))
                btn:SetBackdropColor(unpack(tt.bgColor))
                -- Keep label gray if this tab's parent is disabled
                if btn.Text then
                    if btn.isParentDisabled then
                        btn.Text:SetTextColor(0.45, 0.45, 0.45, 1)
                    else
                        btn.Text:SetTextColor(unpack(tt.textColor))
                    end
                end
            end
            if categoryFrames[catId] then categoryFrames[catId]:Show() end
            if categoryButtons[catId] then
                local activeBtn = categoryButtons[catId]
                activeBtn:SetBackdropBorderColor(unpack(tt.borderColorActive))
                activeBtn:SetBackdropColor(unpack(tt.bgColorActive))
                if activeBtn.Text then
                    if activeBtn.isParentDisabled then
                        activeBtn.Text:SetTextColor(0.45, 0.45, 0.45, 1)
                    else
                        activeBtn.Text:SetTextColor(unpack(tt.textColorActive))
                    end
                end
            end
        end

        for i, tab in ipairs(tabs) do
            local sf = CreateFrame("ScrollFrame", "BBF_MidnightGUI_" .. tab.id, contentParent, "ScrollFrameTemplate")
            sf:SetAllPoints(contentParent)
            sf:Hide()
            AdjustScrollBar(sf, -5)

            local contentW = GetAvailableContentWidth(panelFrame, true)
            local cfWidth = contentW - 11
            local cf = CreateFrame("Frame", nil, sf)
            cf:SetSize(cfWidth, T.ScrollChild.minHeight)
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
            btn.iconFrame = iconFrame   -- store for desaturation

            local containers = {}
            if tab.items then
                containers = tab.items
            else
                if tab.cards then
                    for _, cDef in ipairs(tab.cards) do table.insert(containers, cDef) end
                end
                if tab.sections then
                    for _, sDef in ipairs(tab.sections) do
                        local copy = {}
                        for k, v in pairs(sDef) do copy[k] = v end
                        copy.isSection = true
                        table.insert(containers, copy)
                    end
                end
            end

            -- Collect widgets and cards for this tab to disable when parent is OFF
            local widgetCountBefore = #panelFrame.allWidgets
            local createdCards, tabHeaderFrame = PopulateContainers(cf, containers, tab)
            if tab.parent and panelRefs[tab.parent] then
                local tabWidgets = {}
                for i = widgetCountBefore + 1, #panelFrame.allWidgets do
                    table.insert(tabWidgets, panelFrame.allWidgets[i])
                end
                WireTabToParent(panelRefs[tab.parent], btn, iconFrame, tabWidgets, createdCards, tabHeaderFrame)
            end
        end

        if tabs[1] then
            SelectCategory(tabs[1].id)
        end

        schema._selectCategory  = SelectCategory
        schema._categoryFrames  = categoryFrames
        schema._categoryButtons = categoryButtons

        return sidebar, contentParent, categoryFrames, categoryButtons
    else
        --------------------------------------------------------
        -- MODO SIN TABS: un unico panel con scroll
        --------------------------------------------------------
        local sf = CreateFrame("ScrollFrame", "BBF_MidnightGUI_" .. (schema.id or "single"), contentParent, "ScrollFrameTemplate")
        sf:SetAllPoints(contentParent)
        AdjustScrollBar(sf, -5)

        local contentW = GetAvailableContentWidth(panelFrame, false)
        local cfWidth = contentW - 11
        local cf = CreateFrame("Frame", nil, sf)
        cf.isSinglePanel = true
        cf:SetSize(cfWidth, T.ScrollChild.minHeight)
        sf:SetScrollChild(cf)

        categoryFrames["main"] = sf
        sf.contentFrame = cf

        local containers = {}
        if schema.items then
            containers = schema.items
        else
            if schema.cards then
                for _, cDef in ipairs(schema.cards) do table.insert(containers, cDef) end
            end
            if schema.sections then
                for _, sDef in ipairs(schema.sections) do
                    local copy = {}
                    for k, v in pairs(sDef) do copy[k] = v end
                    copy.isSection = true
                    table.insert(containers, copy)
                end
            end
        end

        PopulateContainers(cf, containers, schema)
    end



    return sidebar, contentParent, categoryFrames, categoryButtons
end