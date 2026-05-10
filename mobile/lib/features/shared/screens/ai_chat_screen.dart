import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';

/// ============================================================
/// 🤖 AI CHAT SCREEN (Shared)
/// AI Assistant untuk semua roles
/// ============================================================

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  // Suggested questions based on role
  final List<String> _suggestedQuestions = [
    'Bagaimana cara mengajukan cuti?',
    'Cara cek slip gaji bulan ini',
    'Bagaimana proses reimbursement?',
    'Jadwal meeting hari ini',
    'Cara update profil',
    'Bagaimana laporan kinerja saya?',
  ];

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Halo! Saya adalah AI Assistant Tridjaya SuperApp. Ada yang bisa saya bantu? 😊',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'suggestions': [
        'Bagaimana cara mengajukan cuti?',
        'Cek slip gaji',
        'Status tugas hari ini',
      ],
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text,
        'time': DateTime.now(),
      });
      _messageController.clear();
      _isTyping = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'isUser': false,
            'text': _generateAIResponse(text),
            'time': DateTime.now(),
            'suggestions': _generateSuggestions(text),
          });
        });
        _scrollToBottom();
      }
    });
  }

  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('cuti') || lowerMessage.contains('izin')) {
      return 'Untuk mengajukan cuti, Anda bisa:\n\n1. Buka menu **Pengajuan Cuti & Izin**\n2. Pilih jenis cuti (Tahunan/Sakit/Darurat)\n3. Tentukan tanggal mulai dan selesai\n4. Isi alasan pengajuan\n5. Submit dan tunggu approval\n\nSisa cuti tahunan Anda: **7 hari**\n\nButuh bantuan lain?';
    } else if (lowerMessage.contains('gaji') || lowerMessage.contains('payroll')) {
      return 'Slip gaji bulan ini:\n\n💰 **Gaji Pokok**: Rp 5.000.000\n📦 **Tunjangan**: Rp 1.300.000\n⏰ **Lembur**: Rp 1.000.000\n\n💵 **Total Gaji**: Rp 7.300.000\n📉 **Potongan**: Rp 400.000\n\n🎯 **Gaji Bersih**: **Rp 6.900.000**\n\nStatus: ⏳ Menunggu pembayaran (tanggal 25)\n\nLihat detail lengkap di menu **Slip Gaji**.';
    } else if (lowerMessage.contains('tugas') || lowerMessage.contains('task')) {
      return 'Tugas Anda hari ini:\n\n✅ **Selesai (2)**\n- Input data penjualan\n- Follow up customer ABC\n\n⏳ **Berjalan (1)**\n- Kunjungan prospek PT Maju Jaya (deadline: 17:00)\n\n⏰ **Pending (1)**\n- Meeting tim (15:00 WIB)\n\nSemangat! 💪';
    } else if (lowerMessage.contains('jadwal') || lowerMessage.contains('schedule')) {
      return 'Jadwal Anda hari ini, 10 Mei 2024:\n\n🕘 09:00 - Daily standup meeting\n🕙 10:30 - Kunjungan prospek\n🕐 13:00 - Istirahat\n🕒 15:00 - Meeting tim\n🕔 17:00 - Deadline tugas\n\nAda 1 event lain di minggu ini.';
    } else if (lowerMessage.contains('profil') || lowerMessage.contains('profile')) {
      return 'Untuk update profil:\n\n1. Buka **Pengaturan** > **Profil**\n2. Edit data yang ingin diubah\n3. Upload foto profil (opsional)\n4. Klik **Simpan**\n\nData yang bisa diupdate:\n- Nama lengkap\n- No. telepon\n- Email\n- Alamat\n- Foto profil';
    } else {
      return 'Maaf, saya belum memahami pertanyaan Anda dengan baik.\n\nBeberapa hal yang bisa saya bantu:\n\n• Informasi cuti dan izin\n• Slip gaji dan payroll\n• Status tugas dan job desk\n• Jadwal dan meeting\n• Panduan penggunaan aplikasi\n\nSilakan pilih topik di atas atau ketik pertanyaan lain. 😊';
    }
  }

  List<String> _generateSuggestions(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('cuti')) {
      return ['Sisa cuti saya berapa?', 'Cara cek riwayat cuti', 'Ajukan cuti sekarang'];
    } else if (lowerMessage.contains('gaji')) {
      return ['Riwayat gaji', 'Komponen potongan', 'Cetak slip gaji'];
    } else if (lowerMessage.contains('tugas')) {
      return ['Submit tugas', 'Lihat deadline', 'Laporan kinerja'];
    }
    return ['Terima kasih', 'Bantuan lain', 'Hubungi admin'];
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF10A37F), // AI green color
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDot(0),
                        _buildDot(1),
                        _buildDot(2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Quick Suggestions
          if (_messages.isNotEmpty && _messages.last['suggestions'] != null)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: (_messages.last['suggestions'] as List<String>)
                    .map((suggestion) => _buildSuggestionChip(suggestion))
                    .toList(),
              ),
            ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.primary),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_messageController.text),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10A37F),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.textHint.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10A37F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 16,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isUser ? Colors.white : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeFormat.format(message['time']),
                    style: TextStyle(
                      fontSize: 11,
                      color: isUser
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: () => _sendMessage(text),
        label: Text(text),
        backgroundColor: const Color(0xFF10A37F).withOpacity(0.1),
        side: BorderSide(color: const Color(0xFF10A37F).withOpacity(0.3)),
        labelStyle: const TextStyle(
          color: Color(0xFF10A37F),
          fontSize: 13,
        ),
      ),
    );
  }
}
