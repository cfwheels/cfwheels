<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="compareTo" access="public" output="false" returntype="boolean" hint="Pass in another Wheels model object to see if the two objects are the same."
	examples='
		<!--- Load a user requested in the URL/form and restrict access if it doesn''t match the user stored in the session --->
		<cfset user = model("user").findByKey(params.key)>
		<cfif not user.compareTo(session.user)>
			<cfset renderView(action="accessDenied")>
		</cfif>
	'
	categories="model-object,miscellaneous" chapters="" functions="">
	<cfargument name="object" type="component" required="true">
	<cfreturn Compare(this.$objectId(), arguments.object.$objectId()) eq 0 />
</cffunction>

<cffunction name="$assignObjectId" access="public" output="false" returntype="numeric">
	<cfset var ret = "">
	<cflock type="exclusive" name="AssignObjectIdLock" timeout="5" throwontimeout="true">
		<cfif !StructKeyExists(request.wheels, "tickCountId")>
			<cfset request.wheels.tickCountId = GetTickCount()>
		</cfif>
		<cfset request.wheels.tickCountId = request.wheels.tickCountId + 1>
		<cfset ret = request.wheels.tickCountId>
	</cflock>
	<cfreturn ret>
</cffunction>

<cffunction name="$objectId" access="public" output="false" returntype="string">
	<cfreturn variables.wheels.instance.tickCountId />
</cffunction>

<cffunction name="isInstance" returntype="boolean" access="public" output="false" hint="Use this method to check whether you are currently in an instance object."
	examples='
		<!--- Use the passed in `id` when we''re not already in an instance --->
		<cffunction name="memberIsAdmin">
			<cfif isInstance()>
				<cfreturn this.admin>
			<cfelse>
				<cfreturn this.findByKey(arguments.id).admin>
			</cfif>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="isClass">
	<cfreturn StructKeyExists(variables.wheels, "instance")>
</cffunction>

<cffunction name="isClass" returntype="boolean" access="public" output="false" hint="Use this method within a model's method to check whether you are currently in a class-level object."
	examples='
		<!--- Use the passed in `id` when we''re already in an instance --->
		<cffunction name="memberIsAdmin">
			<cfif isClass()>
				<cfreturn this.findByKey(arguments.id).admin>
			<cfelse>
				<cfreturn this.admin>
			</cfif>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="isInstance">
	<cfreturn !isInstance(argumentCollection=arguments)>
</cffunction>