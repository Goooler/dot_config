function rm-merged-local
  set trunk (__git_trunk)
  git branch --merged $trunk | command grep -v $trunk | xargs git branch -D
end