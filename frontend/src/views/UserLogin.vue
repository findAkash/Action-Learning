<template>
    <v-container class="fill-height" fluid>
      <v-row align="center" justify="center">
        <v-col cols="12" sm="8" md="4">
          <v-card>
            <v-card-title class="text-h5 text-center header-font">User Login</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="login">
                <v-text-field
                  v-model="email"
                  label="Email"
                  type="email"
                  required
                  outlined
                ></v-text-field>
                <v-text-field
                  v-model="password"
                  label="Password"
                  type="password"
                  required
                  outlined
                ></v-text-field>
                <v-btn type="submit" color="primary" block>Login</v-btn>
              </v-form>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref } from 'vue';
  import { useStore } from 'vuex';
  import { useRouter } from 'vue-router';
  import api from '@/utils/api';
  
  export default defineComponent({
    name: 'UserLogin',
    setup() {
      const email = ref('');
      const password = ref('');
      const store = useStore();
      const router = useRouter();
  
      const login = async () => {
        try {
          const response = await api.post('/institution/admin/login', {
            email: email.value,
            password: password.value,
          });
          store.commit('setUser', response.data.user);
          store.commit('setToken', response.data.user.tokens.token);
          const role = response.data.user.role;
          if (role === 'admin') {
            router.push('/admin-dashboard');
          } else if (role === 'teacher') {
            router.push('/teacher-dashboard');
          }
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
  .fill-height {
    height: 100vh;
  }
  </style>
  