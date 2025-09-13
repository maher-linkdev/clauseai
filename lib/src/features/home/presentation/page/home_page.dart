import 'dart:io';

import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/core/utils/app_snack_bar.dart';
import 'package:deal_insights_assistant/src/core/utils/file_validator.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isDragging = false;
  File? _selectedFile;
  String? _selectedText;
  bool _isUploading = false;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'doc', 'docx'],
    );

    if (result != null && result.files.first.path != null) {
      final file = result.files.first;
      final String? error = FileValidator.validateFile(
        fileName: file.name,
        fileSize: file.size,
        fileBytes: file.bytes!,
      );

      if (error != null) {
        AppSnackBar.error(context, error);
      } else {
        setState(() {
          _selectedFile = File(file.path!);
          _selectedText = null;
        });
      }
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFile = null;
      _selectedText = null;
      _textController.clear();
    });
  }

  void _processUpload() {
    if (_selectedFile != null || _selectedText != null) {
      setState(() {
        _isUploading = true;
      });
      // TODO: Implement upload logic
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isUploading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(PhosphorIcons.fileText(PhosphorIconsStyle.duotone), size: 28, color: ColorsPalette.primary),
            const SizedBox(width: 12),
            Expanded(child: const Text("${AppConstants.appName}: ${AppConstants.appPracticalName}")),
          ],
        ),
        actions: [
          if (isDesktop) const SizedBox(width: 8),
          TextButton.icon(
            icon: Icon(PhosphorIcons.signOut(PhosphorIconsStyle.regular), size: 20),
            label: isDesktop ? const Text('Sign Out') : const SizedBox.shrink(),
            onPressed: () {
              // TODO: Implement sign out
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.colorScheme.background, ColorsPalette.primary.withOpacity(0.02)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      'Upload Your Document',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorsPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Upload a PDF or paste text to analyze contracts and get AI-powered insights',
                      style: theme.textTheme.bodyLarge?.copyWith(color: ColorsPalette.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Upload Options - Responsive Layout
                    if (_selectedFile == null && _selectedText == null) ...[
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWideScreen = ResponsiveBreakpoints.of(context).largerThan(TABLET);

                          if (isWideScreen) {
                            // Horizontal layout for wide screens
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Drag & Drop Section
                                Expanded(
                                  child: DropTarget(
                                    onDragDone: (details) async {
                                      if (details.files.isNotEmpty) {
                                        final file = details.files.first;
                                        final bytes = await file.readAsBytes();
                                        final String? error = FileValidator.validateFile(
                                          fileName: file.name,
                                          fileSize: bytes.length,
                                          fileBytes: bytes,
                                        );

                                        if (error != null) {
                                          AppSnackBar.error(context, error);
                                        } else {
                                          setState(() {
                                            _selectedFile = File(file.path);
                                          });
                                        }
                                      }
                                    },
                                    onDragEntered: (details) {
                                      setState(() {
                                        _isDragging = true;
                                      });
                                    },
                                    onDragExited: (details) {
                                      setState(() {
                                        _isDragging = false;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      height: 400,
                                      decoration: BoxDecoration(
                                        color: _isDragging
                                            ? ColorsPalette.primary.withOpacity(0.05)
                                            : theme.cardTheme.color,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: _isDragging ? ColorsPalette.primary : ColorsPalette.grey300,
                                          width: _isDragging ? 2 : 1.5,
                                          style: BorderStyle.solid,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorsPalette.primary.withOpacity(0.1),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: _pickFile,
                                        borderRadius: BorderRadius.circular(24),
                                        child: Padding(
                                          padding: const EdgeInsets.all(32),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                PhosphorIcons.cloudArrowUp(PhosphorIconsStyle.duotone),
                                                size: 72,
                                                color: _isDragging ? ColorsPalette.primary : ColorsPalette.grey500,
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
                                              Text(
                                                'or',
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: ColorsPalette.textSecondary,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              ElevatedButton.icon(
                                                onPressed: _pickFile,
                                                icon: Icon(
                                                  PhosphorIcons.folderOpen(PhosphorIconsStyle.regular),
                                                  size: 20,
                                                ),
                                                label: const Text('Browse Files'),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Supported: PDF, TXT, DOC, DOCX',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: ColorsPalette.textSecondary,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Vertical Divider
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 180),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: theme.cardTheme.color,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: ColorsPalette.grey300, width: 1.5),
                                        ),
                                        child: Text(
                                          'OR',
                                          style: TextStyle(
                                            color: ColorsPalette.textSecondary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Text Input Section
                                Expanded(
                                  child: Card(
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
                                              Icon(
                                                PhosphorIcons.textT(PhosphorIconsStyle.regular),
                                                color: ColorsPalette.primary,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'Paste Contract Text',
                                                style: theme.textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
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
                                                focusColor: Colors.redAccent,
                                                hintText: 'Paste your contract text here...',
                                                filled: true,
                                                fillColor: ColorsPalette.grey400,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: ColorsPalette.primary, width: 2),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  setState(() {
                                                    _selectedText = value;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton.icon(
                                              onPressed: _textController.text.isNotEmpty
                                                  ? () {
                                                      setState(() {
                                                        _selectedText = _textController.text;
                                                      });
                                                      _processUpload();
                                                    }
                                                  : null,
                                              icon: Icon(PhosphorIcons.upload(PhosphorIconsStyle.regular), size: 20),
                                              label: const Text('Analyze Text'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Vertical layout for narrow screens
                            return Column(
                              children: [
                                // Drag & Drop Section
                                DropTarget(
                                  onDragDone: (details) {
                                    if (details.files.isNotEmpty) {
                                      final file = details.files.first;
                                      print("mimeType: ${file.mimeType}");
                                      setState(() {
                                        _selectedFile = File(file.path);
                                      });
                                    }
                                  },
                                  onDragEntered: (details) {
                                    setState(() {
                                      _isDragging = true;
                                    });
                                  },
                                  onDragExited: (details) {
                                    setState(() {
                                      _isDragging = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: _isDragging
                                          ? ColorsPalette.primary.withOpacity(0.05)
                                          : theme.cardTheme.color,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: _isDragging ? ColorsPalette.primary : ColorsPalette.grey300,
                                        width: _isDragging ? 2 : 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorsPalette.primary.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: _pickFile,
                                      borderRadius: BorderRadius.circular(24),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: isDesktop ? 80 : 60, horizontal: 40),
                                        child: Column(
                                          children: [
                                            Icon(
                                              PhosphorIcons.cloudArrowUp(PhosphorIconsStyle.duotone),
                                              size: isDesktop ? 80 : 64,
                                              color: _isDragging ? ColorsPalette.primary : ColorsPalette.grey500,
                                            ),
                                            const SizedBox(height: 24),
                                            Text(
                                              'Drag & Drop your file here',
                                              style: theme.textTheme.titleLarge?.copyWith(
                                                color: ColorsPalette.textPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'or',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: ColorsPalette.textSecondary,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton.icon(
                                              onPressed: _pickFile,
                                              icon: Icon(
                                                PhosphorIcons.folderOpen(PhosphorIconsStyle.regular),
                                                size: 20,
                                              ),
                                              label: const Text('Browse Files'),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Supported formats: PDF, TXT, DOC, DOCX',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: ColorsPalette.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Horizontal Divider with OR
                                Row(
                                  children: [
                                    Expanded(child: Divider(color: ColorsPalette.grey300, thickness: 1)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          color: ColorsPalette.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider(color: ColorsPalette.grey300, thickness: 1)),
                                  ],
                                ),

                                const SizedBox(height: 32),

                                // Text Input Section
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              PhosphorIcons.textT(PhosphorIconsStyle.regular),
                                              color: ColorsPalette.primary,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Paste Contract Text',
                                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _textController,
                                          maxLines: 8,
                                          decoration: InputDecoration(
                                            hintText: 'Paste your contract text here...',
                                            filled: true,
                                            fillColor: ColorsPalette.grey100,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: ColorsPalette.primary, width: 2),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              setState(() {
                                                _selectedText = value;
                                              });
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton.icon(
                                            onPressed: _textController.text.isNotEmpty
                                                ? () {
                                                    setState(() {
                                                      _selectedText = _textController.text;
                                                    });
                                                    _processUpload();
                                                  }
                                                : null,
                                            icon: Icon(PhosphorIcons.upload(PhosphorIconsStyle.regular), size: 20),
                                            label: const Text('Analyze Text'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],

                    // Selected File Display
                    if (_selectedFile != null) ...[
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                PhosphorIcons.filePdf(PhosphorIconsStyle.duotone),
                                size: 64,
                                color: ColorsPalette.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _selectedFile!.path.split('/').last,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ready to analyze',
                                style: theme.textTheme.bodyMedium?.copyWith(color: ColorsPalette.success),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: _clearSelection,
                                    icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.regular), size: 20),
                                    label: const Text('Remove'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: _isUploading ? null : _processUpload,
                                    icon: _isUploading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular), size: 20),
                                    label: Text(_isUploading ? 'Analyzing...' : 'Analyze Document'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Recent Documents Section
                    if (isDesktop) RecentDocuments(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecentDocuments extends StatelessWidget {
  const RecentDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 64),
        Text('Recent Documents', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      // TODO: Load recent document
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(PhosphorIcons.file(PhosphorIconsStyle.duotone), color: ColorsPalette.primary, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'Contract ${index + 1}.pdf',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '2 days ago',
                            style: theme.textTheme.bodySmall?.copyWith(color: ColorsPalette.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
