export const Storage = {
  set(key, value) { localStorage.setItem(key, String(value)); },
  get(key, fallback = null) { const v = localStorage.getItem(key); return v === null ? fallback : v; },
  today() { return new Date().toISOString().slice(0, 10); }
};
