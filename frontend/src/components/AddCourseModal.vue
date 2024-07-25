<template>
    <v-dialog v-model:modelValue="dialog" max-width="600px" @update:modelValue="handleDialogClose">
      <v-card>
        <v-card-title>
          <span class="text-h5">Add New Course</span>
          <v-spacer></v-spacer>
          <v-btn icon @click="closeDialog">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <v-form @submit.prevent="addCourse">
            <v-text-field v-model="course.name" label="Name" required></v-text-field>
            <v-text-field v-model="course.code" label="Code" required></v-text-field>
            <v-text-field v-model="course.credit" label="Credit" required></v-text-field>
            <v-text-field v-model="course.duration" label="Duration" required></v-text-field>
            <v-btn type="submit" color="primary" block>Add</v-btn>
          </v-form>
        </v-card-text>
      </v-card>
    </v-dialog>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref, watch } from 'vue';
  import { useStore } from 'vuex';
  
  export default defineComponent({
    name: 'AddCourseModal',
    props: {
      modelValue: {
        type: Boolean,
        required: true,
      },
    },
    emits: ['update:modelValue'],
    setup(props, { emit }) {
      const store = useStore();
      const course = ref({ name: '', code: '', credit: 0, duration: 0 });
      const dialog = ref(props.modelValue);
  
      const addCourse = async () => {
        try {
          await store.dispatch('addCourse', course.value);
          emit('update:modelValue', false);
          course.value = { name: '', code: '', credit: 0, duration: 0 };
        } catch (error) {
          console.error('Failed to add course', error);
        }
      };
  
      const closeDialog = () => {
        emit('update:modelValue', false);
      };
  
      const handleDialogClose = (value: boolean) => {
        if (!value) {
          course.value = { name: '', code: '', credit: 0, duration: 0 };
        }
      };
  
      watch(() => props.modelValue, (newValue) => {
        dialog.value = newValue;
      });
  
      return { course, dialog, addCourse, closeDialog, handleDialogClose };
    },
  });
  </script>
  