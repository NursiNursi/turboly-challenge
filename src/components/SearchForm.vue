<script setup>
const emit = defineEmits(["search"]);

const search = (e) => {
  emit("search", e.target.value);
};
</script>

<template>
  <form class="py-4 px-4 flex items-center">
    <div class="relative w-full">
      <input
        @input="search"
        type="text"
        placeholder="Search"
        class="form-control"
      />
    </div>
  </form>
</template>
