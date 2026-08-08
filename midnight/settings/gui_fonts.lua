if not BBF.isMidnight then return end
local L = BBF.L
BBF.GUI = BBF.GUI or {}
BBF.GUI.Schemas = BBF.GUI.Schemas or {}

local schema = {
    id      = "fonts",
    header  = L["Module_Name_Font_Texture"],
    atlas   = "optionsicon-brown",
    size    = {22, 22},
    divider = true,
    cards   = {
        {
            title   = L["UnitFrame_Fonts"],
            options = {
                {
                    type     = "checkbox",
                    key      = "changeUnitFrameFont",
                    label    = L["Tooltip_Change_UnitFrame_Font_Desc"],
                    tooltip  = L["Tooltip_Change_UnitFrame_Font_Etc_Desc"],
                    onChange = BBF.SetCustomFonts,
                    requiresReload = true,
                    children = {
                        { type="checkbox", key="unitFrameFontColor",    label=L["Color"],                tooltip=L["Tooltip_Color_Change_Font_Desc"], onChange=BBF.FontColors, colorPickerKey="unitFrameFontColorRGB" },
                        { type="checkbox", key="unitFrameFontColorLvl", label=L["FontTexture_Color_Level"], tooltip=L["Tooltip_Color_Level_Font_Desc"],  onChange=BBF.FontColors },
                        { type="dropdown", key="unitFrameFont",        label=L["Font"],                 kind="font", width=195, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="unitFrameFontOutline", label=L["Outline_Label"],        width=195, options={"THICKOUTLINE", "OUTLINE"}, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="unitFrameFontSize",    label=L["Size"],                 width=195, options={"6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"}, onChange=BBF.SetCustomFonts },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changeUnitFrameValueFont",
                    label    = L["Tooltip_Change_UnitFrame_Number_Font_Desc"],
                    tooltip  = L["Tooltip_Change_UnitFrame_Number_Font_Etc_Desc"],
                    onChange = BBF.SetCustomFonts,
                    requiresReload = true,
                    children = {
                        { type="checkbox", key="unitFrameValueFontColor", label=L["Color"], tooltip=L["Tooltip_UnitFrame_Numbers_Font_Color_Desc"], onChange=BBF.FontColors, colorPickerKey="unitFrameValueFontColorRGB" },
                        { type="dropdown", key="unitFrameValueFont",        label=L["Font"],          kind="font", width=195, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="unitFrameValueFontOutline", label=L["Outline_Label"], width=195, options={"THICKOUTLINE", "OUTLINE", ""}, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="unitFrameValueFontSize",    label=L["Size"],          width=195, options={"6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"}, onChange=BBF.SetCustomFonts },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changePartyFrameFont",
                    label    = L["Change_Party_Font"],
                    tooltip  = L["Tooltip_Change_PartyFrames_Font_Desc"],
                    onChange = BBF.SetCustomFonts,
                    requiresReload = true,
                    children = {
                        { type="checkbox", key="partyFrameFontColor", label=L["Color"], tooltip=L["Tooltip_Change_Party_Font_Color_Desc"], onChange=BBF.FontColors, colorPickerKey="partyFrameFontColorRGB" },
                        { type="dropdown", key="partyFrameFont",        label=L["Font"],          kind="font", width=195, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="partyFrameFontOutline", label=L["Outline_Label"], width=195, options={"THICKOUTLINE", "OUTLINE", ""}, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="partyFrameFontSize",    label=L["Tooltip_Name_Size"], width=195, options={"6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"}, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="partyFrameStatusFontSize", label=L["Tooltip_Status_Text_Size"], width=195, options={"6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"}, onChange=BBF.SetCustomFonts },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changeActionBarFont",
                    label    = L["Change_ActionBar_Font"],
                    tooltip  = L["Tooltip_Change_ActionBar_Font_Etc_Desc"],
                    onChange = BBF.SetCustomFonts,
                    requiresReload = true,
                    children = {
                        { type="checkbox", key="actionBarFontColor",  label=L["Color"],   tooltip=L["Tooltip_Change_ActionBar_Font_Color_Desc"], onChange=BBF.FontColors, colorPickerKey="actionBarFontColorRGB" },
                        { type="checkbox", key="actionBarChangeCharge",label=L["Charges"], tooltip=L["Tooltip_Charges_Font_Desc"], onChange=BBF.FontColors },
                        { type="dropdown", key="actionBarFont",           label=L["Font"],                     kind="font", width=195, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="actionBarFontOutline",    label=L["Tooltip_Macro_Text_Outline"],      width=195, options={"THICKOUTLINE", "OUTLINE", ""}, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="actionBarKeyFontOutline", label=L["Tooltip_Keybinding_Text_Outline"], width=195, options={"THICKOUTLINE", "OUTLINE", ""}, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="actionBarFontSize",       label=L["Tooltip_Macro_Text_Size"],         width=195, options={"6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"}, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="actionBarKeyFontSize",    label=L["Tooltip_Keybinding_Text_Size"],    width=195, options={"6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"}, onChange=BBF.SetCustomFonts },
                        { type="dropdown", key="actionBarChargeFontSize", label=L["Tooltip_Charge_Text_Size"],       width=195, options={"6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"}, onChange=BBF.SetCustomFonts, parent="actionBarChangeCharge" },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changeAllFontsIngame",
                    label    = L["Tooltip_One_Font_All_Text_Desc"],
                    tooltip  = L["Tooltip_One_Font_All_Text_Desc"],
                    subText  = L["Tooltip_One_Font_All_Text_Extra"],
                    onChange = BBF.SetCustomFonts,
                    requiresReload = true,
                    children = {
                        { type="dropdown", key="allIngameFont", label=L["Font"], kind="font", width=195, onChange=BBF.SetCustomFonts },
                    }
                },
            }
        },
        {
            title   = L["Statusbar_Textures"],
            options = {
                {
                    type     = "checkbox",
                    key      = "changeUnitFrameHealthbarTexture",
                    label    = L["Tooltip_Change_UnitFrame_Healthbar_Texture_Desc"],
                    tooltip  = L["Tooltip_Change_UnitFrame_Healthbar_Texture_Desc"],
                    onChange = BBF.UpdateCustomTextures,
                    requiresReload = true,
                    children = {
                        { type="dropdown", key="unitFrameHealthbarTexture", label=L["Select_Texture"], kind="texture", width=195, onChange=BBF.UpdateCustomTextures },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changeUnitFrameManabarTexture",
                    label    = L["Tooltip_Change_UnitFrame_Manabar_Texture_Desc"],
                    tooltip  = L["Tooltip_Change_UnitFrame_Manabar_Texture_Desc"],
                    onChange = BBF.UpdateCustomTextures,
                    requiresReload = true,
                    children = {
                        { type="checkbox", key="changeUnitFrameManaBarTextureKeepFancy", label=L["Keep_Fancy_Manabars"], tooltip=L["Tooltip_Keep_Fancy_Manabars_Desc"], requiresReload=true },
                        { type="dropdown", key="unitFrameManabarTexture",               label=L["Select_Texture"],     kind="texture", width=195, onChange=BBF.UpdateCustomTextures },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changeUnitFrameCastbarTexture",
                    label    = L["Change_Castbar_Texture"],
                    tooltip  = L["Tooltip_Change_Castbar_Texture_Desc"],
                    onChange = BBF.UpdateCustomTextures,
                    requiresReload = true,
                    children = {
                        { type="dropdown", key="unitFrameCastbarTexture", label=L["Select_Texture"], kind="texture", width=195, onChange=BBF.UpdateCustomTextures },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "addUnitFrameBgTexture",
                    label    = L["Change_UnitFrame_Background_Texture"],
                    tooltip  = L["Tooltip_Change_UnitFrame_Background_Texture_Desc"],
                    onChange = function() BBF.UpdateCustomTextures(); BBF.UnitFrameBackgroundTexture() end,
                    requiresReload = true,
                    children = {
                        { type="dropdown", key="unitFrameBgTexture",          label=L["Select_Texture"], kind="texture", width=195, onChange=function() BBF.UpdateCustomTextures(); BBF.UnitFrameBackgroundTexture() end },
                        { type="checkbox", key="unitFrameBgTextureColor",     label="Health BG", colorPickerKey="unitFrameBgTextureColorRGB", onChange=BBF.UnitFrameBackgroundTexture },
                        { type="checkbox", key="unitFrameBgTextureManaColor", label="Mana BG",   colorPickerKey="unitFrameBgTextureManaColorRGB", onChange=BBF.UnitFrameBackgroundTexture },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changeRaidFrameHealthbarTexture",
                    label    = L["Tooltip_Change_RaidFrame_Healthbar_Texture_Desc"],
                    tooltip  = L["Tooltip_Change_RaidFrame_Healthbar_Texture_Etc_Desc"],
                    onChange = BBF.UpdateCustomTextures,
                    requiresReload = true,
                    children = {
                        { type="dropdown", key="raidFrameHealthbarTexture", label=L["Select_Texture"], kind="texture", width=195, onChange=BBF.UpdateCustomTextures },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changeRaidFrameManabarTexture",
                    label    = L["Tooltip_Change_RaidFrame_Manabar_Texture_Desc"],
                    tooltip  = L["Tooltip_Change_RaidFrame_Manabar_Texture_Etc_Desc"],
                    onChange = BBF.UpdateCustomTextures,
                    children = {
                        { type="dropdown", key="raidFrameManabarTexture", label=L["Select_Texture"], kind="texture", width=195, onChange=BBF.UpdateCustomTextures },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changePartyRaidFrameBackgroundColor",
                    label    = L["Change_RaidFrame_Background_Texture"],
                    tooltip  = L["Tooltip_Change_RaidFrame_Background_Texture_Desc"],
                    onChange = function() BBF.UpdateCustomTextures(); BBF.SetCompactUnitFramesBackground() end,
                    requiresReload = true,
                    children = {
                        { type="dropdown", key="raidFrameBgTexture",                      label=L["Select_Texture"], kind="texture", width=195, onChange=function() BBF.UpdateCustomTextures(); BBF.SetCompactUnitFramesBackground() end },
                        { type="checkbox", key="partyRaidFrameBackgroundHealthColor",     label="Health BG", colorPickerKey="partyRaidFrameBackgroundHealthColorRGB", onChange=BBF.SetCompactUnitFramesBackground },
                        { type="checkbox", key="partyRaidFrameBackgroundManaColor",       label="Mana BG",   colorPickerKey="partyRaidFrameBackgroundManaColorRGB", onChange=BBF.SetCompactUnitFramesBackground },
                    }
                },
            }
        },
        {
            title   = "Personal Resource Display",
            options = {
                {
                    type     = "checkbox",
                    key      = "prdLegacyLook",
                    label    = L["PRD_Legacy_Look"],
                    tooltip  = L["Tooltip_PRD_Legacy_Look_Desc"],
                    onChange = function() BBF.LegacyPRDLook(); BBF.TexturePRD() end,
                    children = {
                        { type="checkbox", key="prdSplitLines", label=L["PRD_Split_Lines"], tooltip=L["Tooltip_PRD_Split_Lines_Desc"], onChange=BBF.LegacyPRDLook },
                    }
                },
                {
                    type     = "checkbox",
                    key      = "changePrdTextures",
                    label    = L["Tooltip_Change_Personal_Resource_Display_Textures"],
                    tooltip  = L["Tooltip_Change_Personal_Resource_Display_Textures_Desc"],
                    onChange = BBF.TexturePRD,
                    children = {
                        { type="checkbox", key="useCustomTextureForExtraBars", label=L["Tooltip_Change_PRD_Extra_Bars_Texture_Desc"], tooltip=L["Tooltip_Change_PRD_Extra_Bars_Texture_Desc"] },
                        {
                            type     = "checkbox",
                            key      = "useCustomTextureForSelf",
                            label    = L["Tooltip_Change_PRD_Healthbar_Texture_Desc"],
                            tooltip  = L["Tooltip_Change_PRD_Healthbar_Texture_Desc"],
                            onChange = BBF.TexturePRD,
                            children = {
                                { type="dropdown", key="customTextureSelf", label=L["Select_Texture"], kind="texture", width=195, onChange=BBF.TexturePRD },
                            }
                        },
                        {
                            type     = "checkbox",
                            key      = "useCustomTextureForSelfMana",
                            label    = L["Tooltip_Change_PRD_Manabar_Texture_Desc"],
                            tooltip  = L["Tooltip_Change_PRD_Manabar_Texture_Desc"],
                            onChange = BBF.TexturePRD,
                            children = {
                                { type="checkbox", key="fancyPrdAltTexture",       label=L["Keep_Fancy_Manabars"], tooltip=L["Tooltip_Keep_Fancy_PRD_Mana_Desc"], onChange=BBF.TexturePRD },
                                { type="dropdown", key="customTextureSelfMana",    label=L["Select_Texture"],      kind="texture", width=195, onChange=BBF.TexturePRD },
                            }
                        },
                    }
                },
            }
        }
    }
}

BBF.GUI.Schemas.fonts = schema

function guiFrameLook()
    local guiFrameLookPanel = CreateFrame("Frame")
    guiFrameLookPanel.name = L["Module_Name_Font_Texture"]
    guiFrameLookPanel.parent = BetterBlizzFrames.name
    local fontSubCategory = Settings.RegisterCanvasLayoutSubcategory(BBF.category, guiFrameLookPanel, guiFrameLookPanel.name, guiFrameLookPanel.name)
    fontSubCategory.ID = guiFrameLookPanel.name
    BBF.CreateTitle(guiFrameLookPanel)

    BBF.GUI.BuildPanel(guiFrameLookPanel, schema)
end
