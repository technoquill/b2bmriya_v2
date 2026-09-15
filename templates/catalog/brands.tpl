{extends file='parent:catalog/brands.tpl'}

{block name='content'}
  <section id="main" class="b2b-category-hub">
    <header class="b2b-category-hub-header">
      <h1>{l s='Brands' d='Shop.Theme.Catalog'}</h1>
    </header>
    <ul class="b2b-category-grid">
      {foreach from=$brands item=brand}
        <li>
          <a class="b2b-category-card" href="{$brand.url|escape:'html':'UTF-8'}">
            <span class="b2b-category-image">
              {if !empty($brand.image)}
                <img src="{$link->getManufacturerImageLink($brand.id_manufacturer)|escape:'html':'UTF-8'}" alt="" loading="lazy" width="200" height="200">
              {/if}
            </span>
            <h2>{$brand.name|escape:'html':'UTF-8'}</h2>
            <span class="b2b-category-action" aria-hidden="true">{l s='View products' d='Shop.Theme.Actions'} <span>→</span></span>
          </a>
        </li>
      {/foreach}
    </ul>
  </section>
{/block}
