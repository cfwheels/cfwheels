# hasMany()

## Description
Sets up a `hasMany` association between this model and the specified one.

## Function Syntax
	hasMany( name, [ modelName, foreignKey, joinKey, joinType, dependent, shortcut, through, join ] )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Gives the association a name that you refer to when working with the association (in the `include` argument to @findAll, to name one example).</td>
		</tr>
		
		<tr>
			<td>modelName</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of associated model (usually not needed if you follow Wheels conventions because the model name will be deduced from the `name` argument).</td>
		</tr>
		
		<tr>
			<td>foreignKey</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Foreign key property name (usually not needed if you follow Wheels conventions since the foreign key name will be deduced from the `name` argument).</td>
		</tr>
		
		<tr>
			<td>joinKey</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Column name to join to if not the primary key (usually not needed if you follow wheels conventions since the join key will be the tables primary key/keys).</td>
		</tr>
		
		<tr>
			<td>joinType</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Use to set the join type when joining associated tables. Possible values are `inner` (for `INNER JOIN`) and `outer` (for `LEFT OUTER JOIN`).</td>
		</tr>
		
		<tr>
			<td>dependent</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Defines how to handle dependent models when you delete a record from this model. Set to `delete` to instantiate associated models and call their @delete method, `deleteAll` to delete without instantiating, `removeAll` to remove the foreign key, or `false` to do nothing.</td>
		</tr>
		
		<tr>
			<td>shortcut</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set this argument to create an additional dynamic method that gets the object(s) from the other side of a many-to-many association.</td>
		</tr>
		
		<tr>
			<td>through</td>
			<td>string</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>Set this argument if you need to override Wheels conventions when using the `shortcut` argument. Accepts a list of two association names representing the chain from the opposite side of the many-to-many relationship to this model.</td>
		</tr>
		
		<tr>
			<td>join</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Used if you want to suplly the entire join statement yourself.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!---
			Example1: Specify that instances of this model has many comments.
			(The table for the associated model, not the current, should have the foreign key set on it.)
		--->
		<cfset hasMany("comments")>

		<!---
			Example 2: Specify that this model (let's call it `reader` in this case) has many subscriptions and setup a shortcut to the `publication` model.
			(Useful when dealing with many-to-many relationships.)
		--->
		<cfset hasMany(name="subscriptions", shortcut="publications")>
		
		<!--- Example 3: Automatically delete all associated `comments` whenever this object is deleted --->
		<cfset hasMany(name="comments", dependent="deleteAll")>
		
		<!---
			Example 4: When not following Wheels naming conventions for associations, it can get complex to define how a `shortcut` works.
			In this example, we are naming our `shortcut` differently than the actual model's name.
		--->
		<!--- In the models/Customer.cfc `init()` method --->
		<cfset hasMany(name="subscriptions", shortcut="magazines", through="publication,subscriptions")>
		
		<!--- In the models/Subscriptions.cfc `init()` method --->
		<cfset belongsTo("customer")>
		<cfset belongsTo("publication")>
		
		<!--- In the models/Publication `init()` method --->
		<cfset hasMany("subscriptions")>
