<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_nested_property_returns_object">
		<cfset gallery = model("Gallery").findOne(include="User")>
		<cfset props = gallery.properties()>
		<cfset assert('IsObject(props.user)')>
	</cffunction>

	<cffunction name="test_nested_property_returns_only_simple_values">
		<cfset gallery = model("Gallery").findOne(include="User")>
		<cfset props = gallery.properties(simpleValues=true)>
		<cfset assert('IsStruct(props.user)')>
		<cfset assert('! IsObject(props.user)')>
	</cffunction>

</cfcomponent>