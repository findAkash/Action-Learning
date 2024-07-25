<template>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title>Batch Detail</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="updateBatch">
                <v-text-field v-model="batch.batchName" label="Name" required></v-text-field>
                <v-text-field v-model="batch.startDate" label="Start Date" required></v-text-field>
                <v-text-field v-model="batch.endDate" label="End Date" required></v-text-field>
                <v-btn type="submit" color="primary">Save</v-btn>
              </v-form>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref, onMounted } from 'vue';
  import { useStore } from 'vuex';
  import { useRoute } from 'vue-router';
  
  export default defineComponent({
    name: 'BatchDetail',
    setup() {
      const store = useStore();
      const route = useRoute();
      const batch = ref({ batchName: '', startDate: '', endDate: '' });
  
      onMounted(async () => {
        const batchId = route.params.id;
        await store.dispatch('fetchBatchById', batchId);
        batch.value = store.getters.currentBatch;
      });
  
      const updateBatch = async () => {
        await store.dispatch('updateBatch', batch.value);
      };
  
      return { batch, updateBatch };
    },
  });
  </script>
  