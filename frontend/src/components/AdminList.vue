<template>
    <div>
      <h2>Admin List</h2>
      <ul>
        <li v-for="admin in admins" :key="admin._id">{{ admin.email }}</li>
      </ul>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted } from 'vue';
  import { useAdminStore } from '@/stores/admin';
  
  export default defineComponent({
    setup() {
      const adminStore = useAdminStore();
      onMounted(() => {
        adminStore.fetchAdmins();
      });
  
      return {
        admins: adminStore.admins,
      };
    },
  });
  </script>
  