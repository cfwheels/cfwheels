```coldfusion
<cffunction name="init">
	<cfscript>
		// Register the `check` method below to be called to validate existing objects before they are updated
		validateOnUpdate("checkPhoneNumber");
	</cfscript>
</cffunction>

<cffunction name="checkPhoneNumber">
	<cfscript>
		// Make sure area code is `614`
		return Left(this.phoneNumber, 3) == "614";
	</cfscript>
</cffunction>
```
