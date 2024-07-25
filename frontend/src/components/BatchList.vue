<template>
    <v-container>
      <v-row>
        <v-col v-for="batch in batches" :key="batch._id" cols="12" sm="6" md="4">
          <v-card>
            <v-card-title>{{ batch.batchName }}</v-card-title>
            <v-card-actions>
              <v-btn :to="`/batch/${batch._id}`" color="primary">View Details</v-btn>
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
    name: 'BatchList',
    setup() {
      const store = useStore();
  
      onMounted(() => {
        store.dispatch('fetchBatches');
      });
  
      const batches = computed(() => store.getters.batches);
  
      return { batches };
    },
  });
  </script>
  