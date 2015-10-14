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
			if (!StructKeyExists(variables, "core"))
			{
				variables.core = {};
				StructAppend(variables.core, variables);
				StructDelete(variables.core, "$wheels");
			}
			StructAppend(variables, application[$wheels.appKey].mixins[$wheels.className], true);
		}
		if (StructKeyExists(variables, "$wheels"))
		{
			// get rid of any extra data created in the variables scope
			StructDelete(variables, "$wheels");
		}
	}
</cfscript>