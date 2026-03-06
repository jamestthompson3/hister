<script lang="ts">
  import { page } from '$app/state';
  import Github from '@lucide/svelte/icons/github';
  import Menu from '@lucide/svelte/icons/menu';
  import X from '@lucide/svelte/icons/x';
  import { Button } from '@hister/components';

  let menuOpen = $state(false);

  const links = [
    { href: '/', label: 'HOME' },
    { href: '/docs', label: 'DOCS' },
    { href: '/posts', label: 'POSTS' },
  ];

  function isActive(href: string): boolean {
    if (href === '/') return page.url.pathname === '/';
    return page.url.pathname.startsWith(href);
  }
</script>

<header class="bg-brutal-bg border-brutal-border sticky top-0 z-50 w-full border-b-[3px]">
  <nav class="flex items-center justify-between px-6 py-4 md:px-12">
    <a
      href="/"
      class="font-space text-[28px] font-extrabold tracking-[2px] text-[var(--text-primary)] no-underline"
    >
      HISTER
    </a>

    <ul class="m-0 hidden list-none items-center gap-8 p-0 md:flex">
      {#each links as link}
        <li>
          <a
            href={link.href}
            class="font-space text-[13px] font-semibold tracking-[1.5px] no-underline transition-colors {isActive(
              link.href,
            )
              ? 'text-[var(--text-primary)]'
              : 'text-[var(--text-secondary)] hover:text-[var(--text-primary)]'}"
          >
            {link.label}
          </a>
        </li>
      {/each}
    </ul>

    <div class="hidden items-center gap-4 md:flex">
      <Button
        href="https://github.com/asciimoo/hister"
        target="_blank"
        rel="noopener noreferrer"
        class="bg-hister-indigo font-space border-brutal-border h-auto rounded-none border-[3px] px-5 py-2.5 text-[13px] font-semibold tracking-[1px] text-white no-underline shadow-[3px_3px_0_rgba(0,0,0,0.25)] transition-all hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-[1px_1px_0_rgba(0,0,0,0.25)]"
      >
        <Github size={18} />
        GITHUB
      </Button>
    </div>

    <button class="p-2 md:hidden" onclick={() => (menuOpen = !menuOpen)} aria-label="Toggle menu">
      {#if menuOpen}
        <X size={24} />
      {:else}
        <Menu size={24} />
      {/if}
    </button>
  </nav>

  {#if menuOpen}
    <ul
      class="border-brutal-border bg-brutal-bg m-0 flex list-none flex-col gap-4 border-t-[2px] px-6 py-4 md:hidden"
    >
      {#each links as link}
        <li>
          <a
            href={link.href}
            class="font-space text-[15px] font-semibold tracking-[1.5px] no-underline {isActive(
              link.href,
            )
              ? 'text-[var(--text-primary)]'
              : 'text-[var(--text-secondary)]'}"
            onclick={() => (menuOpen = false)}
          >
            {link.label}
          </a>
        </li>
      {/each}
      <li>
        <Button
          href="https://github.com/asciimoo/hister"
          target="_blank"
          rel="noopener noreferrer"
          class="bg-hister-indigo font-space border-brutal-border h-auto w-fit rounded-none border-[3px] px-5 py-2.5 text-[13px] font-semibold tracking-[1px] text-white no-underline shadow-[3px_3px_0_rgba(0,0,0,0.25)]"
        >
          <Github size={18} />
          GITHUB
        </Button>
      </li>
    </ul>
  {/if}
</header>
