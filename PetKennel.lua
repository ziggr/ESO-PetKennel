-- PetKennel: Put your bear away in town!
--

local PK        = PetKennel

PetKennel.name              = "PetKennel"
PetKennel.version           = "5.1.1"
PetKennel.saved_var_version = 1

PetKennel.default = {
}

local Log = PetKennel.Log

-- Init ----------------------------------------------------------------------

function PetKennel.OnAddOnLoaded(event, addonName)
    if addonName == PetKennel.name then
        if not PetKennel.version then return end
        PetKennel:Initialize()
    end
end

function PetKennel:Initialize()
    self.saved_vars = ZO_SavedVars:New(
                              "PetKennelVars"
                            , self.saved_var_version
                            , nil
                            , self.default
                            )
    self:CreateSettingsUI()
end

-- Postamble -----------------------------------------------------------------

EVENT_MANAGER:RegisterForEvent( PetKennel.name
                              , EVENT_ADD_ON_LOADED
                              , PetKennel.OnAddOnLoaded
                              )

