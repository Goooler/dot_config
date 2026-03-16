function install-aab
  set aab_path $argv[1]
  set apks_path (string replace -r '\.[^.]*$' '.apks' $aab_path)

  bundletool build-apks --bundle=$aab_path --output=$apks_path
  bundletool install-apks --apks=$apks_path
end

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
