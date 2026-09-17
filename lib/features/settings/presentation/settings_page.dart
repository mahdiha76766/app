import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/widgets/nedicar_logo.dart';
import '../../backup/presentation/data_management_section.dart';
import '../data/providers.dart';
import '../domain/entities/bank_account.dart';
import '../domain/entities/workshop.dart';
import 'widgets/bank_account_sheet.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _nameController = TextEditingController();
  final _mechanicNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _workshopId;
  int _morningHour = 9;
  int _afternoonHour = 17;
  int _nightHour = 20;
  bool _enableWhatsApp = true;
  bool _enableTelegram = false;
  bool _enableSms = false;
  bool _includeBankInfoInMessages = false;
  int _nextInvoiceNumber = 1;
  int? _invoiceSeqYear;
  List<BankAccount> _banks = const [];

  @override
  void initState() {
    super.initState();
    _loadWorkshop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mechanicNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkshop() async {
    final repo = ref.read(workshopRepositoryProvider);
    final workshop = await repo.getWorkshop();
    if (!mounted) return;
    if (workshop != null) {
      _workshopId = workshop.id;
      _nameController.text = workshop.name;
      _mechanicNameController.text = workshop.mechanicName ?? '';
      _phoneController.text = workshop.phone ?? '';
      _addressController.text = workshop.address ?? '';
      _morningHour = workshop.morningHour;
      _afternoonHour = workshop.afternoonHour;
      _nightHour = workshop.nightHour;
      _enableWhatsApp = workshop.enableWhatsApp;
      _enableTelegram = workshop.enableTelegram;
      _enableSms = workshop.enableSms;
      _includeBankInfoInMessages = workshop.includeBankInfoInMessages;
      _nextInvoiceNumber = workshop.nextInvoiceNumber;
      _invoiceSeqYear = workshop.invoiceSeqYear;
      _banks = await ref
          .read(bankAccountRepositoryProvider)
          .listForWorkshop(workshop.id);
      if (!mounted) return;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نام تعمیرگاه الزامی است')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = ref.read(workshopRepositoryProvider);
    final workshop = Workshop(
      id: _workshopId ?? const Uuid().v4(),
      name: name,
      mechanicName: _mechanicNameController.text.trim().isEmpty
          ? null
          : _mechanicNameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      morningHour: _morningHour,
      afternoonHour: _afternoonHour,
      nightHour: _nightHour,
      enableWhatsApp: _enableWhatsApp,
      enableTelegram: _enableTelegram,
      enableSms: _enableSms,
      includeBankInfoInMessages: _includeBankInfoInMessages,
      nextInvoiceNumber: _nextInvoiceNumber,
      invoiceSeqYear: _invoiceSeqYear,
      createdAt: DateTime.now(),
    );
    await repo.saveWorkshop(workshop);
    _workshopId = workshop.id;
    final bankRepo = ref.read(bankAccountRepositoryProvider);
    for (final bank in _banks) {
      await bankRepo.upsert(
        BankAccount(
          id: bank.id,
          workshopId: workshop.id,
          bankName: bank.bankName,
          accountHolderName: bank.accountHolderName,
          accountNumber: bank.accountNumber,
          cardNumber: bank.cardNumber,
          sortOrder: bank.sortOrder,
          createdAt: bank.createdAt,
        ),
      );
    }
    ref.invalidate(workshopProvider);
    ref.invalidate(bankAccountsProvider);
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('اطلاعات ذخیره شد'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickHour({
    required String title,
    required int current,
    required ValueChanged<int> onPicked,
  }) async {
    final selected = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 24,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (context, hour) {
                final isSelected = hour == current;
                return ChoiceChip(
                  label: Text(PersianDigitFormatter.intToPersian(hour)),
                  selected: isSelected,
                  onSelected: (_) => Navigator.of(ctx).pop(hour),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('انصراف'),
            ),
          ],
        );
      },
    );
    if (selected != null) {
      onPicked(selected);
    }
  }

  Future<void> _addBank() async {
    final result = await showBankAccountSheet(context: context);
    if (result == null || !mounted) {
      return;
    }
    setState(() {
      _banks = [
        ..._banks,
        BankAccount(
          id: const Uuid().v4(),
          workshopId: _workshopId ?? '',
          bankName: result.bankName,
          accountHolderName: result.accountHolderName,
          accountNumber: result.accountNumber,
          cardNumber: result.cardNumber,
          sortOrder: _banks.length,
          createdAt: DateTime.now(),
        ),
      ];
    });
  }

  Future<void> _editBank(int index) async {
    final current = _banks[index];
    final result = await showBankAccountSheet(
      context: context,
      bankName: current.bankName,
      accountHolderName: current.accountHolderName,
      accountNumber: current.accountNumber,
      cardNumber: current.cardNumber,
    );
    if (result == null || !mounted) {
      return;
    }
    setState(() {
      _banks = [
        for (var i = 0; i < _banks.length; i++)
          if (i == index)
            BankAccount(
              id: current.id,
              workshopId: current.workshopId,
              bankName: result.bankName,
              accountHolderName: result.accountHolderName,
              accountNumber: result.accountNumber,
              cardNumber: result.cardNumber,
              sortOrder: current.sortOrder,
              createdAt: current.createdAt,
            )
          else
            _banks[i],
      ];
    });
  }

  Future<void> _removeBank(int index) async {
    final removed = _banks[index];
    setState(() {
      _banks = [
        for (var i = 0; i < _banks.length; i++)
          if (i != index) _banks[i],
      ];
    });
    if (removed.workshopId.isNotEmpty) {
      await ref.read(bankAccountRepositoryProvider).delete(removed.id);
      if (!mounted) return;
      ref.invalidate(bankAccountsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Text('تنظیمات', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'اطلاعات تعمیرگاه و تنظیمات برنامه',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'اطلاعات تعمیرگاه', icon: Icons.store_outlined),
          const SizedBox(height: 12),
          _SettingsCard(
            theme: theme,
            children: [
              _SettingsTextField(
                controller: _nameController,
                label: 'نام تعمیرگاه',
                icon: Icons.store,
                required: true,
              ),
              const Divider(height: 1),
              _SettingsTextField(
                controller: _mechanicNameController,
                label: 'نام مکانیک',
                icon: Icons.person_outline,
              ),
              const Divider(height: 1),
              _SettingsTextField(
                controller: _phoneController,
                label: 'شماره تماس',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const Divider(height: 1),
              _SettingsTextField(
                controller: _addressController,
                label: 'آدرس',
                icon: Icons.location_on_outlined,
                maxLines: 2,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'ساعات تحویل',
            icon: Icons.schedule_outlined,
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            theme: theme,
            children: [
              _HourTile(
                title: 'صبح',
                hour: _morningHour,
                icon: Icons.wb_sunny_outlined,
                onTap: () => _pickHour(
                  title: 'ساعت صبح',
                  current: _morningHour,
                  onPicked: (h) => setState(() => _morningHour = h),
                ),
              ),
              const Divider(height: 1),
              _HourTile(
                title: 'عصر',
                hour: _afternoonHour,
                icon: Icons.wb_twilight_outlined,
                onTap: () => _pickHour(
                  title: 'ساعت عصر',
                  current: _afternoonHour,
                  onPicked: (h) => setState(() => _afternoonHour = h),
                ),
              ),
              const Divider(height: 1),
              _HourTile(
                title: 'شب',
                hour: _nightHour,
                icon: Icons.nights_stay_outlined,
                onTap: () => _pickHour(
                  title: 'ساعت شب',
                  current: _nightHour,
                  onPicked: (h) => setState(() => _nightHour = h),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'کانال‌های پیام',
            icon: Icons.chat_outlined,
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            theme: theme,
            children: [
              SwitchListTile(
                secondary: Icon(
                  Icons.chat,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('واتساپ'),
                subtitle: const Text('ارسال پیام و فاکتور از طریق واتساپ'),
                value: _enableWhatsApp,
                onChanged: (v) => setState(() => _enableWhatsApp = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: Icon(
                  Icons.send_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('تلگرام'),
                subtitle: const Text('ارسال پیام و فاکتور از طریق تلگرام'),
                value: _enableTelegram,
                onChanged: (v) => setState(() => _enableTelegram = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: Icon(
                  Icons.sms_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('پیامک (سیم‌کارت)'),
                subtitle: const Text('باز کردن برنامه پیامک گوشی'),
                value: _enableSms,
                onChanged: (v) => setState(() => _enableSms = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: Icon(
                  Icons.account_balance_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('ارسال اطلاعات حساب در پیام'),
                subtitle: const Text(
                  'در واتساپ، تلگرام و پیامک شماره کارت/حساب هم بیاید',
                ),
                value: _includeBankInfoInMessages,
                onChanged: (v) =>
                    setState(() => _includeBankInfoInMessages = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'حساب‌های بانکی',
            icon: Icons.credit_card_outlined,
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            theme: theme,
            children: [
              if (_banks.isEmpty)
                const ListTile(
                  title: Text('هنوز حسابی ثبت نشده'),
                  subtitle: Text('برای نمایش در فاکتور، حساب اضافه کنید'),
                )
              else
                for (var i = 0; i < _banks.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  ListTile(
                    title: Text(_banks[i].bankName),
                    subtitle: Text(
                      [
                        if (_banks[i].accountHolderName?.isNotEmpty == true)
                          'به نام: ${_banks[i].accountHolderName}',
                        if (_banks[i].cardNumber?.isNotEmpty == true)
                          'کارت: ${_banks[i].cardNumber}',
                        if (_banks[i].accountNumber?.isNotEmpty == true)
                          'حساب: ${_banks[i].accountNumber}',
                      ].join(' · '),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeBank(i),
                    ),
                    onTap: () => _editBank(i),
                  ),
                ],
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.add_circle_outline,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('افزودن بانک / حساب'),
                onTap: _addBank,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _isSaving ? 'در حال ذخیره...' : 'ذخیره اطلاعات',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _SectionHeader(
            title: 'مالی',
            icon: Icons.insights_outlined,
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            theme: theme,
            children: [
              ListTile(
                leading: Icon(
                  Icons.bar_chart_rounded,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('گزارش مالی و نمودارها'),
                subtitle: const Text('درآمد، تعداد کار و فیلتر بازه زمانی'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => context.push('/finance'),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.receipt_long_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('فاکتورها'),
                subtitle: const Text('جستجو، بدهکاران و ثبت پرداخت'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => context.push('/invoices'),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _SectionHeader(
            title: 'مدیریت داده‌ها',
            icon: Icons.delete_sweep_outlined,
          ),
          const SizedBox(height: 12),
          DataManagementSection(theme: theme),
          const SizedBox(height: 32),
          _AboutSection(theme: theme),
        ],
      ),
    );
  }
}

class _HourTile extends StatelessWidget {
  const _HourTile({
    required this.title,
    required this.hour,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final int hour;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(
        'ساعت ${PersianDigitFormatter.intToPersian(hour)}',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.edit_outlined),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.theme, required this.children});

  final ThemeData theme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingsTextField extends StatelessWidget {
  const _SettingsTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.required = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        child: Column(
          children: [
            const NediCarLogo(height: 64),
            const SizedBox(height: 12),
            Text(
              'NediCar',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'دستیار آفلاین مکانیک برای ثبت تعمیرات، قطعات و یادآوری.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
