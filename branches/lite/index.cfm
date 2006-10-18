<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels</title>

<style>
	body {
		background-color: #DDDDDD; 
		color: #333333; 
		font-family: Trebuchet MS, Verdana, Arial, Helvetica, sans-serif;
		padding: 0;
		margin: 0;
		}
		
    div#content { 
		width: 600px;
		margin: 0 auto 2em;
		padding: 2em;
		background-color: #FFFFFF;
		border: 3px solid #999999;
		border-width: 0 3px 3px;
		font-size: 1em;
		line-height: 1.4em;
		}
	
	h1 {
		margin: 0;
		line-height: 1.2;
		font-size: 260%;
		}
		
	h3 {
		font-size: 130%;
		padding-bottom: .2em;
		margin-top: 1.5em;
		border-bottom: 1px dotted #999999;
		}
		
	a {
		color: #990000;
		text-decoration: underline;
		}
		
	a:hover {
		color: #FFFFFF;
		background-color: #990000;
		text-decoration: none;
		}
		
	dfn {
		text-variant: none;
		border-bottom: 1px dotted #666666;
		cursor: help;
		}
		
	code.block {
		display: block;
		margin: 0;
		padding: 0 1em;
		line-height: 1;
		}
</style>
  
</head>

<body>

<div id="content">
	
	<h1>ColdFusion is on Wheels!</h1>
	
	<h3>Next Steps</h3>
	
	<p>To get started building your app:</p>
	<ul>
		<li>Head over to the <a href="/script/index.cfm">Generator</a> to build the framework for your app</li>
	</ul>
	
	<p>To learn more about Wheels:</p>
	<ul>
		<li>Read <a href="#">Building Web Applications with ColdFusion on Wheels</a>, the book</li>
		<li>Visit the online API docs at <a href="http://docs.cfwheels.com">http://docs.cfwheels.com</a></li>
	</ul>
	
	<p>To get involved with the community:</p>
	<ul>
		<li>Visit <a href="http://www.cfwheels.com" title="Go to CFWheels.com">The Official Site</a> and <a href="http://www.cfwheels.com/weblog" title="Go to the CFWheels weblog">Blog</a></li>
		<li>Ask questions and get answers at the <a href="#">CFWheels Google Group</a></li>
	</ul>
	
	<h3>How do I remove this page?</h3>
	<p>First delete it from the root of your site's directory. Then, add a new 
		<dfn title="A route tells Wheels about how your URLs should map to files in your application">route</dfn> 
		(located in <code>/config/routes.cfm</code>) to the end of the file to specify a default controller and action:</p>
	
	<code class="block">
		&lt;cfset route.pattern = ""&gt;<br />
		&lt;cfset route.controller = "say"&gt;<br />
		&lt;cfset route.action = "hello"&gt;<br />
		&lt;cfset arrayAppend(routes,duplicate(route))&gt;<br />
		&lt;cfset structClear(route)&gt;<br />
	</code>
</div>

</body>
</html>