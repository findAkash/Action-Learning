<template>
    <div>
      <h2>Teacher List</h2>
      <ul>
        <li v-for="teacher in teachers" :key="teacher._id">{{ teacher.email }}</li>
      </ul>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted } from 'vue';
  import { useTeacherStore } from '@/stores/teacher';
  
  export default defineComponent({
    setup() {
      const teacherStore = useTeacherStore();
      onMounted(() => {
        teacherStore.fetchTeachers();
      });
  
      return {
        teachers: teacherStore.teachers,
      };
    },
  });
  </script>
  