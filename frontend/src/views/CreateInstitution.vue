<template>
    <v-container class="bg-background">
      <v-row>
        <v-col>
          <h1 class="text-4xl header-font text-center mb-6">Create Institution</h1>
        </v-col>
      </v-row>
      <v-form @submit.prevent="createInstitution">
        <v-row>
          <v-col cols="12" sm="6">
            <v-text-field v-model="institution.name" label="Name" required></v-text-field>
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field v-model="institution.address" label="Address" required></v-text-field>
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field v-model="institution.phone" label="Phone" required></v-text-field>
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field v-model="institution.email" label="Email" required></v-text-field>
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field v-model="institution.website" label="Website"></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col>
            <v-btn type="submit" color="primary">Create</v-btn>
          </v-col>
        </v-row>
      </v-form>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref } from 'vue';
  import { useRouter } from 'vue-router';
  import api from '@/utils/api';
  
  export default defineComponent({
    name: 'CreateInstitution',
    setup() {
      const router = useRouter();
      const institution = ref({
        name: '',
        address: '',
        phone: '',
        email: '',
        website: '',
      });
  
      const createInstitution = async () => {
        try {
          await api.post('/superadmin/institution/create', institution.value);
          alert('Institution created successfully');
          router.push('/superadmin-dashboard');
        } catch (error) {
          console.error('Failed to create institution', error);
        }
      };
  
      return { institution, createInstitution };
    },
  });
  </script>
  
  <style scoped>
  /* Add your styles here */
  </style>
  