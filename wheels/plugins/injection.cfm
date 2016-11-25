<cfscript>
	// we use $wheels here since these variables get placed in the variables scope of all objects and we need to make sure they don't clash with other wheels variables or any variables the developer may set
	if (StructKeyExists(application, "$wheels"))
	{
		$wheels.appKey = "$wheels";
	}
	else
	{
		$wheels.appKey = "wheels";
	}
	if (!StructIsEmpty(application[$wheels.appKey].mixins))
	{
		$wheels.metaData = GetMetaData(this);
		if (StructKeyExists($wheels.metaData, "displayName"))
		{
			$wheels.className = $wheels.metaData.displayName;
		}
		else
		{
			$wheels.className = Reverse(SpanExcluding(Reverse($wheels.metaData.name), "."));
		}
		if (StructKeyExists(application[$wheels.appKey].mixins, $wheels.className))
		{

			// we need to first get our mixins
			variables.$wheels.mixins = {};
			StructAppend(variables.$wheels.mixins, application[$wheels.appKey].mixins[$wheels.className], true);

			// then loop through the $stacks to set our original functions at the end
			// of the stack
			if (structKeyExists(variables.$wheels.mixins, "$stacks"))
				for (variables.$wheels.method in variables.$wheels.mixins.$stacks)
					if (structKeyExists(variables, variables.$wheels.method))
						arrayAppend(variables.$wheels.mixins.$stacks[variables.$wheels.method], variables[variables.$wheels.method]);

			// finally append our entire mixin to the variables scope
			// core methods were added as the mixin was created so we don't
			// need every method from variables in variables.core which
			// means less bloat in the core struct
			structAppend(variables, variables.$wheels.mixins, true);
		}
		if (StructKeyExists(variables, "$wheels"))
		{
			// get rid of any extra data created in the variables scope
			StructDelete(variables, "$wheels");
		}
	}
</cfscript>
