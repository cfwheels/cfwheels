<cfoutput>
<cfheader statuscode="404">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels - Error 404</title>

<style>
	body {
		background-color: ##FFFFFF; 
		color: ##333333; 
		font-family: Trebuchet MS, Verdana, Arial, Helvetica, sans-serif;
	}
</style>
  
</head>

<body>
	<h1>404 - File not found</h1>
	<p>Find me in <code>/public/404.cfm</code></p>
	<p>In development mode you want to see the controller and action errors, but when in
	production Wheels will display this page if a path isn't correct (because the user
	probably tried an invalid URL).</p>
</body>
</html>
</cfoutput>