<script setup>
import { ref, onMounted, computed, watch } from "vue";
import SearchForm from "./SearchForm.vue";

const todos = ref([]);
const name = ref("");
const searchFilter = ref("");
const sort = ref("");
const showCreate = ref(false);

const descriptionSort = ref(false);
const dateSort = ref(false);
const prioritySort = ref(false);
const completionSort = ref(false);

const input_content = ref("");
const input_dueDate = ref("");
const input_priority = ref(null);

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

const filteredItems = computed(() => {
  let items = todos.value;

  if (searchFilter.value !== "") {
    items = items.filter((item) =>
      item.content.toLowerCase().includes(searchFilter.value)
    );
  }

  switch (sort.value) {
    case "content":
      items.sort((a, b) => {
        if (descriptionSort.value) {
          return a.content.localeCompare(b.content);
        } else {
          return b.content.localeCompare(a.content);
        }
      });
      break;
    case "date":
      items.sort((a, b) => {
        if (dateSort.value) {
          const dateA = new Date(a.dueDate);
          const dateB = new Date(b.dueDate);

          return dateA - dateB;
        } else {
          const dateA = new Date(a.dueDate);
          const dateB = new Date(b.dueDate);

          return dateB - dateA;
        }
      });
      break;
    case "priority":
      items.sort((a, b) => {
        if (prioritySort.value) {
          const priorityOrder = { high: 1, middle: 2, low: 3 };
          const priorityA = priorityOrder[a.priority];
          const priorityB = priorityOrder[b.priority];

          return priorityA - priorityB;
        } else {
          const priorityOrder = { high: 1, middle: 2, low: 3 };
          const priorityA = priorityOrder[a.priority];
          const priorityB = priorityOrder[b.priority];

          return priorityB - priorityA;
        }
      });
      break;
    case "completion":
      items.sort((a, b) => {
        if (completionSort.value) {
          if (a.done && !b.done) {
            return -1;
          } else if (!a.done && b.done) {
            return 1;
          } else {
            return 0;
          }
        } else {
          if (a.done && !b.done) {
            return 1;
          } else if (!a.done && b.done) {
            return -1;
          } else {
            return 0;
          }
        }
      });
      break;
    default:
  }
  return items;
});

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

  showCreate.value = false;
};

const handleSearch = (search) => {
  searchFilter.value = search;
};

const removeTodo = (todo) => {
  todos.value = todos.value.filter((t) => t !== todo);
};

const handleSortDescription = () => {
  sort.value = "content";
  descriptionSort.value = !descriptionSort.value;
};

const handleSortDate = () => {
  sort.value = "date";
  dateSort.value = !dateSort.value;
};

const handleSortPriority = () => {
  sort.value = "priority";
  prioritySort.value = !prioritySort.value;
};

const handleSortCompletion = () => {
  sort.value = "completion";
  completionSort.value = !completionSort.value;
};

onMounted(() => {
  name.value = localStorage.getItem("name") || "";
  todos.value = JSON.parse(localStorage.getItem("todos")) || [];
});
</script>

<template>
  <main class="app">
    <section class="todo-list">
      <h1 class="display-5 fw-bold mb-4">TODO LIST</h1>
      <div class="d-flex justify-content-between head-row">
        <SearchForm @search="handleSearch" />
        <div class="sort-by">
          <button
            @click="handleSortDescription"
            type="button"
            class="btn btn-secondary"
          >
            Description
            <svg
              v-if="descriptionSort"
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="currentColor"
              class="bi bi-sort-down"
              viewBox="0 0 16 16"
            >
              <path
                d="M3.5 2.5a.5.5 0 0 0-1 0v8.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L3.5 11.293zm3.5 1a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"
              />
            </svg>
            <svg
              v-else
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="currentColor"
              class="bi bi-sort-up"
              viewBox="0 0 16 16"
            >
              <path
                d="M3.5 12.5a.5.5 0 0 1-1 0V3.707L1.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.5.5 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L3.5 3.707zm3.5-9a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"
              />
            </svg>
          </button>

          <button
            @click="handleSortDate"
            type="button"
            class="btn btn-secondary"
          >
            Date
            <svg
              v-if="dateSort"
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="currentColor"
              class="bi bi-sort-down"
              viewBox="0 0 16 16"
            >
              <path
                d="M3.5 2.5a.5.5 0 0 0-1 0v8.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L3.5 11.293zm3.5 1a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"
              />
            </svg>
            <svg
              v-else
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="currentColor"
              class="bi bi-sort-up"
              viewBox="0 0 16 16"
            >
              <path
                d="M3.5 12.5a.5.5 0 0 1-1 0V3.707L1.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.5.5 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L3.5 3.707zm3.5-9a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"
              />
            </svg>
          </button>
          <button
            @click="handleSortPriority"
            type="button"
            class="btn btn-secondary"
          >
            Priority
            <svg
              v-if="prioritySort"
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="currentColor"
              class="bi bi-sort-down"
              viewBox="0 0 16 16"
            >
              <path
                d="M3.5 2.5a.5.5 0 0 0-1 0v8.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L3.5 11.293zm3.5 1a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"
              />
            </svg>
            <svg
              v-else
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="currentColor"
              class="bi bi-sort-up"
              viewBox="0 0 16 16"
            >
              <path
                d="M3.5 12.5a.5.5 0 0 1-1 0V3.707L1.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.5.5 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L3.5 3.707zm3.5-9a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"
              />
            </svg>
          </button>
          <button
            @click="handleSortCompletion"
            type="button"
            class="btn btn-secondary"
          >
            Completion
            <svg
              v-if="completionSort"
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="currentColor"
              class="bi bi-sort-down"
              viewBox="0 0 16 16"
            >
              <path
                d="M3.5 2.5a.5.5 0 0 0-1 0v8.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L3.5 11.293zm3.5 1a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"
              />
            </svg>
            <svg
              v-else
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="currentColor"
              class="bi bi-sort-up"
              viewBox="0 0 16 16"
            >
              <path
                d="M3.5 12.5a.5.5 0 0 1-1 0V3.707L1.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.5.5 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L3.5 3.707zm3.5-9a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"
              />
            </svg>
          </button>
        </div>
      </div>
      <div class="list" id="todo-list">
        <div
          v-for="todo in filteredItems"
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
            <span
              class="badge rounded-pill"
              :class="
                todo.priority === 'high'
                  ? 'bg-danger'
                  : todo.priority === 'middle'
                  ? 'bg-warning'
                  : 'bg-success'
              "
              >{{ todo.priority }}</span
            >

            <input
              class="todo-description"
              type="text"
              v-model="todo.content"
            />
            <input
              class="todo-due-date"
              disabled
              type="text"
              v-model="todo.dueDate"
            />
          </div>

          <div class="actions">
            <button class="delete" @click="removeTodo(todo)">Delete</button>
          </div>
        </div>
      </div>
    </section>

    <section v-if="showCreate" class="create-todo">
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
    <section v-if="!showCreate">
      <button class="create-new-todo" @click="showCreate = !showCreate">
        Add new todo
      </button>
    </section>
  </main>
</template>
