<cffunction name="obfuscateParam" returntype="string" access="public" output="false">
	<cfargument name="param" type="any" required="true">
	<cfscript>
		var loc = {};
		if (isValid("integer", arguments.param) AND IsNumeric(arguments.param))
		{
			loc.length = Len(arguments.param);
			loc.a = (10^loc.length) + Reverse(arguments.param);
			loc.b = "0";
			for (loc.i=1; loc.i LTE loc.length; loc.i=loc.i+1)
				loc.b = (loc.b + Left(Right(arguments.param, loc.i), 1));
			loc.returnValue = FormatBaseN((loc.b+154),16) & FormatBaseN(BitXor(loc.a,461),16);
		}
		else
		{
			loc.returnValue = arguments.param;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="deobfuscateParam" returntype="string" access="public" output="false">
	<cfargument name="param" type="string" required="true">
	<cfscript>
		var loc = {};
		if (Val(arguments.param) IS NOT arguments.param)
		{
			try
			{
				loc.checksum = Left(arguments.param, 2);
				loc.returnValue = Right(arguments.param, (Len(arguments.param)-2));
				loc.z = BitXor(InputBasen(loc.returnValue,16),461);
				loc.returnValue = "";
				for (loc.i=1; loc.i LTE Len(loc.z)-1; loc.i=loc.i+1)
					loc.returnValue = loc.returnValue & Left(Right(loc.z, loc.i),1);
				loc.checksumtest = "0";
				for (loc.i=1; loc.i LTE Len(loc.returnValue); loc.i=loc.i+1)
					loc.checksumtest = (loc.checksumtest + Left(Right(loc.returnValue, loc.i),1));
				if (Left(ToString(FormatBaseN((loc.checksumtest+154),10)),2) IS NOT Left(InputBasen(loc.checksum, 16),2))
					loc.returnValue = arguments.param;
			}
			catch(Any e)
			{
	    	loc.returnValue = arguments.param;
			}
		}
		else
		{
    	loc.returnValue = arguments.param;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="addRoute" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="pattern" type="string" required="true">
	<cfargument name="controller" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		
		// throw errors when controller or action is not passed in as arguments and not included in the pattern
		if (!Len(arguments.controller) && arguments.pattern Does Not Contain "[controller]")
			$throw(type="Wheels.IncorrectArguments", message="The 'controller' argument is not passed in or included in the pattern.", extendedInfo="Either pass in the 'controller' argument to specifically tell Wheels which controller to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
		if (!Len(arguments.action) && arguments.pattern Does Not Contain "[action]")
			$throw(type="Wheels.IncorrectArguments", message="The 'action' argument is not passed in or included in the pattern.", extendedInfo="Either pass in the 'action' argument to specifically tell Wheels which action to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
		
		loc.thisRoute = StructCopy(arguments);
		loc.thisRoute.variables = "";
		loc.iEnd = ListLen(arguments.pattern, "/");
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.pattern, loc.i, "/");
			if (loc.i Contains "[")
				loc.thisRoute.variables = ListAppend(loc.thisRoute.variables, ReplaceList(loc.item, "[,]", ","));
		}
		ArrayAppend(application.wheels.routes, loc.thisRoute);
	</cfscript>
</cffunction>

<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		$doubleCheckedLock(name="modelLock", path=application.wheels.models, key=arguments.name, method="$createClass", args=arguments);
	</cfscript>
	<cfreturn application.wheels.models[arguments.name]>
</cffunction>