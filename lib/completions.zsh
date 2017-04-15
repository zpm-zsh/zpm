function _ZPM-upgrade-compl(){
  _ZPM_Hooks=( "$_ZPM_GitHub_Plugins" )
  for plugg ($_ZPM_Core_Plugins); do
    if type _$plugg-upgrade | grep "shell function" >/dev/null; then
      _ZPM_Hooks+=($plugg)
    fi
  done
  _arguments "*: :($(echo "zpm"; echo $_ZPM_Plugins_3rdparty))"
}

compdef _ZPM-upgrade-compl ZPM-upgrade
