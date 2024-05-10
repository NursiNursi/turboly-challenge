<script setup>
import { defineProps, defineEmits } from "vue";

const props = defineProps(["filteredItems"]);
const emits = defineEmits(["remove"]);

const handleRemove = (todo) => {
  emits("remove", todo);
};

const priorityClass = (priority) => {
  return {
    low: "low",
    middle: "middle",
    high: "high",
  }[priority];
};

const priorityBadgeClass = (priority) => {
  return {
    low: "bg-success",
    middle: "bg-warning",
    high: "bg-danger",
  }[priority];
};
</script>

<template>
  <div class="list" id="todo-list">
    <div
      v-for="todo in filteredItems"
      :class="`todo-item ${todo.done && 'done'}`"
    >
      <label>
        <input type="checkbox" v-model="todo.done" />
        <span :class="`bubble ${priorityClass(todo.priority)}`"></span>
      </label>
      <div class="todo-content">
        <span
          class="badge rounded-pill"
          :class="priorityBadgeClass(todo.priority)"
          >{{ todo.priority }}</span
        >
        <input class="todo-description" type="text" v-model="todo.content" />
        <input
          class="todo-due-date"
          disabled
          type="text"
          v-model="todo.dueDate"
        />
      </div>
      <div class="actions">
        <button class="delete" @click="handleRemove(todo)">Delete</button>
      </div>
    </div>
  </div>
</template>
