<template>
    <v-container>
      <v-row>
        <v-col v-for="student in students" :key="student._id" cols="12" sm="6" md="4">
          <v-card>
            <v-card-title>{{ student.user.firstName }} {{ student.user.lastName }}</v-card-title>
            <v-card-subtitle>{{ student.user.email }}</v-card-subtitle>
            <v-card-actions>
              <v-btn :to="`/student/${student._id}`" color="primary">View Details</v-btn>
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
    name: 'StudentList',
    setup() {
      const store = useStore();
  
      onMounted(() => {
        store.dispatch('fetchStudents');
      });
  
      const students = computed(() => store.getters.students);
  
      return { students };
    },
  });
  </script>
  