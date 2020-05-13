#!/bin/sh

cfengine=${1}
dbengine=${2}

declare -A ports
ports["lucee5"]=60005
ports["adobe2016"]=62016
ports["adobe2018"]=62018
port = ${ports[${cfengine}]}

declare -A dbs
dbs["mysql56"]=mysql
dbs["postgres"]=postgres
dbs["sqlserver"]=sqlserver
db = ${dbs[${dbengine}]}

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
