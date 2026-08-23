{foreach $linkBlocks as $linkBlock}
  <div class="links-block">
    <h2 class="h3">{$linkBlock.title}</h2>
    <ul class="block_content">
      {foreach $linkBlock.links as $link}
        <li>
          <a
            id="{$link.id}-{$linkBlock.id}"
            class="{$link.class}"
            href="{$link.url}"
            title="{$link.description}"
            {if !empty($link.target)}target="{$link.target}" rel="noopener"{/if}
          >
            {$link.title}
          </a>
        </li>
      {/foreach}
    </ul>
  </div>
{/foreach}
