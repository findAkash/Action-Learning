<template>
    <v-container>
      <v-row>
        <v-col v-for="schedule in schedules" :key="schedule._id" cols="12" sm="6" md="4">
          <v-card>
            <v-card-title>{{ schedule.module.title }}</v-card-title>
            <v-card-subtitle>{{ schedule.startTime | formatDate }}</v-card-subtitle>
            <v-card-actions>
              <v-btn :to="`/schedule/${schedule._id}`" color="primary">View Details</v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script lang="ts">
  import { defineComponent, computed, onMounted } from 'vue';
  import { useStore } from 'vuex';
  
  export default defineComponent({
    name: 'ScheduleList',
    setup() {
      const store = useStore();
  
      onMounted(() => {
        store.dispatch('fetchSchedules');
      });
  
      const schedules = computed(() => store.getters.schedules);
  
      return { schedules };
    },
    filters: {
      formatDate(value: string) {
        const options: Intl.DateTimeFormatOptions = { year: 'numeric', month: 'short', day: 'numeric' };
        return new Date(value).toLocaleDateString(undefined, options);
      },
    },
  });
  </script>
  