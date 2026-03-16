set -gx PATH $PATH $HOME/.local/bin

alias grep="grep --color=auto -n -I"
alias ll="gls -vAhlF --color --group-directories-first"
alias sha256="shasum -a 256"
alias yp="yt-dlp --concurrent-fragments 64 --cookies-from-browser chrome"
