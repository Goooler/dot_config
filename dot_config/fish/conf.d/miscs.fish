alias sha256="shasum -a 256"
alias yp="yt-dlp --concurrent-fragments 64 --cookies-from-browser chrome"

function thefuck_alias
  eval (thefuck --alias)
end
thefuck_alias
