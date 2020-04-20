<template>
<div class="home">
	<div class="container-fluid mt-5">
	<b-row>
		<b-col lg="4">
			<b-form-group label="Select Tests to Queue">
			<b-form-checkbox-group
				id="checkbox-group-1"
				v-model="selected"
				stacked
				:options="testsuiteoptions"
				name="testsuites"
			></b-form-checkbox-group>
			</b-form-group>
			<b-btn :disabled="!selected.length" variant="primary">Add to Queue</b-btn>
		</b-col>
		<b-col lg="8">
			<div class="box">

			</div>
		</b-col>
	</b-row>
	</div>
</div>
</template>

<script>
// @ is an alias to /src
import  testsuites  from '@/services/servers'

export default {
	name: 'Home',
	data(){
		return {
			testsuites,
			selected: []
		}
	},
	computed: {
		testsuiteoptions (){
			return testsuites.map((t) => {
				return {
					text: t.displayname, value: t.id
				}
			})
		},
		selectedtestsuites (){
			return this.selected.map((s) => {
				return this.testsuites.find((ts) => ts.id === s) || { id: null}
			})
		}
	}
}
</script>
