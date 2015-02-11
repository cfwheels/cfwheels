<cfoutput>

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