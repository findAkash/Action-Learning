<template>
    <v-dialog v-model:modelValue="dialog" max-width="600px" @update:modelValue="handleDialogClose">
      <v-card>
        <v-card-title>
          <span class="text-h5">Add New Enrollment</span>
          <v-spacer></v-spacer>
          <v-btn icon @click="closeDialog">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <v-form @submit.prevent="addEnrollment">
            <v-text-field v-model="enrollment.student" label="Student ID" required></v-text-field>
            <v-text-field v-model="enrollment.course" label="Course ID" required></v-text-field>
            <v-text-field v-model="enrollment.fee" label="Fee" required></v-text-field>
            <v-text-field v-model="enrollment.discount" label="Discount" required></v-text-field>
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
    name: 'AddEnrollmentModal',
    props: {
      modelValue: {
        type: Boolean,
        required: true,
      },
    },
    emits: ['update:modelValue'],
    setup(props, { emit }) {
      const store = useStore();
      const enrollment = ref({ student: '', course: '', fee: 0, discount: 0 });
      const dialog = ref(props.modelValue);
  
      const addEnrollment = async () => {
        try {
          await store.dispatch('addEnrollment', enrollment.value);
          emit('update:modelValue', false);
          enrollment.value = { student: '', course: '', fee: 0, discount: 0 };
        } catch (error) {
          console.error('Failed to add enrollment', error);
        }
      };
  
      const closeDialog = () => {
        emit('update:modelValue', false);
      };
  
      const handleDialogClose = (value: boolean) => {
        if (!value) {
          enrollment.value = { student: '', course: '', fee: 0, discount: 0 };
        }
      };
  
      watch(() => props.modelValue, (newValue) => {
        dialog.value = newValue;
      });
  
      return { enrollment, dialog, addEnrollment, closeDialog, handleDialogClose };
    },
  });
  </script>
  