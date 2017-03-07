```coldfusion
validationTypeForProperty(property)
```
```coldfusion
// first name is a varchar(50) column
employee = model("employee").new();
// would output "string"
<cfoutput>#employee.validationTypeForProperty("firstName")>#</cfoutput>
```
