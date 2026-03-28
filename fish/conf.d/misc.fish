set -gx PATH $PATH $HOME/.local/bin

alias grep="grep --color=auto -n -I"
alias ll="gls -vAhlF --color --group-directories-first"
alias sha256="shasum -a 256"
alias yp="yt-dlp --concurrent-fragments 64 --cookies-from-browser chrome"


function upfind
  set -f dir (pwd)

  while [ "$dir" != "/" ]
    set -l p (find "$dir" -maxdepth 1 -name $argv[1])

    if [ -n "$p" ]
      echo "$p"
      return 1
    end

    set -f dir (dirname $dir)
  end
end
