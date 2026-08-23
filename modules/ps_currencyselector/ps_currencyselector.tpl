{**
 * ID-free currency selector because the module is rendered in both the header
 * and the off-canvas category menu on this storefront.
 *}
<div class="b2b-selector b2b-currency-selector">
  <details>
    <summary>
      <span class="b2b-selector-label">{l s='Currency:' d='Shop.Theme.Global'}</span>
      <span class="b2b-selector-current">
        {$current_currency.iso_code}{if $current_currency.iso_code !== $current_currency.sign} {$current_currency.sign}{/if}
      </span>
      <i class="material-icons" aria-hidden="true">expand_more</i>
    </summary>
    <ul>
      {foreach from=$currencies item=currency}
        <li{if $currency.current} class="current"{/if}>
          <a title="{$currency.name}" rel="nofollow" href="{$currency.url}">
            {$currency.iso_code}{if $currency.sign !== $currency.iso_code} {$currency.sign}{/if}
          </a>
        </li>
      {/foreach}
    </ul>
  </details>
</div>
