<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">
	
	<cffunction name="test_contains_multiple_spaces_tabs_and_carriage_returns">
		<cfset loc.r = model("post").findAll(where="views 
				
					 >= 			
					   5   		   AND  
		  averagerating     
		   >   
		   				3")>
		<cfset loc.e = loc.r['authorid'][1]>
		<cfset assert('loc.e eq 9')>
	</cffunction>
	
</cfcomponent>