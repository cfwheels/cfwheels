<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="ControllerWithModel")>
		<cfset loc.user = model("user")>
	</cffunction>

	<cffunction name="test_x_select_valid">
		<cfset loc.users = loc.user.findAll(returnAs="array")>
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.users, valueField="id", textField="firstName")>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="#loc.users[1].id#">Tony</option><option value="#loc.users[2].id#">Chris</option><option value="#loc.users[3].id#">Per</option><option value="#loc.users[4].id#">Raul</option><option value="#loc.users[5].id#">Joe</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>