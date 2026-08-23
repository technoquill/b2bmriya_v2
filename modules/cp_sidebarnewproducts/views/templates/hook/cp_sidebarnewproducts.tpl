<section class="sidebar-products sidebar-latest block">
  <h2 class="block_title">{l s='New products' mod='cp_sidebarnewproducts'}</h2>
  <div class="block_content">
    <div class="products">
      {foreach from=$products item=product}
        <article class="product-item">
          <div class="left-part">
            <a href="{$product.url}" class="thumbnail product-thumbnail">
              {if $product.cover}
                <img
                  src="{$product.cover.bySize.cart_default.url}"
                  alt="{$product.cover.legend|default:$product.name}"
                  width="{$product.cover.bySize.cart_default.width}"
                  height="{$product.cover.bySize.cart_default.height}"
                  loading="lazy"
                >
              {else}
                <img
                  src="{$urls.no_picture_image.bySize.cart_default.url}"
                  alt="{$product.name}"
                  width="{$urls.no_picture_image.bySize.cart_default.width}"
                  height="{$urls.no_picture_image.bySize.cart_default.height}"
                  loading="lazy"
                >
              {/if}
            </a>
          </div>
          <div class="right-part">
            <h3 class="product-title"><a href="{$product.url}">{$product.name}</a></h3>
            {if $product.show_price}
              <div class="product-price-and-shipping">
                <span class="price">{$product.price}</span>
                {if $product.has_discount}
                  <span class="sr-only">{l s='Regular price' mod='cp_sidebarnewproducts'}</span>
                  <span class="regular-price">{$product.regular_price}</span>
                {/if}
              </div>
            {/if}
          </div>
        </article>
      {/foreach}
    </div>
    <a href="{$allNewProductsLink}" class="allproducts btn btn-primary">{l s='All products' mod='cp_sidebarnewproducts'}</a>
  </div>
</section>
