<cfscript>

// We use $wheels here since these variables get placed in the variables scope of all objects.
// This way we sure they don't clash with other Wheels variables or any variables the developer may set.
if (StructKeyExists(application, "$wheels")) {
	$wheels.appKey = "$wheels";
} else {
	$wheels.appKey = "wheels";
}

if (!StructIsEmpty(application[$wheels.appKey].mixins)) {
	$wheels.metaData = GetMetaData(this);
	if (StructKeyExists($wheels.metaData, "displayName")) {
		$wheels.className = $wheels.metaData.displayName;
	} else {
		$wheels.className = Reverse(SpanExcluding(Reverse($wheels.metaData.name), "."));
	}
	if (StructKeyExists(application[$wheels.appKey].mixins, $wheels.className)) {

		// We need to first get our mixins.
		variables.$wheels.mixins = duplicate(application[$wheels.appKey].mixins[$wheels.className]);

		// Then loop through the $stacks to set our original functions at the end of the stack.
		if (StructKeyExists(variables.$wheels.mixins, "$stacks")) {
			for (variables.$wheels.method in variables.$wheels.mixins.$stacks) {
				if (StructKeyExists(variables, variables.$wheels.method) && IsCustomFunction(variables[variables.$wheels.method])) {
					ArrayAppend(variables.$wheels.mixins.$stacks[variables.$wheels.method], variables[variables.$wheels.method]);
				}
			}
		}

		// Finally append our entire mixin to the variables scope.
		// Core methods were added when mixin was created so we don't need every method from variables in variables.core.
		// This means less bloat in the core struct.
		StructAppend(variables, variables.$wheels.mixins, true);

	}

	// Get rid of any extra data created in the variables scope.
	if (StructKeyExists(variables, "$wheels")) {
		StructDelete(variables, "$wheels");
	}

}
</cfscript>
