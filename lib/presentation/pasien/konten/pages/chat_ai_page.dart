import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ChatAiPage extends StatefulWidget {
  const ChatAiPage({super.key});

  @override
  State<ChatAiPage> createState() => _ChatAiPageState();
}

class _ChatAiPageState extends State<ChatAiPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    // Pesan awal dari AI
    _messages.addAll([
      ChatMessage(
        text:
            'Halo! mari kita akan memulai tentang Persiapan Anestesi Regional. Siapkah anda untuk mulai?',
        isUser: false,
        time: '10:01',
      ),
      ChatMessage(
        text:
            'Hmm, sihhh nggak paham bntulan anestesi tu artinya apa sih? tlng, CMIIW yaa ngarahin mau tu sebisanya kalnya pls mksdjurufjinya',
        isUser: true,
        time: '10:02',
      ),
      ChatMessage(
        text: 'Baik pak!😃',
        isUser: false,
        time: '10:02',
      ),
      ChatMessage(
        text:
            'Anestesi regional adalah jenis anestesi yang cara membius atau membuat hilang rasa di area tertentu pada tubuh dengan cara kerjanya adalah dengan cara menyuntikkan obat anestesi tanpa kehilangan kesadaran.',
        isUser: false,
        time: '10:02',
      ),
      ChatMessage(
        text:
            'Anestesi regional ini mencakup diantaranya anestesi spinal, epidural, dan blok saraf.',
        isUser: false,
        time: '10:02',
      ),
      ChatMessage(
        text:
            'Nunggu apa(😉)? gimana sudah sekarang dengan sepengen mu(✌) yuk, JDI, CMIIW pak!',
        isUser: false,
        time: '10:02',
      ),
      ChatMessage(
        text: 'Iyaaa!😃',
        isUser: true,
        time: '10:03',
      ),
      ChatMessage(
        text:
            'Klik tombol "Selesaikan quiz" penting untuk bisa melihat umpan balik dan nilai yang sudah anda raih.',
        isUser: false,
        time: '10:03',
      ),
      ChatMessage(
        text:
            'Nah, sekarang performamu adalah penting. Mari kita lanjut menuju suatu pemeriksaan lebih lanjut, dan kamu harus bisa menulis lebih banyak ya dengan kesempatan ini yang adalah kesempatan penting sekali unatukmu',
        isUser: false,
        time: '10:03',
      ),
      ChatMessage(
        text:
            'Substrat pertanyaan bergihan aman dan percayanya berhadapan berapa berapa cara menentukan anggia aord pendl[pekjt nya tersekat tau temuan kesadaran....',
        isUser: false,
        time: '10:03',
      ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text,
        isUser: true,
        time: _getCurrentTime(),
      ));
      _messageController.clear();
    });

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kuis Berbasis AI',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Button.filled(
              onPressed: () => context.pushNamed(RouteName.hasilChatAi),
              label: 'Selesai Kuis',
              height: 36,
              width: context.deviceWidth * 0.34,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages Area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message);
              },
            ),
          ),

          // Input Area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: Row(
                children: [
                  // Text Input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan...',
                          hintStyle: TextStyle(
                            color: AppColor.textGrayColor,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  Gap(12),
                  // Send Button
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 22,
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

  Widget _buildChatBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            // AI Avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology,
                size: 18,
                color: AppColor.primaryColor,
              ),
            ),
            Gap(8),
          ],

          // Message Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? AppColor.primaryColor.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(message.isUser ? 16 : 4),
                      topRight: Radius.circular(message.isUser ? 4 : 16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: message.isUser
                        ? null
                        : Border.all(
                            color: AppColor.borderColor,
                            width: 1,
                          ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.textColor,
                      height: 1.4,
                    ),
                  ),
                ),
                Gap(4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColor.textGrayColor,
                    ),
                    Gap(4),
                    Text(
                      message.time,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColor.textGrayColor,
                      ),
                    ),
                    if (message.isUser) ...[
                      Gap(4),
                      Icon(
                        Icons.check,
                        size: 14,
                        color: AppColor.primaryColor,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          if (message.isUser) ...[
            Gap(8),
            // User Avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}
