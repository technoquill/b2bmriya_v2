<section class="brands">
  <div class="container">
    <div class="products">
      {if $brands}
        {assign var='brandCount' value=count($brands)}

        {if $brandCount > 1}
          <div class="customNavigation">
            <button class="btn prev brand_prev" type="button" aria-label="{l s='Previous brands' mod='cp_brandlogo'}"></button>
            <button class="btn next brand_next" type="button" aria-label="{l s='Next brands' mod='cp_brandlogo'}"></button>
          </div>
        {/if}

        <div id="brand-carousel" class="cp-carousel product_list">
          {foreach from=$brands item=brand}
            <article class="item">
              <div class="brand-image">
                <a href="{$link->getManufacturerLink($brand.id_manufacturer, $brand.link_rewrite)}" title="{$brand.name}">
                  <img
                    src="{$link->getManufacturerImageLink($brand.id_manufacturer)}"
                    alt="{$brand.name}"
                    loading="lazy"
                  >
                </a>
              </div>
              {if $brandname}
                <h3 class="product-title">
                  <a class="product-name" href="{$link->getManufacturerLink($brand.id_manufacturer, $brand.link_rewrite)}">
                    {$brand.name}
                  </a>
                </h3>
              {/if}
            </article>
          {/foreach}
        </div>
      {else}
        <p>{l s='No brand' mod='cp_brandlogo'}</p>
      {/if}
    </div>
  </div>
</section>
