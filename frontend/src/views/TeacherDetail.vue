<template>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title>Teacher Detail</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="updateTeacher">
                <v-text-field v-model="teacher.user.firstName" label="First Name" required></v-text-field>
                <v-text-field v-model="teacher.user.lastName" label="Last Name" required></v-text-field>
                <v-text-field v-model="teacher.user.email" label="Email" required></v-text-field>
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
    name: 'TeacherDetail',
    setup() {
      const store = useStore();
      const route = useRoute();
      const teacher = ref({ user: { firstName: '', lastName: '', email: '' } });
  
      onMounted(async () => {
        const teacherId = route.params.id;
        await store.dispatch('fetchTeacherById', teacherId);
        teacher.value = store.getters.currentTeacher;
      });
  
      const updateTeacher = async () => {
        await store.dispatch('updateTeacher', teacher.value);
      };
  
      return { teacher, updateTeacher };
    },
  });
  </script>
  