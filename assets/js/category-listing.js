/* Presentation adapters for category listings; filtering and commerce remain native. */
(() => {
  const initialize = () => {
    if (document.body.id !== 'category') return;
    const filter = document.getElementById('amazzing_filter');
    const content = document.getElementById('content-wrapper');
    const strings = document.getElementById('b2b-listing-i18n')?.dataset;
    if (!content || !strings) return;
    let scheduled = false;
    let wasOpen = false;
    const setText = (element, text) => {
      if (element && element.textContent !== text) element.textContent = text;
    };
    const toggle = () => filter?.querySelector('.compact-toggle')?.click();
    const sync = () => {
      scheduled = false;
      const compact = !!filter && document.body.classList.contains('has-compact-filter');
      const open = compact && document.body.classList.contains('show-filter');
      const sort = content.querySelector('.sort-by-row');
      if (filter) {
        if (sort && !sort.querySelector('.b2b-filter-open')) {
          const button = document.createElement('button');
          button.type = 'button';
          button.className = 'btn b2b-filter-open';
          button.textContent = strings.filters;
          button.setAttribute('aria-controls', 'amazzing_filter');
          button.addEventListener('click', toggle);
          sort.prepend(button);
        }
        if (!filter.querySelector('.b2b-filter-heading')) {
          const heading = document.createElement('div');
          heading.className = 'b2b-filter-heading';
          heading.innerHTML = '<strong id="b2b-filter-title"></strong><button type="button" class="b2b-filter-close">×</button>';
          setText(heading.querySelector('strong'), strings.filters);
          heading.querySelector('button').setAttribute('aria-label', strings.closeFilters);
          heading.querySelector('button').addEventListener('click', toggle);
          filter.prepend(heading);
          const reset = document.createElement('button');
          reset.type = 'button';
          reset.className = 'b2b-filter-reset';
          reset.textContent = strings.resetFilters;
          reset.addEventListener('click', () => filter.querySelector('.clearAll .all')?.click());
          filter.querySelector('.btn-holder')?.prepend(reset);
        }
        content.querySelector('.b2b-filter-open')?.setAttribute('aria-expanded', String(open));
        filter.inert = compact && !open;
        if (open) {
          filter.setAttribute('role', 'dialog');
          filter.setAttribute('aria-modal', 'true');
          filter.setAttribute('aria-labelledby', 'b2b-filter-title');
        } else {
          filter.removeAttribute('role');
          filter.removeAttribute('aria-modal');
          filter.removeAttribute('aria-labelledby');
        }
        filter.querySelectorAll('.af_subtitle').forEach(el => {
          if (!el.hasAttribute('tabindex')) {
            el.tabIndex = 0;
            el.setAttribute('role', 'button');
            el.addEventListener('keydown', event => {
              if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); el.click(); }
            });
          }
          el.setAttribute('aria-expanded', String(!el.closest('.af_filter').classList.contains('closed')));
        });
      }
      content.querySelectorAll('.st-compare-button').forEach(button => {
        const added = button.classList.contains('added');
        const text = added ? strings.inComparison : strings.compare;
        setText(button.querySelector('.st-compare-title'), text);
        // The comparison module already translates its title and updates it
        // when selection changes; reuse that text for the accessible name.
        const label = button.title;
        if (button.getAttribute('aria-label') !== label) button.setAttribute('aria-label', label);
      });
      if (open !== wasOpen) {
        if (open) filter.querySelector('.b2b-filter-close')?.focus();
        else content.querySelector('.b2b-filter-open')?.focus({preventScroll: true});
        wasOpen = open;
      }
    };
    const schedule = () => {
      if (!scheduled) { scheduled = true; requestAnimationFrame(sync); }
    };
    new MutationObserver(schedule).observe(content, { childList: true, subtree: true, attributes: true, attributeFilter: ['class'] });
    if (filter) new MutationObserver(schedule).observe(filter, { childList: true, characterData: true, subtree: true, attributes: true, attributeFilter: ['class'] });
    new MutationObserver(schedule).observe(document.body, { attributes: true, attributeFilter: ['class'] });
    document.addEventListener('keydown', event => {
      if (!filter || !document.body.classList.contains('has-compact-filter') || !document.body.classList.contains('show-filter')) return;
      if (event.key === 'Escape') { event.preventDefault(); toggle(); return; }
      if (event.key !== 'Tab') return;
      const items = Array.from(filter.querySelectorAll('a[href], button, input, select, [tabindex="0"]')).filter(el => !el.disabled && el.getClientRects().length && getComputedStyle(el).visibility !== 'hidden');
      const first = items[0], last = items[items.length - 1];
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last?.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first?.focus(); }
    });
    // Amazzing Filter replaces miniatures without emitting PrestaShop's list event.
    // Rebind the installed comparison module to the new buttons after replacement.
    if (filter && window.jQuery) window.jQuery(filter).on('updateProductList.b2bListing', () => {
      if (window.StCompareButtonAction) {
        window.jQuery('.st-compare-button').off('click');
        window.StCompareButtonAction();
      }
      schedule();
    });
    sync();
  };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initialize, {once: true});
  else initialize();
})();
