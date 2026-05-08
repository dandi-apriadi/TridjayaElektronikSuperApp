import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment(_animation.value - 1, 0),
            end: Alignment(_animation.value, 0),
            colors: const [
              AppColors.surfaceVariant,
              Color(0xFFE8EBF0),
              AppColors.surfaceVariant,
            ],
          ),
        ),
      ),
    );
  }
}

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _ShimmerBox(width: 36, height: 36, borderRadius: 8),
          _ShimmerBox(width: 14, height: 14, borderRadius: 2),
        ]),
        const SizedBox(height: 12),
        _ShimmerBox(width: 80, height: 22, borderRadius: 4),
        const SizedBox(height: 6),
        _ShimmerBox(width: double.infinity, height: 12, borderRadius: 4),
      ]),
    );
  }
}

class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(children: [
        _ShimmerBox(width: 40, height: 40, borderRadius: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
            const SizedBox(height: 6),
            _ShimmerBox(width: 160, height: 11, borderRadius: 4),
          ]),
        ),
        const SizedBox(width: 12),
        _ShimmerBox(width: 60, height: 22, borderRadius: 6),
      ]),
    );
  }
}

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: List.generate(4, (_) => const StatCardSkeleton()),
        ),
        const SizedBox(height: 20),
        _ShimmerBox(width: 160, height: 18, borderRadius: 4),
        const SizedBox(height: 12),
        ...List.generate(4, (_) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: const ListItemSkeleton(),
        )),
      ],
    );
  }
}
