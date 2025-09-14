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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Update state when losing focus
    if (!_focusNode.hasFocus) {
      ref.read(homeStateProvider.notifier).updateTextInput(_textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeStateProvider);
    final homeNotifier = ref.read(homeStateProvider.notifier);
    final theme = Theme.of(context);

    // Only sync controller from state if the text is different and we're not focused
    if (_textController.text != homeState.textInput && !_focusNode.hasFocus) {
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
                Icon(PhosphorIcons.textAa(PhosphorIconsStyle.regular), 
                     color: ColorsPalette.primary),
                const SizedBox(width: 12),
                Text('Or enter contract text', 
                     style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Paste your contract text here...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (value) {
                  // Update state in real-time
                  ref.read(homeStateProvider.notifier).updateTextInput(value);
                },
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _textController.text.isEmpty
                  ? null
                  : () {
                      // Update state with current text and set it as selected text
                      homeNotifier.setSelectedText(_textController.text);
                    },
              icon: Icon(PhosphorIcons.arrowRight(PhosphorIconsStyle.regular), size: 20),
              label: const Text('Continue with Text'),
            ),
          ],
        ),
      ),
    );
  }
}
