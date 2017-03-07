```coldfusion
invokeWithTransaction(method [, transaction, isolation ])
```
```coldfusion
// This is the method to be run inside a transaction
<cffunction name="transferFunds" returntype="boolean" output="false">
    <cfargument name="personFrom">
    <cfargument name="personTo">
    <cfargument name="amount">
    <cfif arguments.personFrom.withdraw(arguments.amount) and arguments.personTo.deposit(arguments.amount)>
        <cfreturn true>
    <cfelse>
        <cfreturn false>
    </cfif>
</cffunction>

david = model("Person").findOneByName("David")>
mary = model("Person").findOneByName("Mary")>
invokeWithTransaction(method="transferFunds", personFrom=david, personTo=mary, amount=100)>
```
