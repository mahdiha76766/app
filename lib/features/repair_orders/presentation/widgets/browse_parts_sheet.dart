import 'package:flutter/material.dart';

import '../../../../core/theme_constants.dart';
import '../../../parts/domain/entities/part.dart';

Future<Part?> showBrowsePartsSheet({
  required BuildContext context,
  required String title,
  required Future<List<Part>> Function(String query) loadParts,
}) {
  return showModalBottomSheet<Part>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _BrowsePartsSheet(
        title: title,
        loadParts: loadParts,
      );
    },
  );
}

class _BrowsePartsSheet extends StatefulWidget {
  const _BrowsePartsSheet({
    required this.title,
    required this.loadParts,
  });

  final String title;
  final Future<List<Part>> Function(String query) loadParts;

  @override
  State<_BrowsePartsSheet> createState() => _BrowsePartsSheetState();
}

class _BrowsePartsSheetState extends State<_BrowsePartsSheet> {
  final _searchController = TextEditingController();
  List<Part> _parts = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload(String query) async {
    setState(() => _loading = true);
    final parts = await widget.loadParts(query);
    if (!mounted) {
      return;
    }
    setState(() {
      _parts = parts;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.sizeOf(context).height * 0.75;

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'جستجو',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _reload,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _parts.isEmpty
                      ? Center(
                          child: Text(
                            'قطعه‌ای پیدا نشد.',
                            style: theme.textTheme.bodyLarge,
                          ),
                        )
                      : ListView.separated(
                          itemCount: _parts.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final part = _parts[index];
                            return SizedBox(
                              height: AppTapTargets.large,
                              child: FilledButton.tonal(
                                onPressed: () =>
                                    Navigator.of(context).pop(part),
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    part.title,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
