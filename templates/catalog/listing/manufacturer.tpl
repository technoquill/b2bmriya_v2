{extends file='parent:catalog/listing/manufacturer.tpl'}

{block name='product_list_header'}
  <header id="js-product-list-header" class="b2b-listing-header">
    <h1>{$manufacturer.name|escape:'html':'UTF-8'}</h1>
    {if !empty($manufacturer.short_description)}
      <div id="manufacturer-short_description" class="b2b-category-description">{$manufacturer.short_description nofilter}</div>
    {/if}
    {if !empty($manufacturer.description)}
      <div id="manufacturer-description" class="b2b-category-description">{$manufacturer.description nofilter}</div>
    {/if}
  </header>
  {include file='catalog/_partials/listing-controls.tpl'}
{/block}
