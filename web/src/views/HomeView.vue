<script setup>
import { directive as VueInputAutowidth } from "vue-input-autowidth";
</script>

<template>
  <main
    class="home flex h-screen justify-center bg-gradient-to-br from-green-500 to-cyan-400 transition-opacity duration-700 ease-in opacity-0 max-w-full overflow-hidden"
    :class="opacity"
  >
    <section class="my-auto text-center">
      <div
        class="mb-4 text-center px-10 absolute left-0 right-0 flex items-center justify-center"
      >
        <h1 class="text-4xl text-shadow font-black uppercase">Url shortener</h1>
      </div>

      <form class="align-middle">
        <label class="block mb-2 w-full mx-auto mt-16 text-center">
          <input
            type="text"
            id="link"
            :class="{
              'border-opacity-100': focused,
              'border-opacity-70': !focused,
            }"
            v-model="mainUrl"
            v-autowidth="{
              minWidth: '382px',
              maxWidth: '90%',
              comfortZone: '130px',
            }"
            @keyup="validate"
            @paste="validate"
            @focus="focused = true"
            @blur="focused = false"
            class="url border-b-white border-b-2 py-3 placeholder-white placeholder-opacity-70 text-2xl text-center w-full appearance-none bg-transparent w-full text-white leading-tight focus:outline-none"
            placeholder="Type or paste your link here"
          />
        </label>
      </form>
      <p
        :class="{ 'opacity-50': !isValid && mainUrl.length }"
        class="text-sm text-center transition-opacity opacity-0 absolute left-0 right-0"
      >
        This is not a valid url
      </p>

      <div class="absolute left-0 right-0">
        <button
          type="button"
          @click="short"
          :class="{
            'hidden-important opacity-0': !showButton,
            'opacity-100': showButton,
          }"
          class="button-30 mt-8 transition"
        >
          <svg
            :class="{ hidden: !isSubmitting }"
            class="w-4 h-4 mr-2 text-gray-200 animate-spin dark:text-gray-600"
            viewBox="0 0 100 101"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
              fill="currentColor"
            />
            <path
              d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
              fill="#22c665"
            />
          </svg>
          Shorten
        </button>
      </div>
      <div
        class="absolute left-0 right-0 transition"
        :class="{
          'hidden-important opacity-0': !showLinks,
          'opacity-100': showLinks,
        }"
      >
        <div class="text-xl mt-12 flex flex-col items-center">
          <strong class="text-shadow">Short url</strong>
          <div class="flex mt-2">
            {{ shortUrl }}
            <button
              type="button"
              class="ml-2"
              content="copied"
              v-tippy="{ trigger: 'click' }"
              v-clipboard:copy="shortUrl"
            >
              <svg
                class="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M8 7v8a2 2 0 002 2h6M8 7V5a2 2 0 012-2h4.586a1 1 0 01.707.293l4.414 4.414a1 1 0 01.293.707V15a2 2 0 01-2 2h-2M8 7H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2v-2"
                ></path>
              </svg>
            </button>
          </div>
        </div>
        <div class="text-xl mt-8 flex flex-col items-center">
          <strong
            class="items-center flex justify-center text-shadow"
            v-tippy="'On this page you can see the statistics of the link'"
            >Statistics url</strong
          >
          <div class="flex mt-2">
            {{ statisticsUrl }}
            <button
              type="button"
              class="ml-2"
              content="copied"
              v-tippy="{ trigger: 'click' }"
              v-clipboard:copy="statisticsUrl"
            >
              <svg
                class="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M8 7v8a2 2 0 002 2h6M8 7V5a2 2 0 012-2h4.586a1 1 0 01.707.293l4.414 4.414a1 1 0 01.293.707V15a2 2 0 01-2 2h-2M8 7H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2v-2"
                ></path>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>
<script>
import useVuelidate from "@vuelidate/core";
export default {
  directives: { autowidth: VueInputAutowidth },
  name: "HomeView",
  data: () => ({
  v$: useVuelidate(),
  mainUrl: "",
  focused: false,
  shortUrl: "",
  statisticsUrl: "",
  isValid: false,
  isSubmitting: false,
  wasSubmitted: false,
  showLinks: false,
  showButton: false,
  opacity: "",
}
),
  mounted() {
    setTimeout(() => {
      this.opacity = "opacity-100";
    }, 100);
    this.needToShowLinks();
    this.needToShowButton();
  },
  methods: {
    isUrl(str) {
      try {
        new URL(str);
        return true;
      } catch {
        return false;
      }
    },
    validate() {
      this.isValid = this.isUrl(this.mainUrl);
      this.wasSubmitted = false;
      this.needToShowLinks();
      this.needToShowButton();
    },
    short() {
      this.isSubmitting = true;
      setTimeout(() => {
        this.statisticsUrl =
          import.meta.env.VITE_APP_BASE_URL + "statistics/15asd35235";
        this.shortUrl = import.meta.env.VITE_APP_BASE_URL + "dagafdq234123";
        this.isSubmitting = false;
        this.wasSubmitted = true;
        this.needToShowButton();
        this.needToShowLinks();
      }, 1000);
    },
    needToShowLinks() {
      this.showLinks = this.shortUrl && this.isValid && this.wasSubmitted;
    },
    needToShowButton() {
      this.showButton = !this.wasSubmitted && this.isValid;
    },
  },
};
</script>

<style scoped>
.text-shadow {
  text-shadow: 0 2px 0 rgb(0 0 0 / 14%);
}
.url {
  min-height: 56px;
  transition: border-bottom ease-in-out 0.2s;
}

.hidden-important {
  visibility: hidden !important;
}

section {
  padding-bottom: 130px;
}

.button-30 {
  align-items: center;
  appearance: none;
  background-color: #fcfcfd;
  border-radius: 4px;
  border-width: 0;
  box-shadow: #d6d6e7 0 -3px 0 inset;
  box-sizing: border-box;
  color: #22c665;
  outline: none !important;
  cursor: pointer;
  display: inline-flex;
  height: 48px;
  max-width: 200px;
  justify-content: center;
  line-height: 1;
  list-style: none;
  overflow: hidden;
  padding-left: 16px;
  padding-right: 16px;
  text-align: left;
  text-decoration: none;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  white-space: nowrap;
  will-change: box-shadow, transform;
  font-size: 18px;
}

.button-30:hover {
  box-shadow: #d6d6e7 0 -2px 0 inset;
  transform: translateY(1px);
}

.button-30:active {
  box-shadow: #d6d6e7 0 1px 0 inset;
  transform: translateY(2px);
}
</style>
