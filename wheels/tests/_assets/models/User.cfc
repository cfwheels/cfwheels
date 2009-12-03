<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset hasMany(name="photogalleries")>
		<cfset hasMany(name="outerjoinphotogalleries", modelName="photogallery", jointype="outer")>
		<cfset validatesPresenceOf("username,password,firstname,lastname")>
		<cfset validatesUniquenessOf("username")>
		<cfset validatesLengthOf(property="username", minimum="4", when="onCreate")>
		<cfset validatesLengthOf(property="password", minimum="4", when="onUpdate")>
	</cffunction>

</cfcomponent>