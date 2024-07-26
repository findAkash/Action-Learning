<template>
  <v-container class="fill-height" fluid>
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="6" lg="4">
        <v-card class="pa-4">
          <v-card-title class="text-h5 text-center header-font">Edit Institution</v-card-title>
          <v-card-text>
            <v-form @submit.prevent="updateInstitution">
              <v-text-field v-model="institution.name" label="Name" type="text" required outlined></v-text-field>
              <v-text-field v-model="institution.address" label="Address" type="text" required outlined></v-text-field>
              <v-text-field v-model="institution.phone" label="Phone" type="text" required outlined></v-text-field>
              <v-text-field v-model="institution.email" label="Email" type="email" required outlined></v-text-field>
              <v-text-field v-model="institution.website" label="Website" type="text" outlined></v-text-field>
              <v-btn type="submit" color="primary" block class="mt-4">Update</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useStore } from 'vuex';
import api from '@/utils/api';

export default defineComponent({
  name: 'InstitutionDetail',
  setup() {
    const institution = ref({
      name: '',
      address: '',
      phone: '',
      email: '',
      website: '',
    });
    const route = useRoute();
    const router = useRouter();
    const store = useStore();
    const institutionId = route.params.id;

    onMounted(() => {
      const institutionData = store.state.institutions.find(
        (inst: any) => inst._id === institutionId
      );
      if (institutionData) {
        institution.value = { ...institutionData };
      }
    });

    const updateInstitution = async () => {
      try {
        const response = await api.put(
          `/superadmin/institution/update/${institutionId}`,
          institution.value,
          {
            headers: {
              Authorization: `Bearer ${store.state.token}`,
            },
          }
        );
        alert('Institution updated successfully');
        router.push('/superadmin-dashboard');
      } catch (error) {
        console.error('Failed to update institution', error);
        alert('Failed to update institution. Please try again.');
      }
    };

    return { institution, updateInstitution };
  },
});
</script>

<style scoped>
.fill-height {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(90deg, #6200ea, #b00020);
}
</style>