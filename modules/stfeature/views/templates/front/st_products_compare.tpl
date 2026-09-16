{extends file=$layout}

{block name='content'}
  <section
    id="main"
    class="b2b-compare"
    data-b2b-compare
    data-compare-url="{$urls.current_url|escape:'html':'UTF-8'}"
  >
    <header class="b2b-compare__header">
      <div>
        <p class="b2b-compare__eyebrow">Зручний вибір для бізнесу</p>
        <h1 class="h1">Порівняння товарів</h1>
        <p class="b2b-compare__lead">Зіставляйте ціни й характеристики та швидше знаходьте потрібний товар.</p>
      </div>
      {if $hasProduct}
        <p class="b2b-compare__count" data-b2b-compare-count>Товарів у порівнянні: {$products|count}</p>
      {/if}
    </header>

    {if $hasProduct}
      <div class="b2b-compare__toolbar" aria-label="Керування порівнянням">
        <label class="b2b-compare-switch">
          <input type="checkbox" data-b2b-differences-toggle>
          <span class="b2b-compare-switch__control" aria-hidden="true"></span>
          <span>Лише відмінності</span>
        </label>

        <p class="b2b-compare__mode" data-b2b-compare-mode aria-live="polite">Показано всі характеристики</p>

        <div class="b2b-compare__toolbar-actions">
          <div class="b2b-compare__scroll-actions" aria-label="Горизонтальне прокручування">
            <button class="b2b-compare__icon-button" type="button" data-b2b-compare-scroll="-1" aria-label="Прокрутити порівняння ліворуч">
              <span class="material-icons" aria-hidden="true">chevron_left</span>
            </button>
            <button class="b2b-compare__icon-button" type="button" data-b2b-compare-scroll="1" aria-label="Прокрутити порівняння праворуч">
              <span class="material-icons" aria-hidden="true">chevron_right</span>
            </button>
          </div>
          <button class="b2b-compare__clear" type="button" data-b2b-clear-compare>
            <span class="material-icons" aria-hidden="true">delete_sweep</span>
            Очистити порівняння
          </button>
        </div>
      </div>

      <p class="b2b-compare__scroll-hint">
        <span class="material-icons" aria-hidden="true">swipe</span>
        Прокручуйте таблицю горизонтально, щоб побачити всі товари.
      </p>

      <div class="b2b-compare__table-wrap" data-b2b-compare-scroll-container tabindex="0">
        <table id="product_comparison" class="b2b-compare-table">
          <caption class="sr-only">Порівняння {$products|count} товарів за ціною та характеристиками</caption>
          <thead>
            <tr>
              <th class="b2b-compare-table__feature b2b-compare-table__corner" scope="col">
                <span class="material-icons" aria-hidden="true">compare_arrows</span>
                Характеристики
              </th>
              {foreach from=$products item=product}
                <th
                  class="product-miniature js-product-miniature st-productscompare-item leo-productscompare-item b2b-compare-product product-{$product.id_product|intval}"
                  scope="col"
                  data-b2b-compare-product
                  data-id-product="{$product.id_product|intval}"
                  data-id-product-attribute="{$product.id_product_attribute|intval}"
                  itemscope
                  itemtype="https://schema.org/Product"
                >
                  <button
                    class="b2b-compare-product__remove"
                    type="button"
                    data-b2b-remove-compare
                    data-id-product="{$product.id_product|intval}"
                    aria-label="Видалити {$product.name|escape:'html':'UTF-8'} з порівняння"
                  >
                    <span class="material-icons" aria-hidden="true">close</span>
                    <span>Видалити</span>
                  </button>

                  <a class="b2b-compare-product__image" href="{$product.url|escape:'html':'UTF-8'}" tabindex="-1" aria-hidden="true">
                    {if $product.cover}
                      <img
                        src="{$product.cover.bySize.home_default.url|escape:'html':'UTF-8'}"
                        width="{$product.cover.bySize.home_default.width|intval}"
                        height="{$product.cover.bySize.home_default.height|intval}"
                        alt=""
                        loading="lazy"
                      >
                    {else}
                      <img
                        src="{$urls.no_picture_image.bySize.home_default.url|escape:'html':'UTF-8'}"
                        width="{$urls.no_picture_image.bySize.home_default.width|intval}"
                        height="{$urls.no_picture_image.bySize.home_default.height|intval}"
                        alt=""
                        loading="lazy"
                      >
                    {/if}
                  </a>

                  <div class="b2b-compare-product__body">
                    {if !empty($product.manufacturer_name)}
                      <p class="b2b-compare-product__brand">{$product.manufacturer_name|escape:'html':'UTF-8'}</p>
                    {/if}
                    <h2 class="b2b-compare-product__title" itemprop="name">
                      <a href="{$product.url|escape:'html':'UTF-8'}" itemprop="url">{$product.name|escape:'html':'UTF-8'}</a>
                    </h2>
                    {if !empty($product.reference_to_display)}
                      <p class="b2b-compare-product__reference">Артикул: {$product.reference_to_display|escape:'html':'UTF-8'}</p>
                    {/if}
                    {if $product.show_availability && $product.availability_message}
                      <p class="b2b-compare-product__availability b2b-compare-product__availability--{$product.availability|escape:'html':'UTF-8'}">
                        {$product.availability_message|escape:'html':'UTF-8'}
                      </p>
                    {/if}

                    {if $product.show_price}
                      <div class="b2b-compare-product__price" itemprop="offers" itemscope itemtype="https://schema.org/Offer">
                        <span class="price">{$product.price}</span>
                        {if $product.has_discount}
                          <span class="sr-only">Звичайна ціна</span>
                          <span class="regular-price">{$product.regular_price}</span>
                        {/if}
                        {hook h='displayProductPriceBlock' product=$product type='before_price'}
                        {hook h='displayProductPriceBlock' product=$product type='unit_price'}
                        {hook h='displayProductPriceBlock' product=$product type='weight'}
                      </div>
                    {/if}

                    <div class="b2b-compare-product__actions">
                      {hook h='displayStCartButton' product=$product}
                      <a class="btn btn-outline b2b-compare-product__details" href="{$product.url|escape:'html':'UTF-8'}">Детальніше</a>
                    </div>
                  </div>
                </th>
              {/foreach}
            </tr>
          </thead>
          <tbody>
            {if $ordered_features}
              {foreach from=$ordered_features item=feature}
                <tr data-b2b-compare-row>
                  <th class="b2b-compare-table__feature" scope="row">{$feature.name|escape:'html':'UTF-8'}</th>
                  {foreach from=$products item=product}
                    {assign var='product_id' value=$product.id}
                    {assign var='feature_id' value=$feature.id_feature}
                    <td class="b2b-compare-table__value product-{$product.id_product|intval}" data-b2b-compare-value>
                      {if isset($product_features[$product_id]) && isset($product_features[$product_id][$feature_id]) && $product_features[$product_id][$feature_id] != ''}
                        {$product_features[$product_id][$feature_id]|escape:'html':'UTF-8'}
                      {else}
                        <span class="b2b-compare-table__empty" aria-label="Значення відсутнє">—</span>
                      {/if}
                    </td>
                  {/foreach}
                </tr>
              {/foreach}
            {else}
              <tr>
                <th class="b2b-compare-table__feature" scope="row">Характеристики</th>
                <td class="b2b-compare-table__no-features" colspan="100">Для цих товарів немає характеристик для порівняння.</td>
              </tr>
            {/if}
          </tbody>
        </table>
      </div>
      <p class="b2b-compare__status" data-b2b-compare-status role="status" aria-live="polite"></p>
    {else}
      <div class="b2b-compare-empty">
        <span class="b2b-compare-empty__icon material-icons" aria-hidden="true">compare_arrows</span>
        <h2>Поки що тут порожньо</h2>
        <p>Додавайте товари кнопкою «Порівняти» у каталозі — ми зберемо їхні ціни та характеристики в одній таблиці.</p>
        <div class="b2b-compare-empty__actions">
          <a class="btn btn-primary" href="{$urls.base_url|escape:'html':'UTF-8'}">Перейти до каталогу</a>
          <form class="b2b-compare-empty__search" action="{$urls.pages.search|escape:'html':'UTF-8'}" method="get" role="search">
            <input type="hidden" name="controller" value="search">
            <label class="sr-only" for="b2b-compare-search">Назва, артикул або бренд</label>
            <input id="b2b-compare-search" class="form-control" type="search" name="s" placeholder="Назва, артикул або бренд">
            <button class="btn btn-outline" type="submit">
              <span class="material-icons" aria-hidden="true">search</span>
              Знайти товар
            </button>
          </form>
        </div>
      </div>
    {/if}
  </section>
{/block}
