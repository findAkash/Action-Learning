<template>
    <v-app>
      <v-main>
        <v-container>
          <v-row>
            <v-col>
              <v-btn color="primary" @click="viewUsers">View Users</v-btn>
            </v-col>
            <v-col>
              <v-btn color="primary" @click="viewInstitutions">View Institutions</v-btn>
            </v-col>
          </v-row>
          <v-row>
            <router-view></router-view>
          </v-row>
        </v-container>
      </v-main>
    </v-app>
  </template>
  
  <script lang="ts">
  import { defineComponent } from 'vue';
  import { useRouter } from 'vue-router';
  
  export default defineComponent({
    name: 'SuperAdminDashboard',
    setup() {
      const router = useRouter();
  
      const viewUsers = () => {
        router.push({ name: 'UserList' });
      };
  
      const viewInstitutions = () => {
        router.push({ name: 'InstitutionList' });
      };
  
      return {
        viewUsers,
        viewInstitutions,
      };
    },
  });
  </script>
  