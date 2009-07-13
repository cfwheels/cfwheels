<cfscript>
	// we use $wheels here since these variables get placed in the variables scope of all objects and we need to make sure they don't clash with other wheels variables or any variables the develoepr may set
	$wheels.className = Reverse(SpanExcluding(Reverse(GetMetaData(this).name), "."));
	if (StructKeyExists(application.wheels.mixins, $wheels.className))
	{
		$wheels.iList = application.wheels.mixins[$wheels.className];
		$wheels.iEnd = ListLen($wheels.iList);
		for ($wheels.i=1; $wheels.i <= $wheels.iEnd; $wheels.i++)
		{
			$wheels.iItem = ListGetAt($wheels.iList, $wheels.i);
			$wheels.pluginName = ListFirst($wheels.iItem, ".");
			$wheels.methodName = ListLast($wheels.iItem, ".");
			if (StructKeyExists(variables, $wheels.methodName))
				variables.core[$wheels.methodName] = variables[$wheels.methodName];
			variables[$wheels.methodName] = application.wheels.plugins[$wheels.pluginName][$wheels.methodName];
		}
	}
</cfscript>