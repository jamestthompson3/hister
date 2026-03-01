<script lang="ts">
  import XIcon from '@lucide/svelte/icons/x';
  import { Badge } from '@hister/components';

  const noMore = [
    'ADVERTISEMENTS',
    'INCORRECT AI SUGGESTIONS',
    'SPONSORED RESULTS',
    'MANIPULATED RESULT ORDER',
    'PRIVACY CONCERNS',
  ];
</script>

<section class="w-full bg-page-bg">
  <div class="grid grid-cols-1 md:grid-cols-2">
    <article class="bg-[var(--text-primary)] p-8 md:p-12 flex flex-col gap-6">
      <Badge class="bg-hister-coral text-white font-space text-[11px] font-bold tracking-[2px] px-3.5 py-1.5 w-fit rounded-none border-none">
        THE PROBLEM
      </Badge>
      <h2 class="text-white font-space text-4xl md:text-[56px] font-black tracking-[-1px] leading-[0.95]">
        WHY HISTER?
      </h2>
      <p class="text-white/65 font-inter text-[17px] leading-[1.7]">
        When we search online, it's for one of two reasons: finding new information or recalling something we've seen before.
      </p>
      <blockquote class="border-2 border-hister-teal p-5 md:p-6">
        <p class="text-white font-inter text-[15px] font-medium leading-[1.7]">
          Hister solves the recall problem by indexing every page you visit and providing the fastest search interface possible.
        </p>
      </blockquote>
    </article>

    <aside class="bg-hister-indigo p-8 md:p-12 flex flex-col gap-6 min-h-[430px]">
      <Badge class="bg-white/10 text-white font-space text-[11px] font-bold tracking-[2px] px-3.5 py-1.5 w-fit rounded-none border-none">
        BENEFITS
      </Badge>
      <h2 class="text-white font-space text-4xl font-extrabold tracking-[2px]">
        NO MORE:
      </h2>
      <ul class="flex flex-col gap-3 list-none p-0 m-0">
        {#each noMore as item}
          <li class="flex items-center gap-3.5 bg-white/5 border border-white/15 px-4 py-3.5">
            <XIcon size={18} class="text-hister-coral shrink-0" />
            <span class="text-white font-space text-[15px] font-bold tracking-[1px]">{item}</span>
          </li>
        {/each}
      </ul>
    </aside>
  </div>
</section>
