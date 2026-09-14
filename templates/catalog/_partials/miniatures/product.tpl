{extends file='parent:catalog/_partials/miniatures/product.tpl'}

{block name='product_name'}
  {if $page.page_name == 'category'}
    <h2 class="h3 product-title"><a href="{$product.url|escape:'html':'UTF-8'}">{$product.name|escape:'html':'UTF-8'}</a></h2>
    {if !empty($product.reference_to_display)}
      <p class="b2b-product-reference">{l s='Reference' d='Shop.Theme.Catalog'}: {$product.reference_to_display|escape:'html':'UTF-8'}</p>
    {/if}
    {* Preserve the catalogue's feature names, values and ordering verbatim. *}
    {if !empty($product.grouped_features)}
      <div class="b2b-product-specs">
        <dl>
          {foreach $product.grouped_features as $feature}
            {if $feature@iteration <= 3}
              <div><dt>{$feature.name|escape:'html':'UTF-8'}</dt><dd>{$feature.value|escape:'html':'UTF-8'}</dd></div>
            {/if}
          {/foreach}
        </dl>
        {if $product.grouped_features|count > 3}
          <details>
            <summary>{l s='All specifications (%count%)' d='Shop.Theme.Catalog' sprintf=['%count%' => $product.grouped_features|count]}</summary>
            <dl>
              {foreach $product.grouped_features as $feature}
                {if $feature@iteration > 3}
                  <div><dt>{$feature.name|escape:'html':'UTF-8'}</dt><dd>{$feature.value|escape:'html':'UTF-8'}</dd></div>
                {/if}
              {/foreach}
            </dl>
          </details>
        {/if}
      </div>
    {/if}
    {if $product.show_availability && $product.availability_message}
      <p class="b2b-product-stock b2b-stock-{$product.availability|escape:'html':'UTF-8'}">{$product.availability_message|escape:'html':'UTF-8'}</p>
    {/if}
  {else}
    {$smarty.block.parent}
  {/if}
{/block}

{block name='product_reviews'}
  {$smarty.block.parent}
  {if $page.page_name == 'category'}
    <div class="b2b-product-actions">
      {if !$configuration.is_catalog && $product.add_to_cart_url && !$product.is_customizable && !$product.id_product_attribute}
        <form action="{$urls.pages.cart|escape:'html':'UTF-8'}" method="post">
          <input type="hidden" name="token" value="{$static_token|escape:'html':'UTF-8'}">
          <input type="hidden" name="id_product" value="{$product.id_product|intval}">
          <input type="hidden" name="id_product_attribute" value="0">
          <input type="hidden" name="qty" value="{$product.minimal_quantity|intval}">
          <button class="btn btn-primary add-to-cart" data-button-action="add-to-cart" type="submit">{l s='Add to cart' d='Shop.Theme.Actions'}</button>
        </form>
      {else}
        <a class="btn btn-primary b2b-product-details" href="{$product.url|escape:'html':'UTF-8'}">{l s='Product Details' d='Shop.Theme.Catalog'}</a>
      {/if}
      {hook h='displayStCompareButton' product=$product}
    </div>
  {/if}
{/block}
