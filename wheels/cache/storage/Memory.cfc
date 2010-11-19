<cfcomponent implements="AbstractStorage" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfscript>
			variables.$instance = {};
			variables.$instance.cache = {};
		</cfscript>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="isAvailable" access="public" output="false" returntype="boolean">
		<cfreturn StructKeyExists(variables, "$instance") && StructKeyExists(variables.$instance, "cache")>
	</cffunction>
	
	<cffunction name="set" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
		<cfscript>
			variables.$instance.cache[arguments.key] = arguments.value;
		</cfscript>
	</cffunction>
	
	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.value = false;
			
			if (StructKeyExists(variables.$instance.cache, arguments.key))
			{
				if (IsSimpleValue(variables.$instance.cache[arguments.key]))
				{
					loc.value = variables.$instance.cache[arguments.key];
				}
				else
				{
					loc.value = Duplicate(variables.$instance.cache[arguments.key]);
				}
			}
		</cfscript>
		<cfreturn loc.value>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			StructDelete(variables.$instance.cache, arguments.key, false);
		</cfscript>
	</cffunction>
	
</cfcomponent>