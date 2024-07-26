<template>
    <v-container>
      <v-row>
        <v-col v-for="teacher in teachers" :key="teacher._id" cols="12" sm="6" md="4">
          <v-card>
            <v-card-title>{{ teacher.user.firstName }} {{ teacher.user.lastName }}</v-card-title>
            <v-card-subtitle>{{ teacher.user.email }}</v-card-subtitle>
            <v-card-actions>
              <v-btn :to="`/teacher/${teacher._id}`" color="primary">View Details</v-btn>
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
    name: 'TeacherList',
    setup() {
      const store = useStore();
  
      onMounted(() => {
        store.dispatch('fetchTeachers');
      });
  
      const teachers = computed(() => store.getters.teachers);
  
      return { teachers };
    },
  });
  </script>
  