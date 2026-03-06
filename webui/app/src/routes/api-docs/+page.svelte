<script lang="ts">
  import { onMount } from 'svelte';
  import { apiFetch } from '$lib/api';
  import { Badge } from '@hister/components/ui/badge';
  import * as Card from '@hister/components/ui/card';
  import * as Table from '@hister/components/ui/table';
  import { PageHeader } from '@hister/components';

  interface EndpointArg {
    name: string;
    type: string;
    required: boolean;
    description: string;
  }

  interface APIEndpoint {
    name: string;
    path: string;
    method: string;
    csrf_required: boolean;
    description: string;
    args: EndpointArg[] | null;
  }

  let endpoints: APIEndpoint[] = $state([]);
  let loading = $state(true);

  onMount(async () => {
    try {
      const res = await apiFetch('', {
        headers: { Accept: 'application/json' },
      });
      if (res.ok) endpoints = await res.json();
    } finally {
      loading = false;
    }
  });
</script>

<svelte:head>
  <title>Hister - API</title>
</svelte:head>

<div class="flex-1 overflow-y-auto px-3 py-4 md:px-6 md:py-5">
  <div class="mx-auto max-w-4xl space-y-4 md:space-y-5">
    <div class="space-y-1">
      <PageHeader color="hister-teal" size="sm">API Documentation</PageHeader>
      <p class="font-inter text-text-brand-secondary text-xs md:text-sm">
        Available HTTP endpoints for integrating with Hister
      </p>
    </div>

    {#if loading}
      <p class="font-inter text-text-brand-muted py-8 text-center text-sm">Loading endpoints...</p>
    {:else}
      <div class="space-y-4">
        {#each endpoints as ep}
          <Card.Root
            class="bg-card-surface gap-0 overflow-hidden rounded-none border border-black py-0 shadow-[4px_4px_0_var(--brutal-shadow)]"
          >
            <Card.Header class="gap-1 px-4 py-3">
              <div class="flex flex-wrap items-center gap-2.5">
                <Card.Title class="font-outfit text-text-brand text-base font-bold md:text-xl"
                  >{ep.name}</Card.Title
                >
                <Badge
                  variant="default"
                  class="border-0 px-2 py-0 text-[11px] leading-5 font-bold {ep.method === 'GET'
                    ? 'bg-hister-teal text-white'
                    : 'bg-hister-coral text-white'}"
                >
                  {ep.method}
                </Badge>
                <code class="font-fira text-text-brand-secondary text-sm">{ep.path}</code>
                {#if ep.csrf_required}
                  <Badge
                    variant="outline"
                    class="border-hister-amber text-hister-amber border-2 px-1.5 py-0 text-[10px] leading-5 font-semibold"
                  >
                    CSRF
                  </Badge>
                {/if}
              </div>
              <Card.Description class="font-inter text-text-brand-secondary text-sm"
                >{ep.description}</Card.Description
              >
            </Card.Header>

            {#if ep.args && ep.args.length > 0}
              <Card.Content class="border-t px-4 py-3">
                <h4
                  class="font-outfit text-text-brand-muted mb-2 text-xs font-bold tracking-wider uppercase"
                >
                  Arguments
                </h4>
                <div class="hidden md:block">
                  <Table.Root>
                    <Table.Header>
                      <Table.Row
                        class="bg-muted-surface border-brutal-border hover:bg-muted-surface border-b"
                      >
                        <Table.Head
                          class="font-inter text-text-brand-muted h-auto px-3 py-2 text-xs font-bold"
                          >Name</Table.Head
                        >
                        <Table.Head
                          class="font-inter text-text-brand-muted h-auto px-3 py-2 text-xs font-bold"
                          >Type</Table.Head
                        >
                        <Table.Head
                          class="font-inter text-text-brand-muted h-auto px-3 py-2 text-xs font-bold"
                          >Required</Table.Head
                        >
                        <Table.Head
                          class="font-inter text-text-brand-muted h-auto px-3 py-2 text-xs font-bold"
                          >Description</Table.Head
                        >
                      </Table.Row>
                    </Table.Header>
                    <Table.Body>
                      {#each ep.args as arg}
                        <Table.Row class="border-brutal-border/30 border-b">
                          <Table.Cell
                            class="font-fira text-text-brand px-3 py-2 text-sm font-semibold"
                            ><code>{arg.name}</code></Table.Cell
                          >
                          <Table.Cell class="font-fira text-text-brand-secondary px-3 py-2 text-sm"
                            ><code>{arg.type}</code></Table.Cell
                          >
                          <Table.Cell class="px-3 py-2">
                            {#if arg.required}
                              <Badge
                                variant="default"
                                class="bg-hister-rose border-0 px-1.5 py-0 text-[10px] text-white"
                                >required</Badge
                              >
                            {:else}
                              <span class="font-inter text-text-brand-muted text-xs">optional</span>
                            {/if}
                          </Table.Cell>
                          <Table.Cell class="font-inter text-text-brand-secondary px-3 py-2 text-sm"
                            >{arg.description}</Table.Cell
                          >
                        </Table.Row>
                      {/each}
                    </Table.Body>
                  </Table.Root>
                </div>
                <div class="space-y-2.5 md:hidden">
                  {#each ep.args as arg}
                    <div class="space-y-0.5">
                      <div class="flex items-center gap-2">
                        <code class="font-fira text-text-brand text-sm font-semibold"
                          >{arg.name}</code
                        >
                        <code class="font-fira text-text-brand-muted text-xs">{arg.type}</code>
                        {#if arg.required}
                          <Badge
                            variant="default"
                            class="bg-hister-rose border-0 px-1.5 py-0 text-[10px] text-white"
                            >required</Badge
                          >
                        {/if}
                      </div>
                      <p class="font-inter text-text-brand-secondary text-xs">{arg.description}</p>
                    </div>
                  {/each}
                </div>
              </Card.Content>
            {:else}
              <Card.Content class="border-brutal-border border-t px-4 py-3">
                <p class="font-inter text-text-brand-muted text-xs">No arguments</p>
              </Card.Content>
            {/if}
          </Card.Root>
        {/each}
      </div>
    {/if}
  </div>
</div>
