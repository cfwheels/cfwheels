<cfparam name="docs">
<cfoutput>

	<!--- Function AZ --->
		<div class="three wide column" id="function-navigation">
			<div class="ui vertical menu fluid">
				<div class="item">
					<div class="ui input">
					<input type="text" id="doc-search" placeholder="Search...">
				</div>
				</div>
				<div class="item">
					<div class="header"><div id="functionResults">
					<span class="resultCount">
					<div class="ui active inverted dimmer">
						<div class="ui mini loader">Loading</div>
					</div>
					</span> Functions</div></div>
					<div class="menu">
						<a href="" class="item">A-Z</a>
					</div>

					<div id="atoz" class="ui list link forcescroll sticky">
					<cfloop from="1" to="#arraylen(docs.functions)#" index="func">
					<cfset meta=docs.functions[func]>
						<a href="" class="functionlink item"	data-section="#meta.tags.sectionClass#" data-category="#meta.tags.categoryClass#" data-function="#lcase(meta.slug)#">#meta.name#()</a>
					</cfloop>
					</div>
				</div>
		</div><!--/menu-->
	</div><!--/ col -->

	<!--- Functions --->
		<div class="nine wide column" id="function-output">
			<cfloop from="1" to="#arraylen(docs.functions)#" index="func">
			<cfset meta=docs.functions[func]>
			<div id="#lcase(meta.name)#"
				data-section="#meta.tags.sectionClass#"
				data-category="#meta.tags.categoryClass#"
				data-function="#lcase(meta.slug)#"
				class="functiondefinition ui raised segment ">

					<h3 class="functitle ui  ">#meta.name#()</h3>

					<cfif len(meta.tags.section)>
						<a href="" class="filtersection ui  basic purple left ribbon label" title="Show all Functions in this category">
						#meta.tags.section#</a>
					</cfif>
					<cfif len(meta.tags.category)>
						<a href="" class="filtercategory ui basic  red left label" title="Show all Functions in this category">
						#meta.tags.category#</a>
					</cfif>
					<cfif structKeyExists(meta, "returnType")>
						<span class="ui label"><i class="icon reply"></i> #meta.returnType#</span>
					</cfif>
					<cfif structKeyExists(meta, "availableIn") && arrayLen(meta.availableIn)>
						<cfloop from="1" to="#arrayLen(meta.availableIn)#" index="a">
							<span class="ui label">
								<i class="map pin icon"></i>
								#meta.availableIn[a]#
							</span>
						</cfloop>
					</cfif>
					<cfif structKeyExists(meta, "hint")>
						<p class="hint">#$hintOutput(meta.hint)#</p>
					</cfif>

					<cfif isArray(meta.parameters) && arraylen(meta.parameters)>
						<table class="ui celled striped table">
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
	</div><!--/ col -->

	<!--- Categories --->
		<div class="four wide  column" id="function-category-list">
			<div class="ui pointing vertical menu fluid  sticky">
				<cfloop from="1" to="#arraylen(docs.sections)#" index="s">
				<a href="" data-section="#$cssClassLink(docs.sections[s]['name'])#" class="section item">#docs.sections[s]['name']#</a>

				<div class="menu">
				<cfloop from="1" to="#arraylen(docs.sections[s]['categories'])#" index="ss">
					<a href=""	data-section="#$cssClassLink(docs.sections[s]['name'])#"	data-category="#$cssClassLink(docs.sections[s]['categories'][ss])#" class="item category">#docs.sections[s]['categories'][ss]#</a>
				</cfloop>
				</div>
			</cfloop>
			<div class="item">
				<div class="header">Misc</div>
				<div class="menu">
					<a href=""	data-section=""	data-category="" class="section item">Uncategorized</a>
				</div>
			</div>
	</div><!--/ col -->
</cfoutput>
