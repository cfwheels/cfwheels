<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>
	<cfset loadModels("users")>

	<cffunction name="test_x_select_valid">
		<cfset loc.users = loc.user.findAll(returnAs="array")>
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.users, valueField="id", textField="firstName")>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="130">Tony</option><option value="131">Chris</option><option value="132">Per</option><option value="133">Raul</option><option value="134">Joe</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>