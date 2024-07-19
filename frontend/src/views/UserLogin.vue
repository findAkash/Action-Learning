<template>
  <v-app>
    <v-main>
      <v-container class="fill-height d-flex align-center justify-center gradient-bg">
        <v-card class="elevation-12 login-card">
          <!-- <v-toolbar color="primary" dark flat>
            <v-toolbar-title>Login</v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-form>
              <v-text-field
                v-model="email"
                label="Email"
                prepend-icon="mdi-account"
                type="email"
                class="mb-4"
              ></v-text-field>
              <v-text-field
                v-model="password"
                label="Password"
                prepend-icon="mdi-lock"
                type="password"
                class="mb-4"
              ></v-text-field>
              <v-btn color="primary" block @click="login">Login</v-btn>
            </v-form>
          </v-card-text> -->
          <form @submit.prevent="login">
            <input v-model="email" placeholder="Email" />
            <input v-model="password" placeholder="Password" type="password" />
            <button type="submit">Login</button>
          </form>
        </v-card>
      </v-container>
    </v-main>
  </v-app>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import { useUserStore } from '@/stores/user';
import router from '@/router';

export default defineComponent({
  name: 'UserLogin',
  setup() {
    const userStore = useUserStore();
    const email = ref('');
    const password = ref('');

    const login = async () => {
      try {
        await userStore.login({ email: email.value, password: password.value });
        if (userStore.user) {
          router.push('/dashboard');  // Replace with your desired route
        }
      } catch (error) {
        console.error('Login failed', error);
      }
    };

    return {
      email,
      password,
      login,
    };
  },
});
</script>

<style scoped>
.fill-height {
  height: 100vh;
  z-index: 1;
  position: relative;
}

.gradient-bg {
  background: linear-gradient(to right, #00c6ff, #ff7e5f);
  z-index: 0;
}

.login-card {
  max-width: 400px;
  width: 100%;
  margin-top: -100px;
  padding: 20px;
  z-index: 2;
}

.mb-4 {
  margin-bottom: 1rem;
}
</style>

<!-- <form @submit.prevent="login">
  <input v-model="email" placeholder="Email" />
  <input v-model="password" placeholder="Password" type="password" />
  <button type="submit">Login</button>
</form> -->
