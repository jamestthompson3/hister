<script lang="ts">
  import '../app.css';
  import { afterNavigate } from '$app/navigation';
  import Header from '$lib/Header.svelte';
  import Footer from '$lib/Footer.svelte';

  let { children } = $props();

  afterNavigate(() => {
    const hash = window.location.hash;
    if (hash) {
      document.querySelector(hash)?.scrollIntoView({ behavior: 'smooth' });
    }
  });
</script>

<div class="min-h-screen flex flex-col bg-brutal-bg">
  <Header />
  <main class="flex-1">
    {@render children()}
  </main>
  <Footer />
</div>
