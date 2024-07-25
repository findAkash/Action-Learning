<template>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title>Module Detail</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="updateModule">
                <v-text-field v-model="module.title" label="Title" required></v-text-field>
                <v-text-field v-model="module.description" label="Description" required></v-text-field>
                <v-text-field v-model="module.credit" label="Credit" required></v-text-field>
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
    name: 'ModuleDetail',
    setup() {
      const store = useStore();
      const route = useRoute();
      const module = ref({ title: '', description: '', credit: 0 });
  
      onMounted(async () => {
        const moduleId = route.params.id;
        await store.dispatch('fetchModuleById', moduleId);
        module.value = store.getters.currentModule;
      });
  
      const updateModule = async () => {
        await store.dispatch('updateModule', module.value);
      };
  
      return { module, updateModule };
    },
  });
  </script>
  