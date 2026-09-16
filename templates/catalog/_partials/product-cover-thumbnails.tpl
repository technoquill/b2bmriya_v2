{**
 * B2B Mriya product gallery.
 *
 * The js-images-container hook is intentionally retained because PrestaShop
 * replaces this fragment when a product combination changes.
 *}
{assign var=imagesCount value=$product.images|count}

<div
  class="images-container js-images-container b2b-product-gallery"
  data-b2b-gallery
  data-product-id="{$product.id}"
>
  {block name='product_cover'}
    <div class="b2b-gallery-stage">
      {if $product.default_image}
        <button
          class="b2b-gallery-cover-button"
          type="button"
          data-b2b-gallery-open
          aria-label="Відкрити збільшене фото товару"
          aria-controls="product-gallery-lightbox-{$product.id}"
        >
          <picture>
            {if !empty($product.default_image.bySize.large_default.sources.avif)}
              <source srcset="{$product.default_image.bySize.large_default.sources.avif}" type="image/avif">
            {/if}
            {if !empty($product.default_image.bySize.large_default.sources.webp)}
              <source srcset="{$product.default_image.bySize.large_default.sources.webp}" type="image/webp">
            {/if}
            <img
              class="b2b-gallery-cover"
              data-b2b-gallery-cover
              src="{$product.default_image.bySize.large_default.url}"
              {if !empty($product.default_image.legend)}
                alt="{$product.default_image.legend}"
                title="{$product.default_image.legend}"
              {else}
                alt="{$product.name}"
              {/if}
              loading="eager"
              fetchpriority="high"
              decoding="async"
              width="{$product.default_image.bySize.large_default.width}"
              height="{$product.default_image.bySize.large_default.height}"
            >
          </picture>
          <span class="b2b-gallery-zoom-hint" aria-hidden="true">
            <i class="material-icons">&#xE8FF;</i>
          </span>
        </button>

        {if $imagesCount > 1}
          <button
            class="b2b-gallery-stage-control is-previous"
            type="button"
            data-b2b-gallery-previous
            aria-label="Попереднє фото"
          >
            <i class="material-icons" aria-hidden="true">&#xE314;</i>
          </button>
          <button
            class="b2b-gallery-stage-control is-next"
            type="button"
            data-b2b-gallery-next
            aria-label="Наступне фото"
          >
            <i class="material-icons" aria-hidden="true">&#xE315;</i>
          </button>
          <span class="b2b-gallery-counter" aria-live="polite">
            <span data-b2b-gallery-current>1</span>
            <span aria-hidden="true"> / </span>
            <span class="sr-only">з</span>
            <span data-b2b-gallery-total>{$imagesCount}</span>
          </span>
        {/if}
      {else}
        <picture>
          {if !empty($urls.no_picture_image.bySize.large_default.sources.avif)}
            <source srcset="{$urls.no_picture_image.bySize.large_default.sources.avif}" type="image/avif">
          {/if}
          {if !empty($urls.no_picture_image.bySize.large_default.sources.webp)}
            <source srcset="{$urls.no_picture_image.bySize.large_default.sources.webp}" type="image/webp">
          {/if}
          <img
            class="b2b-gallery-cover"
            src="{$urls.no_picture_image.bySize.large_default.url}"
            alt="{$product.name}"
            loading="eager"
            fetchpriority="high"
            decoding="async"
            width="{$urls.no_picture_image.bySize.large_default.width}"
            height="{$urls.no_picture_image.bySize.large_default.height}"
          >
        </picture>
      {/if}
    </div>
  {/block}

  {if $product.default_image && $imagesCount > 1}
    {block name='product_images'}
      <div class="b2b-gallery-navigation">
        <button
          class="b2b-gallery-strip-control is-previous"
          type="button"
          data-b2b-gallery-strip-previous
          aria-label="Прокрутити мініатюри назад"
        >
          <i class="material-icons" aria-hidden="true">&#xE314;</i>
        </button>

        <div class="b2b-gallery-mask" data-b2b-gallery-strip>
          <ul class="b2b-gallery-thumbnails" role="list">
            {foreach from=$product.images item=image name='b2bProductImages'}
              <li class="b2b-gallery-thumbnail-item">
                <button
                  class="b2b-gallery-thumbnail{if $image.id_image == $product.default_image.id_image} is-selected{/if}"
                  type="button"
                  data-b2b-gallery-thumbnail
                  data-index="{$smarty.foreach.b2bProductImages.index}"
                  data-image-src="{$image.bySize.large_default.url}"
                  {if !empty($image.bySize.large_default.sources)}
                    data-image-sources="{$image.bySize.large_default.sources|@json_encode}"
                  {/if}
                  {if !empty($image.legend)}
                    data-image-alt="{$image.legend}"
                    data-image-title="{$image.legend}"
                  {else}
                    data-image-alt="{$product.name} — фото {$smarty.foreach.b2bProductImages.iteration}"
                  {/if}
                  aria-label="Переглянути фото {$smarty.foreach.b2bProductImages.iteration} з {$imagesCount}"
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
              </li>
            {/foreach}
          </ul>
        </div>

        <button
          class="b2b-gallery-strip-control is-next"
          type="button"
          data-b2b-gallery-strip-next
          aria-label="Прокрутити мініатюри вперед"
        >
          <i class="material-icons" aria-hidden="true">&#xE315;</i>
        </button>
      </div>
    {/block}
  {/if}

  {hook h='displayAfterProductThumbs' product=$product}
</div>
