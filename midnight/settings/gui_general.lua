-- ============================================================
-- BetterBlizzFrames: midnight/settings/gui_general.lua
-- SCHEMA DEFINITION — Pure data, zero WoW API calls.
-- The engine (midnight/gui_builder.lua) consumes this table
-- and builds all UI frames automatically.
-- ============================================================
if not BBF.isMidnight then return end
local L = BBF.L


-- ============================================================
function guiGeneralTab()
    -- Special elements unique to the General panel (cannot be schema-driven)
    local mainGuiAnchor = BetterBlizzFrames:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainGuiAnchor:SetPoint("TOPLEFT", 15, -15)
    mainGuiAnchor:SetText(" ")

    BetterBlizzFrames.searchName = L["Search_Name_General"]

    local profilesFrame = guiProfiles()

    local midnightBeta = BetterBlizzFrames:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    midnightBeta:SetPoint("BOTTOM", SettingsPanel, "TOP", 0, 0)
    midnightBeta:SetText(L["Msg_Midnight_Early_Beta"])
    midnightBeta:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
    midnightBeta:Hide()
    BetterBlizzFrames:HookScript("OnShow", function() midnightBeta:Show() end)
    BetterBlizzFrames:HookScript("OnHide", function() midnightBeta:Hide() end)

    local newSearch = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearch:SetAtlas("NewCharacter-Horde", true)
    newSearch:SetPoint("BOTTOM", BetterBlizzFrames, "TOP", -70, 2)
    BBF.CreateTooltipTwo(newSearch, L["Search"], L["Tooltip_Search_Desc"])

    local newSearchPoint = BetterBlizzFrames:CreateTexture(nil, "BACKGROUND")
    newSearchPoint:SetAtlas("auctionhouse-icon-buyallarrow", true)
    newSearchPoint:SetPoint("LEFT", newSearch, "RIGHT", -25, 0)
    newSearchPoint:SetRotation(math.pi / 2)

    BBF.CreateSearchFrame()
    BBF.CreateTitle(BetterBlizzFrames)

    if BetterBlizzFrames.titleText then
        BetterBlizzFrames.titleText:Hide()
        BetterBlizzFrames.loadGUI:Hide()
    end

    -- ============================================================
    -- SCHEMA
    -- Each entry is a tab: { id, label, atlas, size, ... , cards }
    -- Each card: { title, options = { { type, key, label, ... } } }
    -- Option types: "checkbox", "slider", "header", "preview", "dualchild"
    -- Children are declared inline with: children = { {...}, {...} }
    -- Multi-parent children use: type="checkbox", parents={"id1","id2"}
    -- ============================================================
    local schema = {
        popups = {
            customColors = {
                id         = "BBFCustomColorOptionsFrame",
                title      = L["Custom_Health_Colors"],
                width      = 360,
                height     = 560,
                scrollable = true,
                options    = {
                    { type="header", label=L["Custom_Colors"] },
                    { type="checkbox", key="customColorsUnitFrames", label=L["Enable_On_UnitFrames"], tooltip=L["Tooltip_Enable_On_UnitFrames_Desc"], onChange=BBF.UpdateFrames },
                    { type="checkbox", key="customColorsRaidFrames", label=L["Enable_On_Raid_Party_Frames"], tooltip=L["Tooltip_Enable_On_Raid_Party_Frames_Desc"], onChange=BBF.UpdateFrames },

                    { type="header", label=L["Reaction_Colors"] },
                    { type="colorGrid", columns=3, options = {
                        { key="enemyHealthColor",    label=_G["ENEMY"] or L["Enemy"],      default={r=1, g=0.2, b=0.2} },
                        { key="friendlyHealthColor", label=_G["FRIENDLY"] or L["Friendly"],default={r=0.2, g=1, b=0.2} },
                        { key="neutralHealthColor",  label=_G["NEUTRAL"] or L["Neutral"],  default={r=1, g=1, b=0.2} },
                    }},

                    { type="header", label=L["Class_Colors"] },
                    { type="checkbox", key="overrideClassColors", label=L["Override_Class_Colors"], tooltip=L["Tooltip_Override_Class_Colors_Desc"] },
                    { type="checkbox", key="useOneClassColor", label=L["Use_One_Color"], tooltip=L["Tooltip_Use_One_Color_For_All_Classes_Desc"], parent="overrideClassColors" },
                    { type="colorGrid", parent="useOneClassColor", inline=true, options = {
                        { key="singleClassColor", label=L["All_Classes"], default={r=0.8, g=0.8, b=0.8} }
                    }},
                    { type="allClassSwatches", parent="overrideClassColors", marginTop = 4 },

                    { type="header", label=L["Power_Colors"] },
                    { type="checkbox", key="customPowerColors", label=L["Enable_Power_Colors"], tooltip=L["Tooltip_Enable_Power_Colors_Desc"] },
                    { type="checkbox", key="useOnePowerColor", label=L["Use_One_Color"], tooltip=L["Tooltip_Use_One_Color_For_All_Powers_Desc"], parent="customPowerColors" },
                    { type="colorGrid", parent="useOnePowerColor", inline=true, options = {
                        { key="singlePowerColor", label=L["All_Classes"], default={r=0, g=0.8, b=1} }
                    }},
                    { type="allPowerSwatches", parent="customPowerColors", marginTop = 4 },

                    { type="header", label=L["Background_Colors"] },
                    { type="checkbox", key="customBgColorUnitFrames", label=L["Change_UnitFrame_Background_Color"], tooltip=L["Tooltip_Change_UnitFrame_Background_Color_Desc"] },
                    { type="colorSwatchDual", parent="customBgColorUnitFrames", key1="customHealthBgColor", label1=L["Health_BG"], default1={r=0, g=0, b=0}, key2="customManaBgColor", label2=L["Mana_BG"], default2={r=0, g=0, b=0} },

                    { type="checkbox", key="customBgColorRaidFrames", label=L["Change_Party_RaidFrame_Background_Color"], tooltip=L["Tooltip_Change_Party_RaidFrame_Background_Color_Desc"] },
                    { type="colorSwatchDual", parent="customBgColorRaidFrames", key1="customRaidHealthBgColor", label1=L["Health_BG"], default1={r=0, g=0, b=0}, key2="customRaidManaBgColor", label2=L["Mana_BG"], default2={r=0, g=0, b=0} },
                },
            },
            classSpecific = {
                id     = "ClassOptionsFrame",
                title  = L["Class_Specific_Options"],
                width  = 260,
                height = 310,
                options = {
                    { type="classCheckbox", classID=11, key="hidePlayerPowerNoDruid",      onChange=BBF.HideFrames },
                    { type="classCheckbox", classID=4,  key="hidePlayerPowerNoRogue",      onChange=BBF.HideFrames },
                    { type="classCheckbox", classID=9,  key="hidePlayerPowerNoWarlock",    onChange=BBF.HideFrames },
                    { type="classCheckbox", classID=2,  key="hidePlayerPowerNoPaladin",    onChange=BBF.HideFrames },
                    { type="classCheckbox", classID=6,  key="hidePlayerPowerNoDeathKnight",onChange=BBF.HideFrames },
                    { type="classCheckbox", classID=13, key="hidePlayerPowerNoEvoker",     onChange=BBF.HideFrames },
                    { type="classCheckbox", classID=10, key="hidePlayerPowerNoMonk",       onChange=BBF.HideFrames },
                    { type="classCheckbox", classID=8,  key="hidePlayerPowerNoMage",       onChange=BBF.HideFrames },
                },
            },
        },
        tabs = {
            --------------------------------------------------------
            -- TAB 1: General
            --------------------------------------------------------
            {
                id    = "general",
                label = L["General"],
                atlas = "optionsicon-brown",
                size  = {20, 20},
                cards = {
                    {
                        title = L["General_Settings"],
                        options = {
                            { type="checkbox", key="hideArenaFrames",  label=L["Hide_Arena_Frames"],  tooltip=L["Tooltip_Hide_Arena_Frames"],  onChange=BBF.HideArenaFrames },
                            { type="checkbox", key="hideBossFrames",    label=L["Hide_Boss_Frames"],   tooltip=L["Tooltip_Hide_Boss_Frames"],   onChange=BBF.HideArenaFrames, id="cbBoss",
                                children = {
                                    { type="checkbox", key="hideBossFramesParty", label=L["Party"], tooltip=L["Tooltip_Hide_Boss_Frames_Party"] },
                                    { type="checkbox", key="hideBossFramesRaid",  label=L["Raid"],  tooltip=L["Tooltip_Hide_Boss_Frames_Raid"] },
                                }
                            },
                            { type="checkbox", key="playerFrameOCD",    label=L["OCD_Tweaks"],         tooltip=L["Tooltip_OCD_Tweaks_Retail"],  onChange=BBF.FixStupidBlizzPTRShit },
                            { type="checkbox", key="removeRealmNames",  label=L["Hide_Realm"],         tooltip=L["Tooltip_Hide_Realm_Desc"] },
                        },
                    },
                    {
                        title = L["Crowd_Control"],
                        options = {
                            { type="checkbox", key="hideLossOfControlFrameBg",    label=L["Hide_CC_Background"], tooltip=L["Tooltip_Hide_CC_Background"], onChange=BBF.HideFrames },
                            { type="checkbox", key="hideLossOfControlFrameLines", label=L["Hide_CC_Red_Lines"],  tooltip=L["Tooltip_Hide_CC_Red_Lines"], onChange=BBF.HideFrames },
                            { type="slider",   key="lossOfControlScale",          label=L["Loss_of_Control_Scale"], tooltip=L["Tooltip_CC_Scale_Desc"], min=0.4, max=1.4, step=0.01 },
                        },
                    },
                    {
                        title = L["Dark_Mode_Settings"],
                        options = {
                            { type="checkbox", key="darkModeUi", label=L["Dark_Mode"], tooltip=L["Tooltip_Dark_Mode"], onChange=function() BBF.DarkmodeFrames(true) end, id="cbDark",
                                children = {
                                    { type="slider",   key="darkModeColor",               label=L["Darkness"],           tooltip=L["Tooltip_Dark_Mode_Value"],           min=0, max=1, step=0.01 },
                                    { type="checkbox", key="darkModeCastbars",             label=L["Castbars"],           tooltip=L["Dark_Borders_Castbars"],            onChange=function() BBF.DarkmodeFrames(true) end },
                                    { type="checkbox", key="darkModeActionBars",           label=L["ActionBars"],         tooltip=L["Dark_Borders_ActionBars"],          onChange=function() BBF.DarkmodeFrames(true) end },
                                    { type="checkbox", key="darkModeUiAura",               label=L["Auras"],              tooltip=L["Dark_Borders_Aura_Icons"],          onChange=function() BBF.DarkmodeFrames(true) end },
                                    { type="checkbox", key="darkModeMinimap",              label=L["Minimap"],            tooltip=L["Dark_Mode_Minimap"],                onChange=function() BBF.DarkmodeFrames(true) end },
                                    { type="checkbox", key="darkModeNameplateResource",    label=L["Nameplate_Resource"], tooltip=L["Dark_Mode_Nameplate_Resource"],      onChange=function() BBF.DarkmodeFrames(true) end },
                                    { type="checkbox", key="darkModeGameTooltip",          label=L["Tooltip"],            tooltip=L["Tooltip_Dark_Mode_Tooltip_Desc"],   onChange=function() BBF.DarkmodeFrames(true) end },
                                    { type="checkbox", key="darkModeObjectiveFrame",       label=L["Objectives"],         tooltip=L["Tooltip_Dark_Mode_Objectives_Desc"],onChange=function() BBF.DarkmodeFrames(true) end },
                                    { type="checkbox", key="darkModeVigor",                label=L["Vigor"],              tooltip=L["Tooltip_Dark_Mode_Vigor_Desc"],     onChange=function() BBF.DarkmodeFrames(true) end },
                                    { type="checkbox", key="darkModeEliteTexture",         label=L["Elite_Texture"],      tooltip=L["Tooltip_Dark_Mode_Elite_Desc"],     onChange=function() BBF.DarkmodeFrames(true) end,
                                        },
                                }
                            },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 2: Player Frame
            --------------------------------------------------------
            {
                id         = "player",
                label      = L["Player_Frame"],
                atlas      = "groupfinder-icon-friend",
                size       = {22, 22},
                desaturated = true,
                color      = {0.1, 0.6, 1},
                cards = {
                    {
                        title = L["Frame_Layout"],
                        options = {
                            { type="checkbox", key="playerFrameHidden",          label=L["Hide_Frame"],           tooltip=L["Tooltip_Hide_Player_Frame"],            onChange=function() BBF.HidePlayerFrame() end },
                            { type="checkbox", key="playerFrameClickthrough",    label=L["Clickthrough"],         tooltip=L["Tooltip_Clickthrough"] },
                            { type="checkbox", key="symmetricPlayerFrame",       label=L["Mirror_TargetFrame"],   tooltip=L["Tooltip_Mirror_TargetFrame_Desc"] },
                            { type="checkbox", key="hideTotemFrame",             label=L["Hide_Totem_Frame"],     tooltip=L["Tooltip_Hide_Totem_Frame"],             onChange=BBF.HideFrames },
                            { type="checkbox", key="playerReputationClassColor", label=L["Class_Color_Combo"],   tooltip=L["Tooltip_Class_Color_Reputation"],       onChange=BBF.PlayerReputationColor },
                            { type="checkbox", key="playerReputationColor",      label=L["Add_Reputation_Color"],tooltip=L["Tooltip_Add_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a", onChange=BBF.PlayerReputationColor },
                            { type="checkbox", key="playerEliteFrame",           label=L["Show_Elite_Texture"],  tooltip=L["Tooltip_Show_Elite_Texture_Desc"],      onChange=function() if BBF.PlayerEliteFrame then BBF.PlayerEliteFrame() end end},
                        },
                    },
                    {
                        title = L["Display_Resources"],
                        options = {
                            { type="checkbox", key="hidePlayerName",         label=L["Hide_Names"],            tooltip="",                                    onChange=function() BBF.SetCenteredNamesCaller() end },
                            { type="checkbox", key="hidePlayerPower",        label=L["Hide_Resource_Power"],   tooltip=L["Tooltip_Hide_Resource_Power_Desc"],  onChange=BBF.HideFrames,
                                onRightClick = function(isShift, isCtrl, isAlt, widget) if BBF.OpenClassSpecificWindow then BBF.OpenClassSpecificWindow() end end },
                            { type="checkbox", key="hideResourceTooltip",    label=L["Hide_Resource_Tooltip"], tooltip=L["Tooltip_Hide_Resource_Tooltip_Desc"],onChange=BBF.HideClassResourceTooltip },
                            { type="checkbox", key="hideManaFeedback",       label=L["Hide_Mana_Feedback"],    tooltip=L["Tooltip_Hide_Mana_Feedback_Desc"],   onChange=BBF.HideFrames },
                        },
                    },
                    {
                        title = L["Visual_Effects_Glows"],
                        options = {
                            { type="checkbox", key="hidePlayerHealthLossAnim", label=L["Hide_Health_Loss_FX"],      tooltip=L["Tooltip_Hide_Health_Loss_FX_Desc"], onChange=BBF.HideFrames },
                            { type="checkbox", key="hideFullPower",            label=L["Tooltip_Hide_Full_Mana_FX"],tooltip=L["Tooltip_Hide_Full_Mana_FX_Desc"] .. " |A:FullAlert-FrameGlow:16:30|a", onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePlayerRestGlow",       label=L["Hide_Rest_Glow"],           tooltip=L["Tooltip_Hide_Rest_Glow"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-Status:16:42|a", onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePlayerRestAnimation",  label=L["Hide_Zzz_Rest_Animation"],  tooltip=L["Tooltip_Hide_Zzz_Rest"],          onChange=BBF.HideFrames },
                        },
                    },
                    {
                        title = L["Icons_Indicators"],
                        options = {
                            { type="checkbox", key="hideCombatIcon",         label=L["Hide_Combat_Icon"],      tooltip=L["Tooltip_Hide_Combat_Icon"] .. " |A:UI-HUD-UnitFrame-Player-CombatIcon:16:16|a",                     onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePlayerRoleIcon",     label=L["Hide_Role_Icon"],        tooltip=L["Tooltip_Hide_Role_Icon"] .. " |A:roleicon-tiny-dps:16:16|a",                                        onChange=BBF.HideFrames },
                            { type="checkbox", key="hideGroupIndicator",     label=L["Hide_Group_Indicator"],  tooltip=L["Tooltip_Hide_Group_Indicator"],                                                                  onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePlayerLeaderIcon",   label=L["Hide_Leader_Icon"],      tooltip=L["Tooltip_Hide_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:16:16|a",              onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePlayerGuideIcon",    label=L["Hide_Guide_Icon"],       tooltip=L["Tooltip_Hide_Guide_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-GuideIcon:16:16|a",               onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePlayerCornerIcon",   label=L["Hide_Corner_Icon"],      tooltip=L["Tooltip_Hide_Corner_Icon"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment:16:16|a",onChange=BBF.HideFrames },
                            { type="checkbox", key="hideHitIndicator",       label=L["Hide_Hit_Indicator"],    tooltip=L["Tooltip_Hide_Hit_Indicator_Desc"],                                                               onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePvpTimerText",       label=L["Hide_PvP_Timer"],        tooltip=L["Tooltip_Hide_PvP_Timer_Desc"],                                                                  onChange=BBF.HideFrames },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 3: Party Frame
            --------------------------------------------------------
            {
                id    = "party",
                label = L["Party_Frame"],
                atlas = "groupfinder-icon-friend",
                size  = {20, 20},
                desaturated = true,
                color = {0.1, 0.6, 1},
                overlays = {
                    { atlas="groupfinder-icon-friend", size={16,16}, offset={4,3}, desaturated=true, color={0,1,0} },
                },
                cards = {
                    {
                        title = L["Frame_Layout"],
                        options = {
                            { type="slider",   key="partyFrameScale",                label=L["Party_Frame_Scale"],       tooltip="",                                       min=0.7, max=1.7, step=0.01 },
                            { type="slider",   key="partyFrameRangeAlpha",           label=L["Change_Party_Frame_Alpha"],tooltip=L["Tooltip_Party_Frame_Range_Alpha"],     min=0,   max=1,   step=0.01 },
                            { type="checkbox", key="hidePartyFramesInArena",         label=L["Hide_Party_in_Arena"],     tooltip=L["Tooltip_Hide_Party_in_Arena_GEX"],    onChange=BBF.HidePartyInArena },
                            { type="checkbox", key="hideRaidFrameManager",           label=L["Hide_RaidFrameManager"],   tooltip=L["Tooltip_Hide_RaidFrameManager"],       onChange=BBF.HideFrames },
                            { type="checkbox", key="raidFramePixelBorder",           label=L["Pixel_Border"],            tooltip=L["Tooltip_Pixel_Border_RaidFrames_Desc"] },
                            { type="checkbox", key="hideCompactUnitFrameBackground", label=L["Hide_Bg"],                 tooltip=L["Tooltip_Hide_Compact_Frame_Backgrounds"],onChange=BBF.HideCompactUnitFrameBackgrounds },
                            { type="checkbox", key="hideRaidFrameContainerBorder",   label=L["Hide_Container_Border"],   tooltip=L["Tooltip_Hide_Container_Border_Desc"],  onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePartyFrameTitle",            label=L["Hide_CompactPartyFrame_Title"],tooltip=L["Tooltip_Hide_CompactPartyFrame_Title"],onChange=BBF.HideFrames },
                        },
                    },
                    {
                        title = L["Display_Text"],
                        options = {
                            { type="checkbox", key="hidePartyNames",      label=L["Hide_Names"],      tooltip="",                                           onChange=function() BBF.AllNameChanges() end },
                            { type="checkbox", key="classColorPartyNames",label=L["Color_Names"],     tooltip=L["Tooltip_Class_Color_Names_Party_Raid"],   onChange=BBF.AllNameChanges },
                            { type="checkbox", key="hidePartyRoles",      label=L["Hide_Role_Icons"], tooltip=L["Tooltip_Hide_Party_Role_Icons"],          onChange=function() BBF.PartyNameChange() end },
                            { type="checkbox", key="newRaidFrameRoleIcons",label=L["New_Role_Icons"],  tooltip=L["Tooltip_New_Role_Icons_Desc"] },
                            { type="checkbox", key="hidePartyRangeIcon",  label=L["Hide_Range_Icon"], tooltip=L["Tooltip_Hide_Range_Icon"],                onChange=BBF.HideFrames },
                        },
                    },
                    {
                        title = L["Combat_Status"],
                        options = {
                            { type="checkbox", key="showPartyCastbar",        label=L["Party_Castbars"],       tooltip=L["Tooltip_Party_Castbars"],           onChange=BBF.UpdateCastbars },
                            { type="checkbox", key="betterTargetHighlight",   label=L["Better_Target_Highlight"],tooltip=L["Tooltip_Better_Target_Highlight"] },
                            { type="checkbox", key="hidePartyAggroHighlight", label=L["Hide_Aggro_Highlight"], tooltip=L["Tooltip_Hide_Party_Aggro_Highlight"],onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePartyDispelOverlay",  label=L["Hide_Dispel_Overlay"],  tooltip=L["Tooltip_Hide_Dispel_Overlay"],      onChange=BBF.HideFrames },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 4: All Frames
            --------------------------------------------------------
            {
                id    = "all",
                label = L["All_Frames"],
                atlas = "groupfinder-icon-friend",
                size  = {20, 20},
                desaturated = true,
                color = {0.1, 0.6, 1},
                overlays = {
                    { atlas="groupfinder-icon-friend", size={16,16}, offset={3,3},  desaturated=true, color={0,1,0} },
                    { atlas="groupfinder-icon-friend", size={16,16}, offset={-5,3}, desaturated=true, color={1,0,0} },
                },
                cards = {
                    {
                        title = L["Frame_Layout"],
                        options = {
                            { type="checkbox", key="classicFrames",            label=L["Classic_Frames"],         tooltip=L["Tooltip_Classic_Frames_Desc"] },
                            { type="checkbox", key="noPortraitModes",          label=L["No_Portrait"],            tooltip=L["Tooltip_No_Portrait_Desc"] },
                            { type="checkbox", key="noPortraitPixelBorder",    label=L["No_Portrait_PixelBorder"],tooltip=L["Tooltip_NP_PixelBorder_Desc"] },
                            { type="checkbox", key="classColorFrameTexture",   label=L["Class_Color_FrameTexture"],tooltip=L["Tooltip_Border_Status_Color_Desc"] },
                            { type="checkbox", key="hideUnitFrameShadow",      label=L["Hide_Shadow"],            tooltip=L["Tooltip_Hide_Shadow_Desc"],              onChange=BBF.HideFrames },
                            { type="checkbox", key="hideRareDragonTexture",    label=L["Hide_Dragon"],            tooltip=L["Tooltip_Hide_Dragon"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Boss-Gold:22:16|a", onChange=BBF.HideFrames },
                            { type="checkbox", key="hideThreatOnFrame",        label=L["Hide_Threat_Meter"],      tooltip=L["Tooltip_Hide_Threat_Desc"],              onChange=BBF.HideFrames },
                        },
                    },
                    {
                        title = L["Display_Text"],
                        options = {
                            { type="checkbox", key="classColorLevelText",     label=L["Level"],                tooltip=L["Tooltip_Level"] },
                            { type="checkbox", key="centerNames",             label=L["Center_Names"],         tooltip=L["Tooltip_Center_Name_Desc"],           onChange=BBF.SetCenteredNamesCaller },
                            { type="checkbox", key="classColorTargetNames",   label=L["Class_Color_Names"],    tooltip=L["Tooltip_Class_Color_Names"] },
                            { type="checkbox", key="removeRealmNames",        label=L["Hide_Realm"],           tooltip=L["Tooltip_Hide_Realm_Desc"] },
                            { type="checkbox", key="formatStatusBarText",     label=L["Format_Numbers"],       tooltip=L["Tooltip_Format_Numbers_Desc"] .. " |A:glueannouncementpopup-arrow:16:16|a", onChange=BBF.HookStatusBarText, id="cbFormatNum", onRightClick=BBF.ToggleFormatNumbersRightClick,
                                
                                children = {
                                    { type="checkbox", key="singleValueStatusBarText", label=L["No_Max_Value"], tooltip="|A:glueannouncementpopup-arrow:16:16|a " .. L["Tooltip_No_Max_Desc"] },
                                }
                            },
                            { type="checkbox", key="hideLevelText",           label=L["Hide_Max_Level_Text"],  tooltip=L["Tooltip_Hide_Max_Level_Text"],         onChange=BBF.HideFrames },
                        },
                    },
                    {
                        title = L["Colors_Icons_FX"],
                        options = {
                            { type="checkbox", key="classColorFrames",             label=L["Class_Color_Health"],                  tooltip=L["Tooltip_Class_Color_Healthbars"],
                                },
                            { type="checkbox", key="customHealthbarColors",        label=L["Custom_Color_Health_Mana"],            tooltip=L["Tooltip_Custom_Colors_Desc"],
                                },
                            { type="checkbox", key="hidePrestigeBadge",            label=L["Hide_Prestige_Honor_Badge_PvP_Icon"],  tooltip=L["Tooltip_Hide_Prestige_PvP_Icon_Desc"], onChange=BBF.HideFrames },
                            { type="checkbox", key="hideCombatGlow",              label=L["Hide_Combat_Glow"],                   tooltip=L["Tooltip_Hide_Combat_Glow"] .. " |A:UI-HUD-UnitFrame-Player-PortraitOn-InCombat:16:42|a", onChange=BBF.HideFrames },
                            { type="checkbox", key="classPortraitsUseSpecIcons",  label=L["Use_Spec_Icons"],                     tooltip=L["Tooltip_Use_Spec_Icons"],              onChange=BBF.SpecPortraits },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 5: Target Frame
            --------------------------------------------------------
            {
                id         = "target",
                label      = L["Target_Frame"],
                atlas      = "groupfinder-icon-friend",
                size       = {22, 22},
                desaturated = true,
                color      = {1, 0, 0},
                cards = {
                    {
                        title = L["Target_Frame"],
                        options = {
                            { type="checkbox", key="targetFrameClickthrough",          label=L["Clickthrough"],            tooltip=L["Tooltip_Target_Clickthrough"],                                                                                onChange=BBF.ClickthroughFrames },
                            { type="checkbox", key="hideTargetName",                  label=L["Hide_Names"],              tooltip=L["Tooltip_Hide_Target_Name"],                                                                                  onChange=BBF.UpdateNameSettings },
                            { type="checkbox", key="hideTargetLeaderIcon",            label=L["Hide_Leader_Icon"],        tooltip=L["Tooltip_Hide_Target_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:16:16|a",              onChange=BBF.HideFrames },
                            { type="checkbox", key="classColorTargetReputationTexture",label=L["Reputation_Class_Color"],  tooltip=L["Tooltip_Target_Reputation_Class_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a" },
                            { type="checkbox", key="hideTargetReputationColor",       label=L["Hide_Reputation_Color"],   tooltip=L["Tooltip_Hide_Target_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a",          onChange=BBF.HideFrames },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 6: Target of Target
            --------------------------------------------------------
            {
                id    = "tot",
                label = L["Target_of_Target"],
                atlas = "groupfinder-icon-friend",
                size  = {22, 22},
                desaturated = true,
                color = {1, 0, 0},
                overlays = {
                    { atlas="TargetCrosshairs", size={22,22}, offset={8,-8} },
                },
                cards = {
                    {
                        title = L["Target_of_Target"],
                        options = {
                            { type="checkbox", key="hideTargetToT",      label=L["Hide_Frame"],      tooltip=L["Tooltip_Hide_ToT_Frame"],   onChange=BBF.HideFrames },
                            { type="checkbox", key="hideTargetToTName",  label=L["Hide_Names"],      tooltip=L["Tooltip_Hide_ToT_Name"] },
                            { type="checkbox", key="hideTargetToTDebuffs",label=L["Hide_ToT_Debuffs"],tooltip=L["Tooltip_Hide_ToT_Debuffs"],onChange=BBF.HideFrames },
                            { type="slider",   key="targetToTScale",     label=L["Size"],            tooltip=L["Tooltip_ToT_Size"],         min=0.6, max=2.5, step=0.01 },
                            { type="slider",   key="targetToTXPos",      label=L["X_Offset"],        tooltip=L["Tooltip_ToT_X_Offset"],     min=-100, max=100, step=1 },
                            { type="slider",   key="targetToTYPos",      label=L["Y_Offset"],        tooltip=L["Tooltip_ToT_Y_Offset"],     min=-100, max=100, step=1 },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 7: Chat Frame
            --------------------------------------------------------
            {
                id    = "chat",
                label = L["Chat_Frame"],
                atlas = "transmog-icon-chat",
                size  = {18, 16},
                cards = {
                    {
                        title = L["Chat_Frame"],
                        options = {
                            { type="checkbox", key="hideChatButtons",     label=L["Hide_Chat_Buttons"],   tooltip=L["Tooltip_Hide_Chat_Buttons"],     onChange=BBF.HideFrames, id="cbChatBtns",
                                children = {
                                    { type="checkbox", key="hideChatBackground", label=L["Hide_Chat_Background"], tooltip=L["Tooltip_Hide_Chat_Background"], onChange=BBF.HideFrames },
                                }
                            },
                            { type="header", label=L["Filters"] },
                            { type="checkbox", key="filterGladiusSpam",    label=L["Gladius_Spam"],       tooltip=L["Tooltip_Filter_Gladius_Spam"],   onChange=BBF.ChatFilterCaller },
                            { type="checkbox", key="filterNpcArenaSpam",   label=L["Arena_Npc_Talk"],     tooltip=L["Tooltip_Filter_Arena_Npc_Talk"], onChange=BBF.ChatFilterCaller },
                            { type="checkbox", key="filterTalentSpam",     label=L["Talent_Spam"],        tooltip=L["Tooltip_Filter_Talent_Spam"],    onChange=BBF.ChatFilterCaller },
                            { type="checkbox", key="filterEmoteSpam",      label=L["Emote_Spam"],         tooltip=L["Tooltip_Filter_Emote_Spam"],     onChange=BBF.ChatFilterCaller },
                            { type="checkbox", key="filterSystemMessages", label=L["System_Messages"],    tooltip=L["Tooltip_Filter_System_Messages"],onChange=BBF.ChatFilterCaller },
                            { type="checkbox", key="filterMiscInfo",       label=L["Misc_Info"],          tooltip=L["Tooltip_Filter_Misc_Info"],      onChange=BBF.ChatFilterCaller },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 8: Extra Features
            --------------------------------------------------------
            {
                id    = "extra",
                label = L["Extra_Features"],
                atlas = "Campaign-QuestLog-LoreBook",
                size  = {20, 20},
                cards = {
                    {
                        title = L["Extra_Features"],
                        options = {
                            { type="checkbox", key="combatIndicator",    label=L["Combat_Indicator"],    tooltip=L["Tooltip_Combat_Indicator_Desc"],    cpuUsage=1, onChange=function() BBF.CombatIndicatorCaller() end },
                            { type="checkbox", key="healerIndicator",    label=L["Healer_Indicator"],   tooltip=L["Tooltip_Healer_Indicator_Desc"],   onChange=function() BBF.HealerIndicatorCaller() end },
                            { type="checkbox", key="absorbIndicator",    label=L["Absorb_Indicator"],   tooltip=L["Tooltip_Absorb_Indicator_Desc"],   cpuUsage=1, onChange=BBF.AbsorbCaller },
                            { type="checkbox", key="racialIndicator",    label=L["Racial_Indicator"],   tooltip=L["Tooltip_Racial_Indicator_Desc"],   cpuUsage=1, onChange=BBF.RacialIndicatorCaller },
                            { type="checkbox", key="overShields",        label=L["Overshields"],        tooltip=L["Tooltip_Overshields_Desc"],        cpuUsage=2 },
                            { type="checkbox", key="queueTimer",         label=L["Queue_Timer"],        tooltip=L["Tooltip_Queue_Timer_Desc"],        id="cbQueue",
                                children = {
                                    { type="checkbox", key="queueTimerAudio",  label=L["Sound_Effect"], tooltip=L["Tooltip_Queue_Timer_SFX_Desc"] },
                                    { type="checkbox", key="queueTimerWarning",label=L["Sound_Alert"],  tooltip=L["Tooltip_Queue_Timer_Warning_Desc"] },
                                }
                            },
                            { type="checkbox", key="enableBigDebuffs",   label=L["Enable_Big_Debuffs"], tooltip=L["Tooltip_Big_Debuffs_Desc"],       onChange=BBF.EnableBigDebuffs },
                            { type="checkbox", key="kickPopupEnabled",   label=L["Kick_Popup"],         tooltip=L["Tooltip_Kick_Popup_Desc"],         onChange=function() BBF.ToggleKickPopup() end },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 9: Arena Names
            --------------------------------------------------------
            {
                id    = "arenaNames",
                label = L["Arena_Names"],
                atlas = "questlog-questtypeicon-pvp",
                size  = {18, 20},
                cards = {
                    {
                        title = L["Arena_Names"],
                        options = {
                            { type="checkbox",        key="targetAndFocusArenaNames", label=L["Target_And_Focus_Arena_Names"], tooltip=L["Tooltip_Target_And_Focus_Arena_Names_Desc"], id="cbTF" },
                            { type="checkbox",        key="partyArenaNames",           label=L["Party"],                       tooltip=L["Tooltip_Party_Arena_Names_Desc"],           id="cbParty" },
                            { type="checkbox",key="showSpecName",              label=L["Show_Spec_Name"],              tooltip=L["Tooltip_Show_Spec_Name_Desc"],              parents={"cbTF","cbParty"} },
                            { type="checkbox",key="shortArenaSpecName",        label=L["Short"],                       tooltip=L["Tooltip_Short_Arena_Spec_Name"],            parents={"cbTF","cbParty"} },
                            { type="checkbox",key="showArenaID",               label=L["Show_Arena_ID"],               tooltip=L["Tooltip_Show_Arena_ID"],                   parents={"cbTF","cbParty"} },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 10: Focus Frame
            --------------------------------------------------------
            {
                id         = "focus",
                label      = L["Focus_Frame"],
                atlas      = "groupfinder-icon-friend",
                size       = {22, 22},
                desaturated = true,
                color      = {0, 1, 0},
                cards = {
                    {
                        title = L["Focus_Frame"],
                        options = {
                            { type="checkbox", key="focusFrameClickthrough",            label=L["Clickthrough"],          tooltip=L["Tooltip_Focus_Clickthrough"],                                                                                         onChange=BBF.ClickthroughFrames },
                            { type="checkbox", key="hideFocusName",                    label=L["Hide_Names"],            tooltip=L["Tooltip_Hide_Focus_Name"],                                                                                            onChange=BBF.UpdateNameSettings },
                            { type="checkbox", key="hideFocusLeaderIcon",              label=L["Hide_Leader_Icon"],      tooltip=L["Tooltip_Hide_Focus_Leader_Icon"] .. " |A:UI-HUD-UnitFrame-Player-Group-LeaderIcon:16:16|a",                           onChange=BBF.HideFrames },
                            { type="checkbox", key="classColorFocusReputationTexture", label=L["Reputation_Class_Color"],tooltip=L["Tooltip_Focus_Reputation_Class_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a" },
                            { type="checkbox", key="hideFocusReputationColor",         label=L["Hide_Reputation_Color"],tooltip=L["Tooltip_Hide_Focus_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a",                    onChange=BBF.HideFrames },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 11: Focus ToT
            --------------------------------------------------------
            {
                id    = "focusToT",
                label = L["Focus_ToT"],
                atlas = "groupfinder-icon-friend",
                size  = {22, 22},
                desaturated = true,
                color = {0, 1, 0},
                overlays = {
                    { atlas="TargetCrosshairs", size={22,22}, offset={8,-8} },
                },
                cards = {
                    {
                        title = L["Focus_ToT"],
                        options = {
                            { type="checkbox", key="hideFocusToT",       label=L["Hide_Frame"],           tooltip=L["Tooltip_Hide_FocusToT_Frame"],  onChange=BBF.HideFrames },
                            { type="checkbox", key="hideFocusToTName",   label=L["Hide_Names"],           tooltip=L["Tooltip_Hide_FocusToT_Name"] },
                            { type="checkbox", key="hideFocusToTDebuffs",label=L["Hide_FocusToT_Debuffs"],tooltip=L["Tooltip_Hide_ToT_Debuffs"],    onChange=BBF.HideFrames },
                            { type="slider",   key="focusToTScale",      label=L["Size"],                 tooltip=L["Tooltip_FocusToT_Size"],       min=0.6, max=2.5, step=0.01 },
                            { type="slider",   key="focusToTXPos",       label=L["X_Offset"],             tooltip=L["Tooltip_FocusToT_X_Offset"],   min=-100, max=100, step=1 },
                            { type="slider",   key="focusToTYPos",       label=L["Y_Offset"],             tooltip=L["Tooltip_FocusToT_Y_Offset"],   min=-100, max=100, step=1 },
                        },
                    },
                },
            },

            --------------------------------------------------------
            -- TAB 12: Pet Frame
            --------------------------------------------------------
            {
                id    = "pet",
                label = L["Pet_Frame"],
                atlas = "newplayerchat-chaticon-newcomer",
                size  = {19, 19},
                cards = {
                    {
                        title = L["Pet_Frame"],
                        options = {
                            { type="checkbox", key="hidePetFrame",        label=L["Hide_Pet_Frame"],         tooltip=L["Tooltip_Hide_Pet_Frame_Desc"],          onChange=BBF.HideFrames },
                            { type="checkbox", key="petCastbar",          label=L["Pet_Castbar"],            tooltip=L["Tooltip_Pet_Castbar"],                  onChange=BBF.UpdatePetCastbar },
                            { type="checkbox", key="hidePetName",         label=L["Hide_Pet_Name"],          tooltip=L["Tooltip_Hide_Pet_Name_Desc"],           onChange=function() BBF.AllNameChanges() end },
                            { type="checkbox", key="hidePetAuraTooltip",  label=L["Hide_Pet_Aura_Tooltip"],  tooltip=L["Tooltip_Hide_Pet_Aura_Tooltip_Desc"],   onChange=BBF.HideFrames },
                            { type="checkbox", key="colorPetAfterOwner",  label=L["Color_Pet_After_Player_Class"],tooltip="",                                  onChange=function() BBF.UpdateFrames() end },
                            { type="checkbox", key="hidePetText",         label=L["Hide_Pet_Statusbar_Text"],tooltip=L["Tooltip_Hide_Pet_Statusbar_Text_Desc"], onChange=BBF.HideFrames },
                            { type="checkbox", key="hidePetHitIndicator", label=L["Hide_Pet_Hit_Indicator"], tooltip=L["Tooltip_Hide_Pet_Hit_Indicator_Desc"],  onChange=BBF.HideFrames },
                        },
                    },
                },
            },
        }, -- end tabs
    } -- end schema

    -- ============================================================
    -- BUILD the panel from schema
    -- ============================================================
    BBF.GUI.BuildPanel(BetterBlizzFrames, schema)

    -- ============================================================
    -- Reload UI button (unique to General panel)
    -- ============================================================
    local reloadUiButton = CreateFrame("Button", nil, BetterBlizzFrames, "UIPanelButtonTemplate")
    reloadUiButton:SetText(L["Reload_UI"])
    reloadUiButton:SetWidth(96)
    reloadUiButton:SetPoint("RIGHT", SettingsPanel.CloseButton, "LEFT", -3, 0)
    reloadUiButton:SetScript("OnClick", function()
        BetterBlizzFramesDB.reopenOptions = true
        ReloadUI()
    end)
end