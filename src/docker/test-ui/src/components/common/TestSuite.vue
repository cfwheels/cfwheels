<template>
<b-list-group-item :disabled="suiteRunning" class="d-flex flex-row justify-content-between">
	<b-spinner class="ml-3" small v-if="suiteRunning" variant="info" /> {{servername}}

	<b-btn size="sm" @click="runTestSuite" :disabled="suiteRunning" variant="primary">Run Tests</b-btn>

	<span v-if="results">
		<b-badge variant="success" v-if="results.OK">Success</b-badge>
		<b-badge variant="danger" v-if="!results.OK">Failed</b-badge>
	</span>

	<div v-if="results" class="mt-3">
	<b-card title="Results"
		:border-variant="display.variant"
		:header="display.text"
		:header-border-variant="display.variant"
		:header-text-variant="display.variant"
	>
		<b-card-text>
			<p>
				NUMTESTS: {{results.NUMTESTS}}<br>
				NUMERRORS: {{results.NUMERRORS}}<br>
				NUMCASES: {{results.NUMCASES}}<br>
				PATH: {{results.PATH}}<br>
				NUMFAILURES: {{results.NUMFAILURES}}<br>
				OBJECTTESTSPASSED: {{results.OBJECTTESTSPASSED}}<br>
				OK: {{results.OK}}<br>
				BEGIN: {{results.BEGIN}}<br>
				END: {{results.END}}<br>
				NUMSUCCESSES: {{results.NUMSUCCESSES}}
			</p>
		</b-card-text>
		<b-btn @click="runTestSuite" :disabled="suiteRunning" variant="primary">Re-Run Tests</b-btn>
		<b-spinner class="ml-3" v-if="suiteRunning" variant="info" />
	</b-card>
	</div>

	<!--b-row>
		<b-col lg="4">
			<strong>{{servername}}</strong><br>{{server}}
		</b-col>
		<b-col lg="8">
			<div v-if="results">
			<b-card title="Results"
				:border-variant="display.variant"
				:header="display.text"
				:header-border-variant="display.variant"
				:header-text-variant="display.variant"
			>
				<b-card-text>
					<p>
						NUMTESTS: {{results.NUMTESTS}}<br>
						NUMERRORS: {{results.NUMERRORS}}<br>
						NUMCASES: {{results.NUMCASES}}<br>
						PATH: {{results.PATH}}<br>
						NUMFAILURES: {{results.NUMFAILURES}}<br>
						OBJECTTESTSPASSED: {{results.OBJECTTESTSPASSED}}<br>
						OK: {{results.OK}}<br>
						BEGIN: {{results.BEGIN}}<br>
						END: {{results.END}}<br>
						NUMSUCCESSES: {{results.NUMSUCCESSES}}
					</p>
				</b-card-text>
				<b-btn @click="runTestSuite" :disabled="suiteRunning" variant="primary">Re-Run Tests</b-btn>
				<b-spinner class="ml-3" v-if="suiteRunning" variant="info" />
			</b-card>
			</div>
			<div v-else>
			<b-card>
				<b-btn @click="runTestSuite" :disabled="suiteRunning" variant="primary">Run Tests</b-btn>
				<b-spinner class="ml-3" v-if="suiteRunning" variant="info" />
			</b-card>
			</div>
		</b-col>
	</b-row-->
</b-list-group-item>
</template>
<script>
import axios from 'axios'

export default {
	name: 'TestSuite',
	data(){
		return {
			suiteRunning: false,
			results: null,
			display: {
				variant: null
			}
		}
	},
	props: {
		servername: {
			default: null,
			type: String
		},
		server: {
			default: null,
			type: String
		},
		database: {
			default: null,
			type: String
		}
	},
	methods: {
		setRunning(){
			this.suiteRunning = true
			this.$emit('runnerStart')
			this.results = null
		},
		finishRunning(){
			this.$emit('runner', false)
			this.$emit('runnerEnd')
			this.suiteRunning = false
		},
		runTestSuite(){
			this.setRunning()
			axios.get(this.testURL)
				.then((response) => {
					// handle success
					this.results = response.data
					this.display.text = response.data.OK ? 'Passed': 'Failed'
					this.display.variant = response.data.OK ? 'success': 'danger'
					console.log(response)
				})
				.catch((error) => {
					// handle error
					console.log(error)
				})
				.then(() => {
					// always executed
					this.finishRunning()
				});
		}
	},
	computed : {
		testURL(){
			var rv =  this.server + '/wheels/tests/core?reload=true&format=json&db=wheelstestdb'
			if(this.database){
				rv += "_" + this.database
			}
			return rv
		}
	}
}
</script>
