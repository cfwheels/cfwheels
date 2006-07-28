<cfsetting enablecfoutputonly="false">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels Generator</title>

<cfif fileExists(expandPath('/dispatch.cfc'))>
	<script type="text/javascript" src="<cfoutput>#application.pathTo.javascripts#</cfoutput>/prototype.js"></script>
	<script type="text/javascript" src="<cfoutput>#application.pathTo.javascripts#</cfoutput>/scriptaculous.js"></script>
</cfif>

<script type="text/javascript">
	function beforeUpdate() {
		
		document.getElementById('submit').disabled = true;
		
		indicator = document.getElementById('indicator');
		if(indicator.className = 'hide') {
			indicator.className = 'show';
		} else {
			indicator.className = 'hide';
		}
		
	}
	
	function afterUpdate() {
		document.getElementById('submit').disabled = false;
		
		indicator = document.getElementById('indicator');
		if(indicator.className = 'hide') {
			indicator.className = 'show';
		} else {
			indicator.className = 'hide';
		}
	}
	
	function showGenerator() {
		document.getElementById('generator').className = 'show';
		document.getElementById('generateSkeleton').className = 'hide';
	}
		
</script>

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
	
	div#results {
		background-color: #DDDDDD;
		clear: both;
		width: 95%;
		margin: 0 .25em;
		padding: .5em;
	}
	
	div#scaffolds {
		background-color: #CCCCCC;		
	}
	
	div#result {
		background-color: #FFFFFF;
		padding: .5em;
		font-size: 80%;
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

	<cfif fileExists(expandPath('/dispatch.cfc'))>
		<cfset generatorClass = "show">
		<cfset skeletonClass = "hide">
	<cfelse>
		<cfset generatorClass = "hide">
		<cfset skeletonClass = "show">
	</cfif>
	
	<cfoutput>
	
		<div id="generator" class="#generatorClass#">
			<div id="controllers" class="column">
				<h2>Controllers</h2>
				<p>Using the form below you can generate new controllers and related actions/views.  It will create
					a controller, layout, helper and any views you specify. <strong>Separate action names with a comma.</strong></p>
					
				<form name="formControllers" id="formControllers" onsubmit="new Ajax.Updater('result','/script/script.cfc?method=generate', {asynchronous:true, evalScripts:true, onComplete:function(){ new Effect.Highlight('result'); }, parameters:Form.serialize(this)}); return false;">
					<input type="hidden" name="type" value="controller" />
					<label for="controller_name">Controller Name</label>
					<input type="textbox" id="controller_name" name="controller_name" />
					<label for="action_name">Action Name(s)</label>
					<input type="textbox" id="action_name" name="action_name" />
					<input type="submit" name="controller_submit" id="controller_submit" value="Generate" />
				</form>
			</div>
			
			<div id="models" class="column">
				<h2>Models</h2>
				<p>The form below will build the basic component files needed for a model. It will assume that your table
					name is the plural of your model name.  If this is not true you will need to manually edit the model file
					created by this form (in /app/models). <strong>Model names should be singular ('product')</strong></p>
				<form name="formModel" id="formModel" method="post" onsubmit="new Ajax.Updater('result','/script/script.cfc?method=generate', {asynchronous:true, evalScripts:true, onComplete:function(){ new Effect.Highlight('result'); }, parameters:Form.serialize(this)}); return false;">
					<input type="hidden" name="type" value="model" />
					<label for="model_name">Model Name</label>
					<input type="textbox" id="model_name" name="model_name" />
					<input type="submit" name="model_submit" id="model_submit" value="Generate" />
				</form>
			</div>
			
			<div id="scaffolds" class="column">
				<h2>Scaffolds</h2>
				<p>Scaffolds create everything you need to get data in and out of a table in your database.
					This form will create a model, controller and several associated views. 
					<strong>Your database must be configured before a scaffold can be built (see /config/database.cfm)</strong></p>

				<form name="formScaffold" id="formScaffold" method="post" onsubmit="new Ajax.Updater('result','/script/script.cfc?method=generate', {asynchronous:true, evalScripts:true, onComplete:function(){ new Effect.Highlight('result'); }, parameters:Form.serialize(this)}); return false;">
					<input type="hidden" name="type" value="scaffold" />
					<label for="controller_name">Controller Name</label>
					<input type="textbox" id="controller_name" name="controller_name" />
					<label for="model_name">Model Name</label>
					<input type="textbox" id="model_name" name="model_name" />
					<input type="submit" name="scaffold_submit" id="scaffold_submit" value="Generate" />
				</form>
			</div>
		</div>
	
		<div id="generateSkeleton" class="#skeletonClass#">
			<p>It appears that you are creating a new application. Have Wheels create your application skeleton by clicking the button below.</p>
			<form name="formSkeleton" id="formSkeleton" method="post" action="/script/script.cfc">
				<input type="hidden" name="method" value="generate" />
				<input type="hidden" name="type" value="skeleton" />
				<input type="submit" name="skeleton_submit" id="skeleton_submit" value="Create Application Skeleton" />
			</form>
		</div>
	
	</cfoutput>
	
	<div id="results">
		<h2>Log</h2>
		<div id="result"></div>
	</div>
	
</body>
</html>

<!---
   Copyright 2006 Rob Cameron

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->