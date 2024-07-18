<template>
    <div>
      <h2>Super Admin List</h2>
      <ul>
        <li v-for="admin in superAdmins" :key="admin._id">{{ admin.email }}</li>
      </ul>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted } from 'vue';
  import { useSuperAdminStore } from '@/stores/superadmin';
  
  export default defineComponent({
    setup() {
      const superAdminStore = useSuperAdminStore();
      onMounted(() => {
        superAdminStore.fetchSuperAdmins();
      });
  
      return {
        superAdmins: superAdminStore.superAdmins,
      };
    },
  });
  </script>
  