<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>ColdFusion on Wheels</title>

<style>
	body {
		background-color: ##FFFFFF; 
		color: ##333333; 
		font-family: Trebuchet MS, Verdana, Arial, Helvetica, sans-serif;
	}
    div##content { 
		font-size: 1em;
		line-height: 1.4em;
	}
</style>
  
</head>

<body>
	
<h1>Congratulations, you've put ColdFusion on Wheels!</h1>

<div id="content">
	
	<h3>Now what do I do?</h3>
	<p>First, read some of the <a href="http://www.cfwheels.com/documentation" title="Documentation">online documentation</a>, then:</p>
	<ol>
		<li>Open up the <a href="/script" title="Go to the CFW Generator">Script page</a> and open the <strong>CFWheels Generator</strong> in your browser (by default, somewhere like <code>http://localhost/script</code>)</li>
		<li>Use the Generator to create a controller and some associated actions</li>
		<li>Start putting some processing code in your controller and display code in your views and you're off and running!</li>
	</ol>
	
	<h3>How about some instant gratification?</h3>
	<p>All right, try this:</p>
	<ol>
		<li>Get to the <a href="/script" title="Go to the CFW Generator">CFWheels Generator</a>.  Enter "say" as your controller name and "index" as the action name.  Click generate.</li>
		<li>Open up <code>/app/controllers/say_controller.cfc</code>.  Inside the <code>index</code> function enter this code:
			<blockquote>
				<code>&lt;cfset text = &quot;Hello, world!&quot;&gt;</code>
			</blockquote>
		</li>
		<li>Open up <code>/app/views/index.cfm</code> and add this code:
			<blockquote>
<pre>
&lt;cfoutput&gt;
	##text##
&lt;/cfoutput&gt;
</pre>
			</blockquote>
		</li>
		<li>Point your browser to that controller (ex: <code>http://localhost/say</code>)</li>
		<li>Voila!</li>
	</ol>
	
	<h3>Sweet! Now what?</h3>
	<p> Visit <a href="http://www.cfwheels.com" title="Go to CFWheels.com">www.cfwheels.com</a> for the latest builds and updates.
		Drop us a note if you find a bug, found a better way to do something, or just want to let us know how you're using CFWheels!</p>
</div>

<div style="text-align: center">
	<img src="http://www.cfwheels.com/images/logo.png" alt="CFWheels Logo" />
</div>

</body>
</html>
</cfoutput>