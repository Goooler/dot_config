set -gx ANDROID_SDK $HOME/Library/Android/sdk
set -gx ANDROID_SDK_ROOT $ANDROID_SDK
set -gx ANDROID_HOME $ANDROID_SDK
set -gx ANDROID_NDK $ANDROID_SDK/ndk/29.0.14206865
set -gx ANDROID_NDK_HOME $ANDROID_NDK
set -gx ANDROID_SDK_CMD_TOOLS $ANDROID_SDK/cmdline-tools/latest/bin
set -gx ANDROID_SDK_PLATFORM_TOOLS $ANDROID_SDK/platform-tools
set -gx ANDROID_SDK_PROGUARD $ANDROID_SDK/tools/proguard/bin

set -gx PATH /usr/local/sbin $PATH
set -gx PATH $ANDROID_SDK $PATH
set -gx PATH $ANDROID_SDK_ROOT $PATH
set -gx PATH $ANDROID_HOME $PATH
set -gx PATH $ANDROID_NDK $PATH
set -gx PATH $ANDROID_NDK_HOME $PATH
set -gx PATH $ANDROID_SDK_CMD_TOOLS $PATH
set -gx PATH $ANDROID_SDK_PLATFORM_TOOLS $PATH
set -gx PATH $ANDROID_SDK_PROGUARD $PATH


function install-aab
  set aab_path $argv[1]
  set apks_path (string replace -r '\.[^.]*$' '.apks' $aab_path)

  bundletool build-apks --bundle=$aab_path --output=$apks_path
  bundletool install-apks --apks=$apks_path
end
