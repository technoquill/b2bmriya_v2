# B2B Mriya v2

Clean compatibility rebuild of the current B2B Mriya storefront for
PrestaShop 8.2.7.

The target is visual and hook-level parity with `b2b_mriya`, while current
PrestaShop 8 templates remain the base for commerce and customer flows. The
supplied database is used only to reproduce the active module composition and
configuration. B2B rules stay in modules, PrestaShop data and services.

## Rules

- Do not copy the complete `templates` or `modules` directories from
  `b2b_mriya`.
- Add an override only after comparing the legacy file with the current
  PrestaShop 8.2 Classic template.
- Prefer `{extends file='parent:...'}` and override the smallest possible
  Smarty block.
- Keep business logic in modules or services, not in the theme.
- Do not load a second jQuery, Bootstrap, `core.js`, or a legacy vendor bundle.
- Keep all new text files in UTF-8 with LF line endings.
- Treat [HOOK-MAP.md](HOOK-MAP.md) as the source of truth for active storefront
  modules and hook positions.
- Do not revive a disabled legacy module merely because it is listed in the old
  `theme.yml`.

## Current state

The theme is active on the local `b2b-mriya.dev` staging copy and has passed a
responsive public-page audit at 320, 768, 1024 and 1440 px. The coverage
includes the home page, catalogue and search listings, product, populated cart,
the first checkout step, customer access forms, CMS/contact/store/system pages,
mobile navigation, filters, search suggestions and cart modal. It is not yet
approved for production: authenticated customer flows and the complete
checkout matrix in [MIGRATION.md](MIGRATION.md) still need verification.

## Current coverage

- Customer authentication, registration and password reset inherit current
  PrestaShop 8.2 templates and receive scoped B2B styling.
- The product page inherits current price, combination, stock, MOQ and
  add-to-cart contracts and receives scoped responsive styling.
- The shopping cart inherits current AJAX quantity, discounts, voucher, tax,
  shipping and total contracts and receives scoped responsive styling.
- The active database hook/module composition and page layouts are now recorded
  in `theme.yml` and `HOOK-MAP.md`.
- Header search suggestions use the PrestaShop 8 search controller, and the
  configured vertical category tree has keyboard-accessible controls.
- Header, footer, slider, service icons, category/product carousels, catalogue
  listing, product page and cart now render without browser-console errors at
  the tested desktop and mobile breakpoints.
- Currency, language and customer modules use ID-free theme overrides because
  the same hooks are intentionally rendered in both the top bar and side menu.
- Checkout, authenticated account flows and module combinations that require
  customer-group data still require staging verification.
