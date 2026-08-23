{**
 * PrestaShop 8 search presentation for the retained cp_blocksearch widget.
 *
 * Suggestions are requested from the native search controller so product
 * visibility and customer-specific prices use the current presenter contract.
 *}

<div
  class="b2b-search"
  data-b2b-search
  data-search-url="{$search_controller_url|escape:'html':'UTF-8'}"
  data-min-length="3"
  data-loading-text="{l s='Searching…' mod='cp_blocksearch'}"
  data-min-length-text="{l s='Enter at least 3 characters.' mod='cp_blocksearch'}"
  data-empty-text="{l s='No products found.' mod='cp_blocksearch'}"
  data-error-text="{l s='Search is temporarily unavailable.' mod='cp_blocksearch'}"
  data-view-all-text="{l s='View all results' mod='cp_blocksearch'}"
>
  <form
    class="b2b-search-form"
    method="get"
    action="{$search_controller_url|escape:'html':'UTF-8'}"
    role="search"
    autocomplete="off"
  >
    <input type="hidden" name="controller" value="search">
    <label class="sr-only" for="b2b-search-input">{l s='Search products' mod='cp_blocksearch'}</label>
    <input
      id="b2b-search-input"
      class="b2b-search-input"
      type="search"
      name="s"
      value="{$search_query|escape:'htmlall':'UTF-8'}"
      placeholder="{l s='Search Product Here...' mod='cp_blocksearch'}"
      aria-autocomplete="list"
      aria-controls="b2b-search-results"
      aria-expanded="false"
      autocapitalize="off"
      autocomplete="off"
      spellcheck="false"
    >
    <button class="b2b-search-submit" type="submit" aria-label="{l s='Search' mod='cp_blocksearch'}">
      <i class="material-icons" aria-hidden="true">search</i>
    </button>
  </form>

  <p class="sr-only" data-b2b-search-status aria-live="polite"></p>
  <div
    id="b2b-search-results"
    class="b2b-search-results"
    data-b2b-search-results
    role="listbox"
    hidden
  ></div>
</div>
