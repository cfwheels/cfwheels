<cfscript>

public void function addError(required string property, required string message, string name="") {
	ArrayAppend(variables.wheels.errors, arguments);
}

public void function addErrorToBase(required string message, string name="") {
	arguments.property = "";
	addError(argumentCollection=arguments);
}

public array function allErrors() {
	return variables.wheels.errors;
}

public void function clearErrors(string property="", string name="") {
	if (!Len(arguments.property) && !Len(arguments.name)) {
		ArrayClear(variables.wheels.errors);
	} else {
		local.iEnd = ArrayLen(variables.wheels.errors);
		for (local.i = local.iEnd; local.i >= 1; local.i--) {
			local.error = variables.wheels.errors[local.i];
			if (local.error.property == arguments.property && local.error.name == arguments.name) {
				ArrayDeleteAt(variables.wheels.errors, local.i);
			}
		}
	}
}

public numeric function errorCount(string property="", string name="") {
	if (!Len(arguments.property) && !Len(arguments.name)) {
		return ArrayLen(variables.wheels.errors);
	} else {
		return ArrayLen(errorsOn(argumentCollection=arguments));
	}
}

public array function errorsOn(required string property, string name="") {
	local.rv = [];
	local.iEnd = ArrayLen(variables.wheels.errors);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.error = variables.wheels.errors[local.i];
		if (local.error.property == arguments.property && local.error.name == arguments.name) {
			ArrayAppend(local.rv, variables.wheels.errors[local.i]);
		}
	}
	return local.rv;
}

public array function errorsOnBase(string name="") {
	arguments.property = "";
	return errorsOn(argumentCollection=arguments);
}

public boolean function hasErrors(string property="", string name="") {
	if (errorCount(argumentCollection=arguments) > 0) {
		return true;
	} else {
		return false;
	}
}

</cfscript>
