<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_accepts_undefined_value">
		<cfargument name="value1" type="string" required="false" default="asdfasdf" />
		<cfargument name="value2" type="string" required="false" /><!--- this creates an undefined value to test $hashedKey() --->
		<cfset loc.e = raised('$hashedKey(argumentCollection=arguments)')>
		<cfset loc.r = "">
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_accepts_generated_query">
		<cfargument name="a" type="string" required="false" default="asdfasdf" />
		<cfargument name="b" type="query" required="false" default="#QueryNew('a,b,c,e')#" /><!--- this creates a query that does not have sql metadata --->
		<cfset loc.e = raised('$hashedKey(argumentCollection=arguments)')>
		<cfset loc.r = "">
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_same_output">
		<cffile action="readbinary" file="#expandpath('wheels/tests/_assets/files/cfwheels-logo.png')#" variable="loc.binaryData">
		<cftransaction action="begin">
			<cfset loc.photo = model("photo").findOne()>
			<cfset loc.photo.update(filename="somefilename", fileData=loc.binaryData)>
			<cfset loc.photo = model("photo").findAll(where="id = #loc.photo.id#")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset loc.a = []>
		<cfset loc.a[1] = "petruzzi">
		<cfset loc.a[2] = "gibson">
		<cfset loc.query = QueryNew('a,b,c,d,e')>
		<cfset QueryAddRow(loc.query, 1)>
		<cfset QuerySetCell(loc.query, "a", "tony")>
		<cfset QuerySetCell(loc.query, "b", "per")>
		<cfset QuerySetCell(loc.query, "c", "james")>
		<cfset QuerySetCell(loc.query, "d", "chris")>
		<cfset QuerySetCell(loc.query, "e", "raul")>
		<cfset loc.a[3] = loc.query>
		<cfset loc.a[4] = [1,2,3,4,5,6]>
		<cfset loc.a[5] = {a=1,b=2,c=3,d=4}>
		<cfset loc.a[6] = loc.photo>
		<cfset loc.args = {}>
		<cfset loc.args.a = loc.a>
		<cfset loc.e = $hashedKey(argumentCollection=loc.args)>
		<cfset arrayswap(loc.a, 1,3)>
		<cfset arrayswap(loc.a, 4,5)>
		<cfset loc.r = $hashedKey(argumentCollection=loc.args)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>