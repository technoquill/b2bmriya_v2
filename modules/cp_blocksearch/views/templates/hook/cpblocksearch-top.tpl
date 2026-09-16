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
  data-loading-text="Пошук…"
  data-min-length-text="Введіть щонайменше 3 символи."
  data-empty-text="Товарів не знайдено."
  data-error-text="Пошук тимчасово недоступний."
  data-view-all-text="Переглянути всі результати"
  data-results-text="Показано підказок: %count%"
>
  <button
    class="b2b-search-toggle"
    type="button"
    data-b2b-search-toggle
    aria-controls="b2b-search-form"
    aria-expanded="false"
    aria-label="Пошук"
  >
    <i class="material-icons" aria-hidden="true">search</i>
  </button>

  <form
    id="b2b-search-form"
    class="b2b-search-form"
    method="get"
    action="{$search_controller_url|escape:'html':'UTF-8'}"
    role="search"
    autocomplete="off"
  >
    <input type="hidden" name="controller" value="search">
    <label class="sr-only" for="b2b-search-input">{l s='Name, reference or brand' d='Shop.Theme.Catalog'}</label>
    <input
      id="b2b-search-input"
      class="b2b-search-input"
      type="search"
      name="s"
      value="{if isset($search_string)}{$search_string|escape:'htmlall':'UTF-8'}{/if}"
      role="combobox"
      placeholder="{l s='Name, reference or brand' d='Shop.Theme.Catalog'}"
      aria-autocomplete="list"
      aria-haspopup="listbox"
      aria-controls="b2b-search-results"
      aria-expanded="false"
      autocapitalize="off"
      autocomplete="off"
      spellcheck="false"
    >
    <button class="b2b-search-submit" type="submit" aria-label="Пошук">
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
