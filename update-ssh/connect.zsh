compdef connect=ssh
function connect {
  output=`python3 $HOME/python/update-ssh.py`
  case "$?" in
  0)IFS=' ' read ROUTER DEST <<< $output
  	function connect {
      ping -s 16 $ROUTER &
      local PID=$!
      until ping -s 16 -c 10 -W 1200 $DEST | awk 'BEGIN{status = 1} END{exit status} / 0.0% packet loss/{status = 0} /$/{print}'; do done
      kill -SIGINT $PID
      ssh REMOTE_HOST
  	}
    ;;
  1)
    function connect {
      echo '\033[93mWarning\033[0m: NJU-WLAN is unconnected.'
    }
    ;;
  2)
    function connect {
      echo '\033[93mWarning\033[0m: Login failed.'
    }
    ;;
  3)
    function connect {
      echo '\033[93mWarning\033[0m: Cannot fetch information.'
    }
    ;;
  4)
    function connect {
      echo '\033[93mWarning\033[0m: REMOTE_HOST is offline.'
    }
    ;;
  esac
  unset output
  connect $@
}
