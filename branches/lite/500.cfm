<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>Application error</title>

<cfoutput>
	<link href="#application.pathTo.stylesheets#/wheels.css" rel="stylesheet" media="all" type="text/css" />
</cfoutput>
  
</head>

<body id="500">

<div id="content">
	
	<cfoutput>
		<h1>Application Error</h1>
		
		<p>The server encountered an error. This is a potentially serious error and will be fixed soon.</p>
		
		<h3>Next Steps</h3>
		
		<p><a href="##" onclick="history.go(-1); return false;">Go back</a> to the last page you were on</p>
		<ul>
			<li><a href="##" onclick="history.go(-1); return false;">Go back</a> to the last page you were on</li>
		</ul>
		
		<p>To learn more about Wheels:</p>
		<ul>
			<li>Read <a href="##">Building Web Applications with ColdFusion on Wheels</a>, the book</li>
			<li>Visit the online API docs at <a href="http://docs.cfwheels.com">http://docs.cfwheels.com</a></li>
		</ul>
		
	</cfoutput>
</div>

</body>
</html>