set -gx ANDROID_SDK $HOME/Library/Android/sdk
set -gx ANDROID_SDK_ROOT $ANDROID_SDK
set -gx ANDROID_HOME $ANDROID_SDK
set -gx ANDROID_NDK $ANDROID_SDK/ndk/29.0.14206865
set -gx ANDROID_NDK_HOME $ANDROID_NDK
set -gx ANDROID_SDK_CMD_TOOLS $ANDROID_SDK/cmdline-tools/latest/bin
set -gx ANDROID_SDK_PLATFORM_TOOLS $ANDROID_SDK/platform-tools
set -gx ANDROID_SDK_PROGUARD $ANDROID_SDK/tools/proguard/bin
set -gx ANDROID_SDK_BUILD_TOOLS $ANDROID_SDK/build-tools/36.0.0

set -gx PATH /usr/local/sbin $PATH
set -gx PATH $ANDROID_SDK $PATH
set -gx PATH $ANDROID_SDK_ROOT $PATH
set -gx PATH $ANDROID_HOME $PATH
set -gx PATH $ANDROID_NDK $PATH
set -gx PATH $ANDROID_NDK_HOME $PATH
set -gx PATH $ANDROID_SDK_CMD_TOOLS $PATH
set -gx PATH $ANDROID_SDK_PLATFORM_TOOLS $PATH
set -gx PATH $ANDROID_SDK_PROGUARD $PATH
set -gx PATH $ANDROID_SDK_BUILD_TOOLS $PATH


function install-aab
  set aab_path $argv[1]
  set apks_path (string replace -r '\.[^.]*$' '.apks' $aab_path)

  bundletool build-apks --bundle=$aab_path --output=$apks_path
  bundletool install-apks --apks=$apks_path
end

function show-current-activity
  adb shell "dumpsys activity activities | grep ResumedActivity"
end

function check_elf_alignment --description 'Check ELF alignment of shared libraries for 16 KB page size support'
  # usage: check_elf_alignment [path to *.so files|path to *.apk|path to *.apex]

  set -l progname "check_elf_alignment"

  # Define usage helper
  function __check_elf_usage
    echo "Host side script to check the ELF alignment of shared libraries."
    echo "Shared libraries are reported ALIGNED when their ELF regions are"
    echo "16 KB or 64 KB aligned. Otherwise they are reported as UNALIGNED."
    echo
    echo "Usage: check_elf_alignment [input-path|input-APK|input-APEX]"
  end

  # Argument count check
  if test (count $argv) -ne 1
    __check_elf_usage
    return 1
  end

  set -l input_path $argv[1]

  # Help flags
  if contains -- $input_path -h --help -?
    __check_elf_usage
    return 0
  end

  # Validation
  if not test -e $input_path
    echo "Invalid file: $input_path" >&2
    return 1
  end

  set -l tmp ""
  set -l dir_filename ""
  set -l search_dir $input_path

  # Case: APK file
  if string match -q "*.apk" $input_path
    echo
    echo "Recursively analyzing $input_path"
    echo

    # Check if zipalign supports the -P (page size) flag
    if zipalign --help 2>&1 | grep -q "\-P <pagesize_kb>"
      echo "=== APK zip-alignment ==="
      zipalign -v -c -P 16 4 $input_path | grep -E 'lib/arm64-v8a|lib/x86_64|Verification'
      echo "========================="
    else
      echo "NOTICE: Zip alignment check requires build-tools version 35.0.0-rc3 or higher."
      echo "  You can install the latest build-tools by running the below command"
      echo "  and updating your \$PATH:"
      echo
      echo "  sdkmanager \"build-tools;35.0.0-rc3\""
    end

    set dir_filename (basename $input_path)
    set tmp (mktemp -d -t (string replace -r '\.apk$' '' $dir_filename)"_out_XXXXX")
    unzip $input_path "lib/*" -d $tmp >/dev/null 2>&1
    set search_dir $tmp

  # Case: APEX file
  else if string match -q "*.apex" $input_path
    echo
    echo "Recursively analyzing $input_path"
    echo

    set dir_filename (basename $input_path)
    set tmp (mktemp -d -t (string replace -r '\.apex$' '' $dir_filename)"_out_XXXXX")
    deapexer extract $input_path $tmp; or begin; echo "Failed to deapex."; return 1; end
    set search_dir $tmp
  end

  # Colors
  set -l RED (set_color red)
  set -l GREEN (set_color green)
  set -l ENDCOLOR (set_color normal)

  set -l unaligned_libs
  echo
  echo "=== ELF alignment ==="

  # Walk through files
  for match in (find $search_dir -type f)
    # Recursion warnings (matching original bash logic)
    if string match -q "*.apk" $match
      echo "WARNING: doesn't recursively inspect .apk file: $match"
      continue
    end
    if string match -q "*.apex" $match
      echo "WARNING: doesn't recursively inspect .apex file: $match"
      continue
    end

    # Check if it is an ELF file
    if not string match -q "*ELF*" (file $match)
      continue
    end

    # Extract alignment from objdump
    set -l res (objdump -p $match | grep LOAD | awk '{ print $NF }' | head -1)

    # Match 2^14 (16KB) or higher (2^14, 2^15, 2^16...)
    if string match -qr '2\*\*(1[4-9]|[2-9][0-9]|[1-9][0-9]{2,})' -- $res
      echo -e "$match: $GREEN"ALIGNED"$ENDCOLOR ($res)"
    else
      echo -e "$match: $RED"UNALIGNED"$ENDCOLOR ($res)"
      set -a unaligned_libs $match
    end
  end

  # Summary
  if test (count $unaligned_libs) -gt 0
    echo -e "$RED"Found (count $unaligned_libs) "unaligned libs (only arm64-v8a/x86_64 libs need to be aligned).$ENDCOLOR"
  else if test -n "$dir_filename"
    echo -e "ELF Verification Successful"
  end
  echo "====================="

  # Cleanup temporary files
  if test -n "$tmp"; and test -d "$tmp"
    rm -rf $tmp
  end
end
