<cfscript>
/**
 * Internal Function
 */
public any function $pluginRunner() {
	local.previousStack = callStackGet()[2]["function"];

	// get the method name called so that we know which stack to run this is our
	// default way of seeing which method we're supposed to be running for our
	// stacks
	local.methodName = GetFunctionCalledName();

	// if we still don't have what we need our method has been invoked and cf
	// doesn't give us any information for the stack fr
	if (!StructKeyExists(variables.$stacks, local.methodName) && StructKeyExists(request, "$wheelsInvoked") && ArrayLen(request.$wheelsInvoked)) {
		local.methodName = request.$wheelsInvoked[1].method;
	}

	// some of our plugin developers var a new variable that
	// changes the name of the function when called so getFunctionCalledName()
	// returns something we do not understand. We need to fall back to using
	// the stack trace to see what function was immediately called before the
	// function we are currently in. This is our last resort to see what is
	// going on
	//
	// Documentation should reflect that best practice is to just use the
	// core.method() when calling to a core function
	if (!StructKeyExists(variables.$stacks, local.methodName)) {
		local.methodName = local.previousStack;
	}

	if (!StructKeyExists(variables.$stacks, local.methodName)) {
		Throw(
				type="Wheels.MethodUnknown",
				message="The plugin system is unable to determine the method you are trying to call."
		);
	}

	// get our stack from $stack via the name this function was called as
	local.stack = variables.$stacks[local.methodName];

	local.stackLen = arrayLen(local.stack);

	// setup our counter in the request scope so it can be shared as necessary
	if (!StructKeyExists(request.wheels.stacks, local.methodName)) {
		request.wheels.stacks[local.methodName] = 1;
	}

	// ++ the counter for our next method on the stack or reset it to one
	if (local.methodName == local.previousStack) {
		request.wheels.stacks[local.methodName]++;
	} else {
		request.wheels.stacks[local.methodName] = 1;
	}

	// if the developer has called core.method() without there actually being a
	// core method with that name, throw a nice wheels error
	if (request.wheels.stacks[local.methodName] > local.stackLen) {

		// make sure we reset our stack counter in case our expection is caught
		request.wheels.stacks[local.methodName] = 1;

		// throw a method not found error if core.method() doesn't have another
		// method in the stack
		Throw(
			type="Wheels.MethodNotFound",
			message="The method `#local.methodName#` is part of a plugin but was not found in the base object."
		);
	}

	// get the method in the local scope without needing to be scoped
	var method = local.stack[request.wheels.stacks[local.methodName]];

	// if the method called throws an error we'll catch it, reset our counter
	// and rethrow the error
	try {
		local.result = method(argumentCollection=arguments);
	} catch (any e) {
		request.wheels.stacks[local.methodName] = 1;
		rethrow;
	}

	// now that we have a result, remove from our counter
	if (local.methodName == local.previousStack && request.wheels.stacks[local.methodName] != 1) {
		request.wheels.stacks[local.methodName]--;
	}

	// can't return a null result from a variable
	if (!isNull(local.result)) {
		return local.result;
	}

	// return null
	return;
}

</cfscript>
