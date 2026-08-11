-- ============================================================
-- BetterBlizzFrames: midnight/gui_override.lua
-- Decoupled Bridge & Override Layer for Modern GUI Builder Engine.
-- Preserves original gui.lua 100% untouched while rendering custom GUI schemas.
-- ============================================================
if not BBF.isMidnight then return end

local L = BBF.L
local originalLoadGUI = BBF.LoadGUI

local function RenderSchemaPanel(categoryKey, frameName, schemaKey, categoryTitle)
    local frame = _G[frameName] or CreateFrame("Frame", frameName)
    frame.name = categoryTitle or frame.name or categoryKey
    frame.parent = BetterBlizzFrames.name

    if BBF.category and not frame.bbfSubCategoryRegistered then
        local subCat = Settings.RegisterCanvasLayoutSubcategory(BBF.category, frame, frame.name, frame.name)
        subCat.ID = frame.name
        frame.bbfSubCategoryRegistered = subCat
        if categoryKey == "auras" then BBF.aurasSubCategory = frame.name end
    end

    -- Clear legacy default children created by original gui.lua
    for _, child in ipairs({ frame:GetChildren() }) do
        if child and child ~= frame then
            child:Hide()
        end
    end
    for _, region in ipairs({ frame:GetRegions() }) do
        if region:IsObjectType("Texture") or region:IsObjectType("FontString") then
            region:Hide()
        end
    end

    if BBF.CreateTitle then BBF.CreateTitle(frame) end
    if BBF.GUI and BBF.GUI.BuildPanel and BBF.GUI.Schemas and BBF.GUI.Schemas[schemaKey] then
        BBF.GUI.BuildPanel(frame, BBF.GUI.Schemas[schemaKey])
    end
    return frame
end

function BBF.LoadGUI()
    if BetterBlizzFramesDB.hasNotOpenedSettings then
        if BBF.CreateIntroMessageWindow then
            BBF.CreateIntroMessageWindow()
            BetterBlizzFramesDB.hasNotOpenedSettings = nil
            return
        end
    end

    if CombatOnGUICreation and CombatOnGUICreation() then return end

    if BetterBlizzFrames.guiLoaded then
        if BBF.category then Settings.OpenToCategory(BBF.category:GetID()) end
        return
    end

    -- Register LSM providers on GUI engine if present
    if BBF.GUI and BBF.GUI.RegisterProvider then
        BBF.GUI.RegisterProvider("font", function()
            local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
            if not LSM then return {} end
            local fonts = LSM:HashTable(LSM.MediaType.FONT)
            local sorted = {}
            for name in pairs(fonts) do table.insert(sorted, name) end
            table.sort(sorted)
            local choices = {}
            for _, name in ipairs(sorted) do table.insert(choices, { value = name, label = name }) end
            return choices
        end)
        BBF.GUI.RegisterProvider("texture", function()
            local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
            if not LSM then return {} end
            local textures = LSM:HashTable(LSM.MediaType.STATUSBAR)
            local sorted = {}
            for name in pairs(textures) do table.insert(sorted, name) end
            table.sort(sorted)
            local choices = {}
            for _, name in ipairs(sorted) do table.insert(choices, { value = name, label = name }) end
            return choices
        end)
        BBF.GUI.RegisterProvider("statusbar", BBF.GUI.Providers["texture"])
    end

    -- Override the category generators
    _G.guiGeneralTab      = function() RenderSchemaPanel("general",      "BetterBlizzFramesGeneralTab", "general",      L["Module_Name_General"]      or "General") end
    _G.guiFrameAuras       = function() RenderSchemaPanel("auras",        "guiFrameAurasFrame",          "auras",        L["Module_Name_Auras"]        or "Auras") end
    _G.guiCastbars         = function() RenderSchemaPanel("castbars",      "BetterBlizzFramesCastbars",   "castbars",     L["Module_Name_Castbars"]     or "Castbars") end
    _G.guiFrameLook        = function() RenderSchemaPanel("fonts",         "guiFrameLookFrame",          "fonts",        L["Module_Name_Fonts"]        or "Fonts") end
    _G.guiMisc             = function() RenderSchemaPanel("misc",          "guiMiscFrame",               "misc",         L["Module_Name_Misc"]         or "Misc") end
    _G.guiCustomCode       = function() RenderSchemaPanel("customcode",    "guiCustomCodeFrame",         "customcode",   L["Module_Name_CustomCode"]   or "Custom Code") end
    _G.guiSupport          = function() RenderSchemaPanel("support",       "guiSupportFrame",            "support",      L["Module_Name_Support"]      or "Support") end
    _G.guiProfiles         = function() RenderSchemaPanel("profiles",      "guiProfilesFrame",           "profiles",     L["Module_Name_Profiles"]     or "Profiles") end
    _G.guiImportAndExport  = function() RenderSchemaPanel("importexport",  "guiImportExportFrame",       "importexport", L["Module_Name_ImportExport"] or "Import / Export") end

    -- Run original LoadGUI to set up categories & triggers
    if originalLoadGUI then originalLoadGUI() end

    -- Build panels using our declarative schemas
    _G.guiGeneralTab()
    _G.guiFrameAuras()
    _G.guiCastbars()
    _G.guiFrameLook()
    _G.guiMisc()
    _G.guiCustomCode()
    _G.guiSupport()
    _G.guiProfiles()
    _G.guiImportAndExport()

    BetterBlizzFrames.guiLoaded = true
end
