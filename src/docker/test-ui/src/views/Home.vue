<template>
<div class="home">
	<div class="container-fluid mt-5">
	<b-row>
		<b-col lg="4">
			<b-card flush header="Run Tests:" border-variant="secondary" :no-body='true'>
				<b-list-group>
					<b-list-group-item v-for="t in testsuites" title="Add Test to Queue" :key="t.id" button @click="addToQueue(t)">
						<b-icon icon="plus-circle" /> {{t.displayname}}
					</b-list-group-item>
				</b-list-group>

				<b-form-group label="Execution Order" class="m-3">
					<b-form-radio-group
						id="executionOrder"
						v-model="executionOrder"
						:options="executionOrders"
						stacked
						name="executionOrder"
						></b-form-radio-group>
					</b-form-group>
				</b-card>
				<b-card class="mt-3" flush header="Open Server" :no-body='true'>
				<b-list-group>
					<b-list-group-item v-for="s in servers" title="Open Server in New Window" :href="s.server" target="_blank" :key="s.servername">
						{{s.servername}} <b-icon icon="box-arrow-up-right" />
					</b-list-group-item>
				</b-list-group>
			</b-card>
		</b-col>
		<b-col lg="8">
			<b-card no-body>
				<b-card-header>
				<div class="d-flex flex-row">
					<h6><b-icon icon="card-list" /> Queue</h6>
					<b-btn-group class="ml-auto">
						<b-btn variant="success" size="sm" v-if="queue.length && !queueIsRunning" @click="startQueue">
							<b-icon icon="play-fill" /> Start Queue</b-btn>
						<b-btn variant="warning" size="sm" v-if="queue.length && queueIsRunning" @click="stopQueue">
							<b-icon icon="stop-fill" /> Stop Queue</b-btn>
						<b-btn variant="danger" size="sm" v-if="queue.length" :disabled="queueIsRunning" @click="clearQueue">
							<b-icon icon="trash-fill" /> Clear Queue</b-btn>
						<b-btn variant="danger" size="sm"  @click="clearAll">
							<b-icon icon="trash-fill" /> Clear All</b-btn>
					</b-btn-group>
				</div>
			</b-card-header>
				<p class="text-center mt-3" v-if="!queue.length">No Tests added yet. <br><em>Click on a test on the left to add it to the queue.</em></p>
				<b-row class="p-1" v-for="(v, i) in queue" :key="i">
					<b-col md="1">
						<b-badge v-if="v.status === 'done'" variant="success">{{v.status}}</b-badge>
						<b-badge v-if="v.status === 'errored'" variant="danger">{{v.status}}</b-badge>
						<b-badge v-if="v.status === 'waiting'" variant="light">{{v.status}}</b-badge>
						<b-badge v-if="v.status === 'running'" variant="warning">{{v.status}}</b-badge>
						<b-badge v-if="v.status === 'pending'" variant="info">{{v.status}}</b-badge>
					</b-col>
					<b-col md="1"><b-spinner small v-if="v.status === 'running'" /></b-col>
					<b-col md="10">{{v.displayname}}</b-col>
				</b-row>
			</b-card>

			<b-card no-body class="mt-3">
				<b-card-header>
					<div class="d-flex flex-row">
						<h6>Console</h6>
						<b-btn size="sm" class="ml-auto" v-if="status.length" variant="link" @click="clearStatus"><b-icon icon="trash-fill" /> Clear</b-btn>
					</div>
				</b-card-header>
				<p class="text-center mt-3" v-if="!status.length">Nothing here yet</p>
				<div v-if="status.length">
					<b-row class="p-1" v-for="(s, index) in status" :key="index">
						<b-col md="1"><b-badge :variant="s.type">{{formatTime(s.when)}}</b-badge></b-col>
						<b-col md="11">{{s.message}}</b-col>
					</b-row>
				</div>
			</b-card>
			<b-card class="mt-3" no-body>
				<b-card-header>
					<div class="d-flex flex-row">
						<h6>Results</h6>
						<b-btn size="sm" class="ml-auto" v-if="jobs.length" variant="link" @click="clearJobs"><b-icon icon="trash-fill" /> Clear</b-btn>
					</div>
				</b-card-header>
				<p class="text-center mt-3" v-if="!jobs.length">No results returned yet</p>
				<div v-if="jobs.length">
					<b-card
						no-body
						v-for="(j, index) in jobs" :key="index"
						class="m-3"
						:border-variant="j.data.OK === true? 'success' : 'danger'"
					>
						<b-card-header
						:header-bg-variant="j.data.OK === true? 'success' : 'danger'"
						header-text-variant="white">
							<div class="d-flex flex-row">
								<h6>{{j.displayname}}</h6>
								<b-btn size="sm" class="ml-auto"
								v-if="j.data.NUMFAILURES > 0 || j.data.NUMERRORS > 0"
								variant="light" @click="copyResults(j)"><b-icon icon="file-earmark-code" /> Copy to Clipboard</b-btn>
							</div>
						</b-card-header>
						<b-card-text v-if="j.data.END" class="p-3">
							<b-row>
								<b-col lg="4">
								Path: {{j.data.PATH}}<br>
								Cases: {{j.data.NUMCASES}}<br>
								Tests: {{j.data.NUMTESTS}}
								</b-col>
								<b-col lg="3">
								Passes: <strong class="text-success" v-if="j.data.NUMSUCCESSES > 0">{{j.data.NUMSUCCESSES}}</strong><span v-if="j.data.NUMSUCCESSES === 0">-</span><br>
								Failures: <strong class="text-danger" v-if="j.data.NUMFAILURES > 0">{{j.data.NUMFAILURES}}</strong><span v-if="j.data.NUMFAILURES  === 0">-</span><br>
								Errors: <strong class="text-danger" v-if="j.data.NUMERRORS > 0">{{j.data.NUMERRORS}}</strong><span v-if="j.data.NUMERRORS === 0">-</span>
								</b-col>
								<b-col lg="5">
								Started: {{j.data.BEGIN}}<br>
								Ended: {{j.data.BEGIN}}<br>
								</b-col>
							</b-row>

							<b-alert show class="mt-2" variant="danger" v-for="(t, rindex) in filterResults(j.data.RESULTS)" :key="rindex">
								<b-badge variant="danger">{{t.STATUS}}</b-badge> <strong>{{t.CLEANTESTNAME}} <b-icon icon="arrow-right" /> {{t.PACKAGENAME}}</strong><br>
								<pre v-html="t.DEBUGSTRING"></pre>
								<hr>
								<pre v-html="t.MESSAGE"></pre>
							</b-alert>
						</b-card-text>
						<b-card-text v-else v-html="j.data"  class="p-3"></b-card-text>
					</b-card>
				</div>
			</b-card>
		</b-col>
	</b-row>
	</div>
</div>
</template>

<script>
// @ is an alias to /src
import testsuites  from '@/services/testsuites'
import servers  from '@/services/servers'
import api  from '@/services/api'

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

export default {
	name: 'Home',
	data(){
		return {
			testsuites,
			servers,
			api,
			sleep,
			queue: [],
			status: [],
			jobs: [],
			queueIsRunning: false,
			currentJobName: "",
			executionOrders: [
				"directory asc",
				"directory desc",
			],
			executionOrder: "directory asc"
		}
	},
	computed:{
		currentRunningItem(){
			return this.queue.find((v) => v.status === 'running')
		},
		nextItem(){
			return this.queue.find((v) => v.status === 'pending')
		}
	},
	methods: {
		formatTime(time){
			var rv = ("0" + time.getUTCHours()).slice(-2)
				+ ':' +  ("0" + time.getUTCMinutes()).slice(-2)
			return rv
		},
		getItem(id){
			return this.queue.find((v) => v.id === id) || false
		},
		addToQueue(v){
			v.status = "waiting"
			if(!this.getItem(v.id)){
				this.queue.push(v)
			}
		},
		removeFromQueue(i){
			this.queue.splice(i, 1)
		},
		startQueue(){
			this.queue.map((v) => {
				v.status = "pending"
			})
			this.runItem(this.nextItem)
		},
		stopQueue(){
			this.queueIsRunning = false
			this.queue.map((v) => {
				v.status = "stopped"
			})
		},
		clearAll(){
			this.clearStatus()
			this.clearJobs()
			this.clearQueue()
		},
		clearStatus(){
			this.status = []
		},
		clearJobs(){
			this.jobs = []
		},
		clearQueue(){
			this.queueIsRunning = false
			this.queue = []
		},
		addStatus(status){
			this.status.push({ when: new Date, type: status.type, message: status.message})
		},
		getTestURL(t){
			var rv = t.server + '/wheels/tests/core?reload=true&format=json' + '&sort=' + this.executionOrder
			if(t.database){
				rv += "&db=" + t.database
			}
			return rv
		},
		runTestSuite(item){
			this.queueIsRunning = true
			this.addStatus({ type: 'info', message: "Test Started - " + item.displayname})
			this.currentJobName = item.displayname
			this.api.get(this.getTestURL(item))
				.then((response) => {
					// handle success
					response.displayname = this.currentJobName
					this.jobs.unshift(response)
					var message = response.data.OK ? 'Tests Passed: ' + this.currentJobName : 'Tests Failed: ' + this.currentJobName
					var type = response.data.OK ? 'success': 'danger'
					console.log(response)
					this.addStatus({ type: type, message: message})
					item.status = "done"
				})
				.catch((error) => {
					// handle error
					this.addStatus({ type: 'danger', message: error.message })
					this.addStatus({ type: 'danger', message: error.response.statusText})
					//console.log(error.response)
					error.response.displayname = this.currentJobName
					this.jobs.unshift(error.response)
					item.status = "errored"
				})
				.then(() => {
					// always executed
					this.runItem(this.nextItem)
					this.queueIsRunning = false
				});
		},
		async runItem(item){
			if(typeof item !== 'undefined'){
				item.status = "running"
				this.currentJobName = item.displayname
				await this.runTestSuite(item)
			} else {
				this.queueIsRunning = false
				console.log("queue empty?")
			}
		},

		filterResults (res)  {
			var rv = res.filter((r) => r.STATUS !== 'Success') || []
			console.log(rv)
			return rv
		},
		copyResults(j){
			console.log(j)
			var pt = `
---------------------------------
${j.displayname}
---------------------------------
Path: ${j.data.PATH}
Cases: ${j.data.NUMCASES}
Tests: ${j.data.NUMTESTS}
Passes: ${j.data.NUMSUCCESSES}
Failures: ${j.data.NUMFAILURES}
Errors:  ${j.data.NUMERRORS}
Started: ${j.data.BEGIN}
Ended: ${j.data.BEGIN}
`;
this.filterResults(j.data.RESULTS).map((t)=>{
pt +=
`
- ${t.STATUS}: ${t.CLEANTESTNAME} -> ${t.PACKAGENAME}
${t.MESSAGE.replace(/(<([li|ul|>]+)>)/ig,"").replace(/(<([li|ul|/>]+)>)/ig,"\n")}

`
});
			this.$clipboard(pt)
		},
		async fakeMethod(i){
			console.log("fake", i)
			this.sleep(3000).then(() => {
				i.status = "done"
				this.runItem(this.nextItem)
			})
		}
	}
}
</script>

<style lang="scss">
.status {
	border: 1px solid #999;
}
</style>
