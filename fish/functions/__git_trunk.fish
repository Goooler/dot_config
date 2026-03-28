function __git_trunk
  for branch in "trunk" "main" "master"
    if git rev-parse "$branch" &>/dev/null
      echo $branch
      break
    end
  end
end