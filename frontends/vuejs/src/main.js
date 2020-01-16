import Vue from 'vue'
import App from './App.vue'
import getConfig from './config.js'

Vue.config.productionTip = false

Vue.prototype.$appConfig = getConfig('#app-config');

new Vue({
  el: '#app',
  render: h => h(App)
})
