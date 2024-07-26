<template>
    <v-dialog v-bind:model-value="isVisible" persistent max-width="600" @update:model-value="updateVisibility">
      <v-card>
        <v-card-title class="text-h5">QR Code for Attendance</v-card-title>
        <v-card-text>
          <v-img :src="qrCodeSrc" max-height="400" max-width="400"></v-img>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="red darken-1" text @click="closeModal">Close</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </template>
  
  <script>
  export default {
    props: {
      isVisible: {
        type: Boolean,
        required: true,
      },
      qrCodeSrc: {
        type: String,
        required: true,
      },
    },
    methods: {
      updateVisibility(value) {
        this.$emit('update:isVisible', value);
      },
      closeModal() {
        this.$emit('update:isVisible', false);
      },
    },
  };
  </script>
  