{**
 * ID-free language selector because the module can be rendered more than once.
 *}
<div class="b2b-selector b2b-language-selector">
  <details>
    <summary>
      <span class="b2b-selector-label">{l s='Language:' d='Shop.Theme.Global'}</span>
      <span class="b2b-selector-current">{$current_language.name_simple}</span>
      <i class="material-icons" aria-hidden="true">expand_more</i>
    </summary>
    <ul>
      {foreach from=$languages item=language}
        <li{if $language.id_lang == $current_language.id_lang} class="current"{/if}>
          <a href="{url entity='language' id=$language.id_lang}" data-iso-code="{$language.iso_code}">
            {$language.name_simple}
          </a>
        </li>
      {/foreach}
    </ul>
  </details>
</div>
