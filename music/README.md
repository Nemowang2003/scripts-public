# Music

## maintain.py

### Usage:

    python3 maintain.py

First, collect all music caches (placed at `Library/Containers/com.netease.163music/Data/Caches/online_play_cache/*.uc!`).  
Decode them (xor every byte with `163`), and place them at `$HOME/Music`.  
Then, enter an interactive console. For every unarranged mp3 file, display its duration (and metadata, if posible).  
The file would be renamed and well-arranged according to user's input (EOF to skip).  
Finnaly, make sure every file under 'artist' directory is a symlink to the one under 'All' directory.  
If not, move the real file to 'All', and create a symlink to it at the original place.

### TODO

- Features

  Reject if the name of artist if it contains '.'(dot) to correspond with auto completion in `play.zsh`.
  After arrangment of a new music file, write the information to the metadata of the mp3 file.

- Project Management

  Manage this project by poetry, and maybe pyenv.

## play.zsh

### Usage

    play [unlocalized-artist-name] [--force]

Specifying `unlocalized-artist-name` would play everything under the target directory.  
When argument is not present, 'All' is played.  
If Bose is not connected via Bluetooth, a warning emits and the function returns immediately. Use `--force` to diable this behaviour.
*Note*: `--resume-playback=no` is passed into iina, therefore the music would start from the beginning perfectly every time.

### Usage

    cleanup

Cleaning up all cache files of Netease Music.
