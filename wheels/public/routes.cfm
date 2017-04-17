<cfoutput>

<h1>
  Route List
  <small class="muted">(#NumberFormat(ArrayLen(application.wheels.routes))# routes)</small>
</h1>

<input type="text" name="route-search" id="route-search" placeholder="Type to filter...">

<table id="route-dump">
<thead>
  <tr>
    <th class="right">Name</th>
    <th>Method</th>
    <th>Pattern</th>
    <th>Controller</th>
    <th>Action</th>
  </tr>
</thead>
<tbody>
  <cfloop array="#application.wheels.routes#" index="route">
    <tr>
      <td class="right">
        <cfif StructKeyExists(route, "name")>
          <code>#EncodeForHtml(route.name)#</code>
        </cfif>
      </td>
      <td>
        <cfif StructKeyExists(route, "methods")>
          <span class='label label-#EncodeForHtml(lcase(route.methods))#'>#EncodeForHtml(UCase(route.methods))#</span>
        </cfif>
      </td>
      <td>
        <code>#EncodeForHtml(route.pattern)#</td>
      </code>
      <td>
        <cfif StructKeyExists(route, "controller")>
          <code>#EncodeForHtml(route.controller)#</code>
        </cfif>
      </td>
      <td>
        <cfif StructKeyExists(route, "action")>
          <code>#EncodeForHtml(route.action)#</code>
        </cfif>
      </td>
    </tr>
  </cfloop>
  </tbody>
</table>

</cfoutput>

<script>

$(document).ready(function() {
  // Write on keyup event of keyword input element
  $("#route-search").keyup(function() {
    // When value of the input is not blank
    if( $(this).val() != "") {
      // Show only matching TR, hide rest of them
      $("#route-dump tbody>tr").hide();
      $("#route-dump td:contains-ci('" + $(this).val() + "')").parent("tr").show();
    } else {
      // When there is no input or clean again, show everything back
      $("#route-dump tbody>tr").show();
    }
  });
});
// jQuery expression for case-insensitive filter
$.extend($.expr[":"], {
  "contains-ci": function(elem, i, match, array) {
    return (elem.textContent || elem.innerText || $(elem).text() || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
  }
});

</script>
