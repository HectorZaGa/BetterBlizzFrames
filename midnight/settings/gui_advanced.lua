-- ============================================================
-- BetterBlizzFrames: midnight/settings/gui_advanced.lua
-- Pure Declarative Schema for Advanced Module Settings.
-- ============================================================
if not BBF.isMidnight then return end

local L = BBF.L
BBF.GUI = BBF.GUI or {}
BBF.GUI.Schemas = BBF.GUI.Schemas or {}

local schema = {
    tabs = {
        --------------------------------------------------------
        -- TAB 1: Absorb Indicator
        --------------------------------------------------------
        {
            id          = "absorb",
            label       = L["Absorb_Indicator"],
            atlas       = "ParagonReputation_Glow",
            size        = {22, 22},
            cards       = {
                {
                    title   = L["Absorb_Indicator"],
                    options = {
                        { type="slider",   key="absorbIndicatorScale",        label=L["Size"],            tooltip=L["Tooltip_Absorb_Indicator"], min=0.1, max=1.9, step=0.01 },
                        { type="slider",   key="playerAbsorbXPos",            label=L["X_Offset"],        tooltip="",                             min=-100, max=100, step=1 },
                        { type="slider",   key="playerAbsorbYPos",            label=L["Y_Offset"],        tooltip="",                             min=-100, max=100, step=1 },
                        { type="dropdown", key="playerAbsorbAnchor",          label=L["Anchor"],          tooltip="",                             preset="anchorInnerOuter", onChange=BBF.AbsorbCaller },
                        { type="checkbox", key="absorbIndicatorTestMode",     label=L["Test"],            tooltip="",                             onChange=BBF.AbsorbCaller },
                        { type="checkbox", key="absorbIndicatorFlipIconText", label=L["Flip_Icon_Text"],  tooltip="",                             onChange=BBF.AbsorbCaller },
                    }
                },
                {
                    title   = L["Display_Text"],
                    options = {
                        { type="checkbox", key="playerAbsorbAmount", label=L["Player"], tooltip=L["Tooltip_Absorb_Show_Player"], onChange=BBF.AbsorbCaller },
                        { type="checkbox", key="targetAbsorbAmount", label=L["Target"], tooltip=L["Tooltip_Absorb_Show_Target"], onChange=BBF.AbsorbCaller },
                        { type="checkbox", key="focusAbsorbAmount",  label=L["Focus"],  tooltip=L["Tooltip_Absorb_Show_Focus"],  onChange=BBF.AbsorbCaller },
                    }
                }
            }
        },

        --------------------------------------------------------
        -- TAB 2: Combat Indicator
        --------------------------------------------------------
        {
            id          = "combat",
            label       = L["Combat_Indicator"],
            icon        = "Interface\\Icons\\ABILITY_DUALWIELD",
            size        = {20, 20},
            cards       = {
                {
                    title   = L["Combat_Indicator"],
                    options = {
                        { type="slider",   key="combatIndicatorScale",  label=L["Size"],     tooltip=L["Tooltip_Combat_Indicator"], min=0.1, max=1.9, step=0.01 },
                        { type="slider",   key="combatIndicatorXPos",   label=L["X_Offset"], tooltip="",                            min=-50, max=50,  step=1 },
                        { type="slider",   key="combatIndicatorYPos",   label=L["Y_Offset"], tooltip="",                            min=-50, max=50,  step=1 },
                        { type="dropdown", key="combatIndicatorAnchor", label=L["Anchor"],   tooltip="",                            preset="anchorInnerOuter", onChange=BBF.CombatIndicatorCaller },
                    }
                },
                {
                    title   = L["Filters"],
                    options = {
                        { type="checkbox", key="combatIndicatorArenaOnly",   label=L["Arena_Only"],   tooltip=L["Tooltip_Arena_Only"],   onChange=BBF.CombatIndicatorCaller },
                        { type="checkbox", key="combatIndicatorPlayersOnly", label=L["Players_Only"], tooltip=L["Tooltip_Players_Only"], onChange=BBF.CombatIndicatorCaller },
                        { type="checkbox", key="combatIndicatorShowSap",      label=L["No_Combat"],    tooltip=L["Tooltip_No_Combat"],    onChange=BBF.CombatIndicatorCaller },
                        { type="checkbox", key="combatIndicatorShowSwords",   label=L["In_Combat"],    tooltip=L["Tooltip_In_Combat"],    onChange=BBF.CombatIndicatorCaller },
                    }
                },
                {
                    title   = L["All_Frames"],
                    options = {
                        { type="checkbox", key="playerCombatIndicator", label=L["Player"], tooltip="", onChange=BBF.CombatIndicatorCaller },
                        { type="checkbox", key="targetCombatIndicator", label=L["Target"], tooltip="", onChange=BBF.CombatIndicatorCaller },
                        { type="checkbox", key="focusCombatIndicator",  label=L["Focus"],  tooltip="", onChange=BBF.CombatIndicatorCaller },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 3: Healer Indicator
        --------------------------------------------------------
        {
            id          = "healer",
            label       = L["Healer_Indicator"],
            atlas       = "bags-icon-addslots",
            size        = {20, 20},
            cards       = {
                {
                    title   = L["Healer_Indicator"],
                    options = {
                        { type="slider",   key="healerIndicatorScale",  label=L["Size"],     tooltip=L["Tooltip_Healer_Indicator"], min=0.8, max=2.5, step=0.01 },
                        { type="slider",   key="healerIndicatorXPos",   label=L["X_Offset"], tooltip="",                            min=-50, max=50,  step=1 },
                        { type="slider",   key="healerIndicatorYPos",   label=L["Y_Offset"], tooltip="",                            min=-50, max=50,  step=1 },
                        { type="dropdown", key="healerIndicatorAnchor", label=L["Anchor"],   tooltip="",                            preset="anchor" },
                    }
                },
                {
                    title   = L["Display_Text"],
                    options = {
                        { type="checkbox", key="healerIndicatorIcon",     label=L["Icon"],     tooltip=L["Tooltip_Healer_Icon_Show"] },
                        { type="checkbox", key="healerIndicatorPortrait", label=L["Portrait"], tooltip=L["Tooltip_Healer_Portrait_Change"] },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 4: Racial Indicator
        --------------------------------------------------------
        {
            id          = "racial",
            label       = L["Racial_Indicator"],
            icon        = "Interface\\Icons\\ability_ambush",
            size        = {20, 20},
            cards       = {
                {
                    title   = L["Racial_Indicator"],
                    options = {
                        { type="slider", key="racialIndicatorScale", label=L["Size"],     tooltip=L["Tooltip_Racial_Indicator_Enable"], min=0.1, max=1.9, step=0.01 },
                        { type="slider", key="racialIndicatorXPos",  label=L["X_Offset"], tooltip="",                                   min=-50, max=50,  step=1 },
                        { type="slider", key="racialIndicatorYPos",  label=L["Y_Offset"], tooltip="",                                   min=-50, max=50,  step=1 },
                    }
                },
                {
                    title   = L["Filters"],
                    options = {
                        { type="checkbox", key="racialIndicatorOrc",           label=L["Orc"],       tooltip=L["Tooltip_Show_Orc"], onChange=BBF.RacialIndicatorCaller },
                        { type="checkbox", key="racialIndicatorHuman",         label=L["Human"],     tooltip=L["Tooltip_Show_Human"], onChange=BBF.RacialIndicatorCaller },
                        { type="checkbox", key="racialIndicatorDwarf",         label=L["Dwarf"],     tooltip=L["Tooltip_Show_Dwarf"], onChange=BBF.RacialIndicatorCaller },
                        { type="checkbox", key="racialIndicatorNelf",          label=L["Night_Elf"], tooltip=L["Tooltip_Night_Elf"], onChange=BBF.RacialIndicatorCaller },
                        { type="checkbox", key="racialIndicatorUndead",        label=L["Undead"],    tooltip=L["Tooltip_Undead"], onChange=BBF.RacialIndicatorCaller },
                        { type="checkbox", key="racialIndicatorDarkIronDwarf", label=L["DI_Dwarf"],  tooltip=L["Tooltip_DI_Dwarf"], onChange=BBF.RacialIndicatorCaller },
                    }
                },
                {
                    title   = L["All_Frames"],
                    options = {
                        { type="checkbox", key="targetRacialIndicator",   label=L["Target"],    tooltip=L["Tooltip_Target"], onChange=BBF.RacialIndicatorCaller },
                        { type="checkbox", key="focusRacialIndicator",    label=L["Focus"],     tooltip=L["Tooltip_Focus"], onChange=BBF.RacialIndicatorCaller },
                        { type="checkbox", key="racialIndicatorRaceIcons",label=L["Race_Icon"], tooltip=L["Tooltip_Race_Icon"], onChange=BBF.RacialIndicatorCaller },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 5: Interrupt
        --------------------------------------------------------
        {
            id          = "interrupt",
            label       = L["Interrupt_Icon_AS"],
            spell       = 6552,
            size        = {20, 20},
            cards       = {
                {
                    title   = L["Interrupt_Icon_AS"],
                    options = {
                        { type="slider",   key="castBarInterruptIconScale",  label=L["Size"],     tooltip=L["Show_Interrupt_Icon_Next_Castbar"], min=0.1, max=1.9, step=0.01 },
                        { type="slider",   key="castBarInterruptIconXPos",   label=L["X_Offset"], tooltip="",                                      min=-100, max=100, step=1 },
                        { type="slider",   key="castBarInterruptIconYPos",   label=L["Y_Offset"], tooltip="",                                      min=-100, max=100, step=1 },
                        { type="dropdown", key="castBarInterruptIconAnchor", label=L["Anchor"],   tooltip="",                                      preset="anchor" },
                    }
                },
                {
                    title   = L["All_Frames"],
                    options = {
                        { type="checkbox", key="castBarInterruptIconTarget",         label=L["Target"],                               tooltip=L["Show_On_Target"],                        onChange=BBF.UpdateInterruptIconSettings },
                        { type="checkbox", key="castBarInterruptIconFocus",          label=L["Focus"],                                tooltip=L["Show_On_Focus"],                         onChange=BBF.UpdateInterruptIconSettings },
                        { type="checkbox", key="castBarInterruptIconShowActiveOnly", label=L["Tooltip_Only_Show_If_Available_Desc"],  tooltip=L["Tooltip_Only_Show_If_Available_Desc"],   onChange=BBF.UpdateInterruptIconSettings },
                        { type="checkbox", key="interruptIconBorder",                label=L["Border_Status_Color"],                  tooltip=L["Tooltip_Border_Status_Color_Desc"],      onChange=BBF.UpdateInterruptIconSettings },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 6: Kick Popup
        --------------------------------------------------------
        {
            id          = "kick",
            label       = L["Kick_Popup"],
            icon        = "Interface\\Icons\\ability_kick",
            size        = {20, 20},
            cards       = {
                {
                    title   = L["Kick_Popup"],
                    options = {
                        { type="slider", key="kickPopupScale",     label=L["Size"],     tooltip=L["Tooltip_Kick_Popup_Desc"], min=0.5, max=2,   step=0.01 },
                        { type="slider", key="kickPopupIconScale", label=L["Icon"],     tooltip="",                           min=0.5, max=2.5, step=0.01 },
                        { type="slider", key="kickPopupXPos",      label=L["X_Offset"], tooltip="",                           min=-500, max=500, step=1 },
                        { type="slider", key="kickPopupYPos",      label=L["Y_Offset"], tooltip="",                           min=-500, max=500, step=1 },
                    }
                },
                {
                    title   = L["Display_Text"],
                    options = {
                        { type="checkbox", key="kickPopupFontOutline", label=L["Outline_Label"],  tooltip=L["Tooltip_Outline_Toggle"], onChange=function() BBF.UpdateKickPopupFont() end },
                        { type="checkbox", key="kickPopupFontShadow",  label=L["Shadow"],         tooltip="",                          onChange=function() BBF.UpdateKickPopupFont() end },
                        { type="checkbox", key="kickPopupSauce",       label=L["Kick_Popup_Sauce"],tooltip=L["Tooltip_Kick_Popup_Sauce_Desc"], onChange=function() if BetterBlizzFramesDB.kickPopupTestMode then BBF.TestKickPopup(true) end end },
                    }
                },
                {
                    title   = L["Sound_Effect"],
                    options = {
                        { type="checkbox", key="kickPopupTestMode",  label=L["Test"],                 tooltip="",                                   onChange=function() BBF.TestKickPopup(BetterBlizzFramesDB.kickPopupTestMode) end },
                        { type="checkbox", key="kickPopupPlaySound", label=L["Kick_Popup_Play_Sound"], tooltip=L["Tooltip_Kick_Popup_Play_Sound_Desc"] },
                    }
                }
            }
        }
    }
}

BBF.GUI.Schemas.advanced = schema

function guiPositionAndScale()
    local BetterBlizzFramesSubPanel = CreateFrame("Frame")
    BetterBlizzFramesSubPanel.name = L["Module_Name_Advanced"]
    BetterBlizzFramesSubPanel.parent = BetterBlizzFrames.name
    local advancedSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, BetterBlizzFramesSubPanel, BetterBlizzFramesSubPanel.name, BetterBlizzFramesSubPanel.name)
    advancedSubCategory.ID = BetterBlizzFramesSubPanel.name
    BBF.category.AdvancedSettings = BetterBlizzFramesSubPanel.name
    BBF.CreateTitle(BetterBlizzFramesSubPanel)

    BBF.GUI.BuildPanel(BetterBlizzFramesSubPanel, schema)

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
    if BBF.CreateTooltipTwo then
        BBF.CreateTooltipTwo(resetBBFButton, L["Tooltip_Full_Reset"])
    end
end
