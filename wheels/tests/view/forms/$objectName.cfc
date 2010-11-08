<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithNestedModel")>
	</cffunction>

	<cffunction name="test_$objectName_with_objectName">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author")>
		<cfset assert('loc.objectName eq "author"') />
	</cffunction>

	<cffunction name="test_$objectName_with_objectName_as_struct">
		<cfset loc.struct = { formField = "formValue" }>
		<cfset loc.objectName = loc.controller.$objectName(objectName=loc.struct)>
		<cfset assert('IsStruct(loc.objectName) eq true') />
	</cffunction>

	<cffunction name="test_$objectName_hasOne_association">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author", association="profile")>
		<cfset assert('loc.objectName eq "author[''profile'']"') />
	</cffunction>

	<cffunction name="test_$objectName_hasMany_association">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author", association="posts", position="1")>
		<cfset assert('loc.objectName eq "author[''posts''][1]"') />
	</cffunction>

	<cffunction name="test_$objectName_hasMany_associations_nested">
		<cfset loc.objectName = loc.controller.$objectName(objectName="author", association="posts,comments", position="1,2")>
		<cfset assert('loc.objectName eq "author[''posts''][1][''comments''][2]"') />
	</cffunction>

	<cffunction name="test_$objectName_raises_error_without_correct_positions">
		<cfset loc.e = raised('loc.controller.$objectName(objectName="author", association="posts,comments", position="1")')>
		<cfset assert('loc.e eq "Wheels.InvalidArgument"') />
	</cffunction>

</cfcomponent>