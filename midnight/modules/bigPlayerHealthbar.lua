-- Big Healthbar (No Portrait): the PlayerFrame health bar takes over the mana slot.

-- Blizzard's player-bars heights: health 19, mana 10, 1px gap.
-- Mask is noPortrait's portrait-off mask (uipartyframeportraitoffhealthmask, 190x34);
local HEALTHBAR_HEIGHT = 19
local MANABAR_HEIGHT = 10
local BAR_GAP = 1
local HEALTHBAR_HEIGHT_GROWN = HEALTHBAR_HEIGHT + BAR_GAP + MANABAR_HEIGHT -- 30
local MASK_HEIGHT = 34
local MASK_HEIGHT_GROWN = 45 -- 30 + (34-19) = 45

-- noPortrait's vehicle art anchors the mask top only +5 above the bar (vs +9 for
-- player), clipping the grown bar's top, so we re-centre it on the grown bar.
local MASK_GROWN_Y = (MASK_HEIGHT_GROWN - HEALTHBAR_HEIGHT_GROWN) / 2

local function GetHealthBits()
    local hpContainer = PlayerFrame_GetHealthBarContainer()
    return hpContainer, hpContainer.HealthBar, hpContainer.HealthBarMask
end

local function IsEnabled()
    return BetterBlizzFramesDB.bigPlayerHealthbar and BetterBlizzFramesDB.noPortraitModes
end

local function GrowBar(isVehicle)
    local _, healthBar, mask = GetHealthBits()
    if not healthBar or not mask then
        return
    end
    healthBar:SetHeight(HEALTHBAR_HEIGHT_GROWN)
    mask:SetHeight(MASK_HEIGHT_GROWN)

    local x = isVehicle and -34 or -33 -- from noPortrait.lua
    mask:ClearAllPoints()
    mask:SetPoint("TOPLEFT", healthBar, "TOPLEFT", x, MASK_GROWN_Y)
end

local function RestoreBar()
    local _, healthBar, mask = GetHealthBits()
    if not healthBar or not mask then
        return
    end

    healthBar:SetHeight(HEALTHBAR_HEIGHT)
    mask:SetHeight(MASK_HEIGHT)
end

local function Apply(isVehicle)
    if not IsEnabled() then
        return
    end
    if InCombatLockdown() then
        BBF.RunAfterCombat(Apply)
        return
    end
    BBF.UpdateNoPortraitManaVisibility()
    GrowBar(isVehicle)
    BBF.UpdateNoPortraitText(PlayerFrame, "player")
end

local hooked = false
local function EnsureHooks()
    if hooked then
        return
    end
    hooked = true
    hooksecurefunc(BBF, "noPortraitModes", function()
        if BetterBlizzFramesDB.bigPlayerHealthbar then
            C_Timer.After(0, Apply)
        end
    end)
    hooksecurefunc("PlayerFrame_ToPlayerArt", Apply)
    hooksecurefunc("PlayerFrame_ToVehicleArt", function()
        Apply(true)
    end)
end

function BBF.UpdateBigPlayerHealthbar()
    if IsEnabled() then
        EnsureHooks()
        Apply()
        return
    end

    if InCombatLockdown() then
        BBF.RunAfterCombat(BBF.UpdateBigPlayerHealthbar)
        return
    end
    RestoreBar()

    BBF.UpdateNoPortraitManaVisibility()
    if BetterBlizzFramesDB.noPortraitModes then
        BBF.UpdateNoPortraitText(PlayerFrame, "player")
    end
end
