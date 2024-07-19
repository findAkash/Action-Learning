<template>
  <v-app>
    <router-view></router-view>
  </v-app>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'App',
});
</script>

<style>
html, body, #app, .v-application {
  height: 100%;
  margin: 0;
  background: linear-gradient(to right, #00c6ff, #ff7e5f);
  font-family: 'Roboto', sans-serif;
}
</style>
