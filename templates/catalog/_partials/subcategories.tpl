{if !empty($subcategories) && (!isset($display_subcategories) || $display_subcategories == 1)}
      <ul class="b2b-category-grid">
        {foreach from=$subcategories item=subcategory}
          <li>
            <a class="b2b-category-card" href="{$subcategory.url|escape:'html':'UTF-8'}">
              <span class="b2b-category-image">
                {if !empty($subcategory.image.large.url)}
                  <img src="{$subcategory.image.large.url|escape:'html':'UTF-8'}" alt="" loading="lazy" width="200" height="200">
                {/if}
              </span>
              <h2>{$subcategory.name|escape:'html':'UTF-8'}</h2>
              <span class="b2b-category-count" data-category-count></span>
              <span class="b2b-category-action" aria-hidden="true">Переглянути <span>→</span></span>
            </a>
          </li>
        {/foreach}
      </ul>
  <script src="{$urls.base_url}themes/b2b_mriya_v2/assets/js/category-hub.js?v=1" defer></script>
{/if}
