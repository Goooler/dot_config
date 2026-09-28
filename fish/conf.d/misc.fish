set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/go/bin
set -gx PATH $PATH $HOME/.local/share/depot_tools
set -gx PATH $PATH /Applications/Ghostty.app/Contents/MacOS
set -gx PATH $PATH "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"


alias grep="grep --color=auto -n -I"
alias ll="gls -vAhlF --color --group-directories-first"
alias sha256="shasum -a 256"
alias yp="yt-dlp --concurrent-fragments 16 --cookies-from-browser chrome"
alias ytsub="yt-dlp --cookies-from-browser chrome --write-subs --write-auto-subs --sub-lang 'ai-zh,zh-Hans,zh-CN,zh' --skip-download"


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
