<template>
  <div
    class="footer mvmed-gr max-w-full fixed bottom-0 w-full left-1/2 -translate-x-1/2 bg-white mx-auto p-5 shadow-bottomfooter z-999"
  >
    <div class="flex items-center gap-x-8 gap-y-5 justify-center">
      <div
        class="d-flex justify-space-around icon-button"
        v-for="(icon, index) in icons"
        :key="index"
        @click="selectIcon(index)"
        :class="{ active: isSelected(index) }"
      >
        <v-icon
          size="30"
          :color="isSelected(index)"
          :icon="icon"
          v-if="icon !== 'mdi-view-grid-plus-outline'"
        ></v-icon>
        <v-icon
          size="30"
          color="white"
          :style="{
            background: 'linear-gradient(139.4deg, #4FBA68 14.24%, #70B9F3 93.76%)',
            height: '40px',
            width: '40px',
            borderRadius: '31%'
          }"
          :icon="icon"
          variant="tonal"
          v-if="icon === 'mdi-view-grid-plus-outline'"
        ></v-icon>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()
import { usePackageStore } from '../../stores/package'
const packageStore = usePackageStore()

const icons = [
  'mdi-home-outline',
  'mdi-signal-cellular-outline',
  'mdi-view-grid-plus-outline',
  'mdi-package-variant-closed',
  'mdi-view-grid-outline'
]

const isSelected = (index) => packageStore.getSelectedIndex === index

const selectIcon = (index) => {
  packageStore.SET_SELECTED_INDEX(index)

  switch (index) {
    case 0:
      router.push('/dashboard')
      break
  }
}
</script>

<style scoped>
.icon-button {
  margin: 0;
  cursor: pointer;
}

.icon-button.active {
  text-decoration: underline;
}

.footer-gr {
  background: linear-gradient(180deg, #0E5583 14.24%, #269747 93.76%);
}
</style>
