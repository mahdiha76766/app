import 'package:flutter/material.dart';

class BankAccountSheetResult {
  const BankAccountSheetResult({
    required this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.cardNumber,
  });

  final String bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? cardNumber;
}

Future<BankAccountSheetResult?> showBankAccountSheet({
  required BuildContext context,
  String bankName = '',
  String? accountHolderName,
  String? accountNumber,
  String? cardNumber,
}) {
  return showModalBottomSheet<BankAccountSheetResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => _BankAccountSheet(
      bankName: bankName,
      accountHolderName: accountHolderName,
      accountNumber: accountNumber,
      cardNumber: cardNumber,
    ),
  );
}

class _BankAccountSheet extends StatefulWidget {
  const _BankAccountSheet({
    this.bankName = '',
    this.accountHolderName,
    this.accountNumber,
    this.cardNumber,
  });

  final String bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? cardNumber;

  @override
  State<_BankAccountSheet> createState() => _BankAccountSheetState();
}

class _BankAccountSheetState extends State<_BankAccountSheet> {
  late final TextEditingController _bankNameController;
  late final TextEditingController _holderController;
  late final TextEditingController _cardController;
  late final TextEditingController _accountController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _bankNameController = TextEditingController(text: widget.bankName);
    _holderController =
        TextEditingController(text: widget.accountHolderName ?? '');
    _cardController = TextEditingController(text: widget.cardNumber ?? '');
    _accountController =
        TextEditingController(text: widget.accountNumber ?? '');
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _holderController.dispose();
    _cardController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  void _submit() {
    final bankName = _bankNameController.text.trim();
    if (bankName.isEmpty) {
      setState(() => _errorText = 'نام بانک را وارد کنید.');
      return;
    }
    final holder = _holderController.text.trim();
    final card = _cardController.text.trim();
    final account = _accountController.text.trim();
    Navigator.of(context).pop(
      BankAccountSheetResult(
        bankName: bankName,
        accountHolderName: holder.isEmpty ? null : holder,
        cardNumber: card.isEmpty ? null : card,
        accountNumber: account.isEmpty ? null : account,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'حساب بانکی',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'برای نمایش در فاکتور و پیام مشتری',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _bankNameController,
              decoration: const InputDecoration(
                labelText: 'نام بانک *',
                hintText: 'مثلاً ملت / ملی',
                prefixIcon: Icon(Icons.account_balance_outlined),
                isDense: true,
              ),
              textDirection: TextDirection.rtl,
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _holderController,
              decoration: const InputDecoration(
                labelText: 'نام دارنده حساب',
                hintText: 'مثلاً علی رضایی',
                prefixIcon: Icon(Icons.person_outline),
                isDense: true,
              ),
              textDirection: TextDirection.rtl,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cardController,
              decoration: const InputDecoration(
                labelText: 'شماره کارت',
                prefixIcon: Icon(Icons.credit_card_outlined),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _accountController,
              decoration: const InputDecoration(
                labelText: 'شماره حساب',
                prefixIcon: Icon(Icons.numbers_outlined),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('انصراف'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('تأیید و ذخیره'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
