import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FileUploadSection extends ConsumerWidget {
  const FileUploadSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);
    final homeNotifier = ref.read(homeStateProvider.notifier);
    final theme = Theme.of(context);

    return DropTarget(
      onDragDone: (details) async {
        if (details.files.isNotEmpty) {
          final file = details.files.first;
          final bytes = await file.readAsBytes();
          print("fileName ${file.name}");
          await homeNotifier.handleDroppedFile(
            PlatformFile(name: file.name, size: bytes.length, bytes: bytes, path: file.path),
          );
        }
      },
      onDragEntered: (details) {
        homeNotifier.setDragging(true);
      },
      onDragExited: (details) {
        homeNotifier.setDragging(false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 400,
        decoration: BoxDecoration(
          color: homeState.isDragging ? ColorsPalette.primary.withOpacity(0.05) : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: homeState.isDragging ? ColorsPalette.primary : ColorsPalette.grey300,
            width: homeState.isDragging ? 2 : 1.5,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(color: ColorsPalette.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: InkWell(
          onTap: () => homeNotifier.pickFile(),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.cloudArrowUp(PhosphorIconsStyle.duotone),
                  size: 72,
                  color: homeState.isDragging ? ColorsPalette.primary : ColorsPalette.grey500,
                ),
                const SizedBox(height: 24),
                Text(
                  'Drag & Drop your file here',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: ColorsPalette.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('or', style: theme.textTheme.bodyMedium?.copyWith(color: ColorsPalette.textSecondary)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => homeNotifier.pickFile(),
                  icon: Icon(PhosphorIcons.folderOpen(PhosphorIconsStyle.regular), size: 20),
                  label: const Text('Browse Files'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Supported: PDF, TXT, DOC, DOCX',
                  style: theme.textTheme.bodySmall?.copyWith(color: ColorsPalette.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
