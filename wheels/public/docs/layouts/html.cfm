<cfparam name="docs">
<cfoutput>
<div class="row">
	<!--- Section/category List --->
	<div id="sections">
		<h1 class="header">Sections</h1>
		<p style="padding-left:10px;">
		<cfloop from="1" to="#arraylen(docs.sections)#" index="s">
			<a href=""	data-section="#$cssClassLink(docs.sections[s]['name'])#" class="section">#docs.sections[s]['name']#</a>
			<cfloop from="1" to="#arraylen(docs.sections[s]['categories'])#" index="ss">
				<a href=""	data-section="#$cssClassLink(docs.sections[s]['name'])#"	data-category="#$cssClassLink(docs.sections[s]['categories'][ss])#" class="category">#docs.sections[s]['categories'][ss]#</a>
			</cfloop>
		</cfloop>
		<a href=""	data-section=""	data-category="" class="section">Uncategorized</a>
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
				<a href="" class="functionlink"	data-section="#meta.tags.sectionClass#" data-category="#meta.tags.categoryClass#" data-function="#lcase(meta.slug)#">#meta.name#()</a>
			</cfloop>
		</p>
    </div><!--/col-->
    <!--- Function Definition Output --->
    <div id="right">
		<cfloop from="1" to="#arraylen(docs.functions)#" index="func">
			<cfset meta=docs.functions[func]>
			<div id="#lcase(meta.name)#"
				data-section="#meta.tags.sectionClass#"
				data-category="#meta.tags.categoryClass#"
				data-function="#lcase(meta.slug)#"
				class="functiondefinition">
					<h3 class="functitle">#meta.name#()</h3>
					<p>
					<cfif len(meta.tags.section)>
						<a href="" class="filtersection tag" title="Show all Functions in this category">
						<i class="fa fa-tag"></i> #meta.tags.section#</a>
					</cfif>
					<cfif len(meta.tags.category)>
						<a href="" class="filtercategory tag" title="Show all Functions in this category">
						<i class="fa fa-tag"></i> #meta.tags.category#</a>
					</cfif>
					<cfif structKeyExists(meta, "returnType")>
						<span class="tag"><i class="fa fa-reply"></i> #meta.returnType#</span>
					</cfif>
					<cfif structKeyExists(meta, "availableIn") && arrayLen(meta.availableIn)>
						<cfloop from="1" to="#arrayLen(meta.availableIn)#" index="a">
							<span class="tag"><i class="fa fa-bolt"></i> #meta.availableIn[a]#</span>
						</cfloop>
					</cfif>
					  </p>
					<cfif structKeyExists(meta, "hint")>
						<div class="hint">#$hintOutput(meta.hint)#</div>
					</cfif>

					<cfif isArray(meta.parameters) && arraylen(meta.parameters)>
						<table>
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
						<cfloop from="1" to="#arraylen(meta.parameters)#" index="p">
						<cfset _param=meta.parameters[p]>
							<cfif !left(_param.name, 1) EQ "$">
								<tr>
									<td class='code'>#_param.name#</td>
									<td class='code'><cfif StructkeyExists(_param, "type")>#_param.type#</cfif></td>
									<td class='code'><cfif StructkeyExists(_param, "required")>#YesNoFormat(_param.required)#</cfif></td>
									<td class='code'><cfif StructkeyExists(_param, "default")>#_param.default#</cfif></td>
									<td><cfif StructkeyExists(_param, "hint")>#$backTickReplace(_param.hint)#</cfif></td>
								</tr>
							</cfif>
						</cfloop>
						</tbody>
						</table>
					</cfif>

					<cfif meta.extended.hasExtended>
						<div class="md">#meta.extended.docs#</div>
					</cfif>

				</div><!--/ #lcase(meta.name)# -->
		</cfloop>
    	</div><!--/col-->
</div><!--/row-->

</cfoutput>
<script>
$(document).ready(function(){

	checkForUrlHash();

	$(window).on('hashchange',function(){
		filterByFunctionName(location.hash.slice(1));
	});

	$(".section").on("click", function(e){
		filterBySection($(this).data("section"));
		updateFunctionCount();
		e.preventDefault();
	});
	$(".category").on("click", function(e){
		filterByCategory($(this).data("section"), $(this).data("category"));
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
		$(".functionlink").removeClass("active");
		$(this).addClass("active");
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
		filterByCategory(parent.data("section"),parent.data("category"));
		updateFunctionCount();
		e.preventDefault();
	});

	function filterByFunctionName(name){
		$("#right").find(".functiondefinition").hide().end()
				   .find("[data-function='" + name + "']").show().end()
				   .find("#" + name).show();
		window.location.hash="#" + name;
	}
	function filterByCategory(section, category){
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
	function updateFunctionCount(){
		$("#left h1.header span").html($("#left a.functionlink:visible").length);
	}

	function checkForUrlHash(){
		var match = location.hash.match(/^#?(.*)$/)[1];
		if (match){filterByFunctionName(match);}
	}

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
