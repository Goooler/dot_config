function brew-update
  brew update -q
  echo && brew outdated --greedy
end

function brew-upgrade
  HOMEBREW_NO_INSTALL_CLEANUP=true brew upgrade --greedy
  brew cleanup
end

if test (uname -m) = "x86_64"
  eval "$(/usr/local/bin/brew shellenv)"
  export PATH="/usr/local/opt/curl/bin:$PATH" # Use homebrew curl before system
  export PATH="/usr/local/opt/rsync/bin:$PATH" # Use homebrew rsync before system
else if test (uname -m) = "arm64"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/opt/curl/bin:$PATH" # Use homebrew curl before system
  export PATH="/opt/homebrew/opt/rsync/bin:$PATH" # Use homebrew rsync before system
end