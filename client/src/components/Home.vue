<script setup>
import { ref, onMounted, computed } from "vue";
import SearchForm from "./SearchForm.vue";
import SortButtons from "./SortButtons.vue";
import List from "./List.vue";
import CreateTodoForm from "./CreateTodoForm.vue";

const todos = ref([]);
const searchFilter = ref("");
const sort = ref("");
const showCreate = ref(false);

const API_URL = "http://localhost:3000/todos";

const descriptionSort = ref(false);
const dateSort = ref(false);
const prioritySort = ref(false);
const completionSort = ref(false);

const priorityLevels = {
  low: 3,
  middle: 2,
  high: 1,
};

onMounted(async () => {
  const res = await fetch(API_URL);
  todos.value = await res.json();

  console.log(todos.value);
});

const filteredItems = computed(() => {
  let items = [...todos.value];

  if (searchFilter.value !== "") {
    items = items.filter((item) =>
      item.content.toLowerCase().includes(searchFilter.value)
    );
  }

  switch (sort.value) {
    case "content":
      items.sort(
        (a, b) =>
          a.content.localeCompare(b.content) * (descriptionSort.value ? 1 : -1)
      );
      break;
    case "date":
      items.sort(
        (a, b) =>
          (new Date(a.due_date) - new Date(b.due_date)) *
          (dateSort.value ? 1 : -1)
      );
      break;
    case "priority":
      items.sort(
        (a, b) =>
          (priorityLevels[a.priority] - priorityLevels[b.priority]) *
          (prioritySort.value ? 1 : -1)
      );
      break;
    case "completion":
      items.sort(
        (a, b) => (a.completed - b.completed) * (completionSort.value ? 1 : -1)
      );
      break;
    default:
  }
  return items;
});

const handleAddTodo = async (todo) => {
  console.log(todo);
  const res = await fetch(API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      content: todo.content,
      due_date: todo.dueDate,
      priority: todo.priority,
      completed: todo.completed,
    }),
  });

  const data = await res.json();

  todos.value.push(data);
  showCreate.value = false;
};

const removeTodo = async (todo) => {
  await fetch(`${API_URL}/${todo.id}`, {
    method: "DELETE",
  });
  todos.value = todos.value.filter((t) => t !== todo);
};

const handleSearch = (search) => {
  searchFilter.value = search;
};

const handleSort = (type) => {
  if (sort.value === type) {
    switch (type) {
      case "content":
        descriptionSort.value = !descriptionSort.value;
        break;
      case "date":
        dateSort.value = !dateSort.value;
        break;
      case "priority":
        prioritySort.value = !prioritySort.value;
        break;
      case "completion":
        completionSort.value = !completionSort.value;
        break;
    }
  } else {
    sort.value = type;
    descriptionSort.value =
      dateSort.value =
      prioritySort.value =
      completionSort.value =
        false;
    switch (type) {
      case "content":
        descriptionSort.value = true;
        break;
      case "date":
        dateSort.value = true;
        break;
      case "priority":
        prioritySort.value = true;
        break;
      case "completion":
        completionSort.value = true;
        break;
    }
  }
};
</script>

<template>
  <main class="app">
    <section class="todo-list">
      <h1 class="display-5 fw-bold mb-4">TODO LIST</h1>
      <div class="d-flex justify-content-between head-row">
        <SearchForm @search="handleSearch" />
        <SortButtons
          @sort="handleSort"
          :descriptionSort="descriptionSort"
          :dateSort="dateSort"
          :prioritySort="prioritySort"
          :completionSort="completionSort"
        />
      </div>

      <List :filteredItems="filteredItems" @remove="removeTodo" />
    </section>

    <section v-if="showCreate" class="create-todo">
      <CreateTodoForm @addTodo="handleAddTodo" />
    </section>

    <section v-if="!showCreate">
      <button class="create-new-todo" @click="showCreate = !showCreate">
        Add new todo
      </button>
    </section>
  </main>
</template>
