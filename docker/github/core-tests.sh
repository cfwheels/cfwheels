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

test_url="http://127.0.0.1:${port}/wheels/testbox?db=${db}&format=json&only=failure,error&method=runRemote&directory=&opt_run=true&coverageEnabled=false&testBundles=wheels%2Etests_testbox%2Especs%2EBasics,wheels%2Etests_testbox%2Especs%2Econtroller%2Ecaching,wheels%2Etests_testbox%2Especs%2Econtroller%2Ecsrf%2Ecookie,wheels%2Etests_testbox%2Especs%2Econtroller%2Ecsrf%2Esession,wheels%2Etests_testbox%2Especs%2Econtroller%2Efilters,wheels%2Etests_testbox%2Especs%2Econtroller%2Eflash,wheels%2Etests_testbox%2Especs%2Econtroller%2Einitialization,wheels%2Etests_testbox%2Especs%2Econtroller%2Emiscellaneous,wheels%2Etests_testbox%2Especs%2Econtroller%2Eprovides,wheels%2Etests_testbox%2Especs%2Econtroller%2Eredirection,wheels%2Etests_testbox%2Especs%2Econtroller%2Erendering,wheels%2Etests_testbox%2Especs%2Econtroller%2Erequest,wheels%2Etests_testbox%2Especs%2Econtroller%2Everifies,wheels%2Etests_testbox%2Especs%2Edispatch%2EcreateParams,wheels%2Etests_testbox%2Especs%2Edispatch%2EfindMatchingRoute,wheels%2Etests_testbox%2Especs%2Edispatch%2EfindMatchingRouteMega,wheels%2Etests_testbox%2Especs%2Edispatch%2Egetrequestmethod,wheels%2Etests_testbox%2Especs%2Edispatch%2Erequest,wheels%2Etests_testbox%2Especs%2Edispatch%2EsetCorsHeaders,wheels%2Etests_testbox%2Especs%2Eevents%2Eonerror,wheels%2Etests_testbox%2Especs%2Eglobal%2Ecaching,wheels%2Etests_testbox%2Especs%2Eglobal%2Einternal,wheels%2Etests_testbox%2Especs%2Eglobal%2Elistclean,wheels%2Etests_testbox%2Especs%2Eglobal%2Epublic,wheels%2Etests_testbox%2Especs%2Eglobal%2Estrings"
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
