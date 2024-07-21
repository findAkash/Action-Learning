<template>
    <div class="container mx-auto">
      <h1 class="text-2xl font-bold text-center mb-6 text-primary">SuperAdmin Dashboard</h1>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <div
          v-for="institution in institutions"
          :key="institution._id"
          class="card bordered shadow-lg p-4 cursor-pointer"
          @click="viewInstitution(institution._id)"
        >
          <h2 class="text-xl font-bold">{{ institution.name }}</h2>
          <p>{{ institution.address }}</p>
          <p>{{ institution.phone }}</p>
          <p>{{ institution.email }}</p>
          <p>{{ institution.website }}</p>
        </div>
      </div>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted } from 'vue';
  import { useStore } from 'vuex';
  import { useRouter } from 'vue-router';
  
  export default defineComponent({
    name: 'SuperAdminDashboard',
    setup() {
      const store = useStore();
      const router = useRouter();
  
      onMounted(async () => {
        await store.dispatch('fetchInstitutions');
      });
  
      const viewInstitution = (id: string) => {
        router.push(`/institution/${id}`);
      };
  
      return {
        institutions: store.state.institutions,
        viewInstitution,
      };
    },
  });
  </script>
  
  <style scoped>
  /* Add your styles here */
  </style>
  