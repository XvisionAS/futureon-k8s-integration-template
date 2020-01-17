<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    <p>
      NODE_ENV is {{ $appEnv.NODE_ENV }}<br>
      VUE_APP_BACKEND is {{ $appEnv.VUE_APP_BACKEND }}<br>
      VUE_APP_ENV_TEST is {{ $appEnv.VUE_APP_ENV_TEST }}
    </p>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'app',
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
