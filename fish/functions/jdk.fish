function jdk
  set -gx JAVA_HOME (/usr/libexec/java_home -v $argv[1]);
  java -version
end