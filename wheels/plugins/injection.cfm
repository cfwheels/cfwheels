<cfscript>
	// we use $wheels here since these variables get placed in the variables scope of all objects and we need to make sure they don't clash with other wheels variables or any variables the develoepr may set
	if (!StructIsEmpty(application.wheels.mixins))
	{
		$wheels.metaData = GetMetaData(this);
		if (StructKeyExists($wheels.metaData, "displayName"))
			$wheels.className = $wheels.metaData.displayName;
		else
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
				if (!StructKeyExists(variables, "core"))
					variables.core = {};
				if (StructKeyExists(variables, $wheels.methodName) && !StructKeyExists(variables.core, $wheels.methodName))
					variables.core[$wheels.methodName] = Duplicate(variables[$wheels.methodName]);
				variables[$wheels.methodName] = Duplicate(application.wheels.plugins[$wheels.pluginName][$wheels.methodName]);
			}
		}
	}
</cfscript>