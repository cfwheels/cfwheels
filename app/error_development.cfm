<!--- This is the page that will be displayed when a Wheels error is thrown in development mode --->

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
	
	<h1>ColdFusion on Wheels Error</h1>
	
	<cfoutput>
		<cfif isDefined("cfcatch.message") AND cfcatch.message IS NOT "">
			<h3>#cfcatch.message#</h3>
		</cfif>
		<cfif isDefined("cfcatch.detail") AND cfcatch.detail IS NOT "">
			<h4><strong>To fix this error:</strong> <br />#cfcatch.detail#</h4>
		</cfif>
		
		<ul id="variables">
			<cfif isDefined("CGI.script_name") AND CGI.script_name IS NOT ""><li><strong>Page:</strong><br />#CGI.script_name#</li></cfif>
			<cfif isDefined("CGI.query_string") AND CGI.query_string IS NOT ""><li><strong>Query String:</strong><br />#CGI.query_string#</li></cfif>
			<cfif isDefined("CGI.http_referer") AND CGI.http_referer IS NOT ""><li><strong>Referer:</strong><br />#CGI.http_referer#</li></cfif>
			<cfif isDefined("CGI.remote_addr") AND CGI.remote_addr IS NOT ""><li><strong>IP Address:</strong><br />#CGI.remote_addr#</li></cfif>
			<cfif isDefined("CGI.http_user_agent") AND CGI.http_user_agent IS NOT ""><li><strong>User Agent:</strong><br />#CGI.http_user_agent#</li></cfif>
			<cfif isDefined("cfcatch.NativeErrorCode") AND cfcatch.NativeErrorCode IS NOT ""><li><strong>Native Error Code:</strong><br />#cfcatch.NativeErrorCode#</li></cfif>
			<cfif isDefined("cfcatch.SQLState") AND cfcatch.SQLState IS NOT ""><li><strong>SQL State:</strong><br />#cfcatch.SQLState#</li></cfif>
			<cfif isDefined("cfcatch.Sql") AND cfcatch.Sql IS NOT ""><li><strong>SQL:</strong><br />#cfcatch.Sql#</li></cfif>
			<cfif isDefined("cfcatch.queryError") AND cfcatch.queryError IS NOT ""><li><strong>Query Error:</strong><br />#cfcatch.queryError#</li></cfif>
			<cfif isDefined("cfcatch.where") AND cfcatch.where IS NOT ""><li><strong>Where:</strong><br />#cfcatch.where#</li></cfif>
			<cfif isDefined("cfcatch.ErrNumber") AND cfcatch.ErrNumber IS NOT 0><li><strong>Error Number:</strong><br />#cfcatch.ErrNumber#</li></cfif>
			<cfif isDefined("cfcatch.MissingFileName") AND cfcatch.MissingFileName IS NOT ""><li><strong>Missing File Name:</strong><br />#cfcatch.MissingFileName#</li></cfif>
			<cfif isDefined("cfcatch.LockName") AND cfcatch.LockName IS NOT ""><li><strong>Lock Name:</strong><br />#cfcatch.LockName#</li></cfif>
			<cfif isDefined("cfcatch.LockOperation") AND cfcatch.LockOperation IS NOT ""><li><strong>Lock Operation:</strong><br />#cfcatch.LockOperation#</li></cfif>
			<cfif isDefined("cfcatch.ErrorCode") AND cfcatch.ErrorCode IS NOT ""><li><strong>Error Code:</strong><br />#cfcatch.ErrorCode#</li></cfif>
			<cfif isDefined("cfcatch.ExtendedInfo") AND cfcatch.ExtendedInfo IS NOT ""><li><strong>Extended Info:</strong><br />#cfcatch.ExtendedInfo#</li></cfif>
		</ul>
		
		<cfif isDefined("cfcatch.stackTrace") AND cfcatch.stackTrace IS NOT "">
		<h3>Stack trace</h3>
		<code id="stack_trace" class="block">
			#cfcatch.stackTrace#
		</code>
		</cfif>
	</cfoutput>
</div>

</body>
</html>