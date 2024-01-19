<!---
	HTML template for Code Coverage reporter.  Includes details about SonarQube generation, overview stats, and a passthrough reporter
 --->
<cfoutput>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="generator" content="TestBox v#testbox.getVersion()#">
		<title>Pass: #results.getTotalPass()# Fail: #results.getTotalFail()# Errors: #results.getTotalError()#</title>
	</head>
	<body>
		<cfif len( sonarQubeResults ) >
			#sonarQubeResults#<br><br>
		</cfif>
		
		<cfif len( opts.browser.outputDir ) >
			Coverage Browser generated in #opts.browser.outputDir#<br><br>
		</cfif>
				
		#statsHTML#
		
		#nestedReporterResult#	
	</body>
</html>

</cfoutput>