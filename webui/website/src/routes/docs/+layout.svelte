<script lang="ts">
  import { page } from '$app/state';

  let { children, data } = $props();
</script>

<div class="max-w-7xl mx-auto px-6 md:px-12 py-12 flex flex-col md:flex-row gap-10">
  <aside class="md:w-56 shrink-0">
    <nav class="md:sticky md:top-24 flex flex-col gap-1">
      <span class="font-space text-[11px] font-bold tracking-[2px] text-[var(--text-secondary)] mb-3">DOCUMENTATION</span>
      {#each data.docs as doc}
        <a
          href="/docs/{doc.slug}"
          class="font-inter text-sm py-2 px-3 no-underline border-l-[3px] transition-colors {page.url.pathname === `/docs/${doc.slug}`
            ? 'border-hister-indigo text-[var(--text-primary)] font-semibold bg-hister-indigo/5'
            : 'border-transparent text-[var(--text-secondary)] hover:text-[var(--text-primary)] hover:border-brutal-border'}"
        >
          {doc.title}
        </a>
      {/each}
    </nav>
  </aside>

  <main class="flex-1 min-w-0">
    {@render children()}
  </main>
</div>
