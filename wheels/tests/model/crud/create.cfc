<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset results = {}>
	</cffunction>

	<cffunction name="test_auto_incrementing_primary_key_should_be_set">
		<cftransaction>
			<cfset results.author = model("author").create(firstName="Test", lastName="Test")>
			<cfset $assert("IsObject(results.author) AND StructKeyExists(results.author, results.author.primaryKey()) AND IsNumeric(results.author[results.author.primaryKey()])")>
			<cftransaction action="rollback">
		</cftransaction>
	</cffunction>

	<cffunction name="test_non_auto_incrementing_primary_key_should_not_be_changed">
		<cftransaction>
			<cfset results.shop = model("shop").create(ShopId=99, CityCode=99, Name="Test")>
			<cfset $assert("IsObject(results.shop) AND StructKeyExists(results.shop, results.shop.primaryKey()) AND results.shop[results.shop.primaryKey()] IS 99")>
			<cftransaction action="rollback">
		</cftransaction>
	</cffunction>

	<cffunction name="test_composite_key_values_should_be_set_when_they_both_exist">
		<cftransaction>
			<cfset results.city = model("city").create(citycode=99, id="z", name="test")>
			<cfset $assert("results.city.citycode IS 99 AND results.city.id IS 'z'")>
			<cftransaction action="rollback">
		</cftransaction>
	</cffunction>
	
   	<cffunction name="test_columns_that_are_not_null_should_allow_for_blank_string_during_create">
		<cfif NOT StructKeyExists(server, "bluedragon")>
			<cfdbinfo name="loc.dbinfo" datasource="#application.wheels.dataSourceName#" type="version">
			<cfset loc.db = LCase(Replace(loc.dbinfo.database_productname, " ", "", "all"))>
			<cfif loc.db IS "oracle">
				<!--- oracle treates empty strings as null --->
				<cfset loc.author = model("author").create(firstName="Test", lastName=" ", transaction="rollback")>
				<cfset $assert("IsObject(loc.author) AND !len(trim(loc.author.lastName))")>
			<cfelse>
				<cfset loc.author = model("author").create(firstName="Test", lastName="", transaction="rollback")>
				<cfset $assert("IsObject(loc.author) AND !len(loc.author.lastName)")>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="test_saving_a_new_model_without_properties_should_not_throw_errors">
		<cfif NOT StructKeyExists(server, "bluedragon")>
			<cftransaction action="begin">
				<cfset loc.model = model("tag").new()>
				<cfset loc.str = raised('loc.model.save(reload=true)')>
				<cfset $assert('loc.str eq ""')>
				<cftransaction action="rollback"/>
			</cftransaction>
		</cfif>
	</cffunction>

</cfcomponent>