import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/services/openai_service.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/fetch_konten_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatAiPage extends ConsumerStatefulWidget {
  const ChatAiPage({
    super.key,
    this.kontenId,
    this.sourceScreen,
  });

  final String? kontenId;
  final String? sourceScreen;

  @override
  ConsumerState<ChatAiPage> createState() => _ChatAiPageState();
}

class _ChatAiPageState extends ConsumerState<ChatAiPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;
  bool _isBootstrapping = false;

  @override
  void initState() {
    super.initState();
    _startInitialConversation();
  }

  Future<_ChatContext> _resolveContext() async {
    final kontenId = widget.kontenId;

    if (kontenId == null || kontenId.isEmpty) {
      return const _ChatContext(
        konten: KontenModel(
          id: 'standalone_ai',
          judul: 'Sesi AI Pembelajaran',
        ),
        kontenTitle: 'Sesi AI Pembelajaran',
        sectionTitles: ['Pemahaman Umum Anestesi'],
        sectionContents: [
          'Bahas konsep anestesi, persiapan operasi, risiko, pemulihan, dan hal yang masih belum dipahami pasien.',
        ],
      );
    }

    try {
      final konten = await ref.read(
        fetchKontenByIdProvider(kontenId: kontenId).future,
      );
      final sections = await ref.read(
        fetchSectionsByKontenIdProvider(kontenId: kontenId).future,
      );

      final validSections = sections
              ?.where((e) => (e.isiKonten ?? '').trim().isNotEmpty)
              .toList() ??
          [];

      return _ChatContext(
        konten: konten ??
            const KontenModel(
              id: 'standalone_ai',
              judul: 'Sesi AI Pembelajaran',
            ),
        kontenTitle: (konten?.judul ?? '').trim().isNotEmpty
            ? konten!.judul!
            : 'Sesi AI Pembelajaran',
        sectionTitles: validSections
            .map((e) => (e.judulBagian ?? '').trim().isNotEmpty
                ? e.judulBagian!
                : 'Bagian Materi')
            .toList(),
        sectionContents: validSections.map((e) => e.isiKonten ?? '').toList(),
      );
    } catch (_) {
      return const _ChatContext(
        konten: KontenModel(
          id: 'standalone_ai',
          judul: 'Sesi AI Pembelajaran',
        ),
        kontenTitle: 'Sesi AI Pembelajaran',
        sectionTitles: ['Pemahaman Umum Anestesi'],
        sectionContents: [
          'Bahas konsep anestesi, persiapan operasi, risiko, pemulihan, dan hal yang masih belum dipahami pasien.',
        ],
      );
    }
  }

  Future<void> _startInitialConversation() async {
    if (_isBootstrapping) return;

    setState(() {
      _isBootstrapping = true;
    });

    final openAI = ref.read(openAIServiceProvider);
    final contextData = await _resolveContext();

    try {
      final greeting = await openAI.sendFreeChatMessage(
        message:
            'SYSTEM: Mulai percakapan dengan greeting singkat dan pertanyaan pembuka tentang materi.',
        kontenTitle: contextData.kontenTitle,
        sectionContents: contextData.sectionContents,
        sectionTitles: contextData.sectionTitles,
        conversationHistory: const [],
      );

      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..add({
            'role': 'assistant',
            'content': greeting,
          });
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..add({
            'role': 'assistant',
            'content':
                'Halo, saya AI Aconsia. Silakan ceritakan hal yang masih belum jelas terkait anestesi.',
          });
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBootstrapping = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_isLoading) return;

    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });

    _scrollToBottom();

    final openAI = ref.read(openAIServiceProvider);
    final contextData = await _resolveContext();

    try {
      final aiResponse = await openAI.sendFreeChatMessage(
        message: message,
        kontenTitle: contextData.kontenTitle,
        sectionContents: contextData.sectionContents,
        sectionTitles: contextData.sectionTitles,
        conversationHistory: _messages,
      );

      if (!mounted) return;
      setState(() {
        _messages.add({'role': 'assistant', 'content': aiResponse});
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim pesan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _finishSession() async {
    final userMessageCount =
        _messages.where((m) => m['role'] == 'user' && (m['content'] ?? '').trim().isNotEmpty).length;

    if (userMessageCount == 0 || _isLoading) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selesaikan Sesi AI?'),
        content: const Text(
          'Ringkasan pembelajaran akan dibuat dari percakapan ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Lanjut Diskusi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Selesaikan'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    final openAI = ref.read(openAIServiceProvider);
    final contextData = await _resolveContext();

    try {
      final summary = await openAI.generateChatSummary(
        kontenTitle: contextData.kontenTitle,
        conversationHistory: _messages,
      );

      if (!mounted) return;

      context.pushReplacementNamed(
        RouteName.quizResult,
        extra: {
          'konten': contextData.konten,
          'sessionId': 'standalone_${DateTime.now().millisecondsSinceEpoch}',
          'summary': summary,
          'quizResults': _messages,
          'source': widget.sourceScreen ?? 'ai_chat_standalone',
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat ringkasan: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userMessageCount =
        _messages.where((m) => m['role'] == 'user' && (m['content'] ?? '').trim().isNotEmpty).length;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [UiPalette.blue50, UiPalette.white],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  UiSpacing.xs,
                  UiSpacing.xs,
                  UiSpacing.xs,
                  UiSpacing.xxs,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: UiPalette.slate600,
                    ),
                    const Expanded(
                      child: Text(
                        'Sesi AI Pembelajaran',
                        style: UiTypography.title,
                      ),
                    ),
                    TextButton(
                      onPressed: userMessageCount == 0 || _isLoading
                          ? null
                          : _finishSession,
                      child: Text(
                        'Selesaikan',
                        style: UiTypography.body.copyWith(
                          color: userMessageCount == 0
                              ? UiPalette.slate400
                              : UiPalette.blue600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  UiSpacing.md,
                  UiSpacing.sm,
                  UiSpacing.md,
                  UiSpacing.xs,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiSpacing.sm,
                    vertical: UiSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: UiPalette.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: UiPalette.blue100),
                  ),
                  child: Text(
                    'Tanyakan hal yang belum jelas. AI akan membantu mengukur pemahaman Anda.',
                    style: UiTypography.caption.copyWith(
                      color: UiPalette.slate700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _isBootstrapping
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(
                          UiSpacing.md,
                          UiSpacing.xs,
                          UiSpacing.md,
                          UiSpacing.sm,
                        ),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return _ChatBubble(
                            text: message['content'] ?? '',
                            isUser: message['role'] == 'user',
                          );
                        },
                      ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: UiPalette.white,
                  border: Border(top: BorderSide(color: UiPalette.slate200)),
                ),
                padding: const EdgeInsets.fromLTRB(
                  UiSpacing.sm,
                  UiSpacing.xs,
                  UiSpacing.sm,
                  UiSpacing.sm,
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          minLines: 1,
                          maxLines: 4,
                          enabled: !_isLoading,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: 'Ketik pertanyaan Anda...',
                            hintStyle: UiTypography.bodySmall.copyWith(
                              color: UiPalette.slate500,
                            ),
                            filled: true,
                            fillColor: UiPalette.slate50,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: UiSpacing.sm,
                              vertical: UiSpacing.sm,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: UiPalette.slate200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: UiPalette.slate200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: UiPalette.blue500),
                            ),
                          ),
                        ),
                      ),
                      const Gap(UiSpacing.xs),
                      SizedBox(
                        width: 46,
                        height: 46,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _sendMessage,
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: UiPalette.blue600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send_rounded, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser ? UiPalette.blue600 : UiPalette.white;
    final textColor = isUser ? UiPalette.white : UiPalette.slate900;

    return Padding(
      padding: const EdgeInsets.only(bottom: UiSpacing.sm),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            const Gap(UiSpacing.xs),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UiSpacing.sm,
                vertical: UiSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 14 : 6),
                  topRight: Radius.circular(isUser ? 6 : 14),
                  bottomLeft: const Radius.circular(14),
                  bottomRight: const Radius.circular(14),
                ),
                border: isUser
                    ? null
                    : Border.all(color: UiPalette.slate200, width: 1),
              ),
              child: Text(
                text,
                style: UiTypography.body.copyWith(
                  color: textColor,
                ),
              ),
            ),
          ),
          if (isUser) const Gap(UiSpacing.xs),
          if (isUser)
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: UiPalette.blue600,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
        ],
      ),
    );
  }
}

class _ChatContext {
  const _ChatContext({
    required this.konten,
    required this.kontenTitle,
    required this.sectionContents,
    required this.sectionTitles,
  });

  final KontenModel konten;
  final String kontenTitle;
  final List<String> sectionContents;
  final List<String> sectionTitles;
}
