# invokeWithTransaction()

## Description
Runs the specified method within a single database transaction.

## Function Syntax
	invokeWithTransaction( method, [ transaction, isolation ] )


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
			<td>method</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Model method to run.</td>
		</tr>
		
		<tr>
			<td>transaction</td>
			<td>string</td>
			<td>false</td>
			<td>commit</td>
			<td>Set this to `commit` to update the database when the save has completed, `rollback` to run all the database queries but not commit them, or `none` to skip transaction handling altogether.</td>
		</tr>
		
		<tr>
			<td>isolation</td>
			<td>string</td>
			<td>false</td>
			<td>read_committed</td>
			<td>Isolation level to be passed through to the `cftransaction` tag. See your CFML engine's documentation for more details about `cftransaction`'s `isolation` attribute.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- This is the method to be run inside a transaction --->
		<cffunction name="tranferFunds" returntype="boolean" output="false">
			<cfargument name="personFrom">
			<cfargument name="personTo">
			<cfargument name="amount">
			<cfif arguments.personFrom.withdraw(arguments.amount) and arguments.personTo.deposit(arguments.amount)>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
			</cfif>
		</cffunction>

		<cfset david = model("Person").findOneByName("David")>
		<cfset mary = model("Person").findOneByName("Mary")>
		<cfset invokeWithTransaction(method="transferFunds", personFrom=david, personTo=mary, amount=100)>
