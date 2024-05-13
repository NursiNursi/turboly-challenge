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

<style scoped>
input[type="radio"],
input[type="checkbox"] {
  display: none;
}

input:not([type="radio"]):not([type="checkbox"]),
button {
  appearance: none;
  border: none;
  outline: none;
  background: none;
  cursor: initial;
}

.todo-list .list {
  margin: 1rem 0;
}

.todo-list .todo-item {
  display: flex;
  align-items: center;
  background-color: #fff;
  padding: 1rem 1.5rem;
  border-radius: 0.5rem;
  box-shadow: var(--shadow);
  margin-bottom: 1rem;
}

.todo-item label {
  display: block;
  margin-right: 1rem;
  cursor: pointer;
}

.todo-item .todo-content {
  flex: 1 1 0%;
}

.todo-item .todo-content input {
  width: 100%;
}

.todo-description {
  color: var(--dark);
  font-size: 1.25rem;
}

.todo-due-date {
  color: var(--grey);
  font-weight: 600;
}

.todo-item .actions {
  display: flex;
  align-items: center;
}

.todo-item .actions button {
  display: block;
  padding: 0.5rem;
  border-radius: 0.25rem;
  color: #fff;
  cursor: pointer;
  transition: 0.2s ease-in-out;
}

.todo-item .actions button:hover {
  opacity: 0.75;
}

.todo-item .actions .edit {
  margin-right: 0.5rem;
  background-color: var(--primary);
}

.todo-item .actions .delete {
  background-color: var(--danger);
}

.todo-item.done .todo-content input {
  text-decoration: line-through;
  color: var(--grey);
}
</style>
