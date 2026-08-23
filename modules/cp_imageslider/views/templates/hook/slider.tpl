{if $cphomeslider.slides}
  <div
    class="flexslider b2b-home-slider"
    data-interval="{$cphomeslider.speed}"
    data-pause="{$cphomeslider.pause}"
    role="region"
    aria-roledescription="{l s='carousel' mod='cp_imageslider'}"
    aria-label="{l s='Featured promotions' mod='cp_imageslider'}"
  >
    <ul class="slides">
      {foreach from=$cphomeslider.slides item=slide name=home_slides}
        <li class="slide">
          <a href="{$slide.url}" title="{$slide.legend}">
            <img
              class="image"
              src="{$slide.image_url}"
              alt="{$slide.legend}"
              {if isset($slide.sizes[0])}width="{$slide.sizes[0]}"{/if}
              {if isset($slide.sizes[1])}height="{$slide.sizes[1]}"{/if}
              {if $smarty.foreach.home_slides.first}fetchpriority="high"{else}loading="lazy"{/if}
            >
          </a>
          {if $slide.description}
            <div class="caption-description container">
              {$slide.description nofilter}
            </div>
          {/if}
        </li>
      {/foreach}
    </ul>
  </div>
{/if}
