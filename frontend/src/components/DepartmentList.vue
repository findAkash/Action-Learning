<template>
    <v-container>
      <v-row>
        <v-col v-for="department in departments" :key="department._id" cols="12" sm="6" md="4">
          <v-card>
            <v-card-title>{{ department.name }}</v-card-title>
            <v-card-actions>
              <v-btn :to="`/department/${department._id}`" color="primary">View Details</v-btn>
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
    name: 'DepartmentList',
    setup() {
      const store = useStore();
  
      onMounted(() => {
        store.dispatch('fetchDepartments');
      });
  
      const departments = computed(() => store.getters.departments);
  
      return { departments };
    },
  });
  </script>
  