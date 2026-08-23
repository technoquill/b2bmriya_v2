<section id="cpcategorytabs" class="tabs products_block clearfix">
  <div class="container">
    {foreach from=$cpcategoryproductssliderinfos item=cpcategoryproductssliderinfo}
      <div id="tab_{$cpcategoryproductssliderinfo.id}" class="category-tab-content">
        <div class="products-section-title">
          <h2 class="title">{$cpcategoryproductssliderinfo.name}</h2>
        </div>

        {if isset($cpcategoryproductssliderinfo.product) && $cpcategoryproductssliderinfo.product}
          <div class="categorylist-block">
            <div class="category-image">
              {if isset($cpcategoryproductssliderinfo.cate_id.id_category) && $cpcategoryproductssliderinfo.id == $cpcategoryproductssliderinfo.cate_id.id_category}
                <img
                  src="{$image_url}/{$cpcategoryproductssliderinfo.cate_id.image}"
                  alt="{$cpcategoryproductssliderinfo.name}"
                  class="category_img"
                  loading="lazy"
                >
              {else}
                <img
                  src="{$image_url}/categoryslider_placeholder.jpg"
                  alt="{$cpcategoryproductssliderinfo.name}"
                  class="category_img"
                  loading="lazy"
                >
              {/if}
            </div>

            <div class="products">
              <div
                id="cpcategory{$cpcategoryproductssliderinfo.id}-carousel"
                class="cp-carousel product_list product_slider_grid"
                data-catid="{$cpcategoryproductssliderinfo.id}"
              >
                {foreach from=$cpcategoryproductssliderinfo.product item=product}
                  <article class="item">
                    {include file='catalog/_partials/miniatures/product.tpl' product=$product}
                  </article>
                {/foreach}
              </div>

              <div class="customNavigation">
                <button class="btn prev cpcategory_prev" type="button" aria-label="{l s='Previous products' mod='cp_categoryproductsslider'}"></button>
                <button class="btn next cpcategory_next" type="button" aria-label="{l s='Next products' mod='cp_categoryproductsslider'}"></button>
              </div>
            </div>
          </div>
        {else}
          <div class="alert alert-info">{l s='No products in this category at this time.' mod='cp_categoryproductsslider'}</div>
        {/if}
      </div>
    {/foreach}
  </div>
</section>
