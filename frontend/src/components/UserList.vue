<template>
    <v-container>
      <v-card class="pa-5">
        <v-card-title class="text-h5">
          User List
        </v-card-title>
        <v-card-text>
          <v-list>
            <v-list-item v-for="user in users" :key="user._id">
              <v-list-item-content>{{ user.email }}</v-list-item-content>
            </v-list-item>
          </v-list>
        </v-card-text>
      </v-card>
    </v-container>
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
  
      return {
        users: userStore.users,
      };
    },
  });
  </script>
  