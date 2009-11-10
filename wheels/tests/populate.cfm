<cfinclude template="/wheelsMapping/global/functions.cfm">

<!--- reset all tables --->
<cfset model("author").deleteAll(instantiate=false)>
<cfset model("post").deleteAll(instantiate=false)>

<!--- populate with data --->
<cfset loc.per = model("author").create(firstName="Per", lastName="Djurner")>
<cfset loc.per.createPost(title="Title for first test post", body="Text for first test post")>
<cfset loc.per.createPost(title="Title for second test post", body="Text for second test post")>
<cfset loc.per.createPost(title="Title for third test post", body="Text for third test post")>
<cfset loc.tony = model("author").create(firstName="Tony", lastName="Petruzzi")>
<cfset loc.tony.createPost(title="Title for fourth test post", body="Text for fourth test post")>
<cfset loc.chris = model("author").create(firstName="Chris", lastName="Peters")>
<cfset loc.peter = model("author").create(firstName="Peter", lastName="Amiri")>
<cfset loc.james = model("author").create(firstName="James", lastName="Gibson")>
<cfset loc.raul = model("author").create(firstName="Raul", lastName="Riera")>