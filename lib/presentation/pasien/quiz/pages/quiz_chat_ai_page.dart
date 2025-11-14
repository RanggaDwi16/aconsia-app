import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/services/openai_service.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizChatAiPage extends HookConsumerWidget {
  final KontenModel konten;
  final List<KontenSectionModel> sections;
  final String sessionId; // Reading session ID

  const QuizChatAiPage({
    super.key,
    required this.konten,
    required this.sections,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openAI = ref.watch(openAIServiceProvider);

    // FREE CHAT MODE State management
    final isLoading = useState(false);
    final messages = useState<List<Map<String, String>>>([]);
    final answerController = useTextEditingController();
    final scrollController = useScrollController();
    final hasStarted = useState(false);

    // Extract section data for AI context
    final sectionContents = sections.map((s) => s.isiKonten ?? '').toList();
    final sectionTitles =
        sections.map((s) => s.judulBagian ?? 'Materi').toList();

    // Send initial greeting on first load - GET FROM OPENAI
    useEffect(() {
      if (!hasStarted.value) {
        Future.microtask(() async {
          hasStarted.value = true;
          isLoading.value = true;

          try {
            // Get natural greeting from OpenAI
            final greeting = await openAI.sendFreeChatMessage(
              message:
                  'SYSTEM: Mulai percakapan dengan greeting singkat dan pertanyaan pembuka tentang materi.',
              kontenTitle: konten.judul ?? 'Materi Pembelajaran',
              sectionContents: sectionContents,
              sectionTitles: sectionTitles,
              conversationHistory: [],
            );

            messages.value = [
              {
                'role': 'assistant',
                'content': greeting,
              }
            ];
          } catch (e) {
            // Fallback jika gagal - tampilkan error
            messages.value = [
              {
                'role': 'assistant',
                'content':
                    'Maaf, gagal terhubung dengan AI. Coba refresh halaman atau cek koneksi internet Anda.',
              }
            ];
          } finally {
            isLoading.value = false;
          }
        });
      }
      return null;
    }, []);

    // Auto-scroll to bottom when new message
    void scrollToBottom() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    // Send user message and get AI response
    Future<void> sendMessage() async {
      if (answerController.text.trim().isEmpty) {
        return;
      }

      final userMessage = answerController.text.trim();
      answerController.clear();

      // Add user message to chat
      messages.value = [
        ...messages.value,
        {'role': 'user', 'content': userMessage}
      ];
      scrollToBottom();

      isLoading.value = true;

      try {
        // Get AI response with konten context
        final aiResponse = await openAI.sendFreeChatMessage(
          message: userMessage,
          kontenTitle: konten.judul ?? 'Materi Pembelajaran',
          sectionContents: sectionContents,
          sectionTitles: sectionTitles,
          conversationHistory: messages.value,
        );

        // Add AI response to chat
        messages.value = [
          ...messages.value,
          {'role': 'assistant', 'content': aiResponse}
        ];
        scrollToBottom();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim pesan: $e')),
        );
      } finally {
        isLoading.value = false;
      }
    }

    // Finish quiz and generate summary
    Future<void> finishQuiz() async {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Selesai Belajar?'),
          content: const Text(
            'Anda yakin sudah selesai belajar? AI akan membuat rangkuman pembelajaran Anda.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Belum'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
              ),
              child: const Text('Ya, Selesai'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      isLoading.value = true;

      try {
        // Generate summary from chat history
        final summary = await openAI.generateChatSummary(
          kontenTitle: konten.judul ?? 'Materi Pembelajaran',
          conversationHistory: messages.value,
        );

        // Navigate to result page
        if (context.mounted) {
          context.pushReplacementNamed(
            RouteName.quizResult,
            extra: {
              'konten': konten,
              'sessionId': sessionId,
              'summary': summary, // Pre-generated summary from chat
              'quizResults': [], // Empty for free chat mode
            },
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal generate rangkuman: $e')),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    // Count user messages only (exclude AI greeting)
    final userMessageCount =
        messages.value.where((m) => m['role'] == 'user').length;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Quiz Pembelajaran',
        centertitle: true,
        actions: [
          // Finish Quiz button - disabled if no user messages yet
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed:
                  userMessageCount == 0 || isLoading.value ? null : finishQuiz,
              style: TextButton.styleFrom(
                foregroundColor:
                    userMessageCount == 0 ? Colors.grey : AppColor.primaryColor,
              ),
              child: const Text('Selesai Quiz'),
            ),
          ),
        ],
      ),
      body: isLoading.value && !hasStarted.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Chat messages
                Expanded(
                  child: messages.value.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.value.length,
                          itemBuilder: (context, index) {
                            final message = messages.value[index];
                            final isUser = message['role'] == 'user';

                            return Column(
                              crossAxisAlignment: isUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (isUser)
                                  _buildUserBubble(message['content']!)
                                else
                                  _buildAIBubble(message['content']!),
                                const Gap(16),
                              ],
                            );
                          },
                        ),
                ),

                // Input area
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: answerController,
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Tanya apa saja tentang materi ini...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          enabled: !isLoading.value,
                          onSubmitted: (_) => sendMessage(),
                        ),
                      ),
                      const Gap(8),
                      IconButton(
                        onPressed: isLoading.value ? null : sendMessage,
                        icon: isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send),
                        color: AppColor.primaryColor,
                        iconSize: 28,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAIBubble(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.smart_toy, color: Colors.white, size: 14),
                  Gap(4),
                  Text(
                    'AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8),
            // Message bubble
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xFFE8F4FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textColor,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // User badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.primaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: Colors.white, size: 14),
                  Gap(4),
                  Text(
                    'Anda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8),
            // Message bubble
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColor.primaryGreen.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textColor,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
