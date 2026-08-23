<section class="cpcategorylist">
  <div class="cpcategory-container container">
    <div class="products-section-title">
      <h2 class="title">{l s='Shop by Featured Categories' mod='cp_categorylist'}</h2>
    </div>

    <div class="products">
      {if isset($cpcategoryinfos) && $cpcategoryinfos}
        {assign var='categoryCount' value=count($cpcategoryinfos)}

        {if $categoryCount > 1}
          <div class="customNavigation">
            <button class="btn prev cat_prev" type="button" aria-label="{l s='Previous categories' mod='cp_categorylist'}"></button>
            <button class="btn next cat_next" type="button" aria-label="{l s='Next categories' mod='cp_categorylist'}"></button>
          </div>
        {/if}

        <div id="cpcategorylist-carousel" class="cp-carousel product_list product_slider_grid">
          {foreach from=$cpcategoryinfos item=cpcategoryinfo}
            <article class="item">
              <div class="categoryblock">
                <div class="block_content">
                  <div class="cat-img">
                    <a
                      href="{$link->getCategoryLink($cpcategoryinfo.category->id_category, $cpcategoryinfo.category->link_rewrite)}"
                      class="categoryimage"
                    >
                      {if isset($cpcategoryinfo.cate_id.id_category) && $cpcategoryinfo.id == $cpcategoryinfo.cate_id.id_category}
                        <img
                          src="{$image_url}/{$cpcategoryinfo.cate_id.image}"
                          alt="{$cpcategoryinfo.name}"
                          class="img-responsive"
                          loading="lazy"
                        >
                      {else}
                        <img
                          src="{$urls.no_picture_image.bySize.home_default.url}"
                          alt="{$cpcategoryinfo.name}"
                          class="img-responsive"
                          width="{$urls.no_picture_image.bySize.home_default.width}"
                          height="{$urls.no_picture_image.bySize.home_default.height}"
                          loading="lazy"
                        >
                      {/if}
                    </a>
                  </div>
                  <div class="categorylist">
                    <div class="cate-heading">
                      <a href="{$link->getCategoryLink($cpcategoryinfo.category->id_category, $cpcategoryinfo.category->link_rewrite)}">
                        {$cpcategoryinfo.name}
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </article>
          {/foreach}
        </div>
      {else}
        <div class="alert alert-info">{l s='No category is selected.' mod='cp_categorylist'}</div>
      {/if}
    </div>
  </div>
</section>
