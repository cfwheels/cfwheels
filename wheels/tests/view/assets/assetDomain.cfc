<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="_setup">
		<cfscript>
			application.wheels.assetPaths = {http="asset0.localhost, asset2.localhost", https="secure.localhost"};
		</cfscript>
	</cffunction>

	<cffunction name="_teardown">
		<cfscript>
			application.wheels.assetPaths = false;
		</cfscript>
	</cffunction>
	
	<cffunction name="test_returns_protocol">
		<cfscript>
			loc.assetPath = "/javascripts/path/to/my/asset.js";
			loc.e = loc.controller.$assetDomain(loc.assetPath);
			assert('FindNoCase("http://", loc.e)');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_returns_secure_protocol">
		<cfscript>
			request.cgi.server_port_secure = true;
			loc.assetPath = "/javascripts/path/to/my/asset.js";
			loc.e = loc.controller.$assetDomain(loc.assetPath);
			assert('FindNoCase("https://", loc.e)');
			request.cgi.server_port_secure = "";
		</cfscript>
	</cffunction>
	
	<cffunction name="test_returns_same_domain_for_asset">
		<cfscript>
			loc.assetPath = "/javascripts/path/to/my/asset.js";
			loc.e = loc.controller.$assetDomain(loc.assetPath);

			loc.iEnd = 100;
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				assert('loc.e eq loc.controller.$assetDomain(loc.assetPath)');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_returns_asset_path_when_set_false">
		<cfscript>
			application.wheels.assetPaths = false;
			loc.assetPath = "/javascripts/path/to/my/asset.js";
			loc.e = loc.controller.$assetDomain(loc.assetPath);
			assert('loc.e eq loc.assetPath');
			application.wheels.assetPaths = {http="asset0.localhost, asset2.localhost", https="secure.localhost"};
		</cfscript>
	</cffunction>
	

</cfcomponent>