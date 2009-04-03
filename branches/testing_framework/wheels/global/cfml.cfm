<cffunction name="$namedReadLock" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="object" type="any" required="true">
	<cfargument name="method" type="string" required="true">
	<cfargument name="args" type="struct" required="false" default="#StructNew()#">
	<cfargument name="timeout" type="numeric" required="false" default="30">
	<cfset var loc = StructNew()>
	<cflock name="#arguments.name#" type="readonly" timeout="#arguments.timeout#">
		<cfset loc.returnValue = $invoke(component=arguments.object, method=arguments.method, argumentCollection=arguments.args)>
	</cflock>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$doubleCheckedLock" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="condition" type="string" required="true">
	<cfargument name="execute" type="string" required="true">
	<cfargument name="conditionArgs" type="struct" required="false" default="#StructNew()#">
	<cfargument name="executeArgs" type="struct" required="false" default="#StructNew()#">
	<cfargument name="timeout" type="numeric" required="false" default="30">
	<cfset var loc = StructNew()>
	<cfset loc.returnValue = $invoke(method=arguments.condition, argumentCollection=arguments.conditionArgs)>
	<cfif IsBoolean(loc.returnValue) AND NOT loc.returnValue>
		<cflock name="#arguments.name#" timeout="#arguments.timeout#">
			<cfset loc.returnValue = $invoke(method=arguments.condition, argumentCollection=arguments.conditionArgs)>
			<cfif IsBoolean(loc.returnValue) AND NOT loc.returnValue>
				<cfset loc.returnValue = $invoke(method=arguments.execute, argumentCollection=arguments.executeArgs)>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$simpleLock" returntype="any" access="public" output="false">
	<cfargument name="execute" type="string" required="true">
	<cfargument name="executeArgs" type="struct" required="false" default="#StructNew()#">
	<cfargument name="timeout" type="numeric" required="false" default="30">
	<cfset var loc = StructNew()>
	<cfset loc.lockArgs = Duplicate(arguments)>
	<cfset StructDelete(loc.lockArgs, "execute")>
	<cfset StructDelete(loc.lockArgs, "executeArgs")>
	<cflock attributeCollection="#loc.lockArgs#">
		<cfinvoke method="#arguments.execute#" argumentCollection="#arguments.executeArgs#" returnvariable="loc.returnValue">
	</cflock>
	<cfif StructKeyExists(loc, "returnValue")>
		<cfreturn loc.returnValue>
	</cfif>
</cffunction>

<cffunction name="$image" returntype="struct" access="public" output="false">
	<cfset var returnValue = {}>
	<cfset arguments.structName = "returnValue">
	<cfimage attributeCollection="#arguments#">
	<cfreturn returnValue>
</cffunction>

<cffunction name="$mail" returntype="void" access="public" output="false">
	<cfset var loc = {}>
	<cfset loc.content = arguments.body>
	<cfset StructDelete(arguments, "body")>
	<cfmail attributeCollection="#arguments#"><cfif ArrayLen(loc.content) GT 1><cfmailpart type="text">#Trim(loc.content[1])#</cfmailpart><cfmailpart type="html">#Trim(loc.content[2])#</cfmailpart><cfelse>#Trim(loc.content[1])#</cfif></cfmail>
</cffunction>

<cffunction name="$zip" returntype="any" access="public" output="false">
	<cfzip attributeCollection="#arguments#">
	</cfzip>
</cffunction>

<cffunction name="$content" returntype="any" access="public" output="false">
	<cfcontent attributeCollection="#arguments#">
</cffunction>

<cffunction name="$header" returntype="void" access="public" output="false">
	<cfheader attributeCollection="#arguments#">
</cffunction>

<cffunction name="$abort" returntype="void" access="public" output="false">
	<cfabort attributeCollection="#arguments#">
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
	<cfargument name="template" type="string" required="true">
	<cfset var returnValue = "">
	<cfsavecontent variable="returnValue"><cfinclude template="../../#LCase(arguments.template)#"></cfsavecontent>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$directory" returntype="any" access="public" output="false">
	<cfset var returnValue = "">
	<cfset arguments.name = "returnValue">
	<cfdirectory attributeCollection="#arguments#">
	<cfreturn returnValue>
</cffunction>

<cffunction name="$file" returntype="any" access="public" output="false">
	<cfset var returnValue = "">
	<cfset arguments.variable = "returnValue">
	<cffile attributeCollection="#arguments#">
	<cfreturn returnValue>
</cffunction>

<cffunction name="$throw" returntype="void" access="public" output="false">
	<cfthrow attributeCollection="#arguments#">
</cffunction>

<cffunction name="$invoke" returntype="any" access="public" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.returnVariable = "loc.returnValue">
	<cfinvoke attributeCollection="#arguments#">
	<cfif StructKeyExists(loc, "returnValue")>
		<cfreturn loc.returnValue>
	</cfif>
</cffunction>

<cffunction name="$location" returntype="void" access="public" output="false">
	<cflocation attributeCollection="#arguments#">
</cffunction>

<cffunction name="$dbinfo" returntype="any" access="public" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.name = "loc.returnValue">
	<!--- we have to use this cfif here to get around a bug with railo --->
	<cfif StructKeyExists(arguments, "table")>
		<cfdbinfo datasource="#arguments.datasource#" name="#arguments.name#" type="#arguments.type#" username="#arguments.username#" password="#arguments.password#" table="#arguments.table#">
	<cfelse>
		<cfdbinfo datasource="#arguments.datasource#" name="#arguments.name#" type="#arguments.type#" username="#arguments.username#" password="#arguments.password#">
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$dump" returntype="void" access="public" output="true">
	<cfargument name="var" type="any" required="true">
	<cfargument name="abort" type="boolean" required="false" default="true">
	<cfdump var="#arguments.var#">
	<cfif arguments.abort>
		<cfabort>
	</cfif>
</cffunction>