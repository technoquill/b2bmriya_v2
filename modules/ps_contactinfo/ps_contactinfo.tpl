<div class="block-contact footer-block">
  <ul id="block-contact_list">
    {if $shop.logo_details}
      <li class="logotype-block">
        <a href="{$urls.pages.index}">
          <img
            class="logo img-fluid"
            src="{$shop.logo_details.src}"
            alt="{$shop.name}"
            width="{$shop.logo_details.width}"
            height="{$shop.logo_details.height}"
            loading="lazy"
          >
        </a>
      </li>
    {/if}

    <li class="address-block">
      {$contact_infos.address.formatted nofilter}
    </li>

    {if isset($contact_infos.phonesSemicolonToHtml) && $contact_infos.phonesSemicolonToHtml}
      <li class="phone-block">
        <ul class="block-items">
          {foreach from=$contact_infos.phonesSemicolonToHtml item=phone}
            <li>
              <a href="tel:{$phone.formatted}">
                <i class="material-icons b2b-contact-icon" aria-hidden="true">phone</i>
                <span>{$phone.origin}</span>
              </a>
            </li>
          {/foreach}
        </ul>
      </li>
    {elseif $contact_infos.phone}
      <li class="phone-block">
        <a href="tel:{$contact_infos.phone|replace:' ':''}">
          <i class="material-icons b2b-contact-icon" aria-hidden="true">phone</i>
          <span>{$contact_infos.phone}</span>
        </a>
      </li>
    {/if}

    {if isset($contact_infos.maskEmail) && $contact_infos.maskEmail}
      <li class="email-block">
        <i class="material-icons b2b-contact-icon" aria-hidden="true">email</i>
        {$contact_infos.maskEmail nofilter}
      </li>
    {elseif $contact_infos.email && $display_email}
      <li class="email-block">
        <i class="material-icons b2b-contact-icon" aria-hidden="true">email</i>
        {mailto address=$contact_infos.email encode='javascript'}
      </li>
    {/if}
  </ul>
</div>
