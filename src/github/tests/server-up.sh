#!/bin/sh

. $(dirname "$0")/functions.sh

port="$(get_port ${1})"

max_iterations=10
wait_seconds=6
http_endpoint="http://127.0.0.1:${port}"

iterations=0
while true; do
  iterations=$(expr $iterations + 1)

	echo -n "Attempt ${iterations}.. "
	sleep $wait_seconds

	http_code=$(curl -s -o /tmp/server-up-${port}.txt -w '%{http_code}' "$http_endpoint";)

  echo $http_code

	if [ "$http_code" -eq 200 ]; then
		echo "Server Up"
		break
	fi

	if [ "$iterations" -ge "$max_iterations" ]; then
		echo "Loop Timeout"
		exit 1
	fi
done
