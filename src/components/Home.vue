<script setup>
import { ref, onMounted, computed, watch } from "vue";

const todos = ref([]);
const name = ref("");

const input_content = ref("");
const input_dueDate = ref("");
const input_priority = ref(null);

const todos_asc = computed(() =>
  todos.value.sort((a, b) => {
    return b.createdAt - a.createdAt;
  })
);

watch(name, (newVal) => {
  localStorage.setItem("name", newVal);
});

watch(
  todos,
  (newVal) => {
    localStorage.setItem("todos", JSON.stringify(newVal));
  },
  {
    deep: true,
  }
);

const addTodo = () => {
  if (input_content.value.trim() === "" || input_priority.value === null) {
    return;
  }

  todos.value.push({
    content: input_content.value,
    dueDate: input_dueDate.value,
    priority: input_priority.value,
    done: false,
    editable: false,
    createdAt: new Date().getTime(),
  });
};

const removeTodo = (todo) => {
  todos.value = todos.value.filter((t) => t !== todo);
};

onMounted(() => {
  name.value = localStorage.getItem("name") || "";
  todos.value = JSON.parse(localStorage.getItem("todos")) || [];
});
</script>

<template>
  <main class="app">
    <section class="greeting">
      <h2 class="title">
        What's up,
        <input type="text" id="name" placeholder="Name here" v-model="name" />
      </h2>
    </section>

    <section class="create-todo">
      <h3>CREATE A TODO</h3>

      <form id="new-todo-form" @submit.prevent="addTodo">
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
          name="content"
          id="content"
          placeholder="Enter Due Date"
          v-model="input_dueDate"
        />

        <h4>Priorities</h4>
        <div class="options">
          <label>
            <input
              type="radio"
              name="priority"
              id="priority1"
              value="low"
              v-model="input_priority"
            />
            <span class="bubble low"></span>
            <div>Low</div>
          </label>

          <label>
            <input
              type="radio"
              name="priority"
              id="priority2"
              value="middle"
              v-model="input_priority"
            />
            <span class="bubble middle"></span>
            <div>Middle</div>
          </label>

          <label>
            <input
              type="radio"
              name="priority"
              id="priority2"
              value="high"
              v-model="input_priority"
            />
            <span class="bubble high"></span>
            <div>High</div>
          </label>
        </div>

        <input type="submit" value="Add todo" />
      </form>
    </section>

    <section class="todo-list">
      <h3>TODO LIST</h3>
      <div class="list" id="todo-list">
        <div
          v-for="todo in todos_asc"
          :class="`todo-item ${todo.done && 'done'}`"
        >
          <label>
            <input type="checkbox" v-model="todo.done" />
            <span
              :class="`bubble ${
                todo.priority == 'low'
                  ? 'low'
                  : todo.priority == 'middle'
                  ? 'middle'
                  : 'high'
              }`"
            ></span>
          </label>

          <div class="todo-content">
            <input type="text" v-model="todo.content" />
            <input type="text" v-model="todo.dueDate" />
          </div>

          <div class="actions">
            <button class="delete" @click="removeTodo(todo)">Delete</button>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>
