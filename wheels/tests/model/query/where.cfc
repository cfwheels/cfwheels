<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>

	<cffunction name="test_set_where_auto_equals">
		<cfset loc.authorModel.where(id=1)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "eql"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq 1')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_multiple_where_auto_equals">
		<cfset loc.authorModel.where(id=1, firstName="Per")>
		<cfset loc.firstNameData = loc.authorModel.toQuery().where[1]>
		<cfset loc.idData = loc.authorModel.toQuery().where[2]>
		<cfset assert('loc.firstNameData.operation eq "eql"')>
		<cfset assert('loc.firstNameData.property eq "firstName"')>
		<cfset assert('loc.firstNameData.value eq "Per"')>
		<cfset assert('loc.firstNameData.negate eq false')>
		<cfset assert('loc.idData.operation eq "eql"')>
		<cfset assert('loc.idData.property eq "id"')>
		<cfset assert('loc.idData.value eq 1')>
		<cfset assert('loc.idData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_must_be_called_first">
		<cftry>
			<cfset loc.authorModel.where(id=1)>
			<cfcatch type="Wheels.IncorrectQueryMethodChaining">
				<cfset assert('true eq true') />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="test_set_where_property_equals">
		<cfset loc.authorModel.where(property="id", eql=1)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "eql"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq 1')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_property_not_equals">
		<cfset loc.authorModel.where(property="id", notEql=1)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "eql"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq 1')>
		<cfset assert('loc.whereData.negate eq true')>
	</cffunction>

	<cffunction name="test_set_where_property_in">
		<cfset loc.idList = "1,2,3">
		<cfset loc.authorModel.where(property="id", in=loc.idList)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "in"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('IsArray(loc.whereData.value) and ArrayLen(loc.whereData.value) eq 3')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_property_not_in">
		<cfset loc.idList = "1,2,3">
		<cfset loc.authorModel.where(property="id", notIn=loc.idList)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "in"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('IsArray(loc.whereData.value) and ArrayLen(loc.whereData.value) eq 3')>
		<cfset assert('loc.whereData.negate eq true')>
	</cffunction>

	<cffunction name="test_set_where_property_between">
		<cfset loc.idList = "1,3">
		<cfset loc.authorModel.where(property="id", between=loc.idList)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "between"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('IsArray(loc.whereData.value) and ArrayLen(loc.whereData.value) eq 2')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_property_not_between">
		<cfset loc.idList = "1,3">
		<cfset loc.authorModel.where(property="id", notBetween=loc.idList)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "between"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('IsArray(loc.whereData.value) and ArrayLen(loc.whereData.value) eq 2')>
		<cfset assert('loc.whereData.negate eq true')>
	</cffunction>

	<cffunction name="test_set_where_property_greater_than">
		<cfset loc.authorModel.where(property="id", greaterThan=3)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "greaterthan"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq 3')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_property_greater_than_equal">
		<cfset loc.authorModel.where(property="id", greaterThanEql=3)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "greaterthaneql"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq 3')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_property_less_than">
		<cfset loc.authorModel.where(property="id", lessThan=3)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "lessThan"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq 3')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_property_less_than_equal">
		<cfset loc.authorModel.where(property="id", lessThanEql=3)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "lessThanEql"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq 3')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_property_is_null">
		<cfset loc.authorModel.where(property="id", null=true)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "null"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq ""')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

	<cffunction name="test_set_where_property_is_not_null">
		<cfset loc.authorModel.where(property="id", null=false)>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "null"')>
		<cfset assert('loc.whereData.property eq "id"')>
		<cfset assert('loc.whereData.value eq ""')>
		<cfset assert('loc.whereData.negate eq true')>
	</cffunction>

	<cffunction name="test_set_where_to_sql">
		<cfset loc.authorModel.where(sql="id = 3")>
		<cfset loc.whereData = loc.authorModel.toQuery().where[1]>
		<cfset assert('loc.whereData.operation eq "sql"')>
		<cfset assert('loc.whereData.value eq "id = 3"')>
		<cfset assert('loc.whereData.negate eq false')>
	</cffunction>

</cfcomponent>