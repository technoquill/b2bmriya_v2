{extends file='parent:catalog/listing/category.tpl'}

{block name='content'}
  {if !empty($subcategories) && empty($listing.products)}
    <section id="main" class="b2b-category-hub">
      <header class="b2b-category-hub-header">
        <h1>{$category.name|escape:'html':'UTF-8'}</h1>
        <p>{l s='Choose a subcategory' d='Shop.Theme.Catalog'}</p>
      </header>
      {include file='catalog/_partials/subcategories.tpl'}
      <aside class="b2b-category-help">
        <span>{l s='Need help choosing?' d='Shop.Theme.Catalog'}</span>
        <a href="{$urls.pages.contact|escape:'html':'UTF-8'}">{l s='Contact a manager' d='Shop.Theme.Catalog'} →</a>
      </aside>
      {hook h='displayFooterCategory'}
    </section>
  {else}
    {$smarty.block.parent}
  {/if}
{/block}

{block name='product_list_header'}
  <header id="js-product-list-header" class="b2b-listing-header">
    <h1>{$category.name|escape:'html':'UTF-8'}</h1>
    {if !empty($category.description)}
      <div class="b2b-category-description">{$category.description nofilter}</div>
    {/if}
  </header>
  {include file='catalog/_partials/listing-controls.tpl'}
{/block}
