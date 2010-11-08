<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cffile action="readbinary" file="#expandpath('wheels/tests/_assets/files/cfwheels-logo.png')#" variable="loc.binaryData">
	</cffunction>

 	<cffunction name="test_update">
		<cftransaction action="begin">
			<cfset loc.photo = model("photo").findOne()>
			<cfset loc.photo.update(filename="somefilename", fileData=loc.binaryData)>
			<cfset loc.photo = model("photo").findByKey(loc.photo.id)>
			<cfset loc._binary = loc.photo.filedata>
			<cftransaction action="rollback" />
		</cftransaction>

		<cfset assert('IsBinary(ToBinary(loc._binary))')>
	</cffunction>

 	<cffunction name="test_insert">
		<cfset loc.gallery = model("gallery").findOne(
			include="user"
			,where="users.lastname = 'Petruzzi'"
			,orderby="id"
		)>
		<cftransaction action="begin">
			<cfset loc.photo = model("photo").create(
				galleryid="#loc.gallery.id#"
				,filename="somefilename"
				,fileData=loc.binaryData
				,description1="something something"
			)>
			<cfset loc.photo = model("photo").findByKey(loc.photo.id)>
			<cfset loc._binary = loc.photo.filedata>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsBinary(ToBinary(loc._binary))')>
	</cffunction>

</cfcomponent>