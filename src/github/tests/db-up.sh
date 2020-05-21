#!/bin/sh

dbengine=${1}

. $(dirname "$0")/functions.sh

port="$(get_port ${1})"

bash $(dirname "$0")/wait-for-it.sh --timeout=60  --strict 127.0.0.1:${port}  -- echo ${dbengine} "up"
