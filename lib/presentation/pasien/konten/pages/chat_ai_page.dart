import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/fetch_konten_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum HybridSessionState {
  intro,
  questioning,
  assessmentFeedback,
  completed,
}

class HybridQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int relatedSection;
  final List<String> expectedKeywords;
  final String explanation;

  const HybridQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.relatedSection,
    required this.expectedKeywords,
    required this.explanation,
  });
}

class HybridMessage {
  final String id;
  final String type; // ai|user
  final String content;
  final DateTime timestamp;
  final String questionType; // proactive|assessment|followup|recommendation
  final List<String> options;
  final String? correctAnswer;
  final int? relatedSection;

  const HybridMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    required this.questionType,
    this.options = const <String>[],
    this.correctAnswer,
    this.relatedSection,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'questionType': questionType,
        'options': options,
        'correctAnswer': correctAnswer,
        'relatedSection': relatedSection,
      };
}

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

  final List<HybridMessage> _messages = <HybridMessage>[];
  final List<HybridQuestion> _questions = <HybridQuestion>[];
  final Set<int> _weakSections = <int>{};
  final Set<int> _strongSections = <int>{};
  final Map<int, String> _sectionMap = <int, String>{};

  HybridSessionState _sessionState = HybridSessionState.intro;
  bool _isTyping = false;
  bool _isBootstrapping = false;
  bool _waitingManualAnswer = false;
  int _currentQuestionIndex = 0;
  int _comprehensionScore = 60;

  _ChatContext _contextData = const _ChatContext(
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

  @override
  void initState() {
    super.initState();
    _bootstrapChat();
  }

  Future<_ChatContext> _resolveContext() async {
    final kontenId = widget.kontenId;

    if (kontenId == null || kontenId.isEmpty) {
      return _contextData;
    }

    try {
      final konten = await ref.read(
        fetchKontenByIdProvider(kontenId: kontenId).future,
      );
      final sections = await ref.read(
        fetchSectionsByKontenIdProvider(kontenId: kontenId).future,
      );
      final validSections =
          sections.where((e) => (e.isiKonten ?? '').trim().isNotEmpty).toList();

      return _ChatContext(
        konten: konten,
        kontenTitle: (konten.judul ?? '').trim().isNotEmpty
            ? konten.judul!.trim()
            : 'Sesi AI Pembelajaran',
        sectionTitles: validSections
            .map((e) => (e.judulBagian ?? '').trim().isNotEmpty
                ? e.judulBagian!.trim()
                : 'Bagian Materi')
            .toList(growable: false),
        sectionContents:
            validSections.map((e) => (e.isiKonten ?? '').trim()).toList(),
      );
    } catch (_) {
      return _contextData;
    }
  }

  Future<void> _bootstrapChat() async {
    if (_isBootstrapping) return;
    setState(() => _isBootstrapping = true);

    _contextData = await _resolveContext();
    _buildQuestionsFromContext(_contextData);

    _addAiMessage(
      'Hai! Saya adalah AI Assistant untuk edukasi informed consent anestesi. Saya akan menanyakan beberapa pertanyaan untuk memastikan pemahaman Anda. 😊',
      questionType: 'proactive',
    );

    if (!mounted) return;
    await _simulateTyping(const Duration(milliseconds: 900));
    await _askNextQuestion();
    if (mounted) {
      setState(() => _isBootstrapping = false);
    }
  }

  void _buildQuestionsFromContext(_ChatContext contextData) {
    _questions.clear();
    _sectionMap.clear();

    final titles = contextData.sectionTitles.isEmpty
        ? <String>['Pemahaman Umum Anestesi']
        : contextData.sectionTitles;
    for (var i = 0; i < titles.length; i++) {
      _sectionMap[i + 1] = titles[i];
    }

    final t1 = titles.isNotEmpty ? titles[0] : 'Persiapan Sebelum Operasi';
    final t2 = titles.length > 1 ? titles[1] : 'Risiko dan Keamanan';
    final t3 = titles.length > 2 ? titles[2] : 'Pemulihan Setelah Anestesi';

    _questions.addAll([
      HybridQuestion(
        question:
            'Mari kita mulai. Dari materi "$t1", mengapa pasien perlu mengikuti instruksi pra-operasi (misalnya puasa sesuai arahan dokter)?',
        options: const <String>[
          'Agar prosedur lebih aman dan risiko komplikasi berkurang',
          'Supaya proses administrasi lebih cepat',
          'Karena hanya formalitas rumah sakit',
          '💬 Saya ingin menjelaskan dengan kata-kata sendiri',
        ],
        correctAnswer:
            'Agar prosedur lebih aman dan risiko komplikasi berkurang',
        relatedSection: 1,
        expectedKeywords: const <String>[
          'aman',
          'risiko',
          'komplikasi',
          'puasa',
          'instruksi',
        ],
        explanation:
            'Instruksi pra-operasi penting untuk menurunkan risiko dan membantu tim medis menjaga keselamatan pasien.',
      ),
      HybridQuestion(
        question:
            'Bagus. Sekarang dari topik "$t2", apa yang paling tepat dilakukan jika Anda punya riwayat alergi obat?',
        options: const <String>[
          'Memberitahu dokter/tim anestesi sebelum tindakan',
          'Menunggu sampai ditanya saat di ruang operasi',
          'Tidak perlu disampaikan jika alerginya sudah lama',
          '💬 Saya ingin menjelaskan dengan kata-kata sendiri',
        ],
        correctAnswer: 'Memberitahu dokter/tim anestesi sebelum tindakan',
        relatedSection: 2,
        expectedKeywords: const <String>[
          'alergi',
          'dokter',
          'tim',
          'anestesi',
          'sampaikan',
        ],
        explanation:
            'Riwayat alergi harus disampaikan sejak awal agar tim dapat memilih rencana anestesi yang paling aman.',
      ),
      HybridQuestion(
        question:
            'Pertanyaan terakhir, dari materi "$t3": setelah tindakan selesai, apa yang biasanya terjadi pada fase pemulihan anestesi?',
        options: const <String>[
          'Pasien dipantau sampai kondisi sadar dan stabil',
          'Pasien langsung pulang tanpa observasi',
          'Pasien selalu tertidur sampai keesokan hari',
          '💬 Saya ingin menjelaskan dengan kata-kata sendiri',
        ],
        correctAnswer: 'Pasien dipantau sampai kondisi sadar dan stabil',
        relatedSection: 3,
        expectedKeywords: const <String>[
          'dipantau',
          'sadar',
          'stabil',
          'pemulihan',
          'observasi',
        ],
        explanation:
            'Pemulihan dilakukan dengan pemantauan ketat agar tim medis dapat memastikan kondisi pasien kembali stabil.',
      ),
    ]);
  }

  Future<void> _askNextQuestion() async {
    if (!mounted) return;
    if (_currentQuestionIndex >= _questions.length) {
      _completeSession();
      return;
    }

    setState(() {
      _sessionState = HybridSessionState.questioning;
      _waitingManualAnswer = false;
    });

    final q = _questions[_currentQuestionIndex];
    _addAiMessage(
      q.question,
      questionType: 'proactive',
      options: q.options,
      correctAnswer: q.correctAnswer,
      relatedSection: q.relatedSection,
    );
  }

  Future<void> _handleOptionTap(String option) async {
    if (_sessionState == HybridSessionState.completed || _isTyping) return;
    final q = _questions[_currentQuestionIndex];

    _addUserMessage(option);
    await _simulateTyping(const Duration(milliseconds: 900));

    if (option.contains('💬')) {
      setState(() {
        _waitingManualAnswer = true;
        _sessionState = HybridSessionState.assessmentFeedback;
      });
      _addAiMessage(
        'Silakan ketik jawaban Anda di kolom input di bawah. Saya akan menilai pemahaman Anda. 😊',
        questionType: 'assessment',
      );
      return;
    }

    final correct = option == q.correctAnswer;
    if (correct) {
      _strongSections.add(q.relatedSection);
      _comprehensionScore = (_comprehensionScore + 10).clamp(0, 100);
      _addAiMessage(
        '✅ Benar! Pemahaman Anda sangat baik. Kita lanjut ke pertanyaan berikutnya.',
        questionType: 'assessment',
      );
    } else if (option.contains('belum') || option.contains('tidak yakin')) {
      _weakSections.add(q.relatedSection);
      _comprehensionScore = (_comprehensionScore + 3).clamp(0, 100);
      _addAiMessage(
        'Tidak apa-apa. ${q.explanation} Silakan baca ulang bagian terkait ya. 📖',
        questionType: 'assessment',
      );
    } else {
      _weakSections.add(q.relatedSection);
      _comprehensionScore = (_comprehensionScore + 5).clamp(0, 100);
      _addAiMessage(
        'Jawaban Anda belum tepat. Yang paling sesuai: "${q.correctAnswer}". ${q.explanation}',
        questionType: 'assessment',
      );
    }

    setState(() => _sessionState = HybridSessionState.assessmentFeedback);
    await _simulateTyping(const Duration(milliseconds: 1200));
    _currentQuestionIndex += 1;
    await _askNextQuestion();
  }

  Future<void> _handleManualSubmit() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || !_waitingManualAnswer || _isTyping) return;

    final q = _questions[_currentQuestionIndex];
    _messageController.clear();
    _addUserMessage(text);
    await _simulateTyping(const Duration(milliseconds: 950));

    final normalized = text.toLowerCase();
    final matchCount =
        q.expectedKeywords.where((k) => normalized.contains(k)).length;

    if (matchCount >= 2) {
      _strongSections.add(q.relatedSection);
      _comprehensionScore = (_comprehensionScore + 8).clamp(0, 100);
      _addAiMessage(
        '✅ Bagus! Jawaban Anda menunjukkan pemahaman yang baik. Kita lanjut ke pertanyaan berikutnya.',
        questionType: 'assessment',
      );
    } else {
      _weakSections.add(q.relatedSection);
      _comprehensionScore = (_comprehensionScore + 3).clamp(0, 100);
      _addAiMessage(
        'Terima kasih, saya sarankan baca ulang bagian ini agar pemahaman lebih kuat. ${q.explanation}',
        questionType: 'assessment',
      );
    }

    setState(() {
      _waitingManualAnswer = false;
      _sessionState = HybridSessionState.assessmentFeedback;
    });
    await _simulateTyping(const Duration(milliseconds: 1200));
    _currentQuestionIndex += 1;
    await _askNextQuestion();
  }

  void _completeSession() {
    final weak = _weakSections.toList()..sort();
    final weakLines = weak
        .map((idx) => '• Section $idx: ${_sectionMap[idx] ?? 'Bagian Materi'}')
        .join('\n');
    final ready = _comprehensionScore >= 80;

    var text =
        '🎉 Luar biasa! Anda telah menyelesaikan sesi chat. Tingkat pemahaman Anda sekarang: $_comprehensionScore%.';
    if (ready) {
      text += ' Anda sudah siap untuk informed consent!';
    } else if (weakLines.isNotEmpty) {
      text += '\n\nSaya lihat Anda masih perlu memperkuat:\n$weakLines'
          '\n\nSilakan baca kembali bagian tersebut untuk meningkatkan pemahaman. 📖';
    } else {
      text += '\n\nSilakan baca materi lagi agar pemahaman semakin baik. 📖';
    }

    setState(() {
      _sessionState = HybridSessionState.completed;
    });
    _addAiMessage(text, questionType: 'recommendation');
  }

  Future<void> _finishAndNavigate() async {
    if (_sessionState != HybridSessionState.completed || _isTyping) return;
    final summary = _buildSummary();

    if (!mounted) return;
    context.pushReplacementNamed(
      RouteName.quizResult,
      extra: {
        'konten': _contextData.konten,
        'sessionId': 'standalone_${DateTime.now().millisecondsSinceEpoch}',
        'summary': summary,
        'quizResults': _messages.map((e) => e.toJson()).toList(growable: false),
        'source': widget.sourceScreen ?? 'ai_chat_standalone',
        'comprehensionScore': _comprehensionScore,
        'weakTopics': _weakSections
            .map((idx) => _sectionMap[idx] ?? 'Bagian Materi')
            .toList(growable: false),
      },
    );
  }

  Map<String, dynamic> _buildSummary() {
    final weakTitles = _weakSections
        .map((idx) => _sectionMap[idx] ?? 'Bagian Materi')
        .toSet()
        .toList(growable: false);
    final strengths = _strongSections
        .map((idx) => _sectionMap[idx] ?? 'Bagian Materi')
        .toSet()
        .toList(growable: false);

    final status = _comprehensionScore >= 80
        ? 'excellent'
        : _comprehensionScore >= 65
            ? 'good'
            : _comprehensionScore >= 45
                ? 'fair'
                : 'needs_improvement';

    final summaryText = _comprehensionScore >= 80
        ? 'Anda menunjukkan pemahaman yang baik terhadap materi edukasi anestesi.'
        : 'Pemahaman Anda sudah berkembang, namun masih ada beberapa area yang perlu diperkuat.';

    final motivational = _comprehensionScore >= 80
        ? 'Pertahankan pemahaman ini dan siapkan pertanyaan untuk dokter saat informed consent.'
        : 'Tetap semangat, baca ulang materi yang direkomendasikan agar Anda lebih siap.';

    return {
      'overall_score': _comprehensionScore,
      'status': status,
      'strengths': strengths.isEmpty
          ? ['Anda aktif menjawab sesi pembelajaran']
          : strengths,
      'areas_to_improve': weakTitles,
      'summary': summaryText,
      'recommendations': weakTitles
          .map((title) => 'Baca ulang materi: $title')
          .toList(growable: false),
      'motivational_message': motivational,
    };
  }

  Future<void> _simulateTyping(Duration duration) async {
    if (!mounted) return;
    setState(() => _isTyping = true);
    await Future<void>.delayed(duration);
    if (!mounted) return;
    setState(() => _isTyping = false);
  }

  void _addAiMessage(
    String content, {
    required String questionType,
    List<String> options = const <String>[],
    String? correctAnswer,
    int? relatedSection,
  }) {
    setState(() {
      _messages.add(
        HybridMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          type: 'ai',
          content: content,
          timestamp: DateTime.now(),
          questionType: questionType,
          options: options,
          correctAnswer: correctAnswer,
          relatedSection: relatedSection,
        ),
      );
    });
    _scrollToBottom();
  }

  void _addUserMessage(String content) {
    setState(() {
      _messages.add(
        HybridMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          type: 'user',
          content: content,
          timestamp: DateTime.now(),
          questionType: 'followup',
        ),
      );
    });
    _scrollToBottom();
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

  void _handleBackNavigation() {
    if (GoRouter.of(context).canPop()) {
      context.pop();
      return;
    }
    ref.read(selectedIndexPasienProvider.notifier).state = 0;
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completed = _sessionState == HybridSessionState.completed;

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
              _buildHeader(),
              Expanded(
                child: _isBootstrapping
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(
                          UiSpacing.md,
                          UiSpacing.md,
                          UiSpacing.md,
                          UiSpacing.sm,
                        ),
                        itemCount: _messages.length + (_isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_isTyping && index == _messages.length) {
                            return const _TypingDotsRow();
                          }
                          final msg = _messages[index];
                          return _HybridBubble(
                            message: msg,
                            isUser: msg.type == 'user',
                            timeText: _formatTime(msg.timestamp),
                            onOptionTap:
                                msg.type == 'ai' && msg.options.isNotEmpty
                                    ? _handleOptionTap
                                    : null,
                          );
                        },
                      ),
              ),
              if (completed)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    UiSpacing.md,
                    UiSpacing.xs,
                    UiSpacing.md,
                    UiSpacing.sm,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _finishAndNavigate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Selesai & Kembali ke Dashboard'),
                    ),
                  ),
                ),
              _buildInputArea(completed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        UiSpacing.md,
        UiSpacing.sm,
        UiSpacing.md,
        UiSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: UiPalette.white,
        border: Border(bottom: BorderSide(color: UiPalette.slate200)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _handleBackNavigation,
            icon: const Icon(Icons.arrow_back_rounded),
            color: UiPalette.slate700,
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.smart_toy, color: Colors.white),
                ),
                const Gap(UiSpacing.xs),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: UiTypography.label.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'Online',
                          style: UiTypography.caption.copyWith(
                            color: const Color(0xFF16A34A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: UiSpacing.sm,
              vertical: UiSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(color: const Color(0xFFBFDBFE)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pemahaman',
                  style: UiTypography.caption.copyWith(
                    color: UiPalette.slate500,
                  ),
                ),
                Text(
                  '$_comprehensionScore%',
                  style: UiTypography.body.copyWith(
                    color: UiPalette.blue600,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool completed) {
    final disabled = completed || _isTyping || _isBootstrapping;
    return Container(
      decoration: const BoxDecoration(
        color: UiPalette.white,
        border: Border(top: BorderSide(color: UiPalette.slate200)),
      ),
      padding: const EdgeInsets.fromLTRB(
        UiSpacing.md,
        UiSpacing.sm,
        UiSpacing.md,
        UiSpacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: _messageController,
                        enabled: !disabled,
                        onSubmitted: (_) => _handleManualSubmit(),
                        decoration: InputDecoration(
                          hintText: _waitingManualAnswer
                              ? 'Ketik jawaban Anda di sini...'
                              : 'Ketik jawaban Anda di sini... (opsional)',
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
                      Container(
                        margin: const EdgeInsets.only(right: UiSpacing.sm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Optional',
                          style: UiTypography.caption.copyWith(
                            color: const Color(0xFF3730A3),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(UiSpacing.sm),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: disabled ? null : _handleManualSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UiPalette.blue600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.send_rounded),
                  ),
                ),
              ],
            ),
            const Gap(UiSpacing.xs),
            Text(
              '💡 Tip: Pilih quick reply atau ketik manual untuk jawaban lebih detail',
              style: UiTypography.caption.copyWith(
                color: UiPalette.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HybridBubble extends StatelessWidget {
  const _HybridBubble({
    required this.message,
    required this.isUser,
    required this.timeText,
    required this.onOptionTap,
  });

  final HybridMessage message;
  final bool isUser;
  final String timeText;
  final ValueChanged<String>? onOptionTap;

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
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
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
                    message.content,
                    style: UiTypography.body.copyWith(color: textColor),
                  ),
                ),
                if (!isUser && message.options.isNotEmpty) ...[
                  const Gap(UiSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UiSpacing.xs,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '💡 Pilih jawaban atau ketik manual di bawah',
                      style: UiTypography.caption.copyWith(
                        color: const Color(0xFF6D28D9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  ...message.options.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: UiSpacing.xs),
                      child: InkWell(
                        onTap: onOptionTap == null
                            ? null
                            : () => onOptionTap!(option),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(UiSpacing.sm),
                          decoration: BoxDecoration(
                            color: option.contains('💬')
                                ? const Color(0xFFF5F3FF)
                                : UiPalette.white,
                            border: Border.all(
                              color: option.contains('💬')
                                  ? const Color(0xFFC4B5FD)
                                  : UiPalette.slate300,
                              width: 1.4,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            option,
                            style: UiTypography.bodySmall.copyWith(
                              color: option.contains('💬')
                                  ? const Color(0xFF6D28D9)
                                  : UiPalette.slate800,
                              fontWeight: option.contains('💬')
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const Gap(2),
                Text(
                  timeText,
                  style: UiTypography.caption.copyWith(
                    color: UiPalette.slate500,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const Gap(UiSpacing.xs),
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
        ],
      ),
    );
  }
}

class _TypingDotsRow extends StatefulWidget {
  const _TypingDotsRow();

  @override
  State<_TypingDotsRow> createState() => _TypingDotsRowState();
}

class _TypingDotsRowState extends State<_TypingDotsRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: UiSpacing.sm,
              vertical: UiSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: UiPalette.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: UiPalette.slate200),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (index) {
                      final value = ((_controller.value + (index * 0.2)) % 1.0);
                      final opacity = value < 0.5 ? 0.4 + value : 1.0 - value;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: UiPalette.slate500.withOpacity(opacity),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
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
