{extends file='parent:catalog/product.tpl'}

{block name='content'}
  <section id="main">
    <meta content="{$product.url}">

    <header class="b2b-product-page-heading">
      <h1 class="h1">{block name='page_title'}{$product.name}{/block}</h1>
    </header>

    {block name='product_tabs'}
      {capture name='b2b_product_tabs_nav'}
        <ul class="nav nav-tabs" role="tablist">
          <li class="nav-item">
            <a
              class="nav-link active js-product-nav-active"
              data-toggle="tab"
              href="#description"
              role="tab"
              aria-controls="description"
              aria-selected="true"
            >{l s='Description' d='Shop.Theme.Catalog'}</a>
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              data-toggle="tab"
              href="#product-details"
              role="tab"
              aria-controls="product-details"
              aria-selected="false"
            >{l s='Product Details' d='Shop.Theme.Catalog'}</a>
          </li>
          {if $product.attachments}
            <li class="nav-item">
              <a
                class="nav-link"
                data-toggle="tab"
                href="#attachments"
                role="tab"
                aria-controls="attachments"
                aria-selected="false"
              >{l s='Attachments' d='Shop.Theme.Catalog'}</a>
            </li>
          {/if}
          {foreach from=$product.extraContent item=extra key=extraKey}
            <li class="nav-item">
              <a
                class="nav-link"
                data-toggle="tab"
                href="#extra-{$extraKey}"
                role="tab"
                aria-controls="extra-{$extraKey}"
                aria-selected="false"
              >{$extra.title}</a>
            </li>
          {/foreach}
        </ul>
      {/capture}

      <div class="row product-container js-product-container">
        <div class="col-md-6">
          {block name='page_content_container'}
            <section class="page-content" id="content">
              {block name='page_content'}
                {include file='catalog/_partials/product-flags.tpl'}

                {block name='product_cover_thumbnails'}
                  {include file='catalog/_partials/product-cover-thumbnails.tpl'}
                {/block}

                <div class="scroll-box-arrows">
                  <i class="material-icons left">&#xE314;</i>
                  <i class="material-icons right">&#xE315;</i>
                </div>
              {/block}
            </section>
          {/block}
        </div>

        <div class="col-md-6">
          {block name='product_reference_summary'}
            {if isset($product.reference_to_display) && $product.reference_to_display neq ''}
              <div class="product-reference b2b-product-reference-summary">
                <span class="label">{l s='Reference' d='Shop.Theme.Catalog'}:</span>
                <span>{$product.reference_to_display|escape:'html':'UTF-8'}</span>
              </div>
            {/if}
          {/block}

          {block name='product_prices'}
            {include file='catalog/_partials/product-prices.tpl'}
          {/block}

          <div class="product-information">
            {block name='product_description_short'}
              <div
                id="product-description-short-{$product.id}"
                class="product-description"
              >{$product.description_short nofilter}</div>
            {/block}

            {if $product.is_customizable && count($product.customizations.fields)}
              {block name='product_customization'}
                {include file='catalog/_partials/product-customization.tpl' customizations=$product.customizations}
              {/block}
            {/if}

            <div class="product-actions js-product-actions">
              {block name='product_buy'}
                <form action="{$urls.pages.cart}" method="post" id="add-to-cart-or-refresh">
                  <input type="hidden" name="token" value="{$static_token}">
                  <input type="hidden" name="id_product" value="{$product.id}" id="product_page_product_id">
                  <input
                    type="hidden"
                    name="id_customization"
                    value="{$product.id_customization}"
                    id="product_customization_id"
                    class="js-product-customization-id"
                  >

                  {block name='product_variants'}
                    {include file='catalog/_partials/product-variants.tpl'}
                  {/block}

                  {block name='product_pack'}
                    {if $packItems}
                      <section class="product-pack">
                        <p class="h4">{l s='This pack contains' d='Shop.Theme.Catalog'}</p>
                        {foreach from=$packItems item='product_pack'}
                          {block name='product_miniature'}
                            {include
                              file='catalog/_partials/miniatures/pack-product.tpl'
                              product=$product_pack
                              showPackProductsPrice=$product.show_price
                            }
                          {/block}
                        {/foreach}
                      </section>
                    {/if}
                  {/block}

                  {block name='product_discounts'}
                    {include file='catalog/_partials/product-discounts.tpl'}
                  {/block}

                  {block name='product_add_to_cart'}
                    {include file='catalog/_partials/product-add-to-cart.tpl'}
                  {/block}

                  {block name='product_additional_info'}
                    {include file='catalog/_partials/product-additional-info.tpl'}
                  {/block}

                  {* Input to refresh product HTML removed, block kept for compatibility with themes. *}
                  {block name='product_refresh'}{/block}
                </form>
              {/block}

              {capture name='b2b_wishlist_action'}
                {hook h='displayStWishlistButton' product=$product}
              {/capture}
              {capture name='b2b_compare_action'}
                {hook h='displayStCompareButton' product=$product}
              {/capture}
              {if $smarty.capture.b2b_wishlist_action|trim || $smarty.capture.b2b_compare_action|trim}
                <div class="b2b-product-secondary-actions">
                  {$smarty.capture.b2b_wishlist_action nofilter}
                  {$smarty.capture.b2b_compare_action nofilter}
                </div>
              {/if}
            </div>

            {block name='hook_display_reassurance'}
              {hook h='displayReassurance'}
            {/block}
          </div>
        </div>
      </div>

      <div class="tabs b2b-product-tabs">
        {$smarty.capture.b2b_product_tabs_nav nofilter}
        <div class="tab-content" id="tab-content">
          <div
            class="tab-pane fade in active js-product-tab-active"
            id="description"
            role="tabpanel"
          >
            {if $product.description}
              {block name='product_description'}
                <section class="product-description b2b-product-description-full">
                  {$product.description nofilter}
                </section>
              {/block}
            {/if}
          </div>

          {block name='product_details'}
            {include file='catalog/_partials/product-details.tpl'}
          {/block}

          {block name='product_attachments'}
            {if $product.attachments}
              <div class="tab-pane fade in" id="attachments" role="tabpanel">
                <section class="product-attachments">
                  <p class="h5 text-uppercase">{l s='Download' d='Shop.Theme.Actions'}</p>
                  {foreach from=$product.attachments item=attachment}
                    <div class="attachment">
                      <h4>
                        <a href="{url entity='attachment' params=['id_attachment' => $attachment.id_attachment]}">
                          {$attachment.name}
                        </a>
                      </h4>
                      <p>{$attachment.description}</p>
                      <a href="{url entity='attachment' params=['id_attachment' => $attachment.id_attachment]}">
                        {l s='Download' d='Shop.Theme.Actions'} ({$attachment.file_size_formatted})
                      </a>
                    </div>
                  {/foreach}
                </section>
              </div>
            {/if}
          {/block}

          {foreach from=$product.extraContent item=extra key=extraKey}
            <div
              class="tab-pane fade in {$extra.attr.class}"
              id="extra-{$extraKey}"
              role="tabpanel"
              {foreach $extra.attr as $key => $val} {$key}="{$val}"{/foreach}
            >
              {$extra.content nofilter}
            </div>
          {/foreach}
        </div>
      </div>
    {/block}

    {block name='product_accessories'}
      {if $accessories}
        <section class="product-accessories clearfix">
          <p class="h5 text-uppercase">{l s='You might also like' d='Shop.Theme.Catalog'}</p>
          <div class="products row">
            {foreach from=$accessories item='product_accessory' key='position'}
              {block name='product_miniature'}
                {include
                  file='catalog/_partials/miniatures/product.tpl'
                  product=$product_accessory
                  position=$position
                  productClasses='col-xs-12 col-sm-6 col-lg-4 col-xl-3'
                }
              {/block}
            {/foreach}
          </div>
        </section>
      {/if}
    {/block}

    {block name='product_footer'}
      {hook h='displayFooterProduct' product=$product category=$category}
    {/block}

    {block name='product_images_modal'}
      {include file='catalog/_partials/product-images-modal.tpl'}
    {/block}

    {block name='page_footer_container'}
      <footer class="page-footer">
        {block name='page_footer'}{/block}
      </footer>
    {/block}
  </section>
{/block}
