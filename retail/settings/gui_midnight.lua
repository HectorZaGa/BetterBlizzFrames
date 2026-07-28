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

local function guiMidnight()
    local guiMidnight = CreateFrame("Frame")
    guiMidnight.name = "|T136221:12:12|t |cffcc66ffWoW: Midnight|r"
    guiMidnight.parent = BetterBlizzFrames.name
    --InterfaceOptions_AddCategory(guiMidnight)
    local guiMidnightCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiMidnight, guiMidnight.name, guiMidnight.name)
    guiMidnightCategory.ID = guiMidnight.name;
    BBF.guiMidnight = guiMidnight.name
    BBF.category.guiMidnightCategory = guiMidnightCategory.ID
    CreateTitle(guiMidnight)

    local titleText = guiMidnight:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    titleText:SetPoint("TOPLEFT", guiMidnight, "TOPLEFT", 20, -10)
    titleText:SetText(L["Midnight_Title"])
    local titleIcon = guiMidnight:CreateTexture(nil, "ARTWORK")
    titleIcon:SetTexture(136221)
    titleIcon:SetSize(23, 23)
    titleIcon:SetPoint("RIGHT", titleText, "LEFT", -3, 0.5)

    local midnightInfo = guiMidnight:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    midnightInfo:SetPoint("TOPLEFT", titleIcon, "BOTTOMLEFT", 2, -5)
    midnightInfo:SetText(L["Midnight_Info"])
    midnightInfo:SetTextColor(1,1,1,1)
    midnightInfo:SetJustifyH("LEFT")

    local bgImg = guiMidnight:CreateTexture(nil, "BACKGROUND")
    bgImg:SetAtlas("professions-recipe-background")
    bgImg:SetPoint("CENTER", guiMidnight, "CENTER", -8, 4)
    bgImg:SetSize(680, 610)
    bgImg:SetAlpha(0.4)
    bgImg:SetVertexColor(0,0,0)

    local f = CreateFrame("PlayerModel", nil, guiMidnight)
    f:SetIgnoreParentScale(true)
    f:SetScale(1)
    f:SetAllPoints(bgImg)
    f:SetPortraitZoom(0)
    f:SetDisplayInfo(121956)
    f.anim = 69
    f:SetAnimation(69)
    f:HookScript("OnAnimFinished", function(self)
        if self.anim == 3 or self.anim == 15 then return end
        self:SetAnimation(self.anim)
    end)

    local DEFAULT_CAM     = 1.35
    local DEFAULT_VTX     = -35
    local DEFAULT_VTY     = -30

    local validAnimations = {}
    for i = 1, 84 do
        if i ~= 7 and i ~= 11 and i ~= 12 and i ~= 40 and i ~= 56 then
            table.insert(validAnimations, i)
        end
    end
    local extras = { 102, 103, 105, 106, 107, 108, 109, 110, 111, 112, 113, 144, 164, 185, 186, 195, 196, 225 }
    for _, v in ipairs(extras) do
        table.insert(validAnimations, v)
    end

    local pool = {}
    local function RefillPool()
        wipe(pool)
        for i = 1, #validAnimations do
            pool[i] = validAnimations[i]
        end
        for i = #pool, 2, -1 do
            local j = math.random(i)
            pool[i], pool[j] = pool[j], pool[i]
        end
    end
    RefillPool()

    local function PlayRandomAnimation()
        if #pool == 0 then
            RefillPool()
        end
        local anim = table.remove(pool)
        f.anim = anim
        f:SetAnimation(anim)
    end

    local poke = CreateFrame("Button", nil, guiMidnight, "UIPanelButtonTemplate")
    poke:SetText(L["Poke"])
    poke:SetWidth(50)
    poke:SetPoint("LEFT", f, "LEFT", 65, -55)
    poke:SetScale(1.5)
    poke:SetFrameStrata("HIGH")
    poke:SetScript("OnClick", PlayRandomAnimation)
    poke.Text:SetVertexColor(1, 1, 1)


    local r, g, b = 0.945, 0.769, 1.0
    for _, region in ipairs({ poke:GetRegions() }) do
        if region:IsObjectType("Texture") then
            region:SetDesaturated(true)
            region:SetVertexColor(r, g, b)
        end
    end

    local ROT_SENS   = 0.010 * 0.8
    local PITCH_SENS = 0.010 * 0.8
    local DOLLY_SENS = 0.015 * 0.35
    local WHEEL_PAN  = 0.34

    f:EnableMouse(true)
    f:EnableMouseWheel(true)
    f:UseModelCenterToTransform(true)

    local camScale = DEFAULT_CAM
    f:SetCamDistanceScale(camScale)

    local startX, startY, startYaw, startPitch, startPX, startPY, startPZ
    local dragMode

    local function Cur()
        local x, y = GetCursorPosition()
        local s = UIParent:GetEffectiveScale()
        return x / s, y / s
    end

    f:SetScript("OnMouseDown", function(self, button)
        startX, startY            = Cur()
        startYaw                  = self:GetFacing() or 0
        startPitch                = self:GetPitch() or 0
        startPX, startPY, startPZ = self:GetPosition()
        if button == "LeftButton" then
            dragMode = "lmb"
        elseif button == "RightButton" then
            dragMode = "rmb"
        elseif button == "MiddleButton" then
            camScale = DEFAULT_CAM
            self:SetCamDistanceScale(camScale)
            self:SetFacing(0)
            self:SetPitch(0)
            self:SetPosition(0, 0, 0)
            self:SetViewTranslation(DEFAULT_VTX, DEFAULT_VTY)
            return
        end
        self:EnableMouseMotion(true)
    end)

    f:SetScript("OnMouseUp", function(self)
        self:EnableMouseMotion(false)
        dragMode = nil
    end)

    f:SetScript("OnHide", function(self)
        self:EnableMouseMotion(false)
        dragMode = nil
    end)

    f:SetScript("OnMouseWheel", function(self, delta)
        local px, py, pz = self:GetPosition()
        self:SetPosition(px + delta * WHEEL_PAN, py, pz)
    end)

    f:SetScript("OnUpdate", function(self)
        if not dragMode then return end
        local x, y = Cur()
        local dx, dy = x - startX, y - startY
        if dragMode == "lmb" then
            self:SetFacing(startYaw + dx * ROT_SENS)
            self:SetPitch(startPitch - dy * PITCH_SENS)
        elseif dragMode == "rmb" then
            self:SetPosition(startPX, startPY + dx * DOLLY_SENS, startPZ + dy * DOLLY_SENS)
        end
    end)

    local function ResetView()
        camScale = DEFAULT_CAM
        f:RefreshCamera()
        f:ZeroCachedCenterXY()
        f:UseModelCenterToTransform(true)
        f:SetPortraitZoom(0)
        f:SetFacing(0)
        f:SetPitch(0)
        f:SetRoll(0)
        f:SetPosition(0, 0, 0)
        f:SetCamDistanceScale(camScale)
        f:SetViewTranslation(DEFAULT_VTX, DEFAULT_VTY)
    end
    ResetView()

    guiMidnight:HookScript("OnShow", function()
        ResetView()
    end)
end


-- Export tab function to BBF
BBF.guiMidnight = guiMidnight
