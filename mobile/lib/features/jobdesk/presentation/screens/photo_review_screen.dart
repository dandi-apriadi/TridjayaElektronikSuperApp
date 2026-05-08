import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/jobdesk_scoring_dummy_data.dart';
import '../../models/jobdesk_scoring_models.dart';

/// ============================================================
/// 📸 PHOTO REVIEW SCREEN - One by One Review
/// ============================================================
/// Screen untuk PIC review foto satu per satu:
/// - Zoom & pan photo
/// - Annotate/markup
/// - Input score per photo
/// - Navigate previous/next
/// ============================================================

class PhotoReviewScreen extends ConsumerStatefulWidget {
  final String submissionId;
  
  const PhotoReviewScreen({super.key, required this.submissionId});

  @override
  ConsumerState<PhotoReviewScreen> createState() => _PhotoReviewScreenState();
}

class _PhotoReviewScreenState extends ConsumerState<PhotoReviewScreen> {
  late PhotoReviewSession _session;
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TransformationController _transformationController = TransformationController();
  
  int _currentScore = 0;
  bool _isScored = false;

  @override
  void initState() {
    super.initState();
    _session = JobDeskScoringDummyData.getPhotoReviewSession();
    _currentScore = _session.score ?? 0;
    _isScored = _session.score != null;
    _scoreController.text = _currentScore > 0 ? _currentScore.toString() : '';
    _commentController.text = _session.comment ?? '';
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _commentController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Foto',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${_session.currentPhotoIndex + 1} / ${_session.totalPhotos}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          // Score Indicator
          if (_isScored)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getScoreColor(_currentScore),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_currentScore',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Photo Viewer
          Expanded(
            child: _buildPhotoViewer(),
          ),
          
          // Bottom Panel
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Task Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _session.taskName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Score Input
                  Row(
                    children: [
                      Text(
                        'Nilai:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _scoreController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: InputDecoration(
                              hintText: '0-100',
                              hintStyle: TextStyle(
                                color: Colors.white30,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) {
                              final score = int.tryParse(value) ?? 0;
                              setState(() {
                                _currentScore = score.clamp(0, 100);
                                _isScored = true;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Quick Scores
                      _buildQuickScoreButton(100, Colors.green),
                      const SizedBox(width: 8),
                      _buildQuickScoreButton(80, Colors.yellow),
                      const SizedBox(width: 8),
                      _buildQuickScoreButton(60, Colors.orange),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Comment Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _commentController,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Tambahkan komentar...',
                        hintStyle: TextStyle(
                          color: Colors.white30,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                        prefixIcon: Icon(
                          Icons.comment_outlined,
                          color: Colors.white30,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Navigation Buttons
                  Row(
                    children: [
                      // Previous
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _session.hasPrevious ? _goToPrevious : null,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Sebelumnya'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Save
                      ElevatedButton.icon(
                        onPressed: _saveScore,
                        icon: const Icon(Icons.check),
                        label: const Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Next
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _session.hasNext ? _goToNext : _finishReview,
                          icon: Icon(_session.hasNext ? Icons.arrow_forward : Icons.check_circle),
                          label: Text(_session.hasNext ? 'Selanjutnya' : 'Selesai'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoViewer() {
    return GestureDetector(
      onDoubleTap: _resetZoom,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Container(
            color: Colors.black,
            child: Image.network(
              _session.currentPhotoUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white54,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal memuat foto\n${error.toString()}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickScoreButton(int score, Color color) {
    final isSelected = _currentScore == score;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentScore = score;
          _isScored = true;
          _scoreController.text = score.toString();
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '$score',
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.yellow;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _goToPrevious() {
    if (_session.currentPhotoIndex > 0) {
      setState(() {
        _session = PhotoReviewSession(
          submissionId: _session.submissionId,
          userId: _session.userId,
          taskName: _session.taskName,
          photoUrls: _session.photoUrls,
          currentPhotoIndex: _session.currentPhotoIndex - 1,
          score: _session.score,
          comment: _session.comment,
          annotations: _session.annotations,
          startedAt: _session.startedAt,
          completedAt: _session.completedAt,
        );
        _resetZoom();
      });
    }
  }

  void _goToNext() {
    if (_session.currentPhotoIndex < _session.totalPhotos - 1) {
      setState(() {
        _session = PhotoReviewSession(
          submissionId: _session.submissionId,
          userId: _session.userId,
          taskName: _session.taskName,
          photoUrls: _session.photoUrls,
          currentPhotoIndex: _session.currentPhotoIndex + 1,
          score: _session.score,
          comment: _session.comment,
          annotations: _session.annotations,
          startedAt: _session.startedAt,
          completedAt: _session.completedAt,
        );
        _resetZoom();
      });
    }
  }

  void _saveScore() {
    // Save current score
    setState(() {
      _session = PhotoReviewSession(
        submissionId: _session.submissionId,
        userId: _session.userId,
        taskName: _session.taskName,
        photoUrls: _session.photoUrls,
        currentPhotoIndex: _session.currentPhotoIndex,
        score: _currentScore,
        comment: _commentController.text,
        annotations: _session.annotations,
        startedAt: _session.startedAt,
        completedAt: DateTime.now(),
      );
      _isScored = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Nilai $_currentScore disimpan'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _finishReview() {
    _saveScore();
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selesai Review?'),
        content: Text(
          'Anda telah memberikan nilai $_currentScore untuk ${_session.taskName}.\n\n'
          'Lanjutkan ke submission berikutnya?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tetap di Sini'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Go back to queue
            },
            child: const Text('Ke Queue'),
          ),
        ],
      ),
    );
  }
}
