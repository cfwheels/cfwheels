#!/bin/sh

# TODO: loop thru each server/database combo ??

port=${1:-"60005"}
engine=${1:-"lucee5"}
db=${1:-"mysql"}

test_url="http://127.0.0.1:${port}/wheels/tests/core?db=${engine}"
result_file='/tmp/${engine}-${db}-result.txt'

echo "\nRUNNING SUITE (${engine}/${db}):\n"

http_code=$(curl --verbose -s -o '${result_file}' -w '%{http_code}' '${test_url}';)

cat $result_file

if [ "$http_code" -eq "200" ]; then
    echo "\nPASS: HTTP Status Code was 200"
else
    echo "\nFAIL: Status Code: $http_code"
    exit 1
fi
