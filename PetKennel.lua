-- PetKennel: Put away your bear while in town!
--

local PetKennel = _G['PetKennel']

PetKennel.name              = "PetKennel"
PetKennel.version           = "5.1.1"
PetKennel.saved_var_version = 1

PetKennel.default = {
}

local Log = PetKennel.Log

-- Pet -----------------------------------------------------------------------

-- PET_ABILITY_ID array copied from Dolgubon's Lazy Writ Creator DismissPets()
PetKennel.PET_ABILITY_ID = {
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
        if PetKennel.PET_ABILITY_ID[ability_id] then
            -- Log:StartNewEvent("HidePet")
            -- Log:Add("buff", o)
            -- Log:EndEvent()
            Log.Info("Hiding pet: %s", o[1])
            CancelBuff(buff_index)
        end
    end
end

function PetKennel:DumpPets()
    local list = {}
    for k,_ in pairs(self.PET_ABILITY_ID) do
        table.insert(list, k)
    end
    table.sort(list)
    Log:StartNewEvent("Dumping all pet abilities...")
    for _,ability_id in ipairs(list) do
        local n = GetAbilityName(ability_id)
        Log:Add(string.format("%5d %s", ability_id, n))
    end
    Log:EndEvent()

    Log:StartNewEvent("Dumping all buffs")
    for i = 1, GetNumBuffs("player") do
        local o = { GetUnitBuffInfo("player", i) }
        Log:Add(string.format( "ability_id:%d can_click_off:%s %s"
                             , o[11]
                             , tostring(o[12])
                             , o[ 1]
                             ))

    end
    Log:EndEvent()
end

-- Event Listeners -----------------------------------------------------------

function PetKennel:RegisterListeners()
    Log.Debug("RegisterCraftListener")

    EVENT_MANAGER:RegisterForEvent(self.name
        , EVENT_CRAFTING_STATION_INTERACT
        , PetKennel.OnCraftingStationInteract
        )

    EVENT_MANAGER:RegisterForEvent(self.name
        , EVENT_OPEN_BANK
        , PetKennel.OnOpenBank
        )

    EVENT_MANAGER:RegisterForEvent(self.name
        , EVENT_OPEN_STORE
        , PetKennel.OnOpenStore
        )

    EVENT_MANAGER:RegisterForEvent(self.name
        , EVENT_CHATTER_BEGIN
        , PetKennel.OnChatterBegin
        )

end

function PetKennel.OnCraftingStationInteract(event, station_id, same_station)
    local self = PetKennel
    Log.Debug( "OnCraftingStationInteract, enable:%s"
             , tostring(self.saved_vars.enable.crafting_station)
             )
    if self.saved_vars.enable.crafting_station ~= false then
        self:HidePet()
    end
end

function PetKennel.OnOpenBank(event, station_id, bag_id)
    local self = PetKennel
    local is_assistant = IsInteractingWithMyAssistant()
    Log.Debug( "OnOpenBank, enable:%s assistant:%s"
             , tostring(self.saved_vars.enable.banker)
             , tostring(is_assistant)
             )
    if (not is_assistant)
        and self.saved_vars.enable.banker ~= false then
        self:HidePet()
    end
end

function PetKennel.OnOpenStore(event)
    local self = PetKennel
    local is_assistant = IsInteractingWithMyAssistant()
    Log.Debug( "OnOpenStore, enable:%s assistant:%s"
             , tostring(self.saved_vars.enable.merchant)
             , tostring(is_assistant)
             )
    if (not is_assistant)
        and self.saved_vars.enable.merchant ~= false then
        self:HidePet()
    end
end

function PetKennel.OnChatterBegin(option_ct)
    local self = PetKennel
    local dialog_title = self:GetDialogTitle()

    local is_writ_board = LibCraftText.DailyDialogTitleIsWritBoard(dialog_title)
    if is_writ_board then
        Log.Debug( "OnChatterBegin, enable:%s is_writ_board:%s"
                 , tostring(self.saved_vars.enable.crafting_board)
                 , tostring(is_writ_board)
                 )
        if self.saved_vars.enable.crafting_board ~= false then
            self:HidePet()
        end
        return
    end

    local is_turn_in = LibCraftText.DailyDialogTurnInTitleToCraftingType(dialog_title)
    if is_turn_in then
        Log.Debug( "OnChatterBegin, enable:%s is_turn_in:%s"
                 , tostring(self.saved_vars.enable.turn_in)
                 , tostring(is_turn_in)
                 )
        if self.saved_vars.enable.turn_in ~= false then
            self:HidePet()
        end
        return
    end

    local is_rolis = LibCraftText.MASTER.DIALOG.TITLE_ROLIS == dialog_title
    if is_rolis then
        Log.Debug( "OnChatterBegin, enable:%s is_rolis:%s"
                 , tostring(self.saved_vars.enable.rolis)
                 , tostring(is_rolis)
                 )
        if self.saved_vars.enable.rolis ~= false then
            self:HidePet()
        end
        return
    end

end

function PetKennel:GetDialogTitle()
    return ZO_InteractWindowTargetAreaTitle:GetText()
end

-- Key Binding ---------------------------------------------------------------

function PetKennel.KeyBindingHidePet()
    PetKennel:HidePet()
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

                        -- Key binding strings must be defined earlier than
                        -- OnAddOnLoaded() time or the key binding will not
                        -- appear in Controls/Keybindings.
                        --
                        -- Category string is locked at file-load time and
                        -- cannot be changed. That's okay, we don't translate
                        -- our add-on name anyway.
                        --
                        -- Individual key binds can and should be replaced with
                        -- i18n strings later, once we've loaded savedVariables
                        -- and know which language the user prefers.

ZO_CreateStringId("SI_KEYBINDINGS_CATEGORY_PET_KENNEL",    "PetKennel")
ZO_CreateStringId("SI_BINDING_NAME_PetKennel_HidePet",     "Hide Pet")

