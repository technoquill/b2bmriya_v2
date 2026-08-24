{**
 * Responsive checkout header.
 *
 * The parent partial hides the desktop logo on small screens and relies on a
 * legacy DOM relocation target. Render the same current shop logo directly so
 * checkout keeps a stable, linked brand anchor at every viewport width.
 *}

{block name='header_nav'}
  <nav class="header-nav b2b-checkout-header" aria-label="{l s='Checkout' d='Shop.Theme.Checkout'}">
    <div class="container">
      <div class="b2b-checkout-logo">
        <a href="{$urls.pages.index}" aria-label="{$shop.name}">
          {renderLogo}
        </a>
      </div>
    </div>
  </nav>
{/block}

{block name='header_top'}{/block}
