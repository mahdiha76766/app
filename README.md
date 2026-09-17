# دستیار مکانیک خودرو

اپلیکیشن Flutter آفلاین برای مکانیک‌ها: ثبت پلاک، پذیرش تعمیر، قطعات، فاکتور، پیام واتساپ و یادآوری سرویس.

## روش اجرا

```bash
# در صورت محدودیت دسترسی به pub.dev می‌توانید از آینه استفاده کنید:
# export PUB_HOSTED_URL=https://pub.flutter-io.cn
# export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

flutter pub get
flutter run
```

در حالت **debug** پس از اولین اجرا، `DevSeedService` داده آزمایشی (مشتری، خودرو، تعمیر، قطعات، بدهکار، یادآوری) می‌سازد. در **release** این seed اجرا نمی‌شود.

## معماری

ساختار **feature-first** با لایه‌های:

- `domain/` — entity و repository interface
- `data/` — پیاده‌سازی Drift و providerهای Riverpod
- `presentation/` — صفحات و ویجت‌ها

پوشه‌های اصلی:

- `lib/app/` — تم، روتر، ریشه اپ
- `lib/core/` — دیتابیس، فرمتترها، ویجت‌های مشترک (پلاک، صفحه‌کلید قیمت)
- `lib/features/` — home، vehicles، plate_scanner، repair_orders، parts، invoices، messaging، reminders، settings

مبالغ به‌صورت `int` تومان ذخیره می‌شوند (بدون double). تاریخ در DB میلادی و در UI شمسی است. اعداد در UI فارسی نمایش داده می‌شوند. جهت متن RTL است (`fa_IR`).

## پکیج‌های مهم

| پکیج | کاربرد |
|------|--------|
| `flutter_riverpod` | state و DI |
| `go_router` | مسیرها |
| `drift` / `drift_flutter` | دیتابیس SQLite |
| `camera` / `permission_handler` | اسکن پلاک |
| `url_launcher` / `share_plus` | واتساپ و اشتراک |
| `shamsi_date` | تاریخ شمسی |
| `uuid` | شناسه‌ها |

## ساخت دیتابیس

اسکیما در `lib/core/database/tables.dart` تعریف شده و با Drift تولید می‌شود.

نسخه فعلی اسکیما: **۱**

جداول: workshops، customers، vehicles، service_categories، parts، repair_orders، repair_services، repair_parts، part_price_history، reminders

Seed پایه (دسته‌ها و قطعات پرکاربرد) در `onCreate` با `AppDatabaseSeeder` اجرا می‌شود.

## اجرای build_runner

پس از تغییر جداول یا DAO:

```bash
dart run build_runner build --delete-conflicting-outputs
```

خروجی اصلی: `lib/core/database/app_database.g.dart`

## اجرای تست

```bash
flutter analyze
flutter test
```

تست یکپارچه مسیر MVP:

```bash
flutter test test/integration/repair_flow_integration_test.dart
```

پوشه‌های تست: unit (فرمتتر / منطق keypad / classifier)، repository، widget، و integration.

## محدودیت اسکن پلاک

- سرویس تشخیص پلاک قابل تعویض است (`PlateRecognitionService`).
- در debug پیش‌فرض **Mock** است؛ در release حالت **دستی**.
- اتصال API واقعی هنوز پیاده‌سازی نشده (`NotImplementedException`).
- دوربین و مجوز در اندروید/iOS پیکربندی شده‌اند؛ کیفیت OCR به سرویس آینده وابسته است.

## فرمول فاکتور (MVP)

```
partsTotal = مجموع (قیمت × تعداد) فقط برای قطعات تعمیرگاه
subtotal   = partsTotal + laborAmount
grandTotal = max(0, subtotal - discountAmount)
```

قطعات آورده‌شده توسط مشتری در سابقه می‌مانند ولی در جمع فاکتور نیستند.

## مسیر اصلی کاربر

خانه → پلاک (اسکن/دستی) → پرونده خودرو → پذیرش → قطعات → خلاصه/فاکتور → پیام واتساپ → یادآوری (اختیاری)

## مراحل نسخه بعد

1. اتصال OCR واقعی پلاک (API)
2. پیاده‌سازی `ReminderNotificationService` با `flutter_local_notifications`
3. تنظیمات تعمیرگاه در UI (نام، تلفن، آدرس)
4. لیست بدهکاران و گزارش مالی کامل‌تر
5. پشتیبان‌گیری/خروجی اکسل یا اشتراک فایل
6. مهاجرت اسکیما (نسخه ۲ به بعد در `onUpgrade`)
7. ویرایش کامل فاکتور پس از اتمام و چاپ/PDF

## نکات توسعه

- برای ورود قیمت از `PriceKeypadBottomSheet` استفاده کنید (نه کیبورد سیستم).
- واتساپ فقط با متن آماده باز می‌شود؛ ارسال خودکار انجام نمی‌شود.
- دکمه پایان تعمیر و ادامه پذیرش در برابر لمس چندباره محافظت شده‌اند.
- پذیرش باز (draft / inProgress) دوباره ساخته نمی‌شود و همان مسیر ادامه می‌یابد.
