<template>
  <v-container class="d-flex justify-center align-center fill-height">
    <v-card class="pa-5" max-width="400">
      <v-card-title>
        <span class="headline">Login</span>
      </v-card-title>
      <v-card-text>
        <v-form @submit.prevent="login">
          <v-text-field v-model="email" label="Email" required></v-text-field>
          <v-text-field v-model="password" label="Password" type="password" required></v-text-field>
          <v-btn type="submit" color="primary" class="mt-4" block>Login</v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import { useUserStore } from '@/stores/user';

export default defineComponent({
  name: 'UserLogin',
  setup() {
    const userStore = useUserStore();
    const email = ref('');
    const password = ref('');

    const login = async () => {
      await userStore.login({ email: email.value, password: password.value });
    };

    return {
      email,
      password,
      login,
    };
  },
});
</script>
