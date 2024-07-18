<template>
    <div>
      <SuperAdminForm />
      <SuperAdminList />
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent } from 'vue';
  import SuperAdminForm from '@/components/SuperAdminForm.vue';
  import SuperAdminList from '@/components/SuperAdminList.vue';
  
  export default defineComponent({
    components: {
      SuperAdminForm,
      SuperAdminList,
    },
  });
  </script>
  