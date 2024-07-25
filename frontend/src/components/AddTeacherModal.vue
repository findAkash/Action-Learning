<template>
    <v-dialog v-model:modelValue="dialog" max-width="600px" @update:modelValue="handleDialogClose">
      <v-card>
        <v-card-title>
          <span class="text-h5">Add New Teacher</span>
          <v-spacer></v-spacer>
          <v-btn icon @click="closeDialog">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <v-form @submit.prevent="addTeacher">
            <v-text-field v-model="teacher.user.firstName" label="First Name" required></v-text-field>
            <v-text-field v-model="teacher.user.lastName" label="Last Name" required></v-text-field>
            <v-text-field v-model="teacher.user.email" label="Email" required></v-text-field>
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
    name: 'AddTeacherModal',
    props: {
      modelValue: {
        type: Boolean,
        required: true,
      },
    },
    emits: ['update:modelValue'],
    setup(props, { emit }) {
      const store = useStore();
      const teacher = ref({ user: { firstName: '', lastName: '', email: '' } });
      const dialog = ref(props.modelValue);
  
      const addTeacher = async () => {
        try {
          await store.dispatch('addTeacher', teacher.value);
          emit('update:modelValue', false);
          teacher.value = { user: { firstName: '', lastName: '', email: '' } };
        } catch (error) {
          console.error('Failed to add teacher', error);
        }
      };
  
      const closeDialog = () => {
        emit('update:modelValue', false);
      };
  
      const handleDialogClose = (value: boolean) => {
        if (!value) {
          teacher.value = { user: { firstName: '', lastName: '', email: '' } };
        }
      };
  
      watch(() => props.modelValue, (newValue) => {
        dialog.value = newValue;
      });
  
      return { teacher, dialog, addTeacher, closeDialog, handleDialogClose };
    },
  });
  </script>
  