<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_automaticavalidations_should_validate_primary_keys">
		<cfset loc.user = model("UserAutoMaticValidations").new(
			username='tonyp1'
			,password='tonyp123'
			,firstname='Tony'
			,lastname='Petruzzi'
			,address='123 Petruzzi St.'
			,city='SomeWhere1'
			,state='TX'
			,zipcode='11111'
			,phone='1235551212'
			,fax='4565551212'
			,birthday='11/01/1975'
			,birthdaymonth=11
			,birthdayyear=1975
			,isactive=1
		)>
		
		<!--- should be valid since id is not passed in --->
		<cfset assert('loc.user.valid()')>
		
		<!--- should _not_ be valid since id is not a number --->		
		<cfset loc.user.id = 'ABC'>
		<cfset assert('!loc.user.valid()')>
		
		<!--- should be valid since id is blank --->
		<cfset loc.user.id = ''>
		<cfset assert('loc.user.valid()')>
		
		<!--- should be valid since id is a number --->
		<cfset loc.user.id = 1>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
</cfcomponent>