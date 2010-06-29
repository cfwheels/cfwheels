<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset layout(template="class_layout", except="action1,action2")>
	</cffunction>
	
	<cffunction name="action1">
	</cffunction>
	
	<cffunction name="action2">
	</cffunction>
	
	<cffunction name="index">
	</cffunction>	

</cfcomponent>