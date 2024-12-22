import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';

class AnimatedBadgeTooltip extends StatefulWidget {
  final Widget child;
  final String tooltip;
  final bool isVisible;
  final double badgeSize;

  const AnimatedBadgeTooltip({
    super.key,
    required this.child,
    required this.tooltip,
    required this.isVisible,
    required this.badgeSize,
  });

  @override
  State<AnimatedBadgeTooltip> createState() => _AnimatedBadgeTooltipState();
}

class _AnimatedBadgeTooltipState extends State<AnimatedBadgeTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: -20.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didUpdateWidget(AnimatedBadgeTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 18,
          top: 0,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(_slideAnimation.value, 0),
                  child: Container(
                    height: widget.badgeSize,
                    padding: const EdgeInsets.only(
                      left: 32,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.tooltipBackgroundTransparent,
                          AppColors.tooltipBackground.withOpacity(0.9),
                          AppColors.tooltipBackground.withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.3, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(widget.badgeSize / 2),
                    ),
                    child: Center(
                      child: Text(
                        widget.tooltip,
                        style: const TextStyle(
                          color: AppColors.controlText,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}
