import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// Model sederhana untuk data chart
// ─────────────────────────────────────────────
class ChartBarData {
  final String label;
  final double value;
  final Color color;
  const ChartBarData({required this.label, required this.value, required this.color});
}

class ChartLineData {
  final List<double> values;
  final Color color;
  final String label;
  const ChartLineData({required this.values, required this.color, required this.label});
}

class ChartPieData {
  final String label;
  final double value;
  final Color color;
  const ChartPieData({required this.label, required this.value, required this.color});
}

// ─────────────────────────────────────────────
// Bar Chart Card
// ─────────────────────────────────────────────
class BarChartCard extends StatefulWidget {
  final String title;
  final List<ChartBarData> data;
  final double height;
  final String? subtitle;
  final String? unit;

  const BarChartCard({
    super.key,
    required this.title,
    required this.data,
    this.height = 200,
    this.subtitle,
    this.unit,
  });

  @override
  State<BarChartCard> createState() => _BarChartCardState();
}

class _BarChartCardState extends State<BarChartCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = widget.data.fold(0.0, (m, d) => d.value > m ? d.value : m);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.title, style: AppTextStyles.subtitle),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 2),
              Text(widget.subtitle!, style: AppTextStyles.caption),
            ],
          ])),
        ]),
        const SizedBox(height: 18),
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => SizedBox(
            height: widget.height,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal * 1.25,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.textPrimary.withOpacity(0.9),
                    getTooltipItem: (group, _, rod, __) {
                      final d = widget.data[group.x];
                      return BarTooltipItem(
                        '${d.label}\n',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                        children: [TextSpan(
                          text: '${rod.toY.toStringAsFixed(0)}${widget.unit ?? ''}',
                          style: TextStyle(color: d.color, fontWeight: FontWeight.w600, fontSize: 13),
                        )],
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    setState(() {
                      _touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, _) {
                        final i = val.toInt();
                        if (i < 0 || i >= widget.data.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            widget.data[i].label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: _touchedIndex == i ? FontWeight.w700 : FontWeight.w500,
                              color: _touchedIndex == i ? widget.data[i].color : AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (val, _) => Text(
                        val >= 1000 ? '${(val / 1000).toStringAsFixed(0)}k' : val.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(color: AppColors.divider, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: widget.data.asMap().entries.map((e) {
                  final i = e.key;
                  final d = e.value;
                  final isTouched = _touchedIndex == i;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: d.value * _anim.value,
                        color: isTouched ? d.color : d.color.withOpacity(0.75),
                        width: isTouched ? 20 : 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxVal * 1.25,
                          color: AppColors.surfaceVariant,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Line Chart Card
// ─────────────────────────────────────────────
class LineChartCard extends StatefulWidget {
  final String title;
  final List<ChartLineData> series;
  final List<String> xLabels;
  final double height;
  final String? subtitle;
  final String? unit;

  const LineChartCard({
    super.key,
    required this.title,
    required this.series,
    required this.xLabels,
    this.height = 200,
    this.subtitle,
    this.unit,
  });

  @override
  State<LineChartCard> createState() => _LineChartCardState();
}

class _LineChartCardState extends State<LineChartCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allVals = widget.series.expand((s) => s.values);
    final maxVal = allVals.fold(0.0, (m, v) => v > m ? v : m);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.title, style: AppTextStyles.subtitle),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 2),
              Text(widget.subtitle!, style: AppTextStyles.caption),
            ],
          ])),
        ]),
        if (widget.series.length > 1) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            children: widget.series.map((s) => Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 12, height: 3, decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 5),
              Text(s.label, style: AppTextStyles.caption),
            ])).toList(),
          ),
        ],
        const SizedBox(height: 18),
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => SizedBox(
            height: widget.height,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxVal * 1.2,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.textPrimary.withOpacity(0.9),
                    getTooltipItems: (spots) => spots.map((s) {
                      final series = widget.series[s.barIndex];
                      return LineTooltipItem(
                        '${series.label}: ${s.y.toStringAsFixed(0)}${widget.unit ?? ''}',
                        TextStyle(color: series.color, fontWeight: FontWeight.w600, fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (val, _) {
                        final i = val.toInt();
                        if (i < 0 || i >= widget.xLabels.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(widget.xLabels[i], style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (val, _) => Text(
                        val >= 1000 ? '${(val / 1000).toStringAsFixed(0)}k' : val.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(color: AppColors.divider, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: widget.series.map((s) {
                  final spots = s.values.asMap().entries.map((e) =>
                    FlSpot(e.key.toDouble(), e.value * _anim.value),
                  ).toList();
                  return LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: s.color,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                        radius: 3,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: s.color,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [s.color.withOpacity(0.2), s.color.withOpacity(0.0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Donut / Pie Chart Card
// ─────────────────────────────────────────────
class DonutChartCard extends StatefulWidget {
  final String title;
  final List<ChartPieData> data;
  final String centerLabel;
  final String centerValue;
  final double size;

  const DonutChartCard({
    super.key,
    required this.title,
    required this.data,
    required this.centerLabel,
    required this.centerValue,
    this.size = 130,
  });

  @override
  State<DonutChartCard> createState() => _DonutChartCardState();
}

class _DonutChartCardState extends State<DonutChartCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.data.fold(0.0, (s, d) => s + d.value);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.title, style: AppTextStyles.subtitle),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Donut
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (_, response) {
                          setState(() {
                            _touchedIndex = response?.touchedSection?.touchedSectionIndex ?? -1;
                          });
                        },
                      ),
                      startDegreeOffset: -90,
                      sectionsSpace: 2,
                      centerSpaceRadius: widget.size * 0.3,
                      sections: widget.data.asMap().entries.map((e) {
                        final i = e.key;
                        final d = e.value;
                        final isTouched = _touchedIndex == i;
                        return PieChartSectionData(
                          value: d.value * _anim.value,
                          color: d.color,
                          radius: isTouched ? widget.size * 0.28 : widget.size * 0.23,
                          showTitle: false,
                        );
                      }).toList(),
                    ),
                  ),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(widget.centerValue,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text(widget.centerLabel, style: AppTextStyles.caption),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Legend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.data.asMap().entries.map((e) {
                final i = e.key;
                final d = e.value;
                final pct = total > 0 ? ((d.value / total) * 100).toStringAsFixed(0) : '0';
                final isTouched = _touchedIndex == i;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(color: d.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(d.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isTouched ? FontWeight.w700 : FontWeight.w500,
                        color: isTouched ? d.color : AppColors.textSecondary,
                      ))),
                    Text('${d.value.toInt()}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isTouched ? d.color : AppColors.textPrimary,
                      )),
                    const SizedBox(width: 4),
                    Text('($pct%)', style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                  ]),
                );
              }).toList(),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Horizontal Funnel Bar (Pipeline Sales)
// ─────────────────────────────────────────────
class FunnelBarChart extends StatelessWidget {
  final List<ChartBarData> stages;
  final int total;

  const FunnelBarChart({super.key, required this.stages, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Pipeline Prospek', style: AppTextStyles.subtitle),
        const SizedBox(height: 4),
        Text('Total $total prospek aktif', style: AppTextStyles.caption),
        const SizedBox(height: 16),
        ...stages.map((s) {
          final pct = total > 0 ? (s.value / total).clamp(0.0, 1.0) : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                SizedBox(
                  width: 80,
                  child: Text(s.label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: pct),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (_, val, __) => LinearProgressIndicator(
                        value: val,
                        minHeight: 20,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(s.color),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${s.value.toInt()}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: s.color),
                    textAlign: TextAlign.end,
                  ),
                ),
              ]),
            ]),
          );
        }),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Mini Sparkline (inline progress chart)
// ─────────────────────────────────────────────
class SparklineCard extends StatelessWidget {
  final String title;
  final String value;
  final List<double> sparkData;
  final Color color;
  final String? trend;

  const SparklineCard({
    super.key,
    required this.title,
    required this.value,
    required this.sparkData,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final spots = sparkData.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    final maxVal = sparkData.fold(0.0, (m, v) => v > m ? v : m);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          if (trend != null) ...[
            const SizedBox(width: 6),
            Text(trend!, style: AppTextStyles.caption.copyWith(
              color: trend!.startsWith('+') ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w700,
            )),
          ],
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxVal * 1.2,
              lineTouchData: const LineTouchData(enabled: false),
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
