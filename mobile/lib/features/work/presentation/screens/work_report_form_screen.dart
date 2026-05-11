import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/work_report_model.dart';
import '../providers/work_report_provider.dart';

class WorkReportFormScreen extends ConsumerStatefulWidget {
  final WorkReport? report;
  const WorkReportFormScreen({super.key, this.report});

  @override
  ConsumerState<WorkReportFormScreen> createState() => _WorkReportFormScreenState();
}

class _WorkReportFormScreenState extends ConsumerState<WorkReportFormScreen> {
  final _contentCtrl = TextEditingController();
  final _achievementsCtrl = TextEditingController();
  final _challengesCtrl = TextEditingController();
  DateTime _reportDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.report != null) {
      _contentCtrl.text = widget.report!.content;
      _achievementsCtrl.text = widget.report!.achievements ?? '';
      _challengesCtrl.text = widget.report!.challenges ?? '';
      _reportDate = DateTime.tryParse(widget.report!.reportDate) ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    _achievementsCtrl.dispose();
    _challengesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _reportDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _reportDate = picked);
    }
  }

  Future<void> _submit() async {
    if (_contentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konten laporan wajib diisi'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isLoading = true);

    final notifier = ref.read(workReportNotifierProvider.notifier);
    try {
      if (widget.report == null) {
        await notifier.createWorkReport(
          reportDate: _reportDate,
          content: _contentCtrl.text.trim(),
          achievements: _achievementsCtrl.text.trim().isEmpty ? null : _achievementsCtrl.text.trim(),
          challenges: _challengesCtrl.text.trim().isEmpty ? null : _challengesCtrl.text.trim(),
        );
      } else {
        await notifier.updateWorkReport(
          widget.report!.id,
          content: _contentCtrl.text.trim(),
          achievements: _achievementsCtrl.text.trim().isEmpty ? null : _achievementsCtrl.text.trim(),
          challenges: _challengesCtrl.text.trim().isEmpty ? null : _challengesCtrl.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.report == null ? 'Laporan berhasil dibuat' : 'Laporan berhasil diperbarui'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal: ${e.toString()}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.report != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(isEdit ? 'Edit Laporan' : 'Buat Laporan', style: AppTextStyles.heading3),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textHint),
                const SizedBox(width: 10),
                Text(DateFormat('dd MMM yyyy').format(_reportDate), style: AppTextStyles.bodyMedium),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _contentCtrl,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Konten Laporan *',
              hintText: 'Deskripsikan aktivitas kerja hari ini...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _achievementsCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Pencapaian',
              hintText: 'Apa yang berhasil dicapai hari ini?',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _challengesCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Tantangan',
              hintText: 'Apa kesulitan yang dihadapi?',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(isEdit ? 'Simpan Perubahan' : 'Kirim Laporan'),
            ),
          ),
        ]),
      ),
    );
  }
}
