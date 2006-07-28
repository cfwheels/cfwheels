<cfoutput>
<cfheader statuscode="500">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels - Error 500</title>

<style>
	body {
		background-color: ##FFFFFF; 
		color: ##333333; 
		font-family: Trebuchet MS, Verdana, Arial, Helvetica, sans-serif;
	}
</style>
  
</head>

<body>
	<h1>500 - Application error</h1>
	<p>Find me in <code>/public/500.cfm</code></p>
	<p>When in production mode, this error will come up if there is a problem with the application other than
		a file (controller or action) not being found (which will display <code>/public/404.cfm</code></p>
</body>
</html>
</cfoutput>