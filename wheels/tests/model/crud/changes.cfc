<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_comparing_existing_properties_only">
		<cfset loc.author = model("author").findOne(select="firstName")>
		<cfset loc.result = loc.author.hasChanged()>
		<cfset assert("NOT loc.result")>
		<cfset loc.result = loc.author.hasChanged("firstName")>
		<cfset assert("NOT loc.result")>
		<cfset loc.author = model("author").findOne()>
		<cfset StructDelete(loc.author, "firstName")>
		<cfset loc.result = loc.author.hasChanged()>
		<cfset assert("NOT loc.result")>
		<cfset loc.result = loc.author.hasChanged("firstName")>
		<cfset assert("NOT loc.result")>
		<cfset loc.result = loc.author.hasChanged("somethingThatDoesNotExist")>
		<cfset assert("NOT loc.result")>
	</cffunction>

	<cffunction name="test_allChanges">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.author.firstName = "a">
		<cfset loc.author.lastName = "b">
		<cfset loc.compareWith.firstName.changedFrom = "Per">
		<cfset loc.compareWith.firstName.changedTo = "a">
		<cfset loc.compareWith.lastName.changedFrom = "Djurner">
		<cfset loc.compareWith.lastName.changedTo = "b">
		<cfset loc.result = loc.author.allChanges()>
		<cfset assert("loc.result.toString() IS loc.compareWith.toString()")>
	</cffunction>

	<cffunction name="test_changedProperties">
		<cfset loc.author = model("author").findOne()>
		<cfset loc.author.firstName = "a">
		<cfset loc.author.lastName = "b">
		<cfset loc.result = listSort(loc.author.changedProperties(), "textnocase")>
		<cfset assert("loc.result IS 'firstName,lastName'")>
	</cffunction>

	<cffunction name="test_changedProperties_without_changes">
		<cfset loc.author = model("author").findOne()>
		<cfset loc.result = loc.author.changedProperties()>
		<cfset assert("loc.result IS ''")>
	</cffunction>

	<cffunction name="test_changedProperties_change_and_back">
		<cfset loc.author = model("author").findOne()>
		<cfset loc.author.oldFirstName = loc.author.firstName>
		<cfset loc.author.firstName = "a">
		<cfset loc.result = loc.author.changedProperties()>
		<cfset assert("loc.result IS 'firstName'")>
		<cfset loc.author.firstName = loc.author.oldFirstName>
		<cfset loc.result = loc.author.changedProperties()>
		<cfset assert("loc.result IS ''")>
	</cffunction>

	<cffunction name="test_isNew">
		<cftransaction>
			<cfset loc.author = model("author").new(firstName="Per", lastName="Djurner")>
			<cfset loc.result = loc.author.isNew()>
			<cfset assert("loc.result IS true")>
			<cfset loc.author.save(transaction="none")>
			<cfset loc.result = loc.author.isNew()>
			<cfset assert("loc.result IS false")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_isNew_with_find">
		<cfset loc.author = model("author").findOne()>
		<cfset loc.result = loc.author.isNew()>
		<cfset assert("loc.result IS false")>
	</cffunction>

	<cffunction name="test_hasChanged">
		<cfset loc.author = model("author").findOne(where="lastName = 'Djurner'")>
		<cfset loc.result = loc.author.hasChanged()>
		<cfset assert("loc.result IS false")>
		<cfset loc.author.lastName = "Petruzzi">
		<cfset loc.result = loc.author.hasChanged()>
		<cfset assert("loc.result IS true")>
		<cfset loc.author.lastName = "Djurner">
		<cfset loc.result = loc.author.hasChanged()>
		<cfset assert("loc.result IS false")>
	</cffunction>

	<cffunction name="test_hasChanged_with_new">
		<cftransaction>
			<cfset loc.author = model("author").new()>
			<cfset loc.result = loc.author.hasChanged()>
			<cfset assert("loc.result IS true")>
			<cfset loc.author.firstName = "Per">
			<cfset loc.author.lastName = "Djurner">
			<cfset loc.author.save(transaction="none")>
			<cfset loc.result = loc.author.hasChanged()>
			<cfset assert("loc.result IS false")>
			<cfset loc.author.lastName = "Petruzzi">
			<cfset loc.result = loc.author.hasChanged()>
			<cfset assert("loc.result IS true")>
			<cfset loc.author.save(transaction="none")>
			<cfset loc.result = loc.author.hasChanged()>
			<cfset assert("loc.result IS false")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_XXXHasChanged">
		<cfset loc.author = model("author").findOne(where="lastName = 'Djurner'")>
		<cfset loc.author.lastName = "Petruzzi">
		<cfset loc.result = loc.author.lastNameHasChanged()>
		<cfset assert("loc.result IS true")>
		<cfset loc.result = loc.author.firstNameHasChanged()>
		<cfset assert("loc.result IS false")>
	</cffunction>

	<cffunction name="test_changedFrom">
		<cfset loc.author = model("author").findOne(where="lastName = 'Djurner'")>
		<cfset loc.author.lastName = "Petruzzi">
		<cfset loc.result = loc.author.changedFrom(property="lastName")>
		<cfset assert("loc.result IS 'Djurner'")>
	</cffunction>

	<cffunction name="test_XXXChangedFrom">
		<cfset loc.author = model("author").findOne(where="lastName = 'Djurner'")>
		<cfset loc.author.lastName = "Petruzzi">
		<cfset loc.result = loc.author.lastNameChangedFrom(property="lastName")>
		<cfset assert("loc.result IS 'Djurner'")>
	</cffunction>

	<cffunction name="test_date_compare">
		<cfset loc.user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.user.birthday = "11/01/1975 12:00 AM">
		<cfset loc.e = loc.user.hasChanged("birthday")>
		<cfset assert('loc.e eq false')>
	</cffunction>
	
	<cffunction name="test_binary_compare">
		<cfset loc.gallery = model("photogallery").findOne(
			include="user"
			,where="users.lastname = 'Petruzzi'"
			,orderby="photogalleryid"
		)>
		<cffile action="readbinary" file="#expandpath('wheels/tests/_assets/files/cfwheels-logo.png')#" variable="loc.binaryData">
		<cftransaction action="begin">
			<cfset loc.photogalleryphoto = model("PhotoGalleryPhoto").create(
				photogalleryid="#loc.gallery.photogalleryid#"
				,filename="somefilename"
				,fileData=loc.binaryData
				,description1="something something" 
			)>
			<cfset loc.photogalleryphoto = model("PhotoGalleryPhoto").findByKey(loc.photogalleryphoto.photogalleryphotoid)>
			<cfset loc.photogalleryphoto.fileData = loc.binaryData>
			<cfset loc.e1 = loc.photogalleryphoto.hasChanged("fileData")>
			<cfset loc.photogalleryphoto.fileData = "tonyp">
			<cfset loc.e2 = loc.photogalleryphoto.hasChanged("fileData")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.e1 eq false')>
		<cfset assert('loc.e2 eq true')>
	</cffunction>

</cfcomponent>