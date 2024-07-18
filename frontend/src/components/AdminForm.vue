<template>
    <div>
      <h2>Create Admin</h2>
      <form @submit.prevent="createAdmin">
        <input v-model="email" placeholder="Email" />
        <input v-model="password" placeholder="Password" type="password" />
        <button type="submit">Create</button>
      </form>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref } from 'vue';
  import { useAdminStore } from '@/stores/admin';
  
  export default defineComponent({
    setup() {
      const adminStore = useAdminStore();
      const email = ref('');
      const password = ref('');
  
      const createAdmin = async () => {
        await adminStore.createAdmin({ email: email.value, password: password.value });
        email.value = '';
        password.value = '';
      };
  
      return {
        email,
        password,
        createAdmin,
      };
    },
  });
  </script>
  