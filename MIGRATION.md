# B2B Mriya theme migration map

## Target

- Runtime: PrestaShop 8.2.7.
- Parent theme: `classic` 2.2.0.
- Legacy reference: `themes/b2b_mriya`.
- Strategy: preserve the live design, hooks and active module composition while
  rebuilding on current PrestaShop 8 contracts.
- Status values: `pending`, `in progress`, `inherited`, `verified`, `removed`.

The legacy theme remains untouched and is used only as a visual and functional
reference.

## P0: commerce and customer flows

| Area | Legacy source | v2 strategy | Status |
| --- | --- | --- | --- |
| Customer form | `templates/_partials/form-fields.tpl` | Inherit the current form renderer and password-policy markup | inherited |
| Registration | `templates/customer/registration.tpl` and `_partials/customer-form.tpl` | Inherit Classic; the legacy copies contain no confirmed B2B-only fields | inherited |
| Authentication | `templates/customer/authentication.tpl` and `_partials/login-form.tpl` | Inherit the current flow; apply visual changes through scoped CSS | inherited |
| Password reset | `templates/customer/password-*.tpl` | Inherit the PrestaShop 8.2 password policy, constraints and feedback | inherited |
| Product page | `templates/catalog/product.tpl` and product partials | Inherit Classic presenter contracts; style price, stock, MOQ, combinations and add-to-cart with scoped CSS | in progress |
| Cart | `templates/checkout/cart.tpl` and cart partials | Inherit Classic totals, AJAX quantity and voucher contracts; apply scoped responsive styling | in progress |
| Checkout | `templates/checkout/checkout.tpl` and `checkout/_partials/steps/*` | Keep current address, shipping, payment and terms contracts | pending |
| Order confirmation | `templates/checkout/order-confirmation.tpl` | Keep current hooks and payment-module output | pending |

P0 acceptance criteria:

- Registration, login, logout and password reset work with the configured
  password length and strength.
- Product combinations, quantity changes, minimum quantity and out-of-stock
  states update without JavaScript errors.
- Cart totals, discounts, tax, shipping and payment totals match the back
  office.
- Guest and registered checkout complete with every enabled carrier and payment
  module.
- No browser-console errors, missing assets or failed XHR requests.

Customer-flow audit note: the legacy authentication and registration templates
are outdated copies of Classic and do not contain project-specific B2B fields.
They are intentionally not copied into v2. Runtime smoke tests remain required
before these rows can be marked `verified`.

Product-flow audit note: the legacy product templates contain no custom B2B
price calculation. Group-specific prices, combination quantities, availability
and minimum order quantities remain owned by PrestaShop 8.2. The visual
`displayCountDown`, `displayStCompareButton` and `displayStWishlistButton`
integrations must be restored without replacing current product presenter and
cart contracts. Runtime combination and cart tests are still required before
this row can be marked `verified`.

Cart-flow audit note: the legacy cart templates contain no project-specific
total calculation. They are outdated copies that miss current responsive image
sources, safe customization handling, numeric quantity inputs, the current
checkout URL and protected automatic vouchers. Product totals, discounts,
shipping, taxes and minimum quantities remain owned by PrestaShop 8.2. Runtime
tests with customer groups, combinations, vouchers and configured tax rules are
still required before this row can be marked `verified`.

Local smoke-test checkpoint (2026-08-23): the product detail page renders at
desktop and mobile widths, quantity controls remain on one row, an item can be
added through the native AJAX flow, the confirmation modal and v2 mini-cart
update to one item, and the test item can be removed back to an empty cart.
No console warnings/errors or missing images were observed. Combinations,
customer-group prices, vouchers, taxes, carriers and payments remain outside
this checkpoint. The anonymous checkout also reached the current personal-data
step with one cart item and rendered all four checkout steps, but no customer
data was entered and no order was submitted.

Known checkout follow-up: the inherited personal-data step renders duplicate
`field-email` and `field-password` IDs while both registration and login forms
are present. Scope those field IDs before the accessibility gate is considered
complete.

## P1: global layout and navigation

| Area | Legacy source | v2 strategy | Status |
| --- | --- | --- | --- |
| Layouts | `templates/layouts/*.tpl` | Use current parent layouts and restore only required legacy hook zones | in progress |
| Head and SEO | `templates/_partials/head.tpl` and microdata templates | Keep Classic hooks and metadata; validate legacy JSON-LD separately | pending |
| Header | `templates/_partials/header.tpl` | Rebuild from current hooks; port the visual hierarchy without old inline scripts | verified |
| Footer | `templates/_partials/footer.tpl` | Rebuild from current hooks; remove duplicate legacy footer partials | verified |
| Main menu | `cp_sideverticalmenu` | Retain the live menu owner; modernize its mobile behavior without changing its configured tree | verified |
| Search | `cp_blocksearch` | Keep the live hook/module owner; render suggestions through the native PrestaShop 8 search endpoint | verified |
| Mini-cart | `modules/ps_shoppingcart` | Keep the current native data contract and recreate the legacy header presentation | verified |

## P2: catalogue, content and account

| Area | Legacy source | v2 strategy | Status |
| --- | --- | --- | --- |
| Product listings | `templates/catalog/listing/*` | Extend current `product-list.tpl`; port grid/list controls only if still required | verified |
| Product miniature | `templates/catalog/_partials/miniatures/product.tpl` | Rebuild on the current product presenter contract | verified |
| Facets and sorting | catalogue partials and `amazzingfilter` | Use current module templates and events | verified |
| Home page | custom `displayHome` modules | Preserve the exact active order recorded in `HOOK-MAP.md`; modernize modules individually | in progress |
| Customer account | `templates/customer/*` | Inherit current empty states, order details and account transformation | pending |
| CMS/contact/stores | `templates/cms/*` and `contact.tpl` | Port styling after commerce flows | pending |
| Errors | `templates/errors/*` | Inherit Classic, including HTTP 410 support | pending |

## Custom module inventory

The database dump distinguishes modules that are actually active from modules
merely declared by the legacy theme. Active visual modules are retained for
parity and modernized in place where necessary. Disabled modules are excluded.
Most custom modules declare version `1.0.0`, so every retained module still
requires runtime verification on PrestaShop 8.2.

| Group | Modules | Planned action | Status |
| --- | --- | --- | --- |
| Navigation/search | `cp_blocksearch`, `cp_sideverticalmenu` | Native search JSON contract and accessible menu shell implemented and smoke-tested | verified |
| Home catalogue | `cp_featuredproducts`, `cp_newproducts`, `cp_specialsproducts`, `cp_bestsellingproducts`, `cp_categoryproductsslider`, `cp_categorylist`, `cp_brandlogo` | Retain active order and content; refactor only where compatibility requires it | pending |
| Content | `cp_serviceblock`, `cp_footercms1` | Retain active database-managed content and reproduce its layout | pending |
| Product helpers | `cp_imagehover`, `cp_countdown` | Retain active hooks and audit presenter assumptions | pending |
| Sidebars | `cp_sidebarnewproducts`, `cp_sidebarfeaturedproducts`, `amazzingfilter` | Retain on the left-column layouts recorded in the database | pending |
| Theme framework | `cp_themeoptions` | Keep during parity work; retire only after every effective setting is migrated | in progress |
| Wishlist/compare | `stfeature` | Retain for parity; replace only through a separate approved migration | pending |
| Slider | `cp_imageslider` | Retain the configured slide while modernizing accessibility and JavaScript | verified |

Disabled legacy modules are listed in [HOOK-MAP.md](HOOK-MAP.md) and are not
part of the v2 activation set.

## Asset decisions

| Legacy asset | Decision | Reason |
| --- | --- | --- |
| `assets/js/jquery-1.7.1.min.js` | removed | PrestaShop core already owns jQuery |
| `assets/js/jquery-3.7.1.min.js` | removed | Avoid replacing the core jQuery instance |
| `assets/js/core.js` | removed | Core scripts are loaded by PrestaShop |
| Bootstrap Alpha CSS/JS | removed | Version mismatch and obsolete API |
| `owl.carousel.js` 1.3.2 | replaced | Native scroll-snap carousel plus a narrow compatibility bridge for retained modules |
| `lightbox.js` 2.9.0 | pending replacement | Audit actual gallery requirements first |
| `jquery.elevatezoom.js` | pending replacement | Product media should use the current image contract |
| `totalstorage.js`, `parascroll.js`, `inview.js` | removed unless a requirement is proven | Legacy global plugins with unclear ownership |
| Font Awesome 4 bundle | pending replacement | Prefer the existing icon system or scoped SVG icons |

## Delivery gates

1. Run the shop on a supported PHP version with a working local database.
2. Validate `theme.yml` and all required inherited templates.
3. Lint PHP in every retained custom module.
4. Compile and cache Smarty templates in a staging shop.
5. Test desktop and mobile at the key breakpoints.
6. Test keyboard navigation, focus states, labels, modal dialogs and contrast.
7. Inspect Network and Console for 404, XHR and JavaScript errors.
8. Validate canonical, hreflang, Open Graph and JSON-LD output.
9. Run checkout smoke tests for every carrier, payment method, currency and
   customer group used by the B2B shop.
