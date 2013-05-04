# validatesUniquenessOf()

## Description
Validates that the value of the specified property is unique in the database table. Useful for ensuring that two users can't sign up to a website with identical screen names for example. When a new record is created, a check is made to make sure that no record already exists in the database with the given value for the specified property. When the record is updated, the same check is made but disregarding the record itself.

## Function Syntax
	validatesUniquenessOf( properties, [ message, when, allowBlank, scope, condition, unless, includeSoftDeletes ] )


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
			<td>properties</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of property or list of property names to validate against (can also be called with the `property` argument).</td>
		</tr>
		
		<tr>
			<td>message</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Supply a custom error message here to override the built-in one.</td>
		</tr>
		
		<tr>
			<td>when</td>
			<td>string</td>
			<td>false</td>
			<td>onSave</td>
			<td>Pass in `onCreate` or `onUpdate` to limit when this validation occurs (by default validation will occur on both create and update, i.e. `onSave`).</td>
		</tr>
		
		<tr>
			<td>allowBlank</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>If set to `true`, validation will be skipped if the property value is an empty string or doesn't exist at all. This is useful if you only want to run this validation after it passes the @validatesPresenceOf test, thus avoiding duplicate error messages if it doesn't.</td>
		</tr>
		
		<tr>
			<td>scope</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>One or more properties by which to limit the scope of the uniqueness constraint.</td>
		</tr>
		
		<tr>
			<td>condition</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String expression to be evaluated that decides if validation will be run (if the expression returns `true` validation will run).</td>
		</tr>
		
		<tr>
			<td>unless</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String expression to be evaluated that decides if validation will be run (if the expression returns `false` validation will run).</td>
		</tr>
		
		<tr>
			<td>includeSoftDeletes</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>whether to take softDeletes into account when performing uniqueness check</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Make sure that two users with the same screen name won't ever exist in the database (although to be 100% safe, you should consider using database locking as well) --->
		<cfset validatesUniquenessOf(property="username", message="Sorry, that username is already taken.")>

		<!--- Same as above but allow identical user names as long as they belong to a different account --->
		<cfset validatesUniquenessOf(property="username", scope="accountId")>
