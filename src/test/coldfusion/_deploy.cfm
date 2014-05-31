<cfparam name="url.clean" default="false" type="boolean">
<cfparam name="url.build">
<cfoutput>
	<html>
		<head>
		</head>
		<body>
			<cfif url.clean>
				== CLEANING ==
				<br/>
				<!--- Read Directory --->
				<cfdirectory
					action="list"
					directory="#ExpandPath( '.' )#"
					name="qFile"
					/>
				<cfdump var="#qFile#">
				<!--- Loop through file query and delete files --->
				<cfloop query="qFile">
					<cfif
						name eq "#url.build#.war" or
						name eq "_deploy.cfm" or
						name eq "web.config" or
						name eq "CFIDE" or
						name eq "WEB-INF">
						<!--- do nothing, similar to cfcontinue in cf9--->
					<cfelse>
						<cfif type is "file">
							<cfif fileExists("#directory#/#name#")>
								DELETING FILE: "#directory#/#name#"<br/>
								<cfset fileDelete("#directory#/#name#")>
							</cfif>
						<cfelse>
							DELETING DIR: "#directory#/#name#"<br/>
							<cftry>
								<cfdirectory action="delete" directory="#directory#/#name#" recurse="true">
								<cfcatch type="any">
								   FAILED DELETING DIR: "#directory#/#name#"<br/>
								</cfcatch>
							</cftry>
						</cfif>
					</cfif>
				</cfloop>
				== CLEANED ==
				<br/>
			</cfif>
			== DEPLOYING #url.build#.war ==
			<br/>
			<cfzip
				action="unzip"
				file="#ExpandPath( './#url.build#.war' )#"
				destination="#ExpandPath( '.' )#"
				/>
			== DEPLOYED #url.build#.war ==
			<br/>
			<cffile action="append"
				file="#ExpandPath('config/app.cfm')#"
				output="<cfset this.secureJSON = false>">
			== secureJSON successfully disabled on config/app.cfm ==
			<br/>
		</body>
	</html>
</cfoutput>
