import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// ✨ OWNER AI CHAT (TE INTELLIGENCE)
/// Desain UI Premium untuk Asisten AI Owner
/// ============================================================

class OwnerAiChatScreen extends ConsumerStatefulWidget {
  const OwnerAiChatScreen({super.key});

  @override
  ConsumerState<OwnerAiChatScreen> createState() => _OwnerAiChatScreenState();
}

class _OwnerAiChatScreenState extends ConsumerState<OwnerAiChatScreen> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Halo Owner, saya TE Intelligence. Saya memiliki akses penuh ke data 16 cabang dan 350 karyawan Anda. Ada yang ingin Anda analisa hari ini?",
      isAi: true,
      time: "10:30",
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text,
        isAi: false,
        time: "10:32",
      ));
      _messageController.clear();
    });

    // Simulasi respon AI
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: "Berdasarkan data 1 tahun terakhir, Cabang Sam Ratulangi menunjukkan tren pertumbuhan 15%. Namun, stok di Cabang Arjasari perlu perhatian segera.",
            isAi: true,
            time: "10:32",
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'TE Intelligence',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.ownerColor, Color(0xFF1E1B4B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _buildChatBubble(_messages[index]),
              ),
            ),
            _buildQuickActions(),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: msg.isAi ? Colors.white.withOpacity(0.1) : AppColors.ownerColor.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(msg.isAi ? 4 : 20),
            bottomRight: Radius.circular(msg.isAi ? 20 : 4),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              msg.time,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = ['Analisa Sales 1Thn', 'Cek Performa Cabang', 'Stok Kritis'];
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => ActionChip(
          label: Text(actions[i], style: const TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
          onPressed: () {
            _messageController.text = actions[i];
            _sendMessage();
          },
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Tanyakan sesuatu...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_upward, color: AppColors.ownerColor, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isAi;
  final String time;

  ChatMessage({required this.text, required this.isAi, required this.time});
}
