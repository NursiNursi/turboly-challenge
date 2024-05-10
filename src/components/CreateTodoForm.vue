<template>
  <form id="new-todo-form" @submit.prevent="handleAddTodo">
    <h4>What's on your todo list?</h4>
    <input
      type="text"
      name="content"
      id="content"
      placeholder="e.g. make a video"
      v-model="input_content"
    />
    <h4>Due Dates</h4>
    <input
      type="date"
      name="dueDate"
      id="dueDate"
      placeholder="Enter Due Date"
      v-model="input_dueDate"
    />
    <h4>Priorities</h4>
    <div class="options">
      <label v-for="(level, key) in priorityLevels" :key="key">
        <input
          type="radio"
          name="priority"
          :id="'priority' + key"
          :value="key"
          v-model="input_priority"
        />
        <span class="bubble" :class="key"></span>
        <div>{{ key }}</div>
      </label>
    </div>
    <input type="submit" value="Add todo" />
  </form>
</template>

<script setup>
import { ref, defineEmits } from "vue";

const emits = defineEmits(["addTodo"]);

const input_content = ref("");
const input_dueDate = ref("");
const input_priority = ref(null);

const priorityLevels = {
  low: 3,
  middle: 2,
  high: 1,
};

const handleAddTodo = () => {
  if (!input_content.value.trim() || input_priority.value === null) return;

  emits("addTodo", {
    content: input_content.value,
    dueDate: input_dueDate.value,
    priority: input_priority.value,
  });

  input_content.value = "";
  input_dueDate.value = "";
  input_priority.value = null;
};
</script>
