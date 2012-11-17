<cffunction name="textFieldTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a text field form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Basic usage usually involves a `label`, `name`, and `value` --->
		<cfoutput>
		    ##textFieldTag(label="Search", name="q", value=params.q)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="Name to populate in tag's `name` attribute.">
	<cfargument name="value" type="string" required="false" default="" hint="Value to populate in tag's `value` attribute.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		var loc = {};
		$args(name="textFieldTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.returnValue = textField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="passwordFieldTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a password field form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Basic usage usually involves a `label`, `name`, and `value` --->
		<cfoutput>
		    ##passwordFieldTag(label="Password", name="password", value=params.password)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="value" type="string" required="false" default="" hint="@textFieldTag.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		var loc = {};
		$args(name="passwordFieldTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.returnValue = passwordField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="hiddenFieldTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a hidden field form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Basic usage usually involves a `name` and `value` --->
		<cfoutput>
		    ##hiddenFieldTag(name="userId", value=user.id)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="value" type="string" required="false" default="" hint="@textFieldTag.">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.returnValue = hiddenField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="fileFieldTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a file form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Basic usage usually involves a `label`, `name`, and `value` --->
		<cfoutput>
		    ##fileFieldTag(label="Photo", name="photo", value=params.photo)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		var loc = {};
		$args(name="fileFieldTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = "";
		StructDelete(arguments, "name");
		loc.returnValue = fileField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="textAreaTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a text area form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Basic usage usually involves a `label`, `name`, and `password` --->
		<cfoutput>
		    ##textAreaTag(label="Description", name="description", content=params.description)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="content" type="string" required="false" default="" hint="Content to display in `textarea` on page load.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		var loc = {};
		$args(name="textAreaTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.content;
		StructDelete(arguments, "name");
		StructDelete(arguments, "content");
		loc.returnValue = textArea(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="radioButtonTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a radio button form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Basic usage usually involves a `label`, `name`, `value`, and `checked` value --->
		<cfoutput>
		    <fieldset>
				<legend>Gender</legend>
			    ##radioButtonTag(name="gender", value="m", label="Male", checked=true)##<br />
		        ##radioButtonTag(name="gender", value="f", label="Female")##
			</fieldset>
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="value" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether or not to check the radio button by default.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		var loc = {};
		$args(name="radioButtonTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.tagValue = arguments.value;
		if (arguments.checked)
			arguments.objectName[arguments.name] = arguments.value;
		else
			arguments.objectName[arguments.name] = " "; // space added to allow a blank value while still not having the form control checked
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		StructDelete(arguments, "checked");
		loc.returnValue = radioButton(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="checkBoxTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a check box form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Example 1: Basic usage involves a `label`, `name`, and `value` --->
		<cfoutput>
		    ##checkBoxTag(name="subscribe", value="true", label="Subscribe to our newsletter", checked=false)##
		</cfoutput>
		
		<!--- Example 2: Loop over a query to display choices and whether or not they are checked --->
		<!--- - Controller code --->
		<cfset pizza = model("pizza").findByKey(session.pizzaId)>
		<cfset selectedToppings = pizza.toppings()>
		<cfset toppings = model("topping").findAll(order="name")>
		
		<!--- View code --->
		<fieldset>
			<legend>Toppings</legend>
			<cfoutput query="toppings">
				##checkBoxTag(name="toppings", value="true", label=toppings.name, checked=YesNoFormat(ListFind(ValueList(selectedToppings.id), toppings.id))##
			</cfoutput>
		</fieldset>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTag,dateSelectTag,timeSelectTag">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether or not the check box should be checked by default.">
	<cfargument name="value" type="string" required="false" hint="Value of check box in its `checked` state.">
	<cfargument name="uncheckedValue" type="string" required="false" default="" hint="The value of the check box when it's on the `unchecked` state.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		var loc = {};
		$args(name="checkBoxTag", args=arguments);
		arguments.checkedValue = arguments.value;
		arguments.property = arguments.name;
		arguments.objectName = {};
		if (arguments.checked)
			arguments.objectName[arguments.name] = arguments.value;
		else
			arguments.objectName[arguments.name] = " "; // space added to allow a blank value while still not having the form control checked
		if (!StructKeyExists(arguments, "id"))
		{
			loc.valueToAppend = LCase(Replace(ReReplaceNoCase(arguments.checkedValue, "[^a-z0-9- ]", "", "all"), " ", "-", "all"));
			arguments.id = $tagId(arguments.objectName, arguments.property);
			if (len(loc.valueToAppend))
				arguments.id = arguments.id & "-" & loc.valueToAppend;
		}
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		StructDelete(arguments, "checked");
		loc.returnValue = checkBox(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="selectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control based on the supplied `name` and `options`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Controller code --->
		<cfset cities = model("city").findAll()>

		<!--- View code --->
		<cfoutput>
		    ##selectTag(name="cityId", options=cities)##
		</cfoutput>
		
		<!--- Do this when Wheels isn''t grabbing the correct values for the `option`s'' values and display texts --->
		<cfoutput>
			##selectTag(name="cityId", options=cities, valueField="id", textField="name")##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="options" type="any" required="true" hint="@select.">
	<cfargument name="selected" type="string" required="false" default="" hint="Value of option that should be selected by default.">
	<cfargument name="includeBlank" type="any" required="false" hint="@select.">
	<cfargument name="multiple" type="boolean" required="false" hint="Whether to allow multiple selection of options in the select form control.">
	<cfargument name="valueField" type="string" required="false" hint="@select.">
	<cfargument name="textField" type="string" required="false" hint="@select.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		var loc = {};
		$args(name="selectTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		loc.returnValue = select(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="radioButtonTagGroup" returntype="string" access="public" output="false" hint="Builds and returns a string for a group of radio buttons and labels. If you pass in [value] to any of the arguments that get appplied to each individual radio button (`append` for example), it will be replaced by the real value in the current iteration. You can pass in different `prepend`, `append` etc arguments by using a list."
	examples=
	'
		<!--- Simple yes/no selection --->
		<cfset choices = StructNew()>
		<cfset choices.1 = "Yes">
		<cfset choices.0 = "No">
		<cfoutput>
			##radioButtonTagGroup(name="yesorno", values=choices)##
		</cfoutput>

		<!--- Output three radio buttons for choosing how to perform a search --->
		<cfset values = StructNew()>
		<cfset values.all = "Results containing all of the words.">
		<cfset values.any = "Results containing any of the words.">
		<cfset values.exact = "Results containing the exact phrase.">
		<cfoutput>
			##radioButtonTagGroup(name="type", values=values, checkedValue=params.type, prependToGroup="<div class=""clearfix""><label>Show:</label><div class=""input""><ul class=""inputs-list"">", appendToGroup="</ul></div></div>", prepend="<li><label>", append="<span>[value]</span></label></li>")##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="" functions="radioButtonTag,checkBoxTagGroup">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="values" type="struct" required="true" hint="Struct containing keys/values for the radio buttons and labels to be created.">
	<cfargument name="checkedValue" type="string" required="false" hint="The value of the radio button that should be checked.">
	<cfargument name="order" type="string" required="false" hint="List of struct keys in the order you want them displayed (to override the alphabetical default).">
	<cfargument name="prependToGroup" type="string" required="false" hint="String to prepend to the entire group of radio buttons.">
	<cfargument name="appendToGroup" type="string" required="false" hint="String to append to the entire group of radio buttons.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		var loc = {};
		$args(name="radioButtonTagGroup", args=arguments);
		arguments.input = "radioButtonTag";
		arguments.checkedValues = arguments.checkedValue;
		StructDelete(arguments, "checkedValue");
		return $tagGroup(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="checkBoxTagGroup" returntype="string" access="public" output="false" hint="Builds and returns a string for a group of check boxes and labels. If you pass in [value] to any of the arguments that get appplied to each individual check boxes (`append` for example), it will be replaced by the real value in the current iteration. You can pass in different `prepend`, `append` etc arguments by using a list."
	examples=
	'
		<cfset languages = StructNew()>
		<cfset languages.js = "JavaScript">
		<cfset languages.cfml = "ColdFusion">
		<cfset languages.css = "CSS">
		<cfset languages.html = "HTML">
		<cfoutput>
			##checkBoxTagGroup(name="lang", values=languages, checkedValues="cfml,css")##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="" functions="checkBoxTag,radioButtonTagGroup">
	<cfargument name="name" type="string" required="true" hint="@textFieldTag.">
	<cfargument name="values" type="struct" required="true" hint="Values to populate">
	<cfargument name="checkedValues" type="string" required="false" hint="The values of the check boxes that should be checked.">
	<cfargument name="order" type="string" required="false" hint="@radioButtonTagGroup.">
	<cfargument name="prependToGroup" type="string" required="false" hint="@radioButtonTagGroup.">
	<cfargument name="appendToGroup" type="string" required="false" hint="@radioButtonTagGroup.">
	<cfargument name="label" type="string" required="false" hint="@textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="@textField.">
	<cfargument name="prepend" type="string" required="false" hint="@textField.">
	<cfargument name="append" type="string" required="false" hint="@textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="@textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="@textField.">
	<cfscript>
		$args(name="checkBoxTagGroup", args=arguments);
		arguments.input = "checkBoxTag";
		return $tagGroup(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="labelTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a label. Note: Pass any additional arguments like `class` and `rel`, and the generated tag will also include those values as HTML attributes."
	examples=
	'
		<!--- Basic usage usually involves a `label`, `name`, and `value` --->
		<cfoutput>
		    ##labelTag(for="search", value="")##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="for" type="string" required="true" hint="Name to populate in tag's `name` attribute.">
	<cfargument name="value" type="string" required="false" default="" hint="Value to populate in tag's `value` attribute.">
	<cfscript>
		var loc = {};
		$args(name="labelTag", args=arguments);
		arguments.property = arguments.for;
		arguments.objectName = {};
		arguments.objectName[arguments.for] = arguments.value;
		arguments.label = arguments.value;
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = arguments.for;	
		}
		StructDelete(arguments, "for");
		StructDelete(arguments, "value");
		loc.returnValue = this.label(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$tagGroup" returntype="string" access="public" output="false">
	<cfargument name="input" type="string" required="true">
	<cfscript>
		var loc = {};
		
		loc.input = arguments.input;
		StructDelete(arguments, "input");

		// create a base struct that we'll pass along to the individual radio buttons removing the arguments that only apply to the group as a whole
		loc.baseArgs = Duplicate(arguments);
		StructDelete(loc.baseArgs, "values");
		StructDelete(loc.baseArgs, "checkedValues");
		StructDelete(loc.baseArgs, "order");
		StructDelete(loc.baseArgs, "prependToGroup");
		StructDelete(loc.baseArgs, "appendToGroup");
		
		// sort keys alphabeticallty unless the developer has passed in the keys
		if (!Len(arguments.order))
			arguments.order = ArrayToList(StructSort(arguments.values, "textnocase"));

		loc.returnValue = arguments.prependToGroup;
		loc.iEnd = ListLen(arguments.order);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.key = ListGetAt(arguments.order, loc.i);
			
			// create struct from the base struct but then apply the individual changes such as the value and if it should be checked
			loc.args = Duplicate(loc.baseArgs);
			if (ListFindNoCase(arguments.checkedValues,loc.key))
				loc.args.checked = true;
			else			
				loc.args.checked = false;
			loc.args.value = LCase(loc.key);
			
			// the arguments below can be passed in as lists so we'll have to use the value from the corresponding list position
			loc.listArgs = "label,labelPlacement,prepend,append,prependToLabel,appendToLabel";
			loc.jEnd = ListLen(loc.listArgs);
			for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
			{
				loc.item = ListGetAt(loc.listArgs, loc.j);
				if (ListLen(loc.args[loc.item]) >= loc.i)
					loc.args[loc.item] = ListGetAt(loc.args[loc.item], loc.i);
				
				// replace [key] and [value] with the real key and value
				loc.args[loc.item] = ReplaceNoCase(loc.args[loc.item], "[key]", loc.args.value, "all");
				loc.args[loc.item] = ReplaceNoCase(loc.args[loc.item], "[value]", arguments.values[loc.key], "all");
			}

			loc.returnValue &= $invoke(method=loc.input, invokeArgs=loc.args);
		}
		loc.returnValue &= arguments.appendToGroup;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>