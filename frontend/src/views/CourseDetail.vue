<template>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title>Course Detail</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="updateCourse">
                <v-text-field v-model="course.name" label="Name" required></v-text-field>
                <v-text-field v-model="course.code" label="Code" required></v-text-field>
                <v-text-field v-model="course.credit" label="Credit" required></v-text-field>
                <v-text-field v-model="course.duration" label="Duration" required></v-text-field>
                <v-btn type="submit" color="primary">Save</v-btn>
              </v-form>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref, onMounted } from 'vue';
  import { useStore } from 'vuex';
  import { useRoute } from 'vue-router';
  
  export default defineComponent({
    name: 'CourseDetail',
    setup() {
      const store = useStore();
      const route = useRoute();
      const course = ref({ name: '', code: '', credit: 0, duration: 0 });
  
      onMounted(async () => {
        const courseId = route.params.id;
        await store.dispatch('fetchCourseById', courseId);
        course.value = store.getters.currentCourse;
      });
  
      const updateCourse = async () => {
        await store.dispatch('updateCourse', course.value);
      };
  
      return { course, updateCourse };
    },
  });
  </script>
  