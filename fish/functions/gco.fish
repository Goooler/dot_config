function gco --wraps="git checkout"
  if test (count $argv) -gt 0
    git checkout $argv
  else
    git checkout (__git_trunk)
  end
end