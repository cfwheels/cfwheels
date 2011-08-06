<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_updatedAt_does_not_change_when_no_changes_to_model">
		<cftransaction>
			<cfset post = model("Post").findOne()>
			<cfset orgUpdatedAt = post.properties().updatedAt>
			<cfset post.update()>
			<cfset post.reload()>
			<cfset newUpdatedAt = post.properties().updatedAt>
			<cfset assert('orgUpdatedAt eq newUpdatedAt')>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>


</cfcomponent>