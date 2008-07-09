<cffunction name="capitalize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfif len(arguments.text)>
		<cfreturn uCase(left(arguments.text, 1)) & mid(arguments.text, 2, len(arguments.text)-1)>
	</cfif>
</cffunction>

<cffunction name="titleize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var locals = structNew()>

	<cfset locals.result = "">
	<cfloop list="#arguments.text#" delimiters=" " index="locals.i">
		<cfset locals.result = listAppend(locals.result, capitalize(locals.i), " ")>
	</cfloop>

	<cfreturn locals.result>
</cffunction>

<cffunction name="simpleFormat" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfset var local = structNew()>

	<!--- Replace single newline characters with HTML break tags and double newline characters with HTML paragraph tags --->
	<cfset local.output = trim(arguments.text)>
	<cfset local.output = replace(local.output, "#chr(10)##chr(10)#", "</p><p>", "all")>
	<cfset local.output = replace(local.output, "#chr(10)#", "<br />", "all")>
	<cfif local.output IS NOT "">
		<cfset local.output = "<p>" & local.output & "</p>">
	</cfif>

	<cfreturn local.output>
</cffunction>

<cffunction name="autoLink" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfargument name="link" type="any" required="no" default="all">
	<cfargument name="attributes" type="any" required="no" default="">
	<cfset var local = structNew()>

	<cfset local.url_regex = "(?ix)([^(url=)|(href=)'""])(((https?)://([^:]+\:[^@]*@)?)([\d\w\-]+\.)?[\w\d\-\.]+\.(com|net|org|info|biz|tv|co\.uk|de|ro|it)(( / [\w\d\.\-@%\\\/:]* )+)?(\?[\w\d\?%,\.\/\##!@:=\+~_\-&amp;]*(?<![\.]))?)">
	<cfset local.mail_regex = "(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))">

	<cfif len(arguments.attributes) IS NOT 0>
		<!--- Add a space to the beginning so it can be directly inserted in the HTML link element below --->
		<cfset arguments.attributes = " " & arguments.attributes>
	</cfif>

	<cfset local.output = arguments.text>
	<cfif arguments.link IS NOT "urls">
		<!--- Auto link all email addresses --->
		<!--- <cfset local.output = REReplaceNoCase(local.output, "(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))", "<a href=""mailto:\1""#arguments.attributes#>\1</a>", "all")> --->
		<cfset local.output = REReplaceNoCase(local.output, local.mail_regex, "<a href=""mailto:\1""#arguments.attributes#>\1</a>", "all")>
	</cfif>
	<cfif arguments.link IS NOT "email_addresses">
		<!--- Auto link all URLs --->
		<!--- <cfset local.output = REReplaceNoCase(local.output, "(\b(?:https?|ftp)://(?:[a-z\d-]+\.)+[a-z]{2,6}(?:/\S*)?)", "<a href=""\1""#arguments.attributes#>\1</a>", "all")> --->
		<cfset local.output = local.output.ReplaceAll(local.url_regex, "$1<a href=""$2""#arguments.attributes#>$2</a>")>
	</cfif>

	<cfreturn local.output>
</cffunction>

<cffunction name="highlight" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfargument name="phrase" type="any" required="yes">
	<cfargument name="class" type="any" required="no" default="highlight">
	<cfreturn REReplaceNoCase(arguments.text, "(#arguments.phrase#)", "<span class=""#arguments.class#"">\1</span>", "all")>
</cffunction>

<cffunction name="stripTags" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfreturn REReplaceNoCase(arguments.text, "<[a-z].*?>(.*?)</[a-z]>", "\1" , "all")>
</cffunction>

<cffunction name="stripLinks" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfreturn REReplaceNoCase(arguments.text, "<a.*?>(.*?)</a>", "\1" , "all")>
</cffunction>

<cffunction name="excerpt" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfargument name="phrase" type="any" required="true">
	<cfargument name="radius" type="any" required="false" default="100">
	<cfargument name="excerptString" type="any" required="false" default="...">
	<cfset var local = structNew()>

	<cfset local.pos = findNoCase(arguments.phrase, arguments.text, 1)>
	<cfif local.pos IS NOT 0>
		<cfset local.excerpt_string_start = arguments.excerptString>
		<cfset local.excerpt_string_end = arguments.excerptString>
		<cfset local.start = local.pos-arguments.radius>
		<cfif local.start LTE 0>
			<cfset local.start = 1>
			<cfset local.excerpt_string_start = "">
		</cfif>
		<cfset local.count = len(arguments.phrase)+(arguments.radius*2)>
		<cfif local.count GT (len(arguments.text)-local.start)>
			<cfset local.excerpt_string_end = "">
		</cfif>
		<cfset local.output = local.excerpt_string_start & mid(arguments.text, local.start, local.count) & local.excerpt_string_end>
	<cfelse>
		<cfset local.output = "">
	</cfif>

	<cfreturn local.output>
</cffunction>

<cffunction name="truncate" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfargument name="length" type="any" required="true">
	<cfargument name="truncateString" type="any" required="false" default="...">
	<cfset var local = structNew()>

	<cfif len(arguments.text) GT arguments.length>
		<cfset local.output = left(arguments.text, arguments.length-3) & arguments.truncateString>
	<cfelse>
		<cfset local.output = arguments.text>
	</cfif>

	<cfreturn local.output>
</cffunction>