<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.user = model("user")>
	</cffunction>

	<cffunction name="test_select_distinct_addresses">
		<cfset loc.q = loc.user.findAll(select="address", distinct="true", order="address")>
		<cfset assert('loc.q.recordcount eq 4')>
		<cfset loc.e = "123 Petruzzi St.|456 Peters Dr.|789 Djurner Ave.|987 Riera Blvd.">
		<cfset loc.r = valuelist(loc.q.address, "|")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_select_users_groupby_address">
		<cfset loc.q = loc.user.findAll(select="address", group="address", order="address", result="loc.result")>
		<cfset assert('loc.q.recordcount eq 4')>
		<cfset loc.e = "123 Petruzzi St.|456 Peters Dr.|789 Djurner Ave.|987 Riera Blvd.">
		<cfset loc.r = valuelist(loc.q.address, "|")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

 	<cffunction name="test_findByKey">
		<cfset loc.e = loc.user.findOne(where="lastname = 'petruzzi'")>
		<cfset loc.q = loc.user.findByKey(loc.e.id)>
		<cfset assert('loc.q.id eq loc.e.id')>
	</cffunction>

 	<cffunction name="test_findByKey_returns_false_when_record_not_found">
		<cfset loc.q = loc.user.findByKey(999999999)>
		<cfset assert('loc.q eq false')>
	</cffunction>

 	<cffunction name="test_findByKey_returns_false_when_passed_blank_string">
		<cfset loc.q = loc.user.findByKey("")>
		<cfset assert('loc.q eq false')>
	</cffunction>

 	<cffunction name="test_findByKey_returns_empty_query_when_record_not_found_with_return_as_equal_query">
		<cfset loc.q = loc.user.findByKey(key=999999999, returnAs="query")>
		<cfset assert('loc.q.RecordCount eq false')>
	</cffunction>

 	<cffunction name="test_findOne">
		<cfset loc.e = loc.user.findOne(where="lastname = 'petruzzi'")>
		<cfset assert('isobject(loc.e)')>
	</cffunction>

 	<cffunction name="test_findOne_returns_false_when_record_not_found">
		<cfset loc.e = loc.user.findOne(where="lastname = 'somenamenotfound'")>
		<cfset assert('loc.e eq false')>
	</cffunction>

 	<cffunction name="test_findOne_returns_empty_query_when_record_not_found_with_return_as_equal_query">
		<cfset loc.e = loc.user.findOne(where="lastname = 'somenamenotfound'", returnAs="query")>
		<cfset assert('loc.e.RecordCount eq false')>
	</cffunction>

	<cffunction name="test_findOne_returns_false_when_record_not_found_with_inner_join_include">
		<cfset loc.e = loc.user.findOne(where="lastname= = 'somenamenotfound'", include="photogalleries") />
		<cfset assert('loc.e eq false')>
	</cffunction>

	<cffunction name="test_findOne_returns_false_when_record_not_found_with_outer_join_include">
		<cfset loc.e = loc.user.findOne(where="lastname= = 'somenamenotfound'", include="outerjoinphotogalleries") />
		<cfset assert('loc.e eq false')>
	</cffunction>

 	<cffunction name="test_findAll">
		<cfset loc.q = loc.user.findAll(order="id")>
		<cfset assert('loc.q.recordcount eq 5')>
		<cfset loc.q = loc.user.findAll(where="lastname = 'petruzzi' OR lastname = 'peters'", order="lastname")>
		<cfset assert('loc.q.recordcount eq 2')>
		<cfset assert('valuelist(loc.q.lastname) eq "peters,petruzzi"')>
	</cffunction>

	<cffunction name="test_findAllByXXX">
		<cfset loc.q = loc.user.findAllByZipcode(value="22222", order="id")>
		<cfset assert('loc.q.recordcount eq 2')>
		<cfset loc.q = loc.user.findAllByZipcode(value="11111", order="id")>
		<cfset assert('loc.q.recordcount eq 1')>
	</cffunction>

	<cffunction name="test_findByKey_norecords_returns_correct_type">
		<cfset loc.q = loc.user.findByKey("0")>
		<cfset debug('loc.q', false)>
		<cfset assert('isboolean(loc.q) and loc.q eq false')>

		<cfset loc.q = loc.user.findByKey(key="0", returnas="query")>
		<cfset debug('loc.q', false)>
		<cfset assert('isquery(loc.q) and loc.q.recordcount eq 0')>

		<cfset loc.q = loc.user.findByKey(key="0", returnas="object")>
		<cfset debug('loc.q', false)>
		<cfset assert('isboolean(loc.q) and loc.q eq false')>

		<!--- readd when we have implemented the code to throw an error when an incorrect returnAs value is passed in
		<cfset loc.q = raised('loc.user.findByKey(key="0", returnas="objects")')>
		<cfset loc.r = "Wheels.IncorrectArgumentValue">
		<cfset debug('loc.q', false)>
		<cfset assert('loc.q eq loc.r')> --->
	</cffunction>

	<cffunction name="test_findOne_norecords_returns_correct_type">
		<cfset loc.q = loc.user.findOne(where="id = 0")>
		<cfset debug('loc.q', false)>
		<cfset assert('isboolean(loc.q) and loc.q eq false')>

		<cfset loc.q = loc.user.findOne(where="id = 0", returnas="query")>
		<cfset debug('loc.q', false)>
		<cfset assert('isquery(loc.q) and loc.q.recordcount eq 0')>

		<cfset loc.q = loc.user.findOne(where="id = 0", returnas="object")>
		<cfset debug('loc.q', false)>
		<cfset assert('isboolean(loc.q) and loc.q eq false')>

		<!--- readd when we have implemented the code to throw an error when an incorrect returnAs value is passed in
		<cfset loc.q = raised('loc.user.findOne(where="id = 0", returnas="objects")')>
		<cfset loc.r = "Wheels.IncorrectArgumentValue">
		<cfset debug('loc.q', false)>
		<cfset assert('loc.q eq loc.r')> --->
	</cffunction>
	
	<cffunction name="test_findAll_returnAs_query_noRecords_returns_correct_type">
		<cfset loc.q = loc.user.findAll(where="id = 0", returnas="query", order="id")>
		<cfset debug('loc.q', false)>
		<cfset assert('isquery(loc.q) and loc.q.recordcount eq 0')>
	</cffunction>
	
	<cffunction name="test_findAll_returnAs_structs_noRecords_returns_correct_type">
		<cfset loc.q = loc.user.findAll(where="id = 0", returnAs="structs", order="id")>
		<cfset debug('loc.q', false)>
		<cfset assert('isarray(loc.q) and arrayisempty(loc.q)')>
	</cffunction>
	
	<cffunction name="test_findAll_returnAs_objects_noRecords_returns_correct_type">
		<cfset loc.q = loc.user.findAll(where="id = 0", returnas="objects", order="id")>
		<cfset debug('loc.q', false)>
		<cfset assert('isarray(loc.q) and arrayisempty(loc.q)')>
	</cffunction>

	<cffunction name="test_findAll_returnAs_invalid_throws_error">
		<cfset loc.q = raised('loc.user.findAll(where="id = 1", returnas="notvalid", order="id")')>
		<cfset loc.r = "Wheels.IncorrectArgumentValue">
		<cfset debug('loc.q', false)>
		<cfset assert('loc.q eq loc.r')>
	</cffunction>

	<cffunction name="test_exists_by_key_valid">
		<cfset loc.e = loc.user.findOne(where="lastname = 'petruzzi'")>
		<cfset loc.r = loc.user.exists(loc.e.id)>
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

	<cffunction name="test_allow_negative_values_in_where_clause">
		<cfset loc.r = loc.user.exists(where="id = -1")>
		<cfset assert('loc.r eq false')>
	</cffunction>

	<cffunction name="test_findByKey_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset loc.post1 = model("Post").findOne(order="id")>
			<cfset loc.post1.delete(transaction="none")>
			<cfset loc.post2 = model("Post").findByKey(key=loc.post1.id, includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsObject(loc.post2) is true')>
	</cffunction>

	<cffunction name="test_findOne_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset loc.post1 = model("Post").findOne(order="id")>
			<cfset loc.post1.delete(transaction="none")>
			<cfset loc.post2 = model("Post").findOne(where="id=#loc.post1.id#", includeSoftDeletes=true, order="id")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsObject(loc.post2) is true')>
	</cffunction>

	<cffunction name="test_findAll_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset model("Post").deleteAll()>
			<cfset loc.allPosts = model("Post").findAll(includeSoftDeletes=true, order="id")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allPosts.recordcount eq 4')>
	</cffunction>

	<cffunction name="test_findOne_returns_empty_array_for_included_model_when_none_exist">
		<cfset loc.e = model("author").findOne(where="lastname = 'Bellenie'", include="posts")>
		<cfset assert('IsArray(loc.e.posts) && ArrayIsEmpty(loc.e.posts)')>
	</cffunction>

</cfcomponent>