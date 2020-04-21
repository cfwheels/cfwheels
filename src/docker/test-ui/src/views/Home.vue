<template>
<div class="home">
	<div class="container-fluid mt-5">

	<b-row>
		<b-col lg="4">
			<b-card flush header="Run Tests:" :no-body='true'>
				<b-list-group>
					<b-list-group-item v-for="t in testsuites" :key="t.id" button @click="addToQueue(t)">
						{{t.displayname}}
					</b-list-group-item>
				</b-list-group>
				</b-card>
				<b-card class="mt-3" flush header="Open Server" :no-body='true'>
				<b-list-group>
					<b-list-group-item v-for="s in servers" :href="s.server" target="_blank" :key="s.servername">
						{{s.servername}} &gt;
					</b-list-group-item>
				</b-list-group>
			</b-card>
		</b-col>
		<b-col lg="8">
			<b-card>
				<h3>Queue
					<b-btn variant="link" v-if="queue.length" @click="startQueue">Start</b-btn>
					<b-btn variant="link" v-if="queue.length" @click="stopQueue">Stop</b-btn>
					<b-btn variant="link" v-if="queue.length" @click="clearQueue">Clear</b-btn>
				</h3>
				<p class="text-center" v-if="!queue.length">No Tests added yet</p>
				<b-row v-for="(v, i) in queue" :key="i">
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
			<b-card  class="mt-3">
				<h3>Console <b-btn size="sm" v-if="status.length" variant="link" @click="clearStatus">Clear</b-btn></h3>
				<p class="text-center" v-if="!status.length">Nothing here yet</p>
				<div v-if="status.length">
					<b-row v-for="(s, index) in status" :key="index">
						<b-col md="1"><b-badge :variant="s.type">{{formatTime(s.when)}}</b-badge></b-col>
						<b-col md="11">{{s.message}}</b-col>
					</b-row>
				</div>
			</b-card>
			<b-card class="mt-3">
				<h3>Results <b-btn size="sm" v-if="jobs.length" variant="link" @click="clearJobs">Clear</b-btn></h3>
				<div class="text-center">
					<p v-if="!jobs.length">No results returned yet</p>
				</div>
				<div v-if="jobs.length">
					<b-card
						:header="'Result Set'"
						class="mb-3"
						v-for="(j, index) in jobs" :key="index"
					>
						<b-card-text v-if="j.END">
							<b-row>
								<b-col lg="4">
								Path: {{j.PATH}}<br>
								Cases: {{j.NUMCASES}}<br>
								Tests: {{j.NUMTESTS}}
								</b-col>
								<b-col lg="4">
								Passes: {{j.NUMSUCCESSES}}<br>
								Failures: {{j.NUMFAILURES}}<br>
								Errors: {{j.NUMERRORS}}
								</b-col>
								<b-col lg="4">
								Started: {{j.BEGIN}}<br>
								Ended: {{j.BEGIN}}<br>
								</b-col>
							</b-row>

							<b-alert show class="mt-2" variant="danger" v-for="(t, rindex) in filterResults(j.RESULTS)" :key="rindex">
								{{t.CLEANTESTNAME}}<br>{{t.PACKAGENAME}}<br>{{t.STATUS}}
								<div v-html="t.MESSAGE"></div>
							</b-alert>
						</b-card-text>
						<b-card-text v-else v-html="j"></b-card-text>
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
			jobs: []
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
			var rv = time.getUTCHours()
				+ ':' +  time.getUTCMinutes()
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
			this.queue.map((v) => {
				v.status = "stopped"
			})
		},
		clearStatus(){
			this.status = [];
		},
		clearJobs(){
			this.jobs = [];
		},
		clearQueue(){
			this.queue = []
		},
		addStatus(status){
			this.status.push({ when: new Date, type: status.type, message: status.message})
		},
		getTestURL(t){
			var rv = t.server + '/wheels/tests/core?reload=true&format=json'
			if(t.database){
				rv += "&db=" + t.database
			}
			return rv
		},
		runTestSuite(item){
			this.addStatus({ type: 'info', message: "Test Started - " + item.displayname})
			this.api.get(this.getTestURL(item))
				.then((response) => {
					// handle success
					this.jobs.unshift(response.data)
					var message = response.data.OK ? 'Tests Passed': 'Tests Failed'
					var type = response.data.OK ? 'success': 'danger'
					console.log(response)
					this.addStatus({ type: type, message: message})
					item.status = "done"
				})
				.catch((error) => {
					// handle error
					this.addStatus({ type: 'danger', message: error.message })
					this.addStatus({ type: 'danger', message: "Test Request Failed"})
					//console.log(error.response)
					this.jobs.unshift(error.response.data)
					item.status = "errored"
				})
				.then(() => {
					// always executed
					this.runItem(this.nextItem)
				});
		},
		async runItem(item){
			if(typeof item !== 'undefined'){
				item.status = "running"
				await this.runTestSuite(item)
			} else {
				console.log("queue empty?")
			}
		},

		filterResults (res)  {
			var rv = res.filter((r) => r.STATUS !== 'Success') || []
			console.log(rv)
			return rv
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
