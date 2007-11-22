<cfcomponent extends="controller">

	<cffunction name="init">
		<cfset beforeFilter(filters="verifyAdmin", except="welcome")>
	</cffunction>

	<cffunction name="verifyAdmin">
		<cfif application.settings.admin.authenticate_by_method IS NOT "">
			<cfif NOT evaluate("#application.settings.admin.authenticate_by_method#()")>
				<cfabort>
			</cfif>
		</cfif>
		<cfif application.settings.admin.authenticate_by_ip IS NOT "">
			<cfif listFind(application.settings.admin.authenticate_by_ip, CGI.remote_addr) IS 0>
				<cfabort>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>

	<cffunction name="welcome">
		<cfset version = 0.7>
		<cfset renderPage(show_debug=false)>
	</cffunction>

	<cffunction name="admin">
		<cfdirectory action="list" directory="#expandPath('models')#" filter="*.cfc" name="model_files">
		<cfset models = "">
		<cfloop query="model_files">
			<cfif name IS NOT "model.cfc">
				<cfset models = listAppend(models, replace(name, ".cfc", ""))>
			</cfif>
		</cfloop>
		<cfset renderPage(layout=application.settings.admin.layout)>
	</cffunction>

	<cffunction name="list">
		<cfparam name="params.page" default="1">
		<cfparam name="params.per_page" default="50">
		<cfset args.order = "id">
		<cfset args.page = params.page>
		<cfset args.per_page = params.per_page>
		<cfif structKeyExists(params, "primary_key") AND params.primary_key IS NOT "">
			<cfif NOT isNumeric(params.primary_key)>
				<cfset params.primary_key = decryptParam(params.primary_key)>
			</cfif>
			<cfset args.where = "id=#params.primary_key#">
		</cfif>
		<cfset records = model(params.model).findAll(argumentCollection=args)>
		<cfset total_records = paginationTotalRecords()>
		<cfset columns = structKeyList(model(params.model).getcolumns())>
		<cfset page_title = pluralize(params.model)>
		<cfset start_at = (params.page*params.per_page)-49>
		<cfif total_records LT params.page*params.per_page>
			<cfset end_at = total_records>
		<cfelse>
			<cfset end_at = params.page*params.per_page>
		</cfif>
		<cfset renderPage(layout=application.settings.admin.layout)>
	</cffunction>

	<cffunction name="edit">
		<cfif isPost()>
			<cfset record = model(params.model).findByID(params.primary_key)>
			<cfset record.update(params.record)>
			<cfif record.save()>
				<cfset flash(notice="Update successful!")>
				<cfset redirectTo(params.backlink)>
			<cfelse>
				<cfset flash(alert="Update failed!")>
				<cfset renderPage(action="edit")>
			</cfif>
		<cfelse>
			<cfif structKeyExists(params, "primary_key") AND params.primary_key IS NOT "">
				<cfset record = model(params.model).findByID(params.primary_key)>
			<cfelse>
				<cfset record = model(params.model).new()>
			</cfif>
		</cfif>
		<cfset renderPage(layout=application.settings.admin.layout)>
	</cffunction>

	<cffunction name="delete">
		<cfset record =  model(params.model).findByID(params.primary_key)>
		<cfif record.delete()>
			<cfset flash(notice="Delete successful!")>
		<cfelse>
			<cfset flash(alert="Delete failed!")>
		</cfif>
		<cfset redirectTo(back=true)>
	</cffunction>

</cfcomponent>