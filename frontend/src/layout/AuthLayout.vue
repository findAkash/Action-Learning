<template>
  <div>
    <slot />
    <footerView />
  </div>
</template>

<script>
import footerView from './FooterView.vue'
export default {
  components: {
    footerView
  }
}
</script>
