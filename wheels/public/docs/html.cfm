
<cfscript>

	savecontent variable="t1" {
writeOutput('
```
// Create a new author and save it to the database. newAuthor = model("author").create(params.author);
// Same as above using named arguments. newAuthor = model("author").create(firstName="John", lastName="Doe");
// Same as above using both named arguments and a struct. newAuthor = model("author").create(active=1, properties=params.author);
// If you have a `hasOne` or `hasMany` association setup from `customer` to `order` you can do a scoped call (the `createOrder` method below will call `model("order").create(customerId=aCustomer.id, shipping=params.shipping)` internally).
aCustomer = model("customer").findByKey(params.customerId);
anOrder = aCustomer.createOrder(shipping=params.shipping);
```
'
);

	}
	//writeoutput(hintOutput(t1));

	</cfscript>

<cfoutput>


<div class="row">
	<!--- Section/SubSection List --->
	<div id="sections">
		<h1 class="header">Sections</h1>
		<p style="padding-left:10px;">
		<cfloop from="1" to="#arraylen(sections)#" index="s">
			<a href=""	data-section="#cssClassLink(sections[s]['name'])#" class="section">#sections[s]['name']#</a>
			<cfloop from="1" to="#arraylen(sections[s]['categories'])#" index="ss">
				<a href=""	data-section="#cssClassLink(sections[s]['name'])#"	data-subsection="#cssClassLink(sections[s]['categories'][ss])#" class="subsection">#sections[s]['categories'][ss]#</a>
			</cfloop>
		</cfloop>
		</p>
	</div>
	<!--- A-Z Functions --->
    <div id="left">
		<h1 class="header">All Functions</h1>
		<input type="text" name="doc-search" id="doc-search" placeholder="Type to filter..." />
    	<p style="padding-left:15px">
		<a href="" class="docreset"><i class="fa fa-eye"></i> All</a>

    	<cfloop collection="#docs#" item="doc">
			<span style="display: block; font-weight: 700">#doc#</span>

			<cfloop list="#docs[doc]['functions']#" index="func">

				<cfscript>
				sectionCSSClass=structKeyExists(docs[doc]["meta"][func], "doc.section")
					? cssClassLink(docs[doc]["meta"][func]['doc.section']): "";
				subsectionCSSClass=structKeyExists(docs[doc]["meta"][func], "doc.category")
					? cssClassLink(docs[doc]["meta"][func]['doc.category']): "";
				</cfscript>

				<cfif left(func, 1) NEQ "$">
					<a href="" class="functionlink" data-section="#sectionCSSClass#" data-subsection="#subsectionCSSClass#" data-function="#lcase(func)#">#titleize(lcase(func))#()</a>
				</cfif>
			</cfloop>
		</cfloop>
		</p>
    </div><!--/col-->
    <!--- Function Definition Output --->
    <div id="right">
    	<cfloop collection="#docs#" item="doc">
		<cfloop list="#docs[doc]['functions']#" index="func">
			<cfif left(func, 1) NEQ "$">
				<cfscript>
					meta=docs[doc]["meta"][func];
					sectionCSSClass=structKeyExists(meta, "doc.section")
					? cssClassLink(meta['doc.section']): "";
					subsectionCSSClass=structKeyExists(meta, "doc.category")
					? cssClassLink(meta['doc.category']): "";

				</cfscript>
					<div id="#lcase(func)#" data-section="#sectionCSSClass#" data-subsection="#subsectionCSSClass#" class="functiondefinition">

					<h3 class="functitle">#lcase(func)#()</h3>
					<p>
					<cfif len(sectionCSSClass)>
						<a href="" class="filtersection" title="Show all Functions in this category">
						<i class="fa fa-tag"></i> #meta["doc.section"]#</a>
					</cfif>
					<cfif len(subsectionCSSClass)>
						<a href="" class="filtersubsection" title="Show all Functions in this category">
						<i class="fa fa-tag"></i> #meta["doc.category"]#</a>
					</cfif>
					<cfif structKeyExists(meta, "returnType")>
						Returns: #meta.returnType# |
					</cfif>
					 #doc#</p>
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

	$(".section").on("click", function(e){
		filterBySection($(this).data("section"));
		e.preventDefault();
	});
	$(".subsection").on("click", function(e){
		filterBySubSection($(this).data("section"), $(this).data("subsection"));
		e.preventDefault();
	});

	$(".docreset").on("click", function(e){
		$(".functiondefinition").show();
		$(".functionlink").show();
		e.preventDefault();
	});

	$(".functionlink").on("click", function(e){
		filterByFunctionName($(this).data("function"));
		e.preventDefault();
	});

	$(".filtersection").on("click", function(e){
		filterBySection($(this).closest(".functiondefinition").data("section"));
		e.preventDefault();
	});

	$(".filtersubsection").on("click", function(e){
		var parent=$(this).closest(".functiondefinition");
		filterBySubSection(parent.data("section"),parent.data("subsection"));
		e.preventDefault();
	});

	function filterByFunctionName(name){
		$("#right").find(".functiondefinition").hide().end()
				   .find("#" + name).show();
	}
	function filterBySubSection(section, subsection){
		$("#left").find(".functionlink").hide().end()
				   .find('[data-section="' + section + '"][data-subsection="' + subsection + '"]').show();
		$("#right").find(".functiondefinition").hide().end()
				   .find('[data-section="' + section + '"][data-subsection="' + subsection + '"]').show();
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

	function getCategories(){
		var categories=$(".functiondefinition").classes();
		categories.splice( $.inArray("functiondefinition", categories), 1 );
		categories.splice( $.inArray("", categories), 1 );
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
