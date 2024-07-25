<template>
    <v-container>
      <v-row>
        <v-col v-for="course in courses" :key="course._id" cols="12" sm="6" md="4">
          <v-card>
            <v-card-title>{{ course.name }}</v-card-title>
            <v-card-actions>
              <v-btn :to="`/course/${course._id}`" color="primary">View Details</v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, computed, onMounted } from 'vue';
  import { useStore } from 'vuex';
  
  export default defineComponent({
    name: 'CourseList',
    setup() {
      const store = useStore();
  
      onMounted(() => {
        store.dispatch('fetchCourses');
      });
  
      const courses = computed(() => store.getters.courses);
  
      return { courses };
    },
  });
  </script>
  