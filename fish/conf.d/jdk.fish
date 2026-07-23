set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-25.jdk/Contents/Home

function jdk
  set -gx JAVA_HOME $(/usr/libexec/java_home -v $argv[1]);
  java -version
end
