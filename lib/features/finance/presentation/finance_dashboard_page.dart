import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/money_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import '../data/providers.dart';
import '../domain/entities/finance_snapshot.dart';

/// داشبورد مالی با فیلتر و نمودار درآمد.
class FinanceDashboardPage extends ConsumerWidget {
  const FinanceDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final query = ref.watch(financeQueryProvider);
    final snapshotAsync = ref.watch(financeSnapshotProvider);

    return Scaffold(
      appBar: AppPageAppBar(
        title: 'گزارش مالی',
        actions: [
          TextButton(
            onPressed: () => context.push('/invoices'),
            child: const Text('فاکتورها'),
          ),
        ],
      ),
      body: Column(
        children: [
          _PeriodFilters(
            selected: query.period,
            onSelect: (period) {
              ref.read(financeQueryProvider.notifier).state =
                  _queryForPeriod(period);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              '${JalaliDateFormatter.format(query.from)} تا ${JalaliDateFormatter.format(query.to)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('خطا در بارگذاری گزارش')),
              data: (snapshot) {
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(financeSnapshotProvider);
                    await ref.read(financeSnapshotProvider.future);
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    children: [
                      _HeroMetricsCard(snapshot: snapshot),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricTile(
                              label: 'تعداد فاکتور',
                              value: PersianDigitFormatter.intToPersian(
                                snapshot.repairCount,
                              ),
                              icon: Icons.receipt_long_outlined,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _MetricTile(
                              label: 'میانگین فاکتور',
                              value: MoneyFormatter.format(
                                snapshot.averagePerInvoice,
                                withSuffix: false,
                              ),
                              icon: Icons.insights_outlined,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _BreakdownCard(snapshot: snapshot),
                      const SizedBox(height: 16),
                      Text(
                        'روند دریافت روزانه',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _IncomeBarChart(points: snapshot.daily),
                      const SizedBox(height: 16),
                      Text(
                        'ترکیب مبلغ فاکتورها',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _IncomeDonut(snapshot: snapshot),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  FinanceQuery _queryForPeriod(FinancePeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (period) {
      case FinancePeriod.today:
        return FinanceQuery(period: period, from: today, to: today);
      case FinancePeriod.week:
        return FinanceQuery(
          period: period,
          from: today.subtract(const Duration(days: 6)),
          to: today,
        );
      case FinancePeriod.month:
        return FinanceQuery(
          period: period,
          from: DateTime(today.year, today.month, 1),
          to: today,
        );
      case FinancePeriod.threeMonths:
        return FinanceQuery(
          period: period,
          from: DateTime(today.year, today.month - 2, 1),
          to: today,
        );
    }
  }
}

class _PeriodFilters extends StatelessWidget {
  const _PeriodFilters({
    required this.selected,
    required this.onSelect,
  });

  final FinancePeriod selected;
  final ValueChanged<FinancePeriod> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = <(FinancePeriod, String)>[
      (FinancePeriod.today, 'امروز'),
      (FinancePeriod.week, 'هفته'),
      (FinancePeriod.month, 'این ماه'),
      (FinancePeriod.threeMonths, '۳ ماه'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          for (final item in items) ...[
            _FlatChip(
              label: item.$2,
              selected: selected == item.$1,
              onTap: () => onSelect(item.$1),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FlatChip extends StatelessWidget {
  const _FlatChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected ? theme.colorScheme.primary : theme.colorScheme.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroMetricsCard extends StatelessWidget {
  const _HeroMetricsCard({required this.snapshot});

  final FinanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.78),
            const Color(0xFF0E5C4A),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'خلاصه مالی دوره',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          _heroLine('مبلغ کل فاکتورها', snapshot.invoicedTotal, theme),
          const SizedBox(height: 8),
          _heroLine('دریافت‌شده', snapshot.receivedTotal, theme),
          const SizedBox(height: 8),
          _heroLine('مطالبات باقی‌مانده', snapshot.outstandingTotal, theme),
          const SizedBox(height: 10),
          Text(
            '${PersianDigitFormatter.intToPersian(snapshot.repairCount)} فاکتور تکمیل‌شده',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _heroLine(String label, int amount, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ),
        Text(
          MoneyFormatter.format(amount),
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(label, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.snapshot});

  final FinanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(theme, 'اجرت', snapshot.laborTotal, theme.colorScheme.primary),
            const Divider(height: 20),
            _row(
              theme,
              'فروش قطعات',
              snapshot.partsTotal,
              theme.colorScheme.secondary,
            ),
            const Divider(height: 20),
            _row(theme, 'تخفیف', snapshot.discountTotal, theme.colorScheme.error),
          ],
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String label, int amount, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
        Text(
          MoneyFormatter.format(amount),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _IncomeBarChart extends StatelessWidget {
  const _IncomeBarChart({required this.points});

  final List<FinanceDayPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (points.isEmpty) {
      return _EmptyChart(message: 'در این بازه درآمدی ثبت نشده');
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: SizedBox(
        height: 260,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: CustomPaint(
            painter: _BarChartPainter(
              points: points,
              barColor: theme.colorScheme.primary,
              labelColor: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              valueColor: theme.colorScheme.onSurface,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _IncomeDonut extends StatelessWidget {
  const _IncomeDonut({required this.snapshot});

  final FinanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labor = snapshot.laborTotal.toDouble();
    final parts = snapshot.partsTotal.toDouble();
    final total = labor + parts;
    if (total <= 0) {
      return _EmptyChart(message: 'هنوز ترکیبی برای نمایش نیست');
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(
                painter: _DonutPainter(
                  laborFraction: labor / total,
                  laborColor: theme.colorScheme.primary,
                  partsColor: theme.colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legend(
                    theme,
                    'اجرت',
                    labor / total,
                    theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  _legend(
                    theme,
                    'قطعات',
                    parts / total,
                    theme.colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend(ThemeData theme, String label, double fraction, Color color) {
    final percent = (fraction * 100).round();
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(
          '${PersianDigitFormatter.intToPersian(percent)}٪',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Text(message),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.points,
    required this.barColor,
    required this.labelColor,
    required this.valueColor,
  });

  final List<FinanceDayPoint> points;
  final Color barColor;
  final Color labelColor;
  final Color valueColor;

  @override
  void paint(Canvas canvas, Size size) {
    final maxIncome =
        points.map((e) => e.receivedTotal).fold<int>(0, math.max).toDouble();
    if (maxIncome <= 0) {
      return;
    }

    final chartTop = 28.0;
    final chartBottom = size.height - 28;
    final chartHeight = chartBottom - chartTop;
    final n = points.length;
    final gap = 8.0;
    final barWidth = ((size.width - gap * (n + 1)) / n).clamp(10.0, 40.0);
    final totalBarsWidth = n * barWidth + (n - 1) * gap;
    var x = (size.width - totalBarsWidth) / 2;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [barColor.withValues(alpha: 0.55), barColor],
      ).createShader(Rect.fromLTWH(0, chartTop, size.width, chartHeight));

    final textPainter = TextPainter(textDirection: TextDirection.rtl);

    for (final point in points) {
      final h = (point.receivedTotal / maxIncome) * (chartHeight - 4);
      final top = chartBottom - h;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, barWidth, h),
        const Radius.circular(8),
      );
      canvas.drawRRect(rect, paint);

      textPainter.text = TextSpan(
        text: _compactAmount(point.receivedTotal),
        style: TextStyle(
          color: valueColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      );
      textPainter.layout(maxWidth: barWidth + 28);
      textPainter.paint(
        canvas,
        Offset(
          x + (barWidth - textPainter.width) / 2,
          top - textPainter.height - 4,
        ),
      );

      textPainter.text = TextSpan(
        text: JalaliDateFormatter.format(point.day).split('/').last,
        style: TextStyle(color: labelColor, fontSize: 10),
      );
      textPainter.layout(maxWidth: barWidth + 12);
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, chartBottom + 6),
      );

      x += barWidth + gap;
    }
  }

  String _compactAmount(int amount) {
    if (amount >= 1000000000) {
      final v = (amount / 1000000000).toStringAsFixed(1);
      return '${PersianDigitFormatter.toPersian(v)}م‌م';
    }
    if (amount >= 1000000) {
      final v = amount >= 10000000
          ? (amount / 1000000).round().toString()
          : (amount / 1000000).toStringAsFixed(1);
      return '${PersianDigitFormatter.toPersian(v)}م';
    }
    if (amount >= 1000) {
      final v = (amount / 1000).round();
      return '${PersianDigitFormatter.intToPersian(v)}ه';
    }
    return PersianDigitFormatter.intToPersian(amount);
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.barColor != barColor ||
        oldDelegate.valueColor != valueColor;
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.laborFraction,
    required this.laborColor,
    required this.partsColor,
  });

  final double laborFraction;
  final Color laborColor;
  final Color partsColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final stroke = radius * 0.34;

    final bg = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius - stroke / 2, bg);

    final laborPaint = Paint()
      ..color = laborColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    final partsPaint = Paint()
      ..color = partsColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;

    const start = -math.pi / 2;
    final laborSweep = laborFraction * 2 * math.pi;
    canvas.drawArc(rect.deflate(stroke / 2), start, laborSweep, false, laborPaint);
    canvas.drawArc(
      rect.deflate(stroke / 2),
      start + laborSweep,
      (1 - laborFraction) * 2 * math.pi,
      false,
      partsPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.laborFraction != laborFraction;
  }
}
