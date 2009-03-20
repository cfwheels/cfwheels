<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9.1">
		<cfreturn this>
	</cffunction>

	<cffunction name="mailTo" returntype="string" access="public" output="false" hint="Creates a mailto link tag to the specified email address, which is also used as the name of the link unless name is specified.">
		<cfargument name="emailAddress" type="string" required="true" hint="The email address to link to">
		<cfargument name="name" type="string" required="false" default="" hint="A string to use as the link text ('Joe' or 'Support Department' for example)">
		<cfargument name="encode" type="boolean" required="false" default="false" hint="Pass true here to encode the email address, making it harder for bots to harvest it">
	
		<!---
			#mailTo("support@mysite.com")#
			#mailTo(emailAddress="support@mysite.com", name="Website Support", encode=true)#
		--->
	
		<cfscript>
			var loc = {};
			arguments.href = "mailto:#arguments.emailAddress#";
			if (Len(arguments.name))
				loc.text = arguments.name;
			else
				loc.text = arguments.emailAddress;
			arguments.$namedArguments = "emailAddress,name,encode";
			loc.attributes = $getAttributes(argumentCollection=arguments);
			loc.returnValue = "<a" & loc.attributes & ">" & loc.text & "</a>";
			if (arguments.encode)
			{
				loc.js = "document.write('#Trim(loc.returnValue)#');";
				loc.encoded = "";
				loc.iEnd = Len(loc.js);
				for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
				{
					loc.encoded = loc.encoded & "%" & Right("0" & FormatBaseN(Asc(Mid(loc.js,loc.i,1)),16),2);
				}
				loc.returnValue = "<script type=""text/javascript"">eval(unescape('#loc.encoded#'))</script>";
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

</cfcomponent>