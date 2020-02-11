<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    <p>
      NODE_ENV is {{ env.NODE_ENV }}<br>
      VUE_APP_BACKEND is {{ env.BACKEND }}<br>
      VUE_APP_ENV_TEST is {{ env.ENV_TEST }}
    </p>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'app',
  data: () => ({
    env: {
      NODE_ENV: process.env.NODE_ENV,
      BACKEND: process.env.VUE_APP_BACKEND,
      ENV_TEST: process.env.VUE_APP_ENV_TEST
    }
  }),
  components: {
    HelloWorld
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
