<h1>Create Author</h1>
<p>Fill out the form:</p>
<cfoutput>
	#errorMessagesFor("author")#
	#startFormTag(action="createAuthor")#
		#textField(objectName="author", property="firstName", label="First Name:", wrapLabel=false)#
		#textField(objectName="author", property="lastName", label="Last Name:", wrapLabel=false)#
		#textField(objectName="author", property="email", label="Email Address:", wrapLabel=false)#
		#textField(objectName="author", property="password", label="Password:", wrapLabel=false)#
		#textField(objectName="author", property="passwordConfirmation", label="Confirm Password:", wrapLabel=false)#
		#submitTag()#
	#endFormTag()#
</cfoutput>