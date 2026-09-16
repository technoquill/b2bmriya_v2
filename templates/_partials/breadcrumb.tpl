{**
 * Storefront breadcrumb navigation.
 *
 * The current page remains the final, non-linked item. Long product names are
 * constrained visually by the child-theme stylesheet without changing the
 * complete breadcrumb data used by the inherited JSON-LD template.
 *}

<nav
  data-depth="{$breadcrumb.count}"
  class="breadcrumb{if $page.page_name == 'product'} b2b-product-breadcrumb{if $breadcrumb.count > 3} b2b-product-breadcrumb--compact{/if}{/if}"
  aria-label="Хлібні крихти"
>
  <ol>
    {block name='breadcrumb'}
      {foreach from=$breadcrumb.links item=path name=breadcrumb}
        {block name='breadcrumb_item'}
          <li>
            {if not $smarty.foreach.breadcrumb.last}
              {if $smarty.foreach.breadcrumb.first}
                <a class="b2b-breadcrumb-home" href="{$path.url}" aria-label="{$path.title}">
                  <span class="material-icons" aria-hidden="true">home</span>
                </a>
              {else}
                <a href="{$path.url}"><span>{$path.title}</span></a>
              {/if}
            {else}
              <span aria-current="page">{$path.title}</span>
            {/if}
          </li>
        {/block}
      {/foreach}
    {/block}
  </ol>
</nav>
