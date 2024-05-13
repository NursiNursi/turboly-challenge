<template>
  <div class="list" id="todo-list">
    <div
      v-for="todo in filteredItems"
      :key="todo.id"
      :class="`todo-item ${todo.completed && 'done'}`"
    >
      <label>
        <input
          type="checkbox"
          :checked="todo.completed"
          @change="toggleTodoCompletion(todo)"
        />
        <span :class="`bubble ${priorityClass(todo.priority)}`"></span>
      </label>
      <div class="todo-content">
        <span
          class="badge rounded-pill"
          :class="priorityBadgeClass(todo.priority)"
        >
          {{ todo.priority }}
        </span>
        <input class="todo-description" type="text" v-model="todo.content" />
        <input
          class="todo-due-date"
          disabled
          type="text"
          v-model="todo.due_date"
        />
      </div>
      <div class="actions">
        <button class="delete" @click="removeTodo(todo)">Delete</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps, defineEmits, watch } from "vue";

const props = defineProps(["filteredItems"]);
const emits = defineEmits(["remove"]);

const priorityClass = (priority) =>
  ({
    low: "low",
    middle: "middle",
    high: "high",
  }[priority]);

const priorityBadgeClass = (priority) =>
  ({
    low: "bg-success",
    middle: "bg-warning",
    high: "bg-danger",
  }[priority]);

const toggleTodoCompletion = async (todo) => {
  try {
    const res = await fetch(`http://localhost:3000/todos/${todo.id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        completed: !todo.completed,
        id: todo.id,
      }),
    });

    const data = await res.json();
    console.log("Updated API for todo:", todo.id);

    todo.completed = !todo.completed; // Update local state
  } catch (error) {
    console.error("Failed to update API for todo:", todo.id, error);
  }
};

const removeTodo = (todo) => {
  emits("remove", todo);
};
</script>

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
