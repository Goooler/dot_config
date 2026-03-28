function rebase
  set trunk (__git_trunk)
  git checkout $trunk
  and git pull --prune
  and git checkout -
  and git rebase $trunk
end