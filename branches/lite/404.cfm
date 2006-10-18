<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>Page not found</title>

<cfoutput>
	<link href="#application.pathTo.stylesheets#/wheels.css" rel="stylesheet" media="all" type="text/css" />
</cfoutput>
  
</head>

<body id="404">

<div id="content">
	
	<cfoutput>
		<h1>Page not found</h1>
		
		<p>The page you were looking for was not found. This is usually called a 404 error. This could be because
		the URL was typed incorrectly, or there is a bad link on the site.</p>
		
		<h3>Next Steps</h3>
		
		<p>This page doesn't exist, but here are a couple of things you can try:</p>
		<ul>
			<li>If you typed in the address to this page, double check that it was typed correctly</li>
			<li><a href="##" onclick="history.go(-1); return false;">Go back</a> to the last page you were on</li>
			<li>Go to the <a href="/">homepage</a> of this site</li>
			<li>Head to your favorite <a href="http://www.google.com">search engine</a></li>
			<li><a href="webmaster@localhost.com">Notify the webmaster</a> of the site that he has a broken page</li>
		</ul>
	</cfoutput>
</div>

</body>
</html>