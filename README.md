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

This is a migration scaffold, not a finished storefront. Do not enable it on a
production shop until the P0 checks in [MIGRATION.md](MIGRATION.md) pass in a
staging environment.

## Current coverage

- Customer authentication, registration and password reset inherit current
  PrestaShop 8.2 templates and receive scoped B2B styling.
- The product page inherits current price, combination, stock, MOQ and
  add-to-cart contracts and receives scoped responsive styling.
- The shopping cart inherits current AJAX quantity, discounts, voucher, tax,
  shipping and total contracts and receives scoped responsive styling.
- The active database hook/module composition and page layouts are now recorded
  in `theme.yml` and `HOOK-MAP.md`.
- Checkout, global templates, catalogue listings and module-specific
  presentation still require staging verification.
