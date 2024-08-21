<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-card-title>Schedule Detail</v-card-title>
          <v-card-text>
            <v-form @submit.prevent="updateSchedule">
              <v-text-field v-model="schedule.startTime" label="Start Time" required></v-text-field>
              <v-text-field v-model="schedule.endTime" label="End Time" required></v-text-field>
              <v-btn type="submit" color="primary">Save</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useRoute } from 'vue-router';

export default defineComponent({
  name: 'ScheduleDetail',
  setup() {
    const store = useStore();
    const route = useRoute();
    const schedule = ref({ startTime: '', endTime: '' });

    onMounted(async () => {
      const scheduleId = route.params.id;
      await store.dispatch('fetchScheduleById', scheduleId);
      schedule.value = store.getters.currentSchedule;
    });

    const updateSchedule = async () => {
      await store.dispatch('updateSchedule', schedule.value);
    };

    return { schedule, updateSchedule };
  },
});
</script>
