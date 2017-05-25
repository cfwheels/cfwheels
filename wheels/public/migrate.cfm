<cfoutput>

<div id="migrator">

<h1>Database Migrations</h1>
<p>Database Migrations are an easy way to build and alter your database structure using cfscript.</p>

<!--- JSON Messages:--->
<div id="messages"></div>

<div class="tabs">

    <ul class="tab-links">
        <li class="active"><a href="##tabinfo"><i class="fa fa-info-circle"></i> Info</a></li>
        <li><a href="##tabcreate"><i class="fa fa-plus-circle"></i> Create Template</a></li>
        <li><a href="##tabmigrate"><i class="fa fa-database"></i> Migrations</a></li>
    </ul>

	<div class="tab-content">
	    <div id="tabinfo" class="tab active">
			<!--- this is updated via ajax on each remote request --->
			<h5>Database Info</h5>
			<section id="dbinfo">
				 <div class="row">
			      	<div class="column">
			      		<strong>Database Type</strong>
			      		<code id="databaseType">-</code>
			  		</div>
			      	<div class="column">
			      		<strong>Datasource</strong>
			      		<code id="dataSourceName">-</code>
			  		</div>
			      	<div class="column">
			      		<strong>Database Version</strong>
			      		<code id="currentVersion">-</code>
			  		</div>
			    </div>
			</section>
	   </div>

   <div id="tabcreate" class="tab">

		<section id="creation">

			<!--- Migration Prefix --->
			<div id="prefix" style="display: none;">
					<h5>Migration Prefix</h5>
					<p class="help"><i class="fa fa-info-circle"></i> As you have no migration files yet, we need to define how you would like them prefixed</p>
					<input type="radio" name="migrationPrefix" value="timestamp" checked> Timestamp <span class="help">(e.g. <code>#dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#</code>)  <-- Recommended</span><br>
					<input type="radio" name="migrationPrefix" value="numeric"> Numeric <span class="help">(e.g. <code>001</code>)</span><br>
			</div>


			<!--- Create --->
			<h5>Create a Template</h5>
			<div  id="migrator-templates" class="row">
				<div class="column">
					<p class="help"><i class="fa fa-info-circle"></i> Create a blank migration file or use a pre-existing template:</p>
					<input type="radio" name="templateName" value="blank" checked> Create a blank migration file<br><br>

					<div class="row">
						<div class="column">
							<strong>Tables</strong><br>
							<input type="radio" name="templateName" value="create-table"><label class="label-inline"> Create table</label><br>
							<input type="radio" name="templateName" value="change-table"><label class="label-inline"> Change table (multi-column)</label><br>
							<input type="radio" name="templateName" value="rename-table"><label class="label-inline"> Rename table</label><br>
							<input type="radio" name="templateName" value="remove-table"><label class="label-inline"> Remove table</label><br>
						</div>
						<div class="column">
							<strong>Columns</strong><br>
							<input type="radio" name="templateName" value="create-column"><label class="label-inline"> Create single column</label><br>
							<input type="radio" name="templateName" value="change-column"><label class="label-inline"> Change single column</label><br>
							<input type="radio" name="templateName" value="rename-column"><label class="label-inline"> Rename single column</label><br>
							<input type="radio" name="templateName" value="remove-column"><label class="label-inline"> Remove single column</label><br>
						</div>
						<div class="column">
							<strong>Records</strong><br />
							<input type="radio" name="templateName" value="create-record"><label class="label-inline"> Create record</label><br />
							<input type="radio" name="templateName" value="update-record"><label class="label-inline"> Update record</label><br />
							<input type="radio" name="templateName" value="remove-record"><label class="label-inline"> Remove record</label><br />
						</div>

						<div class="column">
							<strong>Other</strong><br />
							<input type="radio" name="templateName" value="create-index"><label class="label-inline"> Create index</label><br />
							<input type="radio" name="templateName" value="remove-index"><label class="label-inline"> Remove index</label><br />
							<input type="radio" name="templateName" value="announce"><label class="label-inline"> Announce operation</label><br />
							<input type="radio" name="templateName" value="execute"><label class="label-inline"> Execute operation</label><br />
						</div>
					</div>

					<label for="migrationName">Migration description:</label>
					<input name="migrationName" id="migrationName" type="text" class="" placeholder=" (eg. 'creates member table')">

					<input type="submit" value="Create Migration File" class="button button-outline createMigration" data-command="createMigration">
				</div>
			</div>
		</section>
   </div>

	<div id="tabmigrate" class="tab">
		<section id="migrations" style="display: none;">
			<h5>Migrate:</h5>
				<div id="dangerous-actions">
					<button class="resetMigration button button-small"><i class="fa fa-exclamation-triangle"></i> Reset Database</button>
					<button class="migrateLatest button button-small"><i class="fa fa-exclamation-triangle"></i> Migrate to Latest</button>
				</div>
				<div id="migrationlist"></div>
		</section>
   </div>

</div><!--/tabcontent-->
</div><!--/tabs-->
</div><!--/migrator-->

</cfoutput>

<script>
$(document).ready(function() {

	getInfo();
	$("#prefix").hide();

	$(".createMigration").on("click", function(e){
		var data=$(this).data();
			data.migrationPrefix=$("input[name='migrationPrefix']:checked").val();
			data.templateName=$("input[name='templateName']:checked").val();
			data.migrationName=$("#migrationName").val();
		$(".button").prop('disabled', true);
		remoteSend(data);
		getInfo();
		e.preventDefault();
	});

	$(".remote-command").on("click", function(e){
		remoteSend($(this).data());
	});

	function getInfo(){
		remoteSend({"command": "info"});
	}

	function updateDisplay(data){
		$("#messages").html();

		// Handle error display
		if(!data.success){
			$("#messages").addClass("failure-message").html("<span class='failure-message-item'>" + data.MESSAGES + "</span>");
		} else {
			// Don't display certain messages
			if(data.command != "info"){
				if(typeof data.message != undefined){
					$("#messages").html("<pre>" + data.message + "</pre>");
					scrollToElement($('#migrator'));
				}
			}
			if(data.messages.length){
				$("#messages").addClass("alert").html(data.messages);
				scrollToElement($('#migrator'));
			}
			// If there are no migrations yet, we need to know the prefix
			if(!data.migrations.length){
				$("#prefix").show();
				$("#migrations").hide();
				$("#tabmigrate").append("<p>No Migrations available</p>");
			} else {
				var ml="";
				$("#prefix").hide();
				for(m in data.migrations){
					var migration=data.migrations[m];
					var s="<div class='migration row " + isCurrentMigration(migration.VERSION, data.currentVersion)
						+ "'><div class='version column'>" + migration.VERSION + "</div>"
						+ "<div class='name column'>" + migration.NAME + "</div>"
						+ "<div class='actions column'>";
						if(migration.STATUS.length == 0){
							s+="<button class='migrate domigrate button-small button'>Migrate To <i class='fa fa-arrow-right'></i></button>";
						} else {
							s+="<button class='redo button-small button'><i class='fa fa-refresh'></i> Redo</button>";
							if(isCurrentMigration(migration.VERSION, data.currentVersion)	){
								s+="<button class='currentVersion button-small button'><i class='fa fa-check'></i> Current</button>";
							} else {
								s+="<button class='migrate migrated button-small button'><i class='fa fa-arrow-up'></i> Roll Back</button>";
							}
						}
						s+="</div></div>";
						ml=ml + s;
				}
				$("#migrationlist").html(ml);
				$("#migrations").show();
				assignClickHandlers();
			}
			$("#databaseType").html(data.databaseType);
			$("#dataSourceName").html(data.datasource);
			$("#currentVersion").html(data.currentVersion);
			$("#currentVersion").data("version", data.currentVersion);
		}

	}

	function isCurrentMigration(version, latest){
		if(version == latest){
			return "currentVersion";
		} else {
			return "";
		}
	}
	/*
	function assignStatusClass(status, version, latest){
		if(status.length == 0){
			return "domigrate";
		} else {
			return "migrated";
		}
	}
	function assignStatus(status, version, latest){

		if(status.length == 0){
			return "Migrate To";
		} else {
			if(version == latest){
				return "Current";
			} else {
				return "Roll Back";
			}
		}
	}*/

	function assignClickHandlers(){
		$(".migrate").on("click", function(e){
			remoteSend({
				"command": "migrateTo",
				"version": $(this).closest(".migration").find(".version").html()
			});
			e.preventDefault();
		});
		$(".resetMigration").on("click", function(e){
			remoteSend({
				"command": "migrateTo",
				"version": 0
			});
			e.preventDefault();
		});
		$(".migrateLatest").on("click", function(e){
			remoteSend({
				"command": "migrateToLatest"
			});
			e.preventDefault();
		});
		$(".redo").on("click", function(e){
			remoteSend({
				"command": "redoMigration",
				"version": $(this).closest(".migration").find(".version").html()
			});
			e.preventDefault();
		});
	}

	function remoteSend(data){
		// We're using the same method the CLI uses to perform a command and return some JSON
		var commandURL="?controller=wheels&action=wheels&view=cli";

		$.ajax({
			url: commandURL,
			type: 'GET',
			data: data
		})
		.done(function(r) {
			console.log(r);
			if(r.command != "info"){
				getInfo();
			}
			updateDisplay(r);
		})
		.fail(function(f) {
			console.log(f);
		})
	}

	// Tabs
    $('.tabs .tab-links a').on('click', function(e)  {
        var currentAttrValue = $(this).attr('href');

        // Show/Hide Tabs
        $('.tabs ' + currentAttrValue).fadeIn(400).siblings().hide();

        // Change/remove current tab to active
        $(this).parent('li').addClass('active').siblings().removeClass('active');

        e.preventDefault();
    });

    function scrollToElement(ele) {
	    $(window).scrollTop(ele.offset().top).scrollLeft(ele.offset().left);
	}

});
</script>
