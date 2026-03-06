<script lang="ts">
  import { Button } from '@hister/components/ui/button';
  import { Input } from '@hister/components/ui/input';
  import * as Card from '@hister/components/ui/card';
  import { Lock } from 'lucide-svelte';

  let token = $state('');

  function handleSave() {
    localStorage.setItem('access-token', token);
    window.location.href = '/';
  }

  function handleKeydown(e: KeyboardEvent) {
    if (e.key === 'Enter') {
      handleSave();
    }
  }
</script>

<svelte:head>
  <title>Authentication - Hister</title>
</svelte:head>

<div class="bg-brutal-bg flex min-h-screen items-center justify-center p-4">
  <Card.Root class="w-full max-w-md shadow-[8px_8px_0px_var(--hister-indigo)]">
    <Card.Header
      class="border-border-brand-muted flex-col space-y-4 border-b-[3px] pb-6 text-center"
    >
      <div class="flex justify-center">
        <div
          class="flex size-16 items-center justify-center rounded-full border-[3px]"
          style="background-color: color-mix(in srgb, var(--hister-indigo) 10%, transparent); border-color: var(--hister-indigo);"
        >
          <Lock class="text-hister-indigo size-8" />
        </div>
      </div>
      <Card.Title
        class="font-outfit text-text-brand text-2xl font-extrabold tracking-wide uppercase"
      >
        Authentication Required
      </Card.Title>
      <Card.Description class="font-inter text-text-brand-secondary">
        Please enter your access token.
      </Card.Description>
    </Card.Header>
    <Card.Content class="space-y-6">
      <div class="space-y-2">
        <label
          for="token"
          class="font-space text-text-brand text-sm font-semibold tracking-wider uppercase"
        >
          Token
        </label>
        <Input
          id="token"
          type="password"
          variant="brutal"
          bind:value={token}
          onkeydown={handleKeydown}
          placeholder="Enter your token"
          class="focus-visible:border-hister-indigo font-mono"
          autofocus
        />
      </div>
      <Button
        onclick={handleSave}
        disabled={!token.trim()}
        class="bg-hister-indigo hover:bg-hister-indigo/90 border-brutal-border font-space h-12 w-full rounded-none border-[3px] font-bold tracking-wider uppercase shadow-[4px_4px_0px_var(--brutal-shadow)] transition-all hover:translate-x-0.5 hover:translate-y-0.5 hover:shadow-[2px_2px_0px_var(--brutal-shadow)] active:translate-x-1 active:translate-y-1 active:shadow-none disabled:cursor-not-allowed disabled:opacity-50"
      >
        Save Token
      </Button>
    </Card.Content>
    <Card.Footer class="bg-muted-surface/50">
      <p class="text-text-brand-muted font-inter w-full text-center text-xs">
        Your token will be stored locally and used for API requests.
      </p>
    </Card.Footer>
  </Card.Root>
</div>
