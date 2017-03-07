```coldfusion
// In the controller action
flashInsert(success="Your post was successfully submitted.");
flashInsert(alert="Don''t forget to tweet about this post!");
flashInsert(error="This is an error message.");

// In the layout or view
<cfoutput>
	#flashMessages()#
</cfoutput>
//
	Generates this (sorted alphabetically):
	<div class="flashMessages">
		<p class="alertMessage">
			Don''t forget to tweet about this post!
		</p>
		<p class="errorMessage">
			This is an error message.
		</p>
		<p class="successMessage">
			Your post was successfully submitted.
		</p>
	</div>


// Only show the "success" key in the view
<cfoutput>
	#flashMessages(key="success")#
</cfoutput>
//
	Generates this:
	<div class="flashMessage">
		<p class="successMessage">
			Your post was successfully submitted.
		</p>
	</div>


// Show only the "success" and "alert" keys in the view, in that order
<cfoutput>
	#flashMessages(keys="success,alert")#
</cfoutput>
//
	Generates this (sorted alphabetically):
	<div class="flashMessages">
		<p class="successMessage">
			Your post was successfully submitted.
		</p>
		<p class="alertMessage">
			Don''t forget to tweet about this post!
		</p>
	</div>

```
