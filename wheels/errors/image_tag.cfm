<!--- missing the source argument --->
<cfif arguments.source IS "">
	<cfset local.CFW_error = "A required argument is missing">
	<cfset local.CFW_suggestion = "Pass in the <tt>source</tt> argument.">
	<cfthrow type="wheels" extendedinfo="ImageTag" message="#local.CFW_error#" detail="#local.CFW_suggestion#">
</cfif>

<!--- file does not exist --->
<cfif left(arguments.source, 7) IS NOT "http://" AND NOT fileExists(expandPath("#application.wheels.web_path##application.settings.paths.images#/#arguments.source#"))>
	<cfset local.CFW_error = "<tt>#expandPath('#application.wheels.web_path##application.settings.paths.images#/#arguments.source#')#</tt> does not exist">
	<cfset local.CFW_suggestion = "Pass in a correct relative path from <tt>#expandPath('#application.wheels.web_path##application.settings.paths.images#\')#</tt> to an image in the <tt>source</tt> argument.">
	<cfthrow type="wheels" extendedinfo="ImageTag" message="#local.CFW_error#" detail="#local.CFW_suggestion#">
</cfif>

<!--- incorrect format --->
<cfif left(arguments.source, 7) IS NOT "http://" AND arguments.source Does Not Contain ".jpg" AND arguments.source Does Not Contain ".gif" AND arguments.source Does Not Contain ".png">
	<cfset local.CFW_error = "Image format not supported">
	<cfset local.CFW_suggestion = "Use a GIF, JPG or PNG image instead.">
	<cfthrow type="wheels" extendedinfo="ImageTag" message="#local.CFW_error#" detail="#local.CFW_suggestion#">
</cfif>