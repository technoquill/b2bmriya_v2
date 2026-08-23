{**
 * Global footer for B2B Mriya v2.
 *}

<div class="footer-container">
  <div class="footer-before-part">
    <div class="container">
      {block name='hook_footer_before'}
        {hook h='displayFooterBefore'}
      {/block}
    </div>
  </div>

  <div class="footer-middle-part">
    <div class="container">
      <div class="row">
        <div class="footer-contact col-xs-12 col-md-4">
          {hook h='displayFooterleft'}
        </div>
        <div class="footer-links col-xs-12 col-md-3">
          {block name='hook_footer'}
            {hook h='displayFooter'}
          {/block}
        </div>
        <div class="footer-support col-xs-12 col-md-5">
          {block name='hook_footer_after'}
            {hook h='displayFooterAfter'}
          {/block}
        </div>
      </div>
    </div>
  </div>

  <div class="footer-after-part">
    <div class="container">
      <div class="row">
        <div class="col-xs-12">
          <p class="copyright">
            {block name='copyright_link'}
              <a href="{$urls.base_url}">
                {l s='%copyright% %year% %shop%' sprintf=['%shop%' => $shop.name, '%year%' => 'Y'|date, '%copyright%' => '©'] d='Shop.Theme.Global'}
              </a>
            {/block}
          </p>
        </div>
      </div>
    </div>
  </div>
</div>

<button class="top_button" type="button" aria-label="{l s='Back to top' d='Shop.Theme.Actions'}">
  <i class="material-icons" aria-hidden="true">expand_less</i>
</button>
