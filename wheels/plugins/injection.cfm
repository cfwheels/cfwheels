<cfscript>
	loc.iList = StructKeyList(application.wheels.plugins);
	loc.iEnd = ListLen(loc.iList);
	for (loc.i=1; loc.i lte loc.iEnd; loc.i=loc.i+1)
	{
		loc.iItem = ListGetAt(loc.iList, loc.i);
		loc.jList = StructKeyList(application.wheels.plugins[loc.iItem]);
		loc.jEnd = ListLen(loc.jList);
		for (loc.j=1; loc.j lte loc.jEnd; loc.j=loc.j+1)
		{
			loc.jItem = ListGetAt(loc.jList, loc.j);
			if (not(ListFindNoCase("init,version", loc.jItem)))
			{
				variables[loc.jItem] = application.wheels.plugins[loc.iItem][loc.jItem];
				if (StructKeyExists(variables, loc.jItem))
					variables.core[loc.jItem] = variables[loc.jItem];
			}
		}
	}
</cfscript>