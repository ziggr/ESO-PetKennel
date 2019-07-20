local LAM2      = LibAddonMenu2 -- do I still need to use LibStub("LibAddonMenu-2.0")
-- local LAM2      = LibStub("LibAddonMenu-2.0")

function PetKennel:CreateSettingsUI()
    self.saved_vars.enable = self.saved_vars.enable or {}

    local lam_addon_id = "PetKennel_LAM"
    local panelData = {
        type                = "panel",
        name                = self.name,
        displayName         = self.name,
        author              = "ziggr",
        version             = self.version,
        --slashCommand        = "/gg",
        registerForRefresh  = false,
        registerForDefaults = false,
    }
    local cntrlOptionsPanel = LAM2:RegisterAddonPanel( lam_addon_id
                                                     , panelData
                                                     )
    local optionsData = {
        { type      = "checkbox"
        , name      = "crafting station"
        , tooltip   = "Hide pet at crafting station?"
        , getFunc   = function()
                        return self.saved_vars.enable.crafting_station ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.crafting_station = e
                      end
        },

        { type      = "checkbox"
        , name      = "crafting writ board"
        , tooltip   = "Hide pet at daily crafting writ board?"
        , getFunc   = function()
                        return self.saved_vars.enable.crafting_board ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.crafting_board = e
                      end
        },

        { type      = "checkbox"
        , name      = "banker"
        , tooltip   = "Hide pet at banker?"
        , getFunc   = function()
                        return self.saved_vars.enable.banker ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.banker = e
                      end
        },

        { type      = "checkbox"
        , name      = "merchant"
        , tooltip   = "Hide pet at merchant?"
        , getFunc   = function()
                        return self.saved_vars.enable.merchant ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.merchant = e
                      end
        },

    }

    LAM2:RegisterOptionControls(lam_addon_id, optionsData)
end

