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
	<cfargument name="controller" type="string" required="true">
	<cfargument name="action" type="string" required="true">
	<cfset var loc = {}>

	<cfset loc.thisRoute = StructCopy(arguments)>

	<cfset loc.thisRoute.variables = "">
	<cfloop list="#arguments.pattern#" index="loc.i" delimiters="/">
		<cfif loc.i Contains "[">
			<cfset loc.thisRoute.variables = ListAppend(loc.thisRoute.variables, ReplaceList(loc.i, "[,]", ","))>
		</cfif>
	</cfloop>

	<cfset ArrayAppend(application.wheels.routes, loc.thisRoute)>

</cffunction>

<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		if (application.settings.environment IS NOT "production")
		{
			if (!Len(application.settings.database.datasource))
				$throw(type="Wheels.MissingDataSource", message="No data source has been added.", extendedInfo="Tell Wheels what data source you want to use by specifying it in 'config/database.cfm'. Don't forget to also add the data source in the ColdFusion Administrator. When you have made your changes you need to issue a '?reload=true' request or restart the ColdFusion service for the changes to be picked up by Wheels.");
		}
		$doubleCheckedLock(name="modelLock", path=application.wheels.models, key=arguments.name, method="$createClass", args=arguments);
	</cfscript>
	<cfreturn application.wheels.models[arguments.name]>
</cffunction>