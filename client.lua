local state = {
    manualHelmetEnabled = false,
    lastPed = nil,
    helmetApplied = false
}

local AUTO_HELMET_CONFIG_FLAG = 35

local function debugPrint(message)
    if Config.Debug then
        print(('[helmet_toggle] %s'):format(message))
    end
end

local function notify(message, notifyType)
    if not Config.Notify then
        return
    end

    if lib and lib.notify then
        lib.notify({
            title = 'Helmet Toggle',
            description = message,
            type = notifyType or 'inform'
        })
        return
    end

    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end

local function getPlayerPedSafe()
    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist(ped) then
        return nil
    end

    return ped
end

local function getHelmetTextureIndex()
    local textureIndex = Config.HelmetTextureIndex

    if type(textureIndex) ~= 'number' then
        return -1
    end

    return textureIndex
end

local function isVehicleEntryInProgress(ped)
    if IsPedGettingIntoAVehicle(ped) then
        return true
    end

    return not IsPedInAnyVehicle(ped, false) and GetVehiclePedIsTryingToEnter(ped) ~= 0
end

local function isHelmetOn(ped)
    return IsPedWearingHelmet(ped)
end

local function lockAutoHelmetOff(ped)
    SetPedConfigFlag(ped, AUTO_HELMET_CONFIG_FLAG, false)
end

local function disableAutoHelmet(ped)
    lockAutoHelmetOff(ped)

    if state.helmetApplied or isHelmetOn(ped) then
        SetPedHelmet(ped, false)
        RemovePedHelmet(ped, false)
    end

    state.helmetApplied = false
end

local function enableManualHelmet(ped)
    lockAutoHelmetOff(ped)

    if not state.helmetApplied or not isHelmetOn(ped) then
        SetPedHelmetFlag(ped, Config.HelmetFlag)
        SetPedHelmet(ped, true)
        GivePedHelmet(ped, true, Config.HelmetFlag, getHelmetTextureIndex())
    end

    state.helmetApplied = true
end

local function applyCurrentState(forceLog)
    local ped = getPlayerPedSafe()
    if not ped then
        return
    end

   
    if isVehicleEntryInProgress(ped) then
        if forceLog then
            debugPrint('Skipped helmet apply during active vehicle entry.')
        end
        return
    end

    if state.manualHelmetEnabled then
        enableManualHelmet(ped)
        if forceLog then
            debugPrint('Helmet on.')
        end
    else
        disableAutoHelmet(ped)
        if forceLog then
            debugPrint('Helmet off. Auto helmet blocked.')
        end
    end
end

local function toggleHelmet()
    state.manualHelmetEnabled = not state.manualHelmetEnabled
    applyCurrentState(true)

    if state.manualHelmetEnabled then
        notify('Helmet on.', 'success')
    else
        notify('Helmet off.', 'error')
    end
end

RegisterCommand(Config.Command, function()
    toggleHelmet()
end, false)

debugPrint(('Registered command /%s'):format(Config.Command))

if Config.EnableKeybind and Config.KeybindCommand and Config.KeybindCommand ~= '' then
    RegisterCommand(Config.KeybindCommand, function()
        toggleHelmet()
    end, false)

    RegisterKeyMapping(Config.KeybindCommand, 'Toggle helmet on/off', 'keyboard', Config.DefaultKeybind)
    debugPrint(('Registered keybind command %s on %s'):format(Config.KeybindCommand, Config.DefaultKeybind))
end

AddEventHandler('playerSpawned', function()
    CreateThread(function()
        Wait(Config.ReapplyDelayMs)
        applyCurrentState(true)
    end)
end)

CreateThread(function()
    Wait(Config.ReapplyDelayMs)
    applyCurrentState(true)

    while true do
        local ped = getPlayerPedSafe()

        if ped then
            lockAutoHelmetOff(ped)

            if state.lastPed ~= ped then
                state.lastPed = ped
                state.helmetApplied = false
                debugPrint('Detected ped change, reapplying helmet state.')
                Wait(Config.ReapplyDelayMs)
                applyCurrentState(true)
            elseif not isVehicleEntryInProgress(ped) then
                if state.manualHelmetEnabled then
                    if not state.helmetApplied or not isHelmetOn(ped) then
                        enableManualHelmet(ped)
                    end
                elseif state.helmetApplied or isHelmetOn(ped) then
                    disableAutoHelmet(ped)
                end
            end
        end

        Wait(Config.AutoBlockIntervalMs)
    end
end)
