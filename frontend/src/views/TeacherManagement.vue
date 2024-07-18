<template>
    <div>
      <TeacherForm />
      <TeacherList />
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent } from 'vue';
  import TeacherForm from '@/components/TeacherForm.vue';
  import TeacherList from '@/components/TeacherList.vue';
  
  export default defineComponent({
    components: {
      TeacherForm,
      TeacherList,
    },
  });
  </script>
  