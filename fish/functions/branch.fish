function branch
  if test (count $argv) -eq 0
    git branch --sort=-committerdate
  else
    git checkout -b "(whoami).(string join '-' $argv | string replace -a ' ' '-').(date +%Y-%m-%d)"
  end
end