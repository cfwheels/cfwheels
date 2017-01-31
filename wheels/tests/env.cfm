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

// CSRF
application.wheels.csrfCookieName = "_wheels_test_authenticity";
application.wheels.csrfCookieEncryptionAlgorithm = "AES";
application.wheels.csrfCookieEncryptionSecretKey = GenerateSecretKey("AES");
application.wheels.csrfCookieEncryptionEncoding = "Base64";

// Setup CSRF token and cookie. The cookie can always be in place, even when the session-based CSRF storage is being
// tested.
dummyController = controller("dummy");
csrfToken = dummyController.$generateCookieAuthenticityToken();

cookie[application.wheels.csrfCookieName] = Encrypt(
  SerializeJson({ authenticityToken=csrfToken }),
  application.wheels.csrfCookieEncryptionSecretKey,
  application.wheels.csrfCookieEncryptionAlgorithm,
  application.wheels.csrfCookieEncryptionEncoding
);

</cfscript>
