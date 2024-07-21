<template>
    <div class="flex justify-center items-center min-h-screen bg-base-100">
      <div class="w-full max-w-xs">
        <form @submit.prevent="login" class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
          <h1 class="text-2xl font-bold text-center mb-6 text-primary">SuperAdmin Login</h1>
          <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
              Email
            </label>
            <input v-model="email" type="email" id="email" placeholder="Email" class="input input-bordered w-full max-w-xs" />
          </div>
          <div class="mb-6">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="password">
              Password
            </label>
            <input v-model="password" type="password" id="password" placeholder="Password" class="input input-bordered w-full max-w-xs" />
          </div>
          <div class="flex items-center justify-between">
            <button type="submit" class="btn btn-primary w-full">
              Login
            </button>
          </div>
        </form>
      </div>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref } from 'vue';
  import { useStore } from 'vuex';
  import { useRouter } from 'vue-router';
  import api from '@/utils/api';
  
  export default defineComponent({
    name: 'SuperAdminLogin',
    setup() {
      const email = ref('');
      const password = ref('');
      const store = useStore();
      const router = useRouter();
  
      const login = async () => {
        try {
          console.log('Attempting login with', { email: email.value, password: password.value });
          const response = await api.post('/superadmin/auth/login', {
            email: email.value,
            password: password.value,
          });
          console.log('Response from server', response.data);
          store.commit('setUser', response.data.user);
          store.commit('setToken', response.data.user.tokens.token);
          console.log(`User ${JSON.stringify(response.data.user)} logged in`);
          console.log(`Token ${response.data.user.tokens.token} logged in`);
          router.push('/superadmin-dashboard');
        } catch (error) {
          console.error('Login failed', error);
          alert('Login failed. Please check your credentials and try again.');
        }
      };
  
      return { email, password, login };
    },
  });
  </script>
  
  <style scoped>
  /* Add your styles here */
  </style>
  