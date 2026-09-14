{**
 * Copyright since 2007 PrestaShop SA and Contributors
 * PrestaShop is an International Registered Trademark & Property of PrestaShop SA
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.md.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/AFL-3.0
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to https://devdocs.prestashop.com/ for more information.
 *
 * @author    PrestaShop SA and Contributors <contact@prestashop.com>
 * @copyright Since 2007 PrestaShop SA and Contributors
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 *}

{* Translate stable sort keys so initial rendering and AJAX use the same labels. *}
{* Module AJAX responses omit the language template variable. Use the active shop language. *}
{assign var='b2bSortLocale' value=Context::getContext()->language->iso_code}
{assign var='b2bSortLabels' value=[
  'product.position.asc' => 'Релевантність',
  'product.position.desc' => 'Релевантність, у зворотному порядку',
  'product.date_add.desc' => 'Спочатку нові',
  'product.date_add.asc' => 'Спочатку давніші',
  'product.date_upd.desc' => 'Нещодавно оновлені',
  'product.date_upd.asc' => 'Давно оновлені',
  'product.name.asc' => 'Назва, А — Я',
  'product.name.desc' => 'Назва, Я — А',
  'product.price.asc' => 'Спочатку дешевші',
  'product.price.desc' => 'Спочатку дорожчі',
  'product.weight.asc' => 'Вага, за зростанням',
  'product.weight.desc' => 'Вага, за спаданням',
  'product.quantity.desc' => 'Спочатку в наявності',
  'product.quantity.asc' => 'Спочатку відсутні',
  'product.random.desc' => 'Випадково',
  'product.sales.desc' => 'Спочатку найпопулярніші',
  'product.sales.asc' => 'Спочатку найменш популярні',
  'product.reference.asc' => 'Артикул, А — Я',
  'product.reference.desc' => 'Артикул, Я — А',
  'product.manufacturer_name.asc' => 'Бренд, А — Я',
  'product.manufacturer_name.desc' => 'Бренд, Я — А'
]}
{assign var='b2bSortSelected' value=$listing.sort_selected}
{foreach from=$listing.sort_orders item=sort_order}
  {if $sort_order.current && $b2bSortLocale == 'uk' && isset($b2bSortLabels[$sort_order.urlParameter])}
    {assign var='b2bSortSelected' value=$b2bSortLabels[$sort_order.urlParameter]}
  {/if}
{/foreach}

<span class="col-sm-3 col-md-5 hidden-sm-down sort-by">{l s='Sort by:' d='Shop.Theme.Global'}</span>
<div class="{if !empty($listing.rendered_facets)}col-xs-8 col-sm-7{else}col-xs-12 col-sm-12{/if} col-md-9 products-sort-order dropdown">
  <div class="b2b-sort-control dropdown">
    <button
      class="btn-unstyle select-title"
      data-toggle="dropdown"
      aria-label="{l s='Sort by selection' d='Shop.Theme.Global'}"
      aria-haspopup="true"
      aria-expanded="false">
      <span class="b2b-sort-label">{if $b2bSortSelected}{$b2bSortSelected|escape:'html':'UTF-8'}{else}{l s='Choose' d='Shop.Theme.Actions'}{/if}</span>
      {* Hidden overlapping labels provide intrinsic width without JavaScript measurements. *}
      <span class="b2b-sort-size" aria-hidden="true">
        {foreach from=$listing.sort_orders item=sort_order}
          <span>
            {if $b2bSortLocale == 'uk' && isset($b2bSortLabels[$sort_order.urlParameter])}
              {$b2bSortLabels[$sort_order.urlParameter]|escape:'html':'UTF-8'}
            {else}
              {$sort_order.label|escape:'html':'UTF-8'}
            {/if}
          </span>
        {/foreach}
      </span>
      <i class="material-icons float-xs-right" aria-hidden="true">&#xE5C5;</i>
    </button>
    <div class="dropdown-menu">
      {foreach from=$listing.sort_orders item=sort_order}
        <a
          rel="nofollow"
          href="{$sort_order.url|escape:'html':'UTF-8'}"
          class="select-list {['current' => $sort_order.current, 'js-search-link' => true]|classnames}"
        >
          {if $b2bSortLocale == 'uk' && isset($b2bSortLabels[$sort_order.urlParameter])}
            {$b2bSortLabels[$sort_order.urlParameter]|escape:'html':'UTF-8'}
          {else}
            {$sort_order.label|escape:'html':'UTF-8'}
          {/if}
        </a>
      {/foreach}
    </div>
  </div>
</div>
