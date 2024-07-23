<template>
    <v-container>
      <v-row align="center" justify="center">
        <v-col cols="12" sm="8" md="6" lg="4">
          <v-card class="pa-4">
            <v-card-title class="text-h5 text-center">Profile</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="updateProfile">
                <v-text-field
                  v-model="user.firstName"
                  label="First Name"
                  type="text"
                  required
                  outlined
                ></v-text-field>
                <v-text-field
                  v-model="user.lastName"
                  label="Last Name"
                  type="text"
                  required
                  outlined
                ></v-text-field>
                <v-text-field
                  v-model="user.email"
                  label="Email"
                  type="email"
                  required
                  outlined
                  disabled
                ></v-text-field>
                <v-btn type="submit" color="primary" block class="mt-4">Update</v-btn>
              </v-form>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref, onMounted } from 'vue';
  import { useStore } from 'vuex';
  import api from '@/utils/api';
  
  export default defineComponent({
    name: 'Profile',
    setup() {
      const store = useStore();
      const user = ref({
        firstName: '',
        lastName: '',
        email: '',
      });
  
      onMounted(() => {
        const userData = store.state.user;
        if (userData) {
          user.value = { ...userData };
        }
      });
  
      const updateProfile = async () => {
        try {
          const response = await api.put(`/user/profile`, user.value, {
            headers: {
              Authorization: `Bearer ${store.state.token}`,
            },
          });
          alert('Profile updated successfully');
          store.commit('setUser', response.data.user);
        } catch (error) {
          console.error('Failed to update profile', error);
          alert('Failed to update profile. Please try again.');
        }
      };
  
      return { user, updateProfile };
    },
  });
  </script>
  