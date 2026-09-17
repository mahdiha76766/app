import 'package:drift/drift.dart';

import '../../../core/formatters/text_normalizer.dart';
import '../app_database.dart';

/// داده‌های اولیه دسته‌ها و قطعات پرکاربرد.
class AppDatabaseSeeder {
  AppDatabaseSeeder(this._db);

  final AppDatabase _db;

  static const categories = <_SeedCategory>[
    _SeedCategory(id: 'cat-periodic', title: 'سرویس دوره‌ای', iconKey: 'periodic', sortOrder: 1),
    _SeedCategory(id: 'cat-engine', title: 'موتور', iconKey: 'engine', sortOrder: 2),
    _SeedCategory(id: 'cat-suspension', title: 'جلوبندی', iconKey: 'suspension', sortOrder: 3),
    _SeedCategory(id: 'cat-brake', title: 'ترمز', iconKey: 'brake', sortOrder: 4),
    _SeedCategory(id: 'cat-electrical', title: 'برق', iconKey: 'electrical', sortOrder: 5),
    _SeedCategory(id: 'cat-ac', title: 'کولر', iconKey: 'ac', sortOrder: 6),
    _SeedCategory(id: 'cat-gearbox', title: 'گیربکس', iconKey: 'gearbox', sortOrder: 7),
    _SeedCategory(id: 'cat-exhaust', title: 'اگزوز', iconKey: 'exhaust', sortOrder: 8),
    _SeedCategory(id: 'cat-body', title: 'بدنه', iconKey: 'body', sortOrder: 9),
    _SeedCategory(id: 'cat-other', title: 'سایر', iconKey: 'other', sortOrder: 10),
  ];

  static const partsByCategory = <String, List<String>>{
    'cat-periodic': [
      'روغن موتور',
      'فیلتر روغن',
      'فیلتر هوا',
      'فیلتر کابین',
      'شمع موتور',
      'وایر شمع',
      'تسمه تایم',
      'تسمه دینام',
      'ضد یخ',
      'روغن گیربکس',
      'فیلتر بنزین',
      'واشر درب سوپاپ',
    ],
    'cat-engine': [
      'واشر سرسیلندر',
      'کیت تایم',
      'ترموستات',
      'واتر پمپ',
      'رادیاتور',
      'شیلنگ رادیاتور',
      'سنسور اکسیژن',
      'کویل جرقه',
      'استپر موتور',
      'سوپاپ',
      'یاتاقان ثابت',
      'پیستون',
      'رینگ پیستون',
      'اویل پمپ',
    ],
    'cat-suspension': [
      'کمک جلو',
      'کمک عقب',
      'سیبک',
      'مفصل',
      'بوش طبق',
      'طبق کامل',
      'میل موجگیر',
      'توپی چرخ',
      'بلبرینگ چرخ',
      'فنر لول',
      'اکسل جلو',
      'قرقری فرمان',
    ],
    'cat-brake': [
      'لنت جلو',
      'لنت عقب',
      'دیسک ترمز',
      'کاسه چرخ',
      'شیلنگ ترمز',
      'روغن ترمز',
      'پمپ ترمز',
      'بوستر ترمز',
      'لوله ترمز',
      'سنسور ABS',
      'کالیپر ترمز',
    ],
    'cat-electrical': [
      'باتری',
      'دینام',
      'استارت',
      'آفتامات',
      'فیوز',
      'رله',
      'لامپ جلو',
      'لامپ عقب',
      'سنسور سرعت',
      'ECU',
      'سوئیچ اینرسی',
      'دسته راهنما',
      'مقاومت فن',
    ],
    'cat-ac': [
      'گاز کولر',
      'کمپرسور کولر',
      'کندانسور',
      'اواپراتور',
      'فیلتر درایر',
      'شیر انبساط',
      'نشتی‌گیر کولر',
      'تسمه کولر',
      'سنسور فشار گاز',
      'مقاومت بخاری',
    ],
    'cat-gearbox': [
      'صفحه کلاچ',
      'دیسک کلاچ',
      'بلبرینگ کلاچ',
      'کیت کلاچ',
      'روغن گیربکس دستی',
      'روغن گیربکس اتومات',
      'سیم کلاچ',
      'دسته دنده',
      'کاسه نمد گیربکس',
      'توربین گیربکس',
      'فیلتر گیربکس اتومات',
    ],
    'cat-exhaust': [
      'منبع اگزوز',
      'لوله اگزوز',
      'کاتالیزور',
      'واشر اگزوز',
      'سنسور اکسیژن عقب',
      'منیفولد دود',
      'انباره وسط',
      'بست اگزوز',
      'فلنج اگزوز',
    ],
    'cat-body': [
      'آینه بغل',
      'دستگیره در',
      'قفل در',
      'شیشه بالابر',
      'موتور شیشه بالابر',
      'برف‌پاک‌کن',
      'تیغه برف‌پاک‌کن',
      'چراغ خطر',
      'سپر جلو',
      'سپر عقب',
      'گلگیر',
      'کاپوت',
    ],
    'cat-other': [
      'چسب واشر',
      'اسپری شستشو',
      'گریس',
      'نوار چسب برق',
      'بست کمربندی',
      'پیچ و مهره',
      'واشر تخت',
      'سیلیکون',
      'تمیزکننده کاربراتور',
      'اسپری روان‌کننده',
    ],
  };

  Future<void> seedIfNeeded() async {
    final existing = await _db.select(_db.serviceCategories).get();
    if (existing.isNotEmpty) {
      return;
    }

    final now = DateTime.now();

    await _db.batch((batch) {
      batch.insertAll(
        _db.serviceCategories,
        [
          for (final category in categories)
            ServiceCategoriesCompanion.insert(
              id: category.id,
              title: category.title,
              iconKey: category.iconKey,
              sortOrder: category.sortOrder,
              isActive: const Value(true),
            ),
        ],
      );

      final partCompanions = <PartsCompanion>[];
      for (final entry in partsByCategory.entries) {
        final categoryId = entry.key;
        for (var index = 0; index < entry.value.length; index++) {
          final title = entry.value[index];
          partCompanions.add(
            PartsCompanion.insert(
              id: '$categoryId-part-${index + 1}',
              title: title,
              normalizedTitle: TextNormalizer.normalize(title),
              serviceCategoryId: Value(categoryId),
              usageCount: const Value(0),
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
        }
      }
      batch.insertAll(_db.parts, partCompanions);
    });
  }
}

class _SeedCategory {
  const _SeedCategory({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String iconKey;
  final int sortOrder;
}
