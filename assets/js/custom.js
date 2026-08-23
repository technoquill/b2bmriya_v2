/**
 * B2B Mriya v2 storefront behavior.
 *
 * PrestaShop core.js and Classic theme.js are inherited from the parent. This
 * file implements only the legacy shell interactions and a small compatibility
 * layer for active CP modules that formerly depended on the global Owl bundle.
 */

(() => {
  'use strict';

  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
  let lastFocusedElement = null;

  const scrollCarousel = (element, direction) => {
    if (!element) {
      return;
    }

    const distance = Math.max(element.clientWidth * 0.82, 240);
    element.scrollBy({
      left: direction * distance,
      behavior: reducedMotion.matches ? 'auto' : 'smooth',
    });
  };

  /**
   * The category-products module still calls the Owl 1 API. Keep that module
   * from throwing while presenting the same content as a native scroll-snap
   * carousel. No legacy Owl code is loaded.
   */
  const installOwlCompatibility = () => {
    if (!window.jQuery || window.jQuery.fn.owlCarousel) {
      return;
    }

    const $ = window.jQuery;

    $.fn.owlCarousel = function owlCarouselCompatibility() {
      return this.each(function initializeCarousel() {
        const element = this;

        element.dataset.b2bCarouselReady = 'true';
        element.setAttribute('role', 'region');
        element.setAttribute('aria-roledescription', 'carousel');
        element.setAttribute('tabindex', '0');

        $(element)
          .off('.b2bCompatibility')
          .on('owl.next.b2bCompatibility', () => scrollCarousel(element, 1))
          .on('owl.prev.b2bCompatibility', () => scrollCarousel(element, -1));
      });
    };

    $.fn.owlCarousel.b2bCompatibility = true;
  };

  installOwlCompatibility();

  const hydrateLazyImages = (root = document) => {
    const images = [];

    if (root.matches?.('img[data-src]')) {
      images.push(root);
    }

    if (root.querySelectorAll) {
      images.push(...root.querySelectorAll('img[data-src]'));
    }

    images.forEach((image) => {
      image.loading = image.loading || 'lazy';

      if (image.dataset.src) {
        image.src = image.dataset.src;
      }

      if (image.dataset.srcset) {
        image.srcset = image.dataset.srcset;
      }

      image.classList.remove('lazyload');
    });
  };

  const getOverlay = () => document.querySelector('[data-b2b-overlay]');

  const showOverlay = () => {
    const overlay = getOverlay();

    if (!overlay) {
      return;
    }

    overlay.hidden = false;
    window.requestAnimationFrame(() => overlay.classList.add('is-visible'));
  };

  const hideOverlay = () => {
    const overlay = getOverlay();

    if (!overlay) {
      return;
    }

    overlay.classList.remove('is-visible');
    window.setTimeout(() => {
      if (!document.querySelector('.b2b-mini-cart.is-open, #cp_sidevertical_menu_top.slide')) {
        overlay.hidden = true;
      }
    }, reducedMotion.matches ? 0 : 180);
  };

  const openCart = (trigger) => {
    const panel = document.querySelector('.b2b-mini-cart');

    if (!panel) {
      return false;
    }

    closeVerticalMenu({ restoreFocus: false });
    lastFocusedElement = trigger;
    panel.removeAttribute('inert');
    panel.classList.add('is-open');
    panel.setAttribute('aria-hidden', 'false');
    trigger.setAttribute('aria-expanded', 'true');
    document.body.classList.add('b2b-panel-open');
    showOverlay();

    const closeButton = panel.querySelector('[data-b2b-cart-close]');
    if (closeButton) {
      closeButton.focus();
    }

    return true;
  };

  const closeCart = ({ restoreFocus = true } = {}) => {
    const panel = document.querySelector('.b2b-mini-cart');
    const trigger = document.querySelector('[data-b2b-cart-open]');

    if (!panel || !panel.classList.contains('is-open')) {
      return;
    }

    panel.classList.remove('is-open');
    panel.setAttribute('aria-hidden', 'true');
    panel.setAttribute('inert', '');

    if (trigger) {
      trigger.setAttribute('aria-expanded', 'false');
    }

    document.body.classList.remove('b2b-panel-open');
    hideOverlay();

    if (restoreFocus && lastFocusedElement && document.contains(lastFocusedElement)) {
      lastFocusedElement.focus();
    }
  };

  const openVerticalMenu = (trigger) => {
    const menu = document.querySelector('#cp_sidevertical_menu_top');

    if (!menu) {
      return;
    }

    closeCart({ restoreFocus: false });
    lastFocusedElement = trigger;
    menu.removeAttribute('inert');
    menu.classList.add('slide');
    menu.setAttribute('aria-hidden', 'false');
    document.body.classList.add('b2b-panel-open');
    trigger.setAttribute('aria-expanded', 'true');
    showOverlay();

    menu.querySelector('[data-b2b-menu-close]')?.focus();
  };

  const closeVerticalMenu = ({ restoreFocus = true } = {}) => {
    const menu = document.querySelector('#cp_sidevertical_menu_top');
    const trigger = document.querySelector('[data-b2b-menu-open]');

    if (!menu || !menu.classList.contains('slide')) {
      return;
    }

    menu.classList.remove('slide');
    menu.setAttribute('aria-hidden', 'true');
    menu.setAttribute('inert', '');
    document.body.classList.remove('b2b-panel-open');

    if (trigger) {
      trigger.setAttribute('aria-expanded', 'false');
    }

    hideOverlay();

    if (restoreFocus && lastFocusedElement && document.contains(lastFocusedElement)) {
      lastFocusedElement.focus();
    }
  };

  const closePanels = (options) => {
    closeCart(options);
    closeVerticalMenu(options);
  };

  const trapPanelFocus = (event) => {
    if (event.key !== 'Tab') {
      return;
    }

    const panel = document.querySelector('.b2b-mini-cart.is-open, #cp_sidevertical_menu_top.slide');
    if (!panel) {
      return;
    }

    const focusable = Array.from(
      panel.querySelectorAll('a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])'),
    ).filter((element) => !element.hidden && element.offsetParent !== null);

    if (!focusable.length) {
      return;
    }

    const first = focusable[0];
    const last = focusable[focusable.length - 1];

    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  };

  const initializeCarousels = () => {
    document.querySelectorAll('.cp-carousel').forEach((carousel) => {
      carousel.setAttribute('role', 'region');
      carousel.setAttribute('aria-roledescription', 'carousel');
      carousel.setAttribute('tabindex', '0');
      carousel.dataset.b2bCarouselReady = 'true';
    });

    if (window.jQuery && window.jQuery.fn.owlCarousel?.b2bCompatibility) {
      window.jQuery('.cp-carousel').owlCarousel();
    }

    document.querySelectorAll('.customNavigation .prev, .customNavigation .next').forEach((control) => {
      control.setAttribute('role', 'button');
      control.setAttribute('tabindex', '0');
      control.setAttribute(
        'aria-label',
        control.classList.contains('next') ? 'Next products' : 'Previous products',
      );
    });
  };

  const initializeHomeSlider = () => {
    if (!window.jQuery || !window.jQuery.fn.flexslider) {
      return;
    }

    window.jQuery('.b2b-home-slider').each(function initializeSlider() {
      const slider = window.jQuery(this);

      if (slider.data('flexslider')) {
        return;
      }

      slider.flexslider({
        animation: reducedMotion.matches ? 'fade' : 'slide',
        slideshow: !reducedMotion.matches,
        slideshowSpeed: Number(slider.data('interval')) || 5500,
        pauseOnHover: Boolean(Number(slider.data('pause'))),
        keyboard: true,
        touch: true,
      });
    });
  };

  const decodeText = (value) => {
    const documentFragment = new DOMParser().parseFromString(String(value || ''), 'text/html');
    return documentFragment.body.textContent || '';
  };

  const initializeSearch = () => {
    document.querySelectorAll('[data-b2b-search]').forEach((search, searchIndex) => {
      if (search.dataset.b2bSearchReady === 'true') {
        return;
      }

      const form = search.querySelector('.b2b-search-form');
      const input = search.querySelector('.b2b-search-input');
      const results = search.querySelector('[data-b2b-search-results]');
      const status = search.querySelector('[data-b2b-search-status]');
      const endpoint = search.dataset.searchUrl;
      const minimumLength = Number(search.dataset.minLength) || 3;

      if (!form || !input || !results || !status || !endpoint) {
        return;
      }

      search.dataset.b2bSearchReady = 'true';
      let activeIndex = -1;
      let requestController = null;
      let requestTimer = null;

      const getOptions = () => Array.from(results.querySelectorAll('[role="option"]'));

      const setExpanded = (expanded) => {
        results.hidden = !expanded;
        input.setAttribute('aria-expanded', String(expanded));

        if (!expanded) {
          activeIndex = -1;
          input.removeAttribute('aria-activedescendant');
        }
      };

      const setActiveOption = (index) => {
        const options = getOptions();

        if (!options.length) {
          return;
        }

        activeIndex = (index + options.length) % options.length;
        options.forEach((option, optionIndex) => {
          option.setAttribute('aria-selected', String(optionIndex === activeIndex));
        });
        input.setAttribute('aria-activedescendant', options[activeIndex].id);
        options[activeIndex].scrollIntoView({ block: 'nearest' });
      };

      const renderMessage = (message, className = '') => {
        const messageElement = document.createElement('p');
        messageElement.className = `b2b-search-message ${className}`.trim();
        messageElement.textContent = message;
        results.replaceChildren(messageElement);
        status.textContent = message;
        setExpanded(true);
      };

      const getProductImage = (product) => (
        product.cover?.bySize?.small_default
        || window.prestashop?.urls?.no_picture_image?.bySize?.small_default
        || null
      );

      const renderProducts = (products, term) => {
        if (!products.length) {
          renderMessage(search.dataset.emptyText);
          return;
        }

        const list = document.createElement('ul');
        list.className = 'b2b-search-list';
        const safeProducts = products.slice(0, 8);

        safeProducts.forEach((product, productIndex) => {
          const item = document.createElement('li');
          const link = document.createElement('a');
          const imageData = getProductImage(product);
          const copy = document.createElement('span');
          const name = document.createElement('strong');

          link.id = `b2b-search-option-${searchIndex}-${productIndex}`;
          link.className = 'b2b-search-product';
          link.href = product.url || product.link || form.action;
          link.setAttribute('role', 'option');
          link.setAttribute('aria-selected', 'false');

          if (imageData?.url) {
            const image = document.createElement('img');
            image.src = imageData.url;
            image.alt = '';
            image.loading = 'lazy';

            if (imageData.width) {
              image.width = imageData.width;
            }

            if (imageData.height) {
              image.height = imageData.height;
            }

            link.append(image);
          }

          copy.className = 'b2b-search-product-copy';
          name.textContent = decodeText(product.name);
          copy.append(name);

          if (product.category_name) {
            const category = document.createElement('small');
            category.textContent = decodeText(product.category_name);
            copy.append(category);
          }

          if (product.price) {
            const price = document.createElement('span');
            price.className = 'b2b-search-product-price';
            price.textContent = decodeText(product.price);
            copy.append(price);
          }

          link.append(copy);
          item.append(link);
          list.append(item);
        });

        const allResultsUrl = new URL(form.action, window.location.href);
        allResultsUrl.searchParams.set('s', term);

        const allResultsLink = document.createElement('a');
        allResultsLink.className = 'b2b-search-all';
        allResultsLink.href = allResultsUrl.toString();
        allResultsLink.textContent = search.dataset.viewAllText;

        results.replaceChildren(list, allResultsLink);
        status.textContent = `${safeProducts.length} ${search.dataset.viewAllText}`;
        setExpanded(true);
      };

      const requestResults = async () => {
        const term = input.value.trim();

        if (!term) {
          setExpanded(false);
          status.textContent = '';
          return;
        }

        if (term.length < minimumLength) {
          renderMessage(search.dataset.minLengthText);
          return;
        }

        requestController?.abort();
        requestController = new AbortController();
        renderMessage(search.dataset.loadingText, 'is-loading');

        try {
          const response = await fetch(endpoint, {
            method: 'POST',
            credentials: 'same-origin',
            headers: {
              Accept: 'application/json',
              'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: new URLSearchParams({ s: term, resultsPerPage: '8' }),
            signal: requestController.signal,
          });

          if (!response.ok) {
            throw new Error(`Search request failed with HTTP ${response.status}`);
          }

          const payload = await response.json();

          if (input.value.trim() === term) {
            renderProducts(Array.isArray(payload.products) ? payload.products : [], term);
          }
        } catch (error) {
          if (error.name !== 'AbortError') {
            renderMessage(search.dataset.errorText, 'is-error');
          }
        }
      };

      input.addEventListener('input', () => {
        requestController?.abort();
        window.clearTimeout(requestTimer);
        requestTimer = window.setTimeout(requestResults, 250);
      });

      input.addEventListener('keydown', (event) => {
        const options = getOptions();

        if (event.key === 'ArrowDown' && options.length) {
          event.preventDefault();
          setActiveOption(activeIndex + 1);
        } else if (event.key === 'ArrowUp' && options.length) {
          event.preventDefault();
          setActiveOption(activeIndex - 1);
        } else if (event.key === 'Enter' && activeIndex >= 0 && options[activeIndex]) {
          event.preventDefault();
          options[activeIndex].click();
        } else if (event.key === 'Escape') {
          setExpanded(false);
        }
      });

      document.addEventListener('click', (event) => {
        if (!search.contains(event.target)) {
          setExpanded(false);
        }
      });
    });
  };

  const initialize = () => {
    hydrateLazyImages();
    initializeCarousels();
    initializeSearch();

    const menuTrigger = document.querySelector('[data-b2b-menu-open]');
    if (menuTrigger) {
      menuTrigger.setAttribute('aria-expanded', 'false');
      menuTrigger.setAttribute('aria-controls', 'cp_sidevertical_menu_top');
    }

    const topButton = document.querySelector('.top_button');
    const updateTopButton = () => {
      if (topButton) {
        topButton.classList.toggle('is-visible', window.scrollY > 500);
      }
    };

    updateTopButton();
    window.addEventListener('scroll', updateTopButton, { passive: true });

    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === Node.ELEMENT_NODE) {
            hydrateLazyImages(node);
          }
        });
      });
    });

    observer.observe(document.body, { childList: true, subtree: true });
  };

  document.addEventListener('click', (event) => {
    const cartTrigger = event.target.closest('[data-b2b-cart-open]');
    if (cartTrigger && openCart(cartTrigger)) {
      event.preventDefault();
      return;
    }

    if (event.target.closest('[data-b2b-cart-close]')) {
      closeCart();
      return;
    }

    const submenuToggle = event.target.closest('[data-b2b-submenu-toggle]');
    if (submenuToggle) {
      event.preventDefault();

      const submenu = document.getElementById(submenuToggle.getAttribute('aria-controls'));
      if (submenu) {
        const expanded = submenuToggle.getAttribute('aria-expanded') === 'true';
        submenuToggle.setAttribute('aria-expanded', String(!expanded));
        submenu.hidden = expanded;
        submenu.classList.toggle('in', !expanded);
      }
      return;
    }

    const menuOpen = event.target.closest('[data-b2b-menu-open]');
    if (menuOpen) {
      event.preventDefault();
      openVerticalMenu(menuOpen);
      return;
    }

    if (event.target.closest('[data-b2b-menu-close]')) {
      event.preventDefault();
      closeVerticalMenu();
      return;
    }

    if (event.target.closest('[data-b2b-overlay]')) {
      closePanels();
      return;
    }

    const carouselControl = event.target.closest('.customNavigation .prev, .customNavigation .next');
    if (carouselControl && !carouselControl.matches('.cpcategory_prev, .cpcategory_next')) {
      const section = carouselControl.closest('section, .special_container, .category-tab-content');
      const carousel = section?.querySelector('.cp-carousel');
      scrollCarousel(carousel, carouselControl.classList.contains('next') ? 1 : -1);
      return;
    }

    if (event.target.closest('.top_button')) {
      window.scrollTo({ top: 0, behavior: reducedMotion.matches ? 'auto' : 'smooth' });
    }
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      closePanels();
      return;
    }

    trapPanelFocus(event);

    if ((event.key === 'Enter' || event.key === ' ') && event.target.matches('.customNavigation .prev, .customNavigation .next')) {
      event.preventDefault();
      event.target.click();
    }
  });

  if (window.prestashop?.on) {
    window.prestashop.on('updateCart', () => closeCart({ restoreFocus: false }));
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initialize, { once: true });
  } else {
    initialize();
  }

  if (document.readyState === 'complete') {
    initializeHomeSlider();
  } else {
    window.addEventListener('load', initializeHomeSlider, { once: true });
  }
})();
