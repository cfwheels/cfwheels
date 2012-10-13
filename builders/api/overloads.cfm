<!--- 
Use this file to overload any of the outputted api documentation

example map of the doucmentation structure:

<data type="struct">
	<findAll type="struct">
		<EXAMPLES type="string" />
		<CATEGORIES type="array">
			<item type="string" order="1"/>
			<item type="string" order="2"/>
		</CATEGORIES>
		<NAME type="string"/>
		<CHAPTERS type="array">
			<item type="string" order="1"/>
			<item type="string" order="2"/>
		</CHAPTERS>
		<PARAMETERS type="array">
			<item type="struct" order="1">
				<NAME type="string"/>
				<DEFAULT type="string"/>
				<TYPE type="string"/>
				<REQUIRED type="boolean"/>
				<HINT type="string"/>
			</item>
			<item type="struct" order="2">
				<NAME type="string"/>
				<DEFAULT type="string"/>
				<TYPE type="string"/>
				<REQUIRED type="boolean"/>
				<HINT type="string"/>
			</item>
		</PARAMETERS>
	</findAll>
</data>
 --->

<!--- the properties argument for validations should be set to true --->
<cfloop list="validatesConfirmationOf,validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesLengthOf,validatesNumericalityOf,validatesPresenceOf,validatesUniquenessOf" index="i">
	
	<cfset temp = {}>
	<cfset temp.required = "true">
	
	<cfset api.overload(i, "parameters", temp, "properties")>
	
</cfloop>

<cfloop list="textFieldTag" index="i">
	
	<cfset temp = {}>
	<cfset temp.default = "">
	<cfset temp.hint = "The class name for the label">
	<cfset temp.name = "labelClass">
	<cfset temp.required = "false">
	<cfset temp.type = "string">
	
	<cfset api.overload(i, "parameters", temp, "")>
	
</cfloop>