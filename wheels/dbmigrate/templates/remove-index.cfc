<!---
    |----------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                 |
    |----------------------------------------------------------------------------|
	| table         | Yes      | string  |         | table name                  |
	| indexName     | Yes      | string  |         | name of the index to remove |
    |----------------------------------------------------------------------------|

    EXAMPLE:
      removeIndex(table='members',indexName='members_username');
--->
<cfcomponent extends="[extends]" hint="[description]">
  <cffunction name="up">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
	    		removeIndex(table='tableName', indexName='');
	    	}
	    	catch (any ex){
	    		hasError = true;
		      	catchObject = ex;
	    	}
		    
	    </cfscript>
	    <cfif hasError>
	    	<cftransaction action="rollback" />
	    	<cfthrow 
			    detail = "#catchObject.detail#"
			    errorCode = "1"
			    message = "#catchObject.message#"
			    type = "Any">
	    <cfelse>
	    	<cftransaction action="commit" />
	    </cfif>
	 </cftransaction>
  </cffunction>
  <cffunction name="down">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
	    		addIndex(table='tableName',columnNames='columnName',unique=true);
	    	}
	    	catch (any ex){
	    		hasError = true;
		      	catchObject = ex;
	    	}
			
	    </cfscript>
	     <cfif hasError>
	    	<cftransaction action="rollback" />
	    	<cfthrow 
			    detail = "#catchObject.detail#"
			    errorCode = "1"
			    message = "#catchObject.message#"
			    type = "Any">
	    <cfelse>
	    	<cftransaction action="commit" />
	    </cfif>
	 </cftransaction>
  </cffunction>
</cfcomponent>