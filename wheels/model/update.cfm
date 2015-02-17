<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="updateAll" returntype="numeric" access="public" output="false" hint="Updates all properties for the records that match the `where` argument. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument. By default, objects will not be instantiated and therefore callbacks and validations are not invoked. You can change this behavior by passing in `instantiate=true`. This method returns the number of records that were updated."
	examples=
	'
		<!--- Update the `published` and `publishedAt` properties for all records that have `published=0` --->
		<cfset recordsUpdated = model("post").updateAll(published=1, publishedAt=Now(), where="published=0")>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `removeAllComments` method below will call `model("comment").updateAll(postid="", where="postId=##post.id##")` internally.) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset removedSuccessfully = aPost.removeAllComments()>
	'
	categories="model-class,update" chapters="updating-records,associations" functions="hasMany,update,updateByKey,updateOne">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="instantiate" type="boolean" required="false" hint="Whether or not to instantiate the object(s) first. When objects are not instantiated, any callbacks and validations set on them will be skipped.">
	<cfargument name="validate" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
	<cfscript>
		var loc = {};
		$args(name="updateAll", args=arguments);
		arguments.include = $listClean(arguments.include);
		arguments.properties = $setProperties(argumentCollection=arguments, filterList="where,include,properties,reload,parameterize,instantiate,validate,transaction,callbacks,includeSoftDeletes", setOnModel=false);

		// find and instantiate each object and call its update function
		if (arguments.instantiate)
		{
			loc.rv = 0;
			loc.objects = findAll(select=propertyNames(), where=arguments.where, include=arguments.include, reload=arguments.reload, parameterize=arguments.parameterize, callbacks=arguments.callbacks, includeSoftDeletes=arguments.includeSoftDeletes, returnIncluded=false, returnAs="objects");
			loc.iEnd = ArrayLen(loc.objects);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				if (loc.objects[loc.i].update(properties=arguments.properties, parameterize=arguments.parameterize, transaction=arguments.transaction, callbacks=arguments.callbacks))
				{
					loc.rv++;
				}
			}
		}
		else
		{
			arguments.sql = [];
			ArrayAppend(arguments.sql, "UPDATE #tableName()# SET");
			loc.pos = 0;
			for (loc.key in arguments.properties)
			{
				loc.pos++;
				ArrayAppend(arguments.sql, "#variables.wheels.class.properties[loc.key].column# = ");
				loc.param = {value=arguments.properties[loc.key], type=variables.wheels.class.properties[loc.key].type, dataType=variables.wheels.class.properties[loc.key].dataType, scale=variables.wheels.class.properties[loc.key].scale, null=!Len(arguments.properties[loc.key])};
				ArrayAppend(arguments.sql, loc.param);
				if (StructCount(arguments.properties) > loc.pos)
				{
					ArrayAppend(arguments.sql, ",");
				}
			}
			arguments.sql = $addWhereClause(sql=arguments.sql, where=arguments.where, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes);
			arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
			loc.rv = invokeWithTransaction(method="$updateAll", argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="updateByKey" returntype="boolean" access="public" output="false" hint="Finds the object with the supplied key and saves it (if validation permits it) with the supplied properties and/or named arguments. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument. Returns `true` if the object was found and updated successfully, `false` otherwise."
	examples=
	'
		<!--- Updates the object with `33` as the primary key value with values passed in through the URL/form --->
		<cfset result = model("post").updateByKey(33, params.post)>

		<!--- Updates the object with `33` as the primary key using named arguments --->
		<cfset result = model("post").updateByKey(key=33, title="New version of Wheels just released", published=1)>
	'
	categories="model-class,update" chapters="updating-records,associations" functions="hasOne,hasMany,update,updateAll,updateOne">
	<cfargument name="key" type="any" required="true" hint="See documentation for @findByKey.">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="validate" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
	<cfscript>
		var loc = {};
		$args(name="updateByKey", args=arguments);
		$keyLengthCheck(arguments.key);
		arguments.where = $keyWhereString(values=arguments.key);
		StructDelete(arguments, "key");
		loc.rv = updateOne(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="updateOne" returntype="boolean" access="public" output="false" hint="Gets an object based on the arguments used and updates it with the supplied properties. Returns `true` if an object was found and updated successfully, `false` otherwise."
	examples=
	'
		<!--- Sets the `new` property to `1` on the most recently released product --->
		<cfset result = model("product").updateOne(order="releaseDate DESC", new=1)>

		<!--- If you have a `hasOne` association setup from `user` to `profile`, you can do a scoped call. (The `removeProfile` method below will call `model("profile").updateOne(where="userId=##aUser.id##", userId="")` internally.) --->
		<cfset aUser = model("user").findByKey(params.userId)>
		<cfset aUser.removeProfile()>
	'
	categories="model-class,update" chapters="updating-records,associations" functions="hasOne,update,updateAll,updateByKey">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="order" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="validate" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
	<cfscript>
		var loc = {};
		$args(name="updateOne", args=arguments);
		loc.object = findOne(where=arguments.where, order=arguments.order, reload=arguments.reload, includeSoftDeletes=arguments.includeSoftDeletes);
		StructDelete(arguments, "where");
		StructDelete(arguments, "order");
		if (IsObject(loc.object))
		{
			loc.rv = loc.object.update(argumentCollection=arguments);
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="update" returntype="boolean" access="public" output="false" hint="Updates the object with the supplied properties and saves it to the database. Returns `true` if the object was saved successfully to the database and `false` otherwise."
	examples=
	'
		<!--- Get a post object and then update its title in the database --->
		<cfset post = model("post").findByKey(33)>
		<cfset post.update(title="New version of Wheels just released")>

		<!--- Get a post object and then update its title and other properties based on what is pased in from the URL/form --->
		<cfset post = model("post").findByKey(params.key)>
		<cfset post.update(title="New version of Wheels just released", properties=params.post)>

		<!--- If you have a `hasOne` association setup from `author` to `bio`, you can do a scoped call. (The `setBio` method below will call `bio.update(authorId=anAuthor.id)` internally.) --->
		<cfset author = model("author").findByKey(params.authorId)>
		<cfset bio = model("bio").findByKey(params.bioId)>
		<cfset author.setBio(bio)>

		<!--- If you have a `hasMany` association setup from `owner` to `car`, you can do a scoped call. (The `addCar` method below will call `car.update(ownerId=anOwner.id)` internally.) --->
		<cfset anOwner = model("owner").findByKey(params.ownerId)>
		<cfset aCar = model("car").findByKey(params.carId)>
		<cfset anOwner.addCar(aCar)>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `removeComment` method below will call `comment.update(postId="")` internally.) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset aComment = model("comment").findByKey(params.commentId)>
		<cfset aPost.removeComment(aComment)>
	'
	categories="model-object,crud" chapters="updating-records,associations" functions="hasMany,hasOne,updateAll,updateByKey,updateOne">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="validate" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		$args(name="update", args=arguments);
		$setProperties(argumentCollection=arguments, filterList="properties,parameterize,reload,validate,transaction,callbacks");
		loc.rv = save(parameterize=arguments.parameterize, reload=arguments.reload, validate=arguments.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="updateProperty" returntype="boolean" access="public" output="false" hint="Updates a single property and saves the record without going through the normal validation procedure. This is especially useful for boolean flags on existing records."
	examples=
	'
		<!--- Sets the `new` property to `1` through updateProperty() --->
		<cfset product = model("product").findByKey(56)>
		<cfset product.updateProperty("new", 1)>
	'
	categories="model-class,update" chapters="updating-records,associations" functions="hasOne,update,updateAll,updateByKey,updateProperties">
	<cfargument name="property" type="string" required="true" hint="Name of the property to update the value for globally.">
	<cfargument name="value" type="any" required="true" hint="Value to set on the given property globally.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		$args(name="updateProperty", args=arguments);
		arguments.validate = false;
		this[arguments.property] = arguments.value;
		loc.rv = save(parameterize=arguments.parameterize, reload=false, validate=arguments.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="updateProperties" returntype="boolean" access="public" output="false" hint="Updates all the properties from the `properties` argument or other named arguments. If the object is invalid, the save will fail and `false` will be returned."
	examples=
	'
		<!--- Sets the `new` property to `1` through `updateProperties()` --->
		<cfset product = model("product").findByKey(56)>
		<cfset product.updateProperties(new=1)>
	'
	categories="model-class,update" chapters="updating-records,associations" functions="hasOne,update,updateAll,updateByKey,updateProperties">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="Struct containing key/value pairs with properties and associated values that need to be updated globally.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="validate" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		$args(name="updateProperties", args=arguments);
		$setProperties(argumentCollection=arguments, filterList="properties,parameterize,validate,transaction,callbacks");
		loc.rv = save(parameterize=arguments.parameterize, reload=false, validate=arguments.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE MODEL CLASS METHODS --->

<cffunction name="$updateAll" returntype="numeric" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize).result.recordCount;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE MODEL OBJECT METHODS --->

<cffunction name="$update" returntype="boolean" access="public" output="false">
	<cfargument name="parameterize" type="any" required="true">
	<cfargument name="reload" type="boolean" required="true">
	<cfscript>
		var loc = {};
		if (hasChanged())
		{
			// perform update since changes have been made
			if (variables.wheels.class.timeStampingOnUpdate)
			{
				$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
			}
			loc.sql = [];
			ArrayAppend(loc.sql, "UPDATE #tableName()# SET ");
			for (loc.key in variables.wheels.class.properties)
			{
				// include all changed non-key values in the update
				if (StructKeyExists(this, loc.key) && !ListFindNoCase(primaryKeys(), loc.key) && hasChanged(loc.key))
				{
					ArrayAppend(loc.sql, "#variables.wheels.class.properties[loc.key].column# = ");
					loc.param = $buildQueryParamValues(loc.key);
					ArrayAppend(loc.sql, loc.param);
					ArrayAppend(loc.sql, ",");
				}
			}

			// only submit the update if we generated an sql set statement
			if (ArrayLen(loc.sql) > 1)
			{
				ArrayDeleteAt(loc.sql, ArrayLen(loc.sql));
				loc.sql = $addKeyWhereClause(sql=loc.sql);
				loc.upd = variables.wheels.class.adapter.$query(sql=loc.sql, parameterize=arguments.parameterize);
				if (arguments.reload)
				{
					this.reload();
				}
			}
		}
	</cfscript>
	<cfreturn true>
</cffunction>