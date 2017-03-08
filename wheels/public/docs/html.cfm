<cfoutput>

<div class="row">
	<!--- Section/category List --->
	<div id="sections">
		<h1 class="header">Sections</h1>
		<p style="padding-left:10px;">
		<cfloop from="1" to="#arraylen(docs.sections)#" index="s">
			<a href=""	data-section="#cssClassLink(docs.sections[s]['name'])#" class="section">#docs.sections[s]['name']#</a>
			<cfloop from="1" to="#arraylen(docs.sections[s]['categories'])#" index="ss">
				<a href=""	data-section="#cssClassLink(docs.sections[s]['name'])#"	data-category="#cssClassLink(docs.sections[s]['categories'][ss])#" class="category">#docs.sections[s]['categories'][ss]#</a>
			</cfloop>
		</cfloop>
		</p>
	</div>
	<!--- A-Z Functions --->
    <div id="left">
		<h1 class="header">A-Z Functions <small>(<span>#arraylen(docs.functions)#</span>)</small></h1>
		<input type="text" name="doc-search" id="doc-search" placeholder="Type to filter..." />
    	<p>
			<a href="" class="docreset"><i class="fa fa-eye"></i> All</a>
			<cfloop from="1" to="#arraylen(docs.functions)#" index="func">
			<cfset meta=docs.functions[func]>
				<a href="" class="functionlink"	data-section="#meta.sectionClass#" data-category="#meta.categoryClass#" data-function="#lcase(meta.name)#">#meta.name#()</a>
			</cfloop>
		</p>
    </div><!--/col-->
    <!--- Function Definition Output --->
    <div id="right">
		<cfloop from="1" to="#arraylen(docs.functions)#" index="func">
			<cfset meta=docs.functions[func]>
			<div id="#lcase(meta.name)#"
				data-section="#meta.sectionClass#"
				data-category="#meta.categoryClass#"
				class="functiondefinition">
					<h3 class="functitle">#meta.name#()</h3>
					<p>
					<cfif len(meta.section)>
						<a href="" class="filtersection tag" title="Show all Functions in this category">
						<i class="fa fa-tag"></i> #meta.section#</a>
					</cfif>
					<cfif len(meta.category)>
						<a href="" class="filtercategory tag" title="Show all Functions in this category">
						<i class="fa fa-tag"></i> #meta.category#</a>
					</cfif>
					<cfif structKeyExists(meta, "returnType")>
						<span class="tag"><i class="fa fa-reply"></i> #meta.returnType#</span>
					</cfif>
					  </p>
					<cfif structKeyExists(meta, "hint")>
						<div class="hint">#hintOutput(meta.hint)#</div>
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
					</cfif>

					<cfif meta.hasExtended>
						<div class="md">#meta.extended#</div>
					</cfif>

				</div><!--/ #lcase(meta.name)# -->
		</cfloop>
    	</div><!--/col-->
</div><!--/row-->

</cfoutput>
<script>
$(document).ready(function(){

	$.each($(".md"), function( index, md ) {
		var converter = new showdown.Converter();
	  	var markdown=$(md).html();
	  	$(md).html(converter.makeHtml(markdown));
	});

	$(".section").on("click", function(e){
		filterBySection($(this).data("section"));
		updateFunctionCount();
		e.preventDefault();
	});
	$(".category").on("click", function(e){
		filterBycategory($(this).data("section"), $(this).data("category"));
		updateFunctionCount();
		e.preventDefault();
	});

	$(".docreset").on("click", function(e){
		$(".functiondefinition").show();
		$(".functionlink").show();
		updateFunctionCount();
		e.preventDefault();
	});

	$(".functionlink").on("click", function(e){
		filterByFunctionName($(this).data("function"));
		updateFunctionCount();
		e.preventDefault();
	});

	$(".filtersection").on("click", function(e){
		filterBySection($(this).closest(".functiondefinition").data("section"));
		updateFunctionCount();
		e.preventDefault();
	});

	$(".filtercategory").on("click", function(e){
		var parent=$(this).closest(".functiondefinition");
		filterBycategory(parent.data("section"),parent.data("category"));
		updateFunctionCount();
		e.preventDefault();
	});

	function filterByFunctionName(name){
		$("#right").find(".functiondefinition").hide().end()
				   .find("#" + name).show();
	}
	function filterBycategory(section, category){
		$("#left").find(".functionlink").hide().end()
				   .find('[data-section="' + section + '"][data-category="' + category + '"]').show();
		$("#right").find(".functiondefinition").hide().end()
				   .find('[data-section="' + section + '"][data-category="' + category + '"]').show();
	}
	function filterBySection(section){
		$("#left").find(".functionlink").hide().end()
				   .find('[data-section="' + section + '"]').show();
		$("#right").find(".functiondefinition").hide().end()
				   .find('[data-section="' + section + '"]').show();
	}
	function filterByCategory(category){
		$("#left").find(".functionlink").hide().end()
				   .find("." + category).show();
		$("#right").find(".functiondefinition").hide().end()
				   .find("." + category).show();
	}
	function updateFunctionCount(){
		$("#left h1.header span").html($("#left a.functionlink:visible").length);
	}

	//function getCategories(){
	//	var categories=$(".functiondefinition").classes();
	//	categories.splice( $.inArray("functiondefinition", categories), 1 );
	//	categories.splice( $.inArray("", categories), 1 );
	//}

  // Write on keyup event of keyword input element
  $("#doc-search").keyup(function(){
    // When value of the input is not blank
    if( $(this).val() != "")
    {
      // Show only matching TR, hide rest of them
      $("#left a").hide();
      $("#left a:contains-ci('" + $(this).val() + "')").show();
		updateFunctionCount();
    }
    else
    {
      // When there is no input or clean again, show everything back
      $("#left a").show();
      updateFunctionCount();
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
