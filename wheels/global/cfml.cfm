<cffunction name="$doubleCheckedLock" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="condition" type="string" required="true">
	<cfargument name="execute" type="string" required="true">
	<cfargument name="conditionArgs" type="struct" required="false" default="#StructNew()#">
	<cfargument name="executeArgs" type="struct" required="false" default="#StructNew()#">
	<cfargument name="timeout" type="numeric" required="false" default="30">
	<cfset local.rv = $invoke(method=arguments.condition, invokeArgs=arguments.conditionArgs)>
	<cfif IsBoolean(local.rv) AND NOT local.rv>
		<cflock name="#arguments.name#" timeout="#arguments.timeout#">
			<cfset local.rv = $invoke(method=arguments.condition, invokeArgs=arguments.conditionArgs)>
			<cfif IsBoolean(local.rv) AND NOT local.rv>
				<cfset local.rv = $invoke(method=arguments.execute, invokeArgs=arguments.executeArgs)>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn local.rv>
</cffunction>

<cffunction name="$simpleLock" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	<cfargument name="execute" type="string" required="true">
	<cfargument name="executeArgs" type="struct" required="false" default="#StructNew()#">
	<cfargument name="timeout" type="numeric" required="false" default="30">
	<cfif StructKeyExists(arguments, "object")>
		<cflock name="#arguments.name#" type="#arguments.type#" timeout="#arguments.timeout#">
			<cfset local.rv = $invoke(component="#arguments.object#", method="#arguments.execute#", argumentCollection="#arguments.executeArgs#")>
		</cflock>
	<cfelse>
		<cfset arguments.executeArgs.$locked = true>
		<cflock name="#arguments.name#" type="#arguments.type#" timeout="#arguments.timeout#">
			<cfset local.rv = $invoke(method="#arguments.execute#", argumentCollection="#arguments.executeArgs#")>
		</cflock>
	</cfif>
	<cfif StructKeyExists(local, "rv")>
		<cfreturn local.rv>
	</cfif>
</cffunction>

<cffunction name="$image" returntype="struct" access="public" output="false">
	<cfset var rv = {}>
	<cfset arguments.structName = "rv">
	<cfimage attributeCollection="#arguments#">
	<cfreturn rv>
</cffunction>

<cffunction name="$mail" returntype="void" access="public" output="false">
	<cfif StructKeyExists(arguments, "mailparts")>
		<cfset local.mailparts = arguments.mailparts>
		<cfset StructDelete(arguments, "mailparts")>
	</cfif>
	<cfif StructKeyExists(arguments, "mailparams")>
		<cfset local.mailparams = arguments.mailparams>
		<cfset StructDelete(arguments, "mailparams")>
	</cfif>
	<cfif StructKeyExists(arguments, "tagContent")>
		<cfset local.tagContent = arguments.tagContent>
		<cfset StructDelete(arguments, "tagContent")>
	</cfif>
	<cfmail attributeCollection="#arguments#">
		<cfif StructKeyExists(local, "mailparams")>
			<cfloop array="#local.mailparams#" index="local.i">
				<cfmailparam attributeCollection="#local.i#">
			</cfloop>
		</cfif>
		<cfif StructKeyExists(local, "mailparts")>
			<cfloop array="#local.mailparts#" index="local.i">
				<cfset local.innerTagContent = local.i.tagContent>
				<cfset StructDelete(local.i, "tagContent")>
				<cfmailpart attributeCollection="#local.i#">
					#local.innerTagContent#
				</cfmailpart>
			</cfloop>
		</cfif>
		<cfif StructKeyExists(local, "tagContent")>
			#local.tagContent#
		</cfif>
	</cfmail>
</cffunction>

<cffunction name="$cache" returntype="any" access="public" output="false">
	<!--- If cache is found only the function is aborted, not page. --->
	<cfset variables.$instance.reCache = false>
	<cfcache attributeCollection="#arguments#">
	<cfset variables.$instance.reCache = true>
</cffunction>

<cffunction name="$content" returntype="any" access="public" output="false">
	<cfcontent attributeCollection="#arguments#">
</cffunction>

<cffunction name="$header" returntype="void" access="public" output="false">
	<cfheader attributeCollection="#arguments#">
</cffunction>

<cffunction name="$include" returntype="void" access="public" output="false">
	<cfargument name="template" type="string" required="true">
	<cfinclude template="../../#LCase(arguments.template)#">
</cffunction>

<cffunction name="$includeAndOutput" returntype="void" access="public" output="true">
	<cfargument name="template" type="string" required="true">
	<cfinclude template="../../#LCase(arguments.template)#">
</cffunction>

<cffunction name="$includeAndReturnOutput" returntype="string" access="public" output="false">
	<cfargument name="$template" type="string" required="true">

	<!--- Make it so the developer can reference passed in arguments in the loc scope if they prefer. --->
	<cfif StructKeyExists(arguments, "$type") AND arguments.$type IS "partial">
		<cfset local = arguments>
	</cfif>

	<!--- Include the template and return the result. --->
	<!--- Variable is set to $wheels to limit chances of it being overwritten in the included template. --->
	<cfsavecontent variable="local.$wheels"><cfinclude template="../../#LCase(arguments.$template)#"></cfsavecontent>
	<cfreturn local.$wheels>

</cffunction>

<cffunction name="$directory" returntype="any" access="public" output="false">
	<cfset var rv = "">
	<cfset arguments.name = "rv">
	<cfdirectory attributeCollection="#arguments#">
	<cfreturn rv>
</cffunction>

<cffunction name="$file" returntype="any" access="public" output="false">
	<cffile attributeCollection="#arguments#">
</cffunction>

<cffunction name="$invoke" returntype="any" access="public" output="false">
	<cfset arguments.returnVariable = "local.rv">
	<cfif StructKeyExists(arguments, "componentReference")>
		<cfset arguments.component = arguments.componentReference>
		<cfset StructDelete(arguments, "componentReference")>
	<cfelseif NOT StructKeyExists(variables, arguments.method)>
		<!--- this is done so that we can call dynamic methods via "onMissingMethod" on the object (we need to pass in the object for this so it can call methods on the "this" scope instead) --->
		<cfset arguments.component = this>
	</cfif>
	<cfif StructKeyExists(arguments, "invokeArgs")>
		<cfset arguments.argumentCollection = arguments.invokeArgs>
		<cfif StructCount(arguments.argumentCollection) IS NOT ListLen(StructKeyList(arguments.argumentCollection))>
			<!--- work-around for fasthashremoved cf8 bug --->
			<cfset arguments.argumentCollection = StructNew()>
			<cfloop list="#StructKeyList(arguments.invokeArgs)#" index="local.i">
				<cfset arguments.argumentCollection[local.i] = arguments.invokeArgs[local.i]>
			</cfloop>
		</cfif>
		<cfset StructDelete(arguments, "invokeArgs")>
	</cfif>
	<cfif !structKeyExists(request, "$wheelsInvoked")>
		<cfset request.$wheelsInvoked = arrayNew(1)>
	</cfif>
	<cfset arrayPrepend(request.$wheelsInvoked, duplicate(arguments))>
	<cfinvoke attributeCollection="#arguments#">
	<cfset arrayDeleteAt(request.$wheelsInvoked, 1)>
	<cfif StructKeyExists(local, "rv")>
		<cfreturn local.rv>
	</cfif>
</cffunction>

<cffunction name="$location" returntype="void" access="public" output="false">
	<cfargument name="delay" type="boolean" required="false" default="false">
	<cfset StructDelete(arguments, "$args", false)>
	<cfif NOT arguments.delay>
		<cfset StructDelete(arguments, "delay", false)>
		<cflocation attributeCollection="#arguments#">
	</cfif>
</cffunction>

<cffunction name="$htmlhead" returntype="void" access="public" output="false">
	<cfhtmlhead attributeCollection="#arguments#">
</cffunction>

<cffunction name="$dbinfo" returntype="any" access="public" output="false">
	<cfset arguments.name = "local.rv">
	<cfif StructKeyExists(arguments, "username") && !Len(arguments.username)>
		<cfset StructDelete(arguments, "username")>
	</cfif>
	<cfif StructKeyExists(arguments, "password") && !Len(arguments.password)>
		<cfset StructDelete(arguments, "password")>
	</cfif>
	<cfdbinfo attributeCollection="#arguments#">

	<!--- Override name of database adapter when running internal tests --->
	<cfif arguments.type IS "version" AND StructKeyExists(url, "controller") AND StructKeyExists(url, "action") AND StructKeyExists(url, "view") AND StructKeyExists(url, "type") AND StructKeyExists(url, "adapter")>
		<cfif url.controller IS "wheels" AND url.action IS "wheels" AND url.view IS "tests" AND url.type IS "core">
			<cfset QuerySetCell(local.rv, "driver_name", url.adapter)>
		</cfif>
	</cfif>

	<cfreturn local.rv>
</cffunction>

<cffunction name="$wddx" returntype="any" access="public" output="false">
	<cfargument name="input" type="any" required="true">
	<cfargument name="action" type="string" required="false" default="cfml2wddx">
	<cfargument name="useTimeZoneInfo" type="boolean" required="false" default="true">
	<cfset arguments.output = "local.output">
	<cfwddx attributeCollection="#arguments#">
	<cfif StructKeyExists(local, "output")>
		<cfreturn local.output>
	</cfif>
</cffunction>

<cffunction name="$zip" returntype="any" access="public" output="false">
	<cfzip attributeCollection="#arguments#">
</cffunction>

<cffunction name="$query" returntype="any" access="public" output="false">
	<cfargument name="sql" type="string" required="true">
	<cfset StructDelete(arguments, "name")>
	<!--- allow the use of query of queries, caveat: Query must be called query. Eg: SELECT * from query --->
	<cfif StructKeyExists(arguments, "query") && IsQuery(arguments.query)>
		<cfset var query = Duplicate(arguments.query)>
	</cfif>
	<cfquery attributeCollection="#arguments#" name="local.rv">#PreserveSingleQuotes(arguments.sql)#</cfquery>
	<!--- some sql statements may not return a value --->
	<cfif StructKeyExists(local, "rv")>
		<cfreturn local.rv>
	</cfif>
</cffunction>
