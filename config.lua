Config = {}

-- Prints debug messages in the F8/client console.
Config.Debug = false

-- Chat command to toggle the helmet manually.
Config.Command = 'helmet'

-- Optional keybind for the toggle command.
Config.EnableKeybind = true
Config.KeybindCommand = 'helmet'
Config.DefaultKeybind = 'F2'

-- Shows an ox_lib notification when the helmet is toggled.
Config.Notify = true

-- How often the script checks and removes auto-applied helmets.
Config.AutoBlockIntervalMs = 200

-- Small delay used after player spawn/ped changes before re-applying the saved state.
Config.ReapplyDelayMs = 500

-- GivePedHelmet helmetFlag / textureIndex values.
Config.HelmetFlag = 4096
Config.HelmetTextureIndex = -1
