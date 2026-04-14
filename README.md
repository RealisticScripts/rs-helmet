# RS Helmet

RS Helmet is a FiveM resource that lets players manually choose whether they wear a helmet while preventing GTA's automatic helmet behavior on motorcycles. You can put on or take off a helmet in any class of vehicle.

## Features

- Blocks automatic helmet behavior
- Manual helmet toggle command
- Works on or off a motorcycle
- Uses `ox_lib` notifications
- Configurable keybind
- Includes unified version check

## Requirements

- FiveM server using `lua54 'yes'`
- [`ox_lib`](https://github.com/overextended/ox_lib)

## Installation

1. Place the resource folder in your server's resources directory.
2. Add the resource to your server config.
3. Start the resource.

Example:

```cfg
ensure rs-helmet
```

## Usage

Default command:

```text
/helmet
```

Default keybind:

```text
F2
```

## Configuration

Edit `config.lua` to change the command, keybind, debug setting, and timing values.

Current defaults:

- Debug: `false`
- Command: `helmet`
- Keybind enabled: `true`
- Keybind command: `helmet`
- Default keybind: `F2`
- Notifications: `true`
- Auto block interval: `200`
- Reapply delay: `500`
- Helmet flag: `4096`
- Helmet texture index: `-1`

## Included Files

- `fxmanifest.lua`
- `client.lua`
- `server.lua`
- `config.lua`
- `LICENSE`
- `README.md`

## License

Released under the MIT License. See `LICENSE` for details.
