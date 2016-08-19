<!---
    |-----------------------------------------------------------------------------------------------------|
	| Parameter               | Required | Type    | Default | Description                                |
    |-----------------------------------------------------------------------------------------------------|
	| table                   | Yes      | string  |         | Name of table to update records            |
	| where                   | No       | string  |         | Where condition                            |
	| one or more columnNames | No       | string  |         | Use column name as argument name and value |
    |-----------------------------------------------------------------------------------------------------|

    EXAMPLE:
      updateRecord(table='members',where='id=1',status='Active');
--->
<cfcomponent extends="[extends]" hint="[description]">
  <cffunction name="up">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
	    		updateRecord(table='tableName',where='');
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
	    		updateRecord(table='tableName',where='');
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