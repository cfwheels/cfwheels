<cfcomponent name="AbstractBaseFacade" hint="The abstract base to all the scope facades">

<cfscript>
	instance = StructNew();
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseFacade" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="configuration, due to di loops" access="public" returntype="void" output="false">
	<cfargument name="key" hint="The key to store values under" type="string" required="Yes">
	<cfscript>
		setKey(arguments.key);
	</cfscript>
</cffunction>

</cfcomponent>