```coldfusion
<cffunction name="init">
	<cfscript>
		// Register the `checkPhoneNumber` method below to be called to validate objects before they are saved
		validate("checkPhoneNumber");
	</cfscript>
</cffunction>

<cffunction name="checkPhoneNumber">
	<cfscript>
		// Make sure area code is `614`
		return Left(this.phoneNumber, 3) == "614";
	</cfscript>
</cffunction>
```
