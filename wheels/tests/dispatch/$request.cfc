<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset SavedRoutes = duplicate(application.wheels.routes)>
		<cfset application.wheels.routes = []>
		<cfset loc.dispatch = createobject("component", "wheelsMapping.Dispatch")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.routes = SavedRoutes>
	</cffunction>
	
 	<cffunction name="test_route_with_format">
		<cfset addRoute(name="test", pattern="users/[username].[format]", controller="test", action="test")>
		<cfscript>
			loc.args = {};
			loc.args.pathinfo = "/users/foo.bar";
			loc.args.urlScope["username"] = "foo.bar";
			loc.params = loc.dispatch.$paramParser(argumentCollection=loc.args);
			$assert('loc.params.controller eq "Test"');
			$assert('loc.params.action eq "test"');
			$assert('loc.params.username eq "foo"');
			$assert('loc.params.format eq "bar"');
		</cfscript>
	</cffunction>
	
 	<cffunction name="test_route_with_format_only">
		<cfset addRoute(name="test", pattern="contact/export.[format]", controller="test", action="test")>
		<cfscript>
			loc.args = {};
			loc.args.pathinfo = "/contact/export.csv";
			loc.args.urlScope = {};
			loc.params = loc.dispatch.$paramParser(argumentCollection=loc.args);
			$assert('loc.params.controller eq "Test"');
			$assert('loc.params.action eq "test"');
			$assert('loc.params.format eq "csv"');
		</cfscript>
	</cffunction>

 	<cffunction name="test_route_without_format_should_ignore_fullstops">
		<cfset addRoute(name="test", pattern="users/[username]", controller="test", action="test")>
		<cfscript>
			loc.args = {};
			loc.args.pathinfo = "/users/foo.bar";
			loc.args.urlScope["username"] = "foo.bar";
			loc.params = loc.dispatch.$paramParser(argumentCollection=loc.args);
			$assert('loc.params.username eq "foo.bar"');
		</cfscript>
	</cffunction>
	
 	<cffunction name="test_route_with_format_and_format_not_specified">
		<cfset addRoute(name="test", pattern="users/[username].[format]", controller="test", action="test")>
		<cfscript>
			loc.args = {};
			loc.args.pathinfo = "/users/foo";
			loc.args.urlScope["username"] = "foo";
			loc.params = loc.dispatch.$paramParser(argumentCollection=loc.args);
			$assert('loc.params.controller eq "Test"');
			$assert('loc.params.action eq "test"');
			$assert('loc.params.username eq "foo"');
			$assert('loc.params.format eq ""');
		</cfscript>
	</cffunction>

</cfcomponent>