<template>
    <v-dialog v-model:modelValue="dialog" max-width="600px" @update:modelValue="handleDialogClose">
      <v-card>
        <v-card-title>
          <span class="text-h5">Add New Batch</span>
          <v-spacer></v-spacer>
          <v-btn icon @click="closeDialog">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <v-form @submit.prevent="addBatch">
            <v-text-field v-model="batch.batchName" label="Name" required></v-text-field>
            <v-text-field v-model="batch.startDate" label="Start Date" required></v-text-field>
            <v-text-field v-model="batch.endDate" label="End Date" required></v-text-field>
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
    name: 'AddBatchModal',
    props: {
      modelValue: {
        type: Boolean,
        required: true,
      },
    },
    emits: ['update:modelValue'],
    setup(props, { emit }) {
      const store = useStore();
      const batch = ref({ batchName: '', startDate: '', endDate: '' });
      const dialog = ref(props.modelValue);
  
      const addBatch = async () => {
        try {
          await store.dispatch('addBatch', batch.value);
          emit('update:modelValue', false);
          batch.value = { batchName: '', startDate: '', endDate: '' };
        } catch (error) {
          console.error('Failed to add batch', error);
        }
      };
  
      const closeDialog = () => {
        emit('update:modelValue', false);
      };
  
      const handleDialogClose = (value: boolean) => {
        if (!value) {
          batch.value = { batchName: '', startDate: '', endDate: '' };
        }
      };
  
      watch(() => props.modelValue, (newValue) => {
        dialog.value = newValue;
      });
  
      return { batch, dialog, addBatch, closeDialog, handleDialogClose };
    },
  });
  </script>
  