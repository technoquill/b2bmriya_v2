{hook h='displayStCompareTopLink'}
{hook h='displayStWishlistTopLink'}

<div class="b2b-overlay" data-b2b-overlay hidden></div>

<div id="_desktop_cart">
  <div
    class="blockcart b2b-blockcart"
    data-refresh-url="{$refresh_url}"
    data-products-count="{$cart.products_count}"
  >
    <a
      class="b2b-cart-trigger"
      href="{$cart_url}"
      rel="nofollow"
      data-b2b-cart-open
      aria-controls="b2b-mini-cart"
      aria-expanded="false"
      aria-label="{l s='Shopping cart containing %count% product(s)' sprintf=['%count%' => $cart.products_count] d='Shop.Theme.Checkout'}"
    >
      <i class="material-icons" aria-hidden="true">shopping_basket</i>
      <span class="cart-products-counthome">{$cart.products_count}</span>
      <span class="hidden-sm-down b2b-cart-label">{l s='Cart' d='Shop.Theme.Checkout'}</span>
    </a>

    <aside
      id="b2b-mini-cart"
      class="b2b-mini-cart"
      role="dialog"
      aria-modal="true"
      aria-hidden="true"
      aria-label="{l s='Shopping cart' d='Shop.Theme.Checkout'}"
      inert
    >
      <div class="b2b-mini-cart-header">
        <h2>{l s='Shopping cart' d='Shop.Theme.Checkout'} ({$cart.products_count})</h2>
        <button class="b2b-mini-cart-close" type="button" data-b2b-cart-close aria-label="{l s='Close' d='Shop.Theme.Global'}">
          <i class="material-icons" aria-hidden="true">close</i>
        </button>
      </div>

      {if $cart.products_count > 0}
        <div class="b2b-mini-cart-products">
          {foreach from=$cart.products item=product}
            <article class="b2b-mini-cart-product">
              <a class="b2b-mini-cart-image" href="{$product.url}">
                {if $product.cover}
                  <img
                    src="{$product.cover.bySize.cart_default.url}"
                    width="{$product.cover.bySize.cart_default.width}"
                    height="{$product.cover.bySize.cart_default.height}"
                    alt="{$product.cover.legend|default:$product.name}"
                    loading="lazy"
                  >
                {else}
                  <img
                    src="{$urls.no_picture_image.bySize.cart_default.url}"
                    width="{$urls.no_picture_image.bySize.cart_default.width}"
                    height="{$urls.no_picture_image.bySize.cart_default.height}"
                    alt="{$product.name}"
                    loading="lazy"
                  >
                {/if}
              </a>
              <div class="b2b-mini-cart-info">
                <a class="product-name" href="{$product.url}">{$product.name}</a>
                <span class="product-quantity">{$product.quantity}&nbsp;×&nbsp;{$product.price}</span>
              </div>
              <a
                class="remove-from-cart"
                rel="nofollow"
                href="{$product.remove_from_cart_url}"
                data-link-action="delete-from-cart"
                data-id-product="{$product.id_product}"
                data-id-product-attribute="{$product.id_product_attribute}"
                data-id-customization="{$product.id_customization}"
                aria-label="{l s='Remove %product% from cart' sprintf=['%product%' => $product.name] d='Shop.Theme.Actions'}"
              >
                <i class="material-icons" aria-hidden="true">delete</i>
              </a>
            </article>
          {/foreach}
        </div>

        <div class="b2b-mini-cart-summary">
          {foreach from=$cart.subtotals item=subtotal}
            {if $subtotal && $subtotal.value|count_characters > 0 && $subtotal.type !== 'tax'}
              <div class="cart-summary-line">
                <span>{if $subtotal.type === 'products'}{$cart.summary_string}{else}{$subtotal.label}{/if}</span>
                <strong>{if $subtotal.type === 'discount'}−&nbsp;{/if}{$subtotal.value}</strong>
              </div>
            {/if}
          {/foreach}
          <div class="cart-summary-line cart-total">
            <span>{$cart.totals.total.label}</span>
            <strong>{$cart.totals.total.value}</strong>
          </div>
        </div>

        <div class="b2b-mini-cart-actions">
          <a class="btn btn-secondary" href="{$cart_url}" rel="nofollow">{l s='View cart' d='Shop.Theme.Actions'}</a>
          <a class="btn btn-primary" href="{$urls.pages.order}" rel="nofollow">{l s='Checkout' d='Shop.Theme.Actions'}</a>
        </div>
      {else}
        <div class="b2b-mini-cart-empty">
          <i class="material-icons" aria-hidden="true">remove_shopping_cart</i>
          <p>{l s='There are no items in your cart' d='Shop.Theme.Checkout'}</p>
          <a class="btn btn-primary" href="{$urls.pages.index}">{l s='Continue shopping' d='Shop.Theme.Actions'}</a>
        </div>
      {/if}
    </aside>
  </div>
</div>
