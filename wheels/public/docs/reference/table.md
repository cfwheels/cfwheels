```coldfusion
table(name)
```
```coldfusion
// In models/User.cfc
<cffunction name="init">
    // Tell Wheels to use the `tbl_USERS` table in the database for the `user` model instead of the default (which would be `users`)
    table("tbl_USERS")>
</cffunction>
```
