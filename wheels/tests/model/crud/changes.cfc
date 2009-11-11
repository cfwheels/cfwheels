<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_hasChanged">
		<cfset loc.author = model("author").findOne(where="lastName = 'Djurner'")>
		<cfset loc.result = loc.author.hasChanged()>
		<cfset assert("loc.result IS false")>
		<cfset loc.author.lastName = "Petruzzi">
		<cfset loc.result = loc.author.hasChanged()>
		<cfset assert("loc.result IS true")>
		<cfset loc.author.lastName = "Djurner">
		<cfset loc.result = loc.author.hasChanged()>
		<cfset assert("loc.result IS false")>
	</cffunction>

	<cffunction name="test_XXXHasChanged">
		<cfset loc.author = model("author").findOne(where="lastName = 'Djurner'")>
		<cfset loc.author.lastName = "Petruzzi">
		<cfset loc.result = loc.author.lastNameHasChanged()>
		<cfset assert("loc.result IS true")>
		<cfset loc.result = loc.author.firstNameHasChanged()>
		<cfset assert("loc.result IS false")>
	</cffunction>

	<cffunction name="test_changedFrom">
		<cfset loc.author = model("author").findOne(where="lastName = 'Djurner'")>
		<cfset loc.author.lastName = "Petruzzi">
		<cfset loc.result = loc.author.changedFrom(property="lastName")>
		<cfset assert("loc.result IS 'Djurner'")>
	</cffunction>
 
	<cffunction name="test_XXXChangedFrom">
		<cfset loc.author = model("author").findOne(where="lastName = 'Djurner'")>
		<cfset loc.author.lastName = "Petruzzi">
		<cfset loc.result = loc.author.lastNameChangedFrom(property="lastName")>
		<cfset assert("loc.result IS 'Djurner'")>
	</cffunction>

</cfcomponent>