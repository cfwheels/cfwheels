<cfinclude template="../layout/_header.cfm">
<cfscript>
datasourceAvailable = true;
try {
	availableMigrations = application.wheels.migrator.getAvailableMigrations();
	CreateObject("java", "java.util.Collections").reverse(availableMigrations);
	currentVersion = application.wheels.migrator.getCurrentMigrationVersion();
	if (ArrayLen(availableMigrations)) latestVersion = availableMigrations[1]["version"];
} catch (database err) {
	datasourceAvailable = false;
	message = err.message;
}
</cfscript>
<cfoutput>
	<div class="ui container">
		#pageHeader("Migrator", "Database Migrations")#

		<cfinclude template="../migrator/_navigation.cfm">
		<cfif datasourceAvailable>
		<cfif arrayLen(availableMigrations)>

			<div class="ui segment">

			<cfscript>
			latestClass = currentVersion EQ latestVersion ? "disabled" : "performmigration";
			resetClass = currentVersion EQ 0 ? "disabled" : "performmigration";
			</cfscript>
					<div class="ui button violet #latestClass#"
						data-data-url="#urlFor(route='wheelsMigratorCommand', command="migrateto", version='#latestVersion#')#">Migrate To Latest</div>

					<div class="ui button red #resetClass#"
						data-data-url="#urlFor(route='wheelsMigratorCommand', command="migrateto", version=0)#">Reset Database</div>
				#startTable(title="Available Migrations", colspan=4)#
				<cfloop from="1" to="#arrayLen(availableMigrations)#" index="m">
					<cfscript>
						mig = availableMigrations[m];
						class="";
						hasMigrated=false;
						if(mig.status EQ "migrated"){
							class="positive";
							hasMigrated=true;
						}
						if(mig.version EQ currentVersion){
							class="active";

						}
					</cfscript>
					<tr class="#class#">
						<td>
							<cfif hasMigrated>
								<i class="icon check"></i>
							<cfelse>
								<div class="ui icon button teal tiny previewsql"
									data-data-url="#urlFor(route='wheelsMigratorSQL', version='#mig.version#')#"
									data-content="Preview SQL">
									<i class="icon code"></i>
								</div>
							</cfif>
						</td>
						<td>#mig.version#</td>
						<td>#replace(mig.name, '_', ' ', 'all')#</td>
						<td>

							<cfif !hasMigrated>
								<div class="ui icon button violet tiny performmigration"
									data-data-url="#urlFor(route='wheelsMigratorCommand', command="migrateto", version='#mig.version#')#"
									data-content="Migrate To this schema (Up)">
									<i class="icon redo alternate"></i>
								</div>
							</cfif>
							<cfif hasMigrated>
								<cfif mig.version NEQ currentVersion>
								<div class="ui icon button red tiny performmigration"
									data-data-url="#urlFor(route='wheelsMigratorCommand', command="migrateto", version='#mig.version#')#"
								data-content="Migrate To this schema (Down)">
									<i class="icon undo alternate"></i>
								</div>
							</cfif>
								<div class="ui icon button red tiny performmigration"
									data-data-url="#urlFor(route='wheelsMigratorCommand', command="redomigration", version='#mig.version#')#"
								data-content="Redo This Migration (Down then Up)">
									<i class="icon sync alternate"></i>
								</div>

							</cfif>
						</td>
					</tr>
				</cfloop>
				#endTable()#
			</div>
			</div>
		<cfelse>
		<div class="ui placeholder segment">
			<div class="ui icon header">
				<i class="database icon"></i>
				No migration files found!<br><small>Perhaps start by using the templating system?</small>
			</div>
		</div>
		</cfif>
	<cfelse>

		<div class="ui placeholder segment">
			<div class="ui icon header">
				<i class="database icon"></i>
				Database Error<br><small>
			#message#</small>
			</div>
		</div>
	</cfif>

	</div><!--/container-->

	<div class="ui longer previewsqlmodal modal">
		<i class="close icon"></i>
		<div class="header">
			Preview SQL
		</div>
		<div class="content">
		<div class="ui placeholder">
			<div class="paragraph">
				<div class="line"></div>
				<div class="line"></div>
				<div class="line"></div>
				<div class="line"></div>
				<div class="line"></div>
			</div>
			<div class="paragraph">
				<div class="line"></div>
				<div class="line"></div>
				<div class="line"></div>
			</div>
		</div>
		</div>

		<div class="actions">
			<div class="ui cancel button">Close</div>
		</div>
	</div>


	<div class="ui migratorcommandmodal modal">
		<i class="close icon"></i>
		<div class="header">
			Perform Migration
		</div>
		<div class="content longer"></div>
		<div class="actions">
			<div class="ui cancel button">Close</div>
		</div>
	</div>
</cfoutput>

<script>
$(document).ready(function() {

// Click handlers
$(".previewsql").on("click", function(e){
	var url = $(this).data("data-url");
	var resp = $.ajax({
		url: url,
		method: 'get'
	})
	.done(function(data, status, req) {
		var res = $(".previewsqlmodal > .content");
		res.html(data);
		$('.ui.modal.longer.previewsqlmodal')
			.modal({
				onVisible: function(){
					hljs.initHighlightingOnLoad();
				}
			})
			.modal('show')
		;
		hljs.initHighlightingOnLoad();
	})
	.fail(function(e) {
		//alert( "error" );
	})
	.always(function(r) {
		//console.log(r);
	});
});
$(".performmigration").on("click", function(e){
	var url = $(this).data("data-url");
	var resp = $.ajax({
		url: url,
		method: 'post'
	})
	.done(function(data, status, req) {
		var res = $(".migratorcommandmodal > .content");
		res.html(data);
		$('.ui.modal.migratorcommandmodal')
			.modal({
				onHidden: function(){
					location.reload();
				},
				onVisible: function(){
					hljs.initHighlightingOnLoad();
				}
			})
			.modal('show')
		;
	})
	.fail(function(e) {
		//alert( "error" );
	})
	.always(function(r) {
		//console.log(r);
	});
});
// Popups
$('.ui.icon.button')
	.popup()
;

});
</script>
<cfinclude template="../layout/_footer.cfm">
