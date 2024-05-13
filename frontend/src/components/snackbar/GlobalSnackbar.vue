<template>
    <div v-if="packageStore.getSnackbar.show" class="flex z-999">
      <v-snackbar v-model="snackbarName" :timeout="2000">
        <v-btn
          v-if="packageStore.getSnackbar.type == 'success'"
          class="!bg-green-200 !shadow-none !text-green-600 !w-8 !h-8 md:!w-10 md:!h-10 mx-2 !text-lg z-999"
          aria-label="Sent"
          icon="mdi-check"
        ></v-btn>
        <v-btn
          v-else
          class="!bg-red-200 !shadow-none !text-red-600 !w-8 !h-8 md:!w-10 md:!h-10 mx-2 !text-lg z-999"
          aria-label="Sent"
          icon="mdi-alert-circle-outline"
        ></v-btn>
        {{ packageStore.getSnackbar.message }}
      </v-snackbar>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import { usePackageStore } from '../../stores/package'
  
  const packageStore = usePackageStore()
  const snackbarName = ref(true)
  </script>
  