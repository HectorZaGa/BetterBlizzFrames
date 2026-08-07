-- ============================================================
-- BetterBlizzFrames: midnight/settings/gui_auras.lua
-- Pure Declarative Schema for Auras Module Settings.
-- ============================================================
if not BBF.isMidnight then return end

local L = BBF.L
BBF.GUI = BBF.GUI or {}
BBF.GUI.Schemas = BBF.GUI.Schemas or {}

local schema = {
    tabs = {
        --------------------------------------------------------
        -- TAB 1: Player Aura
        --------------------------------------------------------
        {
            id          = "player",
            label       = L["Player_Auras"],
            atlas       = "groupfinder-icon-friend",
            size        = {22, 22},
            cards       = {
                {
                    title   = L["Player_Aura_Settings"],
                    options = {
                        { type="checkbox", key="enablePlayerBuffFiltering",  label=L["Enable_Player_Aura_Adjustments"], tooltip="" },
                        { type="checkbox", key="clickthroughPlayerAuras",    label=L["Clickthrough_Player_Auras"],       tooltip=L["Tooltip_Clickthrough_Player_Auras"], parent="enablePlayerBuffFiltering" },
                        { type="checkbox", key="hidePlayerAuraTooltips",     label=L["Hide_Player_Aura_Tooltips"],      tooltip="", parent="enablePlayerBuffFiltering" },
                        { type="slider",   key="playerAuraSpacingX",         label=L["Horizontal_Padding"],              tooltip=L["Tooltip_Horizontal_Padding"], parent="enablePlayerBuffFiltering", min=-10, max=10, step=1 },
                        { type="slider",   key="playerAuraSpacingY",         label=L["Vertical_Padding"],                tooltip="", parent="enablePlayerBuffFiltering", min=-10, max=10, step=1 },
                    }
                }
            }
        },

        --------------------------------------------------------
        -- TAB 2: Target & Focus Aura
        --------------------------------------------------------
        {
            id          = "targetfocus",
            label       = L["Target_And_Focus_Auras"],
            atlas       = "groupfinder-icon-friend",
            size        = {22, 22},
            desaturated = true,
            color       = {0, 1, 0},
            overlays    = {
                { atlas="TargetCrosshairs", size={22,22}, offset={8,-8} },
            },
            cards       = {
                {
                    title   = L["Dimensions_And_Layout"],
                    options = {
                        { type="slider",   key="targetAndFocusAuraScale",      label=L["All_Aura_Size"],        tooltip=L["Tooltip_All_Aura_Size"], min=0.7, max=2, step=0.01 },
                        { type="slider",   key="targetAndFocusSmallAuraScale", label=L["Small_Aura_Size"],      tooltip=L["Tooltip_Small_Aura_Size"], min=0.5, max=2, step=0.01 },
                        { type="checkbox", key="sameSizeAuras",                label=L["Same_Size"],            tooltip=L["Tooltip_Same_Size"], parent="targetAndFocusSmallAuraScale", inverseParent=true },
                        { type="slider",   key="targetAndFocusAurasPerRow",    label=L["Max_Auras_Per_Row"],    tooltip="", min=1, max=12, step=1 },
                        { type="slider",   key="targetAndFocusAuraOffsetX",    label=L["X_Offset"],             tooltip="", min=-50, max=50, step=1 },
                        { type="slider",   key="targetAndFocusAuraOffsetY",    label=L["Y_Offset"],             tooltip="", min=-50, max=50, step=1 },
                        { type="slider",   key="targetAndFocusHorizontalGap",  label=L["Horizontal_Gap"],       tooltip="", min=0, max=18, step=0.5 },
                        { type="slider",   key="targetAndFocusVerticalGap",    label=L["Vertical_Gap"],         tooltip="", min=0, max=18, step=0.5 },
                        { type="slider",   key="auraTypeGap",                  label=L["Aura_Type_Gap"],        tooltip=L["Tooltip_Aura_Type_Gap"], min=0, max=30, step=1 },
                    }
                },
                {
                    title   = L["Text_And_Timers"],
                    options = {
                        { type="slider",   key="auraStackSize",      label=L["Aura_Stack_Size"],       tooltip=L["Tooltip_Aura_Stack_Size"], min=0.4, max=2, step=0.01 },
                        { type="checkbox", key="showAuraCdText",     label=L["Show_Aura_Timer_Text"],  tooltip=L["Tooltip_Show_Aura_Timer_Text"] },
                        { type="slider",   key="auraCdTextSize",     label=L["Aura_CD_Text_Size"],     tooltip=L["Tooltip_Aura_CD_Text_Size"], parent="showAuraCdText", min=0.4, max=2, step=0.01 },
                        { type="checkbox", key="auraCdTextOnlyMine", label=L["Only_Mine"],             tooltip=L["Tooltip_Aura_CD_Text_Only_Mine"], parent="showAuraCdText" },
                    }
                }
            }
        },
        
        --------------------------------------------------------
        -- TAB 3: Display & Visibility
        --------------------------------------------------------
        {
            id          = "display",
            label       = L["Display_And_Visibility"],
            atlas       = "optionsicon-brown",
            size        = {20, 20},
            cards       = {
                {
                    title   = L["Aura_Styling"],
                    options = {
                        { type="checkbox", key="changePurgeTextureColor", label=L["Change_Purge_Texture_Color"], tooltip=L["Change_Purge_Texture_Color_Desc"], colorPicker={r=0, g=1, b=0}, colorPickerKey="purgeTextureColorRGB" },
                        { type="checkbox", key="increaseAuraStrata",          label=L["Increase_Aura_Frame_Strata"],   tooltip=L["Tooltip_Increase_Aura_Frame_Strata"] },
                        { type="checkbox", key="hideUnitframeAuraTooltips",   label=L["Hide_UnitFrame_Aura_Tooltips"],  tooltip=L["Tooltip_Hide_UnitFrame_Aura_Tooltips"] },
                        { type="checkbox", key="pixelBorderAuras",            label=L["Pixel_Border_Auras"],           tooltip=L["Tooltip_Pixel_Border_Auras_Desc"] },
                        { type="checkbox", key="removeDebuffColorBorder",     label=L["Remove_Debuff_Color_Border"],    tooltip=L["Tooltip_Remove_Debuff_Color_Border"] },
                    }
                },
                {
                    title   = L["Hide_Auras"],
                    options = {
                        { type="checkbox", key="hideTargetBuffs",   label=L["Hide_Target_Buffs"],   tooltip=L["Tooltip_Hide_Target_Buffs_Desc"] },
                        { type="checkbox", key="hideTargetDebuffs",  label=L["Hide_Target_Debuffs"],  tooltip=L["Tooltip_Hide_Target_Debuffs_Desc"] },
                        { type="checkbox", key="hideFocusBuffs",    label=L["Hide_Focus_Buffs"],    tooltip=L["Tooltip_Hide_Focus_Buffs_Desc"] },
                        { type="checkbox", key="hideFocusDebuffs",   label=L["Hide_Focus_Debuffs"],   tooltip=L["Tooltip_Hide_Focus_Debuffs_Desc"] },
                    }
                },
                {
                    title   = L["Aura_Limits"],
                    options = {
                        { type="checkbox", key="enableMaxTargetFocusBuffs",   label=L["Max_Buffs"],   tooltip=L["Max_Buffs"] },
                        { type="slider",   key="maxTargetFocusBuffs",         label=L["Max_Buffs"],   tooltip="", parent="enableMaxTargetFocusBuffs", min=1, max=100, step=1 },
                        { type="checkbox", key="enableMaxTargetFocusDebuffs",  label=L["Max_Debuffs"], tooltip=L["Max_Debuffs"] },
                        { type="slider",   key="maxTargetFocusDebuffs",        label=L["Max_Debuffs"], tooltip="", parent="enableMaxTargetFocusDebuffs", min=1, max=100, step=1 },
                    }
                }
            }
        }
    }
}

BBF.GUI.Schemas.auras = schema

function guiFrameAuras()
    local guiFrameAurasFrame = CreateFrame("Frame")
    guiFrameAurasFrame.name = L["Module_Name_Auras"]
    guiFrameAurasFrame.parent = BetterBlizzFrames.name
    local aurasSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiFrameAurasFrame, guiFrameAurasFrame.name, guiFrameAurasFrame.name)
    aurasSubCategory.ID = guiFrameAurasFrame.name
    BBF.aurasSubCategory = guiFrameAurasFrame.name
    BBF.CreateTitle(guiFrameAurasFrame)

    BBF.GUI.BuildPanel(guiFrameAurasFrame, schema)
end
