<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_railo_invalid">
		<cfset assert('Len($checkMinimumVersion(version="4.3.0.003", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="4.2.1.008", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3.0.2", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="4.2.1.000", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3.1.2", engine="Railo"))')>
		<cfset assert('Len($checkMinimumVersion(version="3.1.2.020", engine="Railo"))')>
	</cffunction>

	<cffunction name="test_lucee_valid">
		<cfset assert('!Len($checkMinimumVersion(version="4.5.1.022", engine="Lucee"))')>
	</cffunction>

	<cffunction name="test_lucee_invalid">
		<cfset assert('Len($checkMinimumVersion(version="4.5.1.021", engine="Lucee"))')>
		<cfset assert('Len($checkMinimumVersion(version="4.4.0", engine="Lucee"))')>
		<cfset assert('Len($checkMinimumVersion(version="4.5.0.023", engine="Lucee"))')>
	</cffunction>

	<cffunction name="test_adobe_valid">
		<cfset assert('!Len($checkMinimumVersion(version="10,0,16,251028", engine="Adobe ColdFusion"))')>
		<cfset assert('!Len($checkMinimumVersion(version="11,0,5,251028", engine="Adobe ColdFusion"))')>
	</cffunction>

	<cffunction name="test_adobe_invalid">
		<cfset assert('Len($checkMinimumVersion(version="9,0,0,251028", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="8,0,1,195765", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="10,0,4,277803", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="8,0,1,0", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="8,0", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="8,0,0,0", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="8,0,0,195765", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="7", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="10,0,0,282462", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="10,0,3,282462", engine="Adobe ColdFusion"))')>
		<cfset assert('Len($checkMinimumVersion(version="11,0,3,282462", engine="Adobe ColdFusion"))')>
	</cffunction>

</cfcomponent>