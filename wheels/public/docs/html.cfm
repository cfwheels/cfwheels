<cfoutput>
<div class="row">
    <div id="left">
		<input type="text" name="doc-search" id="doc-search" placeholder="Type to filter..." />
    	<p style="padding-left:15px">
		<cfloop list="#controllerFunctions#" index="func">
				<cfif left(func, 1) NEQ "$">
					<a href="" class="doclink" data-section="#lcase(func)#">#titleize(lcase(func))#()</a>
				</cfif>
		</cfloop>
		</p>
    </div><!--/col-->
    <div id="right">
		<cfloop list="#controllerFunctions#" index="func">
			<cfif left(func, 1) NEQ "$">
				<cfset meta=GetMetaData(controllerScope[func])>
					<div id="#lcase(func)#" class="docsection">
					<h3 class="functitle">#lcase(func)#()</h3>
					<cfif structKeyExists(meta, "hint")>
						#hintOutput(meta.hint)#
					</cfif>
					<cfif isArray(meta.parameters) && arraylen(meta.parameters)>
						<table>
						<caption>Parameters</caption>
						<thead>
							<tr>
								<th>Name</th>
								<th>Type</th>
								<th>Required</th>
								<th>Default</th>
								<th>Description</th>
							</tr>
						</thead>
						<tbody>
						<cfloop from="1" to="#arraylen(meta.parameters)#" index="_param">
							<tr>
								<td><cfif structkeyExists(meta.parameters[_param], "name")>#meta.parameters[_param]['name']#</cfif></td>
								<td><cfif structkeyExists(meta.parameters[_param], "type")>#meta.parameters[_param]['type']#</cfif></td>
								<td><cfif structkeyExists(meta.parameters[_param], "Required")>#meta.parameters[_param]['required']#</cfif></td>
								<td>
								<cfif
									structKeyExists(application.wheels.functions, func)
									AND structKeyExists(application.wheels.functions[func], meta.parameters[_param]['name'])>
									#application.wheels.functions[func][meta.parameters[_param]['name']]#
								</cfif>
								<cfif structkeyExists(meta.parameters[_param], "default")>#meta.parameters[_param]['default']#</cfif></td>
								<td><cfif structkeyExists(meta.parameters[_param], "hint")>#meta.parameters[_param]['hint']#</cfif></td>
							</tr>
						</cfloop>
						</tbody>
						</table>
					<cfelse>
						<p>No Parameters</p>
					</cfif>
					</div><!--/ #lcase(func)# -->
				</cfif>
			</cfloop>
    	</div><!--/col-->
</div><!--/row-->

</cfoutput>
<script>
$(document).ready(function(){

	$(".doclink").on("click", function(e){
		var section=$(this).data("section");
		$(".docsection").hide();
		$("#" + section).show();
		e.preventDefault();
	});


  // Write on keyup event of keyword input element
  $("#doc-search").keyup(function(){
    // When value of the input is not blank
    if( $(this).val() != "")
    {
      // Show only matching TR, hide rest of them
      $("#left a").hide();
      $("#left a:contains-ci('" + $(this).val() + "')").show();
    }
    else
    {
      // When there is no input or clean again, show everything back
      $("#left a").show();
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
