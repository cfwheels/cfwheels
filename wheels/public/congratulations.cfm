<cfset thisVersion = ListGetAt(get("version"), 1, ".") & "." & ListGetAt(get("version"), 2, ".")>

<cfoutput>

<h1>Congratulations!</h1>
<p><i class="fa fa-check-circle"></i><strong> You have successfully installed<cfif Len(get("version"))> version #get("version")# of</cfif> CFWheels.</strong><br>
Welcome to the wonderful world of CFWheels. We hope you will enjoy it!</p>

<h2>Now What?</h2>
<p>Now that you have a working installation of CFWheels, you may be wondering what to do next. Here are some suggestions.</p>

<div class="row">
	<div class="column">
		<a class="" href="http://docs.cfwheels.org/v#thisVersion#/docs/beginner-tutorial-hello-world">View and code along with our
		&quot;Hello World&quot; tutorial.</a>
	</div>
	<div class="column">
		<a class="" href="http://docs.cfwheels.org/v#thisVersion#/docs">Have a look at the rest of our documentation.</a>
	</div>
	<div class="column">
		<a class="" href="http://groups.google.com/group/cfwheels">Say &quot;Hello!&quot; to everyone in the Google Group.</a>
	</div>
	<div class="column">Build the next killer website on the World Wide Web...</div>
</div>

<p><strong>Good Luck!</strong></p>

<h3>How to Make this Message Go Away</h3>
<p>Want to have another page load when your application loads this URL? You can configure your own <em>home route</em>.</p>
<ol>
	<li>
		<p>Open the routes configuration file at <code>config/routes.cfm</code>.</p>
	</li>
	<li>
		<p>You will see a line similar to this for a route named <code>root</code>:</p>
		<pre><code>drawRoutes().root(to=&quot;wheels####wheels&quot;, method=&quot;get&quot;).end();</code></pre>
	</li>
	<li>
		<p>Simply change the <code>to</code> parameter to specify a <code>controller####action</code> of your choosing.</p>
	</li>
	<li>
		<p>Reload your CFWheels application.</p>
	</li>
</ol>

</cfoutput>
