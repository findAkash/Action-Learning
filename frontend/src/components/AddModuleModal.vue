<template>
    <v-dialog v-model:modelValue="dialog" max-width="600px" @update:modelValue="handleDialogClose">
      <v-card>
        <v-card-title>
          <span class="text-h5">Add New Module</span>
          <v-spacer></v-spacer>
          <v-btn icon @click="closeDialog">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <v-form @submit.prevent="addModule">
            <v-text-field v-model="module.title" label="Title" required></v-text-field>
            <v-text-field v-model="module.description" label="Description" required></v-text-field>
            <v-text-field v-model="module.credit" label="Credit" required></v-text-field>
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
    name: 'AddModuleModal',
    props: {
      modelValue: {
        type: Boolean,
        required: true,
      },
    },
    emits: ['update:modelValue'],
    setup(props, { emit }) {
      const store = useStore();
      const module = ref({ title: '', description: '', credit: 0 });
      const dialog = ref(props.modelValue);
  
      const addModule = async () => {
        try {
          await store.dispatch('addModule', module.value);
          emit('update:modelValue', false);
          module.value = { title: '', description: '', credit: 0 };
        } catch (error) {
          console.error('Failed to add module', error);
        }
      };
  
      const closeDialog = () => {
        emit('update:modelValue', false);
      };
  
      const handleDialogClose = (value: boolean) => {
        if (!value) {
          module.value = { title: '', description: '', credit: 0 };
        }
      };
  
      watch(() => props.modelValue, (newValue) => {
        dialog.value = newValue;
      });
  
      return { module, dialog, addModule, closeDialog, handleDialogClose };
    },
  });
  </script>
  