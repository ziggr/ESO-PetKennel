local LAM2      = LibAddonMenu2

function PetKennel:CreateSettingsUI()
    self.saved_vars.enable = self.saved_vars.enable or {}

    local lam_addon_id = "PetKennel_LAM"
    local panelData = {
        type                = "panel",
        name                = self.name,
        displayName         = self.name,
        author              = "ziggr",
        version             = self.version,
        registerForRefresh  = false,
        registerForDefaults = false,
    }
    local cntrlOptionsPanel = LAM2:RegisterAddonPanel( lam_addon_id
                                                     , panelData
                                                     )
    local optionsData = {
        { type      = "header"
        , name      = "Dismiss combat + vanity pets:"
        },


        { type      = "checkbox"
        , name      = "crafting writ boards"
        , tooltip   = "Hide pet at daily crafting writ board?"
        , getFunc   = function()
                        return self.saved_vars.enable.crafting_board ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.crafting_board = e
                      end
        },

        { type      = "checkbox"
        , name      = "crafting stations"
        , tooltip   = "Hide pet at crafting station?"
        , getFunc   = function()
                        return self.saved_vars.enable.crafting_station ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.crafting_station = e
                      end
        },

        { type      = "checkbox"
        , name      = "writ turn-in crates"
        , tooltip   = "Hide pet at writ turn-in crates?"
        , getFunc   = function()
                        return self.saved_vars.enable.turn_in ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.turn_in = e
                      end
        },

        { type      = "checkbox"
        , name      = "banker"
        , tooltip   = "Hide pet at (non-assistant) banker?"
        , getFunc   = function()
                        return self.saved_vars.enable.banker ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.banker = e
                      end
        },

        { type      = "checkbox"
        , name      = "merchant"
        , tooltip   = "Hide pet at (non-assistant) merchant?"
        , getFunc   = function()
                        return self.saved_vars.enable.merchant ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.merchant = e
                      end
        },

        { type      = "checkbox"
        , name      = "Rolis"
        , tooltip   = "Hide pet at Rolis Hlaalu?"
        , getFunc   = function()
                        return self.saved_vars.enable.rolis ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.rolis = e
                      end
        },

        { type      = "header"
        , name      = "Dismiss vanity pets:"
        },


        { type      = "checkbox"
        , name      = "dungeons & delves"
        , tooltip   = "Hide vanity pet when entering dungeons or delves?"
        , getFunc   = function()
                        return self.saved_vars.enable.dungeon_and_delve ~= false
                      end
        , setFunc   = function(e)
                        self.saved_vars.enable.dungeon_and_delve = e
                      end
        },

    }

    LAM2:RegisterOptionControls(lam_addon_id, optionsData)
end

