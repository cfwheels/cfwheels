<cfcomponent name="FacadeFactory" hint="The Factory for getting facades">
	
	<cfscript>
		instance = StructNew();
	</cfscript>
	
	<cffunction name="init" hint="Constructor" access="public" returntype="FacadeFactory" output="false">
		<cfscript>
			setServerFacade(createObject("component", "ServerFacade").init());
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getServerFacade" access="public" returntype="ServerFacade" output="false">
		<cfreturn instance.ServerFacade />
	</cffunction>
	
	<cffunction name="setServerFacade" access="private" returntype="void" output="false">
		<cfargument name="ServerFacade" type="ServerFacade" required="true">
		<cfset instance.ServerFacade = arguments.ServerFacade />
	</cffunction>
	
</cfcomponent>