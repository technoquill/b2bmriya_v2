{**
 * Global header for B2B Mriya v2.
 *
 * The hook zones mirror the active legacy storefront. Module data and
 * behavior remain owned by the modules registered in config/theme.yml.
 *}

{block name='header_banner'}
  <div class="header-banner">
    {hook h='displayBanner'}
  </div>
{/block}

{block name='header_nav'}
  <nav class="header-nav" aria-label="{l s='Store utilities' d='Shop.Theme.Global'}">
    <div class="container">
      <div class="left-nav">
        {hook h='displayNav1'}
      </div>
      <div class="right-nav">
        {hook h='displayNav2'}
      </div>
    </div>
  </nav>
{/block}

{block name='header_top'}
  <div class="header-top header-top-main bg_main">
    <div class="header-div">
      <div class="container">
        <div class="header-left">
          <div class="header_logo" id="_desktop_logo">
            {if $shop.logo_details}
              {if $page.page_name == 'index'}
                <h1 class="header-logo-heading">{renderLogo}</h1>
              {else}
                {renderLogo}
              {/if}
            {/if}
          </div>
        </div>

        <div class="header-center">
          {hook h='displayHeaderCenter'}
        </div>

        <div class="header-right">
          {hook h='displayHeaderRight'}
        </div>
      </div>
    </div>
  </div>
{/block}
