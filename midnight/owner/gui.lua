if not BBF.isMidnight then return end
BetterBlizzFrames = nil
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local L = BBF.L
--local anchorPoints = {"CENTER", "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT"}
local anchorPoints = {"CENTER", "TOP", "LEFT", "RIGHT", "BOTTOM"}
local anchorPoints2 = {"TOP", "LEFT", "RIGHT", "BOTTOM"}
local pixelsBetweenBoxes = 6
local pixelsOnFirstBox = -1
local sliderUnderBoxX = 12
local sliderUnderBoxY = -10
local sliderUnderBox = "12, -10"
local titleText = "|A:gmchat-icon-blizz:16:16|a Better|cff00c0ffBlizz|rFrames: \n\n"

-- Font configuration for localization support
-- Custom fonts (arialn.TTF, Expressway_Free.ttf) support Latin alphabet only
-- For non-Latin languages, use WoW's default font from GameFontNormal (supports all locales)
local locale = GetLocale()

-- Check if custom fonts support the current locale (Latin-based languages only)
local useCustomFonts = (locale == "enUS" or locale == "enGB" or
                         locale == "deDE" or locale == "esES" or locale == "esMX" or
                         locale == "frFR" or locale == "itIT" or locale == "ptBR")

local fontSmall, fontMedium, fontLarge

if useCustomFonts then
    -- Use custom addon fonts for Latin-based languages
    fontSmall = "Interface\\AddOns\\BetterBlizzFrames\\media\\arialn.TTF"
    fontMedium = "Interface\\AddOns\\BetterBlizzFrames\\media\\arialn.TTF"
    fontLarge = "Interface\\AddOns\\BetterBlizzFrames\\media\\Expressway_Free.ttf"
else
    -- Get game's default font path which already supports the current locale
    local gameFont = GameFontNormal:GetFont()
    fontSmall = gameFont
    fontMedium = gameFont
    fontLarge = gameFont
end

local playerClass = select(2, UnitClass("player"))
local playerClassResourceScale = "classResource" .. playerClass .. "Scale"

BBF.fontSmall = fontSmall
BBF.fontMedium = fontMedium
BBF.fontLarge = fontLarge
BBF.anchorPoints = anchorPoints
BBF.anchorPoints2 = anchorPoints2
BBF.pixelsBetweenBoxes = pixelsBetweenBoxes
BBF.pixelsOnFirstBox = pixelsOnFirstBox
BBF.sliderUnderBoxX = sliderUnderBoxX
BBF.sliderUnderBoxY = sliderUnderBoxY
BBF.sliderUnderBox = sliderUnderBox
BBF.playerClass = playerClass
BBF.playerClassResourceScale = playerClassResourceScale


BBF.squareGreenGlow = "Interface\\AddOns\\BetterBlizzFrames\\media\\blizzTex\\newplayertutorial-drag-slotgreen.tga"

local checkBoxList = {}
local sliderList = {}

local function RecolorEntireAuraWhitelist(r, g, b, a)
    if type(BetterBlizzFramesDB) ~= "table" then return false end
    local wl = BetterBlizzFramesDB.auraWhitelist
    if type(wl) ~= "table" then return false end

    for _, entry in pairs(wl) do
        if type(entry) == "table" then
            local c = entry.color
            if type(c) == "table" then
                if c[1] or c.r then
                    c[1], c[2], c[3], c[4] = r, g, b, a
                    c.r, c.g, c.b, c.a = nil, nil, nil, nil
                else
                    entry.color = { r, g, b, a }
                end
            else
                entry.color = { r, g, b, a }
            end
        end
    end

    if BBF and BBF["auraWhitelistRefresh"] then
        BBF["auraWhitelistRefresh"]()
    end

    return true
end

local function UpdateColorSquare(icon, r, g, b, a)
    if r and g and b then
        if icon.SetVertexColor then
            icon:SetVertexColor(r, g, b, a or 1)
        elseif icon.SetColorTexture then
            icon:SetColorTexture(r, g, b, a or 1)
        end
    end
end

local function OpenColorOptions(entryColors, func)
    if type(entryColors) ~= "table" then return end
    local colorData = entryColors
    local r, g, b = colorData[1] or 1, colorData[2] or 1, colorData[3] or 1
    local a = colorData[4] or 1

    local function updateColors(newR, newG, newB, newA)
        if type(entryColors) == "table" then
            entryColors[1] = newR
            entryColors[2] = newG
            entryColors[3] = newB
            entryColors[4] = newA or 1
        end

        if func then
            func()
        end
    end

    local function swatchFunc()
        r, g, b = ColorPickerFrame:GetColorRGB()
        updateColors(r, g, b, a)
    end

    local function opacityFunc()
        a = ColorPickerFrame:GetColorAlpha()
        updateColors(r, g, b, a)
    end

    local function cancelFunc(previousValues)
        if previousValues then
            r, g, b, a = previousValues.r, previousValues.g, previousValues.b, previousValues.a
            updateColors(r, g, b, a)
        end
    end

    ColorPickerFrame.previousValues = { r = r, g = g, b = b, a = a }

    ColorPickerFrame:SetupColorPickerAndShow({
        r = r, g = g, b = b, opacity = a, hasOpacity = true,
        swatchFunc = swatchFunc, opacityFunc = opacityFunc, cancelFunc = cancelFunc
    })
end







local LSM = LibStub("LibSharedMedia-3.0")


local function CreateFontDropdown(name, parentFrame, defaultText, settingKey, toggleFunc, point, dropdownWidth, maxVisibleItems, labelPos)
    maxVisibleItems = maxVisibleItems or 25  -- Default to 25 visible items if not provided

    -- Create container for label and dropdown
    local container = CreateFrame("Frame", nil, parentFrame)
    container:SetSize(dropdownWidth or 155, 50)

    -- Create and position label
    local label

    -- Create the dropdown button with the new dropdown template
    local dropdown = CreateFrame("DropdownButton", nil, parentFrame, "WowStyle1DropdownTemplate")
    dropdown:SetPoint("BOTTOMLEFT", container, "BOTTOMLEFT", 0, 0)
    dropdown:SetWidth(dropdownWidth or 155)
    dropdown:SetDefaultText(BetterBlizzFramesDB[settingKey] or defaultText)
    dropdown.Background:SetVertexColor(0.9,0.9,0.9)
    dropdown.Arrow:SetVertexColor(0.9,0.9,0.9)

    if labelPos == "TOP" then
        label = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetPoint("BOTTOM", dropdown, "TOP", 0, 3)
        label:SetText(L["Font"])
    else
        label = container:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall2")
        label:SetPoint("LEFT", container, "LEFT", -50, -12)
        label:SetText(L["Font"])
        label:SetFont(fontSmall, 13)
    end

    -- Custom font display for the selected font
    -- dropdown.customFontText = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- dropdown.customFontText:SetPoint("LEFT", dropdown, "LEFT", 8, 0)
    -- dropdown.customFontText:SetText(BetterBlizzFramesDB[settingKey] or defaultText)
    -- dropdown.customFontText:SetTextColor(1,1,1)
    -- local initialFont = LSM:Fetch(LSM.MediaType.FONT, BetterBlizzFramesDB[settingKey] or "")
    -- if initialFont then
    --     dropdown.customFontText:SetFont(initialFont, 12)
    -- end

    -- Initialize a unique font pool for this dropdown
    dropdown.fontPool = {}

    -- Fetch and sort fonts
    C_Timer.After(1, function()
        local fonts = LSM:HashTable(LSM.MediaType.FONT)
        local sortedFonts = {}
        for fontName in pairs(fonts) do
            table.insert(sortedFonts, fontName)
        end
        table.sort(sortedFonts)

        -- Define the generator function for the dropdown menu
        local function GeneratorFunction(owner, rootDescription)
            local itemHeight = 20  -- Each item's height
            local maxScrollExtent = maxVisibleItems * itemHeight
            rootDescription:SetScrollMode(maxScrollExtent)

            for index, fontName in ipairs(sortedFonts) do
                local fontPath = fonts[fontName]

                -- Create each item as a button with the custom font
                local button = rootDescription:CreateButton("                                                  ", function()
                    BetterBlizzFramesDB[settingKey] = fontName
                    -- dropdown.customFontText:SetText(fontName)
                    -- dropdown.customFontText:SetFont(fontPath, 12)
                    dropdown:SetDefaultText(BetterBlizzFramesDB[settingKey] or defaultText)
                    toggleFunc(fontPath)
                end)

                -- Use the pooled font string for each button
                button:AddInitializer(function(button)
                    local fontDisplay = dropdown.fontPool[index]
                    if not fontDisplay then
                        fontDisplay = dropdown:CreateFontString(nil, "BACKGROUND")
                        dropdown.fontPool[index] = fontDisplay
                    end

                    -- Attach the font display to the button and set the font
                    fontDisplay:SetParent(button)
                    fontDisplay:SetPoint("LEFT", button, "LEFT", 5, 0)
                    fontDisplay:SetFont(fontPath, 12)
                    fontDisplay:SetText(fontName)
                    fontDisplay:Show()
                end)
            end
        end

        -- Hide any unused font strings when the menu is closed
        hooksecurefunc(dropdown, "OnMenuClosed", function()
            for _, fontDisplay in pairs(dropdown.fontPool) do
                fontDisplay:Hide()
            end
        end)

        -- Set up the dropdown menu with the generator function
        dropdown:SetupMenu(GeneratorFunction)
    end)

    -- Position the container on the specified anchor point
    container:SetPoint("TOPLEFT", point.anchorFrame, "TOPLEFT", point.x, point.y)

    return dropdown, container
end

local function CreateTextureDropdown(name, parentFrame, labelText, settingKey, toggleFunc, point, dropdownWidth, maxVisibleItems)
    maxVisibleItems = maxVisibleItems or 25  -- Default to 25 visible items if not provided

    -- Create container for label and dropdown
    local container = CreateFrame("Frame", nil, parentFrame)
    container:SetSize(dropdownWidth or 155, 50)

    -- -- Create and position label
    -- local label = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- label:SetPoint("BOTTOMLEFT", container, "TOPLEFT", 0, 2)
    -- label:SetText(labelText)

    -- Create the dropdown button with the new dropdown template
    local dropdown = CreateFrame("DropdownButton", nil, parentFrame, "WowStyle1DropdownTemplate")
    dropdown:SetPoint("BOTTOMLEFT", container, "BOTTOMLEFT", 0, 0)
    dropdown:SetWidth(dropdownWidth or 155)
    dropdown:SetDefaultText(BetterBlizzFramesDB[settingKey] or L["Select_Texture"])
    dropdown.Background:SetVertexColor(0.9,0.9,0.9)
    dropdown.Arrow:SetVertexColor(0.9,0.9,0.9)

    -- Initialize a unique texture pool for this dropdown
    dropdown.texturePool = {}

    -- Fetch and sort textures
    C_Timer.After(1, function()
        local textures = LSM:HashTable(LSM.MediaType.STATUSBAR)
        local sortedTextures = {}
        for textureName in pairs(textures) do
            table.insert(sortedTextures, textureName)
        end
        table.sort(sortedTextures)

        -- Get class colors table
        local classColors = RAID_CLASS_COLORS
        local classKeys = {}
        for class in pairs(classColors) do
            table.insert(classKeys, class)
        end

        -- Define the generator function for the dropdown menu
        local function GeneratorFunction(owner, rootDescription)
            local itemHeight = 20  -- Each item's height
            local maxScrollExtent = maxVisibleItems * itemHeight
            rootDescription:SetScrollMode(maxScrollExtent)

            for index, textureName in ipairs(sortedTextures) do
                local texturePath = textures[textureName]

                -- Create each item as a button with the background texture
                local button = rootDescription:CreateButton(textureName, function()
                    BetterBlizzFramesDB[settingKey] = textureName
                    dropdown:SetDefaultText(textureName)
                    toggleFunc(texturePath)
                end)

                -- Use the pooled texture for the background on each button
                button:AddInitializer(function(button)
                    local textureBackground = dropdown.texturePool[index]
                    if not textureBackground then
                        textureBackground = dropdown:CreateTexture(nil, "BACKGROUND")
                        dropdown.texturePool[index] = textureBackground
                    end

                    -- Attach the background to the button and set the texture
                    textureBackground:SetParent(button)
                    textureBackground:SetAllPoints(button)
                    textureBackground:SetTexture(texturePath)

                    -- Pick a random class color and apply it
                    local randomClass = classKeys[math.random(#classKeys)]
                    local color = classColors[randomClass]
                    textureBackground:SetVertexColor(color.r, color.g, color.b)

                    textureBackground:Show()
                end)
            end
        end

        hooksecurefunc(dropdown, "OnMenuClosed", function()
            for _, texture in pairs(dropdown.texturePool) do
                texture:Hide()
            end
        end)

        dropdown:SetupMenu(GeneratorFunction)
    end)

    container:SetPoint("TOPLEFT", point.anchorFrame, "TOPLEFT", point.x, point.y)

    return dropdown, container
end

local function CreateSimpleDropdown(name, parentFrame, labelText, settingKey, optionsTable, toggleFunc, point, dropdownWidth)
    dropdownWidth = dropdownWidth or 155  -- Default dropdown width if not provided

    -- Create container for label and dropdown
    local container = CreateFrame("Frame", nil, parentFrame)
    container:SetSize(dropdownWidth, 50)

    -- Function to get localized text
    local function GetLocalizedText(text)
        if text == "" then return "NONE" end
        return L[text] or text
    end

    -- Create the dropdown button with the new dropdown template
    local dropdown = CreateFrame("DropdownButton", nil, parentFrame, "WowStyle1DropdownTemplate")
    dropdown:SetPoint("BOTTOMLEFT", container, "BOTTOMLEFT", 0, 0)
    dropdown:SetWidth(dropdownWidth)
    dropdown:SetDefaultText(GetLocalizedText(BetterBlizzFramesDB[settingKey]) or (L["Select"].." "..labelText))
    dropdown.Background:SetVertexColor(0.9, 0.9, 0.9)
    dropdown.Arrow:SetVertexColor(0.9, 0.9, 0.9)

    -- Create and position label
    local label = container:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall2")
    label:SetPoint("LEFT", container, "LEFT", -50, -12)
    label:SetText(labelText)
    label:SetFont(fontSmall, 13)
    dropdown.LabelText = label

    -- Define the generator function for the dropdown menu
    local function GeneratorFunction(owner, rootDescription)
        local itemHeight = 20  -- Each item's height
        local maxScrollExtent = math.min(#optionsTable, 25) * itemHeight
        rootDescription:SetScrollMode(maxScrollExtent)

        for _, option in ipairs(optionsTable) do
            local displayText = GetLocalizedText(option)
            -- Create each item as a button
            local button = rootDescription:CreateButton(displayText, function()
                BetterBlizzFramesDB[settingKey] = tonumber(option) or option
                dropdown:SetDefaultText(displayText)
                if toggleFunc then
                    toggleFunc(option)
                end
            end)

            -- Add the text initializer for the button
            button:AddInitializer(function(button)
                --button.Text:SetText(displayText) -- 11.1 error
            end)
        end
    end

    -- Reset dropdown contents when closed
    hooksecurefunc(dropdown, "OnMenuClosed", function()
        dropdown:SetDefaultText(GetLocalizedText(BetterBlizzFramesDB[settingKey]) or (L["Select"].." "..labelText))
    end)

    dropdown:SetupMenu(GeneratorFunction)
    container:SetPoint("TOPLEFT", point.anchorFrame, "TOPLEFT", point.x, point.y)

    return dropdown, container
end

local function CreateColorBox(parent, colorVar, labelText, callback)
    local function OpenColorPicker(colorType, icon)
        -- Initialize color with default RGBA if not present
        BetterBlizzFramesDB[colorType] = BetterBlizzFramesDB[colorType] or {1, 1, 1, 1}
        local r, g, b, a = unpack(BetterBlizzFramesDB[colorType])
        if not a then a = 1 end

        local function updateColors()
            BetterBlizzFramesDB[colorType] = {r, g, b, a}
            if icon then
                UpdateColorSquare(icon, r, g, b, a)
                BBF.CastbarRecolorWidgets() --temp
            end
            ColorPickerFrame.Content.ColorSwatchCurrent:SetAlpha(a)
            if callback then
                callback()
            end
        end

        local function swatchFunc()
            r, g, b = ColorPickerFrame:GetColorRGB()
            a = ColorPickerFrame:GetColorAlpha()
            updateColors()
        end

        local function opacityFunc()
            a = ColorPickerFrame:GetColorAlpha()
            updateColors()
        end

        local function cancelFunc(previousValues)
            if previousValues then
                r, g, b, a = previousValues.r, previousValues.g, previousValues.b, previousValues.a
                updateColors()
            end
        end

        -- Setup and show the color picker
        ColorPickerFrame.previousValues = {r, g, b, a}
        ColorPickerFrame:SetupColorPickerAndShow({
            r = r, g = g, b = b, opacity = a,
            hasOpacity = true,
            swatchFunc = swatchFunc,
            opacityFunc = opacityFunc,
            cancelFunc = cancelFunc,
            previousValues = {r, g, b, a},
        })
    end

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(55, 20)

    local colorTexture = frame:CreateTexture(nil, "OVERLAY")
    colorTexture:SetSize(18, 18)
    colorTexture:SetPoint("LEFT", frame, "LEFT", 4, 0)
    colorTexture:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")

    local currentColor = BetterBlizzFramesDB[colorVar] or {1, 1, 1, 1}
    colorTexture:SetVertexColor(currentColor[1] or 1, currentColor[2] or 1, currentColor[3] or 1, currentColor[4] or 1)

    -- Label text for the color box
    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    text:SetText(labelText)
    text:SetPoint("LEFT", colorTexture, "RIGHT", 4, 0)
    frame.text = text

    -- Make the frame clickable and open a color picker on click
    frame:EnableMouse(true)
    frame:SetScript("OnMouseDown", function(self, button)
        if frame:GetAlpha() == 1 then
            if button == "LeftButton" then
                OpenColorPicker(colorVar, colorTexture)
            elseif button == "RightButton" and IsShiftKeyDown() then
                local defaultColor = BBF.defaultSettings[colorVar]
                if defaultColor then
                    BetterBlizzFramesDB[colorVar] = {unpack(defaultColor)}
                    UpdateColorSquare(colorTexture, unpack(defaultColor))
                    if callback then
                        callback()
                    end
                end
            end
        end
    end)

    local grandparent = parent:GetParent()

    if parent:GetObjectType() == "CheckButton" and (parent:GetChecked() == false or (grandparent:GetObjectType() == "CheckButton" and grandparent:GetChecked() == false)) then
        frame:SetAlpha(0.5)
    else
        frame:SetAlpha(1)
    end

    return frame
end














StaticPopupDialogs["BBF_KICK_POPUP_SOUND_ID"] = {
    text = "Enter a custom Sound ID (leave empty or 0 to use dropdown):",
    button1 = "OK",
    button2 = "Cancel",
    hasEditBox = true,
    OnShow = function(self)
        local fileID = BetterBlizzFramesDB.kickPopupSoundFileID
        if fileID and fileID ~= 0 then
            self.editBox:SetText(tostring(fileID))
        else
            self.editBox:SetText("")
        end
        self.editBox:HighlightText()
    end,
    OnAccept = function(self)
        local text = self.editBox:GetText():trim()
        local id = tonumber(text)
        if not id or id == 0 then
            BetterBlizzFramesDB.kickPopupSoundFileID = nil
            if BBF.kickPopupSoundNameDropdown then
                LibDD:UIDropDownMenu_SetText(BBF.kickPopupSoundNameDropdown, BetterBlizzFramesDB.kickPopupSoundName or "Lossa Countered")
            end
        else
            BetterBlizzFramesDB.kickPopupSoundFileID = id
            if BBF.kickPopupSoundNameDropdown then
                LibDD:UIDropDownMenu_SetText(BBF.kickPopupSoundNameDropdown, "ID: " .. id)
            end
            local channel = BetterBlizzFramesDB.kickPopupSoundChannel or "Master"
            PlaySound(id, channel)
        end
    end,
    EditBoxOnEnterPressed = function(self)
        local parent = self:GetParent()
        StaticPopupDialogs["BBF_KICK_POPUP_SOUND_ID"].OnAccept(parent)
        parent:Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

StaticPopupDialogs["BBF_CONFIRM_RELOAD"] = {
    text = titleText..L["Popup_Reload_Required"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        BetterBlizzFramesDB.reopenOptions = true
        ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
}

StaticPopupDialogs["BBF_TOT_MESSAGE"] = {
    text = titleText..L["Popup_Tot_Message_Text_Midnight"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end,
    OnCancel = function()
        BetterBlizzFramesDB.targetToTXPos = 0
        if BBF.targetToTXPos and BBF.targetToTXPos.SetValue then
            BBF.targetToTXPos:SetValue(0)
        end
        BetterBlizzFramesDB.focusToTXPos = 0
        if BBF.focusToTXPos and BBF.focusToTXPos.SetValue then
            BBF.focusToTXPos:SetValue(0)
        end
        BBF.MoveToTFrames()
        StaticPopup_Show("BBF_CONFIRM_RELOAD")
    end,
    timeout = 0,
    whileDead = true,
}

StaticPopupDialogs["BBF_CONFIRM_PROFILE"] = {
    text = "",
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function(self)
        if self.data and self.data.func then
            self.data.func()
        end
    end,
    timeout = 0,
    whileDead = true,
}

StaticPopupDialogs["BBF_CONFIRM_PVP_WHITELIST"] = {
    text = titleText..L["Popup_PVP_Whitelist_Midnight"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        local importString = "!BBFnQ1FSXr1DE2D8UElrxVetGmusWZDIEHiLtqPNJQao7S76FLw7elVoBiOwD5T7(2Dh8SZSm)y9TMC0MuQevkrjkfvrqhKFueuKOQb6PqnqsOrPbsqu26R6sc6sGyXDLRLlbzku(dk(((9nZB2NJND89x278((99EF)1NV)yMi)DPkqSjp65KJFpxjBkDsf6loszIfvjtz1I27KQRrmlrlST)w1cij7tTsvdtBIU92gnVHMH53mIuej71LTr0xe4GQvqzlenTgTHmyVUgX2wJ4FtPb75)QRUw)1DDx3G9CLU7EBW)ijh)p)1bMQUSK5Sm0CSHdKAs1vTR7YlUUl34bi3XH(yK6Byt1OMvnMaiTGskIPPk1eO3JkGEKtGwzPHxI7UxJQxsvVKsAthlsbo1bDJ84g4uo2R(Ia3ZoIPAfdZcQenqOQr9UyWI(I17T0LQa8cxWOjRdSSVnOBtnHZKtm84MsrIBzL4L6gtPrTSWlLrrLmK8MQfvZtxSlgWCIh8k97Tv4dEWRWoqD4aj2i)YTT9pboGt2RAnvDqHAtPf8UhWk87HKKC73txO8LupVkv3gVgdzysxGIeiR3Km1U4nUFtyBnQWPwYJ6EtM4QposChzCmRPwduABq3YwvpVT1IkBx9XLJS3Nc5(w3GEEIPoXw1q)UvgWHG6FD8C3SPLrE)DYxZ7Dxb2LL2LbSf5gRSHPULNGdpleNW27CmGJd3RHrfLTOQxWQL7pqPCSZVk0ppDztdDdqLzuL7sC(vj4Rg5d(uGSzgZWjFz8I)TiMviEucRfY1jYE3dQd6CE6GKG1LyIBusRYKkeFFlG6aCeJCSDIIusR8u9ce98(uFSDUqQt8OhepWLUrQDzQPLTHzfL(1iLUwxbGozPCVcqBJ)AUIn3Ri4rjTKmmRxMQMusb0tzSYuLTarp3TYiMg208OWWzDjzcrje9d3hdnbVmJtPvzXSSyPpCFbiVXt9PmriPUT6F)WKsQ5bOlkhccxwW0eBhFgZFoTbgxdAyagjPLfXrZMBk3XNfWHi197XoeuOsrjw2G3IDzvFbQ73ZLPb75)9V8fipa3Nz)7)eZn3Csj2(Uq3bFKOTysSl3k)mGy5ixylyu8MmZHg9rq0oUn8cBHFoF4N)xuy6Tt0zN9m3CFHeA5)(Ob6MBDmYX((YX(xEugebyMqtTAPY2liUhOro6n)SOeFtmZWAv6JyAxETke9ck9RA6JUDZpBa(un(ag07OgUETIiCOe24dclc4DpaW809QwSOdKeIzp5c)7EGqyuk3XMV35Xe8oJ(PNbwCNznulueeNwQGa6KB7DVu)meZ39sCTcimdsbfakn2OBTQgIRkh7NnccJUPQGtVl8ikZChPF2iIoExCB417g5lEXTfKx2TUbmhskndJcAow2T8Ecekh93JGDhoTrLCaPUbxTqQ(9gYXUWx1nkjNrfvxKfLHuRKRLmbmihtPt(LUfeP0PC026MH6VrITJjD1wkzMakCqhuiCNK26wqre)kVnUNk8WZR82bIH9iCpzx)2hjiTvUtWT4neteHlih)xvebrgMOrRzOr1fYVETcbq6JDeCNwJ7X9yhjOdt5Ym93iGLg3n0vyyiHrRnrkxwUJFm6FCyM9eWw9bUHNhWre7OdJ4eJcfpmb6lLsJmPFnhhD4q89J)rOoT6kgcu6utLwHe(rVTGDOTNBROmVCVfHF26diXwX6w2juV14wJZb9GhgchVWdJEYBauuG0NFCpwEHhw4giDxOwF67NQR0VrEhlLXO8SKWsIXohDi8QEN(6IHcdhyjYiX)v8DAjYEehzWE(LYYRNruS35G93InaPo6jzWDkUf0YoZ35Ga4ltJ934BYp3kwHle8bDTH(WSxyRjUZFPR8xxjlvLxmc80GCTw6pcTE3WOKsuoctgnXeFafbWx8x)vyi5uiDIs6Yyz6Cl9RlMAUT1ThrKr4Nclg5vpnE4lFaiFau5kuYwnvl1CQAnlehijmFVd(tybg9cx4YqEuOq76w2enFT0j7OdxT0mMMFpbTeWiyN7aDS6fCSeamGNgYb226278fN9kios)JdGH9ULZafTBYR)fwqWJkYfFgKSEjvQcEFdsyPeyY6fFMqo6iV1n5kRQuLC1Dnuty4FgWYHPOEQPzNjONusHA7YCR1tnDqw35IVo2QZfNHBJLZzHO23EAtv7145r)VT8LR452)vyOWBwZwTcb7MA(zDrceuarFVnl0jb(ta5jtvOkntOU9mEvfK47uLjVWcAAkJslQjwghSQyq6K7gX6YuXyCiM3WpZstyzGc5yNgtdwDzB0rttTyDeMldunTdxfcRlIqSeSNQzy9XGrgda9BwFHW9lPUSupRhOmvknh)yMEwFyOeXVo0XdXN6pScca6GW57Jh37gDFFUB8G9C5LTmVA9o1J9yhKz2ARef34XmDOwLnADgCGo5y)5FnkEO3VIV9TLCaud1zoi6dbvqcvFInApoxA7EqXOG1mfUXBwVSHwDH6BBHmUMPsmfcfBokPkMd3Z8o1rcrbgn2mOH8wa8c0GVrvNjjgRLfsa5TYpUYM(NBSyDAd7HS0k(CxxmEpJJraxS8(qbR4Zd7s8BZYqo9g8a4HKfQXMs0x8UPrELJvy1O6CekjpDck0HVFTBfwDt3WetHP(pCVQwaISvt3)PUCixTy76(erPGFkyFI(72iICNPmPGXek9scR6eGwzPBehhXHHoiGAqfqRGNh2vW6(XRqp8RG19hemt3VfquUuoMMgtWbK6(TcBB)r3fE5tAMNGZyWPzAhyLabYA3diRDeGQzFPk3(GqJu01WJ2J)4)dIysWprKcM2PzH3SkUKJEUxGz4tAHqw8v7JusZVZKZ9cbCxImk2Hu1BwCSc8HG8TaWiUBhqxR1ajgmn2Ga8hKMOZKc8kOMJd5BWm4ncUjq54R5PziFEZMzb9edRhwYJ4XrLo2Aoafte5lE8fkOjw(tIXZ9vJmpiLwn9LL)KaQ2qZhKBiU)QiQ59(FGe17cG2HfKJFM(Wfxf)EDM(eqYJSNtZWBnn0ZbWD8tzpHvzrhpXpm78vVUnx1cnS3vb4swAM2fd(GFke8fxhlZwit5i4uhPnhucqqyU)x2G1Ei8xM5Vr6wrPuxy1)x70(0ZBdoF8ARaAc5SI804CvZ5oaiUo7Pxxa276SXAS00AgKXzNddAzXN7w9pdA2)PD5La54NFdUbJibmihDU3erKCRZAIM5HGNly1LMjX8TdjeSdr(vFgtrc)9AphOmcNCq1OfDyylYrBSw8kU8(0nb))cqLiLGMKmj2))W5gzwoY2Fjm8zuqeR7omy)IB3(lfsK()(BaSn9WimLj0zBA)jBdRiiksDvlBZXU2pPMHFviDvtqFe7p9pH5Bsz4GyAPi8(IWfc5wC808aRgIJPbEUCStIfqFsOR08gLa34M4cWkIN8LMa3JVdFXlnraorRgHaMHnVjOpGIoc56w9qbGMgB2ddmSVm6gtuaQ1S1vyaeklDECEsnK5kMZh0KJoEj0RYTJMrGcb8o9JxkKGePupaElgel1rSG)upGi(ZB8GOMFi1IuL0g5n8vtWcHT3ZC9Z3b(6fbsYCYSE1qM2qJFUWtdzdJM)SOeoi00avyqRyP8)RRCLRxmVF(Zkh5z)EOOXkqSP6aFCihr8tDb8oZhnn8ZWiUDSzQd3xoOXIH9Q6NXv77nadU0KylmtZF9cSQU4QMjNU1hJ94SOpA(XrOWMD6zpEqhYmFP5RZ)sc68y7gNL6SBkNLkl)DM8eyl5E17ExHefTD0nz2KGIhs23lTiufYI)2GaUs8Xe8(8aE(IFmrmWFsmrZHHkElqzdp3xB0Easw0l(lyWjuBsfdZQLnSu9Nr2f)fbfGTRVmWqUrX5b53H0U(YTwiF)EqCYBsmJZ1wOX73ty(7RCwCdKNxklS5VjW6L0lXfVvoBy(uF4ZlAaHFkAavXQhnhqtTsvl)chvVlrSQpbL6QRCEVeK0G2IYQxRpnh9wxUmWSCS)WxJjfzmC0Y5ycC3lTIHUAEL0QM59lreiR5flXooAw289iQGxLJ3eD9X)2XrdrGJCOxhLjVcv4bPh61dY5E3sio0OK6OOmOrv)2Z3TuyQ05wPxn0ReRHuSg6SWP6xcD08y18tNeAUMTAteMb75SpXt8AWDyWE(Jp0dDqCxBI08wjof(U3A8iEs7PEQG8Ep3(rn0YNFn3J5yAlu09(dviw16Cx7Qh4aVMRrJvdV)KnCt0wFnUI6QKJ0dMxT6n4MsY9Lj18L(Y0Y9ulmdZEX3UvJDWjEVhmGCo1)ISS3PhK0rP3MJLbEEi7CSVX)ng4NudNz2yQvw8(nbosmekotNcGkyVszZMh2q1csJx)841F7CTB9ZVqIUTBhjzIf74VTBh8WAdj9h47W1wyAU357IxvVouDX3AzmhqSCSNBPOPAz9vbQld6fpTrLko6cLJ8ClnSJ7zUkMHiPL74Nk7wmbBVFMRgcM(RIDimlZQbLNLSqTMVVtynbyN4tItiFFzifPLCAwKa84WmY9YEBSDmai(QeaEhoJ(QKtJYH5bccH92gFcMkHvZVArvOW1bmHs)8FL8JpHaQN0zrqe3VFanxCHgIv7HeilLgFNp7lLrH6CXiCVoGHBJ9oC(2Uh6T1zyY7SJYqzG)IrD4ap0i5PvWeMPOK8GXK3Q(VbFBVnEiUA83KjOSxNM92SWOdLm2nFx5NEdIG9N6smuLmvvnvTXojyvANKwYp3iqstgs8g4aENDevOlyt3VgbJw)IYaQtS17gpGBSFtQ(KQlS5bKQTE3H4J11rzD73fldauarbyJiAybqJ6yvEba8)WZH5c8(AtAzidqMCK38NJipcP54(8V5ppK7Z94MOklPcQYYJEKMKfFGxaFYr6Qyqk7b84ND2Dvmmpelm790mtAVQZBoeWsHCPNQbdiVVkSVDhqZbQVTqjvB98obwE)7f18V)9Yu8n6QvxkPB4qz5VYgOeHMF(r4kHjmNcNRxJ167MDzb)YiNFs0pRFdtBV5uNYKYhqgSyi7B0VXfZY(4A8FlC3FZx9hSyiQPoXYVM1fLG9nua1U5b2aRfMS8tpdZWafk6)nZWLRF6zcJX)Zc4r2CilzkB44fpfYuwa2KB76rKLQRWF0TELe0VQTnviMSvyta)joc(AcNHL8fLxX8Vh5HddB9c)pSegoMefVQgwaGjqJCSPUJSyhLMKsgSHhWvktDhbGyfpHc6ruJdRLqzHeL4e7HHhCcg0F09nKA(Y5mm1B1G)sCC3pkkOnXCOzvH5sz7uGNN64pEiYPuUJNvSzOChVHFsTeV8ZZ8w4ZY0nQ2BxF5NpmT3F87Ya6H)ckXXalo05hOejA(U)7VpgkZM1PUEIJsTm0QTOOmiJ7e)GchREv60eW8SLYQ2unvl7)Vd!BBF"
        local profileData, errorMessage = BBF.OldImportProfile(importString, "auraWhitelist")
        if errorMessage then
            BBF.Print(L["Print_Error_Importing_Whitelist"] .. " " .. tostring(errorMessage))
            return
        end
        BBF.DeepMergeTables(BetterBlizzFramesDB.auraWhitelist, profileData)
        BBF.auraWhitelistRefresh()
        Settings.OpenToCategory(BBF.category:GetID(), BBF.aurasSubCategory)
    end,
    timeout = 0,
    whileDead = true,
}

StaticPopupDialogs["BBF_CONFIRM_PVP_BLACKLIST"] = {
    text = titleText..L["Popup_PVP_Blacklist_Midnight"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        local importString = "!BBF11xcysr5z(70h1mOGccinxXwnrCtcM1K11igJo3mWmW4mat0eDtnDxtpLt1v1wDxZqZAwdKvtIU5snhAIXDnBUmRMOHaRAmrqmXK1SPxatWdubeburCaeq8G))EpQQ7bZ)8KNNxD6V6749(67Z6o7MYAwY8RhFQPsEx3Y)4zANLGn5AM3AJTwSOLBgR0nf4xS0QkoO3iDz7A9zByn38zJXbqLyfMs3w(f9CnDSxHv209zzwAql)ugRzX8ubyLyRVhpVsPxKvPr88hQsIpBkJrBu(1rBeZWKwM9WMzSlvoT3aPBZ3RyjzmnPJPPJFmDANBqEmjw9g5XayLyRQplhN0TzLL)67Rx5RVVEX636YZyvSyTZDl6C3Y7z998ZyXJzn6mSgmdfo1El5BwYkNDM0D4oqqrBpxEd8N)tYg4p)NWGMyt4iAz5MgOG0Tw2QinKK393wqQ393gd50A1XkVLBjtN0npOPxX5LUvt)sdYdCF3GmW9DdvIT)EmxHNp2XM5OHZZu9jeSgG0UUf8H2U5sp)aFF7mMU8Uo(SNhpgabgPPahNIwL1ZZs1ZZsReRY4XFQHvDc0Fbam0M98l45B6WdDLzKHUYmyHMwh5S9nNtX0n7hy5KEreYpVPVLC4Un9WDB)npCvX4pFNYu(8Dsl2G2P7ZCyzF92TE28V82Twj2D1JvXGcfCSTa31Timz3c2UjtzStDc2jMGkJJ)YDR)PD3jrH6ZUywV8enKq)9z6iNLD2L(DDf9D7Cr6FArH)PeN97k0XZ(DXunJUmbHgNIoCl5Z060TyMVGLRLpFOxXDZ7yazod7CUHRANGdXZnLrFfLZuFfjjKwDZywOyGdyGYMUfRIGSvoLXv6l7IR0NOM9yMZI5)k7phtmsMLW4K(IYyoPVi4IBlWNzr)ubweZxdZ6byY3SEGkXU5M9wr50TzlufJDEz6b8YIoZN0xsNPVe(tZI)tp(Ll)Ph)YjE3U8Y5BcPBqO7ku(Y4BoGmKV5a0q6Zgcy6jTfZryjaJ)YYKH8xwg2InHdN3ircOnSMBvOH3ktdJDO)apwabtWY8SZoGNFEEw(dFAzw(dFAcH1ybpG(lxOee3A2Z9AcSeUOKh5RlSBh5RJHn1(8nluaO0Lwauks1ZWqEGh3MVDzCB(2ReB7T5BzTcssPpB3SSKKXlRB6xgB6T37GMzXMU1897BQY(N0xvXwFvSoNzJoedz6(8TlwkxGPFwcj0Sx(cMUGAxCq7c8h906z4PXzy)qpso8nlXYLvTWdylFgzaB5ZqyZEla9vdasw6ElavM8cx)ee1MaI5yjwqYUFhR0lZUiypy57owRiF3XAReZV3bdgyahzl)19ewUVUhM8P3NPF)MUzt3feh98XgPtRHTCasivYN6oeCZtDheoShlhmehs9yharBx0gJNMWypVOBfqqybvOOvgOcuv8zK6RklxkcdnTgl5LNKyCkNUhlaT7N0wIf5X(bYI9y)aAXQQFOvSu0OSde6VHy5bqsyO9b9cCSlo4y01MChFpzU2X3J010MnzZPu55LUjhZmdLUBVrYkYNXoGiFdyLy3F7(cEWXsWtR3swP1BrReX0y5dE(LeuYYrrYj3HII2bHIMs1vQ1HTlMXIoAcx2)HYL9Fanxn75KL035ksoB9FswMT(pbPtIvFqlOVw2bdiOU1paFwj1kMoyl09GqW3D5PmEuvQ7rPbmTwlwYcOTSILcyDbmQapkN0fRNuYk7sG(50nHLrLcmwFo9OMdC5lZEf28jTxZHhUSCmVt9yEN0gP6XSNGcLcugYeFkEZcyLyBS1LxWRi2jTH95qPm(t6(8pXheigvQKfXRPUnqkaEkw7laehp0pvSeuoybCTRPIO(jfKj5NuGMKUmbJylGl0fgBdr0g3qzzm3qzW03bWxLSn5Z)fCcY5)cGjS7VjhpVSG5cSQ8wFCI(naPfVtGvSiudH)GllS00SAxKMMv70PdNER0DB5gU3IpRFV(Z)Em9m6Fei9BjsaN)xt2uN)xJvzL1eQRggcZL8CTkczaX8FIF(O8WaKiMqOpd8KWHqHfhI0Ja(wHTn(z97Kv7S(DyZ0eMfyffACdPMfxPW2uCLKDs7SwPBeh1CPIT5NwqcB(PjZrWTGHY7btwK1GragKNCJVPIc)MafUX2DSmZtOIEmllkeZCdYKN5g45Wh)EXaObl98TCkaSfyaUkbBM4QGMPUS8ZyZknasFefx2HIS6atXK72NSZbRHbfhdk9i3SmQJaFh3igug7IaNnON4IJXRQSuV6aSHtiB2FGVlTv7iNRDO2NeZCM82fqyiPvxORG02ySdB5R3HnOxnMjJJz(inwXpYTORmuX0)Y8CCSePGN6EePGN6EGuslww44cRB5YP8i1FIMYb)enjnU2zMdyG496ZLxwTNlpPBBjJydCUjTtDlc3gICBZyTJiJBTJqCan7xUiysbzf(iMVar9PHYl147xwQX3FKJjd3GW(mCdmcrSrr8nnnc4ZnZN1MxJTR7LTt7LtTzhOeq8NT7aFsMLpPVYptoPVYpJgute9JWSyu9rYB(YcooDbhhj1uZc2T5CgkGhYQpQmKvF0WTz9tiRSZNqwWDmFsvx50JXF8B66Ln4nD9KYBq4Z7j0tAQbgl0LJ6NGLotq)CLpT8T3G(TeZ5upUVTxph1QD9tya9thi6tN0ps4RN0pIDyWtSDBMg)tLgSmKGCk3WwFn6ZaaAQBXQeeqdT4CF)wbHDF)wcxmFtFysckNYyxGiFyinS4pc)Tl(Ja(WfeKnxiP04NTszp)ZG06254NgJWEIfmdHdEbZGMAYddtkslyNTKVNtkJdOQfpaulEZ9woF)2EfTz(P6U4Fn)tacU8EdYcfsPBXZtyk3R6v5EzVk7na8AyRMfRm05Mr8d5s((YyUKVpT2KcJbGKIvTkgpYTPcl3wOI1IwwdP7DJ5k0FJ5sEgaDj(zmjNAj9un87xnJr(9RgmcluuFLUlZmdkiSugpZYLf)zwoVbpoNGejMVZxwgZ35ltmQDpOTj73jzGlIrj5oxJqC25AG(WETSy9zc3wDB47kOOn8DbDPltxt4igBXi5SEz5RM1ldTaWZq3vi4KxEeHr5LjH0P0BPaGvzswVWfl2UrkJ)8)IST(Z)lGMCfaR3DGJiAzCKsYNFKsG1B(PmA8UKH24Db0q3(25jv(qsk0UAY39xk7J39xsYdseOKUs8pzpaCLkIhC7c1gqwO1Kd2lReRGPTgNWDO(REhK3yNwpKDmARdwQsJz2sCjNTq6UKZgSLiinOZQhlZio(4)d)VcD)F4)f77g9PWkXYKh(Qzk2rUvr)nGKw(odCn9t3yEipu7YySkjMxajXokQaC6TTG73Phb750DlUmhFcIjAaRWHpBMreQxMTFPabrD4hso)h(HWoI4vHxyqllCMTiZXNC3Qq6UHq6DrMvhSGNTifMCJpM8BB8XOJdKSkmicPOBp7I6g9c(VKn6f8FrK9UqacGr0EiR5r6KG79IN7j3SopB(Xc14LCRpQ8N26JIVC6iWpZmLddoId7fkvlLHjpX26lXJfqSnA2hBrjej3qB7V0QKTXlTkIxUamU7hA3VUz3aZAbijWWMmbJcCKRh7(7Nc281vvnVou1SQEmZYAsirXBHD(gay4cUL7hyl6MQ)HfM16FyiCZsh9wG5Wt(tEs5q9tEsWE0PLzbsOQns5GiygtW1asu)EZW(jeEQjVCPrv)4)C8Oamk8tRFSSKw)yYiRV6(bhqwkJBxIwdqmRZQfw9EM0n6xAEP7YJsNehVfLrb6u9z(k8P6Z8viwl4TLFEIGXo26mCely9tqewbmYyGXJiRJXJqKSfANziEV3gCHH1s5rAVLassE0niyIJUbIZeIUUuWO1oeJSsAaaeUY07i2duIS2weyzSQRux9vgT6R)wLvF93krhBgbKaDMuQs8CZQuMK74jKmlSJNGLJrmBMSc0w8nZ55IZyRLTsz06QLfU1vt4Rfzns6fzdLuUPxK3C71f)J2UZj9siKykJrVrzSJEJySV)qB(r0SMqalRWsN)bCiMsGFEmfp9yeEQn4C1)FXtgFtvr338UiRNMJ46eL8GR6xi)0v9lOddChdhzkcsmfqZu2CquvD67Rid8v)kSVbqDu42lmraQw29QdCV0aN8ImjTPuGt(E1y1or7xGOJR9lG57Z6f0V4AXPi(GaiSBXCoPRAbO(XFdkx7nejJFFBvycUVTckm5KswwhDhIo847w8Ncqih1Ph0kNfUhioJKOTlu2fTDHGJFHEd7bnxleQfGJHSy9n93Z)oGyxoFZa4aMk98L09Xxks6j2)Jk29)WgNCmdaowcMP3s(G7xWJN4Fug2j(hXWMDFsKGP711BK0TdpcHn2axgRRzMC3BsoE7EtSzwY3K0lgUCpYGwo5dv)4UCr9JlzVEITB74AzwKKgHyh0(K8N(IYK8tFr87ZOQTAlOfl9YG)eGI7eMbKxwLbEzsg40uNDC0SI5herdnEO)DzGp0)ojSSuxFonf8XX2sIs34GQPOdsHs0dD(wcuSuuTWgBxSBDeKsmfLBR0CMGKpEvkZ5QiMZuVxlul1ptjpbTEyDtFyAtp52rC(wU5OuHfknXitNdl4bNdJLRZaG)quGAyWW6TeJgG0bVd3SWls4vac5gMQB203vt9qIziPReqoDAWVQ0KhwAUsJTjLrytuGW5lyvkq2JX1FiotkjI4aQ0ARiC5CIvSn(cYMyJVaHufR2LPXuJbXlsccfqIC3dzPLsAqB0XrLcV9FUmKB)NJHagEZ(9CGUr41rGPZFlv2Ps(gpLSYVXtXAu89YNMmLtZjLinRIvZPVXTRuMBNOmt)9m9DBxkDNWpEm2gEHjtdfGqjL6w(hxKQw(hNiRle6okniL7AvadFzMHS0CBkEGbiW0D5jrz2Bj1pNN4hj)6tGah2Fh5jYj8he2MSvSWBkUyciXveQtKo2GxUGPTmnBxsreGCkyaBdmKKUptXZGgUxjd837jWgz4muiQARwPcjhnac9RlE50gu5Pm2NkJSV)DM)NS7dMyVmclrYv)6coF1VoPnOJmuqaHsNn757huOKKcavC6buY6d8Zjxy5)0j8CYF6eEoYwlmsKrSmhWX5un06PE184aK0baxTj39RAKPlpxWhB5lCHx8efBCx8eLCAZQuB3CfwnKEMm2infuFBo2fsV4abje75v2(NhUhXrJKX3ueKtEWDihZdUdGHBSiLGSMnra2Lve4h4VkF7h4Vsm9DKZ1IwV5d2T0lb(zXcDF6ficDF6fqPdMZ7rTbRzSRFSmh76ht0PoChMZQkyRApWws)ASHonrBZqNg5bN5aq3ly6eR637HKT49Eis4S3mM(owLsZzmQQF(BAVYG20Eb1SlZC5nzLS9RBHp4we74FWTa(X299cipvhYMymrKj346Kn4nUoYabcufUqf5nkgTQ(4wu33Uf4(2gfNu7QkLj(1kkraKIzLYQQxqjs(SFpElU(dkBX1FqApeMJ2AcI6wuhSULhHiTuuD1m9gBy1YVUHvtHn6tHwuLBo5o0Z)o2lHJBIZ6qBE(PHwo4qapKJShzihzpSih5So8nT8X5R(EFvzu79vd5JtUEv386HU57VnlAlLpuFt8n0SCQ3qZuOUM(9dbfkHuYEET6EETucwTH8zn756k8UITXcuvJo1L6MLslwPY1yDCJkkBJhKgrt(cbtmX0P9aYr)n0D8B8QKd8dAwOOxwbLDvso4beeSffKVF6JbLPOU1Br36TGJ6)h)fVR4tcGSRcC41mHosQK35x7Nq25x7NaKAIloB1nD8n0QoTTgoT1v4y6j9yK9RLmyaDwXobbhx9dn2HsH3XQ5tlLoBsTdx7uOMr8y8RlfbcqCMAe)YGqsb(5Ym6nCD)vUIrxhlT2iyTmH7DwfmLspKY4q3N81h6(OLymrEsA1ee65FMcc98ptHUmqGV4gTAZrqbxSIcUyCk3cuU86QsgOV8UwqaLaqxtrbuS1EsI09ApPiFd37He1y79qCe)197(q8qaKmy4IiNljwoHDyE9CxP6i1kzt0(5iMbe9Ce6RUFKyrcqmfDAzX0RQgNF)xj9ZV)ReSPSLv48oCJM3mZ(dlBMz)HXCpZARi5sgXMtndv(DQW8XEEjutaP4PPY1NMkqslwzmf5NzpxDUMljLv7C1Bgps3icxxKNaeOk4Jo(XOStT3TlhZ9UDQcwbfhmWU6rm2bK6Sci7cULz2YvnzfFkdlZ7ugo0b9(9zJI0Vw)j)lLsrCYuktM489gjQyKiKHHqW5XeQ(MJXB8cE2oSjOfz5aNa811ybIseaHW289kbT0cs045fNuaK59ksPQN(EvDkpMBvlC4TUmEnqaAKBNwWtmFoAebh4(5us9NJgv7UW5aFRCMU1iJDKFJSnoYVHomlbg7crYfSexqIpRfWZcGGdR5uj(Asb8bK87QD4Rl4WQwiHwDZYzKVnqs9Yl(aS5ekkjbMIxL)tpvC5p9uXbowuzf47hM2Y7qv4ChqHtHPr6F7dtMeQiLo3La31fpoFNlsg57CrCseCi(KfNxQnsDUFbfb8fQOLKOiDSQE(tmSirbiHSRjnZl0oF)bCP7t(06U)PtqD3b0rnGwG76CZOZFg2IkXPmczoOkJ29)negT7)Bq5pfMQksf6J5JgVMR6XNnkaRTjjZbqYxPfxOGp5z)WwPxmiRSL(oq0XbHUZB8T1u6)ThrOE55m3IfixKh)V4Nx28V4NNvu56Api58hIrbrIeM3N7uZw7DszRDYSNnZTxpZHGstXgpVHh3dkB4X9GqJzNyB5ugeIsw51IzVEzsE51tBgWgeWX9TeVOclySDn)GB)Rc199nOTOoeYFwcMEDtq2SRBcKnqpxlOCYvlNAD79fvj6xKYTFG3vBxdJCSdksDacIuJWPbF1qCDU)Rkr6FvuK4a8dxzQQMhF7FISUV9pHCH1AapQQrvtJ47O(R8oC6MQwP0wxEbQgGAznoqmrH1bIXedkBMuZB0JvjsejLXhsSbdizsSnobf4Sx2XAEPfvqco4uuCWPuj2wQlg93syijrcqWfrzRcE8P(vAiAYaeyfob)JnAlJDPrsTlej12HlWKxhikMWagRZ5hiOhhU04H4eo2zOO2CfW)OugxV6571)8roLFQIamGKKdfQxrU1RAYR)W03B8wklXBrSetIsltPbbYaX)uL37B1JmMVvpy)rQWO2)rA1l5aUg9aUgYPyly(GoGrX0z8RNV87)65tfhD5SpvUAfBt84DliUhVBkJNWdst4WRl5vUyMi5wf5Fajv92fgehDwoM)13ETkFbC7A7H19UplZckJX(vC7()DIAyFUDdsZfnLZFRWaMxza5II1HVN7auxzuJdlVX)TmpVX)nodqS3ZVuGRTIaUEXsgGso931Lk)776sHvpolLCjstz86Fd5hEDORz)T6MdXkkjNPjZCPI9ABteqETTr7IM9SzACxMWb92Gopbzo6diBKrFa2POmCzMGrln2SzOmBZ4DPCCZsjJy6i9s3HFc53omLZWtDzEoLmrmAmUK3F0GI)BxJyl53UgYZCZIdIJVz)owNb059NuDF)jkOahymGDGv)Yy)IPjB)FX0iPhO7Oybni1A96Uo3BqX13aRjZ2jNu85Ae23SWucyKE338XL1(nFC6RyVrOIJoe75uxMs3cM4Cf)JbKC9Hq75leLTVhzd8cdyfolJwHgs7WnRxE7s0PmvYrv2TrzZnnocuXsvfBbMzTcnQy8KQTVNCJKcGtL)BRu7wKvsDlY0wc0aiAGAJ8(On4JNzrPvesSGpVSpwaPVFIT745xBTVtz0I4ZeGvgtr36DqOOxCa5HvhqEyYbKj3tqPbzd6nMlhBospWJtBOGXnkfMmuwMlqYCyYJk1kgqkj7W3BnAHSkt2JODt2J8fjKa1Iq0Vrzhji0jlJrD08f7WJXRp8ZKXlsnJPF5g6rkVxpRMddvCBbY35d9e9J)jK9Wh)tqXbtAGZR1knvYdnv53o0ubDeCpfSR2qr19JEt(hbuSxMHYiiuiHGtYgfK4ANTmdRD2vI5JOPkvsc)U(4)rX3W4uQpNIg158iDbyqKEbI2Rk4h9ui0lwbBkLoGFkJNF0seFFsXiaK2hlzq)AA6nGNKmjBizAfqQ37qamvvBgFxcso(UieO0ZKh)z9FtItgqGi4AA1BqMmEAb49e67WEqm5k458L2KquEjk7EtSwxY7gNuywxtz22PuMnjPF2kNUXmz8TIYVWtMso9pzQOKLndbBcinTDgKzOWPTfFtoOLKp0PlF1dD6KEjfLXfes4wAtvB1gzdR2(OLldMPkALy4XRNPXti1A92Z3m3CgXuMmv(BuY3Zj1nSNykHU2jrCew45Pg)MxCYrLZTPZTTZnDBHkSxROPfqAv6jWLtT6WuIVOEVuMHnOM12a0ew5)M3DhsSecixIrxzRbY6CxG0DfZw7RKzBtX7maL698AAZI94Fl(3aeyOqN7s3U6eVXZQY0pljtpJ2GGMPVnCdSRYWHHmux16eumSjDUS3wg8L92uhaZUkq5SpQKkjFP7wihV0DZkrShM6IKESO(Vo010J9)jZXX()WqoRLbDpqleHlMhceA5bfNB3W0e3o0lS8Cg2AfcUFdVGIvOudpDUbocPIKoY0WeBb1zYel46e01cUosp55iC9ts4qJpj89P6ntGJKDXoL(bNZFSF5ugFqrffGv4mPf2XHZjQQkjVNpMCgVNpgqOlZwklEZLZO954v(wYmCLVfMHzfgf0FRwSLNTdR6Co8ujEcQbqIslz30mZZzMJk7(mhLSHut3p1j5qrFEWZ1IW8UMjXx)VgMfYi5eJRuPCx5Bt4Kfj4KjRAcMml1wGKZzl)zdZbHXzRPx6SxlzzJcpOjtxTnJnE4hu2vp8dsFFRupLjvpJvPNkPRuHjaz1P4ZQMf9K7(di)4U)avKkTaRn5evqJn18huZvYbptQHSWGcSQjO74NR48mGuNuutL)QF8I1eadvOeRfP5ZbSc3GriSCXixn9tLrM3rr2VdyY71YrAXcBw1sdNbR9ea4MsFCsoRwBIehtc(gqQGRdksAvlCq8tt5bpn28PxMHO6G2vvbseN1(e89DUVkCF)ZDZPdLGkl3CAVumHkYyMqfSkq)DXbfCEyACCvhDCRiH26AwSyqnvel(L82IVwxc4fU)UHcbfFcRtcheG0biiFEQn9SC9ll9v(M1AoV5nqXS6yd9XDOT2uDBr(Y62cTXBIsyN9Xxk24Pu(Tue)sJG51tCKI8MtOztqs(dGHLLo59CUQ425sTfxuJgBCvsCDasDkc1ZcJ19)4txxTPtQ(Hoy(3Pmg0yPsuT606WFk)fzjpL)cHVQ2fQbig78MChj1W2(NzQ(2(NHGvRlFqtOrm0S16KI5ci(8zoF4v1k4if8PEKGMhQU7rYtFzXtraPn1y6KakqjhPUrPmEEPObac8WRXl0(0UlEFFpYYsGJJvPIHXJyCBVHm(B7nQWLJml8coGu10tqu)zMjUYxtXLDAINtN3fwAWADFkLXRO2OEfYg1KAKtkhHXGc6WO1tEqnVhhmb3rlEJq5CwcSQ(eApULGAqYtvkgz6Oix0YS(rMKSiFKjX4Cth416qWJxYXvZHf)mmEiP(OaY(9BoIK9OWJC8PQstKIZP2y6MdCkb77IU6M9aQSyQKR6ILD6QUyQv0SClAvTQj1FIpJSvpXNHWO25sZfHvRY9P80kBbvq0jg1g2D77L1wlx50)uYKp9pf1mkkdynnJY20lXZ2AHk)o3jsrrqA8Akf(1afEJCGfSGGTERqMVKWdazgfV8rXS1OVVxUqRPjozXGlGKoLLaFskk5AlhLp7W0R0JeDbG0Sj(F575vItJJDHcHQ(IF6QmZPZsOUu7CWIm9g2ECj3T0Gwasgswg)zjVx5ZsEVept1MOVMIRK8E(iQy8hH(UUKLlTUCP5Gklb)KasOLa9sq8mIHwaPDtxw(uELmHP(s9df38S(MNLmRV5zr6QnDZfqoCun1ugBBpknypswqiUXXu6SJQePJ2suMZ)1Ad3(RVhAsvNvR2cOnSTRv0gCTvI1tVMABre7LLwJbWkuKyEb(0vudEJcrqleJsgQ7RtzSf9IeSLBHkhO0aBDpONLR9YP5(E2dnlaqQMRTUc3H6c9DqUqFQHDqxJzV6GAU0dXe0bGyYxk5fRZyU2iV2UvMUDZw8HleSotj)QI52Rvdc(APGGJZF1oLCLayuCXJQt0O7M1sKX3RFZsCu9HD7rdPNcJLspfyPSDU0VGSmIAd7a63Fa89RxAAUA2MPLimaK6kUve4FC(qM8EUwLz6A58WBszzoYLGe7YrKj2LdL4hX7ulvUo5bL2AbqUz0YffED8jRnt)K)94xA3ZVC62ceff1jThhGeAtQph76BMYq9ipTRv91zTxiDDcjp7RY83q6zlOcegZQUCtttF8)4LCMIuoG0el3teyrTmSMhQ1oTJIlWHz79e0F5XIksSlx9W6sYv3mVFpVTjbBEEKo8PuB4yTU8cqXOLFcUp6s8K0Y2mPbWzmvYjvIkseGaILLAyCIaw93t(OsFmaiCfGDhhSqcgE17x(PvVFo1AVNc5NCu1I(ONlX8C5bZXHBDSA7wfJNuZj6ts5eDYSpurvRNAEBr493in6nGeFa5aB)b5qabsL64UPcaekERujXLoqo5oppz5355rN(oid1sJWmVW2ZT(XjSNaIth7jD)H34TdCokN75GVo9cnherWMMusynsOncMFwAhewDXwzr6TTv8btV20OshMfAdojkv4PsU3Ji7R9EKWuPg)5KE4aqsOVdxRL75t5lkDJflAc7D8M9K1n7jtYItPQ2xWNyxSA3yKu7hKKFxMPWYUyEY1JmzcYtHLOQqITxPh0aK8sq65QieVLtXs(cAm2wolrF3wiDnH8ynzsz8a(VMuwS7mjMLzeEnD15rcn5YcSKIXK8iQPHJatd3vhuNZBs6k5dxc5sUciftdLNw)S261C81(OsE1FTpkXJ0BGnzpJTwL3Mtgm2CNHUjpd60mMAfoKTFE4uiC7nrlY1PcqiGsQtc9dR(XlwOams133VE5O99RNo3VNoyo(18wI31xZBv54kpzFuVrdkD87vYHfGv4cIqxpe2urtEUbWRL7Fwcc5(Nft2Z6Xj45Y9YLBU9A6RRZqstSci1pgEoLgtgOJ1KCZHaKvTqlTqjJAk7KhudK9GFmQFh4k2UKbT8ud2R7MfS764gPES5zcipkGZvyiOIvyqy3OgYOhlBkr2zI8)i(1OrCCnV97rHeObIJNRsRn)QOAZp93BdV1OL)iLDPdxd)b2)taOJgu2Y3ctrpJAi87FIkr6eJuFqcMwoKJUr6oVj5gsbizYUr3CoWrO5qD)e3gfSl8IRijeDgawHDmQ4i8fjRBFZYHd5fL8dciLZmi7dKjf8p)JpO4XmGKkVAKheTF8y(HANu9dVtkrnrDWG0lfnSTNt0IqD60K6RSFEkh71K869kPiaqUyaXh66u2JRtAP7mdjLulmJ713G4RhGCD2DeDxnbpNyN0p4TtZ3bPKmoX57565ZEFVekT7LszSu1rXLIp(M7KYbgvct5OQmfpiXumziowYMUSc0HDr2bRWKBvhJN5dkJ6z(GuZTrT4DZMfP7naZ794Y9RaqY1FIHLYYRFEjYG6NGKUlaJAE5huLkFW6jrMfA7Y5W44st2RPMlEnGJ2)sHyxEwLrvNb)WspsaiP2sso7iHP7Fj2zjIkvxtEWRu6OkajUNoHGzwtPveHz)0uVrd2xM9)eeDQasglTRTLL2LgGYUUyElrxOwqLqyUHCYNLCxwaKoylUFQhFnDpUCQTv5AgcyLJ7gC1ShDr)Yqr(WR3MKROpG69(aA6OEUJYanR3ylNTQX8SpE1xntPZgQltU6fkZXQxiLactrTWLxecw8MPr1czJNtT86TZ5ztnVh7gLoodqiSq1TKWYH2(3VMRQ9tAlovQfHcC1efys9qapOJPIBhJsh)exm8Cya6oqVmBi26rCILyhMl9lKWRYIqhQPls3EDYxV96inxrfdHBlMS12xSpJ08vaYCZC)uKvgxn9g3lixKvazLT1CX1cVg6jNEjzitVeXdyA7ef8EY9O0K90iTx5YG2Sz09Qm5XKgzaq2AaNQEMjHc3XumuL8ruAYJSqAhaEBlepkzoSAZVDEIzwaRqPaf67X)hi1oXUfoKm30ngLuT6KHcyLO81NEjwzg01MUR7mjSIibdyLy93QRV6Dx9jKK2dion9HdAyqRsc7Ft1r538c5BTTzUahVcG3q2JJEPYEC0lTcNmMQ5RxAMEAqjYj3zBazXPAAusJ3vBf639wjVHLR9(5P6Upps390(BCUBtZfEYlqSAai1QaWZi)I6Td8yZw52Okrm5gzbkYlUZr9Y)VJhv8PPPKGkf5mAKtwG0Z4ZTDFkl1TyxSGJz5ujFNlrwP35sO4F4YkwWYuV)A1N8DeuyY3Hof)oEU1MiWGBIGP0HJta3)hl0R)YqpxNa3Gt4hvpPFuw9179KwtN)wFdZqwKgMr1f5vodzcELZGsVzyBy0O2RW7tnITVeug3yKt6UTZmK5YfzLUAtmb1vBGYVu3(50JY(vKkr(FOqZY)dPugfWnNUELat(CYfZfqQx)SZbZWPB3JaIL1njfNbWkuJiyw1pePkCE(AZejp3gaIXnZoYxG6R0Ssgzk5bHfRACqQUlC78ObKM1O(lqirv9Dj5N0xovFsFkYot66al5apLXP8jLn2P8jzRKK))uGmlcFCyBeSUHK906gIvgg27l1Mq3KhwEizaKm8t9dN4NM2QcFX7ukC7xKUf8Ng1NpMCrJt3fzRMAfuYxS46RrtC61OzQARnYPiG6kQOgRm5LwuwSlLE5pMyKl9vXmn8W89mbaSBAnJJDbCI5SxXeJRvBYGRLLq7Hr)ujn4cPAzoayEgNYenoIuBZ3agT2jgVGskFHXtn6kL5qXcnFqNVuSDaPO507nQLg4vY7vUkEasbclM)kLMlyIW7QUK8kNETTquFHxW84xX)MOt7k(3q8GWEbuDkDv8hsslnGqDsJ9dM2q7QXg5XeJHJ8yqHqNEEAX63K88Lai1ScoblNE(gkfA(6foz9mEYqWkMKcLTRPZB7tGQzKvjYj05W3wk(NhvvVmkPEz281oXmtP5rUJNUx1Md7nPEwpM6TZXyVDy1r8Mo95mFsFKOnAdYbgq2Oe1Cq2UJPftnEu1u9JEoKBC2dqQhKEAi(VuUVPaIFQnlhPliXsolDPPytMuTlnDxA(7eM(bvM(bjvlVfVux)CKV76NdLuTc(qmhUXu1rNepI0QvaYNj9oDhabLQMJnoM6C5XiNlNyn6HjNtKJ9O6gC0zrO)XZZ9DkX(ciR803NUmcKRFs)f6P9b)7kTzpGK6pQNJRjFwtHRllauEJanbglpdEbBrSObiLJzUv)Sc7LVe)kn0YF1DuTx(MOm(TnrsgGUkaWPYa9MyU))o(hbKoGHxCmOOpQmsXTLK5cyfoQl6rLGCkLIVK6f0qQBYd3LQxPlSL7gmvGaVCEl8Gk)2dYfwVrYcOO0HBer(J3R8yXaiWfDuCittFt6NjBQnmlUApaq35dCule6bDYDlLQgqWO3uGVB6sEPPB9GmR74kLFEhxjzlU9Y(EfZ4vaXVTq4MQDw(FJO0nmvUX2aGufW5TNivMI14VNMMZV3zXijpUOHWBDhhpfVxNZ3vQcMdrXN1XN1LWo2QhojbBwmBciNRRHklVylrsjhqRwXb4AhVukzyK6xj3iuAhIAS74J))uOnJ))KmLHzH8TMB4lIxPHnjPKAtuUvMu4BhdTPQwKW1OMGxZzqCtEoGM2EyIrtEyvXZHVmQIc03uLvl5ZQLJ4z)uy2NERzi7c0CZLGMktF2i)VJFbIXFaP7PvgRbceLHjAvU6TaQM08lvSFkh1S9(uX7s62kaJsx(MvoLntpnstUxkvI6ZSIKkkbjUsjVRaIrDg9MNkmKpN3pe7jJh0nl5aEGYmTmLzIEfKOBtMlxuXEcSft47u8mgWiHRnOLuydPjvplq0imvvJWuhR21MH9Zm2SZeT4576LtFDX6xfO7)cROpuiffVnYom51Vw)XrNIoRtH0ZCE8goLOYfqSH(8YW0OehLIs80RU4nI4IY3VtuVOqpShAR2PLLF0jhnXjw8Vvill(3IjU7uXpt5ABbit)SZe6R0Ott)4PrF8htKfUnvwGEd0MsTYc9yMFitiiKk2Blr(cyTnAOEJv(es8RawHFtuYBL1UMUG92K85cyf(Pcq6iIO((MZEapphtE3JaScF1OfFGiRsa1sTjQwEWr1cfpAQOdrIXjLPfqY8a7ifB2zmTR83skofGaTWVQbYlkrYxsEzRaKKnAkWzeTzh6HloaVFvrG4Z69l42z9(jPuE3lY7vFLys(oQZiVZLl2HiLjJ9kzymQ8aAaigYmRs4Np8F1BKbiVyLlxskJNrAXbajM2)i)5ZrJeAoxALOsdm2YWM4eKQ1diTrxKhCz0rVgj5J4sNPIkNjHkVe6VfBM7uO1ZCNYTjBy7H5IM2KPGfFf16WRWrWf6jv4J3w9niC0asjosAXNX0eC7uEAPaKvZvBc2BYrE1em2NMG49LKoY7xw33NUUVVA9Gl69hS(gMMUWtlkILeJtXbJJXbG3mRwby4YR2XBjFvTArV61sYZi(b(kofLzeTV6MLK4dajm1fJLjLUCPQgG0O6wC03xKZfjFgXZgajkLCnwslVCqHsihq)SdWF2zZ)TtsAeraJuE9g6WEJ3hntsy3J55QkLXfPQrVisn6P1hXafQbHVVCJuwRV8bu3HpWPhTKjFvtfryceCyRLs1KophPCYTkntkGuI4ZyPU)WZ37QmfV7SPRnd5VbDNxT6pQsRhq18EG0rlyCdPNfaKOo6nqqI)H6(x(7QtCjaqO5rt75aAhZL8OkR0rjwPz33GML4I77rDoZhgbj6LL7Ie8VXS2gBvZRZwRJzTri801Yok5KjFbP7eaSYXNOMGIsZ82H0UYasDrnHG4B5m)BTlkWaKjq2UvVcPMs)Cvxm5HocqspvvThTynGv4nwO(g0CK0WSJyTs(LL85diPLokEu6z8RA312Wm4(yda62xZfBHcamGErhKCqbyysrRZ5ouf)0Ze3zE8ob1oL8iBt5mm)YxTPd82tViI79Wr1GAp6DEApdxHlwb9iLasFT1Rn(NvW6X)SewpJ(W0WEMYh3Xl81agYQhFi5Ilai8nTJmLt3AwTtWFdrUaqUUgU588G3FHANnEEnXXp)hKipCNWf17jJxtP94p9irQp0RlAH)q0LmEAh3DRyOYq3e5cOXFufR(JKy1uIYdl8)wA8lXms8ls4vbK6U4WmAwTRoQ7TwHq9FRvqPgvUwbY7(jVB2M2MoB7nyZg5GPl43nfH(IZQH2TxjV9acty8f3s49I9MskJaKfolNEjrVKCj7sAjmajdRSJLCV)0FzY(yMOmR2YnktEl3ijetbxAlYhYTkVHlNdCdamnW5ahh(233SFvVu43HJIouzp4z8M00oCtnr5toSAHvtwNXo03gRDq9D)exSF23RRHZwE52aKez42xvQxwn3OQ4NK0)daknYbLS3AFofIpRpSQ)MUIHZO1sKPyh9TxSfBZ8Ei(x2F)eni3xiajEc4JDw7Qf5m8LUcCrLuUPsrU6UDPy7acAWLfqnah9SAWNIhxPTpo3cwnwT)uryas1mB4H4hecaO2Fx79RMT91ohn52K2Eaqw7cD1yHg2bCIE6qA404xTfaWeeEBBRjR21RpoD1pa5NM(87Y1QJ(40CGXaGJZVHh)H(cY4p0xGzhPmjszaJA2OWob)11Bq8Rt3G4jlHRpMlxb8qrFjjNZ)eP4)s5JYV6yYr5xDmovGd6bhDJ6kNg22Zk1Y6zPmm1FTx4QelqTNVaYE(u6DilhlUtI8ChYQm1tfYDkzoQgN58zjKT(iXmw3Jm2T22k7MABLPX)PVI(yW8vUl(ZOmqsOOAFfpnUkT9kVksw6uBZ3oND2J)HWl5HeFebKcZ1JYUnXpAlTDEIhrEtOaKAGfjvgldQZJEPv)YskpbKmaCl8hD6Fh5Jo9Vdv0RW3e2EmLGDmEs5HbdqSVMLCjVtpxQGEwdrveQf4Wr1xtqJdQz)5Gu2FM0sDZ4XDZznImnSg(XQfaGFsYhRTixtFaPl4Bqgek889qCFfrSK8SgxDNm(mjF)i7s0X2l9cd7BThuY3bGuoI9C8ywQUIADQNrO8pdHxOlJynLWS(XRp)nJ)6JuF)T17W13E(v(B9wBmMEM8wvC6TsVVJtL9gI9V598igoIUmJu9A(in7hGexo)IXPAG4w3uITk(RjHJci5PIpj9h9WqM8P0hs2N6hqupllhPvhc8fYXEoFzf2Z5t81uUD10Jtx3QLqLdINL)6pvML)6pLE93476e93JDuPAxasmLqNUBXbuTKvFY(QtQBgGa3ZVt4de4uZJk860qkwhfsXXvr)2IsV06KN3haReE56)1ssDaKkwlFXaQMYkJ1kjshqIxUjEsMM(GBmTRUc9WevYt9qvUc3gBtFzC2gPjKEwUOBin1oRAtg(JL9aGyNotebqbBRms2mOZo928wZdjYvR3bKR(0fpu0CS3Kp1YOIzQ38pRe4)mRATCEHpcXQws73bJvPx3Wv1t1(PO61ml5MLawaSIEtLnEeP2GawHEYsjT8PRsZmEa5vkaqnp4utQPHPVF9ngy))HQPr5j0f4jQ(NUo9pDDe3pv0rF6cmoh5QNXfji6Dy5813s3ZNkb5P2Jh7bGecXaHxhM4NI(65Dk)VKsHLu2)92uej)5AT3)5Fz6QnMVqzOXGTJQVNjBw1rS51fj(Sh9QwVNl6VbZ98dZADY7(MKV8UVjmSurV1lh3JYopJx1MLz8Q2mD)L8lxtjctl2GbKiLQQ)Xuo86NG0ylaY214lt3yJ6i5E0RI2EAa0URGUffe2mILAZ69nEZuJ5DQu3ntU8swIHyVQeV(e)JYYK4FKTvf4mqG)C7uFnlPNXhvSRDvSRDY(4xJ)BhvtX0rPumDQvF6FRn78jFA1RUNgwIUlQTb6nZGwcLm5ZkpwdasYYlYkGVMaK3CzGEHUg6JLk5g17O6gxlhyfcPYXk8zMmMP8QybifRTNpLRBOqWvlbPrMpR43CgYaBTV3UDzMRa38pPVgLoCneVuR5PlQq2JRVe(CxHmMp3vuH6lHOCGWZhLV6SwIhSX)71h5K)(MPl7lNoBqq44BPFVUFJ8qsdyLAEbCQEDs2Q08MawTTAR5DrOUf9kY3VOxHUO0uUfO7JpJkQ7hkf5PUFi05sxyR2o3ugxG(E1Eb5zfyS6REgSCPbL7PqI5PK(5r00)tElSD91kB7Bccg)u8Nwf9F3kws5cwB0eKh2tuQtV()9!BBF"
        local profileData, errorMessage = BBF.OldImportProfile(importString, "auraBlacklist")
        if errorMessage then
            BBF.Print(L["Print_Error_Importing_Blacklist"] .. " " .. tostring(errorMessage))
            return
        end
        BBF.DeepMergeTables(BetterBlizzFramesDB.auraBlacklist, profileData)
        BBF.auraBlacklistRefresh()
        Settings.OpenToCategory(BBF.category:GetID(), BBF.aurasSubCategory)
    end,
    timeout = 0,
    whileDead = true,
}

------------------------------------------------------------
-- GUI Creation Functions
------------------------------------------------------------
local function CheckAndToggleCheckboxes(frame, alpha)
    for i = 1, frame:GetNumChildren() do
        local child = select(i, frame:GetChildren())
        if child and (child:GetObjectType() == "CheckButton" or child:GetObjectType() == "Slider" or child:GetObjectType() == "Button") then
            if frame:GetChecked() then
                child:Enable()
                child:SetAlpha(1)
            else
                child:Disable()
                child:SetAlpha(alpha or 0.5)
            end
        end

        -- Check if the child has children and if it's a CheckButton or Slider
        for j = 1, child:GetNumChildren() do
            local childOfChild = select(j, child:GetChildren())
            if childOfChild and (childOfChild:GetObjectType() == "CheckButton" or childOfChild:GetObjectType() == "Slider" or childOfChild:GetObjectType() == "Button") then
                if child.GetChecked and child:GetChecked() and frame.GetChecked and frame:GetChecked() then
                    childOfChild:Enable()
                    childOfChild:SetAlpha(1)
                else
                    childOfChild:Disable()
                    childOfChild:SetAlpha(0.5)
                end
            end
        end
    end
end

local function DisableElement(element)
    element:Disable()
    element:SetAlpha(0.5)
end

local function EnableElement(element)
    element:Enable()
    element:SetAlpha(1)
end

local function CreateBorderBox(anchor)
    local contentFrame = anchor:GetParent()
    local texture = contentFrame:CreateTexture(nil, "BACKGROUND")
    texture:SetAtlas("UI-Frame-Neutral-PortraitWiderDisable")
    texture:SetDesaturated(true)
    texture:SetRotation(math.rad(90))
    texture:SetSize(295, 163)
    texture:SetPoint("CENTER", anchor, "CENTER", 0, -95)
    return texture
end

local function FormatClassName(classTag)
    local classMap = {
        DEATHKNIGHT = L["Class_Death_Knight"],
        DEMONHUNTER = L["Class_Demon_Hunter"],
        DRUID = L["Class_Druid"],
        EVOKER = L["Class_Evoker"],
        HUNTER = L["Class_Hunter"],
        MAGE = L["Class_Mage"],
        MONK = L["Class_Monk"],
        PALADIN = L["Class_Paladin"],
        PRIEST = L["Class_Priest"],
        ROGUE = L["Class_Rogue"],
        SHAMAN = L["Class_Shaman"],
        WARLOCK = L["Class_Warlock"],
        WARRIOR = L["Class_Warrior"],
    }

    return classMap[classTag] or (classTag:sub(1, 1):upper() .. classTag:sub(2):lower())
end

--[[
-- dark grey with dark bg
border:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
    edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
    tile = true,
    tileEdge = true,
    tileSize = 12,
    edgeSize = 12,
    insets = { left = 5, right = 5, top = 9, bottom = 9 },
})

]]

--[[
-- clean dark fancy
border:SetBackdrop({
    bgFile = "Interface\\FriendsFrame\\UI-Toast-Background",
    edgeFile = "Interface\\FriendsFrame\\UI-Toast-Border",
    tile = true,
    tileEdge = true,
    tileSize = 12,
    edgeSize = 12,
    insets = { left = 5, right = 5, top = 5, bottom = 5 },
})

]]

-- Function to update the icon texture
local function UpdateIconTexture(editBox, textureFrame)
    local iconID = tonumber(editBox:GetText())
    if iconID then
        textureFrame:SetTexture(iconID)
    end
end

local function CreateIconChangeWindow()
    local window = CreateFrame("Frame", "IconChangeWindow", UIParent, "BasicFrameTemplateWithInset")
    window:SetSize(300, 180)  -- Adjust size as needed
    window:SetPoint("CENTER")
    window:SetFrameStrata("HIGH")

    -- Make the frame movable
    window:SetMovable(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop", window.StopMovingOrSizing)
    window:Hide()

    -- Edit box
    local editBox = CreateFrame("EditBox", nil, window, "InputBoxTemplate")
    editBox:SetSize(150, 20)
    editBox:SetPoint("CENTER", window, "CENTER", 20, 10)

    -- Text above the icon
    local text = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("BOTTOM", editBox, "TOP", -10, 15)
    text:SetText(L["Enter_New_Icon_ID"])

    -- Icon texture frame
    local textureFrame = window:CreateTexture(nil, "ARTWORK")
    textureFrame:SetSize(50, 50)  -- Enlarged icon
    textureFrame:SetPoint("RIGHT", editBox, "LEFT", -10, 0)
    textureFrame:SetTexture(BetterBlizzFramesDB.auraToggleIconTexture)

    -- Text for finding icon IDs
    local findIconText = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    findIconText:SetPoint("CENTER", window, "CENTER", 0, -40)
    findIconText:SetText(L["Find_Icon_IDs"])

    -- OK button
    local okButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    okButton:SetSize(60, 20)
    okButton:SetPoint("BOTTOM", window, "BOTTOM", 30, 10)
    okButton:SetText(L["Yes"])
    okButton:SetScript("OnClick", function()
        local newIconID = tonumber(editBox:GetText())
        if newIconID then
            BetterBlizzFramesDB.auraToggleIconTexture = newIconID
            if ToggleHiddenAurasButton then
                ToggleHiddenAurasButton.Icon:SetTexture(newIconID)
            end
        end
        window:Hide()
    end)

    local resetButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    resetButton:SetSize(60, 20)
    resetButton:SetPoint("BOTTOM", window, "BOTTOM", -30, 10)
    resetButton:SetText(L["Default"])
    resetButton:SetScript("OnClick", function()
        BetterBlizzFramesDB.auraToggleIconTexture = 134430
        if ToggleHiddenAurasButton then
            ToggleHiddenAurasButton.Icon:SetTexture(134430)
        end
        textureFrame:SetTexture(134430)
        editBox:SetText(134430)
    end)

    editBox:SetScript("OnTextChanged", function()
        UpdateIconTexture(editBox, textureFrame)
    end)

    editBox:SetScript("OnEnterPressed", function()
        local newIconID = tonumber(editBox:GetText())
        if newIconID then
            BetterBlizzFramesDB.auraToggleIconTexture = newIconID
            if ToggleHiddenAurasButton then
                ToggleHiddenAurasButton.Icon:SetTexture(newIconID)
            end
        end
        window:Hide()
    end)

    editBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
        window:Hide()
    end)

    window.editBox = editBox
    return window
end



local function CreateBorderedFrame(point, width, height, xPos, yPos, parent)
    local border = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    border:SetBackdrop({
        bgFile = "Interface\\FriendsFrame\\UI-Toast-Background",
        edgeFile = "Interface\\FriendsFrame\\UI-Toast-Border",
        tile = true,
        tileEdge = true,
        tileSize = 10,
        edgeSize = 10,
        insets = { left = 5, right = 5, top = 5, bottom = 5 },
    })
    border:SetBackdropColor(1, 1, 1, 0.4)
    border:SetFrameLevel(1)
    border:SetSize(width, height)
    border:SetPoint("CENTER", point, "CENTER", xPos, yPos)

    return border
end

local function CreateSlider(parent, label, minValue, maxValue, stepValue, element, axis, sliderWidth)
    local sliderFrame = CreateFrame("Frame", nil, parent, "MinimalSliderWithSteppersTemplate")
    local slider = sliderFrame.Slider or sliderFrame

    -- Reference and configure the draggable thumb texture
    local thumbTexture = slider.GetThumbTexture and slider:GetThumbTexture()
    if thumbTexture then
        thumbTexture:SetDrawLayer("OVERLAY")
    end

    slider:SetOrientation('HORIZONTAL')
    slider:SetMinMaxValues(minValue, maxValue)
    slider:SetValueStep(stepValue)
    slider:SetObeyStepOnDrag(true)

    if not slider.Text then
        slider.Text = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        slider.Text:SetPoint("BOTTOM", slider, "TOP", 0, 3)
    end
    slider.Text:SetFontObject(GameFontHighlightSmall)
    slider.Text:SetTextColor(1, 0.81, 0, 1)

    if slider.Low then slider.Low:SetText(" ") end
    if slider.High then slider.High:SetText(" ") end



    local category
    if parent.name then
        category = parent.name
    elseif parent:GetParent() and parent:GetParent().name then
        category = parent:GetParent().name
    elseif parent:GetParent() and parent:GetParent():GetParent() and parent:GetParent():GetParent().name then
        category = parent:GetParent():GetParent().name
    end

    if category == "Better|cff00c0ffBlizz|rFrames |A:gmchat-icon-blizz:16:16|a" then
        category = L["Search_Name_General"]
    end

    slider.searchCategory = category

    table.insert(sliderList, {
        slider = slider,
        label = label,
        element = element
    })

    if sliderWidth then
        slider:SetWidth(sliderWidth)
    end

    local function UpdateSliderRange(newValue, minValue, maxValue)
        newValue = tonumber(newValue) -- Convert newValue to a number

        if (axis == "X" or axis == "Y") and (newValue < minValue or newValue > maxValue) then
            -- For X or Y axis: extend the range by ±30
            local newMinValue = math.min(newValue - 30, minValue)
            local newMaxValue = math.max(newValue + 30, maxValue)
            slider:SetMinMaxValues(newMinValue, newMaxValue)
        elseif newValue < minValue or newValue > maxValue then
            -- For other sliders: adjust the range, ensuring it never goes below a specified minimum (e.g., 0)
            local nonAxisRangeExtension = 2
            local newMinValue = math.max(newValue - nonAxisRangeExtension, 0.1)  -- Prevent going below 0.1
            local newMaxValue = math.max(newValue + nonAxisRangeExtension, maxValue)
            slider:SetMinMaxValues(newMinValue, newMaxValue)
        end
    end

    local function SetSliderValue()
        if BBF.variablesLoaded then
            local initialValue = tonumber(BetterBlizzFramesDB[element]) or 1 -- Convert to number

            if initialValue then
                local currentMin, currentMax = slider:GetMinMaxValues() -- Fetch the latest min and max values

                -- Check if the initial value is outside the current range and update range if necessary
                UpdateSliderRange(initialValue, currentMin, currentMax)

                slider:SetValue(initialValue) -- Set the initial value
                local textValue = initialValue % 1 == 0 and tostring(math.floor(initialValue)) or string.format("%.2f", initialValue)
                slider.Text:SetText(label ~= "" and (label .. ": " .. textValue) or textValue)
            end
        else
            C_Timer.After(0.1, SetSliderValue)
        end
    end

    SetSliderValue()

    if parent and parent:GetObjectType() == "CheckButton" then
        slider.parentCheckButton = parent
        parent.childrenCheckButtons = parent.childrenCheckButtons or {}
        table.insert(parent.childrenCheckButtons, slider)
    end

    local function UpdateEnabledState()
        local parentCB = slider.parentCheckButton
        local isParentDisabled = false
        if parentCB then
            if not parentCB:GetChecked() or not parentCB:IsEnabled() then
                isParentDisabled = true
            end
        end

        if isParentDisabled then
            slider:Disable()
            slider:SetAlpha(0.5)
            if slider.associatedTitle then
                slider.associatedTitle:SetFontObject("GameFontDisableSmall")
            end
            if slider.associatedRow then
                slider.associatedRow:SetAlpha(0.5)
            end
        else
            slider:Enable()
            slider:SetAlpha(1)
            if slider.associatedTitle then
                slider.associatedTitle:SetFontObject("GameFontHighlightSmall")
            end
            if slider.associatedRow then
                slider.associatedRow:SetAlpha(1)
            end
        end
    end

    slider.UpdateEnabledState = UpdateEnabledState
    UpdateEnabledState()

    -- Create Input Box on Right Click
    local editBox = CreateFrame("EditBox", nil, slider, "InputBoxTemplate")
    editBox:SetAutoFocus(false)
    editBox:SetWidth(50) -- Set the width of the EditBox
    editBox:SetHeight(20) -- Set the height of the EditBox
    editBox:SetMultiLine(false)
    editBox:SetPoint("CENTER", slider, "CENTER", 0, 0) -- Position it to the right of the slider
    editBox:SetFrameStrata("DIALOG") -- Ensure it appears above other UI elements
    editBox:Hide()
    editBox:SetFontObject(GameFontHighlightSmall)

    -- Function to handle the entered value and update the slider
    local function HandleEditBoxInput()
        local inputValue = tonumber(editBox:GetText())
        if inputValue then
            -- Check if it's a non-axis slider and inputValue is <= 0
            if (axis ~= "X" and axis ~= "Y") and inputValue <= 0 then
                inputValue = 0.1  -- Set to minimum allowed value for non-axis sliders
            end
            if slider.integerOnly then
                inputValue = math.max(1, math.floor(inputValue))
            end

            local currentMin, currentMax = slider:GetMinMaxValues()
            if inputValue < currentMin or inputValue > currentMax then
                UpdateSliderRange(inputValue, currentMin, currentMax)
            end

            slider:SetValue(inputValue)
            BetterBlizzFramesDB[element] = inputValue
        end
        editBox:Hide()
    end


    editBox:SetScript("OnEnterPressed", HandleEditBoxInput)

    slider:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            editBox:Show()
            editBox:SetFocus()
        end
    end)

    slider:SetScript("OnMouseWheel", function(slider, delta)
        if IsShiftKeyDown() then
            local currentVal = slider:GetValue()
            if delta > 0 then
                slider:SetValue(currentVal + stepValue)
            else
                slider:SetValue(currentVal - stepValue)
            end
        end
    end)

    slider:SetScript("OnValueChanged", function(self, value)
        if not BetterBlizzFramesDB.wasOnLoadingScreen then
            local textValue = value % 1 == 0 and tostring(math.floor(value)) or string.format("%.2f", value)
            self.Text:SetText(label ~= "" and (label .. ": " .. textValue) or textValue)
            --if not BBF.checkCombatAndWarn() then
                -- Update the X or Y position based on the axis
                if axis == "X" then
                    BetterBlizzFramesDB[element .. "XPos"] = value
                elseif axis == "Y" then
                    BetterBlizzFramesDB[element .. "YPos"] = value
                elseif axis == "Alpha" then
                    BetterBlizzFramesDB[element .. "Alpha"] = value
                elseif axis == "Height" then
                    BetterBlizzFramesDB[element .. "Height"] = value
                end

                if not axis then
                    BetterBlizzFramesDB[element .. "Scale"] = value
                end

                local xPos = BetterBlizzFramesDB[element .. "XPos"] or 0
                local yPos = BetterBlizzFramesDB[element .. "YPos"] or 0
                local anchorPoint = BetterBlizzFramesDB[element .. "Anchor"] or "CENTER"

                --If no frames are present still adjust values
                if element == "targetToTXPos" then
                    BetterBlizzFramesDB.targetToTXPos = value
                    if not BBF.checkCombatAndWarn() then
                        BBF.MoveToTFrames()
                    end
                elseif element == "targetToTYPos" then
                    BetterBlizzFramesDB.targetToTYPos = value
                    if not BBF.checkCombatAndWarn() then
                        BBF.MoveToTFrames()
                    end
                elseif element == "targetToTScale" then
                    BetterBlizzFramesDB.targetToTScale = value
                    if not BBF.checkCombatAndWarn() then
                        BBF.MoveToTFrames()
                    end
                elseif element == "focusToTScale" then
                    BetterBlizzFramesDB.focusToTScale = value
                    if not BBF.checkCombatAndWarn() then
                        BBF.MoveToTFrames()
                    end
                elseif element == "focusToTXPos" then
                    BetterBlizzFramesDB.focusToTXPos = value
                    if not BBF.checkCombatAndWarn() then
                        BBF.MoveToTFrames()
                    end
                elseif element == "focusToTYPos" then
                    BetterBlizzFramesDB.focusToTYPos = value
                    if not BBF.checkCombatAndWarn() then
                        BBF.MoveToTFrames()
                    end
                elseif element == "partyFrameScale" then
                    BetterBlizzFramesDB.partyFrameScale = value
                    BBF.CompactPartyFrameScale()
                elseif element == "partyFrameRangeAlpha" then
                    BetterBlizzFramesDB.partyFrameRangeAlpha = value
                    BBF.HookAndUpdatePartyFrameRangeAlpha(true)
                elseif element == "darkModeColor" then
                    BetterBlizzFramesDB.darkModeColor = value
                    if not BBF.checkCombatAndWarn() then
                        BBF.DarkmodeFrames()
                    end
                elseif element == "lossOfControlScale" then
                    BetterBlizzFramesDB.lossOfControlScale = value
                    BBF.ToggleLossOfControlTestMode()
                    BBF.ChangeLossOfControlScale()
                elseif element == "targetAndFocusAuraOffsetX" then
                    BetterBlizzFramesDB.targetAndFocusAuraOffsetX = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "targetAndFocusAuraOffsetY" then
                    BetterBlizzFramesDB.targetAndFocusAuraOffsetY = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "targetAndFocusAuraScale" then
                    BetterBlizzFramesDB.targetAndFocusAuraScale = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "targetAndFocusHorizontalGap" then
                    BetterBlizzFramesDB.targetAndFocusHorizontalGap = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "targetAndFocusVerticalGap" then
                    BetterBlizzFramesDB.targetAndFocusVerticalGap = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "selfAuraPurgeGlowAlpha" then
                    BetterBlizzFramesDB.selfAuraPurgeGlowAlpha = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "targetAndFocusAurasPerRow" then
                    BetterBlizzFramesDB.targetAndFocusAurasPerRow = value
                    BBF.RefreshAllAuraFrames()
                    --
                elseif element == "combatIndicatorScale" then
                    BetterBlizzFramesDB.combatIndicatorScale = value
                    BBF.CombatIndicatorCaller()
                elseif element == "combatIndicatorXPos" then
                    BetterBlizzFramesDB.combatIndicatorXPos = value
                    BBF.CombatIndicatorCaller()
                elseif element == "combatIndicatorYPos" then
                    BetterBlizzFramesDB.combatIndicatorYPos = value
                    BBF.CombatIndicatorCaller()
                elseif element == "healerIndicatorScale" then
                    BetterBlizzFramesDB.healerIndicatorScale = value
                    BBF.HealerIndicatorCaller()
                elseif element == "healerIndicatorXPos" then
                    BetterBlizzFramesDB.healerIndicatorXPos = value
                    BBF.HealerIndicatorCaller()
                elseif element == "healerIndicatorYPos" then
                    BetterBlizzFramesDB.healerIndicatorYPos = value
                    BBF.HealerIndicatorCaller()
                elseif element == "absorbIndicatorScale" then
                    BetterBlizzFramesDB.absorbIndicatorScale = value
                    BBF.AbsorbCaller()
                elseif element == "playerAbsorbXPos" then
                    BetterBlizzFramesDB.playerAbsorbXPos = value
                    BBF.AbsorbCaller()
                elseif element == "playerAbsorbYPos" then
                    BetterBlizzFramesDB.playerAbsorbYPos = value
                    BBF.AbsorbCaller()
                elseif element == "targetAbsorbXPos" then
                    BetterBlizzFramesDB.targetAbsorbXPos = value
                    BBF.AbsorbCaller()
                elseif element == "targetAbsorbYPos" then
                    BetterBlizzFramesDB.targetAbsorbYPos = value
                    BBF.AbsorbCaller()
                elseif element == "partyCastBarScale" then
                    BetterBlizzFramesDB.partyCastBarScale = value
                    BBF.UpdateCastbars()
                elseif element == "partyCastBarXPos" then
                    BetterBlizzFramesDB.partyCastBarXPos = value
                    BBF.UpdateCastbars()
                elseif element == "partyCastBarYPos" then
                    BetterBlizzFramesDB.partyCastBarYPos = value
                    BBF.UpdateCastbars()
                elseif element == "partyCastbarIconXPos" then
                    BetterBlizzFramesDB.partyCastbarIconXPos = value
                    BBF.UpdateCastbars()
                elseif element == "partyCastbarIconYPos" then
                    BetterBlizzFramesDB.partyCastbarIconYPos = value
                    BBF.UpdateCastbars()
                elseif element == "partyCastBarWidth" then
                    BetterBlizzFramesDB.partyCastBarWidth = value
                    BBF.UpdateCastbars()
                elseif element == "partyCastBarHeight" then
                    BetterBlizzFramesDB.partyCastBarHeight = value
                    BBF.UpdateCastbars()
                elseif element == "partyCastBarIconScale" then
                    BetterBlizzFramesDB.partyCastBarIconScale = value
                    BBF.UpdateCastbars()
                elseif element == "targetCastBarScale" then
                    BetterBlizzFramesDB.targetCastBarScale = value
                    BBF.ChangeCastbarSizes()
                elseif element == "targetCastBarXPos" then
                    BetterBlizzFramesDB.targetCastBarXPos = value
                    BBF.CastbarAdjustCaller()
                elseif element == "targetCastBarYPos" then
                    BetterBlizzFramesDB.targetCastBarYPos = value
                    BBF.CastbarAdjustCaller()
                elseif element == "targetCastBarWidth" then
                    BetterBlizzFramesDB.targetCastBarWidth = value
                    BBF.ChangeCastbarSizes()
                elseif element == "targetCastBarHeight" then
                    BetterBlizzFramesDB.targetCastBarHeight = value
                    BBF.ChangeCastbarSizes()
                elseif element == "targetCastBarIconScale" then
                    BetterBlizzFramesDB.targetCastBarIconScale = value
                    BBF.ChangeCastbarSizes()
                elseif element == "targetCastbarIconXPos" then
                    BetterBlizzFramesDB.targetCastbarIconXPos = value
                    BBF.ChangeCastbarSizes()
                elseif element == "targetCastbarIconYPos" then
                    BetterBlizzFramesDB.targetCastbarIconYPos = value
                    BBF.ChangeCastbarSizes()
                elseif element == "focusCastBarScale" then
                    BetterBlizzFramesDB.focusCastBarScale = value
                    BBF.ChangeCastbarSizes()
                elseif element == "focusCastBarXPos" then
                    BetterBlizzFramesDB.focusCastBarXPos = value
                    BBF.CastbarAdjustCaller()
                elseif element == "focusCastBarYPos" then
                    BetterBlizzFramesDB.focusCastBarYPos = value
                    BBF.CastbarAdjustCaller()
                elseif element == "focusCastBarWidth" then
                    BetterBlizzFramesDB.focusCastBarWidth = value
                    BBF.ChangeCastbarSizes()
                elseif element == "focusCastBarHeight" then
                    BetterBlizzFramesDB.focusCastBarHeight = value
                    BBF.ChangeCastbarSizes()
                elseif element == "focusCastBarIconScale" then
                    BetterBlizzFramesDB.focusCastBarIconScale = value
                    BBF.ChangeCastbarSizes()
                elseif element == "playerCastBarScale" then
                    BetterBlizzFramesDB.playerCastBarScale = value
                    BBF.ChangeCastbarSizes()
                elseif element == "focusCastbarIconXPos" then
                    BetterBlizzFramesDB.focusCastbarIconXPos = value
                    BBF.ChangeCastbarSizes()
                elseif element == "focusCastbarIconYPos" then
                    BetterBlizzFramesDB.focusCastbarIconYPos = value
                    BBF.ChangeCastbarSizes()
                elseif element == "playerCastBarIconScale" then
                    BetterBlizzFramesDB.playerCastBarIconScale = value
                    BBF.ChangeCastbarSizes()
                elseif element == "playerCastbarIconXPos" then
                    BetterBlizzFramesDB.playerCastbarIconXPos = value
                    BBF.ChangeCastbarSizes()
                elseif element == "playerCastbarIconYPos" then
                    BetterBlizzFramesDB.playerCastbarIconYPos = value
                    BBF.ChangeCastbarSizes()
                elseif element == "playerCastBarWidth" then
                    BetterBlizzFramesDB.playerCastBarWidth = value
                    BBF.ChangeCastbarSizes()
                elseif element == "playerCastBarHeight" then
                    BetterBlizzFramesDB.playerCastBarHeight = value
                    BBF.ChangeCastbarSizes()
                elseif element == "maxTargetBuffs" then
                    BetterBlizzFramesDB.maxTargetBuffs = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "maxTargetDebuffs" then
                    BetterBlizzFramesDB.maxTargetDebuffs = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "maxTargetFocusBuffs" then
                    BetterBlizzFramesDB.maxTargetFocusBuffs = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "maxTargetFocusDebuffs" then
                    BetterBlizzFramesDB.maxTargetFocusDebuffs = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "maxBuffFrameBuffs" then
                    BetterBlizzFramesDB.maxBuffFrameBuffs = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "maxBuffFrameDebuffs" then
                    BetterBlizzFramesDB.maxBuffFrameDebuffs = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "petCastBarScale" then
                    BetterBlizzFramesDB.petCastBarScale = value
                    BBF.UpdatePetCastbar()
                elseif element == "petCastBarXPos" then
                    BetterBlizzFramesDB.petCastBarXPos = value
                    BBF.UpdatePetCastbar()
                elseif element == "petCastBarYPos" then
                    BetterBlizzFramesDB.petCastBarYPos = value
                    BBF.UpdatePetCastbar()
                elseif element == "petCastBarWidth" then
                    BetterBlizzFramesDB.petCastBarWidth = value
                    BBF.UpdatePetCastbar()
                elseif element == "petCastBarHeight" then
                    BetterBlizzFramesDB.petCastBarHeight = value
                    BBF.UpdatePetCastbar()
                elseif element == "petCastBarIconScale" then
                    BetterBlizzFramesDB.petCastBarIconScale = value
                    BBF.UpdatePetCastbar()
                elseif element == "playerAuraMaxBuffsPerRow" then
                    BetterBlizzFramesDB.playerAuraMaxBuffsPerRow = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "playerAuraSpacingX" then
                    BetterBlizzFramesDB.playerAuraSpacingX = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "playerAuraSpacingY" then
                    BetterBlizzFramesDB.playerAuraSpacingY = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "auraTypeGap" then
                    BetterBlizzFramesDB.auraTypeGap = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "auraStackSize" then
                    BetterBlizzFramesDB.auraStackSize = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "auraCdTextSize" then
                    BetterBlizzFramesDB.auraCdTextSize = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "targetAndFocusSmallAuraScale" then
                    BetterBlizzFramesDB.targetAndFocusSmallAuraScale = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "enlargedAuraSize" then
                    BetterBlizzFramesDB.enlargedAuraSize = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "compactedAuraSize" then
                    BetterBlizzFramesDB.compactedAuraSize = value
                    BBF.RefreshAllAuraFrames()
                elseif element == "racialIndicatorScale" then
                    BetterBlizzFramesDB.racialIndicatorScale = value
                    BBF.RacialIndicatorCaller()
                elseif element == "racialIndicatorXPos" then
                    BetterBlizzFramesDB.racialIndicatorXPos = value
                    BBF.RacialIndicatorCaller()
                elseif element == "racialIndicatorYPos" then
                    BetterBlizzFramesDB.racialIndicatorYPos = value
                    BBF.RacialIndicatorCaller()
                elseif element == "targetToTAdjustmentOffsetY" then
                    BetterBlizzFramesDB.targetToTAdjustmentOffsetY = value
                    BBF.CastbarAdjustCaller()
                elseif element == "focusToTAdjustmentOffsetY" then
                    BetterBlizzFramesDB.focusToTAdjustmentOffsetY = value
                    BBF.CastbarAdjustCaller()
                elseif element == "castBarInterruptIconScale" then
                    BetterBlizzFramesDB.castBarInterruptIconScale = value
                    BBF.UpdateInterruptIconSettings()
                elseif element == "castBarInterruptIconXPos" then
                    BetterBlizzFramesDB.castBarInterruptIconXPos = value
                    BBF.UpdateInterruptIconSettings()
                elseif element == "castBarInterruptIconYPos" then
                    BetterBlizzFramesDB.castBarInterruptIconYPos = value
                    BBF.UpdateInterruptIconSettings()
                elseif element == "kickPopupScale" then
                    BetterBlizzFramesDB.kickPopupScale = value
                    BBF.UpdateKickPopupSettings()
                elseif element == "kickPopupIconScale" then
                    BetterBlizzFramesDB.kickPopupIconScale = value
                    BBF.UpdateKickPopupSettings()
                elseif element == "kickPopupXPos" then
                    BetterBlizzFramesDB.kickPopupXPos = value
                    BBF.UpdateKickPopupSettings()
                elseif element == "kickPopupYPos" then
                    BetterBlizzFramesDB.kickPopupYPos = value
                    BBF.UpdateKickPopupSettings()
                elseif element == "uiWidgetPowerBarScale" then
                    BetterBlizzFramesDB.uiWidgetPowerBarScale = value
                    BBF.ResizeUIWidgetPowerBarFrame()
                elseif element == "actionBarCDNumberScale" then
                    BetterBlizzFramesDB.actionBarCDNumberScale = value
                    BBF.ActionBarCDNumberSize()
                elseif element == playerClassResourceScale then
                    BetterBlizzFramesDB[playerClassResourceScale] = value
                    BBF.UpdateClassComboPoints()
                    --end
                elseif element == "legacyComboScale" or element == "legacyComboXPos" or element == "legacyComboYPos" then
                    BetterBlizzFramesDB[element] = value
                    if BBF.UpdateLegacyComboPosition then
                        BBF.UpdateLegacyComboPosition()
                    end
                end
            end
        end)

    return slider
end

local function CreateTooltip(widget, tooltipText, anchor)
    widget.tooltipTitle = tooltipText
    widget:SetScript("OnEnter", function(self)
        if GameTooltip:IsShown() then
            GameTooltip:Hide()
        end

        if anchor then
            GameTooltip:SetOwner(self, anchor)
        else
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        end
        GameTooltip:SetText(tooltipText)

        GameTooltip:Show()
    end)

    widget:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end

local function CreateTooltipTwo(widget, title, mainText, subText, anchor, cvarName, cpuUsage, category)
    widget.tooltipTitle = title
    widget.tooltipMainText = mainText
    widget.tooltipSubText = subText
    widget.tooltipCVarName = cvarName
    widget:HookScript("OnEnter", function(self)
        -- Clear the tooltip before showing new information
        GameTooltip:ClearLines()
        if GameTooltip:IsShown() then
            GameTooltip:Hide()
        end
        if anchor then
            GameTooltip:SetOwner(self, anchor)
        else
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        end
        -- Set the bold title
        GameTooltip:AddLine(title)
        --GameTooltip:AddLine(" ") -- Adding an empty line as a separator
        local formattedMainText = mainText
        if (title == L["Show_Spec_Name"] or title == L["Tooltip_Show_Spec_Name"]) and mainText and string.find(mainText, "%%s") then
            local partySpecStatus = BetterBlizzFramesDB.partyArenaNames and (L["On"] or "ON") or "OFF"
            local checkMark = BetterBlizzFramesDB.partyArenaNames and " |A:ParagonReputation_Checkmark:15:15|a" or ""
            formattedMainText = string.format(mainText, partySpecStatus .. checkMark)
        elseif (title == L["Show_Elite_Texture"] or title == L["Elite_Texture"]) and mainText and string.find(mainText, "%%d") then
            local textures = BetterBlizzFramesDB.classicFrames and 7 or 4
            local currentMode = BetterBlizzFramesDB.playerEliteFrameMode or 1
            local activeStr = string.format(L["Active_Texture_Status"] or "Active: %d/%d", currentMode, textures)
            formattedMainText = string.format(mainText, textures) .. " |cff32f795" .. activeStr .. "|r"
        end
        GameTooltip:AddLine(formattedMainText, 1, 1, 1, true) -- true for wrap text

        if title == L["Format_Numbers"] then
            local tooltipText = "\n\n18800 K |A:glueannouncementpopup-arrow:20:20|a 18.8 M\n|cff32f795" .. L["Right_Click_Show_Extra_Decimal"] .. "|r"
            if BetterBlizzFramesDB.formatStatusBarTextExtraDecimals then
                tooltipText = "\n\n18800 K |A:glueannouncementpopup-arrow:20:20|a 18.80 M\n|cff32f795" .. L["Right_Click_Show_Extra_Decimal"] .. "|r|A:ParagonReputation_Checkmark:15:15|a"
            end
            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end

        if title == L["Tooltip_Class_Color_Healthbars_Title"] or title == L["Class_Color_Health"] then
            local green = "|cff32f795"
            local babyBlue = "|cff7fc6ff"
            local reset = "|r"
            local check = " |A:ParagonReputation_Checkmark:15:15|a"

            local strPlayer = L["Ctrl_Right_Click_Keep_PlayerFrame_Green"] or "Ctrl+Right-Click to keep PlayerFrame green."
            local strFriendly = L["Shift_Right_Click_Keep_Friendly_Units_Green"] or "Shift+Right-Click to keep Friendly units green."

            local tooltipText = "\n"
            tooltipText = tooltipText .. green .. strPlayer .. reset
            if BetterBlizzFramesDB.classColorFramesSkipPlayer then
                tooltipText = tooltipText .. check
            end

            tooltipText = tooltipText .. "\n\n" .. babyBlue .. strFriendly .. reset
            if BetterBlizzFramesDB.classColorFramesSkipFriendly then
                tooltipText = tooltipText .. check
            end

            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end

        if title == L["Custom_Colors"] or title == L["Custom_Color_Health_Mana"] then
            local yellow = "|cffffff00"
            local green = "|cff32f795"
            local babyBlue = "|cff7fc6ff"
            local reset = "|r"
            local check = " |A:ParagonReputation_Checkmark:15:15|a"

            local strPlayer = L["Ctrl_Right_Click_Keep_PlayerFrame_Green"] or "Ctrl+Right-Click to keep PlayerFrame green."
            local strFriendly = L["Shift_Right_Click_Keep_Friendly_Units_Green"] or "Shift+Right-Click to keep Friendly units green."

            local tooltipText = "\n" .. yellow .. L["Right_Click_To_Open_Options"] .. reset
            tooltipText = tooltipText .. "\n\n" .. green .. strPlayer .. reset
            if BetterBlizzFramesDB.classColorFramesSkipPlayer then
                tooltipText = tooltipText .. check
            end

            tooltipText = tooltipText .. "\n\n" .. babyBlue .. strFriendly .. reset
            if BetterBlizzFramesDB.classColorFramesSkipFriendly then
                tooltipText = tooltipText .. check
            end

            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end

        if title == L["Hide_Dispel_Overlay"] then
            local green = "|cff32f795"
            local babyBlue = "|cff7fc6ff"
            local reset = "|r"
            local check = " |A:ParagonReputation_Checkmark:15:15|a"

            local tooltipText = "\n"
            tooltipText = tooltipText .. green .. L["Right_Click_Keep_Dispel_Border"] .. " |A:RaidFrame-DispelHighlight:15:30|a" .. reset
            if BetterBlizzFramesDB.hidePartyDispelOverlayKeepBorder then
                tooltipText = tooltipText .. check
            end

            tooltipText = tooltipText .. "\n\n" .. babyBlue .. L["Shift_Right_Click_Keep_Dispel_Gradient"] .. " |A:_RaidFrame-Dispel-Highlight-Horizontal:15:30|a" .. reset
            if BetterBlizzFramesDB.hidePartyDispelOverlayKeepGradient then
                tooltipText = tooltipText .. check
            end

            local orange = "|cffffaa00"
            tooltipText = tooltipText .. "\n\n" .. orange .. L["Ctrl_Right_Click_Hide_Dispel_Icons"] .. " |A:RaidFrame-Icon-DebuffCurse:15:15|a" .. reset
            if BetterBlizzFramesDB.hidePartyDispelOverlayHideIcons then
                tooltipText = tooltipText .. check
            end

            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end

        if title == L["Show_Elite_Texture"] or title == L["Elite_Texture"] then
            local tooltipText = L["Tooltip_Elite_Texture_Dark_Mode"]
            if BetterBlizzFramesDB.playerEliteFrameDarkmode then
                tooltipText = L["Tooltip_Elite_Texture_Dark_Mode_Check"] .. "|A:ParagonReputation_Checkmark:15:15|a"
            end
            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end

        if title == L["Tooltip_Pixel_Border_RaidFrames_Title"] or title == L["Pixel_Border"] then
            local green = "|cff32f795"
            local reset = "|r"
            local activeSize = BetterBlizzFramesDB.raidFramePixelBorderSize and "1.5px" or "1px"
            local tooltipText = "\n" .. green .. "Right-click to toggle between 1px and 1.5px. Active: " .. activeSize .. reset
            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end

        if title == L["Change_Party_Frame_Alpha"] or title == L["Party_Frame_Range_Alpha"] then
            local green = "|cff32f795"
            local reset = "|r"
            local check = ""
            if BetterBlizzFramesDB.partyFrameRangeAlphaSolidBackground then
                check = " |A:ParagonReputation_Checkmark:15:15|a"
            end
            local tooltipText = "\n" .. green .. L["Tooltip_Party_Frame_Range_Alpha_Solid_Bg"] .. reset .. check
            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end

        if title == L["Tooltip_Dark_Mode_Auras"] or title == L["Auras"] then
            local green = "|cff32f795"
            local reset = "|r"
            local check = ""
            if BetterBlizzFramesDB.removeDebuffColorBorder then
                check = " |A:ParagonReputation_Checkmark:15:15|a"
            end
            local tooltipText = "\n" .. green .. L["Tooltip_Remove_Debuff_Color_Border_Toggle"] .. reset .. check
            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end


        -- Set the subtext
        if subText then
            GameTooltip:AddLine("____________________________", 0.8, 0.8, 0.8, true)
            GameTooltip:AddLine(subText, 0.8, 0.80, 0.80, true)
        end
        -- Add CVar information if provided
        if cvarName then
            --GameTooltip:AddLine(" ")
            --GameTooltip:AddLine("Default Value: " .. cvarName, 0.5, 0.5, 0.5) -- grey color for subtext
            GameTooltip:AddDoubleLine(L["Tooltip_Changes_CVar"], cvarName, 0.2, 1, 0.6, 0.2, 1, 0.6)
        end
        if cpuUsage then
            local star = "|A:UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare-Star:16:16|a"
            local noStar = "|A:UI-HUD-UnitFrame-Target-PortraitOn-Boss-IconRing:16:16|a"

            -- Create star string based on cpuUsage (0-5)
            local starString = ""
            for i = 1, 5 do
                if i <= cpuUsage then
                    starString = starString .. star
                else
                    starString = starString .. noStar
                end
            end
            GameTooltip:AddDoubleLine(" ", " ")
            GameTooltip:AddDoubleLine(L["CPU_Usage"], starString, 0.2, 1, 0.6, 0.2, 1, 0.6)
        end

        if category then
            GameTooltip:AddLine("")
            GameTooltip:AddLine("|A:shop-games-magnifyingglass:17:17|a " .. L["Tooltip_Setting_Located_In"]..category..L["Tooltip_Section"], 0.4, 0.8, 1, true)
        end
        GameTooltip:Show()
    end)
    widget:HookScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end

local CLASS_COLORS = {
    ROGUE = "|cfffff569",
    WARRIOR = "|cffc79c6e",
    MAGE = "|cff40c7eb",
    DRUID = "|cffff7d0a",
    HUNTER = "|cffabd473",
    PRIEST = "|cffffffff",
    WARLOCK = "|cff8787ed",
    SHAMAN = "|cff0070de",
    PALADIN = "|cfff58cba",
    DEATHKNIGHT = "|cffc41f3b",
    MONK = "|cff00ff96",
    DEMONHUNTER = "|cffa330c9",
    EVOKER = "|cff33937f",
    STARTER = "|cff32cd32",
    BLITZ = "|cffff8000",
    MYTHIC = "|cff7dd1c2",
}

local CLASS_ICONS = {
    ROGUE = "groupfinder-icon-class-rogue",
    WARRIOR = "groupfinder-icon-class-warrior",
    MAGE = "groupfinder-icon-class-mage",
    DRUID = "groupfinder-icon-class-druid",
    HUNTER = "groupfinder-icon-class-hunter",
    PRIEST = "groupfinder-icon-class-priest",
    WARLOCK = "groupfinder-icon-class-warlock",
    SHAMAN = "groupfinder-icon-class-shaman",
    PALADIN = "groupfinder-icon-class-paladin",
    DEATHKNIGHT = "groupfinder-icon-class-deathknight",
    MONK = "groupfinder-icon-class-monk",
    DEMONHUNTER = "groupfinder-icon-class-demonhunter",
    EVOKER = "groupfinder-icon-class-evoker",
    STARTER = "newplayerchat-chaticon-newcomer",
    BLITZ = "questlog-questtypeicon-pvp",
    MYTHIC = "worldquest-icon-dungeon",
}

local function ShowProfileConfirmation(profileName, class, profileFunction, additionalNote)
    local noteText = additionalNote or ""
    local color = CLASS_COLORS[class] or "|cffffffff"
    local icon = CLASS_ICONS[class] or "groupfinder-icon-role-leader"
    local profileText = string.format("|A:%s:16:16|a %s%s|r", icon, color, profileName..L["Profile_Label"])
    local confirmationText = titleText .. string.format(L["Profile_Confirmation_Text"], profileText, noteText)

    StaticPopupDialogs["BBF_CONFIRM_PROFILE"].text = confirmationText
    StaticPopup_Show("BBF_CONFIRM_PROFILE", nil, nil, { func = profileFunction })
end

local function CreateClassButton(parent, class, name, twitchName, onClickFunc)
    local bbfParent = parent == BetterBlizzFrames
    local coreProfile = class == "STARTER" or name == "Bodify"
    local btnWidth, btnHeight = bbfParent and 104 or (coreProfile and 150 or 114), bbfParent and 22 or 30
    local button = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    button:SetSize(btnWidth, btnHeight)

    local dontIncludeProfileText = (bbfParent or not coreProfile) and "" or L["Profile_Label"]
    local color = CLASS_COLORS[class] or "|cffffffff"
    local icon = CLASS_ICONS[class] or "groupfinder-icon-role-leader"

    if name == "Bodify" then
        icon = "gmchat-icon-blizz"
    end

    button:SetText(string.format("|A:%s:16:16|a %s%s|r", icon, color, (name..dontIncludeProfileText)))
    button:SetNormalFontObject("GameFontNormal")
    button:SetHighlightFontObject("GameFontHighlight")
    local a,b,c = button.Text:GetFont()
    button.Text:SetFont(a,b,"OUTLINE")
    local a,b,c,d,e = button.Text:GetPoint()
    if not bbfParent then
        button.Text:SetPoint("LEFT",b,"LEFT",10,e-0.6)
    end
    local ttAnchor = "ANCHOR_TOP"

    button:SetScript("OnClick", function()
        if onClickFunc then
            onClickFunc()
        end
    end)

    if class == "STARTER" then
        CreateTooltipTwo(button, string.format("|A:%s:16:16|a %s%s|r", icon, color, name..L["Profile_Label"]), L["Profile_Starter_Desc"], nil, ttAnchor)
    elseif class == "BLITZ" then
        CreateTooltipTwo(button, string.format("|A:%s:16:16|a %s%s|r", icon, color, name..L["Profile_Label"]), L["Profile_Blitz_Desc"], nil, ttAnchor)
    elseif class == "MYTHIC" then
        CreateTooltipTwo(button, string.format("|A:%s:16:16|a %s%s|r", icon, color, name..L["Profile_Label"]), L["Profile_Mythic_Desc"], nil, ttAnchor)
    elseif name == "Bodify" then
        CreateTooltipTwo(button, string.format("|A:%s:16:16|a %s%s|r", icon, color, name..L["Profile_Label"]), L["Profile_Bodify_Desc"], nil, ttAnchor)
    else
        CreateTooltipTwo(button, string.format("|A:%s:16:16|a %s%s|r", icon, color, name..L["Profile_Label"]), string.format(L["Profile_Streamer_Desc"], name), string.format("www.twitch.tv/%s", twitchName), ttAnchor)
    end

    return button
end

local function CreateImportExportUI(parent, title, dataTable, posX, posY, tableName)
    -- Frame to hold all import/export elements
    local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    frame:SetSize(210, 65) -- Adjust size as needed
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
    
    -- Setting the backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground", -- More subtle background
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- Sleeker border
        tile = false, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.7) -- Semi-transparent black

    -- Title
    local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
    titleText:SetPoint("BOTTOM", frame, "TOP", 0, 0)
    titleText:SetText(title)

    -- Export EditBox
    local exportBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    exportBox:SetSize(100, 20)
    exportBox:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, -10)
    exportBox:SetAutoFocus(false)
    CreateTooltipTwo(exportBox, L["Tooltip_Ctrl_C_Copy"])

    -- Import EditBox
    local importBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    importBox:SetSize(100, 20)
    importBox:SetPoint("TOP", exportBox, "BOTTOM", 0, -5)
    importBox:SetAutoFocus(false)

    -- Export Button
    local exportBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    exportBtn:SetPoint("RIGHT", exportBox, "LEFT", -10, 0)
    exportBtn:SetSize(73, 20)
    exportBtn:SetText(L["Export"])
    exportBtn:SetNormalFontObject("GameFontNormal")
    exportBtn:SetHighlightFontObject("GameFontHighlight")
    CreateTooltipTwo(exportBtn, L["Tooltip_Export_Data"], L["Tooltip_Export_Data_Desc"])

    -- Import Button
    local importBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    importBtn:SetPoint("RIGHT", importBox, "LEFT", -10, 0)
    importBtn:SetSize(title ~= "Full Profile" and 52 or 73, 20)
    importBtn:SetText(L["Import"])
    importBtn:SetNormalFontObject("GameFontNormal")
    importBtn:SetHighlightFontObject("GameFontHighlight")
    CreateTooltipTwo(importBtn, L["Tooltip_Import_Data"], L["Tooltip_Import_Data_Desc"])

    -- Keep Old Checkbox
    local keepOldCheckbox
    if title ~= "Full Profile" then
        keepOldCheckbox = CreateFrame("CheckButton", nil, frame, "InterfaceOptionsCheckButtonTemplate")
        keepOldCheckbox:SetPoint("RIGHT", importBtn, "LEFT", 3, -1)
        keepOldCheckbox:SetChecked(true)
        CreateTooltipTwo(keepOldCheckbox, L["Tooltip_Keep_Old_Data"], L["Tooltip_Keep_Old_Data_Desc"])
    end

    -- Button scripts
    exportBtn:SetScript("OnClick", function()
        local exportString = BBF.ExportProfile(dataTable, tableName)
        exportBox:SetText(exportString)
        exportBox:SetFocus()
        exportBox:HighlightText()
    end)

    local wipeButton = exportBox:CreateTexture(nil, "OVERLAY")
    wipeButton:SetSize(14,14)
    wipeButton:SetPoint("CENTER", exportBox, "TOPRIGHT", 8,6)
    wipeButton:SetAtlas("transmog-icon-remove")
    wipeButton:Hide()

    wipeButton:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" and IsShiftKeyDown() and IsAltKeyDown() then
            if title == "Full Profile" then
                BetterBlizzFramesDB = nil
            else
                BetterBlizzFramesDB[tableName] = nil
            end
            ReloadUI()
        end
    end)

    local function HideWipeButton()
        if not wipeButton:IsMouseOver() then
            wipeButton:Hide()
        end
    end

    frame:HookScript("OnEnter", function()
        wipeButton:Show()
        C_Timer.After(4, HideWipeButton)
    end)
    CreateTooltipTwo(wipeButton, L["Tooltip_Delete_Data_Title"]..title, L["Tooltip_Delete_Data_Desc"].." "..title)

    wipeButton:HookScript("OnEnter", function()
        wipeButton:Show()
    end)

    wipeButton:HookScript("OnLeave", function()
        C_Timer.After(0.5, HideWipeButton)
    end)


    importBtn:SetScript("OnClick", function()
        local importString = importBox:GetText()
        local profileData, errorMessage = BBF.OldImportProfile(importString, tableName)
        if errorMessage then
            BBF.Print(L["Print_Error_Importing"] .. title .. ": " .. tostring(errorMessage))
        else
            if not profileData then
                BBF.Print(L["Print_Error_Importing_Generic"])
                return
            end
            if keepOldCheckbox and keepOldCheckbox:GetChecked() then
                -- Perform a deep merge if "Keep Old" is checked
                BBF.DeepMergeTables(dataTable, profileData)
            else
                -- Replace existing data with imported data
                for k in pairs(dataTable) do dataTable[k] = nil end -- Clear current table
                for k, v in pairs(profileData) do
                    dataTable[k] = v -- Populate with new data
                end
            end
            BBF.Print(string.format(L["Print_Imported_Successfully"], title))
            StaticPopup_Show("BBF_CONFIRM_RELOAD")
        end
    end)
    return frame
end

local function CreateAnchorDropdown(name, parent, defaultText, settingKey, toggleFunc, point)
    local function getDisplayTextForSetting(settingValue)
        if name == "combatIndicatorDropdown" or name == "playerAbsorbAnchorDropdown" then
            if settingValue == "LEFT" then
                return L["Anchor_INNER"]
            elseif settingValue == "RIGHT" then
                return L["Anchor_OUTER"]
            end
        end
        if settingValue == "TOP" then
            return L["Anchor_TOP"]
        elseif settingValue == "BOTTOM" then
            return L["Anchor_BOTTOM"]
        elseif settingValue == "CENTER" then
            return L["Anchor_CENTER"]
        elseif settingValue == "LEFT" then
            return L["Anchor_LEFT"]
        elseif settingValue == "RIGHT" then
            return L["Anchor_RIGHT"]
        end
        return settingValue or defaultText
    end

    local dropdown = CreateFrame("DropdownButton", name, parent, "WowStyle1DropdownTemplate")
    dropdown:SetWidth(150)
    if point and point.anchorFrame then
        dropdown:SetPoint("TOPLEFT", point.anchorFrame, "TOPLEFT", point.x or 0, point.y or 0)
    end

    local currentSetting = BetterBlizzFramesDB[settingKey]
    dropdown:SetDefaultText(getDisplayTextForSetting(currentSetting) or defaultText)
    dropdown.Background:SetVertexColor(0.9, 0.9, 0.9)
    dropdown.Arrow:SetVertexColor(0.9, 0.9, 0.9)

    local anchorPointsToUse = (name == "combatIndicatorDropdown" or name == "playerAbsorbAnchorDropdown") and anchorPoints2 or anchorPoints

    local function GeneratorFunction(owner, rootDescription)
        for _, anchor in ipairs(anchorPointsToUse) do
            local displayText = anchor
            if anchor == "TOP" then
                displayText = L["Anchor_TOP"]
            elseif anchor == "BOTTOM" then
                displayText = L["Anchor_BOTTOM"]
            elseif anchor == "CENTER" then
                displayText = L["Anchor_CENTER"]
            elseif anchor == "LEFT" then
                if name == "combatIndicatorDropdown" or name == "playerAbsorbAnchorDropdown" then
                    displayText = L["Anchor_INNER"]
                else
                    displayText = L["Anchor_LEFT"]
                end
            elseif anchor == "RIGHT" then
                if name == "combatIndicatorDropdown" or name == "playerAbsorbAnchorDropdown" then
                    displayText = L["Anchor_OUTER"]
                else
                    displayText = L["Anchor_RIGHT"]
                end
            end

            rootDescription:CreateRadio(displayText, function()
                return BetterBlizzFramesDB[settingKey] == anchor
            end, function()
                if BetterBlizzFramesDB[settingKey] ~= anchor then
                    BetterBlizzFramesDB[settingKey] = anchor
                    dropdown:SetDefaultText(displayText)
                    if toggleFunc then toggleFunc(anchor) end
                    if BBF.MoveToTFrames then BBF.MoveToTFrames() end
                end
            end)
        end
    end

    hooksecurefunc(dropdown, "OnMenuClosed", function()
        dropdown:SetDefaultText(getDisplayTextForSetting(BetterBlizzFramesDB[settingKey]))
    end)

    dropdown:SetupMenu(GeneratorFunction)

    if point and point.label and point.label ~= "" then
        local dropdownText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        dropdownText:SetPoint("BOTTOM", dropdown, "TOP", 0, 3)
        dropdownText:SetText(point.label)
    end

    return dropdown
end

local classOptionsFrame
function BBF.OpenClassSpecificWindow()
    if not classOptionsFrame then
        classOptionsFrame = CreateFrame("Frame", "ClassOptionsFrame", UIParent, "ButtonFrameTemplate")
        tinsert(UISpecialFrames, "ClassOptionsFrame")
        ButtonFrameTemplate_HidePortrait(classOptionsFrame)
        if classOptionsFrame.Inset then classOptionsFrame.Inset:Hide() end
        if classOptionsFrame.Bg then
            classOptionsFrame.Bg:SetColorTexture(0.0784, 0.0784, 0.0784, 1)
        end
        classOptionsFrame:SetSize(260, 310)
        classOptionsFrame:SetPoint("CENTER")
        classOptionsFrame:SetFrameStrata("DIALOG")
        classOptionsFrame:SetMovable(true)
        classOptionsFrame:EnableMouse(true)
        classOptionsFrame:RegisterForDrag("LeftButton")
        classOptionsFrame:SetScript("OnDragStart", classOptionsFrame.StartMoving)
        classOptionsFrame:SetScript("OnDragStop", classOptionsFrame.StopMovingOrSizing)
        if classOptionsFrame.SetTitle then
            classOptionsFrame:SetTitle(L["Class_Specific_Options"])
        else
            classOptionsFrame.title = classOptionsFrame:CreateFontString(nil, "OVERLAY")
            classOptionsFrame.title:SetFontObject("GameFontHighlight")
            classOptionsFrame.title:SetPoint("TOP", classOptionsFrame, "TOP", 0, -5)
            classOptionsFrame.title:SetText(L["Class_Specific_Options"])
        end

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

        for i, classData in ipairs(classes) do
            local rowFrame = CreateFrame("Frame", nil, classOptionsFrame)
            rowFrame:SetHeight(30)
            rowFrame:SetPoint("TOPLEFT", classOptionsFrame, "TOPLEFT", 16, -32 - (i - 1) * 33)
            rowFrame:SetPoint("TOPRIGHT", classOptionsFrame, "TOPRIGHT", 4, -32 - (i - 1) * 33)

            local rowHighlight = rowFrame:CreateTexture(nil, "BACKGROUND")
            rowHighlight:SetPoint("TOPLEFT", rowFrame, "TOPLEFT", -10, 0)
            rowHighlight:SetPoint("BOTTOMRIGHT", rowFrame, "BOTTOMRIGHT", -10, 0)
            rowHighlight:SetAtlas("options-item-highlight")
            if not rowHighlight:GetTexture() then
                rowHighlight:SetColorTexture(1, 1, 1, 0.12)
            end
            rowHighlight:SetBlendMode("ADD")
            rowHighlight:Hide()

            local classCheckbox = CreateFrame("CheckButton", nil, rowFrame, "SettingsCheckboxTemplate")
            if classCheckbox:GetHighlightTexture() then
                classCheckbox:GetHighlightTexture():SetTexture("")
                classCheckbox:GetHighlightTexture():SetAlpha(0)
                classCheckbox:GetHighlightTexture():Hide()
                classCheckbox:GetHighlightTexture().Show = function() end
            end
            if classCheckbox.HoverBackground then
                classCheckbox.HoverBackground:SetAlpha(0)
                classCheckbox.HoverBackground:Hide()
                classCheckbox.HoverBackground.Show = function() end
            end

            local function UpdateHighlight()
                if MouseIsOver(rowFrame) then
                    rowHighlight:Show()
                else
                    rowHighlight:Hide()
                end
            end
            classCheckbox:SetSize(26, 26)
            classCheckbox:SetPoint("LEFT", rowFrame, "LEFT", 5, 0)
            if not classCheckbox.Text then
                classCheckbox.Text = classCheckbox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                classCheckbox.Text:SetPoint("LEFT", classCheckbox, "RIGHT", 6, 0)
            end
            local localizedClassName = GetClassInfo(classData.classID)
            classCheckbox.Text:SetText(string.format(L["Ignore_Class"], localizedClassName or ""))

            if classData.color then
                local r, g, b = classData.color.r, classData.color.g, classData.color.b
                classCheckbox.Text:SetTextColor(r, g, b)
            end

            classCheckbox:SetHitRectInsets(0, -180, 0, 0)
            classCheckbox:SetChecked(BetterBlizzFramesDB[classData.var])

            classCheckbox:SetScript("OnClick", function(self)
                BetterBlizzFramesDB[classData.var] = self:GetChecked() or nil
                if BBF.HideFrames then BBF.HideFrames() end
            end)

            rowFrame:EnableMouse(true)
            rowFrame:SetScript("OnEnter", UpdateHighlight)
            rowFrame:SetScript("OnLeave", UpdateHighlight)
            rowFrame:SetScript("OnMouseDown", function() classCheckbox:Click() end)
            classCheckbox:HookScript("OnEnter", UpdateHighlight)
            classCheckbox:HookScript("OnLeave", UpdateHighlight)
        end
        classOptionsFrame:Show()
    else
        if classOptionsFrame:IsShown() then
            classOptionsFrame:Hide()
        else
            classOptionsFrame:Show()
        end
    end
end

local customColorFrame
function BBF.OpenColorOptions()
    if not customColorFrame then
        customColorFrame = CreateFrame("Frame", "BBFCustomColorOptionsFrame", UIParent, "ButtonFrameTemplate")
        tinsert(UISpecialFrames, "BBFCustomColorOptionsFrame")
        ButtonFrameTemplate_HidePortrait(customColorFrame)
        if customColorFrame.Inset then customColorFrame.Inset:Hide() end
        if customColorFrame.Bg then
            customColorFrame.Bg:SetColorTexture(0.0784, 0.0784, 0.0784, 1)
        end
        customColorFrame:SetSize(360, 560)
        customColorFrame:SetPoint("CENTER")
        customColorFrame:SetFrameStrata("DIALOG")
        customColorFrame:SetMovable(true)
        customColorFrame:EnableMouse(true)
        customColorFrame:RegisterForDrag("LeftButton")
        customColorFrame:SetScript("OnDragStart", customColorFrame.StartMoving)
        customColorFrame:SetScript("OnDragStop", customColorFrame.StopMovingOrSizing)
        if customColorFrame.SetTitle then
            customColorFrame:SetTitle(L["Custom_Health_Colors"])
        else
            customColorFrame.title = customColorFrame:CreateFontString(nil, "OVERLAY")
            customColorFrame.title:SetFontObject("GameFontHighlight")
            customColorFrame.title:SetPoint("TOP", customColorFrame, "TOP", 0, -5)
            customColorFrame.title:SetText(L["Custom_Health_Colors"])
        end

        local scrollFrame = CreateFrame("ScrollFrame", nil, customColorFrame, "ScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", customColorFrame, "TOPLEFT", 10, -30)
        scrollFrame:SetPoint("BOTTOMRIGHT", customColorFrame, "BOTTOMRIGHT", -30, 10)

        local content = CreateFrame("Frame", nil, scrollFrame)
        content:SetSize(315, 780)
        scrollFrame:SetScrollChild(content)

        local currentY = -10

        local function AddHeader(textStr)
            local header = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            header:SetPoint("TOPLEFT", content, "TOPLEFT", 10, currentY)
            header:SetText(textStr)
            currentY = currentY - 22
            return header
        end

        local function AddCheckbox(dbKey, labelStr, callback, indentX, ttTitle, ttDesc)
            local posX = 6 + (indentX or 0)
            local width = 295 - (indentX or 0)
            local rowFrame = CreateFrame("Frame", nil, content)
            rowFrame:SetSize(width, 28)
            rowFrame:SetPoint("TOPLEFT", content, "TOPLEFT", posX, currentY)

            local rowHighlight = rowFrame:CreateTexture(nil, "BACKGROUND")
            rowHighlight:SetAllPoints()
            rowHighlight:SetAtlas("options-item-highlight")
            if not rowHighlight:GetTexture() then
                rowHighlight:SetColorTexture(1, 1, 1, 0.12)
            end
            rowHighlight:SetBlendMode("ADD")
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
                if MouseIsOver(rowFrame) then
                    rowHighlight:Show()
                else
                    rowHighlight:Hide()
                end
            end
            cb:SetSize(24, 24)
            cb:SetPoint("LEFT", rowFrame, "LEFT", 5, 0)
            if not cb.Text then
                cb.Text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                cb.Text:SetPoint("LEFT", cb, "RIGHT", 6, 0)
            end
            cb.Text:SetText(labelStr)
            cb:SetHitRectInsets(0, -(width - 45), 0, 0)
            cb:SetChecked(BetterBlizzFramesDB[dbKey])
            cb:SetScript("OnClick", function(self)
                BetterBlizzFramesDB[dbKey] = self:GetChecked() or nil
                if callback then callback() end
                if BBF.UpdateFrames then BBF.UpdateFrames() end
            end)

            if ttTitle or ttDesc then
                CreateTooltipTwo(cb, ttTitle or labelStr, ttDesc, nil, "ANCHOR_RIGHT")
                CreateTooltipTwo(rowFrame, ttTitle or labelStr, ttDesc, nil, "ANCHOR_RIGHT")
            end

            rowFrame:EnableMouse(true)
            rowFrame:SetScript("OnEnter", UpdateHighlight)
            rowFrame:SetScript("OnLeave", UpdateHighlight)
            rowFrame:SetScript("OnMouseDown", function() if cb:IsEnabled() then cb:Click() end end)
            cb:HookScript("OnEnter", UpdateHighlight)
            cb:HookScript("OnLeave", UpdateHighlight)

            currentY = currentY - 32
            return cb
        end

        local function SetSwatchEnabled(swatchBtn, enabled)
            if swatchBtn then
                swatchBtn:SetEnabled(enabled)
                swatchBtn:SetAlpha(enabled and 1 or 0.4)
            end
        end

        local function AddColorSwatch(dbKey, labelStr, posX, posY, defaultColor, maxTextWidth, callback, ttTitle, ttDesc)
            local btn = CreateFrame("Button", nil, content)
            btn:SetSize(18, 18)
            btn:SetPoint("TOPLEFT", content, "TOPLEFT", posX, posY)
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
            local descText = ttDesc or L["Tooltip_Color_Picker_Desc"]
            CreateTooltipTwo(btn, titleText, descText, nil, "ANCHOR_RIGHT")

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
                        BetterBlizzFramesDB[dbKey] = {r = nr, g = ng, b = nb}
                        swatch:SetVertexColor(nr, ng, nb)
                        if callback then callback() end
                        if BBF.UpdateFrames then BBF.UpdateFrames() end
                    end,
                    cancelFunc = function(prev)
                        BetterBlizzFramesDB[dbKey] = {r = prev.r, g = prev.g, b = prev.b}
                        swatch:SetVertexColor(prev.r, prev.g, prev.b)
                        if callback then callback() end
                        if BBF.UpdateFrames then BBF.UpdateFrames() end
                    end
                }
                ColorPickerFrame:SetupColorPickerAndShow(info)
            end)

            return btn
        end

        -- SECTION 1: General Custom Colors
        AddHeader(L["Custom_Colors"])
        AddCheckbox("customColorsUnitFrames", L["Enable_On_UnitFrames"], nil, nil, L["Enable_On_UnitFrames"], L["Tooltip_Enable_On_UnitFrames_Desc"])
        AddCheckbox("customColorsRaidFrames", L["Enable_On_Raid_Party_Frames"], nil, nil, L["Enable_On_Raid_Party_Frames"], L["Tooltip_Enable_On_Raid_Party_Frames_Desc"])

        -- SECTION 2: Reaction Colors
        currentY = currentY - 10
        AddHeader(L["Reaction_Colors"])
        local startY = currentY
        AddColorSwatch("enemyHealthColor", _G["ENEMY"] or L["Enemy"], 10, startY, {r = 1, g = 0.2, b = 0.2}, 76, nil, L["Enemy_Health_Color"], L["Tooltip_Color_Picker_Desc"])
        AddColorSwatch("friendlyHealthColor", _G["FRIENDLY"] or L["Friendly"], 110, startY, {r = 0.2, g = 1, b = 0.2}, 76, nil, L["Friendly_Health_Color"], L["Tooltip_Color_Picker_Desc"])
        AddColorSwatch("neutralHealthColor", _G["NEUTRAL"] or L["Neutral"], 210, startY, {r = 1, g = 1, b = 0.2}, 76, nil, L["Neutral_Health_Color"], L["Tooltip_Color_Picker_Desc"])
        currentY = currentY - 28

        -- SECTION 3: Class Colors
        currentY = currentY - 10
        AddHeader(L["Class_Colors"])

        local classSwatches = {}
        local singleClassBtn
        local useOneClassCb

        local function UpdateClassColorsState()
            local parentEnabled = BetterBlizzFramesDB.overrideClassColors
            local useOne = BetterBlizzFramesDB.useOneClassColor

            useOneClassCb:SetEnabled(parentEnabled and true or false)
            useOneClassCb:SetAlpha(parentEnabled and 1 or 0.4)

            SetSwatchEnabled(singleClassBtn, parentEnabled and useOne)

            for _, btn in ipairs(classSwatches) do
                SetSwatchEnabled(btn, parentEnabled and not useOne)
            end
        end

        AddCheckbox("overrideClassColors", L["Override_Class_Colors"], function() UpdateClassColorsState() end, nil, L["Override_Class_Colors"], L["Tooltip_Override_Class_Colors_Desc"])
        useOneClassCb = AddCheckbox("useOneClassColor", L["Use_One_Color"], function() UpdateClassColorsState() end, 16, L["Use_One_Color"], L["Tooltip_Use_One_Color_For_All_Classes_Desc"])
        singleClassBtn = AddColorSwatch("singleClassColor", L["All_Classes"], 26, currentY, {r = 0.8, g = 0.8, b = 0.8}, nil, nil, L["Single_Class_Color"], L["Tooltip_Color_Picker_Desc"])
        currentY = currentY - 26

        local function GetNativePowerName(key, spellID)
            if _G[key] then return _G[key] end
            if _G["POWER_TYPE_" .. key] then return _G["POWER_TYPE_" .. key] end
            if spellID then
                local name = C_Spell.GetSpellName(spellID)
                if name then return name end
            end
            return key
        end

        local classes = {}
        for classID = 1, GetNumClasses() do
            local localizedClassName, classTag = GetClassInfo(classID)
            if classTag and localizedClassName then
                table.insert(classes, {key = classTag, name = localizedClassName})
            end
        end
        table.sort(classes, function(a, b) return a.name < b.name end)

        local thirdCount = math.ceil(#classes / 3)
        local gridStartY = currentY
        local rowHeight = 28
        for i, classData in ipairs(classes) do
            local colIndex = math.floor((i - 1) / thirdCount)
            local rowIndex = (i - 1) % thirdCount
            local posX = 10 + colIndex * 102
            local posY = gridStartY - rowIndex * rowHeight
            local classDefColor = RAID_CLASS_COLORS[classData.key] or {r = 1, g = 1, b = 1}
            local btn = AddColorSwatch("classColor" .. classData.key, classData.name, posX, posY, {r = classDefColor.r, g = classDefColor.g, b = classDefColor.b}, 76, nil, classData.name, L["Tooltip_Color_Picker_Desc"])
            table.insert(classSwatches, btn)
        end
        currentY = gridStartY - thirdCount * rowHeight - 12

        -- SECTION 4: Power Colors
        AddHeader(L["Power_Colors"])

        local powerSwatches = {}
        local singlePowerBtn
        local useOnePowerCb

        local function UpdatePowerColorsState()
            local parentEnabled = BetterBlizzFramesDB.customPowerColors
            local useOne = BetterBlizzFramesDB.useOnePowerColor

            useOnePowerCb:SetEnabled(parentEnabled and true or false)
            useOnePowerCb:SetAlpha(parentEnabled and 1 or 0.4)

            SetSwatchEnabled(singlePowerBtn, parentEnabled and useOne)

            for _, btn in ipairs(powerSwatches) do
                SetSwatchEnabled(btn, parentEnabled and not useOne)
            end
        end

        AddCheckbox("customPowerColors", L["Enable_Power_Colors"], function() UpdatePowerColorsState() end, nil, L["Enable_Power_Colors"], L["Tooltip_Enable_Power_Colors_Desc"])
        useOnePowerCb = AddCheckbox("useOnePowerColor", L["Use_One_Color"], function() UpdatePowerColorsState() end, 16, L["Use_One_Color"], L["Tooltip_Use_One_Color_For_All_Powers_Desc"])
        singlePowerBtn = AddColorSwatch("singlePowerColor", L["All_Classes"], 26, currentY, {r = 0, g = 0.8, b = 1}, nil, nil, L["Single_Power_Color"], L["Tooltip_Color_Picker_Desc"])
        currentY = currentY - 26

        local powerTypes = {
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
            { key = "SOUL_SHARDS", spellID = 246985, color = {r = 0.64, g = 0.2, b = 0.93} },
        }

        local pThird = math.ceil(#powerTypes / 3)
        local pGridStartY = currentY
        for i, pData in ipairs(powerTypes) do
            local colIndex = math.floor((i - 1) / pThird)
            local rowIndex = (i - 1) % pThird
            local posX = 10 + colIndex * 102
            local posY = pGridStartY - rowIndex * rowHeight
            local labelName = GetNativePowerName(pData.key, pData.spellID)
            local btn = AddColorSwatch("powerColor" .. pData.key, labelName, posX, posY, pData.color, 76, nil, labelName, L["Tooltip_Color_Picker_Desc"])
            table.insert(powerSwatches, btn)
        end
        currentY = pGridStartY - pThird * rowHeight - 14

        -- SECTION 5: Background Colors
        AddHeader(L["Background_Colors"])
        local unitHealthBgBtn, unitManaBgBtn, unitBgDd

        local function UpdateUnitBgState()
            local parentEnabled = BetterBlizzFramesDB.customBgColorUnitFrames
            SetSwatchEnabled(unitHealthBgBtn, parentEnabled)
            SetSwatchEnabled(unitManaBgBtn, parentEnabled)
            if unitBgDd then unitBgDd:SetEnabled(parentEnabled) end
        end

        local unitBgCb = AddCheckbox("customBgColorUnitFrames", L["Change_UnitFrame_Background_Color"], function() UpdateUnitBgState() end, nil, L["Change_UnitFrame_Background_Color"], L["Tooltip_Change_UnitFrame_Background_Color_Desc"])
        if CreateTextureDropdown then
            unitBgDd = CreateTextureDropdown(
                "unitFrameBgTexture",
                content,
                L["Select_Texture"],
                "unitFrameBgTexture",
                function()
                    if BBF.UpdateCustomTextures then BBF.UpdateCustomTextures() end
                    if BBF.UnitFrameBackgroundTexture then BBF.UnitFrameBackgroundTexture() end
                end,
                { anchorFrame = unitBgCb, x = 20, y = -4, label = L["Select_Texture"] }
            )
            currentY = currentY - 32
        end
        unitHealthBgBtn = AddColorSwatch("customHealthBgColor", L["Health_BG"], 26, currentY, {r = 0, g = 0, b = 0}, 100, nil, L["Health_Bar_Background_Color"], L["Tooltip_Color_Picker_Desc"])
        unitManaBgBtn = AddColorSwatch("customManaBgColor", L["Mana_BG"], 146, currentY, {r = 0, g = 0, b = 0}, 100, nil, L["Mana_Bar_Background_Color"], L["Tooltip_Color_Picker_Desc"])
        currentY = currentY - 28

        local raidHealthBgBtn, raidManaBgBtn, raidBgDd

        local function UpdateRaidBgState()
            local parentEnabled = BetterBlizzFramesDB.customBgColorRaidFrames
            SetSwatchEnabled(raidHealthBgBtn, parentEnabled)
            SetSwatchEnabled(raidManaBgBtn, parentEnabled)
            if raidBgDd then raidBgDd:SetEnabled(parentEnabled) end
        end

        local raidBgCb = AddCheckbox("customBgColorRaidFrames", L["Change_Party_RaidFrame_Background_Color"], function() UpdateRaidBgState() end, nil, L["Change_Party_RaidFrame_Background_Color"], L["Tooltip_Change_Party_RaidFrame_Background_Color_Desc"])
        if CreateTextureDropdown then
            raidBgDd = CreateTextureDropdown(
                "raidFrameBgTexture",
                content,
                L["Select_Texture"],
                "raidFrameBgTexture",
                function()
                    if BBF.UpdateCustomTextures then BBF.UpdateCustomTextures() end
                    if BBF.SetCompactUnitFramesBackground then BBF.SetCompactUnitFramesBackground() end
                end,
                { anchorFrame = raidBgCb, x = 20, y = -4, label = L["Select_Texture"] }
            )
            currentY = currentY - 32
        end
        raidHealthBgBtn = AddColorSwatch("customRaidHealthBgColor", L["Health_BG"], 26, currentY, {r = 0, g = 0, b = 0}, 100, nil, L["Party_Raid_Health_Bar_Background_Color"], L["Tooltip_Color_Picker_Desc"])
        raidManaBgBtn = AddColorSwatch("customRaidManaBgColor", L["Mana_BG"], 146, currentY, {r = 0, g = 0, b = 0}, 100, nil, L["Party_Raid_Mana_Bar_Background_Color"], L["Tooltip_Color_Picker_Desc"])
        currentY = currentY - 28

        -- Sync initial states
        UpdateClassColorsState()
        UpdatePowerColorsState()
        UpdateUnitBgState()
        UpdateRaidBgState()

        content:SetHeight(math.abs(currentY) + 30)

        customColorFrame:Show()
    else
        if customColorFrame:IsShown() then
            customColorFrame:Hide()
        else
            customColorFrame:Show()
        end
    end
end

function BBF.HandleRightClick(option, titleStr, widget)
    local isShift = IsShiftKeyDown()
    local isCtrl = IsControlKeyDown()

    if option == "formatStatusBarText" or titleStr == L["Format_Numbers"] then
        BetterBlizzFramesDB.formatStatusBarTextExtraDecimals = not BetterBlizzFramesDB.formatStatusBarTextExtraDecimals
        if BBF.HookStatusBarText then BBF.HookStatusBarText() end

    elseif option == "playerEliteFrame" or titleStr == L["Show_Elite_Texture"] then
        if isShift then
            BetterBlizzFramesDB.playerEliteFrameDarkmode = not BetterBlizzFramesDB.playerEliteFrameDarkmode
        else
            local textures = BetterBlizzFramesDB.classicFrames and 7 or 4
            BetterBlizzFramesDB.playerEliteFrameMode = ((BetterBlizzFramesDB.playerEliteFrameMode or 1) % textures) + 1
        end
        if BBF.PlayerElite then BBF.PlayerElite(BetterBlizzFramesDB.playerEliteFrameMode) end
        if BBF.PlayerEliteFrame then BBF.PlayerEliteFrame() end
        if BBF.DarkmodeFrames then BBF.DarkmodeFrames(true) end

    elseif option == "darkModeEliteTexture" or titleStr == L["Tooltip_Dark_Mode_Elite_Title"] or titleStr == L["Dark_Mode_Elite_Texture"] then
        BetterBlizzFramesDB.darkModeEliteTextureDesaturated = not BetterBlizzFramesDB.darkModeEliteTextureDesaturated
        if BBF.DarkmodeFrames then BBF.DarkmodeFrames(true) end

    elseif option == "classColorFrames" or titleStr == L["Class_Color_Health"] or titleStr == L["Tooltip_Class_Color_Healthbars_Title"] then
        if isShift and not isCtrl then
            BetterBlizzFramesDB.classColorFramesSkipFriendly = not BetterBlizzFramesDB.classColorFramesSkipFriendly
        else
            BetterBlizzFramesDB.classColorFramesSkipPlayer = not BetterBlizzFramesDB.classColorFramesSkipPlayer
        end

        if BetterBlizzFramesDB.classColorFramesSkipPlayer then
            if PlayerFrame and PlayerFrame.healthbar then
                PlayerFrame.healthbar:SetStatusBarDesaturated(false)
                PlayerFrame.healthbar:SetStatusBarColor(1, 1, 1)
            end
            if CfPlayerFrameHealthBar and BBF.updateFrameColorToggleVer then
                BBF.updateFrameColorToggleVer(CfPlayerFrameHealthBar, "player")
            end
        else
            if PlayerFrame and PlayerFrame.healthbar and BBF.updateFrameColorToggleVer then
                BBF.updateFrameColorToggleVer(PlayerFrame.healthbar, "player")
            end
            if CfPlayerFrameHealthBar and BBF.updateFrameColorToggleVer then
                BBF.updateFrameColorToggleVer(CfPlayerFrameHealthBar, "player")
            end
        end

        if BBF.ClassColorFramesCaller then
            BBF.ClassColorFramesCaller()
        elseif BBF.ClassColorFrames then
            BBF.ClassColorFrames()
        end
        if BBF.UpdateFrames then
            BBF.UpdateFrames()
        end

        if GameTooltip:IsShown() and widget and widget.HasScript and widget:HasScript("OnEnter") then
            widget:GetScript("OnEnter")(widget)
        end

    elseif option == "customHealthbarColors" or titleStr == L["Custom_Colors"] or titleStr == L["Custom_Color_Health_Mana"] then
        if isShift and not isCtrl then
            BetterBlizzFramesDB.classColorFramesSkipFriendly = not BetterBlizzFramesDB.classColorFramesSkipFriendly
            if BBF.UpdateFrames then BBF.UpdateFrames() end
        elseif isCtrl and not isShift then
            BetterBlizzFramesDB.classColorFramesSkipPlayer = not BetterBlizzFramesDB.classColorFramesSkipPlayer
            if BetterBlizzFramesDB.classColorFramesSkipPlayer then
                if PlayerFrame and PlayerFrame.healthbar then
                    PlayerFrame.healthbar:SetStatusBarDesaturated(false)
                    PlayerFrame.healthbar:SetStatusBarColor(1, 1, 1)
                end
                if CfPlayerFrameHealthBar and BBF.updateFrameColorToggleVer then
                    BBF.updateFrameColorToggleVer(CfPlayerFrameHealthBar, "player")
                end
            else
                if PlayerFrame and PlayerFrame.healthbar and BBF.updateFrameColorToggleVer then
                    BBF.updateFrameColorToggleVer(PlayerFrame.healthbar, "player")
                end
                if CfPlayerFrameHealthBar and BBF.updateFrameColorToggleVer then
                    BBF.updateFrameColorToggleVer(CfPlayerFrameHealthBar, "player")
                end
            end
            if BBF.UpdateFrames then BBF.UpdateFrames() end
        else
            if BBF.OpenColorOptions then BBF.OpenColorOptions() end
        end

        if GameTooltip:IsShown() and widget and widget.HasScript and widget:HasScript("OnEnter") then
            widget:GetScript("OnEnter")(widget)
        end

    elseif option == "hidePartyDispelOverlay" or titleStr == L["Hide_Dispel_Overlay"] then
        if isCtrl then
            BetterBlizzFramesDB.hidePartyDispelOverlayHideIcons = not BetterBlizzFramesDB.hidePartyDispelOverlayHideIcons
        elseif isShift then
            BetterBlizzFramesDB.hidePartyDispelOverlayKeepGradient = not BetterBlizzFramesDB.hidePartyDispelOverlayKeepGradient
        else
            BetterBlizzFramesDB.hidePartyDispelOverlayKeepBorder = not BetterBlizzFramesDB.hidePartyDispelOverlayKeepBorder
        end
        if BBF.HideFrames then BBF.HideFrames() end

    elseif option == "raidFramePixelBorder" or titleStr == L["Pixel_Border"] or titleStr == L["Tooltip_Pixel_Border_RaidFrames_Title"] then
        BetterBlizzFramesDB.raidFramePixelBorderSize = not BetterBlizzFramesDB.raidFramePixelBorderSize

    elseif option == "partyFrameRangeAlpha" or titleStr == L["Party_Frame_Range_Alpha"] or titleStr == L["Change_Party_Frame_Alpha"] then
        BetterBlizzFramesDB.partyFrameRangeAlphaSolidBackground = not BetterBlizzFramesDB.partyFrameRangeAlphaSolidBackground

    elseif option == "hidePlayerPower" or titleStr == L["Hide_Resource_Power"] then
        if BBF.OpenClassSpecificWindow then BBF.OpenClassSpecificWindow() end

    elseif option == "showSpecName" or titleStr == L["Show_Spec_Name"] then
        BetterBlizzFramesDB.partyArenaNames = not BetterBlizzFramesDB.partyArenaNames
        if BBF.UpdateNameSettings then BBF.UpdateNameSettings() end
    end

    if widget and widget:IsMouseOver() then
        local onEnter = widget:GetScript("OnEnter")
        if onEnter then
            onEnter(widget)
        end
    end
end

local function CreateCheckbox(option, label, parent, cvarName, extraFunc)
    local checkBox = CreateFrame("CheckButton", nil, parent, "SettingsCheckboxTemplate")
    if checkBox:GetHighlightTexture() then
        checkBox:GetHighlightTexture():SetTexture("")
        checkBox:GetHighlightTexture():SetAlpha(0)
        checkBox:GetHighlightTexture():Hide()
        checkBox:GetHighlightTexture().Show = function() end
    end
    if checkBox.HoverBackground then
        checkBox.HoverBackground:SetAlpha(0)
        checkBox.HoverBackground:Hide()
        checkBox.HoverBackground.Show = function() end
    end
    if not checkBox.Text then
        checkBox.Text = checkBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        checkBox.Text:SetPoint("LEFT", checkBox, "RIGHT", 4, 0)
    end
    checkBox.Text:SetText(label)
    checkBox:SetSize(23,23)
    checkBox:RegisterForClicks("LeftButtonUp", "RightButtonUp")



    local category
    if parent.name then
        category = parent.name
    elseif parent:GetParent() and parent:GetParent().name then
        category = parent:GetParent().name
    elseif parent:GetParent() and parent:GetParent():GetParent() and parent:GetParent():GetParent().name then
        category = parent:GetParent():GetParent().name
    end

    if category == "Better|cff00c0ffBlizz|rFrames |A:gmchat-icon-blizz:16:16|a" then
        category = L["Search_Name_General"]
    end

    checkBox.searchCategory = category


    table.insert(checkBoxList, {checkbox = checkBox, label = label})

    if parent and parent:GetObjectType() == "CheckButton" then
        checkBox.parentCheckButton = parent
        parent.childrenCheckButtons = parent.childrenCheckButtons or {}
        table.insert(parent.childrenCheckButtons, checkBox)
    end

    local function UpdateEnabledState()
        local isParentDisabled = false
        if checkBox.parentCheckButtons then
            local anyParentActive = false
            for _, parentCB in ipairs(checkBox.parentCheckButtons) do
                if parentCB:GetChecked() and parentCB:IsEnabled() then
                    anyParentActive = true
                    break
                end
            end
            if not anyParentActive then
                isParentDisabled = true
            end
        elseif checkBox.parentCheckButton then
            local parentCB = checkBox.parentCheckButton
            if not parentCB:GetChecked() or not parentCB:IsEnabled() then
                isParentDisabled = true
            end
        end

        if isParentDisabled then
            checkBox:Disable()
            checkBox:SetAlpha(0.5)
            if checkBox.associatedTitle then
                checkBox.associatedTitle:SetFontObject("GameFontDisableSmall")
            end
            if checkBox.associatedRow then
                checkBox.associatedRow:SetAlpha(0.5)
            end
        else
            checkBox:Enable()
            checkBox:SetAlpha(1)
            if checkBox.associatedTitle then
                checkBox.associatedTitle:SetFontObject("GameFontHighlightSmall")
            end
            if checkBox.associatedRow then
                checkBox.associatedRow:SetAlpha(1)
            end
        end

        if checkBox.childrenCheckButtons then
            for _, child in ipairs(checkBox.childrenCheckButtons) do
                if child.UpdateEnabledState then
                    child:UpdateEnabledState()
                end
            end
        end
    end


    checkBox.UpdateEnabledState = UpdateEnabledState

    local function UpdateOption(value)
        if option == 'friendlyFrameClickthrough' and BBF.checkCombatAndWarn() then
            return
        end

        local function SetChecked()
            if BetterBlizzFramesDB.hasCheckedUi then
                BetterBlizzFramesDB[option] = value
                checkBox:SetChecked(value)
            else
                C_Timer.After(0.1, function()
                    SetChecked()
                end)
            end
        end
        SetChecked()

        UpdateEnabledState()

        if extraFunc and not BetterBlizzFramesDB.wasOnLoadingScreen and BetterBlizzFrames.guiLoaded then
            extraFunc(option, value)
        end

        if not BetterBlizzFramesDB.wasOnLoadingScreen then
            BBF.UpdateUserTargetSettings()
        end

        if not BetterBlizzFramesDB.wasOnLoadingScreen and BetterBlizzFramesDB.playerAuraFiltering then
            BBF.RefreshAllAuraFrames()
        end
        --BBF.Print("Checkbox option '" .. option .. "' changed to:", value)
    end

    UpdateOption(BetterBlizzFramesDB[option])

    checkBox:SetScript("OnClick", function(self, button)
        if button == "RightButton" then
            checkBox:SetChecked(BetterBlizzFramesDB[option])
            if BBF.HandleRightClick then
                BBF.HandleRightClick(option, label, checkBox)
            end
        else
            UpdateOption(checkBox:GetChecked())
            UpdateEnabledState()
        end
    end)

    return checkBox

end




local function deleteEntry(listName, key)
    if not key then return end

    local entry = BetterBlizzFramesDB[listName][key]

    if not entry then
        if key == "example aura :3 (delete me)" then
            entry = BetterBlizzFramesDB[listName]["example"]
            key = "example"
        end
    end

    if entry then
        if entry.id then
            local spellName, _, icon = BBF.TWWGetSpellInfo(entry.id)
            if spellName and icon then
                local iconString = "|T" .. icon .. ":16:16:0:0|t"
                BBF.Print(string.format(L["Print_Removed_From_List"], iconString .. " " .. spellName .. " (" .. entry.id .. ")"))
            elseif entry.name then
                BBF.Print(string.format(L["Print_Removed_From_List"], entry.name .. " (" .. entry.id .. ")"))
            else
                BBF.Print(string.format(L["Print_Removed_ID_Not_Found"], entry.id))
            end
        else
            BBF.Print(string.format(L["Print_Removed_From_List"], entry.name))
        end

        BetterBlizzFramesDB[listName][key] = nil
    end

    BBF.currentSearchFilter = ""

    if SettingsPanel:IsShown() then
        if BBF[listName.."Refresh"] then
            BBF[listName.."Refresh"]()
        end
    else
        BBF[listName.."DelayedUpdate"] = BBF[listName.."Refresh"]
    end

    BBF.RefreshAllAuraFrames()
end

local lists = { "auraBlacklist", "auraWhitelist" }

for _, listName in ipairs(lists) do
    -- Create static popup dialogs for duplicate confirmations
    StaticPopupDialogs["BBF_DUPLICATE_NPC_CONFIRM_" .. listName] = {
        text = L["Dialog_Duplicate_Entry"],
        button1 = L["Yes"],
        button2 = L["No"],
        OnAccept = function()
            deleteEntry(listName, BBF.entryToDelete)  -- Delete the entry when "Yes" is clicked
        end,
        timeout = 0,
        whileDead = true,
    }

    -- Create static popup dialogs for delete confirmations
    StaticPopupDialogs["BBF_DELETE_NPC_CONFIRM_" .. listName] = {
        text = L["Dialog_Confirm_Delete"],
        button1 = L["Yes"],
        button2 = L["No"],
        OnAccept = function()
            deleteEntry(listName, BBF.entryToDelete)  -- Delete the entry when "Yes" is clicked
        end,
        timeout = 0,
        whileDead = true,
    }
end

StaticPopupDialogs["BBF_DUPLICATE_UPDATE_OR_DELETE"] = {
    text = L["Dialog_Duplicate_Blacklist"],
    button1 = L["Update_And_Always_Hide"],
    button2 = L["Delete_From_Blacklist"],
    OnAccept = function()
        BBF["auraBlacklist"](BBF.entryToDelete, "auraBlacklist", nil, true)  -- Update when accepted
    end,
    OnCancel = function()
        deleteEntry("auraBlacklist", BBF.entryToDelete)  -- Delete the entry when "Yes" is clicked
    end,
    timeout = 0,
    whileDead = true,
}


local function addOrUpdateEntry(inputText, listName, addShowMineTag, skipRefresh, color)
    BBF.entryToDelete = nil
    local name, comment = strsplit("/", inputText, 2)
    name = strtrim(name or "")
    comment = comment and strtrim(comment) or nil
    local id = tonumber(name)
    local printMsg
    local spellName
    local icon
    local iconString
    local _

    -- Check if there's a numeric ID within the name and clear the name if found
    if id then
        spellName, _, icon = BBF.TWWGetSpellInfo(id)
        name = spellName or ""

        if not spellName then
            BBF.Print(string.format(L["Print_No_Spell_Found"], id))
            return
        end

        if icon then
            iconString = "|T" .. icon .. ":16:16:0:0|t"
        else
            iconString = ""
        end

        -- Check if the spell is being added to blacklist or whitelist
        if listName == "auraBlacklist" then
            printMsg = iconString .. " " .. spellName .. " (" .. id .. ")" .. L["Print_Added_To_Blacklist_With_Icon"]
        elseif listName == "auraWhitelist" then
            printMsg = iconString .. " " .. spellName .. " (" .. id .. ")" .. L["Print_Added_To_Whitelist_With_Icon"]
        end
    end

    if (name ~= "" or id) then
        local key = id or string.lower(name)  -- Use id if available, otherwise use name
        local isDuplicate = false

        -- Directly check if the key already exists in the list
        if BetterBlizzFramesDB[listName][key] then
            if listName == "auraBlacklist" then
                local hasShowMineTag = BetterBlizzFramesDB[listName][key].showMine
                if addShowMineTag and not hasShowMineTag then
                    -- do nothing, adds tag
                elseif not addShowMineTag and hasShowMineTag then
                    -- do nothing, removes tag
                else
                    isDuplicate = true
                    BBF.entryToDelete = key  -- Use key to identify the duplicate
                    if addShowMineTag then
                        BBF.DuplicateWithTag = true
                    end
                end
            elseif listName == "auraWhitelist" then
                isDuplicate = true
                BBF.entryToDelete = key  -- Use key to identify the duplicate
            end
        end

        if isDuplicate then
            if BBF.DuplicateWithTag then
                StaticPopup_Show("BBF_DUPLICATE_UPDATE_OR_DELETE")
                BBF.DuplicateWithTag = nil
            else
                StaticPopup_Show("BBF_DUPLICATE_NPC_CONFIRM_" .. listName)
            end
        else
            -- Initialize the new entry with appropriate structure
            local newEntry = {
                name = name,
                id = id,
                comment = comment or nil,
            }

            if listName == "auraWhitelist" then
                newEntry = {name = name, id = id, comment = comment or nil, color = {0,1,0,1}}
            end

            -- if color then
            --     --newEntry.color = {1,0.501960813999176,0,1} -- offensive
            --     --newEntry.color = {1,0.6627451181411743,0.9450981020927429,1} -- defensive
            --     newEntry.color = {0,1,1,1} -- mobility
            --     --newEntry.color = {0,1,0,1} --muy importante
            --     newEntry.important = true
            --     newEntry.enlarged = true
            -- end

            -- If adding to auraBlacklist and addShowMineTag is true, set showMine to true
            if addShowMineTag and listName == "auraBlacklist" then
                newEntry.showMine = true
                if id then
                    printMsg = iconString .. " " .. spellName .. " (" .. id .. ")" .. L["Print_Added_To_Blacklist_With_Tag"]
                end
            end

            -- Add the new entry to the list using key
            BetterBlizzFramesDB[listName][key] = newEntry

            -- Update UI: Re-create text line button and refresh the list display
            if BBF["UpdateTextLine"..listName] then
                BBF["UpdateTextLine"..listName](newEntry, #BBF[listName.."TextLines"] + 1, BBF[listName.."ExtraBoxes"])
            end

            BBF.currentSearchFilter = ""

            if not skipRefresh then
                if BBF[listName.."Refresh"] then
                    BBF[listName.."Refresh"]()
                end
            else
                if SettingsPanel:IsShown() then
                    if BBF[listName.."Refresh"] then
                        BBF[listName.."Refresh"]()
                    end
                else
                    BBF[listName.."DelayedUpdate"] = BBF[listName.."Refresh"]
                end
            end

            if printMsg then
                BBF.Print(printMsg)
            end

        end
    end

    BBF.RefreshAllAuraFrames()
    if BBF[listName.."EditBox"] then
        BBF[listName.."EditBox"]:SetText("")  -- Clear the EditBox
    end
end
BBF["auraBlacklist"] = addOrUpdateEntry
BBF["auraWhitelist"] = addOrUpdateEntry







local function CreateList(subPanel, listName, listData, refreshFunc, extraBoxes, colorText, width, pos)
    -- Create the scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", nil, subPanel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(width or 322, 270)
    if not pos then
        scrollFrame:SetPoint("TOPLEFT", 10, -10)
    else
        scrollFrame:SetPoint("TOPLEFT", -48, -10)
    end

    -- Create the content frame
    local contentFrame = CreateFrame("Frame", nil, scrollFrame)
    contentFrame:SetSize(width or 322, 270)
    scrollFrame:SetScrollChild(contentFrame)

    local textLines = {}
    BBF[listName.."TextLines"] = textLines
    BBF[listName.."ExtraBoxes"] = extraBoxes
    local framePool = {}
    BBF.entryToDelete = nil
    BBF.currentSearchFilter = ""

    -- Function to update the background colors of the entries
    local function updateBackgroundColors()
        for i, button in ipairs(textLines) do
            local bg = button.bgImg
            if i % 2 == 0 then
                bg:SetColorTexture(0.3, 0.3, 0.3, 0.1)  -- Dark color for even lines
            else
                bg:SetColorTexture(0.3, 0.3, 0.3, 0.3)  -- Light color for odd lines
            end
        end
    end

    local function createOrUpdateTextLineButton(npc, index, extraBoxes)
        local button

        -- Reuse frame from the pool if available
        if framePool[index] then
            button = framePool[index]
            button:Show()
        else
            -- Create a new frame if pool is exhausted
            button = CreateFrame("Frame", nil, contentFrame)
            button:SetSize((width and width - 12) or (322 - 12), 20)
            button:SetPoint("TOPLEFT", 10, -(index - 1) * 20)

            -- Background
            local bg = button:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints()
            button.bgImg = bg  -- Store the background texture for later updates

            -- Icon
            local iconTexture = button:CreateTexture(nil, "OVERLAY")
            iconTexture:SetSize(20, 20)  -- Same height as the button
            iconTexture:SetPoint("LEFT", button, "LEFT", 0, 0)
            button.iconTexture = iconTexture

            -- Text
            local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetPoint("LEFT", button, "LEFT", 25, 0)
            button.text = text
            text:SetFont(fontSmall, 13)

            -- Delete Button
            local deleteButton = CreateFrame("Button", nil, button, "UIPanelButtonTemplate")
            deleteButton:SetSize(20, 20)
            deleteButton:SetPoint("RIGHT", button, "RIGHT", 4, 0)
            deleteButton:SetText("X")
            deleteButton:SetScript("OnClick", function()
                if IsShiftKeyDown() then
                    deleteEntry(listName, button.npcData.id or button.npcData.name:lower())
                else
                    BBF.entryToDelete = button.npcData.id or button.npcData.name:lower()
                    StaticPopup_Show("BBF_DELETE_NPC_CONFIRM_" .. listName)
                end
            end)
            button.deleteButton = deleteButton

            -- Save button to the pool
            framePool[index] = button
        end

        -- Update button's content
        button.npcData = npc
        local displayText
        if npc.id then
            displayText = string.format("%s (%d)", (npc.name or C_Spell.GetSpellName(npc.id) or "Name Missing"), npc.id)  -- Display as "Name (id)"
        else
            displayText = npc.name  -- Display just the name if there's no id
        end
        button.text:SetText(displayText)
        button.iconTexture:SetTexture(C_Spell.GetSpellTexture(npc.id or npc.name))

        -- Function to set text color
        local function SetTextColor(r, g, b, a)
            if colorText and button.checkBoxI and button.checkBoxI:GetChecked() then
                button.text:SetTextColor(r or 1, g or 1, b or 0, a or 1)
            else
                button.text:SetTextColor(1, 1, 0, 1)
            end
        end

        -- Function to set important box color
        local function SetImportantBoxColor(r, g, b, a)
            if button.checkBoxI then
                if button.checkBoxI:GetChecked() then
                    button.checkBoxI.texture:SetVertexColor(r or 0, g or 1, b or 0, a or 1)
                else
                    button.checkBoxI.texture:SetVertexColor(0, 1, 0, 1)
                end
            end
        end

        -- Initialize colors based on npc data
        local entryColors = npc.color or {1, 0.8196, 0, 1}  -- Default yellowish color 
        

        -- Extra logic for handling additional checkboxes and flags
        if extraBoxes then
            -- CheckBox for Pandemic
            if not button.checkBoxP then
                local checkBoxP = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
                checkBoxP:SetSize(24, 24)
                checkBoxP:SetPoint("RIGHT", button.deleteButton, "LEFT", 4, 0)
                checkBoxP:SetScript("OnClick", function(self)
                    button.npcData.pandemic = self:GetChecked() and true or nil
                    BBF.RefreshAllAuraFrames()
                end)
                checkBoxP.texture = checkBoxP:CreateTexture(nil, "ARTWORK", nil, 1)
                checkBoxP.texture:SetAtlas("newplayertutorial-drag-slotgreen")
                checkBoxP.texture:SetDesaturated(true)
                checkBoxP.texture:SetVertexColor(1, 0, 0)
                checkBoxP.texture:SetSize(27, 27)
                checkBoxP.texture:SetPoint("CENTER", checkBoxP, "CENTER", -0.5, 0.5)
                button.checkBoxP = checkBoxP
                local isWarlock = playerClass == "WARLOCK"
                local extraText = isWarlock and L["Tooltip_Pandemic_Glow_Warlock_Extra"] or ""
                CreateTooltipTwo(checkBoxP, L["Pandemic_Glow_Icon"], L["Tooltip_Pandemic_Glow"]..extraText, L["Tooltip_Pandemic_Extra"], "ANCHOR_TOPRIGHT")
            end
            button.checkBoxP:SetChecked(button.npcData.pandemic)
    
            -- CheckBox for Important with color picker
            if not button.checkBoxI then
                local checkBoxI = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
                checkBoxI:SetSize(24, 24)
                checkBoxI:SetPoint("RIGHT", button.checkBoxP, "LEFT", 4, 0)
                checkBoxI:SetScript("OnClick", function(self)
                    button.npcData.important = self:GetChecked() and true or nil
                    BBF.RefreshAllAuraFrames()
                    SetImportantBoxColor(button.npcData.color[1], button.npcData.color[2], button.npcData.color[3], button.npcData.color[4])
                    SetTextColor(button.npcData.color[1], button.npcData.color[2], button.npcData.color[3], button.npcData.color[4])
                end)
                checkBoxI.texture = checkBoxI:CreateTexture(nil, "ARTWORK", nil, 1)
                checkBoxI.texture:SetAtlas("newplayertutorial-drag-slotgreen")
                checkBoxI.texture:SetSize(27, 27)
                checkBoxI.texture:SetDesaturated(true)
                checkBoxI.texture:SetPoint("CENTER", checkBoxI, "CENTER", -0.5, 0.5)
                button.checkBoxI = checkBoxI
                CreateTooltipTwo(checkBoxI, L["Important_Glow_Icon"], L["Tooltip_Important_Glow"], L["Tooltip_Important_Extra"], "ANCHOR_TOPRIGHT")
            end
            button.checkBoxI:SetChecked(button.npcData.important)
    
            -- Color picker logic
            local function OpenColorPicker(isAll)
                BBF.needsUpdate = true

                -- one-time hook for OK/Cancel to run bulk recolor
                if isAll and not BBF._allColorHook then
                    BBF._allColorHook = true
                    local okBtn     = ColorPickerFrame.Footer and ColorPickerFrame.Footer.OkayButton
                    local cancelBtn = ColorPickerFrame.Footer and ColorPickerFrame.Footer.CancelButton
                    if okBtn then
                        okBtn:HookScript("OnClick", function()
                            if BBF._allColorActive and BBF._allColorPending then
                                local p = BBF._allColorPending
                                RecolorEntireAuraWhitelist(p.r, p.g, p.b, p.a)
                            end
                            BBF._allColorActive  = false
                            BBF._allColorPending = nil
                        end)
                    end
                    if cancelBtn then
                        cancelBtn:HookScript("OnClick", function()
                            BBF._allColorActive  = false
                            BBF._allColorPending = nil
                        end)
                    end
                end

                BBF._allColorActive  = isAll or false
                BBF._allColorPending = nil

                -- set OK button label
                local okBtn = ColorPickerFrame.Footer and ColorPickerFrame.Footer.OkayButton
                if okBtn then
                    if not BBF._colorPickerOkText then
                        BBF._colorPickerOkText = okBtn:GetText()
                    end
                    okBtn:SetText(isAll and L["Color_ALL_Auras"] or BBF._colorPickerOkText)
                end

                -- entryColors is the per-row array table (entry.color). Ensure table exists.
                entryColors = entryColors or {}
                if type(entryColors) ~= "table" then entryColors = {} end
                local r = entryColors[1] or 1
                local g = entryColors[2] or 1
                local b = entryColors[3] or 1
                local a = entryColors[4] or 1
                local backup = { r = r, g = g, b = b, a = a }

                local function updateRowPreview()
                    entryColors[1], entryColors[2], entryColors[3], entryColors[4] = r, g, b, a
                    SetTextColor(r, g, b, a)
                    SetImportantBoxColor(r, g, b, a)
                    BBF.RefreshAllAuraFrames()
                    if ColorPickerFrame.Content and ColorPickerFrame.Content.ColorSwatchCurrent then
                        ColorPickerFrame.Content.ColorSwatchCurrent:SetAlpha(a)
                    end
                    BBF.auraListNeedsUpdate = true
                    if isAll then BBF._allColorPending = { r = r, g = g, b = b, a = a } end
                end

                local function swatchFunc()
                    r, g, b = ColorPickerFrame:GetColorRGB()
                    updateRowPreview()
                end

                local function opacityFunc()
                    a = ColorPickerFrame:GetColorAlpha()
                    updateRowPreview()
                end

                local function cancelFunc()
                    r, g, b, a = backup.r, backup.g, backup.b, backup.a
                    updateRowPreview()
                    BBF._allColorActive  = false
                    BBF._allColorPending = nil
                end

                ColorPickerFrame.previousValues = { r = r, g = g, b = b, a = a }
                ColorPickerFrame:SetupColorPickerAndShow({
                    r = r, g = g, b = b, opacity = a, hasOpacity = true,
                    swatchFunc = swatchFunc, opacityFunc = opacityFunc, cancelFunc = cancelFunc
                })

                updateRowPreview()
            end

            button.checkBoxI:SetScript("OnMouseDown", function(self, button)
                if button ~= "RightButton" then return end
                local isAll = IsControlKeyDown() and IsAltKeyDown()
                OpenColorPicker(isAll)
            end)

            -- CheckBox for Compacted
            if not button.checkBoxC then
                local checkBoxC = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
                checkBoxC:SetSize(24, 24)
                checkBoxC:SetPoint("RIGHT", button.checkBoxI, "LEFT", 3, 0)
                button.checkBoxC = checkBoxC
                CreateTooltipTwo(checkBoxC, L["Compacted_Aura_Icon"], L["Tooltip_Compacted_Aura"], L["Tooltip_Pandemic_Extra"], "ANCHOR_TOPRIGHT")
            end
            button.checkBoxC:SetChecked(button.npcData.compacted)
    
            -- CheckBox for Enlarged
            if not button.checkBoxE then
                local checkBoxE = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
                checkBoxE:SetSize(24, 24)
                checkBoxE:SetPoint("RIGHT", button.checkBoxC, "LEFT", 3, 0)
                checkBoxE:SetScript("OnClick", function(self)
                    button.npcData.enlarged = self:GetChecked() and true or nil
                    button.checkBoxC:SetChecked(false)
                    button.npcData.compacted = false
                    BBF.RefreshAllAuraFrames()
                end)
                button.checkBoxC:SetScript("OnClick", function(self)
                    button.npcData.compacted = self:GetChecked() and true or nil
                    button.checkBoxE:SetChecked(false)
                    button.npcData.enlarged = false
                    BBF.RefreshAllAuraFrames()
                end)
                CreateTooltipTwo(checkBoxE, L["Enlarged_Aura_Icon"], L["Tooltip_Enlarged_Aura"], L["Tooltip_Pandemic_Extra"], "ANCHOR_TOPRIGHT")
                button.checkBoxE = checkBoxE
            end
            button.checkBoxE:SetChecked(button.npcData.enlarged)
    
            -- CheckBox for "Only Mine"
            if not button.checkBoxOnlyMine then
                local checkBoxOnlyMine = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
                checkBoxOnlyMine:SetSize(24, 24)
                checkBoxOnlyMine:SetPoint("RIGHT", button.checkBoxE, "LEFT", 3, 0)
                checkBoxOnlyMine:SetScript("OnClick", function(self)
                    button.npcData.onlyMine = self:GetChecked() and true or nil
                    BBF.RefreshAllAuraFrames()
                end)
                button.checkBoxOnlyMine = checkBoxOnlyMine
                CreateTooltipTwo(checkBoxOnlyMine, L["Only_My_Aura_Icon"], L["Tooltip_Only_My_Aura"], nil, "ANCHOR_TOPRIGHT")
            end
            button.checkBoxOnlyMine:SetChecked(button.npcData.onlyMine)
        end

        if listName == "auraBlacklist" then
            if not button.checkBoxShowMine then
                -- Create Checkbox Only Mine if not already created
                local checkBoxShowMine = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
                checkBoxShowMine:SetSize(24, 24)
                checkBoxShowMine:SetPoint("RIGHT", button, "RIGHT", -13, 0)
                CreateTooltipTwo(checkBoxShowMine, L["Show_Mine_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-FriendOnlineIcon:22:22|a", L["Tooltip_Show_Mine"], nil, "ANCHOR_TOPRIGHT")

                -- Handler for the show mine checkbox
                checkBoxShowMine:SetScript("OnClick", function(self)
                    button.npcData.showMine = self:GetChecked() and true or nil
                    BBF.RefreshAllAuraFrames()
                end)

                -- Adjust text width and settings
                button.text:SetWidth(196)
                button.text:SetWordWrap(false)
                button.text:SetJustifyH("LEFT")

                -- Save the reference to the button
                button.checkBoxShowMine = checkBoxShowMine
            end
            button.checkBoxShowMine:SetChecked(button.npcData.showMine)
        end

        if button.checkBoxI then
            if button.checkBoxI:GetChecked() then
                SetImportantBoxColor(entryColors[1], entryColors[2], entryColors[3], entryColors[4])
                SetTextColor(entryColors[1], entryColors[2], entryColors[3], entryColors[4])
            else
                SetImportantBoxColor(0, 1, 0, 1)
                SetTextColor(1, 0.8196, 0, 1)
            end
        end

        if npc.id and not button.idTip then
            button:SetScript("OnEnter", function(self)
                if not button.npcData.id then return end
                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                GameTooltip:SetSpellByID(button.npcData.id)
                GameTooltip:AddLine(L["Tooltip_Spell_ID"] .. button.npcData.id, 1, 1, 1)
                GameTooltip:Show()
            end)
            button:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            button.idTip = true
        end

        -- Update background colors
        updateBackgroundColors()

        return button
    end
    BBF["UpdateTextLine"..listName] = createOrUpdateTextLineButton

    local editBox = CreateFrame("EditBox", nil, subPanel, "InputBoxTemplate")
    editBox:SetSize((width and width - 62) or (322 - 62), 19)
    editBox:SetPoint("TOP", scrollFrame, "BOTTOM", -15, -5)
    editBox:SetAutoFocus(false)
    BBF[listName.."EditBox"] = editBox
    CreateTooltipTwo(editBox, L["Filter_Auras"], L["Tooltip_Filter_Auras"], nil, "ANCHOR_TOP")

    local function cleanUpEntry(entry)
        -- Iterate through each field in the entry
        for key, value in pairs(entry) do
            if value == false then
                entry[key] = nil
            end
        end
    end

    local function getSortedNpcList()
        local sortableNpcList = {}

        -- Iterate over the structure using pairs to access all entries
        local safeFilter = BBF.currentSearchFilter:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
        for key, entry in pairs(listData) do
            cleanUpEntry(entry)
            -- Apply the search filter
            if BBF.currentSearchFilter == "" or (entry.name and entry.name:lower():match(safeFilter)) or (entry.id and tostring(entry.id):match(safeFilter)) then
                table.insert(sortableNpcList, entry)
            end
        end

        -- Sort the list alphabetically by the 'name' field, and then by 'id' if the names are the same
        table.sort(sortableNpcList, function(a, b)
            local nameA = a.name and a.name:lower() or ""
            local nameB = b.name and b.name:lower() or ""

            -- First, compare by name
            if nameA ~= nameB then
                return nameA < nameB
            end

            -- If names are the same, compare by id (sort low to high)
            local idA = a.id or math.huge
            local idB = b.id or math.huge
            return idA < idB
        end)

        return sortableNpcList
    end

    -- Function to update the list with batching logic
    local function refreshList()
        if true then return end
        local sortedListData = getSortedNpcList()
        local totalEntries = #sortedListData
        local batchSize = 35  -- Number of entries to process per frame
        local currentIndex = 1

        local function processNextBatch()
            for i = currentIndex, math.min(currentIndex + batchSize - 1, totalEntries) do
                local npc = sortedListData[i]
                local button = createOrUpdateTextLineButton(npc, i, extraBoxes)
                textLines[i] = button
            end

            -- Hide any extra frames
            for i = totalEntries + 1, #framePool do
                if framePool[i] then
                    framePool[i]:Hide()
                end
            end

            -- Update the content frame height
            contentFrame:SetHeight(totalEntries * 20)
            updateBackgroundColors()

            -- Continue processing if there are more entries
            currentIndex = currentIndex + batchSize
            if currentIndex <= totalEntries then
                C_Timer.After(0.04, processNextBatch)  -- Defer to the next frame
            end
        end
        -- Start processing in the first frame
        processNextBatch()
    end

    contentFrame.refreshList = refreshList
    refreshList()
    --BBF[listName.."DelayedUpdate"] = refreshList
    BBF[listName.."Refresh"] = refreshList
    --BBF.auraWhitelist & BBF.auraBlacklist

    editBox:SetScript("OnEnterPressed", function(self)
        addOrUpdateEntry(self:GetText(), listName)
    end)

        -- Function to search and filter the list
        local function searchList(searchText)
            BBF.currentSearchFilter = searchText:lower()
            refreshList()
        end

        -- Update the list as the user types
        editBox:SetScript("OnTextChanged", function(self, userInput)
            if userInput then
                searchList(self:GetText())
            end
        end, true)

    local addButton = CreateFrame("Button", nil, subPanel, "UIPanelButtonTemplate")
    addButton:SetSize(60, 24)
    addButton:SetText(L["Add"])
    addButton:SetPoint("LEFT", editBox, "RIGHT", 10, 0)
    addButton:SetScript("OnClick", function()
        addOrUpdateEntry(editBox:GetText(), listName)
    end)
    scrollFrame:HookScript("OnShow", function()
        if BBF.auraWhitelistDelayedUpdate then
            BBF.auraWhitelistDelayedUpdate()
            BBF.auraWhitelistDelayedUpdate = nil
        end
        if BBF.auraBlacklistDelayedUpdate then
            BBF.auraBlacklistDelayedUpdate()
            BBF.auraBlacklistDelayedUpdate = nil
        end
    end)
    return scrollFrame
end

SettingsPanel:HookScript("OnShow", function()
    if BBF.auraWhitelistDelayedUpdate then
        BBF.auraWhitelistDelayedUpdate()
        BBF.auraWhitelistDelayedUpdate = nil
    end
    if BBF.auraBlacklistDelayedUpdate then
        BBF.auraBlacklistDelayedUpdate()
        BBF.auraBlacklistDelayedUpdate = nil
    end
end)

local function CreateCDManagerList(parent)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    local width, height = 450, 510
    scrollFrame:SetSize(width, height)
    scrollFrame:SetPoint("TOPLEFT", 185, -14)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(width, height)
    scrollFrame:SetScrollChild(content)

    local spellText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    spellText:SetPoint("BOTTOMLEFT", scrollFrame, "TOPLEFT", 10, 3)
    spellText:SetText(L["Spell"])

    local priorityText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    priorityText:SetPoint("BOTTOMLEFT", scrollFrame, "TOP", 95, 3)
    priorityText:SetText(L["Priority"])

    local blacklistIcon = parent:CreateTexture(nil, "OVERLAY")
    blacklistIcon:SetAtlas("lootroll-toast-icon-pass-up")
    blacklistIcon:SetPoint("BOTTOM", scrollFrame, "TOPRIGHT", -29, 1)
    blacklistIcon:SetSize(22, 22)
    CreateTooltip(blacklistIcon, L["Tooltip_Hide_Spell_Icon"] .. " |A:lootroll-toast-icon-pass-up:22:22|a")

    local framePool = {}

    local function refreshList()
        local baseSpells = {}
        local blacklist = BetterBlizzFramesDB.cdManagerBlacklist or {}
        local priorityList = BetterBlizzFramesDB.cdManagerPriorityList or {}

        for _, id in ipairs(BBF.cooldownManagerSpells or {}) do
            baseSpells[id] = true
        end

        local fullList = {}
        for _, id in ipairs(BBF.cooldownManagerSpells or {}) do table.insert(fullList, id) end
        for idStr, _ in pairs(blacklist) do
            local id = tonumber(idStr)
            if id and not baseSpells[id] then
                table.insert(fullList, id)
            end
        end
        for idStr, _ in pairs(priorityList) do
            local id = tonumber(idStr)
            if id and not baseSpells[id] then
                table.insert(fullList, id)
            end
        end

        for i, button in ipairs(framePool) do button:Hide() end

        for i, spellID in ipairs(fullList) do
            local info = C_Spell.GetSpellInfo(spellID)
            if info then
                local name = info.name
                local icon = info.iconID or info.originalIconID
                local isCustom = not baseSpells[spellID]

                local button = framePool[i]
                if not button then
                    button = CreateFrame("Frame", nil, content)
                    button:SetSize(width - 12, 20)
                    button:SetPoint("TOPLEFT", 10, -(i - 1) * 20)

                    local bg = button:CreateTexture(nil, "BACKGROUND")
                    bg:SetAllPoints()
                    button.bg = bg

                    local iconTex = button:CreateTexture(nil, "ARTWORK")
                    iconTex:SetSize(20, 20)
                    iconTex:SetPoint("LEFT")
                    button.iconTex = iconTex

                    local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                    label:SetPoint("LEFT", iconTex, "RIGHT", 5, 0)
                    button.label = label

                    local checkbox = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
                    checkbox:SetSize(24, 24)
                    checkbox:SetPoint("RIGHT", button, "RIGHT", -15, 0)
                    CreateTooltipTwo(checkbox, L["Hide_Spell_Icon"], L["Tooltip_Hide_Spell_Icon_CD"], nil, "ANCHOR_TOPRIGHT")
                    button.checkbox = checkbox

                    local slider = CreateFrame("Slider", nil, button, "OptionsSliderTemplate")
                    slider:SetSize(80, 16)
                    slider:SetPoint("RIGHT", checkbox, "LEFT", -20, 0)
                    slider:SetMinMaxValues(0, 20)
                    slider:SetValueStep(1)
                    slider:SetObeyStepOnDrag(true)
                    slider.Low:SetText("")
                    slider.High:SetText("")
                    CreateTooltipTwo(slider, L["Priority_Value"], L["Tooltip_Priority"], nil, "ANCHOR_TOPRIGHT")
                    button.slider = slider

                    local text = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                    text:SetPoint("RIGHT", slider, "LEFT", -5, 0)
                    button.sliderText = text

                    local del = CreateFrame("Button", nil, button, "UIPanelButtonTemplate")
                    del:SetSize(18, 18)
                    del:SetText("X")
                    del:SetPoint("RIGHT", button, "RIGHT", 0, 0)
                    button.del = del
                    CreateTooltipTwo(del, L["Delete"], L["Tooltip_Delete"])

                    framePool[i] = button
                end

                button.iconTex:SetTexture(icon)
                button.label:SetText(name .. " (" .. spellID .. ")")

                local isBlacklisted = BetterBlizzFramesDB.cdManagerBlacklist[spellID]
                local priority = BetterBlizzFramesDB.cdManagerPriorityList[spellID]

                button.checkbox:SetChecked(isBlacklisted or false)
                if isBlacklisted then
                    button.slider:Disable()
                    button.slider:SetAlpha(0.3)
                else
                    button.slider:Enable()
                    button.slider:SetAlpha(1)
                end

                local value = priority or 0
                button.slider:SetValue(value)
                button.sliderText:SetText(value)
                if value == 0 then
                    button.slider:SetAlpha(0.3)
                else
                    button.slider:SetAlpha(1)
                end

                button.checkbox:SetScript("OnClick", function(self)
                    if self:GetChecked() then
                        BetterBlizzFramesDB.cdManagerBlacklist[spellID] = true
                        BetterBlizzFramesDB.cdManagerPriorityList[spellID] = nil
                    else
                        BetterBlizzFramesDB.cdManagerBlacklist[spellID] = false
                    end
                    refreshList()
                    BBF.ResetCooldownManagerIcons()
                    BBF.RefreshCooldownManagerIcons()
                end)

                button.slider:SetScript("OnValueChanged", function(self, value)
                    local v = math.floor(value + 0.5)
                    self:SetValue(v)
                    button.sliderText:SetText(v)

                    if v == 0 then
                        BetterBlizzFramesDB.cdManagerPriorityList[spellID] = nil
                        self:SetAlpha(0.3)
                    else
                        BetterBlizzFramesDB.cdManagerPriorityList[spellID] = v
                        self:SetAlpha(1)
                    end

                    BBF.RefreshCooldownManagerIcons()
                end)

                if isCustom then
                    button.del:SetScript("OnClick", function()
                        BetterBlizzFramesDB.cdManagerBlacklist[spellID] = nil
                        BetterBlizzFramesDB.cdManagerPriorityList[spellID] = nil
                        refreshList()
                        BBF.RefreshCooldownManagerIcons()
                    end)
                    button.del:Show()
                else
                    button.del:Hide()
                end

                button.bg:SetColorTexture(0.2, 0.2, 0.2, i % 2 == 0 and 0.1 or 0.3)
                button:Show()
            end
        end

        local input = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
        input:SetSize(width-50, 20)
        input:SetPoint("TOPLEFT", scrollFrame, "BOTTOMLEFT", 15, -8)
        input:SetAutoFocus(false)
        CreateTooltipTwo(input, L["Enter_Spell_ID"], L["Tooltip_Enter_Spell"], L["Tooltip_Enter_Spell_Note"], "ANCHOR_TOP")

        function BBF.AddCDManagerSpellEntry(inputText, refreshList)
            if not inputText or inputText == "" then return end

            local id = tonumber(inputText)
            local info = C_Spell.GetSpellInfo(id or inputText)

            if info and info.spellID then
                local spellID = info.spellID
                if not BetterBlizzFramesDB.cdManagerPriorityList[spellID] and not BetterBlizzFramesDB.cdManagerBlacklist[spellID] then
                    BetterBlizzFramesDB.cdManagerBlacklist[spellID] = false
                    refreshList()
                    BBF.RefreshCooldownManagerIcons()
                end
            elseif not id then -- if it's not a number and didn't resolve to a spell, treat it as a raw name
                if not BetterBlizzFramesDB.cdManagerPriorityList[inputText] and not BetterBlizzFramesDB.cdManagerBlacklist[inputText] then
                    BetterBlizzFramesDB.cdManagerBlacklist[inputText] = false
                    refreshList()
                    BBF.RefreshCooldownManagerIcons()
                end
            else
                BBF.Print(string.format(L["Print_Invalid_Spell_ID"], inputText))
            end
        end

        input:SetScript("OnEnterPressed", function(self)
            BBF.AddCDManagerSpellEntry(self:GetText(), refreshList)
            self:SetText("")
        end)

        local add = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
        add:SetSize(50, 22)
        add:SetText(L["Add"])
        add:SetPoint("LEFT", input, "RIGHT", 6, 0)

        add:SetScript("OnClick", function()
            BBF.AddCDManagerSpellEntry(input:GetText(), refreshList)
            input:SetText("")
        end)

        content:SetHeight(#fullList * 22)
    end

    scrollFrame:HookScript("OnShow", function()
        if BBF.cdManagerNeedsUpdate then
            refreshList()
        end
    end)

    scrollFrame.Refresh = refreshList
    BBF.RefreshCdManagerList = refreshList
    BBF.cdManagerScrollFrame = scrollFrame

    refreshList()
    return scrollFrame
end



local function CreateTitle(parent)
    local mainGuiAnchor = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor:SetPoint("TOPLEFT", 15, -15)
    mainGuiAnchor:SetText(" ")
    local addonNameText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    addonNameText:SetPoint("TOPLEFT", mainGuiAnchor, "TOPLEFT", -20, 47)
    addonNameText:SetText("BetterBlizzFrames")
    local addonNameIcon = parent:CreateTexture(nil, "ARTWORK")
    addonNameIcon:SetAtlas("gmchat-icon-blizz")
    addonNameIcon:SetSize(22, 22)
    addonNameIcon:SetPoint("LEFT", addonNameText, "RIGHT", -2, -1)
    local verNumber = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    verNumber:SetPoint("LEFT", addonNameText, "RIGHT", 25, 0)
    verNumber:SetText(BBF.VersionNumber)
end

local function CreateSearchFrame()
    local searchFrame = CreateFrame("Frame", "BBFSearchFrame", UIParent)
    searchFrame:SetSize(680, 610)
    searchFrame:SetPoint("CENTER", UIParent, "CENTER")
    searchFrame:SetFrameStrata("HIGH")
    searchFrame:Hide()

    local wipText = searchFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    wipText:SetPoint("BOTTOM", searchFrame, "BOTTOM", -10, 10)
    wipText:SetText(L["Search_WIP"])

    CreateTitle(searchFrame)

    local bgImg = searchFrame:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", searchFrame, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0, 0, 0)

    local settingsText = searchFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    settingsText:SetPoint("TOPLEFT", searchFrame, "TOPLEFT", 20, 0)
    settingsText:SetText(L["Search_Results"])

    -- Icon next to the title
    local searchIcon = searchFrame:CreateTexture(nil, "ARTWORK")
    searchIcon:SetAtlas("communities-icon-searchmagnifyingglass")
    searchIcon:SetSize(28, 28)
    searchIcon:SetPoint("RIGHT", settingsText, "LEFT", -3, -1)

    -- Reference the existing SettingsPanel.SearchBox to copy properties
    local referenceBox = SettingsPanel.SearchBox

    -- Create the search input field on top of SettingsPanel.SearchBox
    local searchBox = CreateFrame("EditBox", nil, SettingsPanel, "InputBoxTemplate")
    searchBox:SetSize(referenceBox:GetWidth() + 1, referenceBox:GetHeight() + 1)
    searchBox:SetPoint("CENTER", referenceBox, "CENTER")
    searchBox:SetFrameStrata("HIGH")
    searchBox:SetAutoFocus(false)
    searchBox.Left:Hide()
    searchBox.Right:Hide()
    searchBox.Middle:Hide()
    searchBox:SetFontObject(referenceBox:GetFontObject())
    searchBox:SetTextInsets(16, 8, 0, 0)
    searchBox:Hide()
    searchBox:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
    end)
    CreateTooltipTwo(searchBox, L["Search"], L["Tooltip_Search_Desc"], nil, "TOP")

    local resultsList = CreateFrame("Frame", nil, searchFrame)
    resultsList:SetSize(640, 500)
    resultsList:SetPoint("TOP", settingsText, "BOTTOM", 0, -10)

    local checkboxPool = {}
    local sliderPool = {}

    local function SearchElements(query)
        for _, child in ipairs({resultsList:GetChildren()}) do
            child:Hide()
        end

        if query == "" then
            return
        end

        -- Convert the query into lowercase and split it into individual words
        query = string.lower(query)
        local queryWords = { strsplit(" ", query) }

        local checkboxCount = 0
        local sliderCount = 0
        local yOffsetCheckbox = -20  -- Starting position for the first checkbox
        local yOffsetSlider = -20    -- Starting position for the first slider

        -- Helper function to check if all query words are in the label
        local function matchesQuery(label)
            label = string.lower(label)
            for _, queryWord in ipairs(queryWords) do
                if not string.find(label, queryWord) then
                    return false
                end
            end
            return true
        end

        local function applyRightClickScript(searchCheckbox, originalCheckbox)
            local originalScript = originalCheckbox:GetScript("OnMouseDown")
            if originalScript then
                searchCheckbox:SetScript("OnMouseDown", function(self, button)
                    if button == "RightButton" then
                        originalScript(originalCheckbox, button)
                    end
                end)
            end
        end

        -- Search through checkboxes
        for _, data in ipairs(checkBoxList) do
            if checkboxCount >= 20 then break end

            -- Prepare the label and tooltip text
            local label = string.lower(data.label or "")
            local tooltipTitle = string.lower(data.checkbox.tooltipTitle or "")
            local tooltipMainText = string.lower(data.checkbox.tooltipMainText or "")
            local tooltipSubText = string.lower(data.checkbox.tooltipSubText or "")
            local tooltipCVarName = string.lower(data.checkbox.tooltipCVarName or "")

            -- Check if all query words are found in any of the searchable fields
            if matchesQuery(label) or matchesQuery(tooltipTitle) or matchesQuery(tooltipMainText) or matchesQuery(tooltipSubText) or matchesQuery(tooltipCVarName) then
                checkboxCount = checkboxCount + 1

                -- Re-use or create a new checkbox from the pool
                local resultCheckBox = checkboxPool[checkboxCount]
                if not resultCheckBox then
                    resultCheckBox = CreateFrame("CheckButton", nil, resultsList, "InterfaceOptionsCheckButtonTemplate")
                    resultCheckBox:SetSize(23, 23)
                    resultCheckBox.Text:SetFont(fontSmall, 12)
                    checkboxPool[checkboxCount] = resultCheckBox
                end

                -- Update checkbox properties and position
                resultCheckBox:ClearAllPoints()
                resultCheckBox:SetPoint("TOPLEFT", searchIcon, "TOPLEFT", 27, yOffsetCheckbox)
                resultCheckBox.Text:SetText(data.label)
                if not data.label or data.label == "" then
                    resultCheckBox.Text:SetText(data.checkbox.tooltipTitle)
                end
                resultCheckBox:SetChecked(data.checkbox:GetChecked())

                -- Link the result checkbox to the main checkbox
                resultCheckBox:SetScript("OnClick", function()
                    data.checkbox:Click()
                end)

                applyRightClickScript(resultCheckBox, data.checkbox)

                -- Reapply tooltip
                if data.checkbox.tooltipMainText then
                    CreateTooltipTwo(resultCheckBox, data.checkbox.tooltipTitle, data.checkbox.tooltipMainText, data.checkbox.tooltipSubText, nil, data.checkbox.tooltipCVarName, nil, data.checkbox.searchCategory)
                elseif data.checkbox.tooltipTitle then
                    CreateTooltipTwo(resultCheckBox, data.checkbox.tooltipTitle, nil, nil, nil, nil, nil, data.checkbox.searchCategory)
                else
                    CreateTooltipTwo(resultCheckBox, L["No_data_yet_WIP"], nil, nil, nil, nil, nil, data.checkbox.searchCategory)
                end

                resultCheckBox:Show()

                -- Move down for the next checkbox
                yOffsetCheckbox = yOffsetCheckbox - 24
            end
        end

        -- Search through sliders
        for _, data in ipairs(sliderList) do
            if sliderCount >= 13 then break end

            -- Prepare the label and tooltip text
            local label = string.lower(data.label or "")
            local tooltipTitle = string.lower(data.slider.tooltipTitle or "")
            local tooltipMainText = string.lower(data.slider.tooltipMainText or "")
            local tooltipSubText = string.lower(data.slider.tooltipSubText or "")
            local tooltipCVarName = string.lower(data.slider.tooltipCVarName or "")

            -- Check if all query words are found in any of the searchable fields
            if matchesQuery(label) or matchesQuery(tooltipTitle) or matchesQuery(tooltipMainText) or matchesQuery(tooltipSubText) or matchesQuery(tooltipCVarName) then
                sliderCount = sliderCount + 1

                -- Re-use or create a new slider from the slider pool
                local resultSlider = sliderPool[sliderCount]
                if not resultSlider then
                    resultSlider = CreateFrame("Slider", nil, resultsList, "OptionsSliderTemplate")
                    resultSlider:SetOrientation('HORIZONTAL')
                    resultSlider:SetValueStep(data.slider:GetValueStep())
                    resultSlider:SetObeyStepOnDrag(true)
                    resultSlider.Text = resultSlider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                    resultSlider.Text:SetTextColor(1, 0.81, 0, 1)
                    resultSlider.Text:SetFont(fontSmall, 11)
                    resultSlider.Text:SetPoint("TOP", resultSlider, "BOTTOM", 0, -1)
                    resultSlider.Low:SetText(" ")
                    resultSlider.High:SetText(" ")
                    sliderPool[sliderCount] = resultSlider
                end

                -- Format the slider text value
                local function formatSliderValue(value)
                    return value % 1 == 0 and tostring(math.floor(value)) or string.format("%.2f", value)
                end

                -- Update slider properties and position
                resultSlider:ClearAllPoints()
                resultSlider:SetPoint("TOPLEFT", searchIcon, "TOPLEFT", 277, yOffsetSlider)
                resultSlider:SetScript("OnValueChanged", nil)
                resultSlider:SetMinMaxValues(data.slider:GetMinMaxValues())
                resultSlider:SetValue(data.slider:GetValue())
                resultSlider.Text:SetText(data.label .. ": " .. formatSliderValue(data.slider:GetValue()))

                resultSlider:SetScript("OnValueChanged", function(self, value)
                    data.slider:SetValue(value) -- Trigger the original slider's script
                    resultSlider.Text:SetText(data.label .. ": " .. formatSliderValue(value))
                end)

                -- Tooltip setup for sliders
                if data.slider.tooltipMainText then
                    CreateTooltipTwo(resultSlider, data.slider.tooltipTitle, data.slider.tooltipMainText, data.slider.tooltipSubText, nil, data.slider.tooltipCVarName, nil, data.slider.searchCategory)
                elseif data.slider.tooltipTitle then
                    CreateTooltipTwo(resultSlider, data.slider.tooltipTitle, nil, nil, nil, nil, nil, data.slider.searchCategory)
                else
                    CreateTooltipTwo(resultSlider, L["No_data_yet_WIP"], nil, nil, nil, nil, nil, data.slider.searchCategory)
                end

                -- Show the slider and prepare for the next slider
                resultSlider:Show()
                yOffsetSlider = yOffsetSlider - 42
            end
        end
    end

    searchBox:SetScript("OnTextChanged", function(self)
        local query = self:GetText()
        if #query > 0 then
            SettingsPanelSearchIcon:SetVertexColor(1, 1, 1)
            SettingsPanel.SearchBox.Instructions:SetAlpha(0)
            searchFrame:Show()
            if SettingsPanel.currentLayout and SettingsPanel.currentLayout.frame then
                SettingsPanel.currentLayout.frame:Hide()
            end
        else
            SettingsPanelSearchIcon:SetVertexColor(0.6, 0.6, 0.6)
            SettingsPanel.SearchBox.Instructions:SetAlpha(1)
            searchFrame:Hide()
            if SettingsPanel.currentLayout and SettingsPanel.currentLayout.frame then
                SettingsPanel.currentLayout.frame:Show()
            end
        end
        if #query >= 1 then
            SearchElements(query)
        else
            SearchElements("")
        end

        if not searchBox.hookedSettings then
            SettingsPanel:HookScript("OnHide", function()
                SettingsPanelSearchIcon:SetVertexColor(0.6, 0.6, 0.6)
                SettingsPanel.SearchBox.Instructions:SetAlpha(1)
                searchFrame:Hide()
                searchBox:Hide()
                if SettingsPanel.currentLayout and SettingsPanel.currentLayout.frame then
                    searchBox:SetText("")
                    SettingsPanel.currentLayout.frame:Show()
                end
            end)
            searchBox.hookedSettings = true
        end
    end)

    hooksecurefunc(SettingsPanel, "DisplayLayout", function()
        if SettingsPanel.currentLayout.frame and SettingsPanel.currentLayout.frame.name == "Better|cff00c0ffBlizz|rFrames |A:gmchat-icon-blizz:16:16|a" or
        (SettingsPanel.currentLayout.frame and SettingsPanel.currentLayout.frame.parent == "Better|cff00c0ffBlizz|rFrames |A:gmchat-icon-blizz:16:16|a") then
            SettingsPanel.SearchBox.Instructions:SetText(L["Search_In_BBF"])
            searchBox:Show()
            searchBox:SetText("")
            searchFrame:Hide()
            searchFrame:ClearAllPoints()
            searchFrame:SetPoint("TOPLEFT", SettingsPanel.currentLayout.frame, "TOPLEFT")
            searchFrame:SetPoint("BOTTOMRIGHT", SettingsPanel.currentLayout.frame, "BOTTOMRIGHT")
            if not SettingsPanel.currentLayout.frame:IsShown() then
                SettingsPanel.currentLayout.frame:Show()
            end
        else
            if SettingsPanel.SearchBox.Instructions:GetText() == L["Search_In_BBF"] then
                SettingsPanel.SearchBox.Instructions:SetText(L["Search"])
            end
            searchBox:Hide()
            searchFrame:Hide()
        end
    end)
end

------------------------------------------------------------
-- GUI Panels
------------------------------------------------------------



------------------------------------------------------------
-- Shared Helper Function Exports for BBF Settings Modules
------------------------------------------------------------
BBF.LibDD = LibDD
BBF.LSM = LSM
BBF.CreateCheckbox = CreateCheckbox
BBF.CreateSlider = CreateSlider
BBF.CreateSimpleDropdown = CreateSimpleDropdown
BBF.CreateFontDropdown = CreateFontDropdown
BBF.CreateTextureDropdown = CreateTextureDropdown
BBF.CreateColorBox = CreateColorBox
BBF.CreateImportExportUI = CreateImportExportUI
BBF.CreateTitle = CreateTitle
BBF.CreateHeader = CreateHeader
BBF.CreateTooltip = CreateTooltip
BBF.CreateTooltipTwo = CreateTooltipTwo
BBF.CreateClassButton = CreateClassButton
BBF.CreateCDManagerList = CreateCDManagerList
BBF.CreateList = CreateList
BBF.CreateAnchorDropdown = CreateAnchorDropdown
BBF.CreateIconChangeWindow = CreateIconChangeWindow
BBF.CreateBorderedFrame = CreateBorderedFrame
BBF.RecolorEntireAuraWhitelist = RecolorEntireAuraWhitelist
BBF.UpdateColorSquare = UpdateColorSquare
BBF.CreateSearchFrame = CreateSearchFrame
BBF.CheckAndToggleCheckboxes = CheckAndToggleCheckboxes
BBF.DisableElement = DisableElement
BBF.EnableElement = EnableElement
BBF.CreateBorderBox = CreateBorderBox
BBF.FormatClassName = FormatClassName
BBF.ShowProfileConfirmation = ShowProfileConfirmation
BBF.HandleEditBoxInput = HandleEditBoxInput
BBF.SetSliderValue = SetSliderValue
BBF.UpdateSliderRange = UpdateSliderRange

local function CombatOnGUICreation()
    if InCombatLockdown() then
        BBF.Print(L["Print_Waiting_For_Combat"])
        if not BBF.waitingCombat then
            local f = CreateFrame("Frame")
            f:RegisterEvent("PLAYER_REGEN_ENABLED")
            f:SetScript("OnEvent", function(self)
                self:UnregisterEvent("PLAYER_REGEN_ENABLED")
                BBF.LoadGUI()
            end)
            BBF.waitingCombat = true
        end
        return true
    end
end

function BBF.InitializeOptions()
    if not BetterBlizzFrames then
        BetterBlizzFrames = CreateFrame("Frame")
        BetterBlizzFrames.name = "Better|cff00c0ffBlizz|rFrames |A:gmchat-icon-blizz:16:16|a"
        --InterfaceOptions_AddCategory(BetterBlizzFrames)
        BBF.category = Settings.RegisterCanvasLayoutCategory(BetterBlizzFrames, BetterBlizzFrames.name, BetterBlizzFrames.name)
        Settings.RegisterAddOnCategory(BBF.category)

        local titleText = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFont_Gigantic")
        titleText:SetPoint("CENTER", BetterBlizzFrames, "CENTER", -15, 33)
        titleText:SetText("|A:gmchat-icon-blizz:16:16|a Better|cff00c0ffBlizz|rFrames")
        BetterBlizzFrames.titleText = titleText

        local loadGUI = CreateFrame("Button", nil, BetterBlizzFrames, "UIPanelButtonTemplate")
        loadGUI:SetText(L["Load_Settings"])
        loadGUI:SetWidth(100)
        loadGUI:SetPoint("CENTER", BetterBlizzFrames, "CENTER", -18, 6)
        BetterBlizzFrames.loadGUI = loadGUI
        loadGUI:SetScript("OnClick", function(self)
            if CombatOnGUICreation() then return end
            titleText:Hide()
            self:Hide()
            BBF.LoadGUI()
        end)
    end
end

function BBF.LoadGUI()
    -- First time opening settings
    if BetterBlizzFramesDB.hasNotOpenedSettings then
        BBF.CreateIntroMessageWindow()
        BetterBlizzFramesDB.hasNotOpenedSettings = nil
        return
    end

    if CombatOnGUICreation() then return end

    if BetterBlizzFrames.guiLoaded then
        Settings.OpenToCategory(BBF.category:GetID())
        return
    end

    guiGeneralTab()
    guiPositionAndScale()
    guiFrameAuras()
    guiFrameLook()
    guiCastbars()
    guiImportAndExport()
    guiMisc()
    --guiChatFrame()
    guiCustomCode()
    guiSupport()
    BetterBlizzFrames.guiLoaded = true

    if SettingsPanel:IsShown() then
        HideUIPanel(SettingsPanel)
    end
    Settings.OpenToCategory(BBF.category:GetID())
    Settings.OpenToCategory(BBF.category:GetID(), BBF.guiCustomCode)
    Settings.OpenToCategory(BBF.category:GetID())
end


function BBF.CreateIntroMessageWindow()
    if BBF.IntroMessageWindow then
        BBF.IntroMessageWindow:ClearAllPoints()
        if BBP and BBP.IntroMessageWindow and BBP.IntroMessageWindow:IsShown() then
            BBP.IntroMessageWindow:ClearAllPoints()
            BBP.IntroMessageWindow:SetPoint("CENTER", UIParent, "CENTER", 240, 45)
            BBF.IntroMessageWindow:SetPoint("CENTER", UIParent, "CENTER", -240, 45)
        else
            BBF.IntroMessageWindow:SetPoint("CENTER", UIParent, "CENTER", 0, 45)
        end
        BBF.IntroMessageWindow:Show()
        return
    end

    BBF.IntroMessageWindow = CreateFrame("Frame", "BBFIntro", UIParent, "PortraitFrameTemplate")
    BBF.IntroMessageWindow:SetSize(470, 550)
    BBF.IntroMessageWindow.Bg:SetDesaturated(true)
    BBF.IntroMessageWindow.Bg:SetVertexColor(0.5,0.5,0.5, 0.98)
    if BBP and BBP.IntroMessageWindow and BBP.IntroMessageWindow:IsShown() then
        BBP.IntroMessageWindow:SetPoint("CENTER", UIParent, "CENTER", 240, 45)
        BBF.IntroMessageWindow:SetPoint("CENTER", UIParent, "CENTER", -240, 45)
    else
        BBF.IntroMessageWindow:SetPoint("CENTER", UIParent, "CENTER", 0, 45)
    end
    BBF.IntroMessageWindow:SetMovable(true)
    BBF.IntroMessageWindow:EnableMouse(true)
    BBF.IntroMessageWindow:RegisterForDrag("LeftButton")
    BBF.IntroMessageWindow:SetScript("OnDragStart", BBF.IntroMessageWindow.StartMoving)
    BBF.IntroMessageWindow:SetScript("OnDragStop", BBF.IntroMessageWindow.StopMovingOrSizing)
    BBF.IntroMessageWindow:SetTitle("Better|cff00c0ffBlizz|rFrames "..BBF.VersionNumber)
    BBF.IntroMessageWindow:SetFrameStrata("HIGH")

    -- Add background texture
    BBF.IntroMessageWindow.textureTest = BBF.IntroMessageWindow:CreateTexture(nil, "BACKGROUND")
    BBF.IntroMessageWindow.textureTest:SetAtlas("communities-widebackground")
    BBF.IntroMessageWindow.textureTest:SetSize(465, 150)
    BBF.IntroMessageWindow.textureTest:SetPoint("TOP", BBF.IntroMessageWindow, "TOP", 0, -15)

    -- Create a mask texture
    local maskTexture = BBF.IntroMessageWindow:CreateMaskTexture()
    maskTexture:SetAtlas("Azerite-CenterBG-ChannelGlowBar-FillingMask")
    maskTexture:SetSize(665, 300)
    maskTexture:SetPoint("CENTER", BBF.IntroMessageWindow.textureTest, "CENTER", 0, 50)
    BBF.IntroMessageWindow.textureTest:AddMaskTexture(maskTexture)

    BBF.IntroMessageWindow:SetPortraitToAsset(135724)

    local welcomeText = BBF.IntroMessageWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge2")
    welcomeText:SetPoint("TOP", BBF.IntroMessageWindow, "TOP", 0, -45)
    welcomeText:SetText(L["Welcome_Text"])
    welcomeText:SetJustifyH("CENTER")

    local description1 = BBF.IntroMessageWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    description1:SetPoint("TOP", welcomeText, "BOTTOM", 0, -10)
    local starterProfileText = "|A:newplayerchat-chaticon-newcomer:16:16|a |cff32cd32" .. L["Label_Starter_Profile"] .. "|r"
    description1:SetText(string.format(L["Welcome_Description"], starterProfileText))
    description1:SetJustifyH("CENTER")
    description1:SetWidth(410)

    local btnWidth, btnHeight, btnGap = 150, 30, -3

    local function ShowProfileConfirmation(profileName, class, profileFunction, additionalNote)
        local noteText = additionalNote or ""
        local color = CLASS_COLORS[class] or "|cffffffff"
        local icon = CLASS_ICONS[class] or "groupfinder-icon-role-leader"
        local profileText = string.format("|A:%s:16:16|a %s%s|r", icon, color, profileName..L["Profile_Label"])
        local confirmationText = titleText .. string.format(L["Profile_Confirmation_Text_Intro"], profileText, noteText)
        StaticPopupDialogs["BBF_CONFIRM_PROFILE"].text = confirmationText
        StaticPopup_Show("BBF_CONFIRM_PROFILE", nil, nil, { func = profileFunction })
    end

    local starterButton = CreateClassButton(BBF.IntroMessageWindow, "STARTER", "Starter", nil, function()
        ShowProfileConfirmation("Starter", "STARTER", function() BBF.ApplyProfile("Starter") end)
    end)
    starterButton:SetPoint("TOP", description1, "BOTTOM", -75, -20)

    local bodifyButton = CreateClassButton(BBF.IntroMessageWindow, "MAGE", "Bodify", "bodify", function()
        ShowProfileConfirmation("Bodify", "MAGE", function() BBF.ApplyProfile("Bodify") end)
    end)
    bodifyButton:SetPoint("TOP", description1, "BOTTOM", 75, -20)

    local orText = BBF.IntroMessageWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
    orText:SetPoint("CENTER", bodifyButton, "BOTTOM", -75, -20)
    orText:SetText(L["OR"])
    orText:SetJustifyH("CENTER")

    local columnOffsets = { -114, 0, 114 }
    local columnAnchors = { orText, orText, orText }
    local columnFirstRow = { true, true, true }
    local colIndex = 1
    local lastCol1Button

    for _, profile in ipairs(BBF.ProfileData) do
        if not profile.core then
            local button = CreateClassButton(BBF.IntroMessageWindow, profile.class, profile.name, profile.twitchName, function()
                ShowProfileConfirmation(profile.name, profile.class, function() BBF.ApplyProfile(profile.name) end)
            end)

            if columnFirstRow[colIndex] then
                button:SetPoint("TOP", columnAnchors[colIndex], "BOTTOM", columnOffsets[colIndex], -10)
                columnFirstRow[colIndex] = false
            else
                button:SetPoint("TOP", columnAnchors[colIndex], "BOTTOM", 0, btnGap)
            end

            columnAnchors[colIndex] = button
            if colIndex == 1 then
                lastCol1Button = button
            end
            colIndex = colIndex + 1
            if colIndex > 3 then colIndex = 1 end
        end
    end

    local orText2 = BBF.IntroMessageWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
    orText2:SetPoint("CENTER", lastCol1Button, "BOTTOM", 114, -20)
    orText2:SetText(L["OR"])
    orText2:SetJustifyH("CENTER")

    local buttonLast = CreateFrame("Button", nil, BBF.IntroMessageWindow, "GameMenuButtonTemplate")
    buttonLast:SetSize(btnWidth, btnHeight)
    buttonLast:SetText(L["Exit_No_Profile"])
    buttonLast:SetPoint("TOP", lastCol1Button, "BOTTOM", 114, -40)
    buttonLast:SetNormalFontObject("GameFontNormal")
    buttonLast:SetHighlightFontObject("GameFontHighlight")
    buttonLast:SetScript("OnClick", function()
        BBF.IntroMessageWindow:Hide()
        if not BetterBlizzFrames.guiLoaded then
            BBF.LoadGUI()
        else
            Settings.OpenToCategory(BBF.category:GetID())
        end
    end)
    CreateTooltipTwo(buttonLast, L["Exit_No_Profile"], L["Tooltip_Exit_No_Profile"], nil, "ANCHOR_TOP")
    local f,s,o = buttonLast.Text:GetFont()
    buttonLast.Text:SetFont(f,s,"OUTLINE")

    BBF.IntroMessageWindow.CloseButton:HookScript("OnClick", function()
        if not BetterBlizzFrames.guiLoaded then
            BBF.LoadGUI()
        else
            Settings.OpenToCategory(BBF.category:GetID())
        end
    end)

    local function AdjustWindowHeight()
        local baseHeight = 334
        local perRowHeight = 29
        local buttonCount = 0
        for _, child in ipairs({BBF.IntroMessageWindow:GetChildren()}) do
            if child and child:IsObjectType("Button") then
                buttonCount = buttonCount + 1
            end
        end

        local rowCount = math.ceil(buttonCount / 3)
        local newHeight = baseHeight + (rowCount * perRowHeight)

        BBF.IntroMessageWindow:SetSize(470, newHeight)
    end
    AdjustWindowHeight()
end