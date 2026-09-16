<div class="product-add-to-cart js-product-add-to-cart">
  {if !$configuration.is_catalog}
    <strong class="b2b-mobile-cart-price" aria-hidden="true">{$product.price}</strong>
    <span class="control-label b2b-quantity-label">{l s='Quantity' d='Shop.Theme.Catalog'}</span>

    {block name='product_quantity'}
      <div class="product-quantity clearfix">
        <div class="qty">
          <input
            type="number"
            name="qty"
            id="quantity_wanted"
            inputmode="numeric"
            pattern="[0-9]*"
            {if $product.quantity_wanted}
              value="{$product.quantity_wanted}"
              min="{$product.minimal_quantity}"
            {else}
              value="1"
              min="1"
            {/if}
            class="input-group"
            aria-label="{l s='Quantity' d='Shop.Theme.Actions'}"
          >
        </div>

        <div class="add">
          <button
            class="btn btn-primary add-to-cart"
            data-button-action="add-to-cart"
            type="submit"
            {if !$product.add_to_cart_url}
              disabled
            {/if}
          >
            <i class="material-icons shopping-cart" aria-hidden="true">&#xE547;</i>
            {l s='Додати в кошик' d='Shop.Theme.Actions'}
          </button>
        </div>

        {hook h='displayProductActions' product=$product}
      </div>
    {/block}

    {block name='product_minimal_quantity'}
      <p class="product-minimal-quantity js-product-minimal-quantity">
        {if $product.minimal_quantity > 1}
          {l
            s='The minimum purchase order quantity for the product is %quantity%.'
            d='Shop.Theme.Checkout'
            sprintf=['%quantity%' => $product.minimal_quantity]
          }
        {/if}
      </p>
    {/block}
  {/if}
</div>
