<cfscript>
application.wheels.controllerPath = "wheels/tests/_assets/controllers";
application.wheels.modelPath = "/wheelsMapping/tests/_assets/models";
application.wheels.modelComponentPath = "wheels.tests._assets.models";
application.wheels.dataSourceName = "wheelstestdb";

/* turn off default validations for testing */
application.wheels.automaticValidations = false;
application.wheels.assetQueryString = false;
application.wheels.assetPaths = false;

/* redirections should always delay when testing */
application.wheels.functions.redirectTo.delay = true;

/* turn off transactions by default */
application.wheels.transactionMode = "none";

/* turn off request query caching */
application.wheels.cacheQueriesDuringRequest = false;
</cfscript>
