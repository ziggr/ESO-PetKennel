-- PetKennel: Put your bear away in town!
--

local PK        = PetKennel

PetKennel.name              = "PetKennel"
PetKennel.version           = "5.1.1"
PetKennel.saved_var_version = 1

PetKennel.default = {
}

local Log = PetKennel.Log

-- Pet -----------------------------------------------------------------------

-- PET_ABILITY_ID array copied from Dolgubon's Lazy Writ Creator DismissPets()
local PET_ABILITY_ID = {
[23304]=true, [30631]=true, [30636]=true, [30641]=true, [23319]=true, [30647]=true,
[30652]=true, [30657]=true, [23316]=true, [30664]=true, [30669]=true, [30674]=true,
[24613]=true, [30581]=true, [30584]=true, [30587]=true, [24636]=true, [30592]=true,
[30595]=true, [30598]=true, [24639]=true, [30618]=true, [30622]=true, [30626]=true,
[85982]=true, [85983]=true, [85984]=true, [85985]=true, [85986]=true, [85987]=true,
[85988]=true, [85989]=true, [85990]=true, [85991]=true, [85992]=true, [85993]=true,
}
-- 85986 = Eternal Guardian warden bear

function PetKennel:HidePet()
    Log.Debug("HidePet")

    for i = 1, GetNumBuffs("player") do
        local o = { GetUnitBuffInfo("player", i) }
        local buff_index = o[ 4]
        local buff_name  = o[ 1]
        local ability_id = o[11]
        if PET_ABILITY_ID[ability_id] then
            -- Log:StartNewEvent("HidePet")
            -- Log:Add("buff", o)
            -- Log:EndEvent()
            Log.Info("Hiding pet:%s", o[1])
            CancelBuff(buff_index)
        end
    end
end


-- Event Listeners -----------------------------------------------------------

function PetKennel:RegisterListeners()
    Log.Debug("RegisterCraftListener")

    EVENT_MANAGER:RegisterForEvent(self.name
        , EVENT_CRAFTING_STATION_INTERACT
        , PetKennel.OnCraftingStationInteract
        )

end

function PetKennel.OnCraftingStationInteract(event, station_id, same_station)
    local self = PetKennel
    Log.Debug( "OnCraftingStationInteract, enable:%s"
             , tostring(self.saved_vars.enable.crafting_station)
             )

    if self.saved_vars.enable.crafting_station then
        self:HidePet()
    end
end


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

    self:RegisterListeners()
end

-- Postamble -----------------------------------------------------------------

EVENT_MANAGER:RegisterForEvent( PetKennel.name
                              , EVENT_ADD_ON_LOADED
                              , PetKennel.OnAddOnLoaded
                              )

