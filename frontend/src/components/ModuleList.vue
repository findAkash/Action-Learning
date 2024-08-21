<template>
    <v-container>
      <v-row>
        <v-col v-for="module in modules" :key="module._id" cols="12" sm="6" md="4">
          <v-card>
            <v-card-title>{{ module.title }}</v-card-title>
            <v-card-actions>
              <v-btn :to="`/module/${module._id}`" color="primary">View Details</v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, computed, onMounted } from 'vue';
  import { useStore } from 'vuex';
  
  export default defineComponent({
    name: 'ModuleList',
    setup() {
      const store = useStore();
  
      onMounted(() => {
        store.dispatch('fetchModules');
      });
  
      const modules = computed(() => store.getters.modules);
  
      return { modules };
    },
  });
  </script>
  