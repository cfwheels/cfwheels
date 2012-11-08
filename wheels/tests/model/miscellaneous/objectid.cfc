<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_objectids_should_be_sequential_and_norepeating">
		<cfset loc.photos = []>
		<cfset loc.s = {}>
		<cfloop from="1" to="30" index="loc.i">
			<cfset ArrayAppend(loc.photos, model("photo").new())>
		</cfloop>
		<cfset loc.gallery = model("gallery").new(photos=loc.photos)>
		<cfloop array="#loc.gallery.photos#" index="loc.i">
			<cfset loc.s[loc.i.$objectid()] = "">
		</cfloop>

		<cfset assert('StructCount(loc.s) eq 30')>
		<cfset loc.a = loc.gallery.photos[1].$objectid() + 29>
		<cfset loc.b = loc.gallery.photos[30].$objectid()>
		<cfset assert('loc.a eq loc.b')>
	</cffunction>

</cfcomponent>
