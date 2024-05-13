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

  // Convert the dueDate to ISO string format
  const dueDateISO = new Date(input_dueDate.value).toISOString();

  emits("addTodo", {
    content: input_content.value,
    dueDate: dueDateISO,
    priority: input_priority.value,
  });

  input_content.value = "";
  input_dueDate.value = "";
  input_priority.value = null;
};
</script>

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

.create-todo .options label div {
  color: var(--dark);
  font-size: 1.125rem;
  margin-top: 1rem;
}

.create-todo input[type="submit"] {
  display: block;
  width: 100%;
  font-size: 1.125rem;
  padding: 1rem 1.5rem;
  color: #fff;
  background-color: var(--primary);
  border-radius: 0.5rem;
  box-shadow: var(--middle-glow);
  cursor: pointer;
  transition: 0.2s ease-in-out;
}

.create-todo input[type="submit"]:hover {
  opacity: 0.75;
}

.create-todo input[type="text"],
.create-todo input[type="date"] {
  display: block;
  width: 100%;
  font-size: 1.125rem;
  padding: 1rem 1.5rem;
  color: var(--dark);
  background-color: #fff;
  border-radius: 0.5rem;
  box-shadow: var(--shadow);
  margin-bottom: 1.5rem;
}

.create-todo .options {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-gap: 1rem;
  margin-bottom: 1.5rem;
}

.create-todo .options label {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1.5rem;
  background-color: #fff;
  border-radius: 0.5rem;
  box-shadow: var(--shadow);
  cursor: pointer;
}
</style>
