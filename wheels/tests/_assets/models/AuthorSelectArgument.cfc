<cfcomponent extends="Model">

  <cffunction name="init">
    <cfset table("authors")>
    <cfset property(name="selectArgDefault", sql="id")>
    <cfset property(name="selectArgTrue", sql="id", select=true)>
    <cfset property(name="selectArgFalse", sql="id", select=false)>
  </cffunction>

</cfcomponent>