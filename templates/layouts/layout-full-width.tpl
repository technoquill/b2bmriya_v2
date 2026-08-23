{extends file='parent:layouts/layout-full-width.tpl'}

{block name='header'}
  {include file='_partials/header.tpl'}

  {if $page.page_name == 'index'}
    <section id="wrapper-top" aria-label="{l s='Featured content' d='Shop.Theme.Global'}">
      {hook h='displayTopColumn'}
    </section>
  {/if}
{/block}
