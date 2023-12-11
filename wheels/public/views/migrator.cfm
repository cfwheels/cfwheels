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
<!--- cfformat-ignore-start --->
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
									<svg xmlns="http://www.w3.org/2000/svg" height="12" width="14" viewBox="0 0 640 512"><path fill="##ffffff" d="M392.8 1.2c-17-4.9-34.7 5-39.6 22l-128 448c-4.9 17 5 34.7 22 39.6s34.7-5 39.6-22l128-448c4.9-17-5-34.7-22-39.6zm80.6 120.1c-12.5 12.5-12.5 32.8 0 45.3L562.7 256l-89.4 89.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0l112-112c12.5-12.5 12.5-32.8 0-45.3l-112-112c-12.5-12.5-32.8-12.5-45.3 0zm-306.7 0c-12.5-12.5-32.8-12.5-45.3 0l-112 112c-12.5 12.5-12.5 32.8 0 45.3l112 112c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L77.3 256l89.4-89.4c12.5-12.5 12.5-32.8 0-45.3z"/></svg>
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
									<svg xmlns="http://www.w3.org/2000/svg" height="12" width="12" viewBox="0 0 512 512"><path fill="##ffffff" d="M463.5 224H472c13.3 0 24-10.7 24-24V72c0-9.7-5.8-18.5-14.8-22.2s-19.3-1.7-26.2 5.2L413.4 96.6c-87.6-86.5-228.7-86.2-315.8 1c-87.5 87.5-87.5 229.3 0 316.8s229.3 87.5 316.8 0c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0c-62.5 62.5-163.8 62.5-226.3 0s-62.5-163.8 0-226.3c62.2-62.2 162.7-62.5 225.3-1L327 183c-6.9 6.9-8.9 17.2-5.2 26.2s12.5 14.8 22.2 14.8H463.5z"/></svg>
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
				<svg xmlns="http://www.w3.org/2000/svg" height="70" width="50" viewBox="0 0 448 512"><path d="M448 73.1v45.7C448 159.1 347.7 192 224 192S0 159.1 0 118.9V73.1C0 32.9 100.3 0 224 0s224 32.9 224 73.1zM448 176v102.9C448 319.1 347.7 352 224 352S0 319.1 0 278.9V176c48.1 33.1 136.2 48.6 224 48.6S399.9 209.1 448 176zm0 160v102.9C448 479.1 347.7 512 224 512S0 479.1 0 438.9V336c48.1 33.1 136.2 48.6 224 48.6S399.9 369.1 448 336z"/></svg><br>
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
		<svg xmlns="http://www.w3.org/2000/svg" height="16" width="12" viewBox="0 0 384 512"><path fill="##ffffff" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"/></svg>
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
		<svg xmlns="http://www.w3.org/2000/svg" height="16" width="12" viewBox="0 0 384 512"><path fill="##ffffff" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"/></svg>
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
<!--- cfformat-ignore-end --->
