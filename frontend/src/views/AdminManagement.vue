<template>
    <div>
      <AdminForm />
      <AdminList />
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent } from 'vue';
  import AdminForm from '@/components/AdminForm.vue';
  import AdminList from '@/components/AdminList.vue';
  
  export default defineComponent({
    components: {
      AdminForm,
      AdminList,
    },
  });
  </script>
  