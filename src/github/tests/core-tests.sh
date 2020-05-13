#!/bin/sh

port=${1:-"60005"}
engine=${2:-"lucee5"}
db=${3:-"mysql"}

test_url="http://127.0.0.1:${port}/wheels/tests/core?db=${db}&format=json"
result_file="/tmp/${engine}-${db}-result.txt"

echo "\nRUNNING SUITE (${engine}/${db}):\n"
echo ${test_url}
echo ${result_file}

http_code=$(curl --verbose -s -o "${result_file}" -w "%{http_code}" "${test_url}";)

cat $result_file

if [ "$http_code" -eq "200" ]; then
    echo "\nPASS: HTTP Status Code was 200"
else
    echo "\nFAIL: Status Code: $http_code"
    exit 1
fi
