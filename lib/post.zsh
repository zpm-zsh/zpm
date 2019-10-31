#!/usr/bin/env zsh

post_fn(){
  echo 'PATH="'"${ZPM_PATH}"'${PATH}"' >> ~/.zsh.cache
  echo 'fpath=( '$ZPM_fpath' $fpath )' >> ~/.zsh.cache
  echo '_ZPM_Plugins=( '$_ZPM_Plugins' )' >> ~/.zsh.cache
  echo 'zpm () {}' >> ~/.zsh.cache
}