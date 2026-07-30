if not BBF.isMidnight then return end
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

function guiGeneralTab()
    ----------------------
    -- Main panel:
    ----------------------
    local mainGuiAnchor = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor:SetPoint("TOPLEFT", 15, -15)
    mainGuiAnchor:SetText(" ")

    BetterBlizzFrames.searchName = L["Search_Name_General"]

    local profilesFrame = guiProfiles()

    local bgImg = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", BetterBlizzFrames, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local midnightBeta = BetterBlizzFrames:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    midnightBeta:SetPoint("BOTTOM", SettingsPanel, "TOP", 0, 0)
    midnightBeta:SetText(L["Msg_Midnight_Early_Beta"])
    midnightBeta:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
    midnightBeta:Hide()
    BetterBlizzFrames:HookScript("OnShow",function() midnightBeta:Show() end)
    BetterBlizzFrames:HookScript("OnHide",function() midnightBeta:Hide() end)

    local newSearch = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearch:SetAtlas("NewCharacter-Horde", true)
    newSearch:SetPoint("BOTTOM", BetterBlizzFrames, "TOP", -70, 2)
    CreateTooltipTwo(newSearch, L["Search"], L["Tooltip_Search_Desc"])

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

    -------------------------------------------------------
    -- SIDEBAR NAVIGATION & CARD CONTAINER DESIGN
    -------------------------------------------------------
    local sidebar = CreateFrame("Frame", nil, BetterBlizzFrames)
    sidebar:SetSize(165, 545)
    sidebar:SetPoint("TOPLEFT", BetterBlizzFrames, "TOPLEFT", 12, -45)

    local contentParent = CreateFrame("Frame", nil, BetterBlizzFrames)
    contentParent:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 10, 0)
    contentParent:SetPoint("BOTTOMRIGHT", BetterBlizzFrames, "BOTTOMRIGHT", -38, 15)

    local categoryList = {
        { id = "general",     label = L["General"],             atlas = "optionsicon-brown", size = {20, 20} },
        { id = "player",      label = L["Player_Frame"],        atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {0.1, 0.6, 1} },
        { id = "party",       label = L["Party_Frame"],         atlas = "groupfinder-icon-friend", size = {20, 20}, desaturated = true, color = {0.1, 0.6, 1},
          overlays = { { atlas = "groupfinder-icon-friend", size = {16, 16}, offset = {4, 3}, desaturated = true, color = {0, 1, 0} } } },
        { id = "all",         label = L["All_Frames"],          atlas = "groupfinder-icon-friend", size = {20, 20}, desaturated = true, color = {0.1, 0.6, 1},
          overlays = {
              { atlas = "groupfinder-icon-friend", size = {16, 16}, offset = {3, 3}, desaturated = true, color = {0, 1, 0} },
              { atlas = "groupfinder-icon-friend", size = {16, 16}, offset = {-5, 3}, desaturated = true, color = {1, 0, 0} }
          } },
        { id = "target",      label = L["Target_Frame"],        atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {1, 0, 0} },
        { id = "tot",         label = L["Target_of_Target"],   atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {1, 0, 0},
          overlays = { { atlas = "TargetCrosshairs", size = {22, 22}, offset = {8, -8} } } },
        { id = "chat",        label = L["Chat_Frame"],          atlas = "transmog-icon-chat", size = {18, 16} },
        { id = "extra",       label = L["Extra_Features"],      atlas = "Campaign-QuestLog-LoreBook", size = {20, 20} },
        { id = "arenaNames",  label = L["Arena_Names"],         atlas = "questlog-questtypeicon-pvp", size = {18, 20} },
        { id = "focus",       label = L["Focus_Frame"],         atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {0, 1, 0} },
        { id = "focusToT",    label = L["Focus_ToT"],           atlas = "groupfinder-icon-friend", size = {22, 22}, desaturated = true, color = {0, 1, 0},
          overlays = { { atlas = "TargetCrosshairs", size = {22, 22}, offset = {8, -8} } } },
        { id = "pet",         label = L["Pet_Frame"],           atlas = "newplayerchat-chaticon-newcomer", size = {19, 19} },
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
        local sf = CreateFrame("ScrollFrame", "BBF_MidnightCat_" .. cat.id, contentParent, "ScrollFrameTemplate")
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
            if MouseIsOver(row) then
                rowHighlight:Show()
            else
                rowHighlight:Hide()
            end
        end

        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("LEFT", row, "LEFT", 6, 0)
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
                if cb:IsEnabled() then
                    cb:Click("LeftButton")
                end
            elseif button == "RightButton" then
                if BBF.HandleRightClick then
                    BBF.HandleRightClick(dbKey, titleStr, titleFrame)
                end
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
            if MouseIsOver(row) then
                rowHighlight:Show()
            else
                rowHighlight:Hide()
            end
        end

        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title:SetPoint("LEFT", row, "LEFT", 6, 0)
        title:SetText(titleStr)
        title:SetWidth(314)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 314), rowHeight)

        local cb = CreateCheckbox(dbKey, "", parentCb or row, nil, callback)
        cb.associatedTitle = title
        cb.associatedRow = row
        cb:SetSize(28, 28)
        cb:SetPoint("RIGHT", row, "RIGHT", -5, 0)
        if cb.UpdateEnabledState then
            cb:UpdateEnabledState()
        end

        titleFrame:EnableMouse(true)
        titleFrame:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                if cb:IsEnabled() then
                    cb:Click("LeftButton")
                end
            elseif button == "RightButton" then
                if BBF.HandleRightClick then
                    BBF.HandleRightClick(dbKey, titleStr, titleFrame)
                end
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
            if MouseIsOver(row) then
                rowHighlight:Show()
            else
                rowHighlight:Hide()
            end
        end

        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("LEFT", row, "LEFT", 6, 0)
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

        titleFrame:HookScript("OnEnter", UpdateHighlight)
        titleFrame:HookScript("OnLeave", UpdateHighlight)
        slider:HookScript("OnEnter", UpdateHighlight)
        slider:HookScript("OnLeave", UpdateHighlight)

        card.currentY = card.currentY - rowHeight - 10
        card:SetHeight(-card.currentY + 6)
        return slider
    end

    local function AddCardDualChildCheckboxes(card, parentCb, dbKey1, titleStr1, descStr1, dbKey2, titleStr2, descStr2)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 22, card.currentY)

        local rowHeight = 30
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
            if MouseIsOver(row) then
                rowHighlight:Show()
            else
                rowHighlight:Hide()
            end
        end

        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        -- Item 1: SFX
        local title1 = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title1:SetPoint("LEFT", row, "LEFT", 6, 0)
        title1:SetText(titleStr1)

        local titleFrame1 = CreateFrame("Frame", nil, row)
        titleFrame1:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame1:SetSize(title1:GetStringWidth() + 6, rowHeight)

        local cb1 = CreateCheckbox(dbKey1, "", parentCb or row, nil)
        cb1.associatedTitle = title1
        cb1:SetSize(24, 24)
        cb1:SetPoint("LEFT", title1, "RIGHT", 6, 0)
        if cb1.UpdateEnabledState then
            cb1:UpdateEnabledState()
        end

        titleFrame1:EnableMouse(true)
        titleFrame1:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                if cb1:IsEnabled() then cb1:Click("LeftButton") end
            elseif button == "RightButton" then
                if BBF.HandleRightClick then BBF.HandleRightClick(dbKey1, titleStr1, titleFrame1) end
            end
        end)

        if descStr1 and descStr1 ~= "" then
            CreateTooltipTwo(titleFrame1, titleStr1, descStr1)
            CreateTooltipTwo(cb1, titleStr1, descStr1)
        end

        titleFrame1:HookScript("OnEnter", UpdateHighlight)
        titleFrame1:HookScript("OnLeave", UpdateHighlight)
        cb1:HookScript("OnEnter", UpdateHighlight)
        cb1:HookScript("OnLeave", UpdateHighlight)

        -- Item 2: Warning (!)
        local title2 = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title2:SetPoint("LEFT", cb1, "RIGHT", 35, 0)
        title2:SetText(titleStr2)

        local titleFrame2 = CreateFrame("Frame", nil, row)
        titleFrame2:SetPoint("LEFT", cb1, "RIGHT", 35, 0)
        titleFrame2:SetSize(title2:GetStringWidth() + 6, rowHeight)

        local cb2 = CreateCheckbox(dbKey2, "", parentCb or row, nil)
        cb2.associatedTitle = title2
        cb2:SetSize(24, 24)
        cb2:SetPoint("LEFT", title2, "RIGHT", 6, 0)
        if cb2.UpdateEnabledState then
            cb2:UpdateEnabledState()
        end

        titleFrame2:EnableMouse(true)
        titleFrame2:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                if cb2:IsEnabled() then cb2:Click("LeftButton") end
            elseif button == "RightButton" then
                if BBF.HandleRightClick then BBF.HandleRightClick(dbKey2, titleStr2, titleFrame2) end
            end
        end)

        if descStr2 and descStr2 ~= "" then
            CreateTooltipTwo(titleFrame2, titleStr2, descStr2)
            CreateTooltipTwo(cb2, titleStr2, descStr2)
        end

        titleFrame2:HookScript("OnEnter", UpdateHighlight)
        titleFrame2:HookScript("OnLeave", UpdateHighlight)
        cb2:HookScript("OnEnter", UpdateHighlight)
        cb2:HookScript("OnLeave", UpdateHighlight)

        card.currentY = card.currentY - rowHeight - 6
        card:SetHeight(-card.currentY + 6)
        return cb1, cb2
    end




    local function FinalizeCardLayout(cf, lastCard)
        local sf = cf:GetParent()
        local function UpdateHeight()
            if cf:GetTop() and lastCard and lastCard:GetBottom() then
                local contentHeight = (cf:GetTop() - lastCard:GetBottom()) + 20
                cf:SetHeight(math.max(contentHeight, 520))
            end
        end
        UpdateHeight()
        C_Timer.After(0.01, UpdateHeight)
        C_Timer.After(0.1, UpdateHeight)
        if sf then
            sf:HookScript("OnShow", UpdateHeight)
        end
    end

    -------------------------------------------------------
    -- CATEGORY 1: General
    -------------------------------------------------------
    local cfGen = categoryFrames["general"].contentFrame

    -- Card 1: General Settings
    local cardGen = CreateOptionCard(cfGen, L["General_Settings"], nil, -10)
    AddCardCheckbox(cardGen, "hideArenaFrames", L["Hide_Arena_Frames"], L["Tooltip_Hide_Arena_Frames"], BBF.HideArenaFrames)
    local cbBoss = AddCardCheckbox(cardGen, "hideBossFrames", L["Hide_Boss_Frames"], L["Tooltip_Hide_Boss_Frames"], BBF.HideArenaFrames)
    AddCardChildCheckbox(cardGen, cbBoss, "hideBossFramesParty", L["Party"], L["Tooltip_Hide_Boss_Frames_Party"])
    AddCardChildCheckbox(cardGen, cbBoss, "hideBossFramesRaid", L["Raid"], L["Tooltip_Hide_Boss_Frames_Raid"])
    AddCardCheckbox(cardGen, "playerFrameOCD", L["OCD_Tweaks"], L["Tooltip_OCD_Tweaks_Retail"], BBF.FixStupidBlizzPTRShit)
    AddCardCheckbox(cardGen, "removeRealmNames", L["Hide_Realm"], L["Tooltip_Hide_Realm_Desc"])

    -- Card 2: Crowd Control
    local cardCC = CreateOptionCard(cfGen, L["Crowd_Control"], cardGen, -22)
    AddCardCheckbox(cardCC, "hideLossOfControlFrameBg", L["Hide_CC_Background"], L["Tooltip_Hide_CC_Background"], BBF.HideFrames)
    AddCardCheckbox(cardCC, "hideLossOfControlFrameLines", L["Hide_CC_Red_Lines"], L["Tooltip_Hide_CC_Red_Lines"], BBF.HideFrames)
    AddCardSlider(cardCC, "lossOfControlScale", L["Loss_of_Control_Scale"], L["Tooltip_CC_Scale_Desc"], 0.4, 1.4, 0.01)

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
            if MouseIsOver(row) then
                rowHighlight:Show()
            else
                rowHighlight:Hide()
            end
        end

        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title:SetPoint("LEFT", row, "LEFT", 6, 0)
        title:SetText(titleStr)
        title:SetWidth(224)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 224), rowHeight)

        local slider = CreateSlider(parentCb or row, "", minVal, maxVal, stepVal, dbKey, nil, 120)
        slider.associatedTitle = title
        slider.associatedRow = row
        slider:SetPoint("RIGHT", row, "RIGHT", -20, 0)
        if slider.UpdateEnabledState then
            slider:UpdateEnabledState()
        end

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

        titleFrame:HookScript("OnEnter", UpdateHighlight)
        titleFrame:HookScript("OnLeave", UpdateHighlight)
        slider:HookScript("OnEnter", UpdateHighlight)
        slider:HookScript("OnLeave", UpdateHighlight)

        card.currentY = card.currentY - rowHeight - 10
        card:SetHeight(-card.currentY + 6)
        return slider
    end

    -- Card 3: Dark Mode Settings
    local cardDark = CreateOptionCard(cfGen, L["Dark_Mode_Settings"], cardCC, -22)
    local cbDark = AddCardCheckbox(cardDark, "darkModeUi", L["Dark_Mode"], L["Tooltip_Dark_Mode"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildSlider(cardDark, cbDark, "darkModeColor", L["Darkness"], L["Tooltip_Dark_Mode_Value"], 0, 1, 0.01)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeCastbars", L["Castbars"], L["Dark_Borders_Castbars"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeActionBars", L["ActionBars"], L["Dark_Borders_ActionBars"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeUiAura", L["Auras"], L["Dark_Borders_Aura_Icons"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeMinimap", L["Minimap"], L["Dark_Mode_Minimap"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeNameplateResource", L["Nameplate_Resource"], L["Dark_Mode_Nameplate_Resource"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeGameTooltip", L["Tooltip"], L["Tooltip_Dark_Mode_Tooltip_Desc"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeObjectiveFrame", L["Objectives"], L["Tooltip_Dark_Mode_Objectives_Desc"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeVigor", L["Vigor"], L["Tooltip_Dark_Mode_Vigor_Desc"], function() BBF.DarkmodeFrames(true) end)
    AddCardChildCheckbox(cardDark, cbDark, "darkModeEliteTexture", L["Elite_Texture"], L["Tooltip_Dark_Mode_Elite_Desc"], function() BBF.DarkmodeFrames(true) end)
    FinalizeCardLayout(cfGen, cardDark)

    -------------------------------------------------------
    -- CATEGORY 2: Player Frame
    -------------------------------------------------------
    local cfPlayer = categoryFrames["player"].contentFrame

    -- Card 1: Frame & Layout
    local cardPlayerLayout = CreateOptionCard(cfPlayer, L["Frame_Layout"], nil, -10)
    AddCardCheckbox(cardPlayerLayout, "playerFrameHidden", L["Hide_Frame"], L["Tooltip_Hide_Player_Frame"], function() BBF.HidePlayerFrame() end)
    AddCardCheckbox(cardPlayerLayout, "playerFrameClickthrough", L["Clickthrough"], L["Tooltip_Clickthrough"])
    AddCardCheckbox(cardPlayerLayout, "symmetricPlayerFrame", L["Mirror_TargetFrame"], L["Tooltip_Mirror_TargetFrame_Desc"])
    AddCardCheckbox(cardPlayerLayout, "hideTotemFrame", L["Hide_Totem_Frame"], L["Tooltip_Hide_Totem_Frame"], BBF.HideFrames)
    AddCardCheckbox(cardPlayerLayout, "playerReputationClassColor", L["Class_Color_Combo"], L["Tooltip_Class_Color_Reputation"], BBF.PlayerReputationColor)
    AddCardCheckbox(cardPlayerLayout, "playerReputationColor", L["Add_Reputation_Color"], L["Tooltip_Add_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a", BBF.PlayerReputationColor)
    AddCardCheckbox(cardPlayerLayout, "playerEliteFrame", L["Show_Elite_Texture"], L["Tooltip_Show_Elite_Texture_Desc"], function() if BBF.PlayerEliteFrame then BBF.PlayerEliteFrame() end end)

    -- Card 2: Display & Resources
    local cardPlayerDispRes = CreateOptionCard(cfPlayer, L["Display_Resources"], cardPlayerLayout, -22)
    AddCardCheckbox(cardPlayerDispRes, "hidePlayerName", L["Hide_Names"], "", function() BBF.SetCenteredNamesCaller() end)
    AddCardCheckbox(cardPlayerDispRes, "hidePlayerPower", L["Hide_Resource_Power"], L["Tooltip_Hide_Resource_Power_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPlayerDispRes, "hideResourceTooltip", L["Hide_Resource_Tooltip"], L["Tooltip_Hide_Resource_Tooltip_Desc"], BBF.HideClassResourceTooltip)
    AddCardCheckbox(cardPlayerDispRes, "hideManaFeedback", L["Hide_Mana_Feedback"], L["Tooltip_Hide_Mana_Feedback_Desc"], BBF.HideFrames)

    -- Card 3: Visual Effects & Glows
    local cardPlayerFX = CreateOptionCard(cfPlayer, L["Visual_Effects_Glows"], cardPlayerDispRes, -22)
    AddCardCheckbox(cardPlayerFX, "hidePlayerHealthLossAnim", L["Hide_Health_Loss_FX"], L["Tooltip_Hide_Health_Loss_FX_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPlayerFX, "hideFullPower", L["Tooltip_Hide_Full_Mana_FX"], L["Tooltip_Hide_Full_Mana_FX_Desc"] .. " |A:FullAlert-FrameGlow:16:30|a", BBF.HideFrames)
    AddCardCheckbox(cardPlayerFX, "hidePlayerRestGlow", L["Hide_Rest_Glow"], L["Tooltip_Hide_Rest_Glow"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-Status:16:42|a", BBF.HideFrames)
    AddCardCheckbox(cardPlayerFX, "hidePlayerRestAnimation", L["Hide_Zzz_Rest_Animation"], L["Tooltip_Hide_Zzz_Rest"], BBF.HideFrames)

    -- Card 4: Icons & Indicators
    local cardPlayerIcons = CreateOptionCard(cfPlayer, L["Icons_Indicators"], cardPlayerFX, -22)
    AddCardCheckbox(cardPlayerIcons, "hideCombatIcon", L["Hide_Combat_Icon"], L["Tooltip_Hide_Combat_Icon"] .. " |A:UI-HUD-UnitFrame-Player-CombatIcon:16:16|a", BBF.HideFrames)
    AddCardCheckbox(cardPlayerIcons, "hidePlayerRoleIcon", L["Hide_Role_Icon"], L["Tooltip_Hide_Role_Icon"] .. " |A:roleicon-tiny-dps:16:16|a", BBF.HideFrames)
    AddCardCheckbox(cardPlayerIcons, "hideGroupIndicator", L["Hide_Group_Indicator"], L["Tooltip_Hide_Group_Indicator"], BBF.HideFrames)
    AddCardCheckbox(cardPlayerIcons, "hidePlayerLeaderIcon", L["Hide_Leader_Icon"], L["Tooltip_Hide_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:16:16|a", BBF.HideFrames)
    AddCardCheckbox(cardPlayerIcons, "hidePlayerGuideIcon", L["Hide_Guide_Icon"], L["Tooltip_Hide_Guide_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-GuideIcon:16:16|a", BBF.HideFrames)
    AddCardCheckbox(cardPlayerIcons, "hidePlayerCornerIcon", L["Hide_Corner_Icon"], L["Tooltip_Hide_Corner_Icon"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment:16:16|a", BBF.HideFrames)
    AddCardCheckbox(cardPlayerIcons, "hideHitIndicator", L["Hide_Hit_Indicator"], L["Tooltip_Hide_Hit_Indicator_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPlayerIcons, "hidePvpTimerText", L["Hide_PvP_Timer"], L["Tooltip_Hide_PvP_Timer_Desc"], BBF.HideFrames)
    FinalizeCardLayout(cfPlayer, cardPlayerIcons)





    -------------------------------------------------------
    -- CATEGORY 3: Party Frame
    -------------------------------------------------------
    local cfParty = categoryFrames["party"].contentFrame

    -- Card 1: Frame & Layout
    local cardPartyLayout = CreateOptionCard(cfParty, L["Frame_Layout"], nil, -10)
    AddCardSlider(cardPartyLayout, "partyFrameScale", L["Party_Frame_Scale"], "", 0.7, 1.7, 0.01)
    AddCardSlider(cardPartyLayout, "partyFrameRangeAlpha", L["Change_Party_Frame_Alpha"], L["Tooltip_Party_Frame_Range_Alpha"], 0, 1, 0.01)
    AddCardCheckbox(cardPartyLayout, "hidePartyFramesInArena", L["Hide_Party_in_Arena"], L["Tooltip_Hide_Party_in_Arena_GEX"], BBF.HidePartyInArena)
    AddCardCheckbox(cardPartyLayout, "hideRaidFrameManager", L["Hide_RaidFrameManager"], L["Tooltip_Hide_RaidFrameManager"], BBF.HideFrames)
    AddCardCheckbox(cardPartyLayout, "raidFramePixelBorder", L["Pixel_Border"], L["Tooltip_Pixel_Border_RaidFrames_Desc"])
    AddCardCheckbox(cardPartyLayout, "hideCompactUnitFrameBackground", L["Hide_Bg"], L["Tooltip_Hide_Compact_Frame_Backgrounds"], BBF.HideCompactUnitFrameBackgrounds)
    AddCardCheckbox(cardPartyLayout, "hideRaidFrameContainerBorder", L["Hide_Container_Border"], L["Tooltip_Hide_Container_Border_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPartyLayout, "hidePartyFrameTitle", L["Hide_CompactPartyFrame_Title"], L["Tooltip_Hide_CompactPartyFrame_Title"], BBF.HideFrames)

    -- Card 2: Display & Text
    local cardPartyDisp = CreateOptionCard(cfParty, L["Display_Text"], cardPartyLayout, -22)
    AddCardCheckbox(cardPartyDisp, "hidePartyNames", L["Hide_Names"], "", function() BBF.AllNameChanges() end)
    AddCardCheckbox(cardPartyDisp, "classColorPartyNames", L["Color_Names"], L["Tooltip_Class_Color_Names_Party_Raid"], BBF.AllNameChanges)
    AddCardCheckbox(cardPartyDisp, "hidePartyRoles", L["Hide_Role_Icons"], L["Tooltip_Hide_Party_Role_Icons"], function() BBF.PartyNameChange() end)
    AddCardCheckbox(cardPartyDisp, "newRaidFrameRoleIcons", L["New_Role_Icons"], L["Tooltip_New_Role_Icons_Desc"])
    AddCardCheckbox(cardPartyDisp, "hidePartyRangeIcon", L["Hide_Range_Icon"], L["Tooltip_Hide_Range_Icon"], BBF.HideFrames)

    -- Card 3: Combat & Status
    local cardPartyCombat = CreateOptionCard(cfParty, L["Combat_Status"], cardPartyDisp, -22)
    AddCardCheckbox(cardPartyCombat, "showPartyCastbar", L["Party_Castbars"], L["Tooltip_Party_Castbars"], BBF.UpdateCastbars)
    AddCardCheckbox(cardPartyCombat, "betterTargetHighlight", L["Better_Target_Highlight"], L["Tooltip_Better_Target_Highlight"])
    AddCardCheckbox(cardPartyCombat, "hidePartyAggroHighlight", L["Hide_Aggro_Highlight"], L["Tooltip_Hide_Party_Aggro_Highlight"], BBF.HideFrames)
    AddCardCheckbox(cardPartyCombat, "hidePartyDispelOverlay", L["Hide_Dispel_Overlay"], L["Tooltip_Hide_Dispel_Overlay"], BBF.HideFrames)
    FinalizeCardLayout(cfParty, cardPartyCombat)


    -------------------------------------------------------
    -- CATEGORY 4: All Frames
    -------------------------------------------------------
    local cfAll = categoryFrames["all"].contentFrame

    -- Card 1: Frame & Layout
    local cardAllLayout = CreateOptionCard(cfAll, L["Frame_Layout"], nil, -10)
    AddCardCheckbox(cardAllLayout, "classicFrames", L["Classic_Frames"], L["Tooltip_Classic_Frames_Desc"])
    AddCardCheckbox(cardAllLayout, "noPortraitModes", L["No_Portrait"], L["Tooltip_No_Portrait_Desc"])
    AddCardCheckbox(cardAllLayout, "noPortraitPixelBorder", L["No_Portrait_PixelBorder"], L["Tooltip_NP_PixelBorder_Desc"])
    AddCardCheckbox(cardAllLayout, "classColorFrameTexture", L["Class_Color_FrameTexture"], L["Tooltip_Border_Status_Color_Desc"])
    AddCardCheckbox(cardAllLayout, "hideUnitFrameShadow", L["Hide_Shadow"], L["Tooltip_Hide_Shadow_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardAllLayout, "hideRareDragonTexture", L["Hide_Dragon"], L["Tooltip_Hide_Dragon"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Boss-Gold:22:16|a", BBF.HideFrames)
    AddCardCheckbox(cardAllLayout, "hideThreatOnFrame", L["Hide_Threat_Meter"], L["Tooltip_Hide_Threat_Desc"], BBF.HideFrames)

    -- Card 2: Display & Text
    local cardAllDisp = CreateOptionCard(cfAll, L["Display_Text"], cardAllLayout, -22)
    AddCardCheckbox(cardAllDisp, "classColorLevelText", L["Level"], L["Tooltip_Level"])
    AddCardCheckbox(cardAllDisp, "centerNames", L["Center_Names"], L["Tooltip_Center_Name_Desc"], BBF.SetCenteredNamesCaller)
    AddCardCheckbox(cardAllDisp, "classColorTargetNames", L["Class_Color_Names"], L["Tooltip_Class_Color_Names"])
    AddCardCheckbox(cardAllDisp, "removeRealmNames", L["Hide_Realm"], L["Tooltip_Hide_Realm_Desc"])
    local cbFormatNum = AddCardCheckbox(cardAllDisp, "formatStatusBarText", L["Format_Numbers"], L["Tooltip_Format_Numbers_Desc"] .. " |A:glueannouncementpopup-arrow:16:16|a", BBF.HookStatusBarText)
    AddCardChildCheckbox(cardAllDisp, cbFormatNum, "singleValueStatusBarText", L["No_Max_Value"], "|A:glueannouncementpopup-arrow:16:16|a " .. L["Tooltip_No_Max_Desc"])
    AddCardCheckbox(cardAllDisp, "hideLevelText", L["Hide_Max_Level_Text"], L["Tooltip_Hide_Max_Level_Text"], BBF.HideFrames)

    -- Card 3: Colors, Icons & FX
    local cardAllColors = CreateOptionCard(cfAll, L["Colors_Icons_FX"], cardAllDisp, -22)
    AddCardCheckbox(cardAllColors, "classColorFrames", L["Class_Color_Health"], L["Tooltip_Class_Color_Healthbars"])
    AddCardCheckbox(cardAllColors, "customHealthbarColors", L["Custom_Color_Health_Mana"], L["Tooltip_Custom_Colors_Desc"])
    AddCardCheckbox(cardAllColors, "hidePrestigeBadge", L["Hide_Prestige_Honor_Badge_PvP_Icon"], L["Tooltip_Hide_Prestige_PvP_Icon_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardAllColors, "hideCombatGlow", L["Hide_Combat_Glow"], L["Tooltip_Hide_Combat_Glow"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-InCombat:16:42|a", BBF.HideFrames)
    AddCardCheckbox(cardAllColors, "classPortraitsUseSpecIcons", L["Use_Spec_Icons"], L["Tooltip_Use_Spec_Icons"], BBF.SpecPortraits)
    FinalizeCardLayout(cfAll, cardAllColors)


    -------------------------------------------------------
    -- CATEGORY 5: Target Frame
    -------------------------------------------------------
    local cfTarget = categoryFrames["target"].contentFrame
    local cardTarget = CreateOptionCard(cfTarget, L["Target_Frame"], nil, -10)
    AddCardCheckbox(cardTarget, "targetFrameClickthrough", L["Clickthrough"], L["Tooltip_Target_Clickthrough"], BBF.ClickthroughFrames)
    AddCardCheckbox(cardTarget, "hideTargetName", L["Hide_Names"], L["Tooltip_Hide_Target_Name"], BBF.UpdateNameSettings)
    AddCardCheckbox(cardTarget, "hideTargetLeaderIcon", L["Hide_Leader_Icon"], L["Tooltip_Hide_Target_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:16:16|a", BBF.HideFrames)
    AddCardCheckbox(cardTarget, "classColorTargetReputationTexture", L["Reputation_Class_Color"], L["Tooltip_Target_Reputation_Class_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a")
    AddCardCheckbox(cardTarget, "hideTargetReputationColor", L["Hide_Reputation_Color"], L["Tooltip_Hide_Target_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a", BBF.HideFrames)
    FinalizeCardLayout(cfTarget, cardTarget)

    -------------------------------------------------------
    -- CATEGORY 6: Target of Target
    -------------------------------------------------------
    local cfToT = categoryFrames["tot"].contentFrame
    local cardToT = CreateOptionCard(cfToT, L["Target_of_Target"], nil, -10)
    AddCardCheckbox(cardToT, "hideTargetToT", L["Hide_Frame"], L["Tooltip_Hide_ToT_Frame"], BBF.HideFrames)
    AddCardCheckbox(cardToT, "hideTargetToTName", L["Hide_Names"], L["Tooltip_Hide_ToT_Name"])
    AddCardCheckbox(cardToT, "hideTargetToTDebuffs", L["Hide_ToT_Debuffs"], L["Tooltip_Hide_ToT_Debuffs"], BBF.HideFrames)
    AddCardSlider(cardToT, "targetToTScale", L["Size"], L["Tooltip_ToT_Size"], 0.6, 2.5, 0.01)
    AddCardSlider(cardToT, "targetToTXPos", L["X_Offset"], L["Tooltip_ToT_X_Offset"], -100, 100, 1)
    AddCardSlider(cardToT, "targetToTYPos", L["Y_Offset"], L["Tooltip_ToT_Y_Offset"], -100, 100, 1)
    FinalizeCardLayout(cfToT, cardToT)

    local function AddCardHeader(card, titleStr)
        local row = CreateFrame("Frame", nil, card)
        row:SetPoint("TOPLEFT", card, "TOPLEFT", 6, card.currentY)
        row:SetSize(card.cardWidth - 12, 22)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("LEFT", row, "LEFT", 4, 0)
        title:SetText(titleStr)

        card.currentY = card.currentY - 26
        card:SetHeight(-card.currentY + 6)
        return title
    end

    -------------------------------------------------------
    -- CATEGORY 7: Chat Frame
    -------------------------------------------------------
    local cfChat = categoryFrames["chat"].contentFrame
    local cardChat = CreateOptionCard(cfChat, L["Chat_Frame"], nil, -10)
    local cbChatBtns = AddCardCheckbox(cardChat, "hideChatButtons", L["Hide_Chat_Buttons"], L["Tooltip_Hide_Chat_Buttons"], BBF.HideFrames)
    AddCardChildCheckbox(cardChat, cbChatBtns, "hideChatBackground", L["Hide_Chat_Background"], L["Tooltip_Hide_Chat_Background"], BBF.HideFrames)
    AddCardHeader(cardChat, L["Filters"])
    AddCardCheckbox(cardChat, "filterGladiusSpam", L["Gladius_Spam"], L["Tooltip_Filter_Gladius_Spam"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterNpcArenaSpam", L["Arena_Npc_Talk"], L["Tooltip_Filter_Arena_Npc_Talk"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterTalentSpam", L["Talent_Spam"], L["Tooltip_Filter_Talent_Spam"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterEmoteSpam", L["Emote_Spam"], L["Tooltip_Filter_Emote_Spam"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterSystemMessages", L["System_Messages"], L["Tooltip_Filter_System_Messages"], BBF.ChatFilterCaller)
    AddCardCheckbox(cardChat, "filterMiscInfo", L["Misc_Info"], L["Tooltip_Filter_Misc_Info"], BBF.ChatFilterCaller)
    FinalizeCardLayout(cfChat, cardChat)


    -------------------------------------------------------
    -- CATEGORY 8: Extra Features
    -------------------------------------------------------
    local cfExtra = categoryFrames["extra"].contentFrame
    local cardExtra = CreateOptionCard(cfExtra, L["Extra_Features"], nil, -10)
    AddCardCheckbox(cardExtra, "combatIndicator", L["Combat_Indicator"], L["Tooltip_Combat_Indicator_Desc"], function() BBF.CombatIndicatorCaller() end, 1)
    AddCardCheckbox(cardExtra, "healerIndicator", L["Healer_Indicator"], L["Tooltip_Healer_Indicator_Desc"], function() BBF.HealerIndicatorCaller() end)
    AddCardCheckbox(cardExtra, "absorbIndicator", L["Absorb_Indicator"], L["Tooltip_Absorb_Indicator_Desc"], BBF.AbsorbCaller, 1)
    AddCardCheckbox(cardExtra, "racialIndicator", L["Racial_Indicator"], L["Tooltip_Racial_Indicator_Desc"], BBF.RacialIndicatorCaller, 1)
    AddCardCheckbox(cardExtra, "overShields", L["Overshields"], L["Tooltip_Overshields_Desc"], nil, 2)
    local cbQueue = AddCardCheckbox(cardExtra, "queueTimer", L["Queue_Timer"], L["Tooltip_Queue_Timer_Desc"])
    AddCardChildCheckbox(cardExtra, cbQueue, "queueTimerAudio", L["Sound_Effect"], L["Tooltip_Queue_Timer_SFX_Desc"])
    AddCardChildCheckbox(cardExtra, cbQueue, "queueTimerWarning", L["Sound_Alert"], L["Tooltip_Queue_Timer_Warning_Desc"])
    AddCardCheckbox(cardExtra, "enableBigDebuffs", L["Enable_Big_Debuffs"], L["Tooltip_Big_Debuffs_Desc"], BBF.EnableBigDebuffs)
    AddCardCheckbox(cardExtra, "kickPopupEnabled", L["Kick_Popup"], L["Tooltip_Kick_Popup_Desc"], function() BBF.ToggleKickPopup() end)
    FinalizeCardLayout(cfExtra, cardExtra)



    local function AddCardMultiParentChildCheckbox(card, parentCbs, dbKey, titleStr, descStr, callback)
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
            if MouseIsOver(row) then
                rowHighlight:Show()
            else
                rowHighlight:Hide()
            end
        end

        row:EnableMouse(true)
        row:SetScript("OnEnter", UpdateHighlight)
        row:SetScript("OnLeave", UpdateHighlight)

        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title:SetPoint("LEFT", row, "LEFT", 6, 0)
        title:SetText(titleStr)
        title:SetWidth(314)
        title:SetJustifyH("LEFT")

        local titleFrame = CreateFrame("Frame", nil, row)
        titleFrame:SetPoint("LEFT", row, "LEFT", 0, 0)
        titleFrame:SetSize(math.min(title:GetStringWidth() + 10, 314), rowHeight)

        local cb = CreateCheckbox(dbKey, "", row, nil, callback)
        cb.associatedTitle = title
        cb.associatedRow = row
        cb.parentCheckButtons = parentCbs
        for _, parentCB in ipairs(parentCbs) do
            parentCB.childrenCheckButtons = parentCB.childrenCheckButtons or {}
            table.insert(parentCB.childrenCheckButtons, cb)
        end
        cb:SetSize(28, 28)
        cb:SetPoint("RIGHT", row, "RIGHT", -5, 0)
        if cb.UpdateEnabledState then
            cb:UpdateEnabledState()
        end

        titleFrame:EnableMouse(true)
        titleFrame:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                if cb:IsEnabled() then
                    cb:Click("LeftButton")
                end
            elseif button == "RightButton" then
                if BBF.HandleRightClick then
                    BBF.HandleRightClick(dbKey, titleStr, titleFrame)
                end
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

    -------------------------------------------------------
    -- CATEGORY 9: Arena Names
    -------------------------------------------------------
    local cfArena = categoryFrames["arenaNames"].contentFrame
    local cardArena = CreateOptionCard(cfArena, L["Arena_Names"], nil, -10)
    local cbTF = AddCardCheckbox(cardArena, "targetAndFocusArenaNames", L["Target_And_Focus_Arena_Names"], L["Tooltip_Target_And_Focus_Arena_Names_Desc"])
    local cbParty = AddCardCheckbox(cardArena, "partyArenaNames", L["Party"], L["Tooltip_Party_Arena_Names_Desc"])
    local arenaParents = { cbTF, cbParty }
    AddCardMultiParentChildCheckbox(cardArena, arenaParents, "showSpecName", L["Show_Spec_Name"], L["Tooltip_Show_Spec_Name_Desc"])
    AddCardMultiParentChildCheckbox(cardArena, arenaParents, "shortArenaSpecName", L["Short"], L["Tooltip_Short_Arena_Spec_Name"])
    AddCardMultiParentChildCheckbox(cardArena, arenaParents, "showArenaID", L["Show_Arena_ID"], L["Tooltip_Show_Arena_ID"])
    FinalizeCardLayout(cfArena, cardArena)

    -------------------------------------------------------
    -- CATEGORY 10: Focus Frame
    -------------------------------------------------------
    local cfFocus = categoryFrames["focus"].contentFrame
    local cardFocus = CreateOptionCard(cfFocus, L["Focus_Frame"], nil, -10)
    AddCardCheckbox(cardFocus, "focusFrameClickthrough", L["Clickthrough"], L["Tooltip_Focus_Clickthrough"], BBF.ClickthroughFrames)
    AddCardCheckbox(cardFocus, "hideFocusName", L["Hide_Names"], L["Tooltip_Hide_Focus_Name"], BBF.UpdateNameSettings)
    AddCardCheckbox(cardFocus, "hideFocusLeaderIcon", L["Hide_Leader_Icon"], L["Tooltip_Hide_Focus_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:16:16|a", BBF.HideFrames)
    AddCardCheckbox(cardFocus, "classColorFocusReputationTexture", L["Reputation_Class_Color"], L["Tooltip_Focus_Reputation_Class_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a")
    AddCardCheckbox(cardFocus, "hideFocusReputationColor", L["Hide_Reputation_Color"], L["Tooltip_Hide_Focus_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a", BBF.HideFrames)
    FinalizeCardLayout(cfFocus, cardFocus)

    -------------------------------------------------------
    -- CATEGORY 11: Focus ToT
    -------------------------------------------------------
    local cfFToT = categoryFrames["focusToT"].contentFrame
    local cardFToT = CreateOptionCard(cfFToT, L["Focus_ToT"], nil, -10)
    AddCardCheckbox(cardFToT, "hideFocusToT", L["Hide_Frame"], L["Tooltip_Hide_FocusToT_Frame"], BBF.HideFrames)
    AddCardCheckbox(cardFToT, "hideFocusToTName", L["Hide_Names"], L["Tooltip_Hide_FocusToT_Name"])
    AddCardCheckbox(cardFToT, "hideFocusToTDebuffs", L["Hide_FocusToT_Debuffs"], L["Tooltip_Hide_ToT_Debuffs"], BBF.HideFrames)
    AddCardSlider(cardFToT, "focusToTScale", L["Size"], L["Tooltip_FocusToT_Size"], 0.6, 2.5, 0.01)
    AddCardSlider(cardFToT, "focusToTXPos", L["X_Offset"], L["Tooltip_FocusToT_X_Offset"], -100, 100, 1)
    AddCardSlider(cardFToT, "focusToTYPos", L["Y_Offset"], L["Tooltip_FocusToT_Y_Offset"], -100, 100, 1)
    FinalizeCardLayout(cfFToT, cardFToT)

    -------------------------------------------------------
    -- CATEGORY 12: Pet Frame
    -------------------------------------------------------
    local cfPet = categoryFrames["pet"].contentFrame
    local cardPet = CreateOptionCard(cfPet, L["Pet_Frame"], nil, -10)
    AddCardCheckbox(cardPet, "hidePetFrame", L["Hide_Pet_Frame"], L["Tooltip_Hide_Pet_Frame_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPet, "petCastbar", L["Pet_Castbar"], L["Tooltip_Pet_Castbar"], BBF.UpdatePetCastbar)
    AddCardCheckbox(cardPet, "hidePetName", L["Hide_Pet_Name"], L["Tooltip_Hide_Pet_Name_Desc"], function() BBF.AllNameChanges() end)
    AddCardCheckbox(cardPet, "hidePetAuraTooltip", L["Hide_Pet_Aura_Tooltip"], L["Tooltip_Hide_Pet_Aura_Tooltip_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPet, "colorPetAfterOwner", L["Color_Pet_After_Player_Class"], "", function() BBF.UpdateFrames() end)
    AddCardCheckbox(cardPet, "hidePetText", L["Hide_Pet_Statusbar_Text"], L["Tooltip_Hide_Pet_Statusbar_Text_Desc"], BBF.HideFrames)
    AddCardCheckbox(cardPet, "hidePetHitIndicator", L["Hide_Pet_Hit_Indicator"], L["Tooltip_Hide_Pet_Hit_Indicator_Desc"], BBF.HideFrames)
    FinalizeCardLayout(cfPet, cardPet)


    -------------------------------------------------------
    -- DEFAULT CATEGORY SELECTION
    -------------------------------------------------------
    SelectCategory("general")

    -------------------------------------------------------
    -- RELOAD & RESET BUTTONS
    -------------------------------------------------------
    local reloadUiButton = CreateFrame("Button", nil, BetterBlizzFrames, "UIPanelButtonTemplate")
    reloadUiButton:SetText(L["Reload_UI"])
    reloadUiButton:SetWidth(96)
    reloadUiButton:SetPoint("RIGHT", SettingsPanel.CloseButton, "LEFT", -3, 0)
    reloadUiButton:SetScript("OnClick", function()
        BetterBlizzFramesDB.reopenOptions = true
        ReloadUI()
    end)
end
