<script lang="ts">
  import * as Card from '@hister/components/ui/card';

  let { data } = $props();
</script>

<svelte:head>
  <title>Posts | Hister</title>
</svelte:head>

<section class="mx-auto max-w-4xl px-6 py-12 md:px-12">
  <h1
    class="font-space mb-10 text-4xl font-black tracking-[-1px] text-(--text-primary) md:text-5xl"
  >
    POSTS
  </h1>

  <ul class="m-0 flex list-none flex-col gap-4 p-0">
    {#each data.posts as post}
      <li>
        <Card.Root href="/posts/{post.slug}/" class="bg-brutal-card p-6">
          <h2 class="font-space mb-2 text-xl font-extrabold tracking-[0.5px] text-(--text-primary)">
            {post.title}
          </h2>
          {#if post.date}
            <time class="font-inter text-sm text-(--text-secondary)" datetime={post.date}>
              {new Date(post.date).toLocaleDateString('en-US', {
                month: 'long',
                day: 'numeric',
                year: 'numeric',
              })}
            </time>
          {/if}
        </Card.Root>
      </li>
    {/each}
  </ul>
</section>
