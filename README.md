# Zig Game (Name WIP)

> [!WARNING]
> Note that there isn't actually a game yet and I've just created a shell for future use\
> You are free to download and play this, though if there is no itch page linked, do not expect anything fun

## Install

> [!IMPORTANT]
> You will need [Zig 0.15](https://ziglang.org/download/#:~:text=52MiB-,0.15.1,-2025%2D08%2D19 "Zig 0.15.1 download") and a command line interface

Clone this repository using `git clone` or download the ZIP file and cd into it using your terminal
```sh
git clone https://github.com/ChipCruncher72/Zig-Game
cd Zig-Game
```
Then build it with `zig build`
```sh
zig build
# Alternatively
zig build run
```

### Extra options
- `-Ddebug` - Enables debugging, and lowest optimization mode (default false)
- `-Ddynamic_link` - If SDL3 should be dynamically linked or not (default false) (REQUIRES DOWNLOADING SDL3)
- `-Daggressive` - Performs aggressive optimizations, and highest optimization mode (default false)
