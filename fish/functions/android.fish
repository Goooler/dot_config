function install-aab
  set aab_path $argv[1]
  set apks_path (string replace -r '\.[^.]*$' '.apks' $aab_path)

  bundletool build-apks --bundle=$aab_path --output=$apks_path
  bundletool install-apks --apks=$apks_path
end

function show-current-activity
  adb shell "dumpsys activity activities | grep ResumedActivity"
end
