<template>
<div class="test-suite-list">
 <b-nav vertical class="w-25">
    <b-nav-item active>Active</b-nav-item>
    <b-nav-item>Link</b-nav-item>
    <b-nav-item>Another Link</b-nav-item>
    <b-nav-item disabled>Disabled</b-nav-item>
  </b-nav>
	<!--b-card no-body class="mb-3"
		:header="s.servername"
		v-for="s in servers"
		:key="s.servername">
		<b-list-group
			flush
			class="mb-3">
				<test-suite
				:servername="s.servername + ' - ' + d.databasename"
				:server="s.server"
				:database="d.database"
				v-for="d in databases"
				:key="s.servername + d.database"
				:disabled="!!groupIsRunning(s.server)"
				@runnerStart="startTestRunning(s.server)"
				@runnerEnd="finishTestRunning(s.server)"	/>
		</b-list-group>
	</b-card-->
</div>
</template>
<script>
export default {
	name: 'TestSuiteList',
	data(){
		return {
			testRunning: false,
			groupsRunning: [],
			servers: [
				{
					servername: 'Lucee 5',
					server: 'http://localhost:60005'
				},
				{
					servername: 'Adobe ColdFusion 2016',
					server: 'http://localhost:62016'
				},
				{
					servername: 'Adobe ColdFusion 2018',
					server: 'http://localhost:62018'
				}
			],
			databases: [
				{
					databasename: 'MySQL 5.6',
					database: 'mysql'
				},
				{
					databasename: 'MSSQL 2017',
					database: 'sqlserver'
				},
				{
					databasename: 'PostGres',
					database: 'postgres'
				}
			]
		}
	},
	methods: {
		startTestRunning(value){
			this.testRunning = true
			this.groupsRunning.push(value)
		},
		finishTestRunning(value){
			this.testRunning = false
			const index = this.groupsRunning.indexOf(value);
			if (index > -1) {
				this.groupsRunning.splice(index, 1);
			}
		},
		groupIsRunning(value){
			//var rv = this.groupsRunning.filter((g) => g === value).length || 0
			//return rv
			return this.groupsRunning.length > 0
		}
	}
}
</script>
