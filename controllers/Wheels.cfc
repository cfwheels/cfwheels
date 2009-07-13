<!---
	This is a controller file that Wheels uses internally.
	Do not delete this file.
--->
<cfcomponent extends="Controller">

	<cffunction name="plugins">
		<cfif get("environment") IS "production">
			<cfset renderNothing()>
		</cfif>
	</cffunction>

</cfcomponent>