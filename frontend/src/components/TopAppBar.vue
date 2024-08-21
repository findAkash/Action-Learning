<template>
    <v-app-bar app color="primary" dark v-show="authenticated">
      <v-toolbar-title class="header-font">{{ topAppBarTitle }}</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-menu offset-y>
        <template v-slot:activator="{ on, props }">
          <v-btn icon v-bind="props" v-on="on">
            <v-icon>mdi-account-circle</v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item @click="goToProfile">
            <v-list-item-title>Profile</v-list-item-title>
          </v-list-item>
          <v-list-item @click="logout">
            <v-list-item-title>Logout</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>
  </template>
  
  <script lang="ts">
  import { defineComponent, computed } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  import { useStore } from 'vuex';
  
  export default defineComponent({
    name: 'TopAppBar',
    setup() {
      const router = useRouter();
      const route = useRoute();
      const store = useStore();
  
      const authenticated = computed(() => store.state.token !== null);
  
      const goToProfile = () => {
        router.push('/profile');
      };
  
      const logout = () => {
        store.commit('clearUserData');
        localStorage.clear();
        router.push('/login');
      };
  
      const topAppBarTitle = computed(() => {
        const currentPath = route.path;
        if (currentPath === '/superadmin-dashboard') {
          return 'SuperAdmin Dashboard';
        }
        if (currentPath === '/admin-dashboard') {
          return 'Admin Dashboard';
        }
        if (currentPath.includes('/institution/')) {
          return 'Institution Detail';
        }
        if (currentPath === '/create-institution') {
          return 'Create Institution';
        }
        if (currentPath === '/profile') {
          return 'Profile';
        }
        return 'Login';
      });
  
      return { authenticated, topAppBarTitle, goToProfile, logout };
    },
  });
  </script>
  
  <style scoped>
  </style>
  