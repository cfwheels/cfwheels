# isInstance()

## Description
Use this method to check whether you are currently in an instance object.

## Function Syntax
	isInstance(  )



## Examples
	
		<!--- Use the passed in `id` when we're not already in an instance --->
		<cffunction name="memberIsAdmin">
			<cfif isInstance()>
				<cfreturn this.admin>
			<cfelse>
				<cfreturn this.findByKey(arguments.id).admin>
			</cfif>
		</cffunction>
