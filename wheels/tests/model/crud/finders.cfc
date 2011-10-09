<cfcomponent extends="wheelsMapping.Test">

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
		<cfset loc.e = loc.user.findOne(where="lastname = 'Petruzzi'")>
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
		<cfset loc.e = loc.user.findOne(where="lastname = 'Petruzzi'")>
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
		<cfset loc.e = loc.user.findOne(where="lastname= = 'somenamenotfound'", include="galleries") />
		<cfset assert('loc.e eq false')>
	</cffunction>

	<cffunction name="test_findOne_returns_false_when_record_not_found_with_outer_join_include">
		<cfset loc.e = loc.user.findOne(where="lastname= = 'somenamenotfound'", include="outerjoinphotogalleries") />
		<cfset assert('loc.e eq false')>
	</cffunction>

 	<cffunction name="test_findAll">
		<cfset loc.q = loc.user.findAll()>
		<cfset assert('loc.q.recordcount eq 5')>
		<cfset loc.q = loc.user.findAll(where="lastname = 'Petruzzi' OR lastname = 'Peters'", order="lastname")>
		<cfset assert('loc.q.recordcount eq 2')>
		<cfset assert('valuelist(loc.q.lastname) eq "peters,Petruzzi"')>
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
		<cfset loc.q = loc.user.findAll(where="id = 0", returnas="query")>
		<cfset debug('loc.q', false)>
		<cfset assert('isquery(loc.q) and loc.q.recordcount eq 0')>
	</cffunction>

	<cffunction name="test_findAll_returnAs_structs_noRecords_returns_correct_type">
		<cfset loc.q = loc.user.findAll(where="id = 0", returnAs="structs")>
		<cfset debug('loc.q', false)>
		<cfset assert('isarray(loc.q) and arrayisempty(loc.q)')>
	</cffunction>

	<cffunction name="test_findAll_returnAs_objects_noRecords_returns_correct_type">
		<cfset loc.q = loc.user.findAll(where="id = 0", returnas="objects")>
		<cfset debug('loc.q', false)>
		<cfset assert('isarray(loc.q) and arrayisempty(loc.q)')>
	</cffunction>

	<cffunction name="test_findAll_returnAs_invalid_throws_error">
		<cfset loc.q = raised('loc.user.findAll(where="id = 1", returnas="notvalid")')>
		<cfset loc.r = "Wheels.IncorrectArgumentValue">
		<cfset debug('loc.q', false)>
		<cfset assert('loc.q eq loc.r')>
	</cffunction>

	<cffunction name="test_exists_by_key_valid">
		<cfset loc.e = loc.user.findOne(where="lastname = 'Petruzzi'")>
		<cfset loc.r = loc.user.exists(loc.e.id)>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_exists_by_key_invalid">
		<cfset loc.r = loc.user.exists(0)>
		<cfset assert('loc.r eq false')>
	</cffunction>

	<cffunction name="test_exists_by_where_one_record_valid">
		<cfset loc.r = loc.user.exists(where="lastname = 'Petruzzi'")>
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
			<cfset loc.post1 = model("Post").findOne()>
			<cfset loc.post1.delete(transaction="none")>
			<cfset loc.post2 = model("Post").findByKey(key=loc.post1.id, includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsObject(loc.post2) is true')>
	</cffunction>

	<cffunction name="test_findOne_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset loc.post1 = model("Post").findOne()>
			<cfset loc.post1.delete(transaction="none")>
			<cfset loc.post2 = model("Post").findOne(where="id=#loc.post1.id#", includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsObject(loc.post2) is true')>
	</cffunction>

	<cffunction name="test_findAll_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset model("Post").deleteAll()>
			<cfset loc.allPosts = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allPosts.recordcount eq 5')>
	</cffunction>

	<cffunction name="test_findOne_returns_empty_array_for_included_model_when_none_exist">
		<cfset loc.e = model("author").findOne(where="lastname = 'Bellenie'", include="posts")>
		<cfset assert('IsArray(loc.e.posts) && ArrayIsEmpty(loc.e.posts)')>
	</cffunction>
	
	<cffunction name="test_findAll_with_softdeleted_associated_rows">
		<cftransaction action="begin">
			<cfset model("Post").deleteAll()>
			<cfset loc.posts = model("Author").findByKey(key=1, include="Posts", returnAs="query")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.posts.recordcount eq 1')>
	</cffunction>

	<cffunction name="test_findFirst">
		<cfset loc.p = model("post").findOne(order="id ASC")>
		<cfset loc.post = model("post").findFirst()>
		<cfset assert('loc.post.id eq loc.p.id')>
	</cffunction>
	
	<cffunction name="test_findLast">
		<cfset loc.p = model("post").findOne(order="id DESC")>
		<cfset loc.post = model("post").findLast()>
		<cfset assert('loc.post.id eq loc.p.id')>
	</cffunction>
	
	<cffunction name="test_findOneOrCreateBy">
		<cftransaction>
			<cfset loc.author = model("author").findOneOrCreateByLastName(lastname="humphreys", firstname="don")>
			<cfset assert('IsObject(loc.author)')>
			<cfset assert('loc.author.lastname eq "humphreys"')>
			<cfset assert('loc.author.firstname eq "don"')>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>
	
	<cffunction name="test_findAllKeys">
		<cfset loc.p = model("post").findAll(select="id")>
		<cfset loc.posts = model("post").findAllKeys()>
		<cfset loc.keys = ValueList(loc.p.id)>
		<cfset assert('loc.posts eq loc.keys')>
		<cfset loc.p = model("post").findAll(select="id")>
		<cfset loc.posts = model("post").findAllKeys(quoted=true)>
		<cfset loc.keys = QuotedValueList(loc.p.id)>
	</cffunction>

	<cffunction name="test_findAll_returnAs_structs_with_explicit_select_returns_incorrect_number_of_records">
		<cfset loc.records = model("comment").findAll(where="postid = 1", select="comments.id AS cid, posts.id AS pid", include="post")>
		<cfset loc.structs = model("comment").findAll(where="postid = 1", select="comments.id AS cid, posts.id AS pid", include="post", returnAs="structs")>
		<cfset assert("ArrayLen(loc.structs) eq loc.records.RecordCount")>
		<cfloop from="1" to="#loc.records.RecordCount#" index="loc.i">
			<cfset assert('loc.structs[loc.i]["cid"] eq loc.records["cid"][loc.i]')>
			<cfset assert('loc.structs[loc.i]["pid"] eq loc.records["pid"][loc.i]')>
		</cfloop>
	</cffunction>

</cfcomponent>