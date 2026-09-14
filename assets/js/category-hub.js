// Read current catalogue totals only for visible category cards. Keep at most
// two requests in flight and leave the count blank if the catalogue is offline.
(() => {
  const initializeCategoryCounts = () => {
    const labels = document.querySelectorAll('[data-category-count]');
    if (!labels.length || !('IntersectionObserver' in window)) return;
    const queue = [];
    let active = 0;
    const drain = () => {
      while (active < 2 && queue.length) {
        const label = queue.shift();
        const url = new URL(label.closest('a').href);
        url.searchParams.set('ajax', '1');
        url.searchParams.set('action', 'productSearch');
        const controller = new AbortController();
        const timer = setTimeout(() => controller.abort(), 15000);
        active++;
        fetch(url, { credentials: 'same-origin', signal: controller.signal, headers: { Accept: 'application/json' } })
          .then(response => response.ok ? response.json() : null)
          .then(data => {
            const count = data?.pagination?.total_items;
            if (Number.isInteger(count) && count >= 0) label.textContent = `Товарів: ${count}`;
          })
          .catch(() => {})
          .finally(() => { clearTimeout(timer); active--; drain(); });
      }
    };
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        observer.unobserve(entry.target);
        queue.push(entry.target);
      });
      drain();
    });
    labels.forEach(label => observer.observe(label));
  };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initializeCategoryCounts, { once: true });
  else initializeCategoryCounts();
})();
