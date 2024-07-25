<template>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title>Modules</v-card-title>
            <v-list>
              <v-list-item v-for="module in modules" :key="module._id" @click="viewScheduledClasses(module)">
                <v-list-item-content>{{ module.title }}</v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card>
        </v-col>
      </v-row>
      
      <!-- Scheduled Classes Modal -->
      <v-dialog v-model="showScheduledClassesDialog" max-width="600px">
        <v-card>
          <v-card-title>Scheduled Classes</v-card-title>
          <v-card-text>
            <v-list>
              <v-list-item v-for="scheduledClass in scheduledClasses" :key="scheduledClass._id">
                <v-list-item-content>
                  {{ scheduledClass.module.title }} - {{ new Date(scheduledClass.startTime).toLocaleString() }} to {{ new Date(scheduledClass.endTime).toLocaleString() }}
                </v-list-item-content>
                <v-list-item-action>
                  <v-btn @click="showQrCode(scheduledClass._id)"><i class="mdi mdi-qrcode"></i></v-btn>
                </v-list-item-action>
              </v-list-item>
            </v-list>
          </v-card-text>
          <v-card-actions>
            <v-btn color="secondary" @click="showScheduledClassesDialog = false">Close</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
  
      <!-- QR Code Modal -->
      <v-dialog v-model="showQrCodeDialog" max-width="500px">
        <v-card>
          <v-card-title>QR Code</v-card-title>
          <v-card-text>
            <img :src="qrCodeUrl" alt="QR Code" v-if="qrCodeUrl" />
            <v-progress-circular indeterminate v-if="!qrCodeUrl"></v-progress-circular>
          </v-card-text>
          <v-card-actions>
            <v-btn color="primary" @click="closeQrCodeDialog">Close</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref, onMounted } from 'vue';
  import { useStore } from 'vuex';
  import api from '@/utils/api';
  import axios from 'axios';
import { mdi } from 'vuetify/iconsets/mdi';
  
  export default defineComponent({
    name: 'TeacherDashboard',
    setup() {
      const store = useStore();
      const modules = ref([]);
      const scheduledClasses = ref([]);
      const showScheduledClassesDialog = ref(false);
      const showQrCodeDialog = ref(false);
      const qrCodeUrl = ref('');
  
      onMounted(async () => {
        await fetchModules();
      });
  
      const fetchModules = async () => {
        try {
          const response = await api.get('/institution/teacher/modules', {
            headers: {
              Authorization: `Bearer ${store.state.token}`,
            },
          });
          modules.value = response.data.modules;
        } catch (error) {
          console.error('Failed to fetch modules', error);
        }
      };
  
      const viewScheduledClasses = async (module: any) => {
        try {
          const response = await api.get(`/institution/teacher/schedule/${module._id}`, {
            headers: {
              Authorization: `Bearer ${store.state.token}`,
            },
          });
          scheduledClasses.value = [response.data.scheduledClass];
          showScheduledClassesDialog.value = true;
        } catch (error) {
          console.error('Failed to fetch scheduled classes', error);
        }
      };
  
      const showQrCode = async (classId: string) => {
        try {
          const qrApi = axios.create({
            baseURL: process.env.VUE_APP_QR_API_BASE_URL,
            headers: {
              'Content-Type': 'application/json',
            },
            responseType: 'blob',  // Set the response type to blob
          });
          const response = await qrApi.get(`/professor/generate-qr-attendance/${classId}`);
          const blob = new Blob([response.data], { type: 'image/png' });
          qrCodeUrl.value = URL.createObjectURL(blob);  // Create a URL from the blob
          showQrCodeDialog.value = true;
        } catch (error) {
          console.error('Failed to start attendance', error);
        }
      };
  
      const closeQrCodeDialog = () => {
        showQrCodeDialog.value = false;
        qrCodeUrl.value = '';  // Clear the URL to release the object URL
      };
  
      return {
        modules,
        scheduledClasses,
        showScheduledClassesDialog,
        showQrCodeDialog,
        qrCodeUrl,
        viewScheduledClasses,
        showQrCode,
        closeQrCodeDialog,
      };
    },
  });
  </script>
  
  <style scoped></style>
  