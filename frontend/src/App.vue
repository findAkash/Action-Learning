<template>
  <div id="app">
    <v-app>
      <router-view></router-view>
    </v-app>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'App',
});
</script>

<style>
html,
body,
#app {
  height: 100%;
  margin: 0;
  background: linear-gradient(135deg, #ff7e5f, #feb47b);
  font-family: 'Roboto', sans-serif;
}
</style>
