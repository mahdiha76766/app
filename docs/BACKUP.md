# ساختار فایل پشتیبان NediCar

فایل پشتیبان یک JSON نسخه‌گذاری‌شده و مستقل از دستگاه است که همه داده‌های محلی مرتبط با کارگاه را حمل می‌کند.

## نام فایل

```
nedicar-backup-YYYY-MM-DD_HHmmss.json
```

مثال: `nedicar-backup-2026-07-24_130455.json`

Snapshotهای اضطراری محلی در مسیر اپ ذخیره می‌شوند:

```
<app_documents>/nedicar_snapshots/snapshot-<reason>-<stamp>.json
```

حداکثر ۳ Snapshot نگه داشته می‌شود.

## اسکلت JSON

```json
{
  "format": "nedicar-backup",
  "backupVersion": 1,
  "appVersion": "1.0.0+1",
  "schemaVersion": 7,
  "createdAt": "2026-07-24T09:30:00.000Z",
  "counts": {
    "workshops": 1,
    "bankAccounts": 1,
    "customers": 12,
    "vehicles": 20,
    "serviceCategories": 10,
    "parts": 40,
    "repairOrders": 35,
    "repairServices": 10,
    "repairParts": 80,
    "partPriceHistory": 50,
    "reminders": 8,
    "paymentTransactions": 40
  },
  "data": {
    "workshops": [ { "...": "WorkshopRow.toJson()" } ],
    "bankAccounts": [],
    "customers": [],
    "vehicles": [],
    "serviceCategories": [],
    "parts": [],
    "repairOrders": [],
    "repairServices": [],
    "repairParts": [],
    "partPriceHistory": [],
    "reminders": [],
    "paymentTransactions": []
  }
}
```

## فیلدهای متا

| فیلد | معنی |
|------|------|
| `format` | باید دقیقاً `nedicar-backup` باشد |
| `backupVersion` | نسخه فرمت پشتیبان (فعلاً ۱؛ برای migration آینده) |
| `appVersion` | نسخه اپ در زمان Export |
| `schemaVersion` | نسخه schema Drift در زمان Export |
| `createdAt` | زمان UTC ساخت فایل (ISO-8601) |
| `counts` | شمارش سریع برای پیش‌نمایش قبل از Restore |
| `data` | جداول با کلید camelCase مطابق `*Row.toJson()` |

## قوانین Restore

- **Validate** قبل از هر Import (فرمت، نسخه، ساختار رکورد، وجود `id`)
- **Transactional**: کل Import در یک تراکنش Drift؛ شکست = Rollback کامل
- **replace**: پاک‌سازی همه جداول کاربری سپس درج
- **merge**: `insertOnConflictUpdate` بر اساس شناسه پایدار (PK)؛ از ساخت رکورد تکراری با همان `id` جلوگیری می‌شود
- اگر `schemaVersion` فایل از schema فعلی برنامه بزرگ‌تر باشد، Import رد می‌شود
- نسخه‌های آینده می‌توانند روی `backupVersion` تبدیل داده انجام دهند

## امنیت لاگ

شماره موبایل، کارت، حساب، نام مشتری و مشابه در لاگ‌های Backup چاپ نمی‌شوند / ماسک می‌شوند.

## سناریوی تست دستی پیشنهادی

1. چند خودرو/تعمیر/پرداخت ثبت کنید.
2. تنظیمات → مدیریت داده‌ها → **تهیه نسخه پشتیبان** → اشتراک/ذخیره فایل.
3. (اختیاری) اپ را uninstall کنید یا **پاکسازی کامل** با عبارت `حذف کامل`.
4. نصب مجدد / باز کردن اپ → **بازیابی نسخه پشتیبان** → انتخاب فایل → مشاهده شمارش‌ها → جایگزینی کامل.
5. داده قبلی باید برگشته باشد (پلاک فارسی، مشتری، فاکتور ترتیبی، حساب بانکی).
6. یک بار دیگر Restore با حالت **ادغام** و اطمینان از عدم دوبرابر شدن رکوردهای هم‌شناسه.
7. قبل از حذف خطرناک، Snapshot ساخته می‌شود؛ می‌توانید «بازیابی آخرین Snapshot اضطراری» را امتحان کنید.
