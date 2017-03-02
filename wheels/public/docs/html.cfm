<cfoutput>
<div class="row">
    <div id="left">
		<input type="text" name="doc-search" id="doc-search" placeholder="Type to filter..." />
    	<p style="padding-left:15px">
		<a href="" class="docreset"><i class="fa fa-eye"></i> All</a>

    	<cfloop collection="#docs#" item="doc">
			<span style="display: block; font-weight: 700">#doc#</span>
			<cfif arrayLen(docs[doc]['categories'])>
				<cfloop from="1" to="#arraylen(docs[doc]['categories'])#" index="cat">
					<a href="" class="filtercategory"
						title="Show all Functions in this category"
						data-category="#cssClassLink(docs[doc]['categories'][cat])#">
						<i class="fa fa-tag"></i> #docs[doc]['categories'][cat]#</a>
	    		</cfloop>
			</cfif>
			<cfloop list="#docs[doc]['functions']#" index="func">

				<cfscript>
				categoryCSSClass=structKeyExists(docs[doc]["meta"][func], "doc.category")
					? cssClassLink(docs[doc]["meta"][func]['doc.category']): "";
				</cfscript>

				<cfif left(func, 1) NEQ "$">
					<a href="" class="doclink #categoryCSSClass#" data-section="#lcase(func)#">#titleize(lcase(func))#()</a>
				</cfif>
			</cfloop>
		</cfloop>
		</p>
    </div><!--/col-->
    <div id="right">
    	<cfloop collection="#docs#" item="doc">
		<cfloop list="#docs[doc]['functions']#" index="func">
			<cfif left(func, 1) NEQ "$">
				<cfscript>
					meta=docs[doc]["meta"][func];
					if(structKeyExists(meta, "doc.category")){
						categoryCSSClass=cssClassLink(meta['doc.category']);
					} else {
						categoryCSSClass="";
					}
				</cfscript>
					<div id="#lcase(func)#" class="docsection #categoryCSSClass#">

					<h3 class="functitle">#lcase(func)#()</h3>
					<p>
					<cfif len(categoryCSSClass)>
						<a href="" class="filtercategory" title="Show all Functions in this category" data-category="#categoryCSSClass#">
						<i class="fa fa-tag"></i> #meta["doc.category"]#</a> |
					</cfif>
					Returns: #meta.returnType# | #doc#</p>
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
			</cfloop>
    	</div><!--/col-->
</div><!--/row-->

</cfoutput>
<script>
$(document).ready(function(){

	getCategories();

	$(".docreset").on("click", function(e){
		$(".docsection").show();
	});

	$(".doclink").on("click", function(e){
		filterByFunctionName($(this).data("section"));
		e.preventDefault();
	});

	$(".filtercategory").on("click", function(e){
		filterByCategory($(this).data("category"));
		e.preventDefault();
	});

	function filterByFunctionName(name){
		$("#right").find(".docsection").hide().end()
				   .find("#" + name).show();
	}
	function filterByCategory(category){
		$("#left").find(".doclink").hide().end()
				   .find("." + category).show();
		$("#right").find(".docsection").hide().end()
				   .find("." + category).show();
	}

	function getCategories(){
		var categories=$(".docsection").classes();
		categories.splice( $.inArray("docsection", categories), 1 );
		categories.splice( $.inArray("", categories), 1 );
		console.log(categories);
	}

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

;!(function ($) {
    $.fn.classes = function (callback) {
        var classes = [];
        $.each(this, function (i, v) {
            var splitClassName = v.className.split(/\s+/);
            for (var j = 0; j < splitClassName.length; j++) {
                var className = splitClassName[j];
                if (-1 === classes.indexOf(className)) {
                    classes.push(className);
                }
            }
        });
        if ('function' === typeof callback) {
            for (var i in classes) {
                callback(classes[i]);
            }
        }
        return classes;
    };
})(jQuery);

</script>
