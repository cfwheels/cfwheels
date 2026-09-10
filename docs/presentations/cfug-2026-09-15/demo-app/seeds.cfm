<!--- app/db/seeds.cfm — two posts for the CFUG live build.
     Drop this file in place after the Post scaffold + migrate, then `wheels seed`.
     LuCLI has no `wheels generate seed`; write this file (or copy it) yourself. --->
<cfscript>

seedOnce(modelName="Post", uniqueProperties="title", properties={
	title: "Hello Mid-Michigan",
	body: "A first post from wheels seed — no form-filling required."
});

seedOnce(modelName="Post", uniqueProperties="title", properties={
	title: "Convention over configuration",
	body: "Post maps to posts, Posts.cfc, and /posts. The naming is the wiring."
});

</cfscript>
