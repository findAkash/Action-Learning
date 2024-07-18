<template>
    <div>
      <StudentForm />
      <StudentList />
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent } from 'vue';
  import StudentForm from '@/components/StudentForm.vue';
  import StudentList from '@/components/StudentList.vue';
  
  export default defineComponent({
    components: {
      StudentForm,
      StudentList,
    },
  });
  </script>
  