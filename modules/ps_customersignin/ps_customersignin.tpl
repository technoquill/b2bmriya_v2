{**
 * Customer link without a fixed desktop/mobile wrapper ID. The module is
 * intentionally registered in both the top bar and the side menu.
 *}
<div class="user-info b2b-user-info">
  {if $logged}
    <a class="logout" href="{$urls.actions.logout}" rel="nofollow">
      <i class="material-icons" aria-hidden="true">logout</i>
      <span>{l s='Sign out' d='Shop.Theme.Actions'}</span>
    </a>
    <a class="account" href="{$urls.pages.my_account}" title="{l s='View my customer account' d='Shop.Theme.Customeraccount'}" rel="nofollow">
      <i class="material-icons" aria-hidden="true">person</i>
      <span>{$customerName}</span>
    </a>
  {else}
    <a class="login" href="{$urls.pages.authentication}?back={$urls.current_url|urlencode}" title="{l s='Log in to your customer account' d='Shop.Theme.Customeraccount'}" rel="nofollow">
      <i class="material-icons" aria-hidden="true">person_outline</i>
      <span>{l s='Sign in' d='Shop.Theme.Actions'}</span>
    </a>
  {/if}
</div>
