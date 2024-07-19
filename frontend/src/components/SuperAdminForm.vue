<template>
    <v-form>
      <v-text-field v-model="email" label="Email" prepend-icon="mdi-account" type="email"></v-text-field>
      <v-text-field v-model="password" label="Password" prepend-icon="mdi-lock" type="password"></v-text-field>
      <v-btn color="primary" @click="createSuperAdmin">Create Super Admin</v-btn>
    </v-form>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref } from 'vue';
  import { useSuperAdminStore } from '@/stores/superAdmin';
  
  export default defineComponent({
    name: 'SuperAdminForm',
    setup() {
      const superAdminStore = useSuperAdminStore();
      const email = ref('');
      const password = ref('');
  
      const createSuperAdmin = async () => {
        await superAdminStore.createSuperAdmin({ email: email.value, password: password.value });
        email.value = '';
        password.value = '';
      };
  
      return {
        email,
        password,
        createSuperAdmin,
      };
    },
  });
  </script>
  