<template>
    <div>
      <h2>Create Student</h2>
      <form @submit.prevent="createStudent">
        <input v-model="email" placeholder="Email" />
        <input v-model="password" placeholder="Password" type="password" />
        <button type="submit">Create</button>
      </form>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref } from 'vue';
  import { useStudentStore } from '@/stores/student';
  
  export default defineComponent({
    setup() {
      const studentStore = useStudentStore();
      const email = ref('');
      const password = ref('');
  
      const createStudent = async () => {
        await studentStore.createStudent({ email: email.value, password: password.value });
        email.value = '';
        password.value = '';
      };
  
      return {
        email,
        password,
        createStudent,
      };
    },
  });
  </script>
  