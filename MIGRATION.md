# B2B Mriya theme migration map

## Target

- Runtime: PrestaShop 8.2.7.
- Parent theme: `classic` 2.2.0.
- Legacy reference: `themes/b2b_mriya`.
- Strategy: inherit first, then add the smallest possible overrides.
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
| Product page | `templates/catalog/product.tpl` and product partials | Inherit Classic presenter contracts; style price, stock, MOQ, combinations and add-to-cart with scoped CSS | inherited |
| Cart | `templates/checkout/cart.tpl` and cart partials | Inherit Classic totals, AJAX quantity and voucher contracts; apply scoped responsive styling | inherited |
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
and minimum order quantities remain owned by PrestaShop 8.2. The old explicit
`displayCountdown`, `displayStCompareButton` and `displayStWishlistButton` hooks
are intentionally not copied. Current `displayProductActions`,
`displayProductAdditionalInfo`, `displayReassurance` and `displayFooterProduct`
hooks remain available through Classic. Runtime combination and cart tests are
still required before this row can be marked `verified`.

Cart-flow audit note: the legacy cart templates contain no project-specific
total calculation. They are outdated copies that miss current responsive image
sources, safe customization handling, numeric quantity inputs, the current
checkout URL and protected automatic vouchers. Product totals, discounts,
shipping, taxes and minimum quantities remain owned by PrestaShop 8.2. Runtime
tests with customer groups, combinations, vouchers and configured tax rules are
still required before this row can be marked `verified`.

## P1: global layout and navigation

| Area | Legacy source | v2 strategy | Status |
| --- | --- | --- | --- |
| Layouts | `templates/layouts/*.tpl` | Do not copy; extend parent layouts only when a required block is identified | pending |
| Head and SEO | `templates/_partials/head.tpl` and microdata templates | Keep Classic hooks and metadata; validate legacy JSON-LD separately | pending |
| Header | `templates/_partials/header.tpl` | Rebuild from current hooks; port the visual hierarchy without old inline scripts | pending |
| Footer | `templates/_partials/footer.tpl` | Rebuild from current hooks; remove duplicate legacy footer partials | pending |
| Main menu | `modules/ps_mainmenu` and `cp_sideverticalmenu` overrides | Choose one menu owner and make mobile behavior accessible | pending |
| Search | `modules/cp_blocksearch` | Audit module API and XHR endpoint before porting its markup | pending |
| Mini-cart | `modules/ps_shoppingcart` | Start from the current native module override | pending |

## P2: catalogue, content and account

| Area | Legacy source | v2 strategy | Status |
| --- | --- | --- | --- |
| Product listings | `templates/catalog/listing/*` | Extend current `product-list.tpl`; port grid/list controls only if still required | pending |
| Product miniature | `templates/catalog/_partials/miniatures/product.tpl` | Rebuild on the current product presenter contract | pending |
| Facets and sorting | catalogue partials and `ps_facetedsearch` override | Use current module templates and events | pending |
| Home page | custom `displayHome` modules | Replace layout coupling with explicit, documented hook sections | pending |
| Customer account | `templates/customer/*` | Inherit current empty states, order details and account transformation | pending |
| CMS/contact/stores | `templates/cms/*` and `contact.tpl` | Port styling after commerce flows | pending |
| Errors | `templates/errors/*` | Inherit Classic, including HTTP 410 support | pending |

## Custom module inventory

All modules declared under `dependencies.modules` in the legacy `theme.yml`
are present in the shop's root `modules` directory. Their version declarations
are mostly `1.0.0` and many advertise a minimum PrestaShop version from 1.5 or
1.7, so presence does not prove PrestaShop 8.2 compatibility.

| Group | Modules | Planned action | Status |
| --- | --- | --- | --- |
| Navigation/search | `cp_blocksearch`, `cp_sideverticalmenu`, `cp_headercms1` | PHP/Smarty/JS audit, then keep or replace | pending |
| Home catalogue | `cp_featuredproducts`, `cp_newproducts`, `cp_specialsproducts`, `cp_bestsellingproducts`, `cp_categoryproductsslider`, `cp_categorylist`, `cp_brandlogo` | Prefer maintained native modules where behavior overlaps | pending |
| Banners/content | `cp_cmsbanner1`, `cp_cmsbanner2`, `cp_cmsbanner3`, `cp_leftbanner1`, `cp_serviceblock`, `cp_testimonial`, `cp_parallaximages` | Verify content ownership and replace hard-coded markup | pending |
| Product helpers | `cp_imagehover`, `cp_countdown`, `cp_shippingcmsblock`, `cp_sizechartcmsblock` | Audit product presenter assumptions and accessibility | pending |
| Sidebars | `cp_sidebarnewproducts`, `cp_sidebarfeaturedproducts` | Remove if the v2 layout has no sidebars | pending |
| Store UI | `cpcouponpop`, `cp_salenotification`, `cp_cookie` | Review consent, performance and necessity | pending |
| Theme framework | `cp_themeoptions` | Remove theme-wide CSS/JS generation after required settings are migrated | pending |
| Wishlist/compare | `stfeature` | Decide whether to update it or replace it with maintained modules | pending |
| Slider | `cp_imageslider` | Prefer a maintained, accessible slider or a static responsive banner | pending |

## Asset decisions

| Legacy asset | Decision | Reason |
| --- | --- | --- |
| `assets/js/jquery-1.7.1.min.js` | removed | PrestaShop core already owns jQuery |
| `assets/js/jquery-3.7.1.min.js` | removed | Avoid replacing the core jQuery instance |
| `assets/js/core.js` | removed | Core scripts are loaded by PrestaShop |
| Bootstrap Alpha CSS/JS | removed | Version mismatch and obsolete API |
| `owl.carousel.js` 1.3.2 | pending replacement | Old jQuery plugin and inaccessible defaults |
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
