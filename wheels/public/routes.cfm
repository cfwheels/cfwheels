<h1>Route List:</h1>
   <!---  <cfset $dump(application.wheels.routes) /> --->
<style>
  div.scroll-box {
    overflow: scroll;
    height: 600px;
  }

  table#route-dump {
    font-family: monospace;
  }

  table#route-dump th,
  table#route-dump td {
    text-align: left;
    padding: 0.1em 1em;
  }

  table#route-dump th.right,
  table#route-dump td.right {
    text-align: right;
  }
</style>
<cfoutput>
<div class="scroll-box">
  <table id="route-dump" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <th class="right">Name</th>
      <th>Method</th>
      <th>Pattern</th>
      <th>Regex</th>
      <th>Controller</th>
      <th>Action</th>
    </tr>
    <cfloop array="#application.wheels.routes#" index="local.i">
      <tr>
        <td class="right">
          <cfif StructKeyExists(local.i, "name")>
            #local.i.name#
          </cfif>
        </td>
        <td>
          <cfif StructKeyExists(local.i, "methods")>
            #UCase(local.i.methods)#
          </cfif>
        </td>
        <td>#local.i.pattern#</td>
        <td>#local.i.regex#</td>
        <td>
          <cfif StructKeyExists(local.i, "controller")>
            #local.i.controller#
          </cfif>
        </td>
        <td>
          <cfif StructKeyExists(local.i, "action")>
            #local.i.action#
          </cfif>
        </td>
      </tr>
    </cfloop>
  </table>
</div>
</cfoutput>
