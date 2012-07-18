<cfcomponent extends="wheelsMapping.Test" output="false">

	<cffunction name="test_loading_locales">
		<cfset loc.locales = $loadLocales()>
		<cfset assert('StructKeyExists(loc.locales, "en-US")')>
		<cfset assert('StructKeyExists(loc.locales["en-US"], "date")')>
		<cfset assert('StructKeyExists(loc.locales["en-US"]["date"], "month_names")')>
	</cffunction>

	<cffunction name="test_retrieve_locale_specific_key">
		<cfset application.wheels.locales = $loadLocales()>
		<cfset loc.value = l('date.month_names', "en-US")>
		<cfset assert('loc.value eq "January,February,March,April,May,June,July,August,September,October,November,December"')>
	</cffunction>

</cfcomponent>