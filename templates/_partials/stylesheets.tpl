{**
 * Parent stylesheet registry with a cache-busted child-theme stylesheet.
 *}

{assign var='themeCustomCss' value="{$urls.base_url}themes/b2b_mriya_v2/assets/css/custom.css"}

{foreach $stylesheets.external as $stylesheet}
  <link
    rel="stylesheet"
    href="{$stylesheet.uri}{if $stylesheet.uri == $themeCustomCss}?v=0.4.1{/if}"
    type="text/css"
    media="{$stylesheet.media}"
  >
{/foreach}

{foreach $stylesheets.inline as $stylesheet}
  <style>
    {$stylesheet.content}
  </style>
{/foreach}
