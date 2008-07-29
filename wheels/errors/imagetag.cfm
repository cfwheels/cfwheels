<!--- missing the source argument --->
<cfif arguments.source IS "">
	<cfset loc.$error = "A required argument is missing">
	<cfset loc.$suggestion = "Pass in the <tt>source</tt> argument.">
	<cfthrow type="Wheels" message="#loc.$error#" extendedInfo="#loc.$suggestion#">
</cfif>

<!--- file does not exist --->
<cfif Left(arguments.source, 7) IS NOT "http://" AND NOT fileExists(expandPath("#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#"))>
	<cfset loc.$error = "<tt>#expandPath('#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#')#</tt> does not exist">
	<cfset loc.$suggestion = "Pass in a correct relative path from <tt>#expandPath('#application.wheels.webPath##application.wheels.imagePath#\')#</tt> to an image in the <tt>source</tt> argument.">
	<cfthrow type="Wheels" message="#loc.$error#" extendedInfo="#loc.$suggestion#">
</cfif>

<!--- incorrect format --->
<cfif Left(arguments.source, 7) IS NOT "http://" AND arguments.source Does Not Contain ".jpg" AND arguments.source Does Not Contain ".gif" AND arguments.source Does Not Contain ".png">
	<cfset loc.$error = "Image format not supported">
	<cfset loc.$suggestion = "Use a GIF, JPG or PNG image instead.">
	<cfthrow type="Wheels" message="#loc.$error#" extendedInfo="#loc.$suggestion#">
</cfif>