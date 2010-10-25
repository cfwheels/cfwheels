<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfscript>
			loc.controller = controller(name="dummy");
			application.wheels.assetQueryString = true;
		</cfscript>
	</cffunction>

	<cffunction name="teardown">
		<cfscript>
			application.wheels.assetQueryString = false;
		</cfscript>
	</cffunction>

	<cffunction name="test_returns_empty_string_when_set_false">
		<cfscript>
			application.wheels.assetQueryString = false;
			loc.e = loc.controller.$appendQueryString();
			assert('Len(loc.e) eq 0');
		</cfscript>
	</cffunction>

	<cffunction name="test_returns_string_when_set_true">
		<cfscript>
			loc.e = loc.controller.$appendQueryString();
			assert('IsSimpleValue(loc.e) eq true');
		</cfscript>
	</cffunction>

	<cffunction name="test_returns_match_when_set_to_string">
		<cfscript>
			application.wheels.assetQueryString = "MySpecificBuildNumber";
			loc.e = loc.controller.$appendQueryString();
			assert('loc.e eq "?MySpecificBuildNumber"');
		</cfscript>
	</cffunction>

	<cffunction name="test_returns_same_value_without_reload">
		<cfscript>
			loc.iEnd = 100;
			application.wheels.assetQueryString = "MySpecificBuildNumber";
			loc.e = loc.controller.$appendQueryString();
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				assert('loc.controller.$appendQueryString() eq loc.e');
			assert('loc.e eq "?MySpecificBuildNumber"');
		</cfscript>
	</cffunction>

</cfcomponent>