<script lang="ts">
  import { onMount } from 'svelte';
  import { fetchConfig, apiFetch } from '$lib/api';
  import type { HistoryItem } from '$lib/types';
  import { Button } from '@hister/components/ui/button';
  import { Input } from '@hister/components/ui/input';
  import { Badge } from '@hister/components/ui/badge';
  import { Separator } from '@hister/components/ui/separator';
  import { ScrollArea } from '@hister/components/ui/scroll-area';
  import { PageHeader } from '@hister/components';
  import { StatusMessage } from '$lib/components';
  import { Search, Clock, Trash2 } from 'lucide-svelte';

  let items: HistoryItem[] = $state([]);
  let loading = $state(true);
  let error = $state('');
  let filter = $state('');
  let activeGroup = $state('');
  let filterByDate = $state('');

  const groupColors = [
    'hister-indigo',
    'hister-coral',
    'hister-teal',
    'hister-amber',
    'hister-rose',
    'hister-cyan',
    'hister-lime',
  ];

  function getColorVar(color: string): string {
    return `var(--${color})`;
  }

  function formatDateLabel(dateStr: string): string {
    const date = new Date(dateStr);
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    const itemDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());

    if (itemDate.getTime() === today.getTime()) return 'Today';
    if (itemDate.getTime() === yesterday.getTime()) return 'Yesterday';
    return itemDate.toLocaleDateString('en-US', {
      weekday: 'short',
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  }

  function getDateKey(dateStr: string): string {
    const date = new Date(dateStr);
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  }

  const filteredItems = $derived.by(() => {
    let result = items;
    if (filter) {
      const f = filter.toLowerCase();
      result = result.filter(
        (item) =>
          item.query.toLowerCase().includes(f) ||
          item.title.toLowerCase().includes(f) ||
          item.url.toLowerCase().includes(f),
      );
    }
    if (filterByDate) {
      result = result.filter(
        (item) => item.updated_at && getDateKey(item.updated_at) === filterByDate,
      );
    }
    return result;
  });

  const allGroups = $derived.by(() => {
    const g: { key: string; label: string; items: HistoryItem[] }[] = [];
    const seen = new Map<string, number>();
    let baseItems = items;
    if (filter) {
      const f = filter.toLowerCase();
      baseItems = baseItems.filter(
        (item) =>
          item.query.toLowerCase().includes(f) ||
          item.title.toLowerCase().includes(f) ||
          item.url.toLowerCase().includes(f),
      );
    }
    for (const item of baseItems) {
      const key = item.updated_at ? getDateKey(item.updated_at) : 'unknown';
      const label = item.updated_at ? formatDateLabel(item.updated_at) : 'Unknown';
      if (seen.has(key)) {
        g[seen.get(key)!].items.push(item);
      } else {
        seen.set(key, g.length);
        g.push({ key, label, items: [item] });
      }
    }
    return g;
  });

  const groups = $derived.by(() => {
    const g: { key: string; label: string; items: HistoryItem[] }[] = [];
    const seen = new Map<string, number>();
    for (const item of filteredItems) {
      const key = item.updated_at ? getDateKey(item.updated_at) : 'unknown';
      const label = item.updated_at ? formatDateLabel(item.updated_at) : 'Unknown';
      if (seen.has(key)) {
        g[seen.get(key)!].items.push(item);
      } else {
        seen.set(key, g.length);
        g.push({ key, label, items: [item] });
      }
    }
    return g;
  });

  function getGroupColor(idx: number): string {
    return groupColors[idx % groupColors.length];
  }

  function scrollToGroup(key: string) {
    activeGroup = key;
    filterByDate = key;
  }

  function showAll() {
    filterByDate = '';
    activeGroup = groups.length > 0 ? groups[0].key : '';
  }

  async function deleteHistoryItem(item: HistoryItem) {
    try {
      await apiFetch('/history', {
        method: 'POST',
        headers: { 'Content-type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ url: item.url, title: item.title, query: item.query, delete: true }),
      });
      items = items.filter((i) => i.url !== item.url || i.query !== item.query);
    } catch (e) {
      error = String(e);
    }
  }

  async function deleteAllHistory() {
    if (!confirm('Delete all history? This cannot be undone.')) return;
    try {
      for (const item of items) {
        await apiFetch('/history', {
          method: 'POST',
          headers: { 'Content-type': 'application/json; charset=UTF-8' },
          body: JSON.stringify({
            url: item.url,
            title: item.title,
            query: item.query,
            delete: true,
          }),
        });
      }
      items = [];
    } catch (e) {
      error = String(e);
    }
  }

  onMount(async () => {
    try {
      await fetchConfig();
      const res = await apiFetch('/history', {
        headers: { Accept: 'application/json' },
      });
      if (!res.ok) throw new Error('Failed to load history');
      items = await res.json();
    } catch (e) {
      error = String(e);
    } finally {
      loading = false;
    }
  });
</script>

<svelte:head>
  <title>Hister - History</title>
</svelte:head>

<header
  class="bg-card-surface border-brutal-border flex shrink-0 items-center justify-between gap-2 overflow-hidden border-b-[3px] px-3 py-3 md:px-6"
>
  <PageHeader color="hister-indigo" size="xs" class="min-w-0 shrink-0" truncate
    >Search History</PageHeader
  >
  <nav class="flex min-w-0 shrink-0 items-center gap-2 md:gap-3">
    <div
      class="border-brutal-border bg-page-bg flex h-8 min-w-0 items-center gap-2 border-[3px] px-2 md:px-3"
    >
      <Search class="text-text-brand-muted size-3.5 shrink-0" />
      <Input
        bind:value={filter}
        placeholder="Filter..."
        class="font-inter text-text-brand placeholder:text-text-brand-muted h-full w-20 border-0 bg-transparent p-0 text-xs font-medium shadow-none focus-visible:ring-0 md:w-40"
      />
    </div>
    {#if items.length > 0}
      <Button
        variant="outline"
        size="sm"
        class="border-hister-rose text-hister-rose hover:bg-hister-rose/10 font-inter brutal-press h-8 shrink-0 gap-1.5 border-[3px] text-xs font-semibold"
        onclick={deleteAllHistory}
      >
        <Trash2 class="size-3.5" />
        <span class="hidden md:inline">Delete All</span>
      </Button>
    {/if}
  </nav>
</header>

{#if loading}
  <StatusMessage message="Loading history..." type="loading" />
{:else if error}
  <StatusMessage message={error} type="error" class="mx-3 mt-4 md:mx-6" />
{:else if filteredItems.length === 0}
  <StatusMessage message={filter ? 'No matching entries' : 'No history yet'} type="empty" />
{:else}
  <div class="flex min-h-0 flex-1 flex-col overflow-hidden md:flex-row">
    <!-- Timeline sidebar: hidden on mobile, shown on md+ -->
    <ScrollArea class="border-brutal-border hidden w-70 shrink-0 border-r-[3px] pt-5 pr-3 md:block">
      <div class="space-y-1">
        <span
          class="font-space text-text-brand-muted flex items-center gap-1.5 px-2.5 text-xs font-bold tracking-[2px] uppercase"
        >
          <Clock class="size-3" />
          Timeline
        </span>
        <Separator class="bg-border-brand-muted" />

        <Button
          variant="ghost"
          class="flex h-auto w-full items-center justify-start gap-2 rounded-none px-2.5 py-1.5 {!filterByDate
            ? 'bg-hister-indigo text-white hover:bg-(--hister-indigo)/90 hover:text-white'
            : 'hover:bg-muted-surface'}"
          onclick={showAll}
        >
          <span
            class="font-inter text-sm font-semibold"
            class:text-text-brand-secondary={!!filterByDate}
          >
            Show All
          </span>
          <Badge
            variant="secondary"
            class="ml-auto h-4 shrink-0 border-0 px-1.5 py-0 text-xs {filterByDate
              ? 'bg-muted-surface text-text-brand-muted'
              : 'bg-white/20 text-white'}"
          >
            {filteredItems.length}
          </Badge>
        </Button>

        <Separator class="bg-border-brand-muted" />

        {#each allGroups as group, i}
          {@const color = getGroupColor(i)}
          {@const isActive = filterByDate === group.key}
          <Button
            variant="ghost"
            class="flex h-auto w-full items-center justify-start gap-2 rounded-none px-2.5 py-1.5 {isActive
              ? 'text-white hover:text-white'
              : 'hover:bg-muted-surface'}"
            style={isActive ? `background-color: ${getColorVar(color)};` : ''}
            onclick={() => scrollToGroup(group.key)}
          >
            <span
              class="h-2 w-2 shrink-0 rounded-full"
              style={isActive
                ? 'background-color: white;'
                : `background-color: ${getColorVar(color)};`}
            ></span>
            <span
              class="font-inter truncate text-sm"
              class:font-semibold={isActive}
              class:font-medium={!isActive}
              class:text-text-brand-secondary={!isActive}
            >
              {group.label}
            </span>
            <Badge
              variant="secondary"
              class="ml-auto h-4 shrink-0 border-0 px-1.5 py-0 text-xs {isActive
                ? 'bg-white/20 text-white'
                : 'bg-muted-surface text-text-brand-muted'}"
            >
              {group.items.length}
            </Badge>
          </Button>
        {/each}
      </div>
    </ScrollArea>

    <!-- Mobile timeline: horizontal scrollable filter chips -->
    <div
      class="border-brutal-border bg-card-surface flex shrink-0 items-center gap-2 overflow-x-auto border-b-[3px] px-4 py-2 md:hidden"
    >
      <Button
        variant="ghost"
        size="sm"
        class="font-inter h-7 shrink-0 rounded-none px-2.5 text-xs font-semibold {!filterByDate
          ? 'bg-hister-indigo hover:bg-hister-indigo/90 text-white hover:text-white'
          : 'text-text-brand-secondary hover:bg-muted-surface'}"
        onclick={showAll}
      >
        All ({filteredItems.length})
      </Button>
      {#each allGroups as group, i}
        {@const color = getGroupColor(i)}
        {@const isActive = filterByDate === group.key}
        <Button
          variant="ghost"
          size="sm"
          class="font-inter h-7 shrink-0 rounded-none px-2.5 text-xs font-medium {isActive
            ? 'text-white hover:text-white'
            : 'text-text-brand-secondary hover:bg-muted-surface'}"
          style={isActive ? `background-color: ${getColorVar(color)};` : ''}
          onclick={() => scrollToGroup(group.key)}
        >
          {group.label} ({group.items.length})
        </Button>
      {/each}
    </div>

    <ScrollArea orientation="vertical" class="min-h-0 max-w-full min-w-0 flex-1 overflow-x-hidden">
      <div class="w-full space-y-4 overflow-hidden px-3 py-3 md:space-y-6 md:px-6 md:py-5">
        {#each groups as group, gi}
          {@const color = getGroupColor(gi)}
          <div id="group-{encodeURIComponent(group.key)}" class="space-y-2">
            <span class="font-outfit text-sm font-bold" style="color: {getColorVar(color)};"
              >{group.label}</span
            >
            <Separator class="h-0.5" style="background-color: {getColorVar(color)};" />

            <div class="space-y-0">
              {#each group.items as item, ii}
                {@const itemColor = getGroupColor(gi + ii)}
                <article
                  class="bg-card-surface border-b-brutal-border flex items-start gap-2 overflow-hidden border-b-[3px] px-2.5 py-2 md:items-center md:gap-3 md:px-3.5 md:py-2.5"
                  style="border-left: 3px solid {getColorVar(itemColor)};"
                >
                  <div class="w-0 min-w-0 flex-1 space-y-0.5">
                    <a
                      href={item.url}
                      class="font-outfit block truncate text-sm font-bold no-underline hover:underline md:text-base"
                      style="color: {getColorVar(itemColor)};"
                      target="_blank"
                      rel="noopener"
                    >
                      {(item.title || item.url).replace(/<[^>]*>/g, '')}
                    </a>
                    <span
                      class="font-fira text-text-brand-muted block truncate text-xs md:text-sm"
                      title={item.url}>{item.url}</span
                    >
                  </div>
                  <nav class="flex shrink-0 items-center gap-1">
                    <Button
                      variant="ghost"
                      size="sm"
                      class="font-inter text-text-brand-muted hover:text-hister-indigo h-7 shrink-0 gap-1 px-1.5 text-xs no-underline md:px-2"
                      href="/?q={encodeURIComponent(item.query)}"
                    >
                      <Search class="size-3" />
                      <span class="hidden md:inline">Search</span>
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon-sm"
                      class="text-text-brand-muted hover:text-hister-rose size-7 shrink-0"
                      onclick={() => deleteHistoryItem(item)}
                    >
                      <Trash2 class="size-3.5" />
                    </Button>
                  </nav>
                </article>
              {/each}
            </div>
          </div>
        {/each}
      </div>
    </ScrollArea>
  </div>
{/if}
