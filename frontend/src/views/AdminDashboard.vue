<template>
    <div class="container mx-auto">
      <h1>Admin Dashboard</h1>
      <div>
        <h2>Students</h2>
        <ul>
          <li v-for="student in students" :key="student._id">{{ student.name }}</li>
        </ul>
      </div>
      <div>
        <h2>Courses</h2>
        <ul>
          <li v-for="course in courses" :key="course._id">{{ course.name }}</li>
        </ul>
      </div>
      <div>
        <h2>Batches</h2>
        <ul>
          <li v-for="batch in batches" :key="batch._id">{{ batch.name }}</li>
        </ul>
      </div>
      <div>
        <h2>Teachers</h2>
        <ul>
          <li v-for="teacher in teachers" :key="teacher._id">{{ teacher.name }}</li>
        </ul>
      </div>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, onMounted } from 'vue';
  import { useStore } from 'vuex';
  
  export default defineComponent({
    name: 'AdminDashboard',
    setup() {
      const store = useStore();
  
      onMounted(async () => {
        // Fetch data for students, courses, batches, and teachers
        await store.dispatch('fetchStudents');
        await store.dispatch('fetchCourses');
        await store.dispatch('fetchBatches');
        await store.dispatch('fetchTeachers');
      });
  
      return {
        students: store.state.students,
        courses: store.state.courses,
        batches: store.state.batches,
        teachers: store.state.teachers,
      };
    },
  });
  </script>
  
  <style scoped>
  /* Add your styles here */
  </style>
  