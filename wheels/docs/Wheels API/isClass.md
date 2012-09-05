# isClass()

## Description
Use this method within a model's method to check whether you are currently in a class-level object.

## Function Syntax
	isClass(  )



## Examples
	
		<!--- Use the passed in `id` when we're already in an instance --->
		<cffunction name="memberIsAdmin">
			<cfif isClass()>
				<cfreturn this.findByKey(arguments.id).admin>
			<cfelse>
				<cfreturn this.admin>
			</cfif>
		</cffunction>
