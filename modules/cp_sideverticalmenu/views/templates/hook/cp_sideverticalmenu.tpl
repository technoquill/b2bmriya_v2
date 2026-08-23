{**
 * Accessible storefront shell for the configured cp_sideverticalmenu tree.
 * Menu ownership and content remain in the module.
 *}

<div class="text-xs-center mobile">
  <div class="menu-container">
    <button
      class="menu-icon"
      type="button"
      data-b2b-menu-open
      aria-controls="cp_sidevertical_menu_top"
      aria-expanded="false"
    >
      <span class="cat-title">
        <i class="material-icons menu-open" aria-hidden="true">menu</i>
        {l s='Browse Categories ' mod='cp_sideverticalmenu'}
      </span>
    </button>
  </div>
</div>

<aside
  id="cp_sidevertical_menu_top"
  class="tmvm-contener sidevertical-menu clearfix col-lg-12"
  role="dialog"
  aria-modal="true"
  aria-hidden="true"
  aria-labelledby="b2b-side-menu-title"
  inert
>
  <div class="title_main_menu">
    <h2 class="title_menu" id="b2b-side-menu-title">{l s='Menu' mod='cp_sideverticalmenu'}</h2>
    <button class="menu-icon active" type="button" data-b2b-menu-close aria-label="{l s='Close menu' mod='cp_sideverticalmenu'}">
      <i class="material-icons menu-close" aria-hidden="true">close</i>
    </button>
  </div>

  {function name="menu" nodes=[] depth=0 parent=null path='root'}
    {if $nodes|count}
      <ul class="top-menu" {if $depth == 0}id="top-menu"{/if} data-depth="{$depth}">
        {foreach from=$nodes item=node name=menu_items}
          {assign var=_item_path value="{$path}-{$smarty.foreach.menu_items.index}"}
          <li class="{$node.type}{if $node.current} current{/if}">
            <div class="b2b-menu-link-row">
              <a
                class="dropdown-item{if $depth === 1} dropdown-submenu{/if}"
                href="{$node.url}"
                data-depth="{$depth}"
                {if $node.current}aria-current="page"{/if}
                {if $node.open_in_new_window}target="_blank" rel="noopener"{/if}
              >
                {$node.label}
              </a>

              {if $node.children|count}
                <button
                  class="navbar-toggler collapse-icons"
                  type="button"
                  data-b2b-submenu-toggle
                  aria-controls="b2b-side-submenu-{$_item_path}"
                  aria-expanded="false"
                  aria-label="{l s='Toggle submenu' mod='cp_sideverticalmenu'}"
                >
                  <i class="material-icons add" aria-hidden="true">add</i>
                  <i class="material-icons remove" aria-hidden="true">remove</i>
                </button>
              {/if}
            </div>

            {if $node.children|count}
              <div
                class="{if $depth === 0}popover sub-menu js-sub-menu {/if}collapse"
                id="b2b-side-submenu-{$_item_path}"
                hidden
              >
                {menu nodes=$node.children depth=$node.depth parent=$node path=$_item_path}
              </div>
            {/if}
          </li>
        {/foreach}
      </ul>
    {/if}
  {/function}

  <nav class="menu sidevertical-menu js-top-menu position-static" id="sidevertical_menu" aria-label="{l s='Product categories' mod='cp_sideverticalmenu'}">
    <div class="js-top-menu mobile">
      {menu nodes=$menu.children}
    </div>
  </nav>

  <div class="verticalmenu-side">
    <div class="vertical-side-top-text">
      {hook h='displayCustomerSide'}
      {hook h='displayStWishlistTopLink'}
      {hook h='displayStCompareTopLink'}
    </div>
    {hook h='displaySide'}
  </div>
</aside>
