import 'package:flutter/material.dart';

import '../formatters/iranian_plate_normalizer.dart';
import '../theme_constants.dart';

Future<String?> showPlateLetterPickerSheet({
  required BuildContext context,
  String? selectedLetter,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _PlateLetterPickerSheet(selectedLetter: selectedLetter);
    },
  );
}

class _PlateLetterPickerSheet extends StatelessWidget {
  const _PlateLetterPickerSheet({this.selectedLetter});

  final String? selectedLetter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final letters = IranianPlateNormalizer.selectableLetters;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'انتخاب حرف پلاک',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.55,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: letters.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final letter = letters[index];
                  final selected = letter == selectedLetter;
                  return SizedBox(
                    height: AppTapTargets.large,
                    child: Material(
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => Navigator.of(context).pop(letter),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline
                                      .withValues(alpha: 0.5),
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
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
