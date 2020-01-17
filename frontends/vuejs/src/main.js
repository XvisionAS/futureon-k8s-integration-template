import Vue from 'vue'
import App from './App.vue'
import getConfig from './config.js'

Vue.config.productionTip = false

// Set application env vars that come from process.env in development
// and from index.html (injected by apply-env-vars.sh) in production.
// process.env itself cannot be updated, it is a webpack/DefinePlugin constant.
Vue.prototype.$appEnv = process.env;

if (process.env.NODE_ENV === 'production') {
  const runtimeEnv = getConfig('#app-env')
  for (const k in runtimeEnv) {
    Vue.prototype.$appEnv[k] = runtimeEnv[k]
  }
}

new Vue({
  el: '#app',
  render: h => h(App)
})
