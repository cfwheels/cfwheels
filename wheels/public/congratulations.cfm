<cfoutput>

<cfset func = "buttonTag">
<cfset isModel = false>

<cfif isModel>
	<cfset set(dataSourceName="wheelstestdb")>
	<cfset model("author")>
	<cfset funcRef = application.wheels.models.author[func]>
<cfelse>
	<cfset funcRef = Evaluate(func)>
</cfif>
<cfset data = GetMetaData(funcRef)>
<cfset list = "name,type,required,default,hint">
<cfset block = "">
<cfloop array="#data.parameters#" index="i">
	<cfif NOT StructKeyExists(i, "default")>
		<cfset i.default = "">
	</cfif>
	<cfif StructKeyExists(application.wheels.functions, func) AND StructKeyExists(application.wheels.functions[func], i.name)>
		<cfset i.default = application.wheels.functions[func][i.name]>
	</cfif>
</cfloop>
<cfif ArrayLen(data.parameters)>
	<cfset block &= "[block:parameters]{""data"":{""h-0"":""Parameter"",""h-1"":""Type"",""h-2"":""Required"",""h-3"":""Default"",""h-4"":""Description"",">
	<cfloop list="#list#" index="i">
		<cfloop from="1" to="#ArrayLen(data.parameters)#" index="j">
			<cfif Left(data.parameters[j].name, 1) IS NOT "$">
				<cfset block &= """#j-1#-#ListFind(list, i)-1#"": ""#data.parameters[j][i]#""">
				<cfif i IS NOT "hint" OR j IS NOT ArrayLen(data.parameters)>
					<cfset block &= ",">
				</cfif>
			</cfif>
		</cfloop>
	</cfloop>
	<cfset block &= "},""cols"":5,""rows"":#ArrayLen(data.parameters)#">
	<cfset block &= "}[/block]">
	<cfset block = Replace(block, "[runtime expression]", "", "all")>
	<cfset block = REReplaceNoCase(block, "@([a-z]*)", "[\1](doc:\L\1)", "all")>
</cfif>
#data.name#
<hr>
#data.hint#
<hr>
#block#
<hr>

<h1>Congratulations!</h1>
<p><strong>You have successfully installed<cfif Len(get("version"))> version #get("version")# of</cfif> CFWheels.</strong><br>
Welcome to the wonderful world of CFWheels. We hope you will enjoy it!</p>

<h2>Now What?</h2>
<p>Now that you have a working installation of CFWheels, you may be wondering what to do next. Here are some suggestions.</p>
<ul>
	<li><a href="http://cfwheels.org/docs/#Replace(Left(get("version"), 3), ".", "-")#/chapter/hello-world">View and code along with our "Hello World" tutorial.</a></li>
	<li><a href="http://cfwheels.org/docs/#Replace(Left(get("version"), 3), ".", "-")#">Have a look at the rest of our documentation.</a></li>
	<li><a href="http://groups.google.com/group/cfwheels">Say "Hello!" to everyone in the Google Group.</a></li>
	<li>Build the next killer website on the World Wide Web...</li>
</ul>
<p><strong>Good Luck!</strong></p>

<h2>How to Make this Message Go Away</h2>
<p>Want to have another page load when your application loads this URL? You can configure your own <em>home route</em>.</p>
<ol>
	<li>
		<p>Open the routes configuration file at <code>config/routes.cfm</code>.</p>
	</li>
	<li>
		<p>You will see a line similar to this for a route named <code>home</code>:</p>
		<pre><code>addRoute(name="home", pattern="", controller="wheels", action="wheels");</code></pre>
	</li>
	<li>
		<p>Simply change the <code>controller</code> and <code>action</code> arguments to a controller and action of your choosing.</p>
	</li>
	<li>
		<p>Reload your CFWheels application.</p>
	</li>
</ol>

</cfoutput>