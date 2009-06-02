<cfscript>
	// we use $wheels here since these variables get placed in the variables scope of all objects and we need to make sure they don't clash with other wheels variables or any variables the develoepr may set
	$wheels.iList = StructKeyList(application.wheels.plugins);
	$wheels.iEnd = ListLen($wheels.iList);
	for ($wheels.i=1; $wheels.i <= $wheels.iEnd; $wheels.i++)
	{
		$wheels.iItem = ListGetAt($wheels.iList, $wheels.i);
		$wheels.jList = StructKeyList(application.wheels.plugins[$wheels.iItem]);
		$wheels.jEnd = ListLen($wheels.jList);
		for ($wheels.j=1; $wheels.j <= $wheels.jEnd; $wheels.j++)
		{
			$wheels.jItem = ListGetAt($wheels.jList, $wheels.j);
			if (!ListFindNoCase("init,version", $wheels.jItem))
			{
				if (StructKeyExists(variables, $wheels.jItem))
					variables.core[$wheels.jItem] = variables[$wheels.jItem];
				variables[$wheels.jItem] = application.wheels.plugins[$wheels.iItem][$wheels.jItem];
			}
		}
	}
</cfscript>