import { createApp } from 'vue'
import './style.css'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'

import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'
import { createVuetify, type ThemeDefinition } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

// make sure to also import the coresponding css
import '@mdi/font/css/materialdesignicons.css' // Ensure you are using css-loader
// import GlobalSnackbar from './components/snackbar' // Import the GlobalSnackbar component

const namePlaceHolderTheme: ThemeDefinition = {
    colors: {
      background: '#FFF',
      surface: '#FFF',
      primary: '#03a9f4',
      secondary: '#4caf50',
      accent: '#673ab7',
      error: '#f44336',
      warning: '#ff9800',
      info: '#00bcd4',
      success: '#8bc34a'
    }
  }
  const vuetify = createVuetify({
    theme: {
      defaultTheme: 'namePlaceHolderTheme',
      themes: {
        namePlaceHolderTheme
      }
    },
    icons: {
      defaultSet: 'mdi'
    },
    components,
    directives
  })
  
  const app = createApp(App)
  
//   app.component('GlobalSnackbar', GlobalSnackbar)
  app.use(createPinia())
  app.use(router)
  app.use(vuetify)
  
  app.mount('#app')
  