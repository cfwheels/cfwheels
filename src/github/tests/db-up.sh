#!/bin/sh

dbengine=${1}

. $(dirname "$0")/functions.sh

port="$(get_port ${1})"

bash $(dirname "$0")/wait-for-it.sh --timeout=3  --strict localhost:${port}  -- echo ${dbengine} "up"
