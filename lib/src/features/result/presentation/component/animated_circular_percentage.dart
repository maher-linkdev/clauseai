import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedCircularPercentage extends StatefulWidget {
  final double percentage; // Value between 0.0 and 1.0
  final double size;
  final Color? progressColor;
  final Color? backgroundColor;
  final double strokeWidth;
  final Duration animationDuration;
  final bool showPercentageText;
  final TextStyle? textStyle;

  const AnimatedCircularPercentage({
    super.key,
    required this.percentage,
    this.size = 40.0,
    this.progressColor,
    this.backgroundColor,
    this.strokeWidth = 3.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.showPercentageText = true,
    this.textStyle,
  });

  @override
  State<AnimatedCircularPercentage> createState() => _AnimatedCircularPercentageState();
}

class _AnimatedCircularPercentageState extends State<AnimatedCircularPercentage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    // Start animation after a brief delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedCircularPercentage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.percentage,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _progressColor {
    if (widget.progressColor != null) return widget.progressColor!;

    // Dynamic color based on percentage
    if (widget.percentage >= 0.8) return ColorsPalette.success;
    if (widget.percentage >= 0.6) return ColorsPalette.primary;
    if (widget.percentage >= 0.4) return ColorsPalette.warning;
    return ColorsPalette.error;
  }

  Color get _backgroundColor {
    return widget.backgroundColor ?? ColorsPalette.grey300.withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(_backgroundColor),
                ),
              ),
              // Animated progress circle
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                ),
              ),
              // Percentage text in center
              if (widget.showPercentageText)
                Text(
                  '${(_animation.value * 100).round()}%',
                  style: widget.textStyle ??
                      GoogleFonts.lato(
                        fontSize: widget.size * 0.25,
                        fontWeight: FontWeight.w600,
                        color: ColorsPalette.textPrimary,
                      ),
                ),
            ],
          );
        },
      ),
    );
  }
}
