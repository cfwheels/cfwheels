<cfsilent>
<cfsavecontent variable="data">
1|Per|Djurner
</cfsavecontent>
<cfset members = QueryNew("id,firstname,lastname")>
<cfloop list="#data#" index="i" delimiters="#chr(13)##chr(10)#">
<cfset QueryAddRow(members)>
<cfset QuerySetCell(members, "id", ListGetAt(i, 1, "|"))>
<cfset QuerySetCell(members, "firstname", ListGetAt(i, 2, "|"))>
<cfset QuerySetCell(members, "lastname", ListGetAt(i, 3, "|"))>
</cfloop>
<cfset threadname = createuuid()>
<cfthread name="#threadname#"><cfoutput query="members">#members.id#|#members.firstname#|#members.lastname#</cfoutput></cfthread>
<cfthread action="join" name="#threadname#"/>
</cfsilent><cfoutput>#cfthread[threadname].output#</cfoutput>