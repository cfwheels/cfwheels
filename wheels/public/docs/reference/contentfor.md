```coldfusion
// In your view
<cfsavecontent variable="mySidebar">
<h1>My Sidebar Text</h1>
</cfsavecontent>
<cfset contentFor(sidebar=mySidebar)>
```
In your layout
TODO: FIX THIS

```html
&lt;html&gt;
	&lt;head&gt;
	    <title>My Site</title>
	</head>
	<body>
		<cfoutput>
			#includeContent("sidebar")#
			#includeContent()#
		</cfoutput>
	</body>
</html>
```