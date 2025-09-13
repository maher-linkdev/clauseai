import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TextInputSection extends ConsumerStatefulWidget {
  const TextInputSection({super.key});

  @override
  ConsumerState<TextInputSection> createState() => _TextInputSectionState();
}

class _TextInputSectionState extends ConsumerState<TextInputSection> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeStateProvider);
    final homeNotifier = ref.read(homeStateProvider.notifier);
    final theme = Theme.of(context);

    // Sync controller with state
    if (_textController.text != homeState.textInput) {
      _textController.text = homeState.textInput;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(PhosphorIcons.textT(PhosphorIconsStyle.regular), color: ColorsPalette.primary),
                const SizedBox(width: 12),
                Text('Paste Contract Text', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextFormField(
                controller: _textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Paste your contract text here...',
                  filled: true,
                  fillColor: ColorsPalette.grey400,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ColorsPalette.primary, width: 2),
                  ),
                ),
                onChanged: (value) {
                  homeNotifier.updateTextInput(value);
                },
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: homeState.hasSelectedText && !homeState.isProcessing
                    ? () => homeNotifier.analyzeDocument()
                    : null,
                icon: homeState.isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(PhosphorIcons.upload(PhosphorIconsStyle.regular), size: 20),
                label: Text(homeState.isProcessing ? 'Analyzing...' : 'Analyze Text'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
