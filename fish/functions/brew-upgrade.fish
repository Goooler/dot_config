function brew-upgrade
  HOMEBREW_NO_INSTALL_CLEANUP=true brew upgrade --greedy
  brew cleanup
end