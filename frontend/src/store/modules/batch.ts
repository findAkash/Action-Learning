import { Module } from 'vuex';
import api from '@/utils/api';

interface BatchState {
  batches: Array<any>;
  currentBatch: any;
}

const batch: Module<BatchState, any> = {
  state: {
    batches: [],
    currentBatch: null,
  },
  mutations: {
    setBatches(state, batches) {
      state.batches = batches;
    },
    setCurrentBatch(state, batch) {
      state.currentBatch = batch;
    },
  },
  actions: {
    async fetchBatches({ commit }) {
      try {
        const response = await api.get('/institution/admin/batch/list');
        commit('setBatches', response.data.batches);
      } catch (error) {
        console.error('Failed to fetch batches', error);
      }
    },
    async fetchBatchById({ commit }, id) {
      try {
        const response = await api.get(`/institution/admin/batch/${id}`);
        commit('setCurrentBatch', response.data.batch);
      } catch (error) {
        console.error('Failed to fetch batch', error);
      }
    },
    async updateBatch({ dispatch }, batch) {
      try {
        await api.put(`/institution/admin/batch/update/${batch._id}`, batch);
        dispatch('fetchBatches');
      } catch (error) {
        console.error('Failed to update batch', error);
      }
    },
    async addBatch({ commit }, batch) {
      const response = await api.post('/institution/admin/batch/create', batch);
      commit('addBatch', response.data.batch);
    },
  },
  getters: {
    batches: state => state.batches,
    currentBatch: state => state.currentBatch,
  },
};

export default batch;
