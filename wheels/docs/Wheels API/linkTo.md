# linkTo()

## Description
Creates a link to another page in your application. Pass in the name of a `route` to use your configured routes or a `controller`/`action`/`key` combination. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	linkTo( [ text, confirm, route, controller, action, key, params, anchor, onlyPath, host, protocol, port, href, remote ] )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>text</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The text content of the link.</td>
		</tr>
		
		<tr>
			<td>confirm</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Pass a message here to cause a JavaScript confirmation dialog box to pop up containing the message.</td>
		</tr>
		
		<tr>
			<td>route</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of a route that you have configured in `config/routes.cfm`.</td>
		</tr>
		
		<tr>
			<td>controller</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of the controller to include in the URL.</td>
		</tr>
		
		<tr>
			<td>action</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of the action to include in the URL.</td>
		</tr>
		
		<tr>
			<td>key</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Key(s) to include in the URL.</td>
		</tr>
		
		<tr>
			<td>params</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Any additional params to be set in the query string.</td>
		</tr>
		
		<tr>
			<td>anchor</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Sets an anchor name to be appended to the path.</td>
		</tr>
		
		<tr>
			<td>onlyPath</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>If `true`, returns only the relative URL (no protocol, host name or port).</td>
		</tr>
		
		<tr>
			<td>host</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set this to override the current host.</td>
		</tr>
		
		<tr>
			<td>protocol</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set this to override the current protocol.</td>
		</tr>
		
		<tr>
			<td>port</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Set this to override the current port number.</td>
		</tr>
		
		<tr>
			<td>href</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Pass a link to an external site here if you want to bypass the Wheels routing system altogether and link to an external URL.</td>
		</tr>
		
		<tr>
			<td>remote</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Pass true if you wish to make this an asynchronous request</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#linkTo(text="Log Out", controller="account", action="logout")#
		-> <a href="/account/logout">Log Out</a>

		<!--- if you're already in the `account` controller, Wheels will assume that's where you want the link to point --->
		#linkTo(text="Log Out", action="logout")#
		-> <a href="/account/logout">Log Out</a>

		#linkTo(text="View Post", controller="blog", action="post", key=99)#
		-> <a href="/blog/post/99">View Post</a>

		#linkTo(text="View Settings", action="settings", params="show=all&sort=asc")#
		-> <a href="/account/settings?show=all&amp;sort=asc">View Settings</a>

		<!--- Given that a `userProfile` route has been configured in `config/routes.cfm` --->
		#linkTo(text="Joe's Profile", route="userProfile", userName="joe")#
		-> <a href="/user/joe">Joe's Profile</a>
		
		<!--- Link to an external website --->
		#linkTo(text="ColdFusion Framework", href="http://cfwheels.org/")#
		-> <a href="http://cfwheels.org/">ColdFusion Framework</a>
		
		<!--- Remote link --->
		#linkTo(text="View Settings", action="settings", params="show=all&sort=asc", remote="true")#
		-> <a data-remote="true" href="/account/settings?show=all&amp;sort=asc">View Settings</a>
		
		<!--- Give the link `class` and `id` attributes --->
		#linkTo(text="Delete Post", action="delete", key=99, class="delete", id="delete-99")#
		-> <a class="delete" href="/blog/delete/99" id="delete-99">Delete Post</a>
