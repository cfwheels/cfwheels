<cffunction name="contentForLayout" returntype="string" access="public" output="false" hint="View, Helper, Used inside a layout file to output the HTML created in the view.">

	<!---
		EXAMPLES:
		<html>
			<head>
				<title>My Site</title>
			</head>
			<body>
				<cfoutput>
					#contentForLayout()#
				</cfoutput>
			</body>
		</html>

		RELATED:
		 * [UsingLayouts Using Layouts] (chapter)
	--->

	<cfreturn request.wheels.response>
</cffunction>
