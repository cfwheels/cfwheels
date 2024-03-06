<cfsetting requestTimeOut="1800">
<cfscript>
    testBox = new testbox.system.TestBox(directory="wheels.tests_testbox.specs")

    setTestboxEnvironment()

    if(structKeyExists(url, "format")){
        if(url.format eq "json"){
            result = testBox.run(
                reporter = "testbox.system.reports.JSONReporter"
            );
            cfcontent(type="application/json");
            cfheader(name="Access-Control-Allow-Origin", value="*");
            DeJsonResult = DeserializeJSON(result);
            if (DeJsonResult.totalFail > 0 || DeJsonResult.totalError > 0) {
                cfheader(statustext="Expectation Failed", statuscode=417);
            } else {
                cfheader(statustext="OK", statuscode=200);
            }
            // Check if 'only' parameter is provided in the URL
            if (structKeyExists(url, "only") && url.only eq "failure,error") {
                // Filter test results
                filteredBundles = [];
                
                for (bundle in DeJsonResult.bundleStats) {
                    if (bundle.totalError > 0 || bundle.totalFail > 0) {
                        filteredSuites = [];
                        
                        for (suite in bundle.suiteStats) {
                            if (suite.totalError > 0 || suite.totalFail > 0) {
                                arrayAppend(filteredSuites, suite);
                            }
                        }
                        
                        if (arrayLen(filteredSuites) > 0) {
                            bundle.suiteStats = filteredSuites;
                            arrayAppend(filteredBundles, bundle);
                        }
                    }
                }
            
                // Update the result with filtered data
                DeJsonResult.bundleStats = filteredBundles;
                result = serializeJSON(DeJsonResult);
            }
        }
        else if (url.format eq "txt") {
            result = testBox.run(
                reporter = "testbox.system.reports.TextReporter"
            )        
            cfcontent(type="text/plain");
        }
        else if(url.format eq "junit"){
            result = testBox.run(
                reporter = "testbox.system.reports.ANTJUnitReporter"
            )
            cfcontent(type="text/xml");
        }
    }
    else{
        result = testBox.run(
            reporter = "testbox.system.reports.SimpleReporter"
        )
    }
    writeOutput(result)
    // reset the original environment
    application.wheels = application.$$$wheels
    structDelete(application, "$$$wheels")

    private function setTestboxEnvironment() {
        // creating backup for original environment
        application.$$$wheels = Duplicate(application.wheels)

        // load testbox routes
        application.wo.$include(template = "/wheels/tests_testbox/routes.cfm")
        application.wo.$setNamedRoutePositions()

        local.AssetPath = "/wheels/tests_testbox/_assets/"
        
        application.wo.set(rewriteFile = "index.cfm")
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
        application.wo.set(wheelsComponentPath = "/wheels")

        /* turn off default validations for testing */
        application.wheels.automaticValidations = false
        application.wheels.assetQueryString = false
        application.wheels.assetPaths = false

        /* redirections should always delay when testing */
        application.wheels.functions.redirectTo.delay = true

        /* turn off transactions by default */
        application.wheels.transactionMode = "none"

        /* turn off request query caching */
        application.wheels.cacheQueriesDuringRequest = false

        // CSRF
        application.wheels.csrfCookieName = "_wheels_test_authenticity"
        application.wheels.csrfCookieEncryptionAlgorithm = "AES"
        application.wheels.csrfCookieEncryptionSecretKey = GenerateSecretKey("AES")
        application.wheels.csrfCookieEncryptionEncoding = "Base64"

        // Setup CSRF token and cookie. The cookie can always be in place, even when the session-based CSRF storage is being
        // tested.
        dummyController = application.wo.controller("dummy")
        csrfToken = dummyController.$generateCookieAuthenticityToken()

        cookie[application.wheels.csrfCookieName] = Encrypt(
            SerializeJSON({authenticityToken = csrfToken}),
            application.wheels.csrfCookieEncryptionSecretKey,
            application.wheels.csrfCookieEncryptionAlgorithm,
            application.wheels.csrfCookieEncryptionEncoding
        )
        if(structKeyExists(url, "db") && listFind("mysql,sqlserver,postgres,h2", url.db)){
            application.wheels.dataSourceName = "wheelstestdb_" & url.db;
        } else if (application.wheels.coreTestDataSourceName eq "|datasourceName|") {
            application.wheels.dataSourceName = "wheelstestdb"; 
        } else {
            application.wheels.dataSourceName = application.wheels.coreTestDataSourceName;
        }
        application.testenv.db = application.wo.$dbinfo(datasource = application.wheels.dataSourceName, type = "version")

        // Setting up test database for test environment
        local.tables = application.wo.$dbinfo(datasource = application.wheels.dataSourceName, type = "tables")
        local.tableList = ValueList(local.tables.table_name)
        local.populate = StructKeyExists(url, "populate") ? url.populate : true
        if (local.populate || !FindNoCase("authors", local.tableList)) {
            include "populate.cfm"
        }
    }
</cfscript>