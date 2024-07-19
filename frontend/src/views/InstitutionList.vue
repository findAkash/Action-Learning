<template>
    <v-app>
      <v-main>
        <v-container>
          <v-data-table :headers="headers" :items="institutions" class="elevation-1" @click:row="selectInstitution"></v-data-table>
          <v-dialog v-model="dialog" max-width="500px">
            <v-card>
              <v-card-title>
                <span class="headline">Edit Institution</span>
              </v-card-title>
              <v-card-text>
                <v-form>
                  <v-text-field v-model="selectedInstitution.name" label="Name"></v-text-field>
                  <v-text-field v-model="selectedInstitution.address" label="Address"></v-text-field>
                  <v-text-field v-model="selectedInstitution.phone" label="Phone"></v-text-field>
                  <v-text-field v-model="selectedInstitution.email" label="Email"></v-text-field>
                  <v-text-field v-model="selectedInstitution.website" label="Website"></v-text-field>
                </v-form>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue darken-1" text @click="saveInstitution">Save</v-btn>
                <v-btn color="grey darken-1" text @click="dialog = false">Cancel</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-container>
      </v-main>
    </v-app>
  </template>
  
  <script lang="ts">
  import { defineComponent, ref, onMounted } from 'vue';
  import axios from '@/plugins/axios';
  
  interface Institution {
    _id: string;
    name: string;
    address: string;
    phone: string;
    email: string;
    website: string;
  }
  
  export default defineComponent({
    name: 'InstitutionList',
    setup() {
      const institutions = ref<Institution[]>([]);
      const headers = [
        { text: 'Name', value: 'name' },
        { text: 'Address', value: 'address' },
        { text: 'Phone', value: 'phone' },
        { text: 'Email', value: 'email' },
        { text: 'Website', value: 'website' },
      ];
      const dialog = ref(false);
      const selectedInstitution = ref<Partial<Institution>>({});
  
      const fetchInstitutions = async () => {
        const response = await axios.get('/api/v1/superadmin/institution/get');
        institutions.value = response.data.institutions;
      };
  
      const selectInstitution = (item: Institution) => {
        selectedInstitution.value = { ...item };
        dialog.value = true;
      };
  
      const saveInstitution = async () => {
        await axios.put(`/api/v1/superadmin/institution/update/${selectedInstitution.value._id}`, selectedInstitution.value);
        await fetchInstitutions();
        dialog.value = false;
      };
  
      onMounted(() => {
        fetchInstitutions();
      });
  
      return {
        institutions,
        headers,
        dialog,
        selectedInstitution,
        selectInstitution,
        saveInstitution,
      };
    },
  });
  </script>
  