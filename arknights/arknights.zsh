function arknights {
  local user output
  typeset -A names=(
    [name1]=user1
    [name2]=user2
    [name3]=user3
  )
  user=$names[${1-dafault}]
  if [[ -z $user ]]; then
    echo "\033[91mError\033[0m: Unknown name \`$1\`."
    return
  fi
  output=`curl -s --cacert $HOME/MAA-Manager/example.crt "https://MAA-Manager.com/query/$user"`
  if [[ $output =~ online ]]; then
    echo "\033[93mWarning\033[0m: $output"
    return
  fi
  echo "\033[92mNote\033[0m: $output"
  echo 'Ready to launch? [y/n]'
  if read -qs; then
    echo 'Arknights, launch!'
    open -a '明日方舟'
  else
    echo "Sure, it's up to you."
  fi
}
compdef _arknights arknights
function _arknights {
  # TODO maybe can use ${(@k)names} to avoid write twice,
  # but I can't solve variable visibility.
  _values '<name>' name1 name2 name3
}
