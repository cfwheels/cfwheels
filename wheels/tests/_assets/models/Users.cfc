<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset hasMany(name="photogalleries", class="photogalleries", foreignKey="userid")>
		<cfset validatesPresenceOf("username,password,firstname,lastname")>
		<cfset validatesUniquenessOf("username")>
		<cfset validatesLengthOf(property="username", minimum="8", when="onCreate")>
		<cfset validatesLengthOf(property="password", minimum="8", when="onUpdate")>
	</cffunction>

</cfcomponent>