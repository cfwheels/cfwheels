<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfdbinfo name="loc.dbinfo" datasource="wheelstestdb" type="version">
		<cfset loc.db = LCase(Replace(loc.dbinfo.database_productname, " ", "", "all"))>
		
		<cffile action="readbinary" file="#expandpath('wheels/tests/_assets/files/cfwheels-logo.png')#" variable="loc.binaryData">
			
		<!--- There appears to be a problem with the JDBC SQLite adapter and BLOB datatypes, so let's convert it to a string --->
		<cfif loc.db IS "sqlite">
			<cfset loc.binaryData = ToBase64(loc.binaryData)>
		</cfif>
	</cffunction>

 	<cffunction name="test_update">
		<cftransaction action="begin">
			<cfset loc.photogalleryphoto = model("PhotoGalleryPhoto").findOne()>
			<cfset loc.photogalleryphoto.update(filename="somefilename", fileData=loc.binaryData)>
			<cfset loc.photogalleryphoto = model("PhotoGalleryPhoto").findByKey(loc.photogalleryphoto.photogalleryphotoid)>
			<cfset loc._binary = loc.photogalleryphoto.filedata>
			<cftransaction action="rollback" />
		</cftransaction>
		
		<cfset assert('IsBinary(ToBinary(loc._binary))')>
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
		<cfset assert('IsBinary(ToBinary(loc._binary))')>
	</cffunction>

</cfcomponent>