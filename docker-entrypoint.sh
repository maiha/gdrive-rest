#!/usr/bin/env sh

case "$1" in
  "auth" )
    shift
    set -- ruby /usr/local/bin/gdrive.rb "$@"
    exec "$@"
    ;;
  "httpd" )
    shift
    set -- ruby /usr/local/bin/httpd.rb "$@"
    exec "$@"
    ;;
  * )
    exec "$@"
    ;;
esac
