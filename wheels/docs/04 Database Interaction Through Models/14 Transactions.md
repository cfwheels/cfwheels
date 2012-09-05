# Transactions

*Wheels automatically wraps your database calls in transactions to assist your application in 
maintaining data integrity. Learn how to control this functionality.*

Database transactions are a way of grouping multiple queries together. They are useful in case the 
outcome of one query depends on the completion of another. For example, if you want to take money from 
one person's bank account, and transfer it into someone else's, you probably want to make sure the debit 
completes before running the credit.

You'll be pleased to know that Wheels makes using database transactions easy. In fact, the vast majority 
of the time, you won't need to think about using them at all because Wheels automatically runs all 
queries within the callback chain as a single transaction for creates, updates, and deletes.

If any of the callbacks within the chain return `false`, none of the queries will commit.

For example, say you want to automatically create the first post when a new author subscribes to a blog.

In your `blog` model, you would add the following code:

	<!--- Author.cfc Model --->
	<cffunction name="init">
		<cfset afterCreate("createFirstPost")>
	</cffunction>
	
	<cffunction name="createFirstPost")>
		<cfset var post = model("post").new(authorId=this.id, text="This is my first post!")>
		<cfreturn post.save()>
	</cffunction>

In this example, if the post doesn't save (perhaps due to a validation problem), the author doesn't get 
created either. This helps to maintain database integrity.

## Disabling Transactions

If you want to manage transactions yourself using the `<cftransaction>` tag, you can simply add 
`transaction="none"` to any CRUD method.

	<cfset model("author").create(name="John", transaction="none")>

Another option is to disable transactions across your entire application using the `transactionMode` 
configuration:

	<!--- In `config/settings.cfm` --->
	<cfset set(transactionMode="none")>

See the chapter about [Configuration and Defaults][1] for more details.

## Using Rollbacks

Sometimes it's useful to use a rollback to test a process without making any permanent changes to the 
database. To do this, add `transaction="rollback"` to any CRUD method.

	<cfset model("author").create(name="John", transaction="rollback")>

Again, to configure your entire application to rollback _all_ transactions, you can set the 
`transactionMode` configuration to `rollback`.

	<!--- In `config/settings.cfm` --->
	<cfset set(transactionMode="rollback")>

## Nesting Transactions with `invokeWithTransaction`

One issue with ColdFusion is that you cannot nest `<cftransaction>` tags. In this case, Wheels provides 
a workaround. If you wish to run a method within a transaction, use `invokeWithTransaction()`, as below. 

	<cfset invokeWithTransaction(method="transferFunds", personFrom=david, personTo=mary, amount=100)>

[1]: ../02%20Working%20with%20Wheels/02%20Configuration%20and%20Defaults.md