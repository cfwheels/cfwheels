<!--- 	Define special patterns to match against the URL. Each route is a structure and should follow this format:
		
	<cfset route.pattern = "controller/action/:id">	* Set the pattern
	<cfset route.controller = "controller_name">		* Set the controller
	<cfset route.action = "action_name">				* Set the action
	<cfset arrayAppend(routes,duplicate(route))>					* Add this route to array
	<cfset structClear(route)>							* Reset the struct to blank
	
	For the above example, CFWheels would call the "controller_name" controller,
	the "action_name" method inside that controller, and have a params.id variable
	available that contains the value of the ":id" placeholder in the URL.  The default
	is "id" but you could make this whatever you wanted.  For example, if you were 
	working on a blog and wanted the date built into the URL, you could create a route like:
	
	<cfset route.pattern = "blog/entry/:year/:month/:day">
	<cfset route.controller = "blog">
	<cfset route.action = "entry">
	<cfset arrayAppend(routes,duplicate(route))>
	<cfset structClear(route)>
	
	So that when a user goes to http://www.cfwheels.com/blog/entry/2005/11/06 the params
	structure will have three variables available (year, month and day) and they will be set to
	whatever was in the the :year, :month and :day placeholders in the URL.  You could then use
	these in your controller to get only blog entries for that day
	
	By the way, what's with the : syntax?  In Ruby any variable starting with a : is a symbol.
	Symbols are just like strings but they always point to the same place in memory and are
	therefore more efficient.  They don't work that way here in ColdFusion, but they make a good
	variable marker without worrying about where to put quotes and stuff
--->

<!--- Insert your custom routes here, they will be checked in the order they appear --->
<!--- --->

<!--- If nothing else matches, fall back to the standard routes (you probably shouldn't edit these) --->
<cfset route.pattern = ":controller/:action/:id">
<cfset arrayAppend(routes,duplicate(route))>
<cfset structClear(route)>

<cfset route.pattern = ":controller/:action">
<cfset arrayAppend(routes,duplicate(route))>
<cfset structClear(route)>

<cfset route.pattern = ":controller">
<cfset arrayAppend(routes,duplicate(route))>
<cfset structClear(route)>

<!--- 	When you're ready to have your root index file (the page that currently says 
		"Congratulations, you've put ColdFusion on Wheels!") point to an actual page 
		in your app, delete /public/index.cfm and uncomment the route below.  Then 
		change your controller and action to whatever you want in your real app --->
<!---
<cfset route.pattern = "">
<cfset route.controller = "say">
<cfset route.action = "hello">
<cfset arrayAppend(routes,duplicate(route))>
<cfset structClear(route)>
--->
