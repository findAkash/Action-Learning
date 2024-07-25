import { Module } from 'vuex';
import api from '@/utils/api';

interface ModuleState {
  modules: Array<any>;
  currentModule: any;
}

const module: Module<ModuleState, any> = {
  state: {
    modules: [],
    currentModule: null,
  },
  mutations: {
    setModules(state, modules) {
      state.modules = modules;
    },
    setCurrentModule(state, module) {
      state.currentModule = module;
    },
  },
  actions: {
    async fetchModules({ commit }) {
      try {
        const response = await api.get('/institution/admin/module/list');
        commit('setModules', response.data.modules);
      } catch (error) {
        console.error('Failed to fetch modules', error);
      }
    },
    async fetchTeacherModules({ commit }) {
      try {
        const response = await api.get('/institution/teacher/modules', {
          headers: {
            Authorization: `Bearer ${this.state.token}`,
          },
        });
        commit('setModules', response.data.modules);
      } catch (error) {
        console.error('Failed to fetch modules', error);
      }
    },
    async fetchModuleById({ commit }, id) {
      try {
        const response = await api.get(`/institution/admin/module/${id}`);
        commit('setCurrentModule', response.data.module);
      } catch (error) {
        console.error('Failed to fetch module', error);
      }
    },
    async updateModule({ dispatch }, module) {
      try {
        await api.put(`/institution/admin/module/update/${module._id}`, module);
        dispatch('fetchModules');
      } catch (error) {
        console.error('Failed to update module', error);
      }
    },
  },
  getters: {
    modules: state => state.modules,
    currentModule: state => state.currentModule,
  },
};

export default module;
