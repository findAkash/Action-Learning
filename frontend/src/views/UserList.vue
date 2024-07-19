<template>
    <v-app>
      <v-main>
        <v-container>
          <v-data-table :headers="headers" :items="users" class="elevation-1"></v-data-table>
        </v-container>
      </v-main>
    </v-app>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted } from 'vue';
  import { useUserStore } from '@/stores/user';
  
  export default defineComponent({
    name: 'UserList',
    setup() {
      const userStore = useUserStore();
  
      onMounted(() => {
        userStore.fetchUsers();
      });
  
      const headers = [
        { text: 'First Name', value: 'firstName' },
        { text: 'Last Name', value: 'lastName' },
        { text: 'Email', value: 'email' },
        { text: 'Role', value: 'role' },
      ];
  
      return {
        users: userStore.users,
        headers,
      };
    },
  });
  </script>
  