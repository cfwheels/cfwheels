<cfcomponent extends="wheelsMapping.test">

	<cfset global.ParamsParser = createobject("component", "wheelsMapping.ParamsParser").init()>
	<cfset global.args = {}>
	<cfset global.args.path = "home">
	<cfset global.args.route = {pattern="", controller="wheels", action="wheels"}>
	<cfset global.args.formScope = {}>
	<cfset global.args.urlScope = {}>
	
 	<cffunction name="test_multiple_objects_with_checkbox">
		<cfset StructInsert(loc.args.urlScope, "user[1][isActive]($checkbox)", "0", true)>
		<cfset StructInsert(loc.args.urlScope, "user[1][isActive]", "1", true)>
		<cfset StructInsert(loc.args.urlScope, "user[2][isActive]($checkbox)", "0", true)>
		<cfset loc.params = loc.ParamsParser.create(argumentCollection=loc.args)>
		<cfset assert('loc.params.user["1"].isActive eq 1') />
		<cfset assert('loc.params.user["2"].isActive eq 0') />
	</cffunction>

	<cffunction name="test_multiple_objects_in_objects">
		<cfscript>
			loc.args.formScope["user"]["1"]["config"]["1"]["isValid"] = true;
			loc.args.formScope["user"]["1"]["config"]["2"]["isValid"] = false;
			loc.args.formScope["user"]["2"]["config"]["1"]["isValid"] = true;
			loc.args.formScope["user"]["2"]["config"]["2"]["isValid"] = false;
			loc.args.formScope["user"]["2"]["firstname"] = "tony";
			loc.args.formScope["user"]["2"]["lastname"] = "petruzzi";
			loc.params = loc.ParamsParser.create(argumentCollection=loc.args);
			assert('IsStruct(loc.params.user) eq true');
			assert('IsStruct(loc.params.user[1]) eq true');
			assert('IsStruct(loc.params.user[1].config) eq true');
			assert('IsStruct(loc.params.user[1].config[1]) eq true');
			assert('IsStruct(loc.params.user[1].config[2]) eq true');
			assert('IsBoolean(loc.params.user[1].config[1].isValid) eq true');
			assert('IsBoolean(loc.params.user[1].config[2].isValid) eq true');
			assert('loc.params.user[1].config[1].isValid eq true');
			assert('loc.params.user[1].config[2].isValid eq false');
		</cfscript>
	</cffunction>

</cfcomponent>