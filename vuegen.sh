#!/bin/bash

if [ -z $1 ]; then
	echo project name not provided
	echo usage: vuegen [project]
else
	vue create $(echo $1)
	cd $1
	npm install bootstrap
	npm install jquery
	npm install popper.js
	npm install sass-loader
	npm install node-sass
	cd src
	mkdir styles
	cd styles
	echo "@import \"../../node_modules/bootstrap/scss/bootstrap\";" >> bootstrap.scss
	echo "@import \"bootstrap\";" >> exports.scss
	cd ../
	echo "import Vue from 'vue'
import App from './App.vue'
import './styles/exports.scss'

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).\$mount('#app')" > main.js
	mkdir js
	echo "<template>
  <div id="app">
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>" > App.vue
	cd components
	rm HelloWorld.vue
	# add router
fi