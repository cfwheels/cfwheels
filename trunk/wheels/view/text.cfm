<cffunction name="capitalize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfif len(arguments.text)>
		<cfreturn uCase(left(arguments.text, 1)) & mid(arguments.text, 2, len(arguments.text)-1)>
	</cfif>
</cffunction>

<cffunction name="titleize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var loc = structNew()>

	<cfset loc.result = "">
	<cfloop list="#arguments.text#" delimiters=" " index="loc.i">
		<cfset loc.result = listAppend(loc.result, capitalize(loc.i), " ")>
	</cfloop>

	<cfreturn loc.result>
</cffunction>

<cffunction name="simpleFormat" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfset var loc = structNew()>

	<!--- Replace single newline characters with HTML break tags and double newline characters with HTML paragraph tags --->
	<cfset loc.output = trim(arguments.text)>
	<cfset loc.output = replace(loc.output, "#chr(10)##chr(10)#", "</p><p>", "all")>
	<cfset loc.output = replace(loc.output, "#chr(10)#", "<br />", "all")>
	<cfif loc.output IS NOT "">
		<cfset loc.output = "<p>" & loc.output & "</p>">
	</cfif>

	<cfreturn loc.output>
</cffunction>

<cffunction name="autoLink" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfargument name="link" type="any" required="no" default="all">
	<cfargument name="attributes" type="any" required="no" default="">
	<cfset var loc = structNew()>

	<cfset loc.urlRegex = "(?ix)([^(url=)|(href=)'""])(((https?)://([^:]+\:[^@]*@)?)([\d\w\-]+\.)?[\w\d\-\.]+\.(com|net|org|info|biz|tv|co\.uk|de|ro|it)(( / [\w\d\.\-@%\\\/:]* )+)?(\?[\w\d\?%,\.\/\##!@:=\+~_\-&amp;]*(?<![\.]))?)">
	<cfset loc.mailRegex = "(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))">

	<cfif len(arguments.attributes) IS NOT 0>
		<!--- Add a space to the beginning so it can be directly inserted in the HTML link element below --->
		<cfset arguments.attributes = " " & arguments.attributes>
	</cfif>

	<cfset loc.output = arguments.text>
	<cfif arguments.link IS NOT "urls">
		<!--- Auto link all email addresses --->
		<cfset loc.output = REReplaceNoCase(loc.output, loc.mailRegex, "<a href=""mailto:\1""#arguments.attributes#>\1</a>", "all")>
	</cfif>
	<cfif arguments.link IS NOT "emails">
		<!--- Auto link all URLs --->
		<cfset loc.output = loc.output.ReplaceAll(loc.urlRegex, "$1<a href=""$2""#arguments.attributes#>$2</a>")>
	</cfif>

	<cfreturn loc.output>
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
	<cfset var loc = structNew()>

	<cfset loc.pos = findNoCase(arguments.phrase, arguments.text, 1)>
	<cfif loc.pos IS NOT 0>
		<cfset loc.excerptStringStart = arguments.excerptString>
		<cfset loc.excerptStringEnd = arguments.excerptString>
		<cfset loc.start = loc.pos-arguments.radius>
		<cfif loc.start LTE 0>
			<cfset loc.start = 1>
			<cfset loc.excerptStringStart = "">
		</cfif>
		<cfset loc.count = len(arguments.phrase)+(arguments.radius*2)>
		<cfif loc.count GT (len(arguments.text)-loc.start)>
			<cfset loc.excerptStringEnd = "">
		</cfif>
		<cfset loc.output = loc.excerptStringStart & mid(arguments.text, loc.start, loc.count) & loc.excerptStringEnd>
	<cfelse>
		<cfset loc.output = "">
	</cfif>

	<cfreturn loc.output>
</cffunction>

<cffunction name="truncate" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfargument name="length" type="any" required="true">
	<cfargument name="truncateString" type="any" required="false" default="...">
	<cfset var loc = structNew()>

	<cfif len(arguments.text) GT arguments.length>
		<cfset loc.output = left(arguments.text, arguments.length-3) & arguments.truncateString>
	<cfelse>
		<cfset loc.output = arguments.text>
	</cfif>

	<cfreturn loc.output>
</cffunction>