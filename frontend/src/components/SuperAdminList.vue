<template>
    <v-data-table :headers="headers" :items="superAdmins" class="elevation-1"></v-data-table>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted } from 'vue';
  import { useSuperAdminStore } from '@/stores/superAdmin';
  
  export default defineComponent({
    name: 'SuperAdminList',
    setup() {
      const superAdminStore = useSuperAdminStore();
  
      onMounted(() => {
        superAdminStore.fetchSuperAdmins();
      });
  
      const headers = [
        { text: 'Email', value: 'email' },
        { text: 'Role', value: 'role' },
      ];
  
      return {
        superAdmins: superAdminStore.superAdmins,
        headers,
      };
    },
  });
  </script>
  