<cfscript>
	/*
	* PUBLIC MODEL OBJECT METHODS
	*/
	
	public void function addError(
		required string property,
		required string message,
		string name=""
	) { 
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
		if (!Len(arguments.property) && !Len(arguments.name))
		{
			ArrayClear(variables.wheels.errors);
		}
		else
		{
			local.iEnd = ArrayLen(variables.wheels.errors);
			for (local.i=local.iEnd; local.i >= 1; local.i--)
			{
				if (variables.wheels.errors[local.i].property == arguments.property && (variables.wheels.errors[local.i].name == arguments.name))
				{
					ArrayDeleteAt(variables.wheels.errors, local.i);
				}
			}
		} 
	}

	public numeric function errorCount(string property="", string name="") { 
		if (!Len(arguments.property) && !Len(arguments.name))
		{
			local.rv = ArrayLen(variables.wheels.errors);
		}
		else
		{
			local.rv = ArrayLen(errorsOn(argumentCollection=arguments));
		} 
		return local.rv;
	}

	public array function errorsOn(required string property, string name="") { 
		local.rv = [];
		local.iEnd = ArrayLen(variables.wheels.errors);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			if (variables.wheels.errors[local.i].property == arguments.property && (variables.wheels.errors[local.i].name == arguments.name))
			{
				ArrayAppend(local.rv, variables.wheels.errors[local.i]);
			}
		} 
		return local.rv;
	}

	public array function errorsOnBase(string name="") { 
		arguments.property = "";
		local.rv = errorsOn(argumentCollection=arguments); 
		return local.rv;
	}

	public boolean function hasErrors(string property="", string name="") {  
		local.rv = false;
		if (errorCount(argumentCollection=arguments) > 0)
		{
			local.rv = true;
		} 
		return local.rv;
	}
</cfscript>  
 
