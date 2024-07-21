<template>
    <v-container>
      <v-row>
        <v-col>
          <h1 class="text-2xl font-bold text-center mb-6">SuperAdmin Dashboard</h1>
        </v-col>
      </v-row>
      <v-row>
        <v-col v-for="institution in institutions" :key="institution._id" cols="12" sm="6" md="4">
          <v-card @click="viewInstitution(institution._id)" class="cursor-pointer">
            <v-card-title>{{ institution.name }}</v-card-title>
            <v-card-subtitle>{{ institution.address }}</v-card-subtitle>
            <v-card-text>
              <p>{{ institution.phone }}</p>
              <p>{{ institution.email }}</p>
              <p>{{ institution.website }}</p>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted, computed } from 'vue';
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
  
      const institutions = computed(() => store.state.institutions);
  
      const viewInstitution = (id: string) => {
        router.push(`/institution/${id}`);
      };
  
      return {
        institutions,
        viewInstitution,
      };
    },
  });
  </script>
  
  <style scoped>
  /* Add your styles here */
  </style>
  