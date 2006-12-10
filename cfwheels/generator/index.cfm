<cfsetting enablecfoutputonly="false">

<cfif structKeyExists(form,'controller_submit')>
	<cfset variables.generator = createObject("component","cfwheels.generator.engine")>
	<cfset variables.results = variables.generator.generate(type=form.type,controller_name=form.controller_name,action_name=form.action_name)>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels Generator</title>

<cfoutput>
	<link href="#application.pathTo.stylesheets#/wheels.css" rel="stylesheet" media="all" type="text/css" />
</cfoutput>

</head>

<body id="generator">
	
<div id="content">
	
	<h1>CF Wheels Generator</h1>
	<p>The Generator assists in your application development by automating tasks for you. It creates the basic structure of the files you use
		while building a Wheels application.</p>

	<cfoutput>
	
		<div id="generator">
			<div id="controllers" class="generator_group">
				<h3>Controllers</h3>
				<p>Using the form below you can generate new controllers and related actions/views.  It will create
					a controller, layout, helper and any views you specify. <strong>Separate action names with a comma.</strong></p>
					
				<form name="formControllers" id="formControllers" action="/generator/index.cfm" method="post">
					<input type="hidden" name="type" value="controller" />
					<label for="controller_name">Controller Name</label>
					<input type="textbox" id="controller_name" name="controller_name" />
					<label for="action_name">Action Name(s)</label>
					<input type="textbox" id="action_name" name="action_name" />
					<input type="submit" name="controller_submit" id="controller_submit" value="Generate" class="button" />
				</form>
			</div>
			
			<cfif structKeyExists(variables,'results')>
				<div id="result" class="column">
					<span class="title">The following files were generated:</span>
					#variables.results#
				</div>
			</cfif>
			
		</div>
	
	</cfoutput>
	
</div>

</body>
</html>