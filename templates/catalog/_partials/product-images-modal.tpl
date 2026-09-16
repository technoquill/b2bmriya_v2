{**
 * Accessible full-screen product gallery.
 *
 * js-product-images-modal is retained so PrestaShop can replace this fragment
 * after a product combination update. Bootstrap modal classes are deliberately
 * omitted: this lightbox is controlled by the theme's gallery component.
 *}
{assign var=imagesCount value=$product.images|count}

<div
  class="js-product-images-modal b2b-gallery-lightbox"
  id="product-gallery-lightbox-{$product.id}"
  data-b2b-gallery-lightbox
  data-product-id="{$product.id}"
  aria-hidden="true"
  hidden
>
  <div
    class="b2b-gallery-lightbox-dialog"
    role="dialog"
    aria-modal="true"
    aria-label="Фотогалерея: {$product.name}"
  >
    <header class="b2b-gallery-lightbox-header">
      <span class="b2b-gallery-lightbox-counter" aria-live="polite">
        <span data-b2b-lightbox-current>1</span>
        <span aria-hidden="true"> / </span>
        <span class="sr-only">з</span>
        <span data-b2b-lightbox-total>{$imagesCount}</span>
      </span>

      <div class="b2b-gallery-lightbox-actions">
        <button
          class="b2b-gallery-lightbox-action"
          type="button"
          data-b2b-lightbox-zoom
          aria-label="Збільшити фото"
          aria-pressed="false"
        >
          <i class="material-icons" aria-hidden="true">&#xE8FF;</i>
        </button>
        <button
          class="b2b-gallery-lightbox-action"
          type="button"
          data-b2b-lightbox-close
          aria-label="Закрити фотогалерею"
        >
          <i class="material-icons" aria-hidden="true">&#xE5CD;</i>
        </button>
      </div>
    </header>

    <div class="b2b-gallery-lightbox-stage" data-b2b-lightbox-stage>
      {if $imagesCount > 1}
        <button
          class="b2b-gallery-lightbox-control is-previous"
          type="button"
          data-b2b-lightbox-previous
          aria-label="Попереднє фото"
        >
          <i class="material-icons" aria-hidden="true">&#xE314;</i>
        </button>
      {/if}

      <figure class="b2b-gallery-lightbox-figure">
        {if $product.default_image}
          <picture>
            {if !empty($product.default_image.bySize.large_default.sources.avif)}
              <source srcset="{$product.default_image.bySize.large_default.sources.avif}" type="image/avif">
            {/if}
            {if !empty($product.default_image.bySize.large_default.sources.webp)}
              <source srcset="{$product.default_image.bySize.large_default.sources.webp}" type="image/webp">
            {/if}
            <img
              class="b2b-gallery-lightbox-image"
              data-b2b-lightbox-image
              src="{$product.default_image.bySize.large_default.url}"
              {if !empty($product.default_image.legend)}
                alt="{$product.default_image.legend}"
                title="{$product.default_image.legend}"
              {else}
                alt="{$product.name}"
              {/if}
              decoding="async"
              width="{$product.default_image.bySize.large_default.width}"
              height="{$product.default_image.bySize.large_default.height}"
            >
          </picture>
        {/if}
      </figure>

      {if $imagesCount > 1}
        <button
          class="b2b-gallery-lightbox-control is-next"
          type="button"
          data-b2b-lightbox-next
          aria-label="Наступне фото"
        >
          <i class="material-icons" aria-hidden="true">&#xE315;</i>
        </button>
      {/if}
    </div>

    {if $imagesCount > 1}
      <div class="b2b-gallery-lightbox-thumbnails" data-b2b-lightbox-strip>
        {foreach from=$product.images item=image name='b2bModalImages'}
          <button
            class="b2b-gallery-lightbox-thumbnail{if $image.id_image == $product.default_image.id_image} is-selected{/if}"
            type="button"
            data-b2b-lightbox-thumbnail
            data-index="{$smarty.foreach.b2bModalImages.index}"
            data-image-src="{$image.bySize.large_default.url}"
            {if !empty($image.bySize.large_default.sources)}
              data-image-sources="{$image.bySize.large_default.sources|@json_encode}"
            {/if}
            {if !empty($image.legend)}
              data-image-alt="{$image.legend}"
              data-image-title="{$image.legend}"
            {else}
              data-image-alt="{$product.name} — фото {$smarty.foreach.b2bModalImages.iteration}"
            {/if}
            aria-label="Переглянути фото {$smarty.foreach.b2bModalImages.iteration} з {$imagesCount}"
            aria-current="{if $image.id_image == $product.default_image.id_image}true{else}false{/if}"
          >
            <picture>
              {if !empty($image.bySize.small_default.sources.avif)}
                <source srcset="{$image.bySize.small_default.sources.avif}" type="image/avif">
              {/if}
              {if !empty($image.bySize.small_default.sources.webp)}
                <source srcset="{$image.bySize.small_default.sources.webp}" type="image/webp">
              {/if}
              <img
                src="{$image.bySize.small_default.url}"
                alt=""
                loading="lazy"
                decoding="async"
                width="{$image.bySize.small_default.width}"
                height="{$image.bySize.small_default.height}"
              >
            </picture>
          </button>
        {/foreach}
      </div>
    {/if}
  </div>
</div>
