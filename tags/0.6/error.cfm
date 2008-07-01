<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels - Error</title>

<cfoutput>
	<link href="#application.pathTo.stylesheets#/wheels.css" rel="stylesheet" media="all" type="text/css" />
</cfoutput>
  
</head>

<body id="error">

<div id="content">
	
	<h1>CFWheels Error</h1>
	
	<cfoutput>
		<h3>#error.message#</h3>
		<h4><strong>To fix this error:</strong> <br />#error.rootCause.detail#</h4>
		
		<!---
		<ul id="variables">
			<li><strong>Browser:</strong> #error.browser#</li>
			<li><strong>Remote Address:</strong> #error.remoteAddress#</li>
			<li><strong>Referrer:</strong> #error.httpReferer#</li>
			<li><strong>Datetime:</strong> #dateFormat(error.dateTime, 'd mmmm, yyyy')# at #lCase(timeFormat(error.dateTime, 'h:mm:sstt'))#</li>
		</ul>
		--->
		
		<h3>Stack trace</h3>
		<code id="stack_trace" class="block">
			#error.stackTrace#
		</code>
	</cfoutput>
</div>

</body>
</html>