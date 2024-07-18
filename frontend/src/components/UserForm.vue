<template>
    <v-container>
      <v-card class="pa-5">
        <v-card-title>
          <span class="headline">Create User</span>
        </v-card-title>
        <v-card-text>
          <v-form @submit.prevent="createUser">
            <v-text-field v-model="email" label="Email" required></v-text-field>
            <v-text-field v-model="password" label="Password" type="password" required></v-text-field>
            <v-btn type="submit" color="primary" class="mt-4" block>Create</v-btn>
          </v-form>
        </v-card-text>
      </v-card>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref } from 'vue';
  import { useUserStore } from '@/stores/user';
  
  export default defineComponent({
    name: 'UserForm',
    setup() {
      const userStore = useUserStore();
      const email = ref('');
      const password = ref('');
  
      const createUser = async () => {
        await userStore.createUser({ email: email.value, password: password.value });
        email.value = '';
        password.value = '';
      };
  
      return {
        email,
        password,
        createUser,
      };
    },
  });
  </script>
  