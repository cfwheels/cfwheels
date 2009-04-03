<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9">
		<cfreturn this>
	</cffunction>

	<cffunction name="textFieldTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input name="#arguments.name#" id="#arguments.name#" type="text" value="#HTMLEditFormat($formValue(argumentCollection=arguments))#"#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="radioButtonTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="checked" type="any" required="false" default="false">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,checked,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfset loc.name = arguments.name>
		<cfset loc.id = arguments.name & "-" & LCase(Replace(ReReplaceNoCase(arguments.value, "[^a-z0-9 ]", "", "all"), " ", "-", "all"))>
		<cfset arguments.name = loc.id>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input name="#loc.name#" id="#loc.id#" type="radio" value="#$formValue(argumentCollection=arguments)#"<cfif arguments.checked> checked="checked"</cfif>#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="checkBoxTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="1">
		<cfargument name="checked" type="any" required="false" default="false">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,checked,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input name="#arguments.name#" id="#arguments.name#" type="checkbox" value="#arguments.value#"<cfif arguments.checked> checked="checked"</cfif>#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="passwordFieldTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input name="#arguments.name#" id="#arguments.name#" type="password" value="#HTMLEditFormat($formValue(argumentCollection=arguments))#"#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="hiddenFieldTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfset loc.value = $formValue(argumentCollection=arguments)>
		<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
			<cfset loc.value = obfuscateParam(loc.value)>
		</cfif>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				<input name="#arguments.name#" id="#arguments.name#" type="hidden" value="#HTMLEditFormat(loc.value)#"#loc.attributes# />
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="textAreaTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfset loc.output = "">
		<cfset loc.output = loc.output & $formBeforeElement(argumentCollection=arguments)>
		<cfset loc.output = loc.output & "<textarea name=""#arguments.name#"" id=""#arguments.name#""#loc.attributes#>">
		<cfset loc.output = loc.output & $formValue(argumentCollection=arguments)>
		<cfset loc.output = loc.output & "</textarea>">
		<cfset loc.output = loc.output & $formAfterElement(argumentCollection=arguments)>
	
		<cfreturn loc.output>
	</cffunction>
	
	<cffunction name="fileFieldTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input type="file" name="#arguments.name#" id="#arguments.name#" value="#HTMLEditFormat($formValue(argumentCollection=arguments))#"#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="selectTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="options" type="any" required="true">
		<cfargument name="includeBlank" type="any" required="false" default="false">
		<cfargument name="multiple" type="any" required="false" default="false">
		<cfargument name="valueField" type="any" required="false" default="id">
		<cfargument name="textField" type="any" required="false" default="name">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,options,includeBlank,multiple,valueField,textField,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<select name="#arguments.name#" id="#arguments.name#"<cfif arguments.multiple> multiple</cfif>#loc.attributes#>
				<cfif NOT IsBoolean(arguments.includeBlank) OR arguments.includeBlank>
					<cfif NOT IsBoolean(arguments.includeBlank)>
						<cfset loc.text = arguments.includeBlank>
					<cfelse>
						<cfset loc.text = "">
					</cfif>
					<option value="">#loc.text#</option>
				</cfif>
				#$optionsForSelect(argumentCollection=arguments)#
				</select>
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>

	<cffunction name="dateTimeSelectTag" returntype="any" access="public" output="false" hint="Returns HTML select tags for choosing year, month, day, hour, minute and second.">
		<cfargument name="dateOrder" type="any" required="false" default="month,day,year" hint="Use to change the order of or exclude date select tags">
		<cfargument name="timeOrder" type="any" required="false" default="hour,minute,second" hint="Use to change the order of or exclude time select tags ">
		<cfargument name="dateSeparator" type="any" required="false" default=" " hint="Use to change the character that is displayed between the date select tags ">
		<cfargument name="timeSeparator" type="any" required="false" default=":" hint="Use to change the character that is displayed between the time select tags ">
		<cfargument name="separator" type="any" required="false" default=" - " hint="Use to change the character that is displayed between the first and second set of select tags ">
		<!---
			#dateTimeSelectTag(dateOrder="year,month,day", monthDisplay="abbreviations")#
		--->
		<cfset arguments.$functionName = "dateTimeSelectTag">
		<cfreturn $dateTimeSelect(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="dateSelectTag" returntype="any" access="public" output="false" hint="Returns HTML select tags for choosing year, month and day.">
		<cfargument name="order" type="any" required="false" default="month,day,year" hint="Use to change the order of or exclude select tags">
		<cfargument name="separator" type="any" required="false" default=" " hint="Use to change the character that is displayed between the select tags">
		<!---
			#dateSelectTag(order="year,month,day")#
		--->
		<cfreturn $dateSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="timeSelectTag" returntype="any" access="public" output="false" hint="Returns HTML select tags for choosing hour, minute and second.">
		<cfargument name="order" type="any" required="false" default="hour,minute,second" hint="Use to change the order of or exclude select tags">
		<cfargument name="separator" type="any" required="false" default=":" hint="Use to change the character that is displayed between the select tags">
		<!---
			#timeSelectTag(order="hour,minute", separator=" - ")#
		--->
		<cfreturn $timeSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="yearSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with years as options.">
		<cfargument name="startYear" type="any" required="false" default="#year(now())-5#" hint="First year in select list">
		<cfargument name="endYear" type="any" required="false" default="#year(now())+5#" hint="Last year in select list">
		<!---
			#yearSelectTag()#
			#yearSelectTag(startYear=1900, endYear=year(now()))#
		--->
		<cfreturn $yearSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="monthSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with months as options.">
		<cfargument name="monthDisplay" type="any" required="false" default="names" hint="pass in 'names', 'numbers' or 'abbreviations' to control display">
		<!---
			#monthSelectTag()#
			#monthSelectTag(monthDisplay="abbreviations")#
		--->
		<cfreturn $monthSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="daySelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with days as options.">
		<!---
			#daySelectTag()#
		--->
		<cfreturn $daySelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="hourSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with days as options.">
		<!---
			#hourSelectTag()#
		--->
		<cfreturn $hourSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="minuteSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with minutes as options.">
		<cfargument name="minuteStep" type="any" required="false" default="1">
		<!---
			#minuteSelectTag()#
			#minuteSelectTag(minuteStep=10)#
		--->
		<cfreturn $minuteSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="secondSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with seconds from 0 to 59 as options.">
		<!---
			#secondSelectTag()#
		--->
		<cfreturn $secondSelectTag(argumentCollection=arguments)>
	</cffunction>

</cfcomponent>