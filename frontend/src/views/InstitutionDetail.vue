<template>
    <v-container>
      <v-row>
        <v-col>
          <h1 class="text-2xl font-bold text-center mb-6">Edit Institution</h1>
        </v-col>
      </v-row>
      <v-form @submit.prevent="updateInstitution">
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
            <v-btn type="submit" color="primary">Update</v-btn>
          </v-col>
        </v-row>
      </v-form>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref, onMounted } from 'vue';
  import { useRoute, useRouter } from 'vue-router';
  import api from '@/utils/api';
  
  export default defineComponent({
    name: 'InstitutionDetail',
    setup() {
      const institution = ref({
        name: '',
        address: '',
        phone: '',
        email: '',
        website: '',
      });
      const route = useRoute();
      const router = useRouter();
      const institutionId = route.params.id;
  
      onMounted(async () => {
        try {
          const response = await api.get(`/superadmin/institution/${institutionId}`);
          institution.value = response.data;
        } catch (error) {
          console.error('Failed to fetch institution details', error);
        }
      });
  
      const updateInstitution = async () => {
        try {
          await api.put(`/superadmin/institution/${institutionId}`, institution.value);
          alert('Institution updated successfully');
          router.push('/superadmin-dashboard');
        } catch (error) {
          console.error('Failed to update institution', error);
        }
      };
  
      return { institution, updateInstitution };
    },
  });
  </script>
  
  <style scoped>
  /* Add your styles here */
  </style>
  