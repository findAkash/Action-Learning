<template>
    <v-container class="bg-background">
      <v-row>
        <v-col>
          <h1 class="text-4xl header-font text-center mb-6">Create Department</h1>
        </v-col>
      </v-row>
      <v-form @submit.prevent="createDepartment">
        <v-row>
          <v-col cols="12" sm="6">
            <v-text-field v-model="department.name" label="Name" required></v-text-field>
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field v-model="department.address" label="Address" required></v-text-field>
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field v-model="department.phone" label="Phone" required></v-text-field>
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field v-model="department.email" label="Email" required></v-text-field>
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field v-model="department.website" label="Website"></v-text-field>
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
    name: 'CreateDepartment',
    setup() {
      const router = useRouter();
      const department = ref({
        name: '',
        address: '',
        phone: '',
        email: '',
        website: '',
      });
  
      const createDepartment = async () => {
        try {
          await api.post('/institution/admin/department/create', department.value);
          alert('Department created successfully');
          router.push('/admin-dashboard');
        } catch (error) {
          console.error('Failed to create department', error);
        }
      };
  
      return { department, createDepartment };
    },
  });
  </script>
  
  <style scoped>
  /* Add your styles here */
  </style>