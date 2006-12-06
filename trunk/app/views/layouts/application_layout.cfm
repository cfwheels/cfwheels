<!---	Include any HTML code you want displayed on every page in your application 
		(if a controller-specific layout isn't available) --->
<cfif isDefined("request.flash.alert") AND request.flash.alert IS NOT "">
	<p style="font-weight:bold;color:red;"><cfoutput>#request.flash.alert#</cfoutput></p>
<cfelseif isDefined("request.flash.notice") AND request.flash.notice IS NOT "">
	<p style="font-weight:bold;color:green;"><cfoutput>#request.flash.notice#</cfoutput></p>
</cfif>
<cfset contentForLayout()>
<cfif request.params.action IS NOT "listAuthors">
	<p><cfoutput>#linkTo(name="List Authors", action="listAuthors")#</cfoutput></p>
</cfif>