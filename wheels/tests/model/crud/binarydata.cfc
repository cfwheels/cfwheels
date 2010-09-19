<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cffile action="readbinary" file="#expandpath('wheels/tests/_assets/files/cfwheels-logo.png')#" variable="loc.binaryData">	
	</cffunction>

 	<cffunction name="test_update">
		<cftransaction action="begin">
			<cfset loc.photogalleryphoto = model("PhotoGalleryPhoto").findOne()>
			<cfset loc.photogalleryphoto.update(filename="somefilename", fileData=loc.binaryData)>
			<cfset loc.photogalleryphoto = model("PhotoGalleryPhoto").findByKey(loc.photogalleryphoto.photogalleryphotoid)>
			<cfset loc._binary = loc.photogalleryphoto.filedata>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsBinary(loc._binary)')>
	</cffunction>
	
 	<cffunction name="test_insert">
		<cfset loc.gallery = model("photogallery").findOne(
			include="user"
			,where="users.lastname = 'Petruzzi'"
			,orderby="photogalleryid"
		)>
		<cftransaction action="begin">
			<cfset loc.photogalleryphoto = model("PhotoGalleryPhoto").create(
				photogalleryid="#loc.gallery.photogalleryid#"
				,filename="somefilename"
				,fileData=loc.binaryData
				,description1="something something" 
			)>
			<cfset loc.photogalleryphoto = model("PhotoGalleryPhoto").findByKey(loc.photogalleryphoto.photogalleryphotoid)>
			<cfset loc._binary = loc.photogalleryphoto.filedata>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsBinary(loc._binary)')>
	</cffunction>

</cfcomponent>