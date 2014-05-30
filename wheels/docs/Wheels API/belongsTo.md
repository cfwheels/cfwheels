# belongsTo()

## Description
Sets up a `belongsTo` association between this model and the specified one. Use this association when this model contains a foreign key referencing another model.

## Function Syntax
	belongsTo( name, [ modelName, foreignKey, joinKey, joinType, join ] )


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
			<td>join</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Used if you want to suplly the entire join statement yourself.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Specify that instances of this model belong to an author. (The table for this model should have a foreign key set on it, typically named `authorid`.) --->
		<cfset belongsTo("author")>

		<!--- Same as above, but because we have broken away from the foreign key naming convention, we need to set `modelName` and `foreignKey` --->
		<cfset belongsTo(name="bookWriter", modelName="author", foreignKey="authorId")>
