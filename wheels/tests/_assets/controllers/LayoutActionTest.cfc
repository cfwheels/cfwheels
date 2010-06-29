<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset layout(template="class_layout")>
	</cffunction>
	
	<cffunction name="index">
		<cfset layout("instance_layout")>	
	</cffunction>	

</cfcomponent>