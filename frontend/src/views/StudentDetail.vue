<template>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title>Student Detail</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="updateStudent">
                <v-text-field v-model="student.user.firstName" label="First Name" required></v-text-field>
                <v-text-field v-model="student.user.lastName" label="Last Name" required></v-text-field>
                <v-text-field v-model="student.user.email" label="Email" required></v-text-field>
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
    name: 'StudentDetail',
    setup() {
      const store = useStore();
      const route = useRoute();
      const student = ref({ user: { firstName: '', lastName: '', email: '' } });
  
      onMounted(async () => {
        const studentId = route.params.id;
        await store.dispatch('fetchStudentById', studentId);
        student.value = store.getters.currentStudent;
      });
  
      const updateStudent = async () => {
        await store.dispatch('updateStudent', student.value);
      };
  
      return { student, updateStudent };
    },
  });
  </script>
  