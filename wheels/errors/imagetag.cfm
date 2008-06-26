<!--- missing the source argument --->
<cfif arguments.source IS "">
	<cfset locals._error = "A required argument is missing">
	<cfset locals._suggestion = "Pass in the <tt>source</tt> argument.">
	<cfthrow type="wheels" extendedinfo="ImageTag" message="#locals._error#" detail="#locals._suggestion#">
</cfif>

<!--- file does not exist --->
<cfif left(arguments.source, 7) IS NOT "http://" AND NOT fileExists(expandPath("#application.wheels.webPath##application.settings.paths.images#/#arguments.source#"))>
	<cfset locals._error = "<tt>#expandPath('#application.wheels.webPath##application.settings.paths.images#/#arguments.source#')#</tt> does not exist">
	<cfset locals._suggestion = "Pass in a correct relative path from <tt>#expandPath('#application.wheels.webPath##application.settings.paths.images#\')#</tt> to an image in the <tt>source</tt> argument.">
	<cfthrow type="wheels" extendedinfo="ImageTag" message="#locals._error#" detail="#locals._suggestion#">
</cfif>

<!--- incorrect format --->
<cfif left(arguments.source, 7) IS NOT "http://" AND arguments.source Does Not Contain ".jpg" AND arguments.source Does Not Contain ".gif" AND arguments.source Does Not Contain ".png">
	<cfset locals._error = "Image format not supported">
	<cfset locals._suggestion = "Use a GIF, JPG or PNG image instead.">
	<cfthrow type="wheels" extendedinfo="ImageTag" message="#locals._error#" detail="#locals._suggestion#">
</cfif>