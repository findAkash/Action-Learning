<template>
    <div class="container mx-auto">
      <h1 class="text-2xl font-bold text-center mb-6 text-primary">Edit Institution</h1>
      <form @submit.prevent="updateInstitution">
        <div class="mb-4">
          <label class="block text-gray-700 text-sm font-bold mb-2" for="name">
            Name
          </label>
          <input v-model="institution.name" type="text" id="name" class="input input-bordered w-full max-w-xs" />
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 text-sm font-bold mb-2" for="address">
            Address
          </label>
          <input v-model="institution.address" type="text" id="address" class="input input-bordered w-full max-w-xs" />
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 text-sm font-bold mb-2" for="phone">
            Phone
          </label>
          <input v-model="institution.phone" type="text" id="phone" class="input input-bordered w-full max-w-xs" />
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
            Email
          </label>
          <input v-model="institution.email" type="email" id="email" class="input input-bordered w-full max-w-xs" />
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 text-sm font-bold mb-2" for="website">
            Website
          </label>
          <input v-model="institution.website" type="text" id="website" class="input input-bordered w-full max-w-xs" />
        </div>
        <div class="flex items-center justify-between">
          <button type="submit" class="btn btn-primary w-full">
            Update
          </button>
        </div>
      </form>
    </div>
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
  