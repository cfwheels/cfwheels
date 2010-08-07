<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="ControllerWithNestedModel")>
	</cffunction>

	<cffunction name="test_$objectName_with_objectName">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author")>
		<cfset assert('loc.objectName eq "author"') />
	</cffunction>

	<cffunction name="test_$objectName_with_objectName_as_struct">
		<cfset loc.struct = { "formField" = "formValue" }>
		<cfset loc.objectName = loc.controller.$objectName(objectName=loc.struct)>
		<cfset assert('IsStruct(loc.objectName) eq true') />
	</cffunction>

	<cffunction name="test_$objectName_hasOne_association">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author", association="profile")>
		<cfset assert('loc.objectName eq "author[''profile'']"') />
	</cffunction>

	<cffunction name="test_$objectName_hasOne_associations_nested">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author", association="profile,address")>
		<cfset assert('loc.objectName eq "author[''profile''][''address'']"') />
	</cffunction>

	<cffunction name="test_$objectName_hasMany_association">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author", association="books", position="1")>
		<cfset assert('loc.objectName eq "author[''books''][1]"') />
	</cffunction>

	<cffunction name="test_$objectName_hasMany_associations_nested">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author", association="books,pages", position="1,25")>
		<cfset assert('loc.objectName eq "author[''books''][1][''pages''][25]"') />
	</cffunction>

	<cffunction name="test_$objectName_hasOne_and_hasMany_associations_nested">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author", association="profile,phoneNumbers", position="4")>
		<cfset assert('loc.objectName eq "author[''profile''][''phoneNumbers''][4]"') />
	</cffunction>

	<cffunction name="test_$objectName_raises_error_without_correct_positions">
		<cfset loc.e = raised('loc.controller.$objectName(objectName="author", association="books,pages", position="25")')>
		<cfset assert('loc.e eq "Wheels.InvalidArgument"') />
	</cffunction>

</cfcomponent>