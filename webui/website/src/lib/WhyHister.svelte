<script lang="ts">
  import XIcon from '@lucide/svelte/icons/x';
  import { Badge } from '@hister/components';

  const noMore = [
    'Advertisements',
    'Incorrect AI Suggestions',
    'Sponsored Results',
    'Manipulated Result Order',
    'Privacy Concerns',
  ];
</script>

<section class="bg-page-bg w-full">
  <div class="grid grid-cols-1 md:grid-cols-2">
    <article class="flex flex-col gap-6 bg-[var(--text-primary)] p-8 md:p-12">
      <h2
        class="font-space text-4xl leading-[0.95] font-black tracking-[-1px] text-white uppercase md:text-[56px]"
      >
        Why Hister?
      </h2>
      <blockquote class="p-5 md:p-6">
        <p class="font-inter leading-[1.7] font-medium text-white md:text-2xl">
          Keep your data private and local while enjoying powerful search capabilities.
        </p>
      </blockquote>
    </article>

    <aside class="bg-hister-indigo flex min-h-[430px] flex-col gap-6 p-8 md:p-12">
      <Badge
        class="font-space w-fit rounded-none border-none bg-white/10 px-3.5 py-1.5 font-bold tracking-[2px] text-white uppercase md:text-lg"
      >
        Benefits
      </Badge>
      <h2 class="font-space text-4xl font-extrabold tracking-[2px] text-white uppercase">
        No more
      </h2>
      <ul class="m-0 flex list-none flex-col gap-3 p-0">
        {#each noMore as item}
          <li class="flex items-center gap-3.5 border border-white/15 bg-white/5 px-4 py-3.5">
            <XIcon size={18} class="text-hister-white shrink-0" />
            <span class="font-space text-[15px] font-bold tracking-[1px] text-white uppercase"
              >{item}</span
            >
          </li>
        {/each}
      </ul>
    </aside>
  </div>
</section>
