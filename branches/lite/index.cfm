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
			<li>Head over to the <a href="/script/index.cfm">Generator</a> to build the framework for your app</li>
		</ul>
		
		<p>To learn more about Wheels:</p>
		<ul>
			<li>Read <a href="##">Building Web Applications with ColdFusion on Wheels</a>, the book</li>
			<li>Visit the online API docs at <a href="http://docs.cfwheels.com">http://docs.cfwheels.com</a></li>
		</ul>
		
		<p>To get involved with the community:</p>
		<ul>
			<li>Visit <a href="http://www.cfwheels.com" title="Go to CFWheels.com">The Official Site</a> and <a href="http://www.cfwheels.com/weblog" title="Go to the CFWheels weblog">Blog</a></li>
			<li>Ask questions and get answers at the <a href="##">CFWheels Google Group</a></li>
		</ul>
		
		<h3>How do I remove this page?</h3>
		<p>First delete it from the root of your site's directory. Then, add a new 
			<dfn title="A route tells Wheels about how your URLs should map to files in your application">route</dfn> 
			(located in <code>#application.pathTo.config#/routes.cfm</code>) to the end of the file to specify a default controller and action:</p>
		
		<code class="block">
			&lt;cfset route.pattern = ""&gt;<br />
			&lt;cfset route.controller = "say"&gt;<br />
			&lt;cfset route.action = "hello"&gt;<br />
			&lt;cfset arrayAppend(routes,duplicate(route))&gt;<br />
			&lt;cfset structClear(route)&gt;<br />
		</code>
	</cfoutput>
</div>

</body>
</html>