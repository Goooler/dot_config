function brew-update
  brew update -q
  echo && brew outdated --greedy
end

function brew-upgrade
  HOMEBREW_NO_INSTALL_CLEANUP=true brew upgrade --greedy
  brew cleanup
end

function brew-cleanup
  brew cleanup --prune=all
end
