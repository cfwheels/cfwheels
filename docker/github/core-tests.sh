#!/bin/sh

echo "------------------------------- Starting Core-tests.sh -------------------------------"

pwd
ls ../
box server status

cfengine=${1}
dbengine=${2}

. $(dirname "$0")/functions.sh

port="$(get_port ${cfengine})"
db="$(get_db ${dbengine})"

test_url="http://127.0.0.1:${port}/wheels/testbox?db=${db}&format=json&only=failure,error&method=runRemote&directory=&testSuites=Tests%20that%20redirectto,Tests%20that%20findAllKeys,Tests%20that%20$performedRenderOrRedirect,Tests%20that%20processrequest&testBundles=wheels%2Etests_testbox%2Especs%2Econtroller%2Eredirection,wheels%2Etests_testbox%2Especs%2Econtroller%2Emiscellaneous,wheels%2Etests_testbox%2Especs%2Emodel%2Eread,wheels%2Etests_testbox%2Especs%2Eglobal%2Epublic&opt_run=true&coverageEnabled=false"
result_file="/tmp/${cfengine}-${db}-result.txt"

echo "\nRUNNING SUITE (${cfengine}/${dbengine}):\n"
echo ${test_url}
echo ${result_file}

http_code=$(curl -s -o "${result_file}" --write-out "%{http_code}" "${test_url}";)

echo "\nls /tmp/:"
ls /tmp -la

echo "\nResult file:"
cat ${result_file}

echo "\nHTTP Code Pulled Down:"
echo ${http_code}

echo "\npwd:"
pwd

echo "\nls:"
ls -la

echo "\nwhich box"
which box

echo "\n"
cat $result_file

if [ "$http_code" -eq "200" ]; then
    echo "\nPASS: HTTP Status Code was 200"
else
    echo "\nFAIL: Status Code: $http_code"
    exit 1
fi

echo "------------------------------- Ending Core-tests.sh -------------------------------"
