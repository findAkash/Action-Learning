<template>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title>Department Detail</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="updateDepartment">
                <v-text-field v-model="department.name" label="Name" required></v-text-field>
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
    name: 'DepartmentDetail',
    setup() {
      const store = useStore();
      const route = useRoute();
      const department = ref({ name: '' });
  
      onMounted(async () => {
        const departmentId = route.params.id;
        await store.dispatch('fetchDepartmentById', departmentId);
        department.value = store.getters.currentDepartment;
      });
  
      const updateDepartment = async () => {
        await store.dispatch('updateDepartment', department.value);
      };
  
      return { department, updateDepartment };
    },
  });
  </script>
  