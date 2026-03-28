function gw --wraps=gradle
  set -l GW "(upfind gradlew)"
  if [ -z "$GW" ]
    echo "Gradle wrapper not found."
    return 1
  else if contains -- "-p" $argv
    $GW --profile --parallel $argv
  else
    $GW -p (dirname $GW) --profile --parallel $argv
  end
end