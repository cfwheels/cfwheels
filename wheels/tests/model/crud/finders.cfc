<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsmapping/tests/_assets/testhelpers/single_model.cfm">

	<cffunction name="test_select_distinct_addresses">
		<cfset loc.q = loc.user.findAll(select="address", distinct="true", order="address")>
		<cfset assert('loc.q.recordcount eq 4')>
		<cfset loc.e = "123 Petruzzi St.|456 Peters Dr.|789 Djurner Ave.|987 Riera Blvd.">
		<cfset loc.r = valuelist(loc.q.address, "|")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
<!---
	TODO: uncomment once james' patch for group by is integrated
	<cffunction name="test_select_users_groupby_address">
		<cfset loc.q = loc.user.findAll(select="address", group="address", order="address", result="loc.result")>
		<cfset assert('loc.q.recordcount eq 4')>
		<cfset loc.e = "123 Petruzzi St.|456 Peters Dr.|789 Djurner Ave.|987 Riera Blvd.">
		<cfset loc.r = valuelist(loc.q.address, "|")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
 --->

 	<cffunction name="test_findByKey">
		<cfset loc.q = loc.user.findByKey(1)>
		<cfset assert('loc.q.id eq 1')>
	</cffunction>

 	<cffunction name="test_findOne">
		<cfset loc.q = loc.user.findOne(order="id DESC")>
		<cfset assert('loc.q.id eq 5')>
	</cffunction>

 	<cffunction name="test_findAll">
		<cfset loc.q = loc.user.findAll()>
		<cfset assert('loc.q.recordcount eq 5')>
		<cfset loc.q = loc.user.findAll(where="lastname = 'petruzzi' OR lastname = 'peters'", order="lastname")>
		<cfset assert('loc.q.recordcount eq 2')>
		<cfset assert('valuelist(loc.q.lastname) eq "peters,petruzzi"')>
	</cffunction>

	<cffunction name="test_findOneByXXX">
		<cfset loc.q = loc.user.findOneByFirstname('per')>
		<cfset assert('loc.q.id eq 3')>
		<cfset loc.q = loc.user.findOneByZipcode(value="22222", order="id")>
		<cfset assert('loc.q.id eq 2')>
	</cffunction>

	<cffunction name="test_findAllByXXX">
		<cfset loc.q = loc.user.findAllByZipcode(value="22222", order="id")>
		<cfset assert('valuelist(loc.q.id) eq "2,5"')>
		<cfset loc.q = loc.user.findAllByZipcode(value="11111", order="id")>
		<cfset assert('valuelist(loc.q.id) eq "1"')>
	</cffunction>

	<cffunction name="test_findByKey_norecords_returns_correct_type">
		<cfset loc.q = loc.user.findByKey("0")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isboolean(loc.q) and loc.q eq false')>

		<cfset loc.q = loc.user.findByKey(key="0", returnas="query")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isquery(loc.q) and loc.q.recordcount eq 0')>

		<cfset loc.q = loc.user.findByKey(key="0", returnas="object")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isboolean(loc.q) and loc.q eq false')>

		<!--- readd when we have implemented the code to throw an error when an incorrect returnAs value is passed in
		<cfset loc.q = raised('loc.user.findByKey(key="0", returnas="objects")')>
		<cfset loc.r = "Wheels.IncorrectArgumentValue">
		<cfset halt(false, 'loc.q')>
		<cfset assert('loc.q eq loc.r')> --->
	</cffunction>

	<cffunction name="test_findOne_norecords_returns_correct_type">
		<cfset loc.q = loc.user.findOne(where="id = 0")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isboolean(loc.q) and loc.q eq false')>

		<cfset loc.q = loc.user.findOne(where="id = 0", returnas="query")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isquery(loc.q) and loc.q.recordcount eq 0')>

		<cfset loc.q = loc.user.findOne(where="id = 0", returnas="object")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isboolean(loc.q) and loc.q eq false')>

		<!--- readd when we have implemented the code to throw an error when an incorrect returnAs value is passed in
		<cfset loc.q = raised('loc.user.findOne(where="id = 0", returnas="objects")')>
		<cfset loc.r = "Wheels.IncorrectArgumentValue">
		<cfset halt(false, 'loc.q')>
		<cfset assert('loc.q eq loc.r')> --->
	</cffunction>

	<cffunction name="test_findAll_norecords_returns_correct_type">
		<cfset loc.q = loc.user.findAll(where="id = 0")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isquery(loc.q) and loc.q.recordcount eq 0')>

		<cfset loc.q = loc.user.findAll(where="id = 0", returnas="query")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isquery(loc.q) and loc.q.recordcount eq 0')>

		<!--- readd when we have implemented the code to throw an error when an incorrect returnAs value is passed in
		<cfset loc.q = raised('loc.user.findAll(where="id = 0", returnas="object")')>
		<cfset loc.r = "Wheels.IncorrectArgumentValue">
		<cfset halt(false, 'loc.q')>
		<cfset assert('loc.q eq loc.r')> --->

		<cfset loc.q = loc.user.findAll(where="id = 0", returnas="objects")>
		<cfset halt(false, 'loc.q')>
		<cfset assert('isarray(loc.q) and arrayisempty(loc.q)')>
	</cffunction>

	<cffunction name="test_exists_by_key_valid">
		<cfset loc.r = loc.user.exists(3)>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_exists_by_key_invalid">
		<cfset loc.r = loc.user.exists(0)>
		<cfset assert('loc.r eq false')>
	</cffunction>

	<cffunction name="test_exists_by_where_one_record_valid">
		<cfset loc.r = loc.user.exists(where="lastname = 'petruzzi'")>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_exists_by_where_one_record_invalid">
		<cfset loc.r = loc.user.exists(where="lastname = 'someoneelse'")>
		<cfset assert('loc.r eq false')>
	</cffunction>

	<cffunction name="test_exists_by_where_two_records_valid">
		<cfset loc.r = loc.user.exists(where="zipcode = '22222'")>
		<cfset assert('loc.r eq true')>
	</cffunction>

</cfcomponent>