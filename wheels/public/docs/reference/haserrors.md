```coldfusion
hasErrors([ property, name ])
```
```coldfusion
// Check if the post object has any errors set on it 
<cfif post.hasErrors()>
    // Send user to a form to correct the errors... 
</cfif>
```