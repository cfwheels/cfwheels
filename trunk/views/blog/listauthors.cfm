<h1>All Authors</h1>
<p>Listing all authors...</p>
<table cellspacing="0">
	<tr>
		<th style="padding:2px;">First Name</th>
		<th style="padding:2px;">Last Name</th>
		<th style="padding:2px;">Email Address</th>
		<th style="padding:2px;">Password</th>
		<th style="padding:2px;">Delete</th>
	</tr>
	<cfoutput query="authors">
		<tr style="background: ###cycle('ffffff,efefef')#;">
			<td style="padding:2px;">#firstName#</td>
			<td style="padding:2px;">#lastName#</td>
			<td style="padding:2px;">#email#</td>
			<td style="padding:2px;">#password#</td>
			<td style="padding:2px;">#linkTo(text="delete", action="deleteAuthor", params="firstName=#firstName#&lastName=#lastName#", confirm="Are you sure you want to delete #firstName# #lastName#?")#</td>
		</tr>
	</cfoutput>
</table>
<cfoutput>#paginationLinks()#</cfoutput>