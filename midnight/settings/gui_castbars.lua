-- ============================================================
-- BetterBlizzFrames: midnight/settings/gui_castbars.lua
-- Pure Declarative Schema for Castbars Module Settings.
-- ============================================================
if not BBF.isMidnight then return end

local L = BBF.L
BBF.GUI = BBF.GUI or {}
BBF.GUI.Schemas = BBF.GUI.Schemas or {}

local schema = {
    tabs = {
        --------------------------------------------------------
        -- TAB 1: Player Castbar
        --------------------------------------------------------
        {
            id          = "player",
            label       = L["Player_Castbar"],
            atlas       = "groupfinder-icon-friend",
            size        = {22, 22},
            desaturated = true,
            color       = {0.1, 0.6, 1},
            cards       = {
                {
                    title   = L["Player_Castbar"],
                    options = {
                        { type="frameBox", atlas="ui-castingbar-filling-standard", height=45 },
                        { type="slider",   key="playerCastBarScale", label=L["Size"],          tooltip="", min=0.1, max=1.9, step=0.01 },
                        { type="slider",   key="playerCastBarXPos",  label=L["X_Offset"],      tooltip="", min=-130, max=130, step=1 },
                        { type="slider",   key="playerCastBarYPos",  label=L["Y_Offset"],      tooltip="", min=-130, max=130, step=1 },
                        { type="slider",   key="playerCastBarWidth", label=L["Width"],         tooltip="", min=60, max=220, step=1 },
                        { type="slider",   key="playerCastBarHeight",label=L["Height"],        tooltip="", min=5, max=30, step=1 },
                        { type="slider",   key="playerCastBarIconScale", label=L["Icon_Size"], tooltip="", min=0.4, max=2, step=0.01 },
                        { type="slider",   key="playerCastbarIconXPos",  label=L["Icon_x_offset"], tooltip="", min=-160, max=160, step=1 },
                        { type="slider",   key="playerCastbarIconYPos",  label=L["Icon_y_offset"], tooltip="", min=-160, max=160, step=1 },
                        { type="checkbox", key="playerCastBarTimer", label=L["Timer"],        tooltip=L["Tooltip_Castbar_Timer"], onChange=function(...) if BBF and BBF.CastBarTimerCaller then BBF.CastBarTimerCaller(...) end end },
                        { type="checkbox", key="playerDetachCastbar",label=L["Castbar_Detach"],tooltip=L["Tooltip_Detach_From_Frame"] },
                        { type="checkbox", key="hidePlayerCastbar",  label=L["Hide_Bar"],      tooltip=L["Hide_Player_Castbar"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                        { type="checkbox", key="hidePlayerCastbarIcon", label=L["Hide_Icon"],  tooltip=L["Hide_Player_Castbar_Icon"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                    }
                }
            }
        },

        --------------------------------------------------------
        -- TAB 2: Target Castbar
        --------------------------------------------------------
        {
            id          = "target",
            label       = L["Target_Castbar"],
            atlas       = "groupfinder-icon-friend",
            size        = {22, 22},
            desaturated = true,
            color       = {1, 0.1, 0.1},
            cards       = {
                {
                    title   = L["Target_Castbar"],
                    options = {
                        { type="frameBox", atlas="ui-castingbar-tier1-empower-2x", height=45 },
                        { type="slider",   key="targetCastBarScale", label=L["Size"],          tooltip="", min=0.1, max=1.9, step=0.01 },
                        { type="slider",   key="targetCastBarXPos",  label=L["X_Offset"],      tooltip="", min=-130, max=130, step=1 },
                        { type="slider",   key="targetCastBarYPos",  label=L["Y_Offset"],      tooltip="", min=-130, max=130, step=1 },
                        { type="slider",   key="targetCastBarWidth", label=L["Width"],         tooltip="", min=60, max=220, step=1 },
                        { type="slider",   key="targetCastBarHeight",label=L["Height"],        tooltip="", min=5, max=30, step=1 },
                        { type="slider",   key="targetCastBarIconScale", label=L["Icon_Size"], tooltip="", min=0.4, max=2, step=0.01 },
                        { type="slider",   key="targetCastbarIconXPos",  label=L["Icon_x_offset"], tooltip="", min=-160, max=160, step=1 },
                        { type="slider",   key="targetCastbarIconYPos",  label=L["Icon_y_offset"], tooltip="", min=-160, max=160, step=1 },
                        { type="checkbox", key="targetStaticCastbar",    label=L["Static"],        tooltip=L["Tooltip_Castbar_Static"], onChange=function(...) if BBF and BBF.CastBarTimerCaller then BBF.CastBarTimerCaller(...) end end },
                        { type="checkbox", key="targetCastBarTimer",     label=L["Timer"],         tooltip=L["Tooltip_Castbar_Timer"], onChange=function(...) if BBF and BBF.CastBarTimerCaller then BBF.CastBarTimerCaller(...) end end },
                        { type="checkbox", key="targetToTCastbarAdjustment", label=L["ToT_Offset"], tooltip=L["Tooltip_Castbar_ToT_Offset_Desc"] },
                        { type="slider",   key="targetToTAdjustmentOffsetY", label=L["extra"],      tooltip=L["Tooltip_Castbar_ToT_Extra_Desc"], parent="targetToTCastbarAdjustment", min=-20, max=50, step=1 },
                        { type="checkbox", key="targetDetachCastbar",    label=L["Castbar_Detach"],tooltip=L["Tooltip_Detach_From_Frame"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                        { type="checkbox", key="hideTargetCastbar",      label=L["Hide_Bar"],      tooltip=L["Hide_Target_Castbar"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                        { type="checkbox", key="hideTargetCastbarIcon",  label=L["Hide_Icon"],     tooltip=L["Hide_Target_Castbar_Icon"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 3: Focus Castbar
        --------------------------------------------------------
        {
            id          = "focus",
            label       = L["Focus_Castbar"],
            atlas      = "groupfinder-icon-friend",
            size       = {22, 22},
            desaturated = true,
            color      = {0, 1, 0},
            cards       = {
                {
                    title   = L["Focus_Castbar"],
                    options = {
                        { type="frameBox", atlas="ui-castingbar-full-applyingcrafting", height=45 },
                        { type="slider",   key="focusCastBarScale", label=L["Size"],          tooltip="", min=0.1, max=1.9, step=0.01 },
                        { type="slider",   key="focusCastBarXPos",  label=L["X_Offset"],      tooltip="", min=-130, max=130, step=1 },
                        { type="slider",   key="focusCastBarYPos",  label=L["Y_Offset"],      tooltip="", min=-130, max=130, step=1 },
                        { type="slider",   key="focusCastBarWidth", label=L["Width"],         tooltip="", min=60, max=220, step=1 },
                        { type="slider",   key="focusCastBarHeight",label=L["Height"],        tooltip="", min=5, max=30, step=1 },
                        { type="slider",   key="focusCastBarIconScale", label=L["Icon_Size"], tooltip="", min=0.4, max=2, step=0.01 },
                        { type="slider",   key="focusCastbarIconXPos",  label=L["Icon_x_offset"], tooltip="", min=-160, max=160, step=1 },
                        { type="slider",   key="focusCastbarIconYPos",  label=L["Icon_y_offset"], tooltip="", min=-160, max=160, step=1 },
                        { type="checkbox", key="focusStaticCastbar",    label=L["Static"],        tooltip=L["Tooltip_Castbar_Static"], onChange=function(...) if BBF and BBF.CastBarTimerCaller then BBF.CastBarTimerCaller(...) end end },
                        { type="checkbox", key="focusCastBarTimer",     label=L["Timer"],         tooltip=L["Tooltip_Castbar_Timer"], onChange=function(...) if BBF and BBF.CastBarTimerCaller then BBF.CastBarTimerCaller(...) end end },
                        { type="checkbox", key="focusToTCastbarAdjustment", label=L["ToT_Offset"], tooltip=L["Tooltip_Castbar_ToT_Offset_Desc"] },
                        { type="slider",   key="focusToTAdjustmentOffsetY", label=L["extra"],      tooltip=L["Tooltip_Castbar_ToT_Extra_Desc"], parent="focusToTCastbarAdjustment", min=-20, max=50, step=1 },
                        { type="checkbox", key="focusDetachCastbar",    label=L["Castbar_Detach"],tooltip=L["Tooltip_Detach_From_Frame"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                        { type="checkbox", key="hideFocusCastbar",      label=L["Hide_Bar"],      tooltip=L["Tooltip_Hide_Focus_Castbar"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                        { type="checkbox", key="hideFocusCastbarIcon",  label=L["Hide_Icon"],     tooltip=L["Tooltip_Hide_Focus_Castbar_Icon"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 4: Party Castbar
        --------------------------------------------------------
        {
            id          = "party",
            label       = L["Party_Castbars"],
            atlas       = "groupfinder-icon-friend",
            size        = {20, 20},
            desaturated = true,
            color       = {0.1, 0.6, 1},
            overlays    = { 
                { atlas = "groupfinder-icon-friend", size = {16, 16}, offset = {4, 3}, desaturated = true, color = {0, 1, 0} } 
            }, 
            cards       = {
                {
                    title   = L["Party_Castbars"],
                    options = {
                        { type="frameBox", atlas="ui-castingbar-filling-channel", height=45 },
                        { type="slider",   key="partyCastBarScale", label=L["Size"],          tooltip="", min=0.5, max=1.9, step=0.01 },
                        { type="slider",   key="partyCastBarXPos",  label=L["X_Offset"],      tooltip="", min=-200, max=200, step=1 },
                        { type="slider",   key="partyCastBarYPos",  label=L["Y_Offset"],      tooltip="", min=-200, max=200, step=1 },
                        { type="slider",   key="partyCastBarWidth", label=L["Width"],         tooltip="", min=20, max=200, step=1 },
                        { type="slider",   key="partyCastBarHeight",label=L["Height"],        tooltip="", min=5, max=30, step=1 },
                        { type="slider",   key="partyCastBarIconScale", label=L["Icon_Size"], tooltip="", min=0.4, max=2, step=0.01 },
                        { type="slider",   key="partyCastbarIconXPos",  label=L["Icon_x_offset"], tooltip="", min=-50, max=50, step=1 },
                        { type="slider",   key="partyCastbarIconYPos",  label=L["Icon_y_offset"], tooltip="", min=-50, max=50, step=1 },
                        { type="checkbox", key="partyCastBarTestMode", label=L["Test"],       tooltip=L["Tooltip_Castbar_Test"], onChange=function(...) if BBF and BBF.partyCastBarTestMode then BBF.partyCastBarTestMode(...) end end, requiresReload=true },
                        { type="checkbox", key="partyCastBarTimer",    label=L["Timer"],      tooltip=L["Tooltip_Castbar_Timer"], onChange=function(...) if BBF and BBF.partyCastBarTestMode then BBF.partyCastBarTestMode(...) end end, requiresReload=true },
                        { type="checkbox", key="partyCastbarSelf",     label=L["Self"],       tooltip=L["Tooltip_Show_Party_Castbar"], onChange=function(...) if BBF and BBF.partyCastBarTestMode then BBF.partyCastBarTestMode(...) end end, requiresReload=true },
                        { type="checkbox", key="showPartyCastBarIcon", label=L["Icon"],       tooltip="", onChange=function(...) if BBF and BBF.partyCastBarTestMode then BBF.partyCastBarTestMode(...) end end, requiresReload=true },
                        { type="checkbox", key="classicCastbarsParty", label=L["Castbar_Classic"], tooltip=L["Tooltip_Castbar_Classic_Party_Desc"], requiresReload=true },
                        { type="checkbox", key="partyCastBarForceDefaultPartyFrames", label=L["Party_Castbar_Force_Default_Frames"], tooltip=L["Tooltip_Party_Castbar_Force_Default_Frames_Desc"] },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 5: Pet Castbar
        --------------------------------------------------------
        {
            id          = "pet",
            label       = L["Pet_Castbar"],
            atlas        = "newplayerchat-chaticon-newcomer",
            size        = {20, 20},
            cards       = {
                {
                    title   = L["Pet_Castbar"],
                    options = {
                        { type="frameBox", atlas="ui-castingbar-filling-channel", height=45 },
                        { type="slider",   key="petCastBarScale", label=L["Size"],          tooltip="", min=0.5, max=1.9, step=0.01 },
                        { type="slider",   key="petCastBarXPos",  label=L["X_Offset"],      tooltip="", min=-200, max=200, step=1 },
                        { type="slider",   key="petCastBarYPos",  label=L["Y_Offset"],      tooltip="", min=-200, max=200, step=1 },
                        { type="slider",   key="petCastBarWidth", label=L["Width"],         tooltip="", min=20, max=200, step=1 },
                        { type="slider",   key="petCastBarHeight",label=L["Height"],        tooltip="", min=5, max=30, step=1 },
                        { type="slider",   key="petCastBarIconScale", label=L["Icon_Size"], tooltip="", min=0.4, max=2, step=0.01 },
                        { type="checkbox", key="petCastBarTestMode", label=L["Test"],       tooltip=L["Tooltip_Need_Pet"], onChange=function(...) if BBF and BBF.petCastBarTestMode then BBF.petCastBarTestMode(...) end end },
                        { type="checkbox", key="petCastBarTimer",    label=L["Timer"],      tooltip=L["Tooltip_Castbar_Timer"], onChange=function(...) if BBF and BBF.petCastBarTestMode then BBF.petCastBarTestMode(...) end end },
                        { type="checkbox", key="showPetCastBarIcon", label=L["Icon"],       tooltip="", onChange=function(...) if BBF and BBF.petCastBarTestMode then BBF.petCastBarTestMode(...) end end },
                        { type="checkbox", key="petDetachCastbar",   label=L["Castbar_Detach"], tooltip=L["Tooltip_Detach_From_Frame"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 6: General Settings
        --------------------------------------------------------
        {
            id          = "general",
            label       = L["General_Settings"],
            atlas       = "optionsicon-brown",
            size        = {20, 20},
            cards       = {
                {
                    title   = L["Recolor_And_Styling"],
                    options = {
                        { type="checkbox", key="recolorCastbars", label=L["Recolor_Castbars"], tooltip=L["Tooltip_Recolor_Castbars_Desc"], requiresReload=true },
                        { type="checkbox", key="castBarRecolorInterrupt", label=L["Interrupt_CD_Color"], tooltip=L["Tooltip_Interrupt_CD_Color_Desc"], onChange=function(...) if BBF and BBF.UpdateInterruptIconSettings then BBF.UpdateInterruptIconSettings(...) end end },
                        { type="checkbox", key="castBarRecolorInterruptArenaFrames", label=L["Arena"], tooltip=L["Tooltip_Interrupt_CD_Color_Arena_Frames_Desc"], parent="castBarRecolorInterrupt", onChange=function(...) if BBF and BBF.UpdateInterruptIconSettings then BBF.UpdateInterruptIconSettings(...) end end },
                        { type="checkbox", key="castBarInterruptIconEnabled", label=L["Interrupt_CD_Icon"], tooltip=L["Tooltip_Interrupt_CD_Icon_Desc"], onChange=function(...) if BBF and BBF.UpdateInterruptIconSettings then BBF.UpdateInterruptIconSettings(...) end end },
                    }
                },
                {
                    title   = L["General_Settings"],
                    options = {
                        { type="checkbox", key="buffsOnTopReverseCastbarMovement", label=L["Buffs_On_Top_Reverse"], tooltip=L["Tooltip_Buffs_On_Top_Reverse_Desc"], onChange=function(...) if BBF and BBF.CastbarAdjustCaller then BBF.CastbarAdjustCaller(...) end end, requiresReload=true },
                        { type="checkbox", key="normalCastbarForEmpoweredCasts",    label=L["Normal_Evoker_Castbar"], tooltip=L["Tooltip_Normal_Evoker_Castbar_Desc"], requiresReload=true },
                        { type="checkbox", key="quickHideCastbars",                 label=L["Quick_Hide_Castbars"], tooltip=L["Tooltip_Quick_Hide_Castbars_Desc"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end, requiresReload=true },
                        { type="checkbox", key="castBarTargetText",                 label=L["Castbar_Target_Text"], tooltip=L["Tooltip_Castbar_Target_Text_Desc"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end, requiresReload=true },
                        { type="checkbox", key="castBarTargetHighlight",            label=L["Castbar_Target_Highlight"], tooltip=L["Tooltip_Castbar_Target_Highlight_Desc"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end, requiresReload=true },
                        { type="checkbox", key="classicCastbars",                   label=L["Castbar_Classic"], tooltip=L["Tooltip_Castbar_Classic_Target_Focus_Desc"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end, requiresReload=true },
                        { type="checkbox", key="classicCastbarsModernSpark",        label=L["Modern_Spark"], tooltip=L["Tooltip_Modern_Spark_Desc"], parent="classicCastbars", onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end, requiresReload=true },
                        { type="checkbox", key="unitframeCastBarNoTextBorder",      label=L["UnitFrame_Simple_Castbars"], tooltip=L["Tooltip_UnitFrame_Simple_Castbars_Desc"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end, requiresReload=true },
                        { type="checkbox", key="castbarPixelBorder",                label=L["Pixel_Border_Castbars"], tooltip=L["Tooltip_Pixel_Border_Castbars_Desc"], onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end, requiresReload=true },
                        { type="checkbox", key="castbarPixelBorderTextInside",      label=L["Pixel_Border_Castbars_Text_Inside"], tooltip=L["Tooltip_Pixel_Border_Castbars_Text_Inside_Desc"], parent="castbarPixelBorder", onChange=function(...) if BBF and BBF.ChangeCastbarSizes then BBF.ChangeCastbarSizes(...) end end, requiresReload=true },
                    }
                }
            }
        }
    }
}


BBF.GUI.Schemas.castbars = schema

function guiCastbars()
    local BetterBlizzFramesCastbars = CreateFrame("Frame")
    BetterBlizzFramesCastbars.name = L["Castbars"]
    BetterBlizzFramesCastbars.parent = BetterBlizzFrames.name
    local castbarsSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, BetterBlizzFramesCastbars, BetterBlizzFramesCastbars.name, BetterBlizzFramesCastbars.name)
    castbarsSubCategory.ID = BetterBlizzFramesCastbars.name
    BBF.CreateTitle(BetterBlizzFramesCastbars)

    BBF.GUI.BuildPanel(BetterBlizzFramesCastbars, schema)

    local reloadUiButton2 = CreateFrame("Button", nil, BetterBlizzFramesSubPanel, "UIPanelButtonTemplate")
    reloadUiButton2:SetText(L["Label_Reload_Ui"])
    reloadUiButton2:SetWidth(96)
    reloadUiButton2:SetPoint("TOP", BetterBlizzFramesSubPanel, "BOTTOMRIGHT", -140, -9)
    reloadUiButton2:SetScript("OnClick", function()
        BetterBlizzFramesDB.reopenOptions = true
        ReloadUI()
    end)

end
