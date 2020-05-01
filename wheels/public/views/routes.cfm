<cfscript>
// Split out internal routes
"routes" = {
	"internalRoutes" = [],
	"appRoutes" = []
};

for (r in application.wheels.routes){
	if (StructKeyExists(r, "controller") && r.controller EQ "wheels.public") {
		ArrayAppend(routes.internalRoutes, r);
	} else {
		ArrayAppend(routes.appRoutes, r);
	}
}

</cfscript>

<cfinclude template="../layout/_header.cfm">

<cfoutput>

<div class="ui container">

#pageHeader("Routes", "What's going where..")#

<div class="ui top attached tabular menu stackable">
	<a class="item active" data-tab="appRoutes">App&nbsp;<span class="route-count">(#NumberFormat(ArrayLen(routes.appRoutes))#)</span></a>
	<a class="item" data-tab="internalRoutes">Internal&nbsp;<span class="route-count">(#NumberFormat(ArrayLen(routes.internalRoutes))#)</span></a>
</div>

<cfloop collection="#routes#" item="type">
#startTab(tab=type, active=type EQ 'appRoutes' ? true:false)#

<cfif type EQ "internalRoutes">

	<div class="ui info message">
		<div class="header">
			Note
		</div>
		These are here for reference only. They aren't loaded in production, and only used to render the CFWheels internal interface
	</div>

<cfelse>

	<div class="ui grid">
		<div class="two column row">
			<div class="left floated column">
			<!--- Route Filter --->
			<div class="ui action input">
				<input type="text" name="route-search" id="route-search" class="table-searcher" placeholder="Quick find...">
					<button class="ui icon button matched-count">
					<i class="search icon"></i>
					<span class="matched-count-value"></span>
				</button>
			</div>
			</div>
			<div class="right floated column">
			<!--- Route Tester --->
			<div class="ui action input">
				<input type="text" id="route-tester-path" placeholder="/example/path" />
				<select id="route-tester-verb" class="ui select dropdown">
					<option value="GET" selected>GET</option>
					<option value="POST">POST</option>
					<option value="PUT">PUT</option>
					<option value="PATCH">PATCH</option>
					<option value="DELETE">DELETE</option>
					<option value="HEAD">HEAD</option>
					<option value="OPTIONS">OPTIONS</option>
				</select>
				<button class="ui button route-test teal" data-test-url="#urlFor(route='wheelsRouteTester')#" >Test</button>
			</div>
			</div>
		</div>
	</div>

	<div id="router-tester-results"></div>

</cfif>
<div class="ui horizontal section divider">
	Routes
</div>
<div style="overflow-x: scroll;">
	<table class="ui celled striped table searchable">
			<thead>
				<tr>
					<th class="right">Name</th>
					<th>Method</th>
					<th>Pattern</th>
					<th>Controller</th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
			<cfloop array="#routes[type]#" index="route">
				#outputRouteRow(route)#
			</cfloop>
		</tbody>
	</table>
</div>

#endTab()#
</cfloop>

</div>

</cfoutput>

<cfinclude template="../layout/_footer.cfm">
