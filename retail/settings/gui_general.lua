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

-- ============================================================
-- LAYOUT CONSTANTS
-- ============================================================
local SIDEBAR_W     = 165   -- sidebar width
local SIDEBAR_BTN_H = 36    -- height of each tab button
local SIDEBAR_GAP   = 1     -- gap between tab buttons
local CONTENT_X     = SIDEBAR_W + 14  -- content panel left offset
local CONTENT_W     = 458   -- content panel width
local CONTENT_H     = 510   -- content panel height
local ROW_H         = 50    -- height of a single option row (with description)
local ROW_H_SLIM    = 36    -- height of a slim row (no description)
local CARD_PAD_X    = 14    -- horizontal padding inside cards
local CARD_PAD_Y    = 6     -- vertical padding inside cards
local CARD_GAP      = 14    -- gap between cards
local HDR_H         = 42    -- height of section header

-- ============================================================
-- OPTION ROW BUILDER
-- WaypointUI-style row: Name + desc (left) | Checkbox (right)
-- ============================================================
local function CreateOptionRow(parent, dbKey, titleText, descText, onApply, width)
    local rowW = width or (CONTENT_W - CARD_PAD_X * 2 - 4)
    local hasDesc = descText and descText ~= ""
    local rowH = hasDesc and ROW_H or ROW_H_SLIM

    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(rowW, rowH)

    -- Hover highlight
    row:SetScript("OnEnter", function(self)
        if not self._hlTex then
            self._hlTex = self:CreateTexture(nil, "BACKGROUND")
            self._hlTex:SetAllPoints()
            self._hlTex:SetColorTexture(1, 1, 1, 0.05)
        end
        self._hlTex:Show()
    end)
    row:SetScript("OnLeave", function(self)
        if self._hlTex then self._hlTex:Hide() end
    end)

    -- Title
    local title = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("LEFT", row, "LEFT", 2, hasDesc and 8 or 0)
    title:SetText(titleText)
    title:SetTextColor(0.95, 0.95, 0.95)
    row.title = title

    -- Description
    if hasDesc then
        local desc = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
        desc:SetText(descText)
        desc:SetTextColor(0.58, 0.58, 0.60)
        desc:SetWidth(rowW - 48)
        desc:SetJustifyH("LEFT")
        row.desc = desc
    end

    -- Bottom divider
    local sep = row:CreateTexture(nil, "ARTWORK")
    sep:SetColorTexture(0.17, 0.17, 0.19, 1)
    sep:SetHeight(1)
    sep:SetPoint("BOTTOMLEFT",  row, "BOTTOMLEFT",  0, 0)
    sep:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)

    -- Checkbox on right
    local cb = CreateCheckbox(dbKey, "", parent, nil, onApply)
    cb:SetPoint("RIGHT", row, "RIGHT", -4, hasDesc and 8 or 0)
    cb:SetSize(26, 26)
    if cb.text then cb.text:SetText("") end
    if cb.Text then cb.Text:SetText("") end

    -- Whole row is clickable
    row:EnableMouse(true)
    row:SetScript("OnMouseUp", function(self, btn)
        if btn == "LeftButton" then cb:Click() end
    end)

    row.checkbox = cb
    return row, cb
end

-- ============================================================
-- SLIDER ROW BUILDER
-- ============================================================
local function CreateSliderRow(parent, dbKey, titleText, descText, minVal, maxVal, step, label, width)
    local rowW = width or (CONTENT_W - CARD_PAD_X * 2 - 4)
    local rowH = 58

    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(rowW, rowH)

    local title = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("LEFT", row, "LEFT", 2, descText and 10 or 0)
    title:SetText(titleText)
    title:SetTextColor(0.95, 0.95, 0.95)
    row.title = title

    if descText and descText ~= "" then
        local desc = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
        desc:SetText(descText)
        desc:SetTextColor(0.58, 0.58, 0.60)
        desc:SetWidth(rowW - 155)
        desc:SetJustifyH("LEFT")
    end

    local sl = CreateSlider(parent, label or "", minVal, maxVal, step, dbKey, nil, 140)
    sl:SetPoint("RIGHT", row, "RIGHT", -2, -4)

    local sep = row:CreateTexture(nil, "ARTWORK")
    sep:SetColorTexture(0.17, 0.17, 0.19, 1); sep:SetHeight(1)
    sep:SetPoint("BOTTOMLEFT",  row, "BOTTOMLEFT",  0, 0)
    sep:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)

    row.slider = sl
    return row, sl
end

-- ============================================================
-- SECTION HEADER
-- Gold heading, NO underline — sits directly above a card
-- ============================================================
local function CreateSectionHeader(parent, text, anchorTo, yOffset)
    local hdr = CreateFrame("Frame", nil, parent)
    hdr:SetHeight(HDR_H)

    if anchorTo then
        hdr:SetPoint("TOPLEFT",  anchorTo, "BOTTOMLEFT", 0, yOffset or -CARD_GAP)
        hdr:SetPoint("TOPRIGHT", parent,   "TOPRIGHT",   0, 0)
    else
        hdr:SetPoint("TOPLEFT",  parent, "TOPLEFT",  0, 0)
        hdr:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    end

    -- Gold section title (large, bold)
    local lbl = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    lbl:SetPoint("LEFT", hdr, "LEFT", 2, 0)
    lbl:SetText(text)
    lbl:SetTextColor(0.96, 0.82, 0.35)   -- WoW amber gold

    hdr.label = lbl
    return hdr
end

-- ============================================================
-- CARD BUILDER
-- Slightly elevated dark panel with a thin gold top accent
-- ============================================================
local function CreateCard(parent, anchorTo, yOffset)
    local card = CreateFrame("Frame", nil, parent)

    if anchorTo then
        card:SetPoint("TOPLEFT",  anchorTo, "BOTTOMLEFT", 0, yOffset or -4)
        card:SetPoint("TOPRIGHT", parent,   "TOPRIGHT",   0, 0)
    else
        card:SetPoint("TOPLEFT",  parent, "TOPLEFT",  0, 0)
        card:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    end

    -- Card body background (slightly lighter than panel)
    local bg = card:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.11, 0.11, 0.14, 0.96)

    -- Thin outer border (all sides, subtle)
    local function Border(point, r, g, b, a)
        local t = card:CreateTexture(nil, "BORDER")
        t:SetColorTexture(r or 0.22, g or 0.22, b or 0.24, a or 0.9)
        if point == "TOP"    then t:SetHeight(1); t:SetPoint("TOPLEFT",    card,"TOPLEFT",   0, 0); t:SetPoint("TOPRIGHT",   card,"TOPRIGHT",  0, 0)
        elseif point=="BOTTOM" then t:SetHeight(1); t:SetPoint("BOTTOMLEFT",card,"BOTTOMLEFT",0, 0); t:SetPoint("BOTTOMRIGHT",card,"BOTTOMRIGHT",0, 0)
        elseif point=="LEFT"   then t:SetWidth(1);  t:SetPoint("TOPLEFT",   card,"TOPLEFT",   0, 0); t:SetPoint("BOTTOMLEFT", card,"BOTTOMLEFT", 0, 0)
        elseif point=="RIGHT"  then t:SetWidth(1);  t:SetPoint("TOPRIGHT",  card,"TOPRIGHT",  0, 0); t:SetPoint("BOTTOMRIGHT",card,"BOTTOMRIGHT",0, 0) end
    end
    Border("LEFT"); Border("RIGHT"); Border("BOTTOM")
    -- Top border in gold accent
    Border("TOP", 0.55, 0.45, 0.12, 0.9)

    card._rows  = {}
    card._totalH = CARD_PAD_Y

    function card:AddRow(row, extraPad)
        local pad = extraPad or 0
        if #self._rows == 0 then
            row:SetPoint("TOPLEFT",  self, "TOPLEFT",  CARD_PAD_X,  -(self._totalH))
            row:SetPoint("TOPRIGHT", self, "TOPRIGHT", -CARD_PAD_X, 0)
        else
            local prev = self._rows[#self._rows]
            row:SetPoint("TOPLEFT",  prev, "BOTTOMLEFT",  0, -pad)
            row:SetPoint("TOPRIGHT", prev, "TOPRIGHT",     0, 0)
        end
        table.insert(self._rows, row)
        self._totalH = self._totalH + row:GetHeight() + pad
    end

    function card:Finalize()
        self._totalH = self._totalH + CARD_PAD_Y
        self:SetHeight(self._totalH)
    end

    return card
end

-- ============================================================
-- SIDEBAR TAB BUTTON
-- ============================================================
local function CreateTabButton(parent, label, icon, yOffset)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(SIDEBAR_W - 6, SIDEBAR_BTN_H)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 3, yOffset)

    -- Active background: warm amber tint (matches WaypointUI)
    local bgActive = btn:CreateTexture(nil, "BACKGROUND")
    bgActive:SetAllPoints()
    bgActive:SetColorTexture(0.28, 0.20, 0.06, 0.85)
    bgActive:Hide()
    btn._bgActive = bgActive

    -- Left gold accent strip
    local strip = btn:CreateTexture(nil, "BORDER")
    strip:SetColorTexture(0.96, 0.78, 0.28, 1)
    strip:SetSize(3, SIDEBAR_BTN_H - 8)
    strip:SetPoint("LEFT", btn, "LEFT", 0, 0)
    strip:Hide()
    btn._strip = strip

    -- Hover glow
    local hl = btn:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(); hl:SetColorTexture(1, 0.85, 0.4, 0.08)
    btn:SetHighlightTexture(hl)

    -- Icon
    local iconTex
    if icon then
        iconTex = btn:CreateTexture(nil, "ARTWORK")
        iconTex:SetSize(18, 18)
        iconTex:SetPoint("LEFT", btn, "LEFT", 10, 0)
        if type(icon) == "number" then
            iconTex:SetTexture(icon)
        else
            iconTex:SetAtlas(icon)
        end
    end

    -- Label
    local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("LEFT", btn, "LEFT", icon and 34 or 14, 0)
    lbl:SetText(label)
    lbl:SetTextColor(0.72, 0.72, 0.72)
    btn._label = lbl

    btn.SetActive = function(self, active)
        self._bgActive:SetShown(active)
        self._strip:SetShown(active)
        self._label:SetTextColor(
            active and 0.98 or 0.72,
            active and 0.88 or 0.72,
            active and 0.35 or 0.72
        )
        if active then
            self._label:SetFont(self._label:GetFont(), select(2, self._label:GetFont()), "")
        end
    end

    return btn
end

-- ============================================================
-- MAIN GUI FUNCTION
-- ============================================================
function guiGeneralTab()
    -- Shared initialization
    local mainGuiAnchor = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor:SetPoint("TOPLEFT", 15, -15)
    mainGuiAnchor:SetText(" ")

    BetterBlizzFrames.searchName = L["Search_Name_General"]

    local profilesFrame = guiProfiles()

    -- Midnight notice banner
    local midnightBeta = BetterBlizzFrames:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    midnightBeta:SetPoint("BOTTOM", SettingsPanel, "TOP", 0, 0)
    midnightBeta:SetText(L["Msg_Midnight_Available"])
    if useCustomFonts then
        midnightBeta:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
    else
        local gameFont = GameFontNormal:GetFont()
        midnightBeta:SetFont(gameFont, 24, "OUTLINE")
    end
    midnightBeta:Hide()
    BetterBlizzFrames:HookScript("OnShow", function() midnightBeta:Show() end)
    BetterBlizzFrames:HookScript("OnHide", function() midnightBeta:Hide() end)

    -- Background texture
    local bgImg = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", BetterBlizzFrames, "CENTER", -8, 4)
    bgImg:SetSize(680, 610); bgImg:SetAlpha(0.4); bgImg:SetVertexColor(0, 0, 0)

    -- Search button + pointer
    local newSearch = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearch:SetAtlas("NewCharacter-Horde", true)
    newSearch:SetPoint("BOTTOM", BetterBlizzFrames, "TOP", -70, 2)
    CreateTooltipTwo(newSearch, L["Tooltip_Search_New"] .. " |A:shop-games-magnifyingglass:17:17|a", L["Tooltip_Search_Desc"])
    local newSearchPoint = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearchPoint:SetAtlas("auctionhouse-icon-buyallarrow", true)
    newSearchPoint:SetPoint("LEFT", newSearch, "RIGHT", -25, 0)
    newSearchPoint:SetRotation(math.pi / 2)

    CreateSearchFrame()
    CreateTitle(BetterBlizzFrames)
    if BetterBlizzFrames.titleText then
        BetterBlizzFrames.titleText:Hide()
        BetterBlizzFrames.loadGUI:Hide()
    end

    -- ============================================================
    -- ROOT LAYOUT
    -- ============================================================
    local guiRoot = BetterBlizzFrames

    -- Dark overlay behind the whole panel content area
    local panelBg = CreateFrame("Frame", nil, guiRoot)
    panelBg:SetPoint("TOPLEFT", guiRoot, "TOPLEFT", 8, -46)
    panelBg:SetPoint("BOTTOMRIGHT", guiRoot, "BOTTOMRIGHT", -8, 4)
    local panelBgTex = panelBg:CreateTexture(nil, "BACKGROUND")
    panelBgTex:SetAllPoints()
    panelBgTex:SetColorTexture(0.04, 0.04, 0.06, 0.7)

    -- ============================================================
    -- SIDEBAR
    -- ============================================================
    local sidebar = CreateFrame("Frame", nil, guiRoot)
    sidebar:SetPoint("TOPLEFT", guiRoot, "TOPLEFT", 8, -46)
    sidebar:SetSize(SIDEBAR_W, 510)

    local sidebarBg = sidebar:CreateTexture(nil, "BACKGROUND")
    sidebarBg:SetAllPoints()
    sidebarBg:SetColorTexture(0.06, 0.06, 0.09, 0.95)

    local sidebarDivider = sidebar:CreateTexture(nil, "BORDER")
    sidebarDivider:SetColorTexture(0.25, 0.22, 0.12, 0.8)
    sidebarDivider:SetWidth(1)
    sidebarDivider:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 0, 0)
    sidebarDivider:SetPoint("BOTTOMLEFT", sidebar, "BOTTOMRIGHT", 0, 0)

    -- ============================================================
    -- TAB DEFINITIONS
    -- ============================================================
    local tabDefs = {
        { label = L["Tab_General_Settings"], icon = "optionsicon-brown" },
        { label = L["Tab_Player_Frame"],     icon = "groupfinder-icon-friend" },
        { label = L["Tab_Party_Frame"],      icon = "groupfinder-icon-friend" },
        { label = L["Tab_All_Frames"],       icon = "groupfinder-icon-friend" },
        { label = L["Tab_Target_Focus"],     icon = "groupfinder-icon-friend" },
        { label = L["Tab_ToT_FocusToT"],     icon = "TargetCrosshairs" },
        { label = L["Tab_Chat_Frame"],       icon = "transmog-icon-chat" },
        { label = L["Tab_Extra_Features"],   icon = "questlog-questtypeicon-pvp" },
        { label = L["Tab_Arena_Names"],      icon = "questlog-questtypeicon-pvp" },
        { label = L["Tab_Pet_Frame"],        icon = "newplayerchat-chaticon-newcomer" },
    }

    local contentPanels = {}
    local sidebarButtons = {}

    local function SwitchTab(index)
        for i, panel in ipairs(contentPanels) do panel:SetShown(i == index) end
        for i, btn in ipairs(sidebarButtons) do btn:SetActive(i == index) end
    end

    -- Helper: create a scrollable content panel
    local function NewTabPanel()
        local container = CreateFrame("Frame", nil, guiRoot)
        container:SetPoint("TOPLEFT", guiRoot, "TOPLEFT", SIDEBAR_W + 12, -46)
        container:SetSize(CONTENT_W, CONTENT_H)

        local scroll = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
        scroll:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -20, 4)

        local child = CreateFrame("Frame", nil, scroll)
        child:SetSize(CONTENT_W - 24, 3000)
        scroll:SetScrollChild(child)

        container.child = child
        return container
    end

    -- Build tabs and panels
    for i, def in ipairs(tabDefs) do
        local yOff = -((i - 1) * (SIDEBAR_BTN_H + SIDEBAR_GAP))
        local btn = CreateTabButton(sidebar, def.label, def.icon, yOff)
        local panel = NewTabPanel()
        panel:Hide()
        table.insert(contentPanels, panel)
        table.insert(sidebarButtons, btn)
        btn:SetScript("OnClick", function() SwitchTab(i) end)
    end

    -- ============================================================
    -- CONTENT HELPERS
    -- ============================================================
    -- Quickly build a card from a list of rows, anchored below the previous card/header
    local lastAnchor = nil  -- tracks the last thing added in the current panel

    local function ResetAnchor() lastAnchor = nil end

    local function BuildCard(child, rowDefs, hdrWidget)
        local card = CreateCard(child, hdrWidget or lastAnchor, hdrWidget and -4 or -CARD_GAP)
        for _, rowDef in ipairs(rowDefs) do
            card:AddRow(rowDef.row, rowDef.gap)
        end
        card:Finalize()
        lastAnchor = card
        return card
    end

    -- ============================================================
    -- TAB 1: GENERAL SETTINGS
    -- ============================================================
    do
        local c = contentPanels[1].child
        ResetAnchor()

        -- Section: Frames
        local hdr1 = CreateSectionHeader(c, L["Section_Frames"], nil)
        lastAnchor = hdr1

        local row1, cb1 = CreateOptionRow(c, "hideArenaFrames", L["Hide_Arena_Frames"], L["Desc_Hide_Arena_Frames"], BBF.HideArenaFrames)
        cb1:HookScript("OnClick", function(self) if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end end)
        CreateTooltip(cb1, L["Tooltip_Hide_Arena_Frames"])

        local row2, cb2 = CreateOptionRow(c, "hideBossFrames", L["Hide_Boss_Frames"], L["Desc_Hide_Boss_Frames"], BBF.HideArenaFrames)
        CreateTooltip(cb2, L["Tooltip_Hide_Boss_Frames"])

        local row3, cb3 = CreateOptionRow(c, "playerFrameOCD", L["OCD_Tweaks"], L["Desc_OCD_Tweaks"], BBF.FixStupidBlizzPTRShit)
        cb3:HookScript("OnClick", function() BBF.AllNameChanges(); StaticPopup_Show("BBF_CONFIRM_RELOAD") end)
        CreateTooltip(cb3, L["Tooltip_OCD_Tweaks_Retail"])

        -- Boss frame sub-checkboxes (Party / Raid) – placed after the boss frames card closes
        local hideBossFramesParty = CreateCheckbox("hideBossFramesParty", L["Party"], c, nil, BBF.HideArenaFrames)
        local hideBossFramesRaid  = CreateCheckbox("hideBossFramesRaid",  L["Raid"],  c, nil, BBF.HideArenaFrames)
        -- We'll position them relative to row2 once card is built

        local card1 = CreateCard(c, hdr1, -4)
        card1:AddRow(row1); card1:AddRow(row2); card1:AddRow(row3)
        card1:Finalize()
        lastAnchor = card1

        -- Position party/raid sub-checkboxes to the right of the boss frames row label
        hideBossFramesParty:SetPoint("LEFT", row2.title, "RIGHT", 8, 0)
        hideBossFramesRaid:SetPoint("LEFT", hideBossFramesParty.text, "RIGHT", 0, 0)
        CreateTooltip(hideBossFramesParty, L["Tooltip_Hide_Boss_Frames_Party"], "ANCHOR_LEFT")
        CreateTooltip(hideBossFramesRaid, L["Tooltip_Hide_Boss_Frames_Raid"], "ANCHOR_LEFT")

        cb2:HookScript("OnClick", function(self)
            if self:GetChecked() then
                BetterBlizzFramesDB.overShieldsCompact = true; BetterBlizzFramesDB.hideBossFramesParty = true
                hideBossFramesParty:SetAlpha(1); hideBossFramesParty:Enable(); hideBossFramesParty:SetChecked(true)
                hideBossFramesRaid:SetAlpha(1);  hideBossFramesRaid:Enable();  hideBossFramesRaid:SetChecked(true)
            else
                BetterBlizzFramesDB.overShieldsCompact = false; BetterBlizzFramesDB.hideBossFramesParty = false
                hideBossFramesParty:SetAlpha(0); hideBossFramesParty:Disable(); hideBossFramesParty:SetChecked(false)
                hideBossFramesRaid:SetAlpha(0);  hideBossFramesRaid:Disable();  hideBossFramesRaid:SetChecked(false)
                StaticPopup_Show("BBF_CONFIRM_RELOAD")
            end
        end)
        if not BetterBlizzFramesDB.hideBossFrames then
            hideBossFramesParty:SetAlpha(0); hideBossFramesParty:Disable()
            hideBossFramesRaid:SetAlpha(0);  hideBossFramesRaid:Disable()
        end

        -- Section: Crowd Control
        local hdr2 = CreateSectionHeader(c, L["Section_Crowd_Control"], lastAnchor)

        local rowCC1, cbCC1 = CreateOptionRow(c, "hideLossOfControlFrameBg",    L["Hide_CC_Background"], L["Desc_Hide_CC_Background"], BBF.HideFrames)
        cbCC1:HookScript("OnClick", function() BBF.ToggleLossOfControlTestMode() end)
        CreateTooltip(cbCC1, L["Tooltip_Hide_CC_Background"])

        local rowCC2, cbCC2 = CreateOptionRow(c, "hideLossOfControlFrameLines", L["Hide_CC_Red_Lines"],  L["Desc_Hide_CC_Red_Lines"],  BBF.HideFrames)
        cbCC2:HookScript("OnClick", function() BBF.ToggleLossOfControlTestMode() end)
        CreateTooltip(cbCC2, L["Tooltip_Hide_CC_Red_Lines"])

        local rowCC3, slCC3 = CreateSliderRow(c, "lossOfControlScale", L["CC_Scale"], L["Desc_CC_Scale"], 0.4, 1.4, 0.01, L["CC_Scale"])
        CreateTooltipTwo(slCC3, L["Loss_of_Control_Scale"], L["Tooltip_CC_Scale_Desc"])

        local card2 = CreateCard(c, hdr2, -4)
        card2:AddRow(rowCC1); card2:AddRow(rowCC2); card2:AddRow(rowCC3)
        card2:Finalize()
        lastAnchor = card2

        -- Section: Dark Mode
        local hdr3 = CreateSectionHeader(c, L["Section_Dark_Mode"], lastAnchor)

        local rowDM0, cbDM0 = CreateOptionRow(c, "darkModeUi",              L["Dark_Mode"],          L["Desc_Dark_Mode"],             nil)
        cbDM0:HookScript("OnClick", function() BBF.DarkmodeFrames(true); CheckAndToggleCheckboxes(cbDM0, 0) end)
        CreateTooltip(cbDM0, L["Tooltip_Dark_Mode"])

        local rowDM1, cbDM1 = CreateOptionRow(c, "darkModeCastbars",        L["Castbars"],           L["Desc_Dark_Mode_Castbars"])
        cbDM1:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
        CreateTooltip(cbDM1, L["Dark_Borders_Castbars"])

        local rowDM2, cbDM2 = CreateOptionRow(c, "darkModeActionBars",      L["ActionBars"],         L["Desc_Dark_Mode_ActionBars"])
        cbDM2:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
        CreateTooltip(cbDM2, L["Dark_Borders_ActionBars"])

        local rowDM3, cbDM3 = CreateOptionRow(c, "darkModeUiAura",          L["Auras"],              L["Desc_Dark_Mode_Auras"])
        cbDM3:HookScript("OnClick", function() StaticPopup_Show("BBF_CONFIRM_RELOAD"); BBF.DarkmodeFrames(true) end)
        CreateTooltip(cbDM3, L["Dark_Borders_Aura_Icons"])

        local rowDM4, cbDM4 = CreateOptionRow(c, "darkModeMinimap",         L["Minimap"],            L["Desc_Dark_Mode_Minimap"])
        cbDM4:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
        CreateTooltip(cbDM4, L["Dark_Mode_Minimap"])

        local rowDM5, cbDM5 = CreateOptionRow(c, "darkModeNameplateResource", L["Nameplate_Resource"], L["Desc_Dark_Mode_Nameplate"])
        cbDM5:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
        CreateTooltip(cbDM5, L["Dark_Mode_Nameplate_Resource"])

        local rowDM6, cbDM6 = CreateOptionRow(c, "darkModeGameTooltip",     L["Tooltip"],            L["Desc_Dark_Mode_Tooltip"])
        cbDM6:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
        CreateTooltipTwo(cbDM6, L["Tooltip_Dark_Mode_Tooltip_Title"], L["Tooltip_Dark_Mode_Tooltip_Desc"])

        local rowDM7, cbDM7 = CreateOptionRow(c, "darkModeObjectiveFrame",  L["Objectives"],         L["Desc_Dark_Mode_Objectives"])
        cbDM7:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
        CreateTooltipTwo(cbDM7, L["Tooltip_Dark_Mode_Objectives_Title"], L["Tooltip_Dark_Mode_Objectives_Desc"])

        local rowDM8, cbDM8 = CreateOptionRow(c, "darkModeVigor",           L["Vigor"],              L["Desc_Dark_Mode_Vigor"])
        cbDM8:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
        CreateTooltipTwo(cbDM8, L["Tooltip_Dark_Mode_Vigor_Title"], L["Tooltip_Dark_Mode_Vigor_Desc"])

        local rowDM9, cbDM9 = CreateOptionRow(c, "darkModeEliteTexture",    L["Elite_Texture"],      L["Desc_Dark_Mode_Elite"])
        cbDM9:HookScript("OnClick", function() BBF.DarkmodeFrames(true) end)
        cbDM9:HookScript("OnMouseDown", function(self, button)
            if button == "RightButton" then
                BetterBlizzFramesDB.darkModeEliteTextureDesaturated = not BetterBlizzFramesDB.darkModeEliteTextureDesaturated or nil
                BBF.DarkmodeFrames(true)
            end
        end)
        CreateTooltipTwo(cbDM9, L["Tooltip_Dark_Mode_UI"], L["Tooltip_Dark_Mode_Elite_Desc"])

        local rowDM10, slDM10 = CreateSliderRow(c, "darkModeColor", L["Darkness"], L["Desc_Darkness_Level"], 0, 1, 0.01, L["Darkness"])
        CreateTooltipTwo(slDM10, L["Dark_Mode_Value"], L["Tooltip_Dark_Mode_Value"])

        local card3 = CreateCard(c, hdr3, -4)
        card3:AddRow(rowDM0); card3:AddRow(rowDM1); card3:AddRow(rowDM2); card3:AddRow(rowDM3)
        card3:AddRow(rowDM4); card3:AddRow(rowDM5); card3:AddRow(rowDM6); card3:AddRow(rowDM7)
        card3:AddRow(rowDM8); card3:AddRow(rowDM9); card3:AddRow(rowDM10)
        card3:Finalize()
        lastAnchor = card3

        if not BetterBlizzFramesDB.darkModeUi then
            CheckAndToggleCheckboxes(cbDM0, 0)
        end
    end

    -- ============================================================
    -- TAB 2: PLAYER FRAME
    -- ============================================================
    do
        local c = contentPanels[2].child
        ResetAnchor()

        local hdr1 = CreateSectionHeader(c, L["Section_Behavior"], nil)
        lastAnchor = hdr1

        local r1, cb1 = CreateOptionRow(c, "playerFrameClickthrough", L["Clickthrough"],        L["Desc_Clickthrough"],      BBF.ClickthroughFrames)
        cb1:HookScript("OnClick", function(self) if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end end)
        CreateTooltip(cb1, L["Tooltip_Clickthrough"])

        local textures = BetterBlizzFramesDB.classicFrames and 7 or 4
        local r2, cb2 = CreateOptionRow(c, "playerEliteFrame", L["Elite_Texture"], L["Desc_Elite_Texture"])
        cb2:HookScript("OnClick", function() BBF.PlayerElite(BetterBlizzFramesDB.playerEliteFrameMode) end)
        cb2:HookScript("OnMouseDown", function(self, button)
            if button == "RightButton" and IsShiftKeyDown() then
                BetterBlizzFramesDB.playerEliteFrameDarkmode = not BetterBlizzFramesDB.playerEliteFrameDarkmode or nil
                BBF.PlayerElite(BetterBlizzFramesDB["playerEliteFrameMode"])
            elseif button == "RightButton" then
                BetterBlizzFramesDB["playerEliteFrameMode"] = BetterBlizzFramesDB["playerEliteFrameMode"] % textures + 1
                BBF.PlayerElite(BetterBlizzFramesDB["playerEliteFrameMode"])
            end
        end)
        CreateTooltipTwo(cb2, L["Show_Elite_Texture"], string.format(L["Tooltip_Elite_Texture_Desc"], textures))

        local r3, cb3 = CreateOptionRow(c, "playerReputationColor",      L["Add_Reputation_Color"], L["Desc_Reputation_Color"], BBF.PlayerReputationColor)
        CreateTooltip(cb3, L["Tooltip_Add_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:18:98|a")

        local r4, cb4 = CreateOptionRow(c, "playerReputationClassColor", L["Class_Color_Combo"],    L["Desc_Class_Color_Combo"], BBF.PlayerReputationColor)
        CreateTooltip(cb4, L["Tooltip_Class_Color_Reputation"])
        cb3:HookScript("OnClick", function(self)
            if self:GetChecked() then cb4:Enable(); cb4:SetAlpha(1) else cb4:Disable(); cb4:SetAlpha(0) end
        end)
        if not BetterBlizzFramesDB.playerReputationColor then cb4:SetAlpha(0); cb4:Disable() end

        local card1 = CreateCard(c, hdr1, -4)
        card1:AddRow(r1); card1:AddRow(r2); card1:AddRow(r3); card1:AddRow(r4)
        card1:Finalize(); lastAnchor = card1

        -- Section: Visibility
        local hdr2 = CreateSectionHeader(c, L["Section_Visibility"], lastAnchor)

        local rv1, cbv1 = CreateOptionRow(c, "hidePlayerName",       L["Hide_Names"],          L["Desc_Hide_Names"],          BBF.UpdateNameSettings)
        cbv1:HookScript("OnClick", function() BBF.SetCenteredNamesCaller() end)

        local rv2, cbv2 = CreateOptionRow(c, "symmetricPlayerFrame", L["Mirror_TargetFrame"],  L["Desc_Mirror_TargetFrame"],  BBF.SymmetricPlayerFrame)
        CreateTooltipTwo(cbv2, L["Mirror_TargetFrame"], L["Tooltip_Mirror_TargetFrame_Desc"])
        cbv2:SetScript("OnClick", function(self) self:SetChecked(BetterBlizzFramesDB.symmetricPlayerFrame or false) end)
        cbv2:SetScript("OnMouseDown", function(self, button)
            if button == "RightButton" then
                StaticPopup_Show("BBF_CONFIRM_RELOAD")
                if BetterBlizzFramesDB.symmetricPlayerFrame then
                    BetterBlizzFramesDB.symmetricPlayerFrame = nil; cbv2:SetChecked(false)
                else cbv2:SetChecked(true); BetterBlizzFramesDB.symmetricPlayerFrame = true end
            end
        end)

        local rv3, cbv3 = CreateOptionRow(c, "hidePlayerPower",       L["Hide_Resource_Power"], L["Desc_Hide_Resource_Power"], BBF.HideFrames)
        CreateTooltipTwo(cbv3, L["Hide_Resource_Power"], L["Tooltip_Hide_Resource_Power_Desc"])

        local rv4, cbv4 = CreateOptionRow(c, "hideResourceTooltip",   L["Hide_Resource_Tooltip"], L["Desc_Hide_Resource_Tooltip"], BBF.HideClassResourceTooltip)
        CreateTooltipTwo(cbv4, L["Hide_Resource_Tooltip"], L["Tooltip_Hide_Resource_Tooltip_Desc"])

        local rv5, cbv5 = CreateOptionRow(c, "hideManaFeedback",      L["Hide_Mana_Feedback"],  L["Desc_Hide_Mana_Feedback"],  BBF.HideFrames)
        CreateTooltipTwo(cbv5, L["Hide_Mana_Feedback"], L["Tooltip_Hide_Mana_Feedback_Desc"])

        local rv6, cbv6 = CreateOptionRow(c, "hidePlayerRestAnimation", L["Hide_Zzz_Rest_Animation"], L["Desc_Hide_Rest_Animation"], BBF.HideFrames)
        CreateTooltip(cbv6, L["Tooltip_Hide_Zzz_Rest"])

        -- Class-specific popup for hidePlayerPower
        local classOptionsFrame
        local function OpenClassSpecificWindow()
            if not classOptionsFrame then
                classOptionsFrame = CreateFrame("Frame", "ClassOptionsFrame", UIParent, "BasicFrameTemplateWithInset")
                classOptionsFrame:SetSize(185, 210); classOptionsFrame:SetPoint("CENTER"); classOptionsFrame:SetFrameStrata("DIALOG")
                classOptionsFrame:SetMovable(true); classOptionsFrame:EnableMouse(true); classOptionsFrame:RegisterForDrag("LeftButton")
                classOptionsFrame:SetScript("OnDragStart", classOptionsFrame.StartMoving); classOptionsFrame:SetScript("OnDragStop", classOptionsFrame.StopMovingOrSizing)
                classOptionsFrame.title = classOptionsFrame:CreateFontString(nil, "OVERLAY"); classOptionsFrame.title:SetFontObject("GameFontHighlight")
                classOptionsFrame.title:SetPoint("LEFT", classOptionsFrame.TitleBg, "LEFT", 5, 0); classOptionsFrame.title:SetText(L["Class_Specific_Options"])
                local classes = {
                    {classID=11,var="hidePlayerPowerNoDruid",color=RAID_CLASS_COLORS["DRUID"]},{classID=4,var="hidePlayerPowerNoRogue",color=RAID_CLASS_COLORS["ROGUE"]},
                    {classID=9,var="hidePlayerPowerNoWarlock",color=RAID_CLASS_COLORS["WARLOCK"]},{classID=2,var="hidePlayerPowerNoPaladin",color=RAID_CLASS_COLORS["PALADIN"]},
                    {classID=6,var="hidePlayerPowerNoDeathKnight",color=RAID_CLASS_COLORS["DEATHKNIGHT"]},{classID=13,var="hidePlayerPowerNoEvoker",color=RAID_CLASS_COLORS["EVOKER"]},
                    {classID=10,var="hidePlayerPowerNoMonk",color=RAID_CLASS_COLORS["MONK"]},{classID=8,var="hidePlayerPowerNoMage",color=RAID_CLASS_COLORS["MAGE"]},
                }
                local prev
                for i, cd in ipairs(classes) do
                    local cb = CreateFrame("CheckButton", nil, classOptionsFrame, "UICheckButtonTemplate"); cb:SetSize(24, 24)
                    local name = GetClassInfo(cd.classID)
                    cb.Text:SetText(string.format(L["Ignore_Class"], name)); cb.Text:SetTextColor(cd.color.r, cd.color.g, cd.color.b)
                    if i == 1 then cb:SetPoint("TOPLEFT", classOptionsFrame, "TOPLEFT", 10, -30) else cb:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, 3) end
                    cb:SetChecked(BetterBlizzFramesDB[cd.var])
                    cb:SetScript("OnClick", function(self) BetterBlizzFramesDB[cd.var] = self:GetChecked() or nil; BBF.HideFrames() end)
                    prev = cb
                end
                classOptionsFrame:Show()
            else classOptionsFrame:SetShown(not classOptionsFrame:IsShown()) end
        end
        cbv3:SetScript("OnMouseDown", function(self, button) if button == "RightButton" then OpenClassSpecificWindow() end end)

        local card2 = CreateCard(c, hdr2, -4)
        card2:AddRow(rv1); card2:AddRow(rv2); card2:AddRow(rv3); card2:AddRow(rv4); card2:AddRow(rv5); card2:AddRow(rv6)
        card2:Finalize(); lastAnchor = card2

        -- Section: Icons
        local hdr3 = CreateSectionHeader(c, L["Section_Icons"], lastAnchor)
        local ri = {}
        local iconOptions = {
            {"hidePlayerCornerIcon",      L["Hide_Corner_Icon"],    L["Desc_Hide_Corner_Icon"],  BBF.HideFrames},
            {"hidePlayerHealthLossAnim",  L["Hide_Health_Loss_FX"], L["Desc_Hide_Health_Loss"],  BBF.HideFrames},
            {"hidePlayerRestGlow",        L["Hide_Rest_Glow"],      L["Desc_Hide_Rest_Glow"],    BBF.HideFrames},
            {"hideFullPower",             L["Hide_Full_Mana_FX"],   L["Desc_Hide_Full_Mana"],    BBF.HideFrames},
            {"hideCombatIcon",            L["Hide_Combat_Icon"],    L["Desc_Hide_Combat_Icon"],  BBF.HideFrames},
            {"hideHitIndicator",          L["Hide_Hit_Indicator"],  L["Desc_Hide_Hit_Indicator"],BBF.HideFrames},
            {"hideGroupIndicator",        L["Hide_Group_Indicator"],L["Desc_Hide_Group_Indicator"],BBF.HideFrames},
            {"hideTotemFrame",            L["Hide_Totem_Frame"],    L["Desc_Hide_Totem_Frame"],  BBF.HideFrames},
            {"hidePlayerLeaderIcon",      L["Hide_Leader_Icon"],    L["Desc_Hide_Leader_Icon"],  BBF.HideFrames},
            {"hidePlayerGuideIcon",       L["Hide_Guide_Icon"],     L["Desc_Hide_Guide_Icon"],   BBF.HideFrames},
            {"hidePlayerRoleIcon",        L["Hide_Role_Icon"],      L["Desc_Hide_Role_Icon"],    BBF.HideFrames},
            {"hidePvpTimerText",          L["Hide_PvP_Timer"],      L["Desc_Hide_PvP_Timer"],    BBF.HideFrames},
        }
        for _, opt in ipairs(iconOptions) do
            local row, cb = CreateOptionRow(c, opt[1], opt[2], opt[3], opt[4])
            table.insert(ri, row)
        end
        local card3 = CreateCard(c, hdr3, -4)
        for _, row in ipairs(ri) do card3:AddRow(row) end
        card3:Finalize(); lastAnchor = card3
    end

    -- ============================================================
    -- TAB 3: PARTY FRAME
    -- ============================================================
    do
        local c = contentPanels[3].child
        ResetAnchor()

        local hdr1 = CreateSectionHeader(c, L["Section_Behavior"], nil); lastAnchor = hdr1

        local partyOpts = {
            {"showPartyCastbar",            L["Party_Castbars"],              L["Desc_Party_Castbars"],       BBF.UpdateCastbars},
            {"hidePartyRoles",              L["Hide_Role_Icons"],             L["Desc_Hide_Role_Icons"]},
            {"newRaidFrameRoleIcons",       L["New_Role_Icons"],              L["Desc_New_Role_Icons"]},
            {"hidePartyFramesInArena",      L["Hide_Party_in_Arena"],         L["Desc_Hide_Party_Arena"],     BBF.HidePartyInArena},
            {"raidFramePixelBorder",        L["Pixel_Border"],                L["Desc_Pixel_Border"]},
        }
        local card1 = CreateCard(c, hdr1, -4)
        for _, opt in ipairs(partyOpts) do
            local row, cb = CreateOptionRow(c, opt[1], opt[2], opt[3], opt[4])
            if opt[1] == "hidePartyRoles" then cb:HookScript("OnClick", function() BBF.PartyNameChange() end) end
            if opt[1] == "newRaidFrameRoleIcons" then cb:HookScript("OnClick", function() StaticPopup_Show("BBF_CONFIRM_RELOAD") end) end
            CreateTooltip(cb, L["Tooltip_Hide_Party_Role_Icons"] or "")
            card1:AddRow(row)
        end
        card1:Finalize(); lastAnchor = card1

        local hdr2 = CreateSectionHeader(c, L["Section_Visibility"], lastAnchor)
        local visOpts = {
            {"hidePartyNames",              L["Hide_Names"],                  L["Desc_Hide_Party_Names"],     BBF.AllNameChanges},
            {"hidePartyAggroHighlight",     L["Hide_Aggro_Highlight"],        L["Desc_Hide_Aggro_Highlight"], BBF.HideFrames},
            {"hidePartyFrameTitle",         L["Hide_CompactPartyFrame_Title"],L["Desc_Hide_Party_Title"],     BBF.HideFrames},
            {"hideRaidFrameManager",        L["Hide_RaidFrameManager"],       L["Desc_Hide_RaidManager"],     BBF.HideFrames},
            {"hideRaidFrameContainerBorder",L["Hide_Container_Border"],       L["Desc_Hide_Container_Border"],BBF.HideFrames},
            {"classColorPartyNames",        L["Color_Names"],                 L["Desc_Class_Color_Names"],    BBF.AllNameChanges},
        }
        local card2 = CreateCard(c, hdr2, -4)
        for _, opt in ipairs(visOpts) do
            local row, _ = CreateOptionRow(c, opt[1], opt[2], opt[3], opt[4])
            card2:AddRow(row)
        end
        card2:Finalize(); lastAnchor = card2

        local hdr3 = CreateSectionHeader(c, L["Section_Scale_Position"], lastAnchor)
        local rowScale, _ = CreateSliderRow(c, "partyFrameScale", L["Party_Frame_Scale"], L["Desc_Party_Scale"], 0.7, 1.7, 0.01, L["Party_Frame_Scale"])
        local card3 = CreateCard(c, hdr3, -4)
        card3:AddRow(rowScale); card3:Finalize(); lastAnchor = card3
    end

    -- ============================================================
    -- TAB 4: ALL FRAMES
    -- ============================================================
    do
        local c = contentPanels[4].child
        ResetAnchor()

        local hdr1 = CreateSectionHeader(c, L["Section_Frames"], nil); lastAnchor = hdr1
        local frameOpts = {
            {"classicFrames",        L["Classic_Frames"], L["Desc_Classic_Frames"]},
            {"noPortraitModes",      L["No_Portrait"],    L["Desc_No_Portrait"]},
            {"noPortraitPixelBorder",L["NP_PixelBorder"], "Use pixel border for No Portrait mode."},
        }
        local card1 = CreateCard(c, hdr1, -4)
        for _, opt in ipairs(frameOpts) do
            local row, cb = CreateOptionRow(c, opt[1], opt[2], opt[3])
            if opt[1] == "classicFrames" then
                cb:HookScript("OnClick", function(self)
                    BetterBlizzFramesDB.noPortraitModes = false
                    StaticPopup_Show("BBF_CONFIRM_RELOAD")
                end)
            end
            if opt[1] == "noPortraitModes" then cb:HookScript("OnClick", function() BetterBlizzFramesDB.classicFrames = false; StaticPopup_Show("BBF_CONFIRM_RELOAD") end) end
            card1:AddRow(row)
        end
        card1:Finalize(); lastAnchor = card1

        local hdr2 = CreateSectionHeader(c, L["Section_Colors"], lastAnchor)
        local colorOpts = {
            {"classColorFrames",      L["Class_Color_Health"],      L["Desc_Class_Color_Health"]},
            {"customHealthbarColors", L["Custom_Color_Health_Mana"],L["Desc_Custom_Colors"]},
        }
        local card2 = CreateCard(c, hdr2, -4)
        for _, opt in ipairs(colorOpts) do
            local row, cb = CreateOptionRow(c, opt[1], opt[2], opt[3])
            if opt[1] == "classColorFrames" then
                cb:HookScript("OnClick", function(self) if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end; BBF.UpdateFrames() end)
            end
            if opt[1] == "customHealthbarColors" then cb:HookScript("OnClick", function(self) BBF.UpdateFrames(); if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end end) end
            card2:AddRow(row)
        end
        card2:Finalize(); lastAnchor = card2

        local hdr3 = CreateSectionHeader(c, L["Section_Appearance"], lastAnchor)
        local appOpts = {
            {"centerNames",        L["Center_Name"],    L["Desc_Center_Name"],    BBF.SetCenteredNamesCaller},
            {"removeRealmNames",   L["Hide_Realm"],     L["Desc_Hide_Realm"],     BBF.AllNameChanges},
            {"formatNumbers",      L["Format_Numbers"], L["Desc_Format_Numbers"], BBF.AllNameChanges},
            {"hideMaxHealth",      L["No_Max"],         L["Desc_No_Max"],         BBF.AllNameChanges},
            {"hideCombatGlow",     L["Hide_Combat_Glow"],L["Desc_Hide_Combat_Glow"],BBF.HideFrames},
            {"hideShadow",         L["Hide_Shadow"],    L["Desc_Hide_Shadow"],    BBF.HideFrames},
            {"hideDragon",         L["Hide_Dragon"],    L["Desc_Hide_Dragon"],    BBF.HideFrames},
            {"hideThreat",         L["Hide_Threat"],    L["Desc_Hide_Threat"],    BBF.HideFrames},
        }
        local card3 = CreateCard(c, hdr3, -4)
        for _, opt in ipairs(appOpts) do
            local row, _ = CreateOptionRow(c, opt[1], opt[2], opt[3], opt[4])
            card3:AddRow(row)
        end
        card3:Finalize(); lastAnchor = card3
    end

    -- ============================================================
    -- TAB 5: TARGET & FOCUS
    -- ============================================================
    do
        local c = contentPanels[5].child
        ResetAnchor()

        local hdrT = CreateSectionHeader(c, L["Target_Frame"], nil); lastAnchor = hdrT
        local tOpts = {
            {"targetFrameClickthrough",          L["Clickthrough"],          L["Desc_Target_Clickthrough"]},
            {"hideTargetName",                   L["Hide_Names"],            L["Desc_Hide_Names"],         BBF.UpdateNameSettings},
            {"hideTargetLeaderIcon",             L["Hide_Leader_Icon"],      L["Desc_Hide_Target_Leader"], BBF.HideFrames},
            {"classColorTargetReputationTexture",L["Reputation_Class_Color"],L["Desc_Target_Rep_Color"]},
            {"hideTargetReputationColor",        L["Hide_Reputation_Color"], L["Desc_Hide_Target_Rep"],    BBF.HideFrames},
        }
        local card1 = CreateCard(c, hdrT, -4)
        for _, opt in ipairs(tOpts) do
            local row, cb = CreateOptionRow(c, opt[1], opt[2], opt[3], opt[4])
            if opt[1] == "targetFrameClickthrough" then cb:HookScript("OnClick", function(self) if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end end) end
            if opt[1] == "hideTargetName" then cb:HookScript("OnClick", function() BBF.AllNameChanges() end) end
            if opt[1] == "classColorTargetReputationTexture" then
                cb:HookScript("OnClick", function(self)
                    if self:GetChecked() then BBF.ClassColorReputation(TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "target")
                    else BBF.ResetClassColorReputation(TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "target") end
                end)
            end
            card1:AddRow(row)
        end
        card1:Finalize(); lastAnchor = card1

        local hdrF = CreateSectionHeader(c, L["Focus_Frame"], lastAnchor)
        local fOpts = {
            {"focusFrameClickthrough",           L["Clickthrough"],          L["Desc_Focus_Clickthrough"]},
            {"hideFocusName",                    L["Hide_Names"],            L["Desc_Hide_Names"],        BBF.UpdateNameSettings},
            {"hideFocusLeaderIcon",              L["Hide_Leader_Icon"],      L["Desc_Hide_Focus_Leader"], BBF.HideFrames},
            {"classColorFocusReputationTexture", L["Reputation_Class_Color"],L["Desc_Focus_Rep_Color"]},
            {"hideFocusReputationColor",         L["Hide_Reputation_Color"], L["Desc_Hide_Focus_Rep"],   BBF.HideFrames},
        }
        local card2 = CreateCard(c, hdrF, -4)
        for _, opt in ipairs(fOpts) do
            local row, cb = CreateOptionRow(c, opt[1], opt[2], opt[3], opt[4])
            if opt[1] == "focusFrameClickthrough" then cb:HookScript("OnClick", function(self) if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end end) end
            if opt[1] == "hideFocusName" then cb:HookScript("OnClick", function() BBF.AllNameChanges() end) end
            if opt[1] == "classColorFocusReputationTexture" then
                cb:HookScript("OnClick", function(self)
                    if self:GetChecked() then BBF.ClassColorReputation(FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "focus")
                    else BBF.ResetClassColorReputation(FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, "focus") end
                end)
            end
            card2:AddRow(row)
        end
        card2:Finalize(); lastAnchor = card2
    end

    -- ============================================================
    -- TAB 6: TARGET OF TARGET & FOCUS TOT
    -- ============================================================
    do
        local c = contentPanels[6].child
        ResetAnchor()

        local hdrT = CreateSectionHeader(c, L["Target_of_Target"], nil); lastAnchor = hdrT
        local r1, cb1 = CreateOptionRow(c, "hideTargetToT",      L["Hide_Frame"],        L["Desc_Hide_ToT"],     BBF.HideFrames)
        local r2, cb2 = CreateOptionRow(c, "hideTargetToTName",  L["Hide_Names"],        L["Desc_Hide_ToT_Names"])
        cb2:HookScript("OnClick", function(self)
            if self:GetChecked() then TargetFrame.totFrame.Name:SetAlpha(0); if TargetFrame.totFrame.bbfName then TargetFrame.totFrame.bbfName:SetAlpha(0) end
            else TargetFrame.totFrame.Name:SetAlpha(0); if TargetFrame.totFrame.bbfName then TargetFrame.totFrame.bbfName:SetAlpha(1) end end
        end)
        local r3, cb3 = CreateOptionRow(c, "hideTargetToTDebuffs",L["Hide_ToT_Debuffs"], L["Desc_Hide_ToT_Debuffs"], BBF.HideFrames)
        CreateTooltip(cb3, L["Tooltip_Hide_ToT_Debuffs"])

        local r4, sl4 = CreateSliderRow(c, "targetToTScale", L["Size"],    L["Desc_ToT_Scale"], 0.6, 2.5, 0.01, L["Size"])
        local r5, sl5 = CreateSliderRow(c, "targetToTXPos",  L["X_Offset"],L["Desc_ToT_X"],    -100, 100, 1, "X")
        local r6, sl6 = CreateSliderRow(c, "targetToTYPos",  L["Y_Offset"],L["Desc_ToT_Y"],    -100, 100, 1, "Y")
        BBF.targetToTXPos = sl5

        local card1 = CreateCard(c, hdrT, -4)
        card1:AddRow(r1); card1:AddRow(r2); card1:AddRow(r3); card1:AddRow(r4); card1:AddRow(r5); card1:AddRow(r6)
        card1:Finalize(); lastAnchor = card1

        local hdrF = CreateSectionHeader(c, L["Focus_ToT"], lastAnchor)
        local rf1, cbf1 = CreateOptionRow(c, "hideFocusToT",       L["Hide_Frame"],          L["Desc_Hide_ToT"],     BBF.HideFrames)
        local rf2, cbf2 = CreateOptionRow(c, "hideFocusToTName",   L["Hide_Names"],          L["Desc_Hide_ToT_Names"])
        cbf2:HookScript("OnClick", function(self)
            if self:GetChecked() then FocusFrame.totFrame.Name:SetAlpha(0); if FocusFrame.totFrame.bbfName then FocusFrame.totFrame.bbfName:SetAlpha(0) end
            else FocusFrame.totFrame.Name:SetAlpha(0); if FocusFrame.totFrame.bbfName then FocusFrame.totFrame.bbfName:SetAlpha(1) end end
        end)
        local rf3, cbf3 = CreateOptionRow(c, "hideFocusToTDebuffs",L["Hide_FocusToT_Debuffs"],L["Desc_Hide_ToT_Debuffs"], BBF.HideFrames)
        local rf4, sf4 = CreateSliderRow(c, "focusToTScale", L["Size"],    L["Desc_ToT_Scale"], 0.6, 2.5, 0.01, L["Size"])
        local rf5, sf5 = CreateSliderRow(c, "focusToTXPos",  L["X_Offset"],L["Desc_ToT_X"],    -100, 100, 1, "X")
        local rf6, sf6 = CreateSliderRow(c, "focusToTYPos",  L["Y_Offset"],L["Desc_ToT_Y"],    -100, 100, 1, "Y")
        BBF.focusToTXPos = sf5

        local card2 = CreateCard(c, hdrF, -4)
        card2:AddRow(rf1); card2:AddRow(rf2); card2:AddRow(rf3); card2:AddRow(rf4); card2:AddRow(rf5); card2:AddRow(rf6)
        card2:Finalize(); lastAnchor = card2
    end

    -- ============================================================
    -- TAB 7: CHAT FRAME
    -- ============================================================
    do
        local c = contentPanels[7].child
        ResetAnchor()

        local hdr1 = CreateSectionHeader(c, L["Section_Chat_Appearance"], nil); lastAnchor = hdr1
        local r1, _ = CreateOptionRow(c, "hideChatButtons", L["Hide_Chat_Buttons"], L["Desc_Hide_Chat_Buttons"], BBF.HideFrames)
        CreateTooltip(_, L["Tooltip_Hide_Chat_Buttons"])
        local card1 = CreateCard(c, hdr1, -4); card1:AddRow(r1); card1:Finalize(); lastAnchor = card1

        local hdr2 = CreateSectionHeader(c, L["Section_Chat_Filters"], lastAnchor)
        local filterOpts = {
            {"filterGladiusSpam",    L["Gladius_Spam"],    L["Desc_Filter_Gladius"],  BBF.ChatFilterCaller},
            {"filterNpcArenaSpam",   L["Arena_Npc_Talk"],  L["Desc_Filter_NPC_Arena"],BBF.ChatFilterCaller},
            {"filterTalentSpam",     L["Talent_Spam"],     L["Desc_Filter_Talent"],   BBF.ChatFilterCaller},
            {"filterEmoteSpam",      L["Emote_Spam"],      L["Desc_Filter_Emote"],    BBF.ChatFilterCaller},
            {"filterSystemMessages", L["System_Messages"], L["Desc_Filter_System"],   BBF.ChatFilterCaller},
            {"filterMiscInfo",       L["Misc_Info"],       L["Desc_Filter_Misc"],     BBF.ChatFilterCaller},
        }
        local card2 = CreateCard(c, hdr2, -4)
        for _, opt in ipairs(filterOpts) do
            local row, _ = CreateOptionRow(c, opt[1], opt[2], opt[3], opt[4])
            card2:AddRow(row)
        end
        card2:Finalize(); lastAnchor = card2
    end

    -- ============================================================
    -- TAB 8: EXTRA FEATURES
    -- ============================================================
    do
        local c = contentPanels[8].child
        ResetAnchor()

        local hdr1 = CreateSectionHeader(c, L["Section_Combat"], nil); lastAnchor = hdr1
        local combatOpts = {
            {"combatIndicator", L["Combat_Indicator"], "Show a combat indicator on unit frames."},
            {"healerIndicator", L["Healer_Indicator"], "Show a healer indicator on unit frames."},
            {"absorbIndicator", L["Absorb_Indicator"], "Show absorb shields on unit frames."},
            {"overShields",     L["Overshields"],      "Show overshield bars."},
        }
        local card1 = CreateCard(c, hdr1, -4)
        for _, opt in ipairs(combatOpts) do
            local row, _ = CreateOptionRow(c, opt[1], opt[2], opt[3])
            card1:AddRow(row)
        end
        card1:Finalize(); lastAnchor = card1

        local hdr2 = CreateSectionHeader(c, L["Section_Frames"], lastAnchor)
        local r1, cbQ = CreateOptionRow(c, "queueTimer", L["Queue_Timer"], "Show a queue timer countdown.")
        local r2, cbQA = CreateOptionRow(c, "queueTimerAudio", L["SFX"],     "Play a sound when queue pops.")
        local r3, cbQW = CreateOptionRow(c, "queueTimerWarning", L["Warning"],"Show a warning when queue is about to expire.")
        cbQ:HookScript("OnClick", function(self)
            local show = self:GetChecked()
            cbQA:SetAlpha(show and 1 or 0); if show then cbQA:Enable() else cbQA:Disable() end
            cbQW:SetAlpha(show and 1 or 0); if show then cbQW:Enable() else cbQW:Disable() end
        end)
        if not BetterBlizzFramesDB.queueTimer then cbQA:SetAlpha(0); cbQA:Disable(); cbQW:SetAlpha(0); cbQW:Disable() end
        local card2 = CreateCard(c, hdr2, -4); card2:AddRow(r1); card2:AddRow(r2); card2:AddRow(r3); card2:Finalize(); lastAnchor = card2
    end

    -- ============================================================
    -- TAB 9: ARENA NAMES
    -- ============================================================
    do
        local c = contentPanels[9].child
        ResetAnchor()

        local hdr1 = CreateSectionHeader(c, L["Section_Frames"], nil); lastAnchor = hdr1
        local r1, cb1 = CreateOptionRow(c, "targetAndFocusArenaNames", L["Target_And_Focus_Arena_Names"], L["Desc_Target_Arena_Names"])
        CreateTooltipTwo(cb1, L["Arena_Names"], L["Tooltip_Target_And_Focus_Arena_Names_Desc"], nil, "ANCHOR_LEFT")
        local r2, cb2 = CreateOptionRow(c, "partyArenaNames", L["Party"], L["Desc_Party_Arena_Names"])
        CreateTooltipTwo(cb2, L["Arena_Names"], L["Tooltip_Party_Arena_Names_Desc"], nil, "ANCHOR_LEFT")
        local card1 = CreateCard(c, hdr1, -4); card1:AddRow(r1); card1:AddRow(r2); card1:Finalize(); lastAnchor = card1

        local hdr2 = CreateSectionHeader(c, L["Section_Spec_Display"], lastAnchor)
        local r3, cb3 = CreateOptionRow(c, "showSpecName",      L["Show_Spec_Name"], L["Desc_Show_Spec_Name"])
        local r4, cb4 = CreateOptionRow(c, "shortArenaSpecName",L["Short"],          L["Desc_Short_Spec_Name"])
        local r5, cb5 = CreateOptionRow(c, "showArenaID",       L["Show_Arena_ID"],  L["Desc_Show_Arena_ID"])
        CreateTooltipTwo(cb3, L["Show_Spec_Name"], string.format(L["Tooltip_Show_Spec_Name_Desc"], (BetterBlizzFramesDB.targetAndFocusArenaNamePartyOverride and L["True"] or L["False"])))
        CreateTooltip(cb4, L["Tooltip_Short_Arena_Spec_Name"], "ANCHOR_LEFT")
        CreateTooltip(cb5, L["Tooltip_Show_Arena_ID"])
        local card2 = CreateCard(c, hdr2, -4); card2:AddRow(r3); card2:AddRow(r4); card2:AddRow(r5); card2:Finalize(); lastAnchor = card2

        local function ToggleDependentCheckboxes()
            local enable = cb1:GetChecked() or cb2:GetChecked()
            if enable then EnableElement(cb3); EnableElement(cb4); EnableElement(cb5)
            else DisableElement(cb3); DisableElement(cb4); DisableElement(cb5) end
        end
        ToggleDependentCheckboxes()
        cb1:HookScript("OnClick", ToggleDependentCheckboxes)
        cb2:HookScript("OnClick", ToggleDependentCheckboxes)
    end

    -- ============================================================
    -- TAB 10: PET FRAME
    -- ============================================================
    do
        local c = contentPanels[10].child
        ResetAnchor()

        local hdr1 = CreateSectionHeader(c, L["Section_Visibility"], nil); lastAnchor = hdr1
        local visOpts = {
            {"hidePetFrame",       L["Hide_Pet_Frame"],          L["Desc_Hide_Pet"],           BBF.HideFrames},
            {"hidePetName",        L["Hide_Pet_Name"],           L["Desc_Hide_Pet_Name"]},
            {"hidePetText",        L["Hide_Pet_Statusbar_Text"], L["Desc_Hide_Pet_Text"],       BBF.HideFrames},
            {"hidePetHitIndicator",L["Hide_Pet_Hit_Indicator"],  L["Desc_Hide_Pet_Hit"],        BBF.HideFrames},
        }
        local card1 = CreateCard(c, hdr1, -4)
        for _, opt in ipairs(visOpts) do
            local row, cb = CreateOptionRow(c, opt[1], opt[2], opt[3], opt[4])
            if opt[1] == "hidePetName" then cb:HookScript("OnClick", function() BBF.AllNameChanges() end) end
            card1:AddRow(row)
        end
        card1:Finalize(); lastAnchor = card1

        local hdr2 = CreateSectionHeader(c, L["Section_Behavior"], lastAnchor)
        local r1, cb1 = CreateOptionRow(c, "petCastbar",       L["Pet_Castbar"],              L["Desc_Pet_Castbar"],         BBF.UpdatePetCastbar)
        CreateTooltip(cb1, L["Tooltip_Pet_Castbar"])
        local r2, cb2 = CreateOptionRow(c, "colorPetAfterOwner",L["Color_Pet_After_Player_Class"],L["Desc_Color_Pet"])
        cb2:HookScript("OnClick", function() BBF.UpdateFrames() end)
        local r3, cb3 = CreateOptionRow(c, "hidePetAuraTooltip",L["Hide_Pet_Aura_Tooltip"],   L["Desc_Hide_Pet_Aura_Tooltip"],BBF.HideFrames)
        local card2 = CreateCard(c, hdr2, -4); card2:AddRow(r1); card2:AddRow(r2); card2:AddRow(r3); card2:Finalize(); lastAnchor = card2
    end

    -- Start on tab 1
    SwitchTab(1)
end
