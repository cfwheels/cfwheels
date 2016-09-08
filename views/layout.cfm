<!--- Place HTML here that should be used as the default layout of your application. --->
<html>
  <head>
    <cfoutput>#csrfMetaTags()#</cfoutput>
  </head>

	<body>
		<cfoutput>
		#flashMessages()#
		#includeContent()#
		</cfoutput>
	</body>
</html>
