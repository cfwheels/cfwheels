<h1>The Blog</h1>
<p>This is just a small sample application used for testing of various Wheels features.</p>

<h2>Options</h2>
<p>Select an option from the list below.</p>
<cfoutput>
<ul>
	<li>#linkTo(text="Create a new author", action="newAuthor")#</li>
	<li>#linkTo(text="List authors", action="listAuthors")#</li>
</ul>

<h2>Schema</h2>
<p>Here is the schema for the blog database.</p>
<ul>
	<li>
		<strong>authors</strong>
		<br>- firstName (varchar, 50, not null, primary key)
		<br>- lastName (varchar, 50, not null, primary key)
		<br>- email (varchar, 50, not null)
		<br>- password (varchar, 20, not null)
	</li>
	<li>
		<strong>comments</strong>
		<br>- id (int, 11, not null, auto increment, primary key)
		<br>- postUuid (varchar, 36, not null)
		<br>- body (text, not null)
		<br>- deletedAt (datetime)
	</li>
	<li>
		<strong>posts</strong>
		<br>- uuid (varchar, 36, not null, primary key)
		<br>- authorFirstName (varchar, 50, not null)
		<br>- authorLastName (varchar, 50, not null)
		<br>- title (varchar, 100, not null)
		<br>- body (text, not null)
		<br>- createdAt (datetime)
	</li>
	<li>
		<strong>profiles</strong>
		<br>- id (int, 11, not null, auto increment, primary key)
		<br>- authorFirstName (varchar, 50, not null)
		<br>- authorLastName (varchar, 50, not null)
		<br>- bio (text)
	</li>
	<li>
		<strong>taggings</strong>
		<br>- postUuid (varchar, 36, not null, primary key)
		<br>- tagId (int, 11, not null, primary key)
	</li>
	<li>
		<strong>tags</strong>
		<br>- id (int, 11, not null, primary key)
		<br>- tbl_tags_name (varchar, 50, not null)
	</li>
</ul>

</cfoutput>