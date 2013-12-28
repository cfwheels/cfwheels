# Upgrading to Wheels 1.2.x

*Instructions for upgrading your ColdFusion on Wheels 1.1.x application to Wheels 1.2.x.*

If you are upgrading from Wheels 1.1 or newer, the easiest way to upgrade is to replace the `wheels`
folder with the new one from the 1.2 download.

## Plugin Compatibility

Be sure to review your plugins and their compatibility with your newly-updated version of Wheels. Some
plugins may stop working, throw errors, or cause unexpected behavior in your application.

## Supported System Changes

 	TODO
 	
## Application Seeting Changes

 *  the `errorEmailAddress` setting has been deprecated. Wheels now supports the  `errorEmailToAddress`
	and `errorEmailFromAddress` for better control when sending error emails. 


## File System Changes

	TODO

## Database Structure Changes

	TODO

## CFML Code Changes

	TODO

### Model Code

	TODO

### View Code

  * We now use unobtrusive javascript provided by the rails/jquery-ujs adapter to replace hard-coded
	javascript functionality in the following view functions:
    
      1. [startFormTag][3]
      2. [submitTag][4]
      3. [linkTo][5]
      4. [buttonTo][6]
      
    In order to use the javascript functionality these functions provide, you must first download
    the rails/jquery-ujs adapter from [https://github.com/rails/jquery-ujs][1] and place in your
    application's `javascripts` directory. You then install it into by using the `javascript
    your application using the [javaScriptIncludeTag][2]:
    
		<head>
			<cfoutput>
			<!--- Includes `rails.js` --->
		    #javaScriptIncludeTag("rails")#
			</cfoutput>
		</head>
		


### Controller Code

	TODO


[1]: https://github.com/rails/jquery-ujs/blob/master/src/rails.js
[2]: ../Wheels%20API/javaScriptIncludeTag.md
[3]: ../Wheels%20API/startFormTag.md
[4]: ../Wheels%20API/submitTag.md
[5]: ../Wheels%20API/linkTo.md
[6]: ../Wheels%20API/buttonTo.md