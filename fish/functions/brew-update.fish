function brew-update
  brew update -q
  echo && brew outdated --greedy
end