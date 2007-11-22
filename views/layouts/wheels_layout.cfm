<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title></title>
	#styleSheetLinkTag("wheels")#
</head>
<body>
<div id="wrapper">
<div id="content">
<cfif flash()>
	<cfset URL.flash_alert = flash("alert")>
	<cfset URL.flash_notice = flash("notice")>
</cfif>
<cfif (structKeyExists(URL, "flash_alert") AND URL.flash_alert IS NOT "") OR (structKeyExists(URL, "flash_notice") AND URL.flash_notice IS NOT "") OR (structKeyExists(URL, "flash_info") AND URL.flash_info IS NOT "")>
	<cfif structKeyExists(URL, "flash_alert") AND URL.flash_alert IS NOT "">
		<p class="admin-alert">#URL.flash_alert#</p>
	<cfelseif structKeyExists(URL, "flash_notice") AND URL.flash_notice IS NOT "">
		<p class="admin-notice">#URL.flash_notice#</p>
	</cfif>
</cfif>
#contentForLayout()#
</div>
</div>
</body>
</html>
</cfoutput>

