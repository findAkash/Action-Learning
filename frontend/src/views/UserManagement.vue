<template>
    <div>
      <UserForm />
      <UserList />
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent } from 'vue';
  import UserForm from '@/components/UserForm.vue';
  import UserList from '@/components/UserList.vue';
  
  export default defineComponent({
    components: {
      UserForm,
      UserList,
    },
  });
  </script>
  