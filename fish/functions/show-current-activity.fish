function show-current-activity
  adb shell "dumpsys activity activities | grep ResumedActivity"
end