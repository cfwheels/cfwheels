<cfcomponent name="JavaLoader" hint="Loads External Java Classes for Memcached">
	
	<cffunction name="init" hint="Constructor" access="public" returntype="JavaLoader" output="false">
		<cfargument name="serverFacade" type="any" required="Yes" hint="the server facade for the javaloader">
		<cfargument name="jarDir" type="string" required="false"  default="">
		<cfargument name="lockName" type="string" required="false"  default="memcached.server.JavaLoader">
		<cfscript>
			variables.instance = StructNew();
	
			setServerFacade(arguments.serverFacade);
		</cfscript>
			
		<!--- double check lock for safety --->
		<cfif NOT getServerFacade().hasJavaLoader()>
			<cflock name="#arguments.lockName#" throwontimeout="true" timeout="60">
				<cfscript>
					if(NOT getServerFacade().hasJavaLoader())
					{
						getServerFacade().setJavaLoader(createObject("component", "javaloader.JavaLoader").init(queryJars(arguments.jarDir), true));
					}
				</cfscript>
			</cflock>
		</cfif>
	
		<cfscript>
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="create" access="public" returntype="any" output="false" 
			hint="Retrieves a reference to the java class. To create a instance, you must run init() on this object">
		<cfargument name="className" type="string" required="Yes" hint="The name of the class to create">
		<cfscript>
			return getServerFacade().getJavaLoader().create(arguments.className);
		</cfscript>
	</cffunction>
	
	<cffunction name="queryJars" access="private" returntype="array" output="false" hint="pulls a query of all the jars in the /lib folder" >
		<cfargument name="jarDir" type="string" required="false" default="">
		<cfscript>
			var qJars = 0;
			//the path to my jar library
			//var path = expandPath(arguments.jarDir);
			var jarList = "";
			var aJars = ArrayNew(1);
			var libName = 0;
		</cfscript>
		<cfif len(trim(arguments.jardir)) gt 0 and directoryExists(arguments.jarDir)>
			<cfdirectory action="list" name="qJars" directory="#arguments.jarDir#" filter="*.jar" sort="name desc"/>
		
			<cfloop query="qJars">
				<cfscript>
					libName = ListGetAt(name, 1, "-");
					//let's not use the lib's that have the same name, but a lower datestamp
					if(NOT ListFind(jarList, libName))
					{
						ArrayAppend(aJars, directory & "/" & name);
						jarList = ListAppend(jarList, libName);
					}
				</cfscript>
			</cfloop>
		</cfif>
		<cfreturn aJars>
	</cffunction>
	
	<cffunction name="getServerFacade" access="private" returntype="any" output="false">
		<cfreturn instance.serverFacade />
	</cffunction>
	
	<cffunction name="setServerFacade" access="private" returntype="void" output="false">
		<cfargument name="serverFacade" type="any" required="true">
		<cfset instance.serverFacade = arguments.serverFacade />
	</cffunction>

</cfcomponent>