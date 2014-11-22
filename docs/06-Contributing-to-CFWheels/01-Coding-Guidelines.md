# Coding Guidelines

###### Here are the rules of the road for contributing code to the project. Let's follow this process so that we don't duplicate effort and so the code base is easy to maintain over the long haul.

### Subversion Repository
The official Git repository for Wheels is located at our [GitHub repository][1].

Anyone may fork the **_cfwheels_** repository, make changes, and submit a pull request.

#### Core Team Has Write Access
To make sure that we don't have too many chefs in the kitchen, we will be limiting direct commit access to a core team of developers.

At this time, the core team consists of these developers:

* Tony Petruzzi
* Chris Peters
* Peter Amiri
* Raúl Riera
* James Gibson
* Andy Bellenie

This does not restrict you from being able to contribute. See "Process for Implementing Changes to the Code" below for instructions on volunteering. With enough dedication, you can earn a seat on the core team as well!

#### Process for Implementing Changes to the Code
Here's the process that we'd like for you to follow. This process is in place mainly to encourage everyone to communicate openly. This gives us the opportunity to have a great peer-review process, which will result in quality. Who doesn't like quality?

1. Open an issue in the [issue tracker][2], outlining the changes or additions that you would like to make.
2. A member of the core team will review your submission and leave feedback if necessary.
3. Once the core team member is satisfied with the scope of the issue, they will schedule it for a release and mark your issue as "Accepted." This is your green light to start working. Get to coding, grasshopper!
4. Need help or running across any issues while coding? Run it by the Google Group. They all have opinions and love to let you know all about them. :smile:
5. When you have implemented your enhancement or change, use your Git repository to create a pull request with your changes.
	* You should annotate your commits with the issue number as **_issue 55_** if the code issue is **_55_**.
6. A core team will review it and post any necessary feedback in the issue tracker.
7. Once everything is resolved, the issue will be marked as "Fixed." A core team member will then pull your commit into the Git repository.
8. If needed, open an issue in the issue tracker to have the additions and changes in your revision documented. You may claim the issue if you'd like to do this, but it's entirely your choice.

#### Code Style
All framework code should use the following style. This will make things more readable and will keep everyone on the same page. If you're working on code and notice any violations of the official style, feel free to correct it!

Additionally, we recommend that any applications written using the Wheels framework follow the same style. This is optional, of course, but still strongly recommended.

#### Supported CFML Engines
All code for Wheels should be written for use with Adobe ColdFusion 8 and Railo 3.1.

#### Naming Conventions
To stay true to our ColdFusion and Java roots, all names must be camelCase. In some cases, the first letter should be capitalized as well. Refer to these examples.

| Code Element | Examples | Description |
| :----------- | :------- | :---------- |
| CFC Names | MyCfc.cfc, BlogEntry.cfc | CapitalizedCamelCase |
| Variable Names | myVariable, storyId | camelCase
| UDF Names | myFunction() | camelCase
| Built-in CF Variables | result.recordCount, cfhttp.fileContent | camelCase
| Built-in CF Functions | IsNumeric(), Trim() | CapitalizedCamelCase
| Scoped Variables | application.myVariable, session.userId | lowercase.camelCase
| CGI Variables | cgi.remote_addr, cgi.server_name | cgi.lowercase_underscored_name

#### CFC Conventions
##### Local variables

Everyone doing OOP with ColdFusion loves all of the the room for error that the **_var_** keyword allows! To help eliminate confusion, define a local struct at the top of CFC methods called **_loc_**. Any variable whose value should not persist for the life of the CFC instance should be stored in the loc struct. rsist for the life of the CFC instance should be stored in the **_loc_** struct. The only exception to this rule is when a function only uses one variable, in which case that variable alone can be declared with the var keyword.

```
<cffunction name="someMethod" access="public" returntype="void">
    <cfargument name="someArray" type="array" required="true">
    
    <cfset var loc = {}>
    
    <cfset loc.someVariable = true>
    
    <cfloop array="arguments.someArray" index="loc.i">
        <!--- Some code --->
    </cfloop>
</cffunction>
```

##### CFC Methods

All CFC methods should be made public. If a method is meant for internal use only and shouldn't be included in the API, then prefix it with a dollar sign **_$_**. An example would be **_$query()_**.

[1]: https://github.com/cfwheels
[2]: https://github.com/cfwheels/cfwheels/issues