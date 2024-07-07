function cleanup {
  echo files: `ls $HOME/Library/Containers/com.netease.163music/Data/Caches/online_play_cache | wc -l`
  rm $HOME/Library/Containers/com.netease.163music/Data/Caches/online_play_cache/*
}
function play {
  zparseopts -D -E -- -force=force
  if [[ -z $force ]] && ! blueutil --connected | grep -q \
    -e 'DEVICE' \
    ; then
    echo '\033[93mWarning\033[0m: Bluetooth device is not connected. Abort.'
    return
  fi
  iina --no-stdin --music-mode $HOME/Music/${^${*:-All}}.localized -- --loop-playlist --shuffle=yes --resume-playback=no
}
compdef _play play
function _play {
  local artists=(`ls $HOME/Music | awk -F . '!/All.localized/&&/.localized/{print $1}'`)
  _arguments -C \
    '--force[Disable bluetooth check]' \
    '*:[artist ...]:->artist'
  case "$state" in
  artist)
    _values -w '[artist ...]' $artists
    ;;
  esac
}
