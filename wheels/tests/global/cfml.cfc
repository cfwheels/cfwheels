<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_$listClean_default_delim">
		<cfset loc.mylist = "tony,    per   ,  james    ,,, chris   , raul ,,,,  peter">
		<cfset loc.e = "tony,per,james,chris,raul,peter">
		<cfset loc.r = $listClean(loc.mylist)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_$listClean_provide_delim">
		<cfset loc.mylist = "tony|    per   |  james    | chris   | raul |||  peter">
		<cfset loc.e = "tony|per|james|chris|raul|peter">
		<cfset loc.r = $listClean(loc.mylist, "|")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_$listClean_return_array">
		<cfset loc.mylist = "tony,    per   ,  james    ,,, chris   , raul ,,,,  peter">
		<cfset loc.r = $listClean(list=loc.mylist, returnAs="array")>
		<cfset assert('IsArray(loc.r) and ArrayLen(loc.r) eq 6')>
	</cffunction>
	
	<cffunction name="test_$listClean_return_struct">
		<cfset loc.mylist = "tony,    per   ,  james    ,,, chris   , raul ,,,,  peter">
		<cfset loc.r = $listClean(list=loc.mylist, returnAs="struct", defaultValue="#StructNew()#")>
		<cfset assert('IsStruct(loc.r) and StructCount(loc.r) eq 6')>
		<cfloop collection="#loc.r#" item="loc.i">
			<cfset assert('IsStruct(loc.r[loc.i])')>
		</cfloop>
	</cffunction>
	
</cfcomponent>