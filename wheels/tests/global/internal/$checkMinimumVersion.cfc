<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_railo_valid">
		<cfset assert('!Len($checkMinimumVersion(version="4.3.0.003", engine="Railo"))')>
		<cfset assert('!Len($checkMinimumVersion(version="4.2.1.000", engine="Railo"))')>
	</cffunction>

	<cffunction name="test_railo_invalid">
		<cfset assert('Len($checkMinimumVersion(version="3.1.2.022", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3.1.2.020", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3.2.2.020", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3.1.2.018", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3.1.2.019", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="2.1.2.3", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3.3.5.004", engine="Railo"))')>
	</cffunction>

	<cffunction name="test_adobe_valid">
		<cfset assert('!Len($checkMinimumVersion(version="8,0,1,0", engine="Adobe ColdFusion"))')>
		<cfset assert('!Len($checkMinimumVersion(version="9,0,0,251028", engine="Adobe ColdFusion"))')>
		<cfset assert('!Len($checkMinimumVersion(version="8,0,1,195765", engine="Adobe ColdFusion"))')>
		<cfset assert('!Len($checkMinimumVersion(version="10,0,4,277803", engine="Adobe ColdFusion"))')>
	</cffunction>

	<cffunction name="test_adobe_invalid">
		<cfset assert('Len($checkMinimumVersion(version="8,0", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="8,0,0,0", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="8,0,0,195765", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="7", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="10,0,0,282462", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="10,0,3,282462", engine="Adobe ColdFusion"))')>
	</cffunction>

</cfcomponent>