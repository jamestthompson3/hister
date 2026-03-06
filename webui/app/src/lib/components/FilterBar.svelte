<script lang="ts">
  import { Search } from 'lucide-svelte';
  import { Input } from '@hister/components/ui/input';

  let {
    value = $bindable(''),
    placeholder = 'Filter...',
  }: {
    value?: string;
    placeholder?: string;
  } = $props();
</script>

<div class="bg-card-surface border-brutal-border flex h-11 items-center gap-3 border-b-[3px] px-4">
  <Search class="text-text-brand-muted size-4 shrink-0" />
  <Input
    bind:value
    {placeholder}
    class="font-inter text-text-brand placeholder:text-text-brand-muted h-full flex-1 border-0 bg-transparent p-0 text-sm font-medium shadow-none focus-visible:ring-0"
  />
</div>
