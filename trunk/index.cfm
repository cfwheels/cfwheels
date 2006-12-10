<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels</title>

<cfoutput>
	<link href="#application.pathTo.stylesheets#/wheels.css" rel="stylesheet" media="all" type="text/css" />
</cfoutput>
  
</head>

<body id="index">

<div id="content">
	<cfoutput>
		<h1>ColdFusion is on Wheels!</h1>
		
		<h3>Next Steps</h3>
		
		<p>To get started building your app:</p>
		<ul>
			<li>Head over to the <a href="/generator/index.cfm">Generator</a> to build the framework for your app</li>
		</ul>
		
		<p>To learn more about Wheels:</p>
		<ul>
			<li>Visit the <a href="http://www.cfwheels.com">official website</a> to keep up to date on everything related to Wheels</li>
			<li>Go to <a href="http://cfwheels.stikipad.com/docs">the documentation wiki</a> to read tutorials and view the API</li>
			<li>Ask questions and get answers at the <a href="http://groups.google.com/group/cfwheels">Google Group</a></li>
		</ul>
		
		<p>To contribute to the Wheels project:</p>
		<ul>
			<li>Submit bug reports, request new features and download the source code at <a href="http://code.google.com/p/cfwheels/" title="Go to Google Code">Google Code</a></li>
		</ul>
		
		<h3>How do I remove this page?</h3>
		<p>First delete it from the root of your site's directory. Then, add a new 
			<dfn title="A route tells Wheels about how your URLs should map to files in your application">route</dfn> 
			(located in <code>#application.pathTo.config#/routes.ini</code>) to the end of the file to specify a default controller and action:</p>
		
		<code class="block">
			&lt;cfset addRoute(pattern="", controller="say", action="hello")&gt;
		</code>
	</cfoutput>
</div>

</body>
</html>