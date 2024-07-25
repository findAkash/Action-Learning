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

export default defineComponent({
    name: 'TeacherDashboard',
    setup() {
        const store = useStore();
        const modules = ref([]);
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
                const scheduledClass = response.data.scheduledClass;
                if (scheduledClass) {
                    startAttendance(scheduledClass._id);
                }
            } catch (error) {
                console.error('Failed to fetch scheduled classes', error);
            }
        };

        const startAttendance = async (classId: string) => {
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
            showQrCodeDialog,
            qrCodeUrl,
            viewScheduledClasses,
            startAttendance,
            closeQrCodeDialog,
        };
    },
});
</script>

<style scoped></style>
