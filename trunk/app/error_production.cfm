<!--- This is the page that will be displayed when an error occurs in production mode --->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta name="Description" content="" />
	<meta name="Keywords" content="" />
	<title>SingSnap</title>
	<link rel="stylesheet" href="/media/stylesheets/singsnap_feb_7.css" type="text/css" media="all" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />	
</head>
<body style="background: none;">

<div id="wrapper">

<div id="content" style="margin-top: 15px;"> 

<p class="message alert">Oops, that seems to have caused an unexpected error...</p>

<p style="font-weight: bold; text-align: center;">An automatic email has already been sent to notify us of this problem you encountered. If you want to give us more details about what happened or want to be notified as soon as the problem is fixed then you can just drop us an email at <a href="mailto:support@singsnap.com">support@singsnap.com</a>.</p>
<p style="font-weight: bold; text-align: center;">Thank you and sorry for the inconvenience!</p>

</div>

</div>
<cfoutput>
<!-- 
<cfif isDefined("cfcatch.type") AND cfcatch.type IS NOT "">Type:#cfcatch.type#</cfif>
<cfif isDefined("cfcatch.message") AND cfcatch.message IS NOT "">Message:#cfcatch.message#</cfif>
<cfif isDefined("cfcatch.detail") AND cfcatch.detail IS NOT "">Detail:#cfcatch.detail#</cfif>
<cfif isDefined("CGI.script_name") AND CGI.script_name IS NOT "">Page:#CGI.script_name#</cfif>
<cfif isDefined("CGI.query_string") AND CGI.query_string IS NOT "">Query String:#CGI.query_string#</cfif>
<cfif isDefined("CGI.http_referer") AND CGI.http_referer IS NOT "">Referer:#CGI.http_referer#</cfif>
<cfif isDefined("CGI.remote_addr") AND CGI.remote_addr IS NOT "">IP Address:#CGI.remote_addr#</cfif>
<cfif isDefined("CGI.http_user_agent") AND CGI.http_user_agent IS NOT "">User Agent:#CGI.http_user_agent#</cfif>
<cfif isDefined("cfcatch.NativeErrorCode") AND cfcatch.NativeErrorCode IS NOT "">Native Error Code:#cfcatch.NativeErrorCode#</cfif>
<cfif isDefined("cfcatch.SQLState") AND cfcatch.SQLState IS NOT "">SQL State:#cfcatch.SQLState#</cfif>
<cfif isDefined("cfcatch.Sql") AND cfcatch.Sql IS NOT "">SQL:#cfcatch.Sql#</cfif>
<cfif isDefined("cfcatch.queryError") AND cfcatch.queryError IS NOT "">Query Error:#cfcatch.queryError#</cfif>
<cfif isDefined("cfcatch.where") AND cfcatch.where IS NOT "">Where:#cfcatch.where#</cfif>
<cfif isDefined("cfcatch.ErrNumber") AND cfcatch.ErrNumber IS NOT 0>Error Number:#cfcatch.ErrNumber#</cfif>
<cfif isDefined("cfcatch.MissingFileName") AND cfcatch.MissingFileName IS NOT "">Missing File Name:#cfcatch.MissingFileName#</cfif>
<cfif isDefined("cfcatch.LockName") AND cfcatch.LockName IS NOT "">Lock Name:#cfcatch.LockName#</cfif>
<cfif isDefined("cfcatch.LockOperation") AND cfcatch.LockOperation IS NOT "">Lock Operation:#cfcatch.LockOperation#</cfif>
<cfif isDefined("cfcatch.ErrorCode") AND cfcatch.ErrorCode IS NOT "">Error Code:#cfcatch.ErrorCode#</cfif>
<cfif isDefined("cfcatch.ExtendedInfo") AND cfcatch.ExtendedInfo IS NOT "">Extended Info:#cfcatch.ExtendedInfo#</cfif>
 -->
</cfoutput>
</body>
</html>