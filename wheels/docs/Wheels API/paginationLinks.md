# paginationLinks()

## Description
Builds and returns a string containing links to pages based on a paginated query. Uses @linkTo internally to build the link, so you need to pass in a `route` name or a `controller`/`action`/`key` combination. All other @linkTo arguments can be supplied as well, in which case they are passed through directly to @linkTo. If you have paginated more than one query in the controller, you can use the `handle` argument to reference them. (Don't forget to pass in a `handle` to the @findAll function in your controller first.)

## Function Syntax
	paginationLinks( [ windowSize, alwaysShowAnchors, anchorDivider, linkToCurrentPage, prepend, append, prependToPage, prependOnFirst, prependOnAnchor, appendToPage, appendOnLast, appendOnAnchor, classForCurrent, handle, name, showSinglePage, pageNumberAsParam ] )


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
			<td>windowSize</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>The number of page links to show around the current page.</td>
		</tr>
		
		<tr>
			<td>alwaysShowAnchors</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not links to the first and last page should always be displayed.</td>
		</tr>
		
		<tr>
			<td>anchorDivider</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to place next to the anchors on either side of the list.</td>
		</tr>
		
		<tr>
			<td>linkToCurrentPage</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not the current page should be linked to.</td>
		</tr>
		
		<tr>
			<td>prepend</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String or HTML to be prepended before result.</td>
		</tr>
		
		<tr>
			<td>append</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String or HTML to be appended after result.</td>
		</tr>
		
		<tr>
			<td>prependToPage</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String or HTML to be prepended before each page number.</td>
		</tr>
		
		<tr>
			<td>prependOnFirst</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to prepend the `prependToPage` string on the first page in the list.</td>
		</tr>
		
		<tr>
			<td>prependOnAnchor</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to prepend the `prependToPage` string on the anchors.</td>
		</tr>
		
		<tr>
			<td>appendToPage</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String or HTML to be appended after each page number.</td>
		</tr>
		
		<tr>
			<td>appendOnLast</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to append the `appendToPage` string on the last page in the list.</td>
		</tr>
		
		<tr>
			<td>appendOnAnchor</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to append the `appendToPage` string on the anchors.</td>
		</tr>
		
		<tr>
			<td>classForCurrent</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Class name for the current page number (if `linkToCurrentPage` is `true`, the class name will go on the `a` element. If not, a `span` element will be used).</td>
		</tr>
		
		<tr>
			<td>handle</td>
			<td>string</td>
			<td>false</td>
			<td>query</td>
			<td>The handle given to the query that the pagination links should be displayed for.</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The name of the param that holds the current page number.</td>
		</tr>
		
		<tr>
			<td>showSinglePage</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Will show a single page when set to `true`. (The default behavior is to return an empty string when there is only one page in the pagination).</td>
		</tr>
		
		<tr>
			<td>pageNumberAsParam</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Decides whether to link the page number as a param or as part of a route. (The default behavior is `true`).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Example 1: List authors page by page, 25 at a time --->
		<!--- Controller code --->
		<cfparam name="params.page" default="1">
		<cfset allAuthors = model("author").findAll(page=params.page, perPage=25, order="lastName")>

		<!--- View code --->
		<ul>
		    <cfoutput query="allAuthors">
		        <li>#firstName# #lastName#</li>
		    </cfoutput>
		</ul>
		<cfoutput>#paginationLinks(action="listAuthors")#</cfoutput>
		
		<!--- Example 2: Using the same model call above, show all authors with a window size of 5 --->
		<!--- View code --->
		<cfoutput>#paginationLinks(action="listAuthors", windowSize=5)#</cfoutput>

		<!--- Example 3: If more than one paginated query is being run, then you need to reference the correct `handle` in the view --->
		<!--- Controller code --->
		<cfset allAuthors = model("author").findAll(handle="authQuery", page=5, order="id")>

		<!--- View code --->
		<ul>
		    <cfoutput>#paginationLinks(action="listAuthors", handle="authQuery", prependToLink="<li>", appendToLink="</li>")#</cfoutput>
		</ul>

		<!--- Example 4: Call to `paginationLinks` using routes --->
		<!--- Route setup in config/routes.cfm --->
		<cfset addRoute(name="paginatedCommentListing", pattern="blog/[year]/[month]/[day]/[page]", controller="theBlog", action="stats")>
		<cfset addRoute(name="commentListing", pattern="blog/[year]/[month]/[day]",  controller="theBlog", action="stats")>

		<!--- Ccontroller code --->
		<cfparam name="params.page" default="1">
		<cfset comments = model("comment").findAll(page=params.page, order="createdAt")>

		<!--- View code --->
		<ul>
		    <cfoutput>#paginationLinks(route="paginatedCommentListing", year=2009, month="feb", day=10)#</cfoutput>
		</ul>
