#!/bin/sh

cfengine=${1}
dbengine=${2}

case $cfengine in
  lucee5)
    port=60005
    ;;
  adobe2016)
    port=62016
    ;;
  adobe2018)
    port=62018
    ;;
  *)
    echo -n "unknown"
    ;;
esac

case $dbengine in
    mysql56)
        db=mysql
        ;;
    *)
        db=${dbengine}
        ;;
esac

test_url="http://127.0.0.1:${port}/wheels/tests/core?db=${db}&format=json"
result_file="/tmp/${engine}-${db}-result.txt"

echo "\nRUNNING SUITE (${engine}/${dbengine}):\n"
echo ${test_url}
echo ${result_file}

http_code=$(curl -s -o "${result_file}" --write-out "%{http_code}" "${test_url}";)

cat $result_file

if [ "$http_code" -eq "200" ]; then
    echo "\nPASS: HTTP Status Code was 200"
else
    echo "\nFAIL: Status Code: $http_code"
    exit 1
fi
