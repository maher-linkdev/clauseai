import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisSection<T> extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<T> items;
  final Widget Function(T item) itemBuilder;

  const AnalysisSection({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.itemBuilder,
  });

  @override
  State<AnalysisSection<T>> createState() => _AnalysisSectionState<T>();
}

class _AnalysisSectionState<T> extends State<AnalysisSection<T>> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: ColorsPalette.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsPalette.grey300),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorsPalette.backgroundLight.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: ColorsPalette.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalette.textPrimary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorsPalette.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.items.length.toString(),
                      style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w600, color: ColorsPalette.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down, color: ColorsPalette.textSecondary, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Column(
                    children: [
                      for (int i = 0; i < widget.items.length; i++) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: i < widget.items.length - 1
                                ? Border(bottom: BorderSide(color: ColorsPalette.grey300))
                                : null,
                          ),
                          child: widget.itemBuilder(widget.items[i]),
                        ),
                      ],
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
