<cfscript>

public function protectFromForgery(string with = "exception", string only = "", string except = "") {
	$args(args=arguments, name="protectFromForgery");

	// Store settings for this controller in `$class` for later use.
	variables.$class.csrf.type = arguments.with;
	variables.$class.csrf.only = arguments.only;
	variables.$class.csrf.except = arguments.except;
}

public function $runCsrfProtection(string action) {
	if (StructKeyExists(variables.$class, "csrf")) {
		local.csrf = variables.$class.csrf;

		if ((!Len(local.csrf.only) && !Len(local.csrf.except)) || (Len(local.csrf.only) && ListFindNoCase(local.csrf.only, arguments.action)) || (Len(local.csrf.except) && !ListFindNoCase(local.csrf.except, arguments.action))) {
			$storeAuthenticityToken();
			$flagRequestAsProtected();
			$setAuthenticityToken();
			$verifyAuthenticityToken();
		}
	}
}

public function $flagRequestAsProtected() {
	request.$wheels.protectedFromForgery = true;
}

public function $verifyAuthenticityToken() {
	if (!$isVerifiedRequest()) {
		switch (variables.$class.csrf.type) {
			case "abort":
				Abort;

			default:
				Throw(
					"This POSTed request was attempted without a valid authenticity token.",
					"Wheels.InvalidAuthenticityToken"
				);
		}
	}
}

public boolean function $isVerifiedRequest() {
	return isGet() || isHead() || isOptions() || $isAnyAuthenticityTokenValid();
}

public boolean function $isRequestProtectedFromForgery() {
	return StructKeyExists(request.$wheels, "protectedFromForgery")
		&& IsBoolean(request.$wheels.protectedFromForgery)
		&& request.$wheels.protectedFromForgery;
}

public function $setAuthenticityToken() {
	if (!$isVerifiedRequest() && isAjax()) {
		if (StructKeyExists(request.headers, "X-CSRF-Token")) {
			params.authenticityToken = request.headers["X-CSRF-Token"];
		}
	}
}

public function $storeAuthenticityToken() {
	$generateAuthenticityToken();
}

public boolean function $isAnyAuthenticityTokenValid() {
	if ($isRequestProtectedFromForgery() && StructKeyExists(params, "authenticityToken")) {
		if (application.wheels.csrfStore == "session") {
			local.isValid = CsrfVerifyToken(params.authenticityToken);
		} else {
			local.isValid = $isCookieAuthenticityTokenValid();
		}
	} else {
		local.isValid = false;
	}

	return local.isValid;
}

public string function $generateAuthenticityToken() {
	if (application.wheels.csrfStore == "session") {
		return CSRFGenerateToken();
	} else {
		return $generateCookieAuthenticityToken();
	}
}

public boolean function $isCookieAuthenticityTokenValid() {
	local.authenticityToken = $generateCookieAuthenticityToken();
	return Len(local.authenticityToken) && local.authenticityToken == params.authenticityToken;
}

public string function $generateCookieAuthenticityToken() {
	local.authenticityToken = $readAuthenticityTokenFromCookie();

	// If cookie doesn't yet exist, create it.
	if (!Len(local.authenticityToken)) {
		local.authenticityToken = GenerateSecretKey(application.wheels.csrfCookieEncryptionAlgorithm);

		local.value = SerializeJson({
			sessionId=CreateUuid(),
			authenticityToken=local.authenticityToken
		});

		local.value = Encrypt(
			local.value,
			application.wheels.csrfCookieEncryptionSecretKey,
			application.wheels.csrfCookieEncryptionAlgorithm,
			application.wheels.csrfCookieEncryptionEncoding
		);

		if (application.wheels.csrfStore == "cookie") {
			cookie[application.wheels.csrfCookieName] = $csrfCookieAttributeCollection(local.value);
		// Tests will mock the cookie in the request scope.
		} else {
			request[application.wheels.csrfCookieName] = $csrfCookieAttributeCollection(local.value);
			request[application.wheels.csrfCookieName].authenticityToken = local.authenticityToken;
		}
	}

	return local.authenticityToken;
}

public string function $readAuthenticityTokenFromCookie() {
		local.cookieName = application.wheels.csrfCookieName;

		// Cookie is there. Read it in.
		if (StructKeyExists(cookie, local.cookieName)) {
			local.cookie = cookie[local.cookieName];

			try {
				local.cookieAttrs = Decrypt(
					local.cookie,
					application.wheels.csrfCookieEncryptionSecretKey,
					application.wheels.csrfCookieEncryptionAlgorithm,
					application.wheels.csrfCookieEncryptionEncoding
				);
			// If cookie is corrupted, return empty string.
			} catch (any e) {
				return "";
			}

			local.cookieAttrs = DeserializeJson(local.cookieAttrs);

			return local.cookieAttrs.authenticityToken;
		// No cookie, return empty string.
		} else {
			return "";
		}
}

public struct function $csrfCookieAttributeCollection(required string value) {
	local.cookieStruct = {
		value=arguments.value,
		encodeValue=application.wheels.csrfCookieEncodeValue,
		httpOnly=application.wheels.csrfCookieHttpOnly,
		preserveCase=application.wheels.csrfCookiePreserveCase,
		secure=application.wheels.csrfCookieSecure
	};

	if (Len(application.wheels.csrfCookieDomain)) {
		local.cookieStruct.domain = application.wheels.csrfCookieDomain;
	}

	if (Len(application.wheels.csrfCookiePath)) {
		local.cookieStruct.path = application.wheels.csrfCookiePath;
	}

	return local.cookieStruct;
}

</cfscript>
