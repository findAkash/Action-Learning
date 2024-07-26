import { Module } from 'vuex';
import api from '@/utils/api';

interface ScheduleState {
  schedules: Array<any>;
  currentSchedule: any;
}

const schedule: Module<ScheduleState, any> = {
  state: {
    schedules: [],
    currentSchedule: null,
  },
  mutations: {
    setSchedules(state, schedules) {
      state.schedules = schedules;
    },
    setCurrentSchedule(state, schedule) {
      state.currentSchedule = schedule;
    },
  },
  actions: {
    async fetchSchedules({ commit }) {
      try {
        const response = await api.get('/schedule/list');
        commit('setSchedules', response.data.schedules);
      } catch (error) {
        console.error('Failed to fetch schedules', error);
      }
    },
    async fetchScheduleById({ commit }, id) {
      try {
        const response = await api.get(`/schedule/${id}`);
        commit('setCurrentSchedule', response.data.schedule);
      } catch (error) {
        console.error('Failed to fetch schedule', error);
      }
    },
    async updateSchedule({ dispatch }, schedule) {
      try {
        await api.put(`/schedule/update/${schedule._id}`, schedule);
        dispatch('fetchSchedules');
      } catch (error) {
        console.error('Failed to update schedule', error);
      }
    },
  },
  getters: {
    schedules: state => state.schedules,
    currentSchedule: state => state.currentSchedule,
  },
};

export default schedule;
