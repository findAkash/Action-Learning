<template>
    <div>
      <h2>Student List</h2>
      <ul>
        <li v-for="student in students" :key="student._id">{{ student.email }}</li>
      </ul>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted } from 'vue';
  import { useStudentStore } from '@/stores/student';
  
  export default defineComponent({
    setup() {
      const studentStore = useStudentStore();
      onMounted(() => {
        studentStore.fetchStudents();
      });
  
      return {
        students: studentStore.students,
      };
    },
  });
  </script>
  