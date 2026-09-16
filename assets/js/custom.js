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
  let keepCartOpenAfterRefresh = false;
  let cartRefreshTimeout = null;

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

  const syncEmptyProductMessages = (root = document) => {
    const messages = root.matches?.('.product-minimal-quantity')
      ? [root]
      : Array.from(root.querySelectorAll?.('.product-minimal-quantity') || []);

    messages.forEach((message) => {
      message.hidden = message.textContent.trim() === '';
    });
  };

  const syncHeaderCounters = () => {
    const selector = '.cart-products-counthome, .ap-total-wishlist, .ap-total-compare';

    document.querySelectorAll(selector).forEach((counter) => {
      const count = Number.parseInt(counter.textContent.trim(), 10);
      counter.classList.toggle('is-empty', Number.isFinite(count) && count <= 0);
    });
  };

  /**
   * Replaces obfuscated email spans (for example, "name at domain dot ua")
   * with clickable mailto links.
   */
  const emailsMask = (root = document) => {
    const emailSpans = root.matches?.('span.mail')
      ? [root]
      : Array.from(root.querySelectorAll?.('span.mail') || []);

    emailSpans.forEach((emailSpan) => {
      const address = emailSpan.textContent
        .trim()
        .replace(/ at /i, '@')
        .replace(/ dot /gi, '.');

      if (!address.includes('@')) {
        return;
      }

      const link = document.createElement('a');
      const text = document.createElement('span');

      link.className = 'mail';
      link.href = `mailto:${address}`;
      text.textContent = address;
      link.appendChild(text);
      emailSpan.replaceWith(link);
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

  const openCart = (trigger, { focusClose = true } = {}) => {
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
    if (focusClose && closeButton) {
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

    keepCartOpenAfterRefresh = false;
    window.clearTimeout(cartRefreshTimeout);
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

  const preserveOpenCartDuringRefresh = () => {
    keepCartOpenAfterRefresh = true;
    window.clearTimeout(cartRefreshTimeout);
    cartRefreshTimeout = window.setTimeout(() => {
      keepCartOpenAfterRefresh = false;
    }, 10000);
  };

  const restoreOpenCartAfterRefresh = (root) => {
    if (!keepCartOpenAfterRefresh) {
      return;
    }

    const blockcart = root.matches?.('.b2b-blockcart')
      ? root
      : root.querySelector?.('.b2b-blockcart');
    const trigger = blockcart?.querySelector('[data-b2b-cart-open]');

    if (!trigger) {
      return;
    }

    keepCartOpenAfterRefresh = false;
    window.clearTimeout(cartRefreshTimeout);
    openCart(trigger, { focusClose: false });
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
      const searchToggle = search.querySelector('[data-b2b-search-toggle]');
      const endpoint = search.dataset.searchUrl;
      const minimumLength = Number(search.dataset.minLength) || 3;

      if (!form || !input || !results || !status || !endpoint) {
        return;
      }

      search.dataset.b2bSearchReady = 'true';
      let activeIndex = -1;
      let requestController = null;
      let requestTimer = null;

      form.addEventListener('submit', (event) => {
        if (!input.value.trim()) {
          event.preventDefault();
          setExpanded(false);
          input.focus();
        }
      });

      const getOptions = () => Array.from(results.querySelectorAll('[role="option"]'));

      const setExpanded = (expanded) => {
        results.hidden = !expanded;
        input.setAttribute('aria-expanded', String(expanded));

        if (!expanded) {
          activeIndex = -1;
          input.removeAttribute('aria-activedescendant');
        }
      };

      const setMobileSearchOpen = (open) => {
        search.classList.toggle('is-open', open);
        searchToggle?.setAttribute('aria-expanded', String(open));

        if (open) {
          window.requestAnimationFrame(() => input.focus());
        } else {
          setExpanded(false);
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
        status.textContent = search.dataset.resultsText.replace('%count%', safeProducts.length);
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

      searchToggle?.addEventListener('click', () => {
        setMobileSearchOpen(!search.classList.contains('is-open'));
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
          setMobileSearchOpen(false);
          searchToggle?.focus();
        }
      });

      document.addEventListener('click', (event) => {
        if (!search.contains(event.target)) {
          setExpanded(false);
          setMobileSearchOpen(false);
        }
      });
    });
  };

  const initialize = () => {
    hydrateLazyImages();
    syncEmptyProductMessages();
    syncHeaderCounters();
    emailsMask();
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
            emailsMask(node);
            restoreOpenCartAfterRefresh(node);
          }
        });
      });

      syncEmptyProductMessages();
      syncHeaderCounters();
    });

    observer.observe(document.body, { childList: true, subtree: true });
  };

  document.addEventListener('click', (event) => {
    const productTab = event.target.closest('.b2b-product-tabs [role="tab"]');
    if (productTab) {
      productTab.closest('[role="tablist"]')?.querySelectorAll('[role="tab"]').forEach((tab) => {
        tab.setAttribute('aria-selected', String(tab === productTab));
      });
    }

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
    window.prestashop.on('updateCart', () => {
      if (document.querySelector('.b2b-mini-cart.is-open')) {
        preserveOpenCartDuringRefresh();
      }
    });
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

/**
 * Product gallery and full-screen image viewer.
 *
 * Events are delegated because PrestaShop replaces both the cover and the
 * lightbox when a product combination changes.
 */
(() => {
  'use strict';

  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
  let activeGallery = null;
  let lastFocusedElement = null;
  let touchState = null;
  let pinchState = null;

  const getElements = (root, selector) => {
    const elements = [];

    if (root.matches?.(selector)) {
      elements.push(root);
    }

    if (root.querySelectorAll) {
      elements.push(...root.querySelectorAll(selector));
    }

    return elements;
  };

  const normalizeIndex = (index, count) => {
    if (!count) {
      return 0;
    }

    return ((Number(index) % count) + count) % count;
  };

  const parseSources = (value) => {
    if (!value) {
      return {};
    }

    try {
      return JSON.parse(value);
    } catch (error) {
      return {};
    }
  };

  const getSourceUrl = (sources, mimeType) => {
    const format = mimeType.replace('image/', '');
    const directSource = sources[format] || sources[mimeType];

    if (typeof directSource === 'string') {
      return directSource;
    }

    if (directSource && typeof directSource === 'object') {
      return directSource.url || directSource.src || directSource.srcset || '';
    }

    if (Array.isArray(sources)) {
      const matchingSource = sources.find((source) => (
        source?.type === mimeType || source?.type === format || source?.format === format
      ));

      if (matchingSource) {
        return matchingSource.url || matchingSource.src || matchingSource.srcset || '';
      }
    }

    return '';
  };

  const updatePicture = (image, item) => {
    if (!image || !item) {
      return;
    }

    const picture = image.closest('picture');
    const sources = parseSources(item.dataset.imageSources);

    picture?.querySelectorAll('source').forEach((source) => {
      const sourceUrl = getSourceUrl(sources, source.type);

      if (sourceUrl) {
        source.srcset = sourceUrl;
      } else {
        source.removeAttribute('srcset');
      }
    });

    image.src = item.dataset.imageSrc;
    image.alt = item.dataset.imageAlt || '';

    if (item.dataset.imageTitle) {
      image.title = item.dataset.imageTitle;
    } else {
      image.removeAttribute('title');
    }
  };

  const centerItem = (scroller, item, smooth = true) => {
    if (!scroller || !item || scroller.scrollWidth <= scroller.clientWidth) {
      return;
    }

    const left = item.offsetLeft - ((scroller.clientWidth - item.offsetWidth) / 2);
    scroller.scrollTo({
      left: Math.max(0, left),
      behavior: smooth && !reducedMotion.matches ? 'smooth' : 'auto',
    });
  };

  const updateStripControls = (gallery) => {
    const strip = gallery?.querySelector('[data-b2b-gallery-strip]');
    const previous = gallery?.querySelector('[data-b2b-gallery-strip-previous]');
    const next = gallery?.querySelector('[data-b2b-gallery-strip-next]');

    if (!strip || !previous || !next) {
      return;
    }

    previous.disabled = strip.scrollLeft <= 2;
    next.disabled = strip.scrollLeft + strip.clientWidth >= strip.scrollWidth - 2;
  };

  const setLightboxScale = (lightbox, scale) => {
    if (!lightbox) {
      return;
    }

    const normalizedScale = Math.min(3, Math.max(1, Number(scale) || 1));
    const image = lightbox.querySelector('[data-b2b-lightbox-image]');
    const zoomButton = lightbox.querySelector('[data-b2b-lightbox-zoom]');
    const isZoomed = normalizedScale > 1.01;

    lightbox.dataset.scale = String(normalizedScale);
    lightbox.classList.toggle('is-zoomed', isZoomed);
    image?.style.setProperty('--b2b-gallery-scale', String(normalizedScale));

    if (zoomButton) {
      zoomButton.setAttribute('aria-pressed', String(isZoomed));
      zoomButton.setAttribute('aria-label', isZoomed ? 'Зменшити фото' : 'Збільшити фото');
    }

    if (!isZoomed) {
      lightbox.querySelector('[data-b2b-lightbox-stage]')?.scrollTo({ top: 0, left: 0 });
    }
  };

  const setLightboxIndex = (lightbox, index, { scroll = true } = {}) => {
    const items = Array.from(lightbox?.querySelectorAll('[data-b2b-lightbox-thumbnail]') || []);

    if (!lightbox || !items.length) {
      return;
    }

    const nextIndex = normalizeIndex(index, items.length);
    const selectedItem = items[nextIndex];
    const image = lightbox.querySelector('[data-b2b-lightbox-image]');
    const current = lightbox.querySelector('[data-b2b-lightbox-current]');

    updatePicture(image, selectedItem);
    lightbox.dataset.currentIndex = String(nextIndex);

    if (current) {
      current.textContent = String(nextIndex + 1);
    }

    items.forEach((item, itemIndex) => {
      const selected = itemIndex === nextIndex;
      item.classList.toggle('is-selected', selected);
      item.setAttribute('aria-current', String(selected));
    });

    setLightboxScale(lightbox, 1);

    if (scroll) {
      centerItem(lightbox.querySelector('[data-b2b-lightbox-strip]'), selectedItem);
    }
  };

  const getLightbox = (gallery) => {
    const lightboxId = gallery?.querySelector('[data-b2b-gallery-open]')?.getAttribute('aria-controls');
    return lightboxId ? document.getElementById(lightboxId) : null;
  };

  const setGalleryIndex = (gallery, index, { scroll = true, syncLightbox = true } = {}) => {
    const items = Array.from(gallery?.querySelectorAll('[data-b2b-gallery-thumbnail]') || []);

    if (!gallery || !items.length) {
      return;
    }

    const nextIndex = normalizeIndex(index, items.length);
    const selectedItem = items[nextIndex];
    const image = gallery.querySelector('[data-b2b-gallery-cover]');
    const current = gallery.querySelector('[data-b2b-gallery-current]');

    updatePicture(image, selectedItem);
    gallery.dataset.currentIndex = String(nextIndex);

    if (current) {
      current.textContent = String(nextIndex + 1);
    }

    items.forEach((item, itemIndex) => {
      const selected = itemIndex === nextIndex;
      item.classList.toggle('is-selected', selected);
      item.setAttribute('aria-current', String(selected));
    });

    if (scroll) {
      centerItem(gallery.querySelector('[data-b2b-gallery-strip]'), selectedItem);
    }

    if (syncLightbox) {
      const lightbox = getLightbox(gallery);
      if (lightbox?.classList.contains('is-open')) {
        setLightboxIndex(lightbox, nextIndex);
      }
    }
  };

  const moveGallery = (gallery, direction) => {
    const currentIndex = Number(gallery?.dataset.currentIndex) || 0;
    setGalleryIndex(gallery, currentIndex + direction);
  };

  const moveLightbox = (lightbox, direction) => {
    const currentIndex = Number(lightbox?.dataset.currentIndex) || 0;
    setLightboxIndex(lightbox, currentIndex + direction);

    if (activeGallery) {
      setGalleryIndex(activeGallery, currentIndex + direction, {
        scroll: true,
        syncLightbox: false,
      });
    }
  };

  const openLightbox = (gallery, trigger) => {
    const lightbox = getLightbox(gallery);

    if (!lightbox || gallery.closest('.quickview')) {
      return;
    }

    activeGallery = gallery;
    lastFocusedElement = trigger;
    setLightboxIndex(lightbox, Number(gallery.dataset.currentIndex) || 0, { scroll: false });
    lightbox.hidden = false;
    lightbox.setAttribute('aria-hidden', 'false');
    lightbox.classList.add('is-open');
    document.body.classList.add('b2b-gallery-open');
    lightbox.querySelector('[data-b2b-lightbox-close]')?.focus();
  };

  const getOpenLightbox = () => document.querySelector('[data-b2b-gallery-lightbox].is-open');

  const closeLightbox = ({ restoreFocus = true } = {}) => {
    const lightbox = getOpenLightbox();

    if (!lightbox) {
      return;
    }

    lightbox.classList.remove('is-open');
    lightbox.setAttribute('aria-hidden', 'true');
    lightbox.hidden = true;
    setLightboxScale(lightbox, 1);
    document.body.classList.remove('b2b-gallery-open');

    if (restoreFocus && lastFocusedElement && document.contains(lastFocusedElement)) {
      lastFocusedElement.focus();
    }

    activeGallery = null;
    lastFocusedElement = null;
  };

  const trapLightboxFocus = (event, lightbox) => {
    if (event.key !== 'Tab') {
      return;
    }

    const focusable = Array.from(lightbox.querySelectorAll('button:not([disabled]), [tabindex]:not([tabindex="-1"])'))
      .filter((element) => element.offsetParent !== null);

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

  const initializeGallery = (gallery) => {
    if (gallery.dataset.b2bGalleryReady === 'true') {
      return;
    }

    gallery.dataset.b2bGalleryReady = 'true';
    const items = Array.from(gallery.querySelectorAll('[data-b2b-gallery-thumbnail]'));
    const selectedIndex = Math.max(0, items.findIndex((item) => item.classList.contains('is-selected')));
    const openButton = gallery.querySelector('[data-b2b-gallery-open]');
    const strip = gallery.querySelector('[data-b2b-gallery-strip]');

    if (openButton && (gallery.closest('.quickview') || !getLightbox(gallery))) {
      openButton.disabled = true;
      openButton.removeAttribute('aria-controls');
    }

    if (items.length) {
      setGalleryIndex(gallery, selectedIndex, { scroll: false, syncLightbox: false });
    }

    if (strip) {
      strip.addEventListener('scroll', () => updateStripControls(gallery), { passive: true });
      window.requestAnimationFrame(() => updateStripControls(gallery));
    }
  };

  const initializeLightbox = (lightbox) => {
    if (lightbox.dataset.b2bLightboxReady === 'true') {
      return;
    }

    lightbox.dataset.b2bLightboxReady = 'true';
    const items = Array.from(lightbox.querySelectorAll('[data-b2b-lightbox-thumbnail]'));
    const selectedIndex = Math.max(0, items.findIndex((item) => item.classList.contains('is-selected')));

    if (items.length) {
      setLightboxIndex(lightbox, selectedIndex, { scroll: false });
    }
  };

  const initializeProductGalleries = (root = document) => {
    getElements(root, '[data-b2b-gallery]').forEach(initializeGallery);
    getElements(root, '[data-b2b-gallery-lightbox]').forEach(initializeLightbox);
  };

  document.addEventListener('click', (event) => {
    const galleryThumbnail = event.target.closest('[data-b2b-gallery-thumbnail]');
    if (galleryThumbnail) {
      event.preventDefault();
      setGalleryIndex(
        galleryThumbnail.closest('[data-b2b-gallery]'),
        Number(galleryThumbnail.dataset.index),
      );
      return;
    }

    const galleryPrevious = event.target.closest('[data-b2b-gallery-previous]');
    if (galleryPrevious) {
      event.preventDefault();
      moveGallery(galleryPrevious.closest('[data-b2b-gallery]'), -1);
      return;
    }

    const galleryNext = event.target.closest('[data-b2b-gallery-next]');
    if (galleryNext) {
      event.preventDefault();
      moveGallery(galleryNext.closest('[data-b2b-gallery]'), 1);
      return;
    }

    const stripControl = event.target.closest('[data-b2b-gallery-strip-previous], [data-b2b-gallery-strip-next]');
    if (stripControl) {
      event.preventDefault();
      const gallery = stripControl.closest('[data-b2b-gallery]');
      const strip = gallery?.querySelector('[data-b2b-gallery-strip]');
      const direction = stripControl.hasAttribute('data-b2b-gallery-strip-next') ? 1 : -1;

      strip?.scrollBy({
        left: direction * Math.max(240, strip.clientWidth * 0.8),
        behavior: reducedMotion.matches ? 'auto' : 'smooth',
      });
      return;
    }

    const openButton = event.target.closest('[data-b2b-gallery-open]');
    if (openButton) {
      event.preventDefault();
      openLightbox(openButton.closest('[data-b2b-gallery]'), openButton);
      return;
    }

    const lightboxThumbnail = event.target.closest('[data-b2b-lightbox-thumbnail]');
    if (lightboxThumbnail) {
      event.preventDefault();
      const lightbox = lightboxThumbnail.closest('[data-b2b-gallery-lightbox]');
      const index = Number(lightboxThumbnail.dataset.index);
      setLightboxIndex(lightbox, index);

      if (activeGallery) {
        setGalleryIndex(activeGallery, index, { scroll: true, syncLightbox: false });
      }
      return;
    }

    const lightboxPrevious = event.target.closest('[data-b2b-lightbox-previous]');
    if (lightboxPrevious) {
      event.preventDefault();
      moveLightbox(lightboxPrevious.closest('[data-b2b-gallery-lightbox]'), -1);
      return;
    }

    const lightboxNext = event.target.closest('[data-b2b-lightbox-next]');
    if (lightboxNext) {
      event.preventDefault();
      moveLightbox(lightboxNext.closest('[data-b2b-gallery-lightbox]'), 1);
      return;
    }

    const zoomButton = event.target.closest('[data-b2b-lightbox-zoom]');
    if (zoomButton) {
      event.preventDefault();
      const lightbox = zoomButton.closest('[data-b2b-gallery-lightbox]');
      setLightboxScale(lightbox, Number(lightbox.dataset.scale) > 1 ? 1 : 2);
      return;
    }

    if (event.target.closest('[data-b2b-lightbox-close]')) {
      event.preventDefault();
      closeLightbox();
      return;
    }

    const lightbox = event.target.closest('[data-b2b-gallery-lightbox]');
    if (
      lightbox
      && (
        event.target === lightbox
        || event.target.matches('[data-b2b-lightbox-stage], .b2b-gallery-lightbox-figure')
      )
    ) {
      closeLightbox();
    }
  });

  document.addEventListener('dblclick', (event) => {
    const image = event.target.closest('[data-b2b-lightbox-image]');
    if (!image) {
      return;
    }

    event.preventDefault();
    const lightbox = image.closest('[data-b2b-gallery-lightbox]');
    setLightboxScale(lightbox, Number(lightbox.dataset.scale) > 1 ? 1 : 2);
  });

  document.addEventListener('keydown', (event) => {
    const lightbox = getOpenLightbox();

    if (!lightbox) {
      return;
    }

    if (event.key === 'Escape') {
      event.preventDefault();
      closeLightbox();
      return;
    }

    if (event.key === 'ArrowLeft') {
      event.preventDefault();
      moveLightbox(lightbox, -1);
      return;
    }

    if (event.key === 'ArrowRight') {
      event.preventDefault();
      moveLightbox(lightbox, 1);
      return;
    }

    trapLightboxFocus(event, lightbox);
  });

  document.addEventListener('touchstart', (event) => {
    const stage = event.target.closest('[data-b2b-lightbox-stage], .b2b-gallery-stage');
    if (!stage) {
      return;
    }

    if (event.touches.length === 2 && stage.hasAttribute('data-b2b-lightbox-stage')) {
      const [first, second] = event.touches;
      pinchState = {
        distance: Math.hypot(second.clientX - first.clientX, second.clientY - first.clientY),
        scale: Number(stage.closest('[data-b2b-gallery-lightbox]')?.dataset.scale) || 1,
        stage,
      };
      touchState = null;
      return;
    }

    if (event.touches.length === 1) {
      const touch = event.touches[0];
      touchState = { x: touch.clientX, y: touch.clientY, stage };
    }
  }, { passive: true });

  document.addEventListener('touchmove', (event) => {
    if (!pinchState || event.touches.length !== 2) {
      return;
    }

    event.preventDefault();
    const [first, second] = event.touches;
    const distance = Math.hypot(second.clientX - first.clientX, second.clientY - first.clientY);
    const lightbox = pinchState.stage.closest('[data-b2b-gallery-lightbox]');
    setLightboxScale(lightbox, pinchState.scale * (distance / pinchState.distance));
  }, { passive: false });

  document.addEventListener('touchend', (event) => {
    if (pinchState) {
      if (event.touches.length < 2) {
        pinchState = null;
      }
      return;
    }

    if (!touchState || !event.changedTouches.length) {
      touchState = null;
      return;
    }

    const touch = event.changedTouches[0];
    const deltaX = touch.clientX - touchState.x;
    const deltaY = touch.clientY - touchState.y;
    const stage = touchState.stage;
    touchState = null;

    if (Math.abs(deltaX) < 48 || Math.abs(deltaX) <= Math.abs(deltaY)) {
      return;
    }

    const lightbox = stage.closest('[data-b2b-gallery-lightbox]');
    if (lightbox) {
      if (Number(lightbox.dataset.scale) <= 1.01) {
        moveLightbox(lightbox, deltaX < 0 ? 1 : -1);
      }
      return;
    }

    const gallery = stage.closest('[data-b2b-gallery]');
    if (gallery) {
      moveGallery(gallery, deltaX < 0 ? 1 : -1);
    }
  }, { passive: true });

  const initialize = () => {
    initializeProductGalleries();

    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === Node.ELEMENT_NODE) {
            initializeProductGalleries(node);
          }
        });
      });
    });

    observer.observe(document.body, { childList: true, subtree: true });
  };

  if (window.prestashop?.on) {
    window.prestashop.on('updatedProduct', () => {
      closeLightbox({ restoreFocus: false });
      window.requestAnimationFrame(() => initializeProductGalleries());
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initialize, { once: true });
  } else {
    initialize();
  }
})();
