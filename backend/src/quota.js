/** In-memory daily quota per device install id (Asia/Tehran calendar day). */
export class DailyQuotaStore {
  constructor({ limit = 10, nowFn = () => new Date() } = {}) {
    this.limit = limit;
    this.nowFn = nowFn;
    /** @type {Map<string, { day: string, count: number }>} */
    this._map = new Map();
  }

  _dayKey(date = this.nowFn()) {
    // YYYY-MM-DD in local time of the server (operator should run in Iran TZ ideally)
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}-${m}-${d}`;
  }

  remaining(deviceId) {
    const day = this._dayKey();
    const row = this._map.get(deviceId);
    if (!row || row.day !== day) return this.limit;
    return Math.max(0, this.limit - row.count);
  }

  /**
   * @returns {{ ok: true, remaining: number } | { ok: false, remaining: 0, code: 'quota_exceeded' }}
   */
  tryConsume(deviceId) {
    const day = this._dayKey();
    const row = this._map.get(deviceId);
    if (!row || row.day !== day) {
      this._map.set(deviceId, { day, count: 1 });
      return { ok: true, remaining: this.limit - 1 };
    }
    if (row.count >= this.limit) {
      return { ok: false, remaining: 0, code: 'quota_exceeded' };
    }
    row.count += 1;
    return { ok: true, remaining: this.limit - row.count };
  }

  /** For tests */
  reset() {
    this._map.clear();
  }
}
