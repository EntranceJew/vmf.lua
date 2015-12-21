# vmf.lua
[VMF files](https://developer.valvesoftware.com/wiki/Valve_Map_Format) are this very fun mix of almost-json-almost-lua that makes readers for them in short supply.

This library was written to make manipulating .vmf files easier, especially since maps decompiled with BSPSource are a bit messy and may need scrubbing.

## Requirements
Uses LOVE for filesystem code, I will fix this eventually.

## Usage
See [main.lua](/main.lua)

The default program (material counter) output is:
```lua
table: 0x33b6e910 {
  [DEV/GRAYGRID] => 168
  [DEV/DEV_MEASUREWALL01A] => 467
  [OVERLAYS/NO_ENTRY] => 8
  [TOOLS/TOOLSNODRAW] => 76
  [TOOLS/TOOLSSKYBOX] => 78
  [DEV/DEV_MEASUREWALL01D] => 159
  [TOOLS/TOOLSTRIGGER] => 336
}
```