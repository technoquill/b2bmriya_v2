# Storefront hook map

This file is the migration contract for the visible storefront composition.
It was derived from the technical module, shop, hook and configuration tables
in the supplied database dump and cross-checked against `b2b_mriya` templates
and module sources. Customer, address, order and other commercial rows were not
used.

## Source of truth

- Shop in the dump: `B2B Мрія`.
- Active legacy theme: `b2b_mriya`.
- Target theme: `b2b_mriya_v2` on PrestaShop 8.2.7.
- Business rules remain in PrestaShop, custom modules and the separate
  `b2b_*` tables. They must not be moved into Smarty templates.
- Only modules active for shop 1 are included below. Disabled legacy modules
  are intentionally excluded from the target composition.
- Effective shop settings are preserved during activation: quick view remains
  enabled and the configured image format remains JPEG.

## Global layout

| Page | Target layout | Reason |
| --- | --- | --- |
| Home | `layout-full-width` | Slider and home modules span the content width |
| Product | `layout-full-width` | Matches the legacy product composition |
| Category | `layout-left-column` | The old `layout-both-columns` template actually rendered only a left sidebar |
| Cart | `layout-left-column` | Preserves the legacy sidebar composition |
| Checkout | `layout-full-width` | Keeps the current PrestaShop checkout contract |
| Contact | `layout-left-column` | Preserves the legacy page layout |
| Wishlist/compare pages | `layout-left-column` | Preserves `stfeature` page composition |

## Header

| Hook | Position | Module | Decision |
| --- | ---: | --- | --- |
| `displayNav2` | 1 | `ps_languageselector` | keep current module, reproduce legacy placement |
| `displayNav2` | 2 | `ps_currencyselector` | keep current module, reproduce legacy placement |
| `displayNav2` | 3 | `ps_customersignin` | keep current module and account behavior |
| `displayHeaderCenter` | 1 | `cp_sideverticalmenu` | retain initially; audit and modernize its mobile behavior |
| `displayHeaderRight` | 1 | `cp_blocksearch` | retain module placement; use the native PrestaShop 8 search endpoint and presenter in the v2 override |
| `displayHeaderRight` | 2 | `ps_shoppingcart` | keep current module contract; recreate the legacy visual mini-cart safely |
| `displayCustomerSide` | 1 | `ps_customersignin` | retain for the vertical mobile panel |
| `displaySide` | 1 | `ps_currencyselector` | retain for the vertical mobile panel |
| `displaySide` | 2 | `ps_languageselector` | retain for the vertical mobile panel |

`displayNavFullWidth` contains `blockreassurance`, but the legacy header did not
render this hook. It remains registered for compatibility and is not used as an
extra navigation row in v2.

The legacy search category selector was hidden by the effective storefront CSS.
It is therefore not reproduced as a non-functional control. The visible search
field keeps its placement and now obtains suggestions from the current core
search controller, including its product visibility and customer-price rules.
The currency, language and customer modules have ID-free v2 templates because
their configured header and side-panel hooks intentionally render the same
module more than once on a page.

## Home page

| Hook | Position | Module |
| --- | ---: | --- |
| `displayTopColumn` | 1 | `cp_imageslider` |
| `displayHome` | 1 | `cp_serviceblock` |
| `displayHome` | 2 | `cp_featuredproducts` |
| `displayHome` | 4 | `cp_newproducts` |
| `displayHome` | 5 | `cp_specialsproducts` |
| `displayHome` | 6 | `cp_categorylist` |
| `displayHome` | 8 | `cp_categoryproductsslider` |
| `displayHome` | 10 | `cp_bestsellingproducts` |
| `displayHome` | 11 | `cp_brandlogo` |

The gaps are disabled legacy blocks. Their positions are deliberately not
filled: `cp_cmsbanner2`, `cp_cmsbanner3` and `cp_testimonial` are inactive in
the supplied shop state.

## Sidebars and product helpers

| Hook | Position | Module |
| --- | ---: | --- |
| `displayLeftColumn` | 1 | `amazzingfilter` |
| `displayLeftColumn` | 3 | `cp_sidebarnewproducts` |
| `displayLeftColumn` | 4 | `cp_sidebarfeaturedproducts` |
| `displayLeftColumnProduct` | 1 | `ps_categorytree` |
| `displayLeftColumnProduct` | 3 | `cp_sidebarnewproducts` |
| `displayLeftColumnProduct` | 4 | `cp_sidebarfeaturedproducts` |
| `displayCpHoverImage` | 1 | `cp_imagehover` |
| `displayCountDown` | 1 | `cp_countdown` |
| `displayReassurance` | 1 | `blockreassurance` |
| `displayStCompareButton` | 1 | `stfeature` |
| `displayStCompareTopLink` | 1 | `stfeature` |
| `displayStWishlistButton` | 1 | `stfeature` |
| `displayStWishlistTopLink` | 1 | `stfeature` |

`stfeature` also remains registered on `displayBackOfficeHeader`. This is a
service hook required by the installed module rather than visible storefront
content.

## Footer

| Hook | Position | Module | Decision |
| --- | ---: | --- | --- |
| `displayFooterleft` | 1 | `ps_contactinfo` | keep |
| `displayFooter` | 1 | `ps_linklist` | keep |
| `displayFooter` | 6 | `cp_themeoptions` | keep during parity work; retire only after its output is fully migrated |
| `displayFooterAfter` | 1 | `cp_footercms1` | keep support content |
| `displayFooterAfter` | 2 | `cp_themeoptions` | keep during parity work |

## Excluded inactive legacy modules

`cp_cmsbanner1`, `cp_cmsbanner2`, `cp_cmsbanner3`, `cp_cookie`,
`cp_headercms1`, `cp_leftbanner1`, `cp_parallaximages`,
`cp_salenotification`, `cp_shippingcmsblock`, `cp_sizechartcmsblock`,
`cp_testimonial` and `cpcouponpop` are not part of the active target layout.

## Activation gate

Local checkpoint on 2026-08-23: v2 is enabled only on the local staging copy.
Header/search/menu, slider, service block, available home catalogue blocks,
category listing/filter, product add-to-cart, mini-cart removal, empty cart and
footer were exercised at 1280 px and 390 px without console warnings/errors or
horizontal document overflow. This does not approve production activation.

Do not switch the production shop to v2 until all of the following are true:

1. Theme configuration validates and the required custom modules are present.
2. Header, search, cart, home blocks, sidebars and footer render on staging.
3. Product, cart, login and checkout XHR flows have no console errors.
4. Images for the legacy-compatible image types have been regenerated.
5. Desktop and mobile screenshots have been compared with the current store.
