<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.user = model("user")>
		<cfset loc.args = {username="myusername", password="mypassword", firstname="myfirstname", lastname="mylastname"}>
	</cffunction>

	<cffunction name="test_can_create_new_record_validation_execute">
		<cftransaction>
			<cfset loc.u = loc.user.new(loc.args)>
			<cfset loc.e = loc.u.isnew()>
			<cfset loc.r = loc.u.save()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.e eq true')>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_cannot_create_new_record_validation_execute">
		<cftransaction>
			<cfset loc.args.username = "1">
			<cfset loc.u = loc.user.new(loc.args)>
			<cfset loc.e = loc.u.isnew()>
			<cfset loc.r = loc.u.save()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.e eq true')>
		<cfset assert('loc.r eq false')>
	</cffunction>

	<cffunction name="test_can_create_new_record_validation_skipped">
		<cftransaction>
			<cfset loc.args.username = "1">
			<cfset loc.u = loc.user.new(loc.args)>
			<cfset loc.e = loc.u.isnew()>
			<cfset loc.r = loc.u.save(validate="false")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.e eq true')>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_can_update_existing_record_validation_execute">
		<cftransaction>
			<cfset loc.u = loc.user.findOne(where="lastname = 'Petruzzi'")>
			<cfset loc.p = loc.u.properties()>
			<cfset loc.r = loc.u.update(loc.args)>
			<cfset loc.e = loc.u.isnew()>
			<cfset loc.u.update(loc.p)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.e eq false')>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_cannot_update_existing_record_validation_execute">
		<cftransaction>
			<cfset loc.args.password = "1">
			<cfset loc.u = loc.user.findOne(where="lastname = 'Petruzzi'")>
			<cfset loc.p = loc.u.properties()>
			<cfset loc.r = loc.u.update(loc.args)>
			<cfset loc.e = loc.u.isnew()>
			<cfset loc.u.update(loc.p)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.e eq false')>
		<cfset assert('loc.r eq false')>
	</cffunction>

	<cffunction name="test_cant_update_existing_record_validation_skipped">
		<cftransaction>
			<cfset loc.args.password = "1">
			<cfset loc.u = loc.user.findOne(where="lastname = 'Petruzzi'")>
			<cfset loc.p = loc.u.properties()>
			<cfset loc.u.setProperties(loc.args)>
			<cfset loc.e = loc.u.isnew()>
			<cfset loc.r = loc.u.save(validate="false")>
			<cfset loc.u.update(loc.p)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.e eq false')>
		<cfset assert('loc.r eq true')>
	</cffunction>

</cfcomponent>