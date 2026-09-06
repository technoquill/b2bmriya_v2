{extends file='layouts/layout-both-columns.tpl'}

{block name='left_column'}{/block}
{block name='right_column'}{/block}

{block name='content_wrapper'}
  <div id="content-wrapper" class="js-content-wrapper col-xs-12">
    {hook h="displayContentWrapperTop"}
    {block name='content'}
      <p>Hello world! This is HTML5 Boilerplate.</p>
    {/block}
    {hook h="displayContentWrapperBottom"}
  </div>
{/block}

{block name='header'}
  {include file='_partials/header.tpl'}

  {if $page.page_name == 'index'}
    <section id="wrapper-top" aria-label="{l s='Featured content' d='Shop.Theme.Global'}">
      <div class="wrapper-container">
        {hook h='displayTopColumn'}
      </div>
    </section>
  {/if}
{/block}
