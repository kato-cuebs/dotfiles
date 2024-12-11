#!/usr/bin/env bash 
set -ue

helpmsg() {
  command echo "Usage: $0 [--help | -h]" 0>&2
  command echo ""
}

link_to_homedir() {
  command echo "backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ]; then
    command echo "$HOME/.dotbackup not found. Auto Make it"
    command mkdir "$HOME/.dotbackup"
  fi 

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})
  if [[ "$HOME" != "$dotdir" ]]; then
    for f in $dotdir/*; do 
      fname="$(basename $f)"
      echo $fname
      if [[ -L "$HOME/.$fname" ]]; then 
        command rm -f "$HOME/.`basename $f`"
      fi
      if [[ -e "$HOME/.$fname" ]]; then 
        command mv "$HOME/.$fname" "$HOME/.dotbackup"
      fi
      command ln -snf $f $HOME/.$fname
    done
  else
    command echo "same install src dest"
  fi
}

while [ $# -gt 0 ]; do
  case ${1} in 
    --debug|-d)
      set -uex
      ;;
    --help|-h)
      helpmsg
      exit 1
      ;;
    *)
      ;;
  esac
  shift
done

link_to_homedir
#git config --global include.path "~/.gitconfig_shared"
command echo -e "\033[1;36mInstall completed!!! \033[m"
