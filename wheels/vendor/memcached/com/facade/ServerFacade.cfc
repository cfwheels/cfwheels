<cfcomponent name="ServerFacade" hint="Facade to the Server Scope" extends="AbstractBaseFacade">

<cfscript>
	instance.static.uuid = "E9F9B59E-19D2-AE93-755113943D8C265J";
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseFacade" output="false">
	<cfscript>
		setJavaLoaderKey(instance.static.uuid);
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="getJavaLoader" access="public" returntype="any" output="false">
	<cfreturn StructFind(getScope(), getJavaLoaderKey()) />
</cffunction>

<cffunction name="setJavaLoader" access="public" returntype="void" output="false">
	<cfargument name="javaLoader" type="any" required="true">
	<cfset StructInsert(getScope(), getJavaLoaderKey(), arguments.javaLoader) />
</cffunction>

<cffunction name="hasJavaLoader" access="public" returntype="boolean" output="false" hint="if the server scope has the JavaLoader in it">
	<cfreturn StructKeyExists(getScope(), getJavaLoaderkey())/>
</cffunction>

<cffunction name="getScope" access="private" returntype="struct" output="false" hint="returns the Server scope">
	<cfreturn server>
</cffunction>

<cffunction name="getJavaLoaderKey" access="private" returntype="string" output="false">
	<cfreturn instance.JavaLoaderKey />
</cffunction>

<cffunction name="setJavaLoaderKey" access="private" returntype="void" output="false">
	<cfargument name="JavaLoaderKey" type="string" required="true">
	<cfset instance.JavaLoaderKey = arguments.JavaLoaderKey />
</cffunction>

</cfcomponent>