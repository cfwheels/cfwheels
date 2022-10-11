import Vue from 'vue'
import App from './App.vue'
import router from './router'

import Clipboard from 'v-clipboard'
import { BootstrapVue, BootstrapVueIcons } from 'bootstrap-vue'
Vue.config.productionTip = false

Vue.use(Clipboard)
// Install BootstrapVue
Vue.use(BootstrapVue)
// Optionally install the BootstrapVue icon components plugin
Vue.use(BootstrapVueIcons)
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
// https://webpack.js.org/guides/dependency-management/#require-context
//const requireComponent = require.context(
//  // Look for files in components
//  './components/common',
//  // Do not look in subdirectories
//  false,
//  // Only include  .vue files
//  /[\w-]+\.vue$/
//)
//
//// For each matching file name...
//requireComponent.keys().forEach(fileName => {
//  // Get the component config
//  const componentConfig = requireComponent(fileName)
//  const componentName =
//      fileName
//        // Remove the "./_" from the beginning
//        .replace(/^\.\//, '')
//        // Remove the file extension from the end
//        .replace(/\.\w+$/, '')
//  // Globally register the component
//  Vue.component(componentName, componentConfig.default || componentConfig)
//})

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
