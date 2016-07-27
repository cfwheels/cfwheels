<cfscript>

public function protectFromForgery(string with = "exception", string only = "", string except = "") {
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
		local.isValid = CsrfVerifyToken(params.authenticityToken);
	}
	else {
		local.isValid = false;
	}

	return local.isValid;
}

public string function $generateAuthenticityToken() {
	return CSRFGenerateToken();
}

</cfscript>
