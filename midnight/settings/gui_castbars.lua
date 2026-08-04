if not BBF.isMidnight then return end
local L = BBF.L

local fontSmall = BBF.fontSmall
local fontMedium = BBF.fontMedium
local fontLarge = BBF.fontLarge

local CreateCheckbox = BBF.CreateCheckbox
local CreateSlider = BBF.CreateSlider
local CreateColorBox = BBF.CreateColorBox
local CreateTitle = BBF.CreateTitle
local CreateTooltip = BBF.CreateTooltip
local CreateTooltipTwo = BBF.CreateTooltipTwo
local DisableElement = BBF.DisableElement
local EnableElement = BBF.EnableElement
local CheckAndToggleCheckboxes = BBF.CheckAndToggleCheckboxes

function guiCastbars()
    local BetterBlizzFramesCastbars = CreateFrame("Frame")
    BetterBlizzFramesCastbars.name = L["Castbars"]
    BetterBlizzFramesCastbars.parent = BetterBlizzFrames.name
    local castbarsSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, BetterBlizzFramesCastbars, BetterBlizzFramesCastbars.name, BetterBlizzFramesCastbars.name)
    castbarsSubCategory.ID = BetterBlizzFramesCastbars.name
    CreateTitle(BetterBlizzFramesCastbars)

    -------------------------------------------------------
    -- SIDEBAR NAVIGATION CONTAINER
    -------------------------------------------------------
    local sidebar = CreateFrame("Frame", nil, BetterBlizzFramesCastbars)
    sidebar:SetSize(165, 545)
    sidebar:SetPoint("TOPLEFT", BetterBlizzFramesCastbars, "TOPLEFT", 12, -45)

    local contentParent = CreateFrame("Frame", nil, BetterBlizzFramesCastbars)
    contentParent:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 10, 0)
    contentParent:SetPoint("BOTTOMRIGHT", BetterBlizzFramesCastbars, "BOTTOMRIGHT", -38, 15)

    local categoryList = {
        { id = "player",  label = L["Player_Castbar"],   atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {0.1, 0.6, 1} },
        { id = "target",  label = L["Target_Castbar"],   atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {1, 0, 0} },
        { id = "focus",   label = L["Focus_Castbar"],    atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {0, 1, 0} },
        { id = "party",   label = L["Party_Castbars"],   atlas = "groupfinder-icon-friend", size = {20, 20}, desaturated = true, color = {0.1, 0.6, 1},
          overlays = { { atlas = "groupfinder-icon-friend", size = {16, 16}, offset = {4, 3}, desaturated = true, color = {0, 1, 0} } } },
        { id = "pet",     label = L["Pet_Castbar"],      atlas = "newplayerchat-chaticon-newcomer", size = {19, 19} },
        { id = "general", label = L["General_Settings"], atlas = "optionsicon-brown", size = {20, 20} },
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
        local sf = CreateFrame("ScrollFrame", "BBF_MidnightCastbarsCat_" .. cat.id, contentParent, "ScrollFrameTemplate")
        sf:SetAllPoints(contentParent)
        sf:Hide()

        local cf = CreateFrame("Frame", nil, sf)
        cf.cardWidth = 435
        cf:SetSize(cf.cardWidth, 520)
        sf:SetScrollChild(cf)
        sf.contentFrame = cf

        categoryFrames[cat.id] = sf

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

        local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        txt:SetPoint("LEFT", iconFrame, "RIGHT", 4, 0)
        txt:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
        txt:SetJustifyH("LEFT")
        txt:SetText(cat.label)
        txt:SetTextColor(0.8, 0.8, 0.8)
        btn.Text = txt

        btn:SetScript("OnEnter", function(self)
            if categoryButtons[cat.id] and self ~= categoryButtons[cat.id] then
                self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
                self.Text:SetTextColor(1, 1, 1)
            end
        end)
        btn:SetScript("OnLeave", function(self)
            if categoryButtons[cat.id] and self ~= categoryButtons[cat.id] then
                self:SetBackdropBorderColor(0.25, 0.25, 0.28, 0.8)
                self.Text:SetTextColor(0.8, 0.8, 0.8)
            end
        end)
        btn:SetScript("OnClick", function()
            SelectCategory(cat.id)
        end)

        categoryButtons[cat.id] = btn
    end

    -------------------------------------------------------
    -- CARD HELPERS WITH GOLD HEADERS & TOOLTIP BORDERS
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

    local function AddCardCastbarPreview(card, atlasName, width, height, isPet)
        local previewRow = CreateFrame("Frame", nil, card, "BackdropTemplate")
        local containerWidth = 260
        local containerHeight = 56
        previewRow:SetSize(containerWidth, containerHeight)
        previewRow:SetPoint("TOP", card, "TOP", 0, card.currentY - 4)

        previewRow:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        previewRow:SetBackdropColor(0, 0, 0, 0.6)
        previewRow:SetBackdropBorderColor(0.3, 0.3, 0.35, 0.8)

        local tex = previewRow:CreateTexture(nil, "ARTWORK")
        tex:SetAtlas(atlasName)
        tex:SetSize(width or 180, height or 18)
        tex:SetPoint("CENTER", previewRow, "CENTER", 0, 0)

        if isPet then
            tex:SetDesaturated(true)
            tex:SetVertexColor(1, 0.25, 0.98)
        end

        card.currentY = card.currentY - containerHeight - 12
        card:SetHeight(-card.currentY + 6)
        return tex
    end

    local function AddCardCheckbox(card, dbKey, titleStr, descStr, callback)
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
        title:SetWidth(290)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 290), rowHeight)

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
        title:SetWidth(280)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 280), rowHeight)

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
        title:SetWidth(220)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 220), rowHeight)

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
        title:SetWidth(204)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 204), rowHeight)

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
    -- TAB 1: PLAYER CASTBAR
    -------------------------------------------------------
    local cfPlayer = categoryFrames["player"].contentFrame
    local cardPlayer = CreateOptionCard(cfPlayer, L["Player_Castbar"], nil, -10)

    AddCardCastbarPreview(cardPlayer, "ui-castingbar-filling-standard", 150, 16)

    local playerScale = AddCardSlider(cardPlayer, "playerCastBarScale", L["Size"], "", 0.1, 1.9, 0.01)
    local playerIconX = AddCardSlider(cardPlayer, "playerCastbarIconXPos", L["X_Offset"], "", -200, 200, 1)
    local playerIconY = AddCardSlider(cardPlayer, "playerCastbarIconYPos", L["Y_Offset"], "", -200, 200, 1)
    local playerIconScale = AddCardSlider(cardPlayer, "playerCastBarIconScale", L["Icon_Size"], "", 0.4, 2, 0.01)
    local playerWidth = AddCardSlider(cardPlayer, "playerCastBarWidth", L["Width"], "", 60, 230, 1)
    local playerHeight = AddCardSlider(cardPlayer, "playerCastBarHeight", L["Height"], "", 5, 30, 1)

    local playerShowIcon = AddCardCheckbox(cardPlayer, "playerCastBarShowIcon", L["Icon"], L["Tooltip_Player_Castbar_Icon"], BBF.ShowPlayerCastBarIcon)
    local playerTimer = AddCardCheckbox(cardPlayer, "playerCastBarTimer", L["Timer"], L["Tooltip_Castbar_Timer"], BBF.CastBarTimerCaller)
    local playerTimerCenter = AddCardChildCheckbox(cardPlayer, playerTimer, "playerCastBarTimerCentered", L["Center"], L["Tooltip_Player_Castbar_Timer_Center"], BBF.CastBarTimerCaller)
    local playerNoTextBorder = AddCardCheckbox(cardPlayer, "playerCastBarNoTextBorder", L["Player_Castbar_Simple"], L["Tooltip_Player_Castbar_Simple_Desc"], BBF.ChangeCastbarSizes)
    local playerClassic = AddCardCheckbox(cardPlayer, "classicCastbarsPlayer", L["Classic_Castbar"], L["Tooltip_Classic_Castbar_Desc"], function(self)
        CheckAndToggleCheckboxes(self)
        if self:GetChecked() then BetterBlizzFramesDB.castbarPixelBorder = nil end
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    local playerClassicBorder = AddCardChildCheckbox(cardPlayer, playerClassic, "classicCastbarsPlayerBorder", L["Border"], L["Tooltip_Classic_Border_Desc"], BBF.ChangeCastbarSizes)

    local playerHideBar = AddCardCheckbox(cardPlayer, "hidePlayerCastbar", L["Hide_Bar"], L["Hide_Player_Castbar"], function(self)
        if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end
        BBF.ChangeCastbarSizes()
    end)
    local playerHideIcon = AddCardCheckbox(cardPlayer, "hidePlayerCastbarIcon", L["Hide_Icon"], L["Hide_Player_Castbar_Icon"], BBF.ChangeCastbarSizes)

    -- Reset button
    local resetPlayerRow = CreateFrame("Frame", nil, cardPlayer)
    resetPlayerRow:SetPoint("TOPLEFT", cardPlayer, "TOPLEFT", 6, cardPlayer.currentY)
    resetPlayerRow:SetSize(cardPlayer.cardWidth - 12, 34)
    local resetPlayerBtn = CreateFrame("Button", nil, resetPlayerRow, "UIPanelButtonTemplate")
    resetPlayerBtn:SetText(L["Reset"])
    resetPlayerBtn:SetSize(90, 24)
    resetPlayerBtn:SetPoint("CENTER", resetPlayerRow, "CENTER", 0, 0)
    resetPlayerBtn:SetScript("OnClick", function()
        playerScale:SetMinMaxValues(0.1, 1.9)
        playerIconX:SetMinMaxValues(-200, 200)
        playerIconY:SetMinMaxValues(-200, 200)
        playerIconScale:SetMinMaxValues(0.4, 2)
        playerWidth:SetMinMaxValues(60, 230)
        playerHeight:SetMinMaxValues(5, 30)
        playerIconX:SetValue(0)
        playerIconY:SetValue(0)
        playerScale:SetValue(1)
        playerIconScale:SetValue(1)
        playerWidth:SetValue(208)
        playerHeight:SetValue(11)
        BetterBlizzFramesDB.playerCastBarShowIcon = false
        BetterBlizzFramesDB.playerCastBarTimer = false
        BetterBlizzFramesDB.playerStaticCastbar = false
        BetterBlizzFramesDB.playerCastBarTimerCentered = false
        BBF.CastBarTimerCaller()
        BBF.ShowPlayerCastBarIcon()
        BBF.ChangeCastbarSizes()
    end)
    cardPlayer.currentY = cardPlayer.currentY - 42
    cardPlayer:SetHeight(-cardPlayer.currentY + 6)

    FinalizeCardLayout(cfPlayer, cardPlayer)

    -------------------------------------------------------
    -- TAB 2: TARGET CASTBAR
    -------------------------------------------------------
    local cfTarget = categoryFrames["target"].contentFrame
    local cardTarget = CreateOptionCard(cfTarget, L["Target_Castbar"], nil, -10)

    AddCardCastbarPreview(cardTarget, "ui-castingbar-tier1-empower-2x", 150, 16)

    local targetScale = AddCardSlider(cardTarget, "targetCastBarScale", L["Size"], "", 0.1, 1.9, 0.01)
    local targetX = AddCardSlider(cardTarget, "targetCastBarXPos", L["X_Offset"], "", -130, 130, 1)
    local targetY = AddCardSlider(cardTarget, "targetCastBarYPos", L["Y_Offset"], "", -130, 130, 1)
    local targetWidth = AddCardSlider(cardTarget, "targetCastBarWidth", L["Width"], "", 60, 220, 1)
    local targetHeight = AddCardSlider(cardTarget, "targetCastBarHeight", L["Height"], "", 5, 30, 1)
    local targetIconScale = AddCardSlider(cardTarget, "targetCastBarIconScale", L["Icon_Size"], "", 0.4, 2, 0.01)
    local targetIconX = AddCardSlider(cardTarget, "targetCastbarIconXPos", L["Icon_x_offset"], "", -160, 160, 1)
    local targetIconY = AddCardSlider(cardTarget, "targetCastbarIconYPos", L["Icon_y_offset"], "", -160, 160, 1)

    local targetStatic = AddCardCheckbox(cardTarget, "targetStaticCastbar", L["Static"], L["Tooltip_Castbar_Static"])
    local targetTimer = AddCardCheckbox(cardTarget, "targetCastBarTimer", L["Timer"], L["Tooltip_Castbar_Timer"], BBF.CastBarTimerCaller)

    local targetToTCb = AddCardCheckbox(cardTarget, "targetToTCastbarAdjustment", L["ToT_Offset"], L["Tooltip_Castbar_ToT_Offset_Desc"])
    local targetToTSliderY = AddCardChildSlider(cardTarget, targetToTCb, "targetToTAdjustmentOffsetY", L["extra"], L["Tooltip_Castbar_ToT_Extra_Desc"], -20, 50, 1)

    local targetDetach = AddCardCheckbox(cardTarget, "targetDetachCastbar", L["Castbar_Detach"], L["Tooltip_Detach_From_Frame"], function(self)
        if self:GetChecked() then
            targetX:SetMinMaxValues(-900, 900)
            targetX:SetValue(0)
            targetY:SetMinMaxValues(-900, 900)
            targetY:SetValue(0)
            DisableElement(targetToTCb)
            targetStatic:SetChecked(false)
            BetterBlizzFramesDB.targetStaticCastbar = false
        else
            targetX:SetMinMaxValues(-130, 130)
            targetX:SetValue(0)
            EnableElement(targetToTCb)
        end
        BBF.ChangeCastbarSizes()
    end)

    if BetterBlizzFramesDB.targetDetachCastbar then
        targetX:SetMinMaxValues(-900, 900)
        targetY:SetMinMaxValues(-900, 900)
        DisableElement(targetToTCb)
        targetStatic:SetChecked(false)
        BetterBlizzFramesDB.targetStaticCastbar = false
    end

    targetStatic:HookScript("OnClick", function(self)
        if self:GetChecked() then
            DisableElement(targetToTCb)
            targetDetach:SetChecked(false)
            BetterBlizzFramesDB.targetDetachCastbar = false
        else
            EnableElement(targetToTCb)
        end
    end)
    if BetterBlizzFramesDB.targetStaticCastbar then
        DisableElement(targetToTCb)
        targetDetach:SetChecked(false)
        BetterBlizzFramesDB.targetDetachCastbar = false
    end

    AddCardCheckbox(cardTarget, "hideTargetCastbar", L["Hide_Bar"], L["Hide_Target_Castbar"], BBF.ChangeCastbarSizes)
    AddCardCheckbox(cardTarget, "hideTargetCastbarIcon", L["Hide_Icon"], L["Hide_Target_Castbar_Icon"], BBF.ChangeCastbarSizes)

    -- Reset button
    local resetTargetRow = CreateFrame("Frame", nil, cardTarget)
    resetTargetRow:SetPoint("TOPLEFT", cardTarget, "TOPLEFT", 6, cardTarget.currentY)
    resetTargetRow:SetSize(cardTarget.cardWidth - 12, 34)
    local resetTargetBtn = CreateFrame("Button", nil, resetTargetRow, "UIPanelButtonTemplate")
    resetTargetBtn:SetText(L["Reset"])
    resetTargetBtn:SetSize(90, 24)
    resetTargetBtn:SetPoint("CENTER", resetTargetRow, "CENTER", 0, 0)
    resetTargetBtn:SetScript("OnClick", function()
        targetScale:SetMinMaxValues(0.1, 1.9)
        targetX:SetMinMaxValues(-130, 130)
        targetY:SetMinMaxValues(-130, 130)
        targetWidth:SetMinMaxValues(60, 220)
        targetHeight:SetMinMaxValues(5, 30)
        targetIconScale:SetMinMaxValues(0.4, 2)
        targetIconX:SetMinMaxValues(-160, 160)
        targetIconY:SetMinMaxValues(-160, 160)
        targetToTSliderY:SetMinMaxValues(-20, 50)
        targetScale:SetValue(1)
        targetIconScale:SetValue(1)
        targetX:SetValue(0)
        targetY:SetValue(0)
        targetIconX:SetValue(0)
        targetIconY:SetValue(0)
        targetWidth:SetValue(150)
        targetHeight:SetValue(10)
        BetterBlizzFramesDB.targetCastBarTimer = false
        BetterBlizzFramesDB.targetStaticCastbar = false
        BetterBlizzFramesDB.targetDetachCastbar = false
        EnableElement(targetToTCb)
        targetToTCb:SetChecked(true)
        targetToTSliderY:SetValue(0)
        BetterBlizzFramesDB.targetToTCastbarAdjustment = true
        BBF.CastBarTimerCaller()
        BBF.ChangeCastbarSizes()
    end)
    cardTarget.currentY = cardTarget.currentY - 42
    cardTarget:SetHeight(-cardTarget.currentY + 6)

    FinalizeCardLayout(cfTarget, cardTarget)

    -------------------------------------------------------
    -- TAB 3: FOCUS CASTBAR
    -------------------------------------------------------
    local cfFocus = categoryFrames["focus"].contentFrame
    local cardFocus = CreateOptionCard(cfFocus, L["Focus_Castbar"], nil, -10)

    AddCardCastbarPreview(cardFocus, "ui-castingbar-full-applyingcrafting", 150, 16)

    local focusScale = AddCardSlider(cardFocus, "focusCastBarScale", L["Size"], "", 0.1, 1.9, 0.01)
    local focusX = AddCardSlider(cardFocus, "focusCastBarXPos", L["X_Offset"], "", -130, 130, 1)
    local focusY = AddCardSlider(cardFocus, "focusCastBarYPos", L["Y_Offset"], "", -130, 130, 1)
    local focusWidth = AddCardSlider(cardFocus, "focusCastBarWidth", L["Width"], "", 60, 220, 1)
    local focusHeight = AddCardSlider(cardFocus, "focusCastBarHeight", L["Height"], "", 5, 30, 1)
    local focusIconScale = AddCardSlider(cardFocus, "focusCastBarIconScale", L["Icon_Size"], "", 0.4, 2, 0.01)
    local focusIconX = AddCardSlider(cardFocus, "focusCastbarIconXPos", L["Icon_x_offset"], "", -160, 160, 1)
    local focusIconY = AddCardSlider(cardFocus, "focusCastbarIconYPos", L["Icon_y_offset"], "", -160, 160, 1)

    local focusStatic = AddCardCheckbox(cardFocus, "focusStaticCastbar", L["Static"], L["Tooltip_Castbar_Static"])
    local focusTimer = AddCardCheckbox(cardFocus, "focusCastBarTimer", L["Timer"], L["Tooltip_Castbar_Timer"], BBF.CastBarTimerCaller)

    local focusToTCb = AddCardCheckbox(cardFocus, "focusToTCastbarAdjustment", L["ToT_Offset"], L["Tooltip_Castbar_ToT_Offset_Desc"])
    local focusToTSliderY = AddCardChildSlider(cardFocus, focusToTCb, "focusToTAdjustmentOffsetY", L["extra"], L["Tooltip_Castbar_ToT_Extra_Desc"], -20, 50, 1)

    local focusDetach = AddCardCheckbox(cardFocus, "focusDetachCastbar", L["Castbar_Detach"], L["Tooltip_Detach_From_Frame"], function(self)
        if self:GetChecked() then
            focusX:SetMinMaxValues(-900, 900)
            focusX:SetValue(0)
            focusY:SetMinMaxValues(-900, 900)
            focusY:SetValue(0)
            DisableElement(focusToTCb)
            focusStatic:SetChecked(false)
            BetterBlizzFramesDB.focusStaticCastbar = false
        else
            focusX:SetMinMaxValues(-130, 130)
            focusX:SetValue(0)
            EnableElement(focusToTCb)
        end
        BBF.ChangeCastbarSizes()
    end)

    if BetterBlizzFramesDB.focusDetachCastbar then
        focusX:SetMinMaxValues(-900, 900)
        focusY:SetMinMaxValues(-900, 900)
        DisableElement(focusToTCb)
        focusStatic:SetChecked(false)
        BetterBlizzFramesDB.focusStaticCastbar = false
    end

    focusStatic:HookScript("OnClick", function(self)
        if self:GetChecked() then
            DisableElement(focusToTCb)
            focusDetach:SetChecked(false)
            BetterBlizzFramesDB.focusDetachCastbar = false
        else
            EnableElement(focusToTCb)
        end
    end)
    if BetterBlizzFramesDB.focusStaticCastbar then
        DisableElement(focusToTCb)
        focusDetach:SetChecked(false)
        BetterBlizzFramesDB.focusDetachCastbar = false
    end

    AddCardCheckbox(cardFocus, "hideFocusCastbar", L["Hide_Bar"], L["Tooltip_Hide_Focus_Castbar"], BBF.ChangeCastbarSizes)
    AddCardCheckbox(cardFocus, "hideFocusCastbarIcon", L["Hide_Icon"], L["Tooltip_Hide_Focus_Castbar_Icon"], BBF.ChangeCastbarSizes)

    -- Reset button
    local resetFocusRow = CreateFrame("Frame", nil, cardFocus)
    resetFocusRow:SetPoint("TOPLEFT", cardFocus, "TOPLEFT", 6, cardFocus.currentY)
    resetFocusRow:SetSize(cardFocus.cardWidth - 12, 34)
    local resetFocusBtn = CreateFrame("Button", nil, resetFocusRow, "UIPanelButtonTemplate")
    resetFocusBtn:SetText(L["Reset"])
    resetFocusBtn:SetSize(90, 24)
    resetFocusBtn:SetPoint("CENTER", resetFocusRow, "CENTER", 0, 0)
    resetFocusBtn:SetScript("OnClick", function()
        focusScale:SetMinMaxValues(0.1, 1.9)
        focusX:SetMinMaxValues(-130, 130)
        focusY:SetMinMaxValues(-130, 130)
        focusWidth:SetMinMaxValues(60, 220)
        focusHeight:SetMinMaxValues(5, 30)
        focusIconScale:SetMinMaxValues(0.4, 2)
        focusIconX:SetMinMaxValues(-160, 160)
        focusIconY:SetMinMaxValues(-160, 160)
        focusToTSliderY:SetMinMaxValues(-20, 50)
        focusScale:SetValue(1)
        focusIconScale:SetValue(1)
        focusX:SetValue(0)
        focusY:SetValue(0)
        focusIconX:SetValue(0)
        focusIconY:SetValue(0)
        focusWidth:SetValue(150)
        focusHeight:SetValue(10)
        BetterBlizzFramesDB.focusCastBarTimer = false
        BetterBlizzFramesDB.focusStaticCastbar = false
        BetterBlizzFramesDB.focusDetachCastbar = false
        EnableElement(focusToTCb)
        focusToTCb:SetChecked(true)
        focusToTSliderY:SetValue(0)
        BetterBlizzFramesDB.focusToTCastbarAdjustment = true
        BBF.CastBarTimerCaller()
        BBF.ChangeCastbarSizes()
    end)
    cardFocus.currentY = cardFocus.currentY - 42
    cardFocus:SetHeight(-cardFocus.currentY + 6)

    FinalizeCardLayout(cfFocus, cardFocus)

    -------------------------------------------------------
    -- TAB 4: PARTY CASTBARS
    -------------------------------------------------------
    local cfParty = categoryFrames["party"].contentFrame
    local cardParty = CreateOptionCard(cfParty, L["Party_Castbars"], nil, -10)

    AddCardCastbarPreview(cardParty, "ui-castingbar-filling-channel", 150, 16)

    local partyScale = AddCardSlider(cardParty, "partyCastBarScale", L["Size"], "", 0.5, 1.9, 0.01)
    local partyX = AddCardSlider(cardParty, "partyCastBarXPos", L["X_Offset"], "", -200, 200, 1)
    local partyY = AddCardSlider(cardParty, "partyCastBarYPos", L["Y_Offset"], "", -200, 200, 1)
    local partyWidth = AddCardSlider(cardParty, "partyCastBarWidth", L["Width"], "", 20, 200, 1)
    local partyHeight = AddCardSlider(cardParty, "partyCastBarHeight", L["Height"], "", 5, 30, 1)
    local partyIconScale = AddCardSlider(cardParty, "partyCastBarIconScale", L["Icon_Size"], "", 0.4, 2, 0.01)
    local partyIconX = AddCardSlider(cardParty, "partyCastbarIconXPos", L["Icon_x_offset"], "", -50, 50, 1)
    local partyIconY = AddCardSlider(cardParty, "partyCastbarIconYPos", L["Icon_y_offset"], "", -50, 50, 1)

    AddCardCheckbox(cardParty, "partyCastBarTestMode", L["Test"], L["Tooltip_Castbar_Test"], BBF.partyCastBarTestMode)
    AddCardCheckbox(cardParty, "partyCastBarTimer", L["Timer"], L["Tooltip_Castbar_Timer"], BBF.partyCastBarTestMode)
    AddCardCheckbox(cardParty, "partyCastbarSelf", L["Self"], L["Tooltip_Show_Party_Castbar"], BBF.partyCastBarTestMode)
    AddCardCheckbox(cardParty, "showPartyCastBarIcon", L["Icon"], "", BBF.partyCastBarTestMode)

    AddCardCheckbox(cardParty, "classicCastbarsParty", L["Castbar_Classic"], L["Tooltip_Castbar_Classic_Party_Desc"], function(self)
        if not self:GetChecked() then StaticPopup_Show("BBF_CONFIRM_RELOAD") end
        BBF.partyCastBarTestMode()
    end)
    AddCardCheckbox(cardParty, "partyCastBarForceDefaultPartyFrames", L["Party_Castbar_Force_Default_Frames"], L["Tooltip_Party_Castbar_Force_Default_Frames_Desc"])

    -- Reset button
    local resetPartyRow = CreateFrame("Frame", nil, cardParty)
    resetPartyRow:SetPoint("TOPLEFT", cardParty, "TOPLEFT", 6, cardParty.currentY)
    resetPartyRow:SetSize(cardParty.cardWidth - 12, 34)
    local resetPartyBtn = CreateFrame("Button", nil, resetPartyRow, "UIPanelButtonTemplate")
    resetPartyBtn:SetText(L["Reset"])
    resetPartyBtn:SetSize(90, 24)
    resetPartyBtn:SetPoint("CENTER", resetPartyRow, "CENTER", 0, 0)
    resetPartyBtn:SetScript("OnClick", function()
        partyScale:SetMinMaxValues(0.5, 1.9)
        partyX:SetMinMaxValues(-200, 200)
        partyY:SetMinMaxValues(-200, 200)
        partyWidth:SetMinMaxValues(20, 200)
        partyHeight:SetMinMaxValues(5, 30)
        partyIconScale:SetMinMaxValues(0.4, 2)
        partyIconX:SetMinMaxValues(-50, 50)
        partyIconY:SetMinMaxValues(-50, 50)
        partyScale:SetValue(1)
        partyIconScale:SetValue(1)
        partyX:SetValue(0)
        partyY:SetValue(0)
        partyIconX:SetValue(0)
        partyIconY:SetValue(0)
        partyWidth:SetValue(100)
        partyHeight:SetValue(12)
        BetterBlizzFramesDB.partyCastBarTimer = true
        BBF.CastBarTimerCaller()
    end)
    cardParty.currentY = cardParty.currentY - 42
    cardParty:SetHeight(-cardParty.currentY + 6)

    FinalizeCardLayout(cfParty, cardParty)

    -------------------------------------------------------
    -- TAB 5: PET CASTBAR
    -------------------------------------------------------
    local cfPet = categoryFrames["pet"].contentFrame
    local cardPet = CreateOptionCard(cfPet, L["Pet_Castbar"], nil, -10)

    AddCardCastbarPreview(cardPet, "ui-castingbar-filling-channel", 150, 16, true)

    local petScale = AddCardSlider(cardPet, "petCastBarScale", L["Size"], "", 0.5, 1.9, 0.01)
    local petX = AddCardSlider(cardPet, "petCastBarXPos", L["X_Offset"], "", -200, 200, 1)
    local petY = AddCardSlider(cardPet, "petCastBarYPos", L["Y_Offset"], "", -200, 200, 1)
    local petWidth = AddCardSlider(cardPet, "petCastBarWidth", L["Width"], "", 20, 200, 1)
    local petHeight = AddCardSlider(cardPet, "petCastBarHeight", L["Height"], "", 5, 30, 1)
    local petIconScale = AddCardSlider(cardPet, "petCastBarIconScale", L["Icon_Size"], "", 0.4, 2, 0.01)

    AddCardCheckbox(cardPet, "petCastBarTestMode", L["Test"], L["Tooltip_Need_Pet"], BBF.petCastBarTestMode)
    AddCardCheckbox(cardPet, "petCastBarTimer", L["Timer"], L["Tooltip_Castbar_Timer"], BBF.petCastBarTestMode)
    AddCardCheckbox(cardPet, "showPetCastBarIcon", L["Icon"], "", BBF.petCastBarTestMode)

    local petDetach = AddCardCheckbox(cardPet, "petDetachCastbar", L["Castbar_Detach"], L["Tooltip_Detach_From_Frame"], function(self)
        if self:GetChecked() then
            petX:SetMinMaxValues(-900, 900)
            petX:SetValue(0)
            petY:SetMinMaxValues(-900, 900)
            petY:SetValue(0)
        else
            petX:SetMinMaxValues(-130, 130)
            petX:SetValue(0)
        end
        BBF.petCastBarTestMode()
        BBF.ChangeCastbarSizes()
    end)

    if BetterBlizzFramesDB.petDetachCastbar then
        petX:SetMinMaxValues(-900, 900)
        petX:SetValue(0)
        petY:SetMinMaxValues(-900, 900)
        petY:SetValue(0)
    end

    -- Reset button
    local resetPetRow = CreateFrame("Frame", nil, cardPet)
    resetPetRow:SetPoint("TOPLEFT", cardPet, "TOPLEFT", 6, cardPet.currentY)
    resetPetRow:SetSize(cardPet.cardWidth - 12, 34)
    local resetPetBtn = CreateFrame("Button", nil, resetPetRow, "UIPanelButtonTemplate")
    resetPetBtn:SetText(L["Reset"])
    resetPetBtn:SetSize(90, 24)
    resetPetBtn:SetPoint("CENTER", resetPetRow, "CENTER", 0, 0)
    resetPetBtn:SetScript("OnClick", function()
        petScale:SetMinMaxValues(0.5, 1.9)
        petX:SetMinMaxValues(-200, 200)
        petY:SetMinMaxValues(-200, 200)
        petWidth:SetMinMaxValues(20, 200)
        petHeight:SetMinMaxValues(5, 30)
        petIconScale:SetMinMaxValues(0.4, 2)
        petScale:SetValue(1)
        petIconScale:SetValue(1)
        petX:SetValue(0)
        petY:SetValue(0)
        petWidth:SetValue(100)
        petHeight:SetValue(12)
        petDetach:SetChecked(false)
        BetterBlizzFramesDB.petDetachCastbar = false
        BetterBlizzFramesDB.petCastBarTimer = true
        BBF.CastBarTimerCaller()
        BBF.ChangeCastbarSizes()
    end)
    cardPet.currentY = cardPet.currentY - 42
    cardPet:SetHeight(-cardPet.currentY + 6)

    FinalizeCardLayout(cfPet, cardPet)

    -------------------------------------------------------
    -- TAB 6: GENERAL & RECOLOR
    -------------------------------------------------------
    local cfGeneral = categoryFrames["general"].contentFrame
    local cardRecolor = CreateOptionCard(cfGeneral, L["Recolor_And_Styling"], nil, -10)

    local cbRecolor = AddCardCheckbox(cardRecolor, "recolorCastbars", L["Recolor_Castbars"], L["Tooltip_Recolor_Castbars_Desc"])

    -- Color boxes row inside card
    local colorRow = CreateFrame("Frame", nil, cardRecolor)
    colorRow:SetPoint("TOPLEFT", cardRecolor, "TOPLEFT", 6, cardRecolor.currentY)
    colorRow:SetSize(cardRecolor.cardWidth - 12, 36)

    local colorRowHighlight = colorRow:CreateTexture(nil, "BACKGROUND")
    colorRowHighlight:SetAllPoints()
    colorRowHighlight:SetAtlas("options-item-highlight")
    if not colorRowHighlight:GetTexture() then
        colorRowHighlight:SetColorTexture(1, 1, 1, 0.12)
    end
    colorRowHighlight:SetBlendMode("ADD")
    colorRowHighlight:Hide()

    colorRow:EnableMouse(true)
    colorRow:SetScript("OnEnter", function() colorRowHighlight:Show() end)
    colorRow:SetScript("OnLeave", function() colorRowHighlight:Hide() end)

    local boxCast = CreateColorBox(colorRow, "castbarCastColor", L["Cast"], function() BBF.CastbarColorHooks() end)
    boxCast:SetPoint("LEFT", colorRow, "LEFT", 16, 0)

    local boxChannel = CreateColorBox(colorRow, "castbarChannelColor", L["Channel"], function() BBF.CastbarColorHooks() end)
    boxChannel:SetPoint("LEFT", boxCast.text, "RIGHT", 15, 0)

    local boxUninterruptable = CreateColorBox(colorRow, "castbarUninterruptableColor", L["Uninterruptable"], function() BBF.CastbarColorHooks() end)
    boxUninterruptable:SetPoint("LEFT", boxChannel.text, "RIGHT", 15, 0)

    cbRecolor:HookScript("OnClick", function(self)
        local enable = self:GetChecked() and 1 or 0.5
        boxCast:SetAlpha(enable)
        boxChannel:SetAlpha(enable)
        boxUninterruptable:SetAlpha(enable)
        BBF.CastbarRecolorWidgets()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    cardRecolor.currentY = cardRecolor.currentY - 44
    cardRecolor:SetHeight(-cardRecolor.currentY + 6)

    local cbRecolorInterrupt = AddCardCheckbox(cardRecolor, "castBarRecolorInterrupt", L["Interrupt_CD_Color"], L["Tooltip_Interrupt_CD_Color_Desc"], BBF.UpdateInterruptIconSettings)
    AddCardChildCheckbox(cardRecolor, cbRecolorInterrupt, "castBarRecolorInterruptArenaFrames", L["Arena"], L["Tooltip_Interrupt_CD_Color_Arena_Frames_Desc"], BBF.UpdateInterruptIconSettings)
    AddCardCheckbox(cardRecolor, "castBarInterruptIconEnabled", L["Interrupt_CD_Icon"], L["Tooltip_Interrupt_CD_Icon_Desc"], BBF.UpdateInterruptIconSettings)

    -- Interruption Color Buttons Row
    local intColorRow = CreateFrame("Frame", nil, cardRecolor)
    intColorRow:SetPoint("TOPLEFT", cardRecolor, "TOPLEFT", 6, cardRecolor.currentY)
    intColorRow:SetSize(cardRecolor.cardWidth - 12, 34)

    local function OpenColorPicker(colorType, icon)
        local originalColorData = BetterBlizzFramesDB[colorType] or {1, 1, 1, 1}
        if #originalColorData == 3 then table.insert(originalColorData, 1) end
        local r, g, b, a = unpack(originalColorData)

        local function updateColors()
            if icon and icon.SetVertexColor then icon:SetVertexColor(r, g, b, a) end
            if ColorPickerFrame and ColorPickerFrame.Content then
                ColorPickerFrame.Content.ColorSwatchCurrent:SetAlpha(a)
            end
        end

        local function swatchFunc()
            r, g, b = ColorPickerFrame:GetColorRGB()
            BetterBlizzFramesDB[colorType] = {r, g, b, a}
            updateColors()
        end

        local function opacityFunc()
            a = ColorPickerFrame:GetColorAlpha()
            BetterBlizzFramesDB[colorType] = {r, g, b, a}
            updateColors()
        end

        local function cancelFunc()
            r, g, b, a = unpack(originalColorData)
            BetterBlizzFramesDB[colorType] = {r, g, b, a}
            updateColors()
        end

        ColorPickerFrame:SetupColorPickerAndShow({
            r = r, g = g, b = b, opacity = a, hasOpacity = true,
            swatchFunc = swatchFunc, opacityFunc = opacityFunc, cancelFunc = cancelFunc
        })
    end

    local btnNoInt = CreateFrame("Button", nil, intColorRow, "UIPanelButtonTemplate")
    btnNoInt:SetText(L["Interrupt_On_CD"])
    btnNoInt:SetPoint("LEFT", intColorRow, "LEFT", 16, 0)
    btnNoInt:SetSize(130, 22)
    CreateTooltip(btnNoInt, L["Tooltip_Interrupt_On_CD"])
    local iconNoInt = intColorRow:CreateTexture(nil, "ARTWORK")
    iconNoInt:SetAtlas("newplayertutorial-icon-key")
    iconNoInt:SetSize(18, 17)
    iconNoInt:SetPoint("LEFT", btnNoInt, "RIGHT", 4, 0)
    local colNoInt = BetterBlizzFramesDB["castBarNoInterruptColor"] or {1, 1, 1}
    iconNoInt:SetVertexColor(colNoInt[1], colNoInt[2], colNoInt[3], colNoInt[4] or 1)
    btnNoInt:SetScript("OnClick", function() OpenColorPicker("castBarNoInterruptColor", iconNoInt) end)

    local btnDelayInt = CreateFrame("Button", nil, intColorRow, "UIPanelButtonTemplate")
    btnDelayInt:SetText(L["Interrupt_CD_Soon"])
    btnDelayInt:SetPoint("LEFT", iconNoInt, "RIGHT", 25, 0)
    btnDelayInt:SetSize(130, 22)
    CreateTooltip(btnDelayInt, L["Tooltip_Interrupt_CD_Soon"])
    local iconDelayInt = intColorRow:CreateTexture(nil, "ARTWORK")
    iconDelayInt:SetAtlas("newplayertutorial-icon-key")
    iconDelayInt:SetSize(18, 17)
    iconDelayInt:SetPoint("LEFT", btnDelayInt, "RIGHT", 4, 0)
    local colDelayInt = BetterBlizzFramesDB["castBarDelayedInterruptColor"] or {1, 1, 1}
    iconDelayInt:SetVertexColor(colDelayInt[1], colDelayInt[2], colDelayInt[3], colDelayInt[4] or 1)
    btnDelayInt:SetScript("OnClick", function() OpenColorPicker("castBarDelayedInterruptColor", iconDelayInt) end)

    cardRecolor.currentY = cardRecolor.currentY - 42
    cardRecolor:SetHeight(-cardRecolor.currentY + 6)

    -- Styling Card
    local cardOptions = CreateOptionCard(cfGeneral, L["General_Settings"], cardRecolor, -22)
    AddCardCheckbox(cardOptions, "buffsOnTopReverseCastbarMovement", L["Buffs_On_Top_Reverse"], L["Tooltip_Buffs_On_Top_Reverse_Desc"], BBF.CastbarAdjustCaller)
    AddCardCheckbox(cardOptions, "normalCastbarForEmpoweredCasts", L["Normal_Evoker_Castbar"], L["Tooltip_Normal_Evoker_Castbar_Desc"], function(self)
        if BetterBlizzPlatesDB then BetterBlizzPlatesDB.normalCastbarForEmpoweredCasts = self:GetChecked() end
        BBF.HookCastbarsForEvoker()
    end)
    AddCardCheckbox(cardOptions, "quickHideCastbars", L["Quick_Hide_Castbars"], L["Tooltip_Quick_Hide_Castbars_Desc"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    AddCardCheckbox(cardOptions, "castBarTargetText", L["Castbar_Target_Text"], L["Tooltip_Castbar_Target_Text_Desc"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    AddCardCheckbox(cardOptions, "castBarTargetHighlight", L["Castbar_Target_Highlight"], L["Tooltip_Castbar_Target_Highlight_Desc"], function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)

    local cbClassicAll = AddCardCheckbox(cardOptions, "classicCastbars", L["Castbar_Classic"], L["Tooltip_Castbar_Classic_Target_Focus_Desc"], function(self)
        if self:GetChecked() then BetterBlizzFramesDB.castbarPixelBorder = nil end
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    AddCardChildCheckbox(cardOptions, cbClassicAll, "classicCastbarsModernSpark", L["Modern_Spark"], L["Tooltip_Modern_Spark_Desc"], BBF.ChangeCastbarSizes)

    AddCardCheckbox(cardOptions, "unitframeCastBarNoTextBorder", L["UnitFrame_Simple_Castbars"], L["Tooltip_UnitFrame_Simple_Castbars_Desc"], BBF.ChangeCastbarSizes)
    local cbPixelBorder = AddCardCheckbox(cardOptions, "castbarPixelBorder", L["Pixel_Border_Castbars"], L["Tooltip_Pixel_Border_Castbars_Desc"], function(self)
        if self:GetChecked() then
            BetterBlizzFramesDB.classicCastbars = nil
            BetterBlizzFramesDB.classicCastbarsPlayer = nil
        end
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end)
    AddCardChildCheckbox(cardOptions, cbPixelBorder, "castbarPixelBorderTextInside", L["Pixel_Border_Castbars_Text_Inside"], L["Tooltip_Pixel_Border_Castbars_Text_Inside_Desc"], BBF.ChangeCastbarSizes)

    FinalizeCardLayout(cfGeneral, cardOptions)

    -- Right click tip string
    BetterBlizzFramesCastbars.rightClickTip = BetterBlizzFramesCastbars:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    BetterBlizzFramesCastbars.rightClickTip:SetPoint("BOTTOMLEFT", BetterBlizzFramesCastbars, "BOTTOMLEFT", 15, 10)
    BetterBlizzFramesCastbars.rightClickTip:SetText("|A:smallquestbang:20:20|a" .. L["Right_Click_Slider_Tip"])

    SelectCategory("player")
end
