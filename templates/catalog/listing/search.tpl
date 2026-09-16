{extends file='parent:catalog/listing/search.tpl'}

{block name='product_list_header'}
  <header id="js-product-list-header" class="b2b-listing-header b2b-search-header">
    {if !empty($search_string)}
      <h1>
        {l s='Search results' d='Shop.Theme.Catalog'}:
        <span>«{$search_string|escape:'html':'UTF-8'}»</span>
      </h1>
    {else}
      <h1>Пошук товарів</h1>
      <p>Введіть назву товару, артикул або бренд.</p>
    {/if}
  </header>

  {if $listing.products|count}
    {include file='catalog/_partials/listing-controls.tpl'}
  {/if}
{/block}

{block name="error_content"}
  <div class="b2b-search-empty">
    {if empty($search_string)}
      <h2>Що шукаєте?</h2>
      <p>Введіть назву товару, артикул або бренд у полі нижче.</p>
    {else}
      <h2 id="product-search-no-matches">За запитом «{$search_string|escape:'html':'UTF-8'}» нічого не знайдено</h2>
      <p>Перевірте написання, скоротіть запит або спробуйте знайти товар за артикулом.</p>
    {/if}

    <form class="b2b-search-retry" method="get" action="{$urls.pages.search|escape:'html':'UTF-8'}" role="search">
      <label for="b2b-search-retry-input">Новий пошук</label>
      <div class="b2b-search-retry-control">
        <input
          id="b2b-search-retry-input"
          class="form-control"
          type="search"
          name="s"
          value="{$search_string|escape:'htmlall':'UTF-8'}"
          placeholder="Назва, артикул або бренд"
          required
        >
        <button class="btn btn-primary" type="submit">Знайти</button>
      </div>
    </form>

    <p class="b2b-search-help">
      Не знаєте, який товар обрати?
      <a href="{$urls.pages.contact|escape:'html':'UTF-8'}">Зв’язатися з менеджером</a>
    </p>
  </div>
{/block}
