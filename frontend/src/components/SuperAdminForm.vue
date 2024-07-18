<template>
    <div>
      <h2>Create Super Admin</h2>
      <form @submit.prevent="createSuperAdmin">
        <input v-model="email" placeholder="Email" />
        <input v-model="password" placeholder="Password" type="password" />
        <button type="submit">Create</button>
      </form>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref } from 'vue';
  import { useSuperAdminStore } from '@/stores/superadmin';
  
  export default defineComponent({
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
  