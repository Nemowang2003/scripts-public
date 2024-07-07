function configure {
  zparseopts -D -E -- -use-pip-mirror=mirror
  local login=$1 ip=$2 host=$3 user=$4 port=${5-22}
  [[ $port == 22 || $port == 2222 ]] && new_port=`jot -r 1 1025 65535` # or `shuf -i 1 1025-65535 -n 1`
  scp -o ControlMaster=auto -o ControlPath=$HOME/.ssh/%C -o ControlPersist=30s -P $port \
    $HOME/{scripts/config-remote-server/*.sh,.ssh/*.pub} $login@$host:/tmp
  cat >> $HOME/.ssh/config << END

Host $host
  HostName $ip
  Port ${new_port-port}
  User $user
END
  ssh -o ControlMaster=auto -o ControlPath=$HOME/.ssh/%C -p $port $login@$host "cd /tmp && bash run-as-root.sh $user ${new_port-port} $mirror"
  [[ -n $new_port ]] && echo "\033[92mNote\033[0m: Don't forget to open port $new_port on the console."
}
compdef _configure configure
function _configure {
  _arguments '--use-pip-mirror:use nju pip mirror:'
}
