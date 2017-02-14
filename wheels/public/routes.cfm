<cfoutput>

<h1>Route List <small class="muted">(#arraylen(application.wheels.routes)# routes)</small></h1>

<input type="text" name="route-search" id="route-search" placeholder="Type to filter..." />
  <table id="route-dump">
  <thead>
    <tr>
      <th class="right">Name</th>
      <th>Method</th>
      <th>Pattern</th>
      <th>Regex</th>
      <th>Controller</th>
      <th>Action</th>
    </tr>
  </thead>
  <tbody>
    <cfloop array="#application.wheels.routes#" index="local.i">
      <tr>
        <td class="right">
          <cfif StructKeyExists(local.i, "name")>
            <code>#local.i.name#</code>
          </cfif>
        </td>
        <td>
          <cfif StructKeyExists(local.i, "methods")>
            #UCase(local.i.methods)#
          </cfif>
        </td>
        <td><code>#local.i.pattern#</td></code>
        <td><code>#local.i.regex#</td></code>
        <td>
          <cfif StructKeyExists(local.i, "controller")>
            <code>#local.i.controller#</code>
          </cfif>
        </td>
        <td>
          <cfif StructKeyExists(local.i, "action")>
            <code>#local.i.action#</code>
          </cfif>
        </td>
      </tr>
    </cfloop>
    </tbody>
  </table>
</cfoutput>
<script>
$(document).ready(function(){
  // Write on keyup event of keyword input element
  $("#route-search").keyup(function(){
    // When value of the input is not blank
    if( $(this).val() != "")
    {
      // Show only matching TR, hide rest of them
      $("#route-dump tbody>tr").hide();
      $("#route-dump td:contains-ci('" + $(this).val() + "')").parent("tr").show();
    }
    else
    {
      // When there is no input or clean again, show everything back
      $("#route-dump tbody>tr").show();
    }
  });
});
// jQuery expression for case-insensitive filter
$.extend($.expr[":"],
{
    "contains-ci": function(elem, i, match, array)
  {
    return (elem.textContent || elem.innerText || $(elem).text() || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
  }
});

</script>
