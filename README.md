# B2B Mriya v2

Migration theme for PrestaShop 8.2.7.

The theme currently inherits templates and production assets from the bundled
`classic` theme. Only `custom.css` and `custom.js` belong to the child theme and
override the corresponding empty customization files from the parent.

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

## Current state

This is a migration scaffold, not a finished storefront. Do not enable it on a
production shop until the P0 checks in [MIGRATION.md](MIGRATION.md) pass in a
staging environment.

## Current coverage

- Customer authentication, registration and password reset inherit current
  PrestaShop 8.2 templates and receive scoped B2B styling.
- The product page inherits current price, combination, stock, MOQ and
  add-to-cart contracts and receives scoped responsive styling.
- Cart, checkout, global navigation, catalogue listings and module-specific
  presentation are still pending migration.
