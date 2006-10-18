<cfsetting enablecfoutputonly="false">

<cfif isDefined('form.controller_submit')>
	<cfset generator = createObject("component","script.generator")>
	<cfset results = generator.generate(type=form.type,controller_name=form.controller_name,action_name=form.action_name)>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels Generator</title>

<style type="text/css" media="all">
	body {
		font-family: Trebuchet MS, Verdana, Arial, sans-serif;
		font-size: 1em;
		line-height: 1.2em;
	}
	
	h1 {
		font-size: 200%;
		font-weight: bold;
	}
	
	a {
		color: #990000;
	}
	a:hover {
		color: #FFFFFF;
		background-color: #990000;
		text-decoration: none;
	}
	
	.show {
		}
		
	.hide {
		display: none;
		}
	
	div#controllers {
		background-color: #EEEEEE;		
	}
	
	div#models {
		background-color: #DDDDDD;		
	}
	
	div#scaffolds {
		background-color: #CCCCCC;		
	}
	
	div#result {
		font-size: 90%;
		}
	
	div#result span.title {
		font-weight: bold;
		}
	
	div.column {
		width: 30%;
		float: left;
		margin: 1em .25em;
		padding: .5em;
	}
	
	input {
		display: block;
		width: 12em;
		margin-bottom: 1em;
		font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif;
	}
	
	label {
		font-size: 90%;
		color: #666666;
	}
	
	div#generateSkeleton {
		width: 400px;
		padding: 2em;
		background-color: #FFFFCC;
		text-align: center;
		margin: 2em auto;
		border: 3px solid #FFCC99;
		}
		
	div#generateSkeleton p.small {
		font-size: 80%;
		color: #999999;
		}
		
	div#generateSkeleton input#skeleton_submit { 
		padding: .5em;
		width: 300px;
		margin: 0 auto;
		}
	
</style>

</head>

<body>

	<div style="text-align:center;float:left;margin-right:1em;">
		<img src="http://www.cfwheels.com/images/logo.png" alt="CFWheels Logo" />
	</div>
	
	<h1>CF Wheels Generator</h1>
	<p>The Generator assists in your application development by automating tasks for you. It creates the basic structure of the files you use
		while building a Wheels application.</p>

	<cfoutput>
	
		<div id="generator">
			<div id="controllers" class="column">
				<h2>Controllers</h2>
				<p>Using the form below you can generate new controllers and related actions/views.  It will create
					a controller, layout, helper and any views you specify. <strong>Separate action names with a comma.</strong></p>
					
				<form name="formControllers" id="formControllers" action="/script/index.cfm" method="post">
					<input type="hidden" name="type" value="controller" />
					<label for="controller_name">Controller Name</label>
					<input type="textbox" id="controller_name" name="controller_name" />
					<label for="action_name">Action Name(s)</label>
					<input type="textbox" id="action_name" name="action_name" />
					<input type="submit" name="controller_submit" id="controller_submit" value="Generate" />
				</form>
			</div>
			
			<cfif isDefined('results')>
				<div id="result" class="column">
					<span class="title">The following files were generated:</span>
					#results#
				</div>
			</cfif>
			
		</div>
	
	</cfoutput>
	
</body>
</html>