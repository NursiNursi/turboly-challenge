<script setup>
const emit = defineEmits(["search"]);

const search = (e) => {
  emit("search", e.target.value);
};
</script>

<template>
  <form class="search-input">
    <div>
      <input
        @input="search"
        type="text"
        placeholder="Search"
        class="form-control"
      />
    </div>
  </form>
</template>
