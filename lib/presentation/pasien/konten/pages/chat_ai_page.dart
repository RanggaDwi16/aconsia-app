import 'dart:async';

import 'package:aconsia_app/assignment/controllers/get_assignments_by_pasien/fetch_assignments_by_pasien_provider.dart';
import 'package:aconsia_app/assignment/controllers/mark_as_completed/post_mark_as_completed_provider.dart';
import 'package:aconsia_app/core/main/data/models/quiz_result_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/services/openai_service.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/fetch_konten_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/ai_recommendation_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_comprehension_score_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_main_shell_scope.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

enum _FinishFlowState {
  idle,
  saving,
  saved,
  saveFailed,
  navigateFailed,
  completed,
}

enum _CompletionMode {
  locked,
  ready,
}

enum _AnswerQuality {
  strong,
  partial,
  weak,
}

enum _RetryFlowState {
  idle,
  buildingSummary,
  persistingAttempt,
  preparingNewSession,
  navigating,
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
    this.sessionId,
  });

  final String? kontenId;
  final String? sourceScreen;
  final String? sessionId;

  @override
  ConsumerState<ChatAiPage> createState() => _ChatAiPageState();
}

class _ChatAiPageState extends ConsumerState<ChatAiPage> {
  static const int _initialComprehensionScore = 0;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<HybridMessage> _messages = <HybridMessage>[];
  final List<HybridQuestion> _questions = <HybridQuestion>[];
  final Set<int> _weakSections = <int>{};
  final Set<int> _strongSections = <int>{};
  final Map<int, String> _sectionMap = <int, String>{};
  final List<_QuestionOutcome> _questionOutcomes = <_QuestionOutcome>[];

  HybridSessionState _sessionState = HybridSessionState.intro;
  bool _isTyping = false;
  bool _isBootstrapping = false;
  bool _isFinishing = false;
  bool _isSubmittingAnswer = false;
  bool _waitingManualAnswer = false;
  bool _aiOnlineReady = false;
  _FinishFlowState _finishFlowState = _FinishFlowState.idle;
  _RetryFlowState _retryFlowState = _RetryFlowState.idle;
  String _aiNotReadyReason = 'ai_not_ready_missing_key';
  int _currentQuestionIndex = 0;
  int _comprehensionScore = _initialComprehensionScore;
  int _sessionAttempt = 1;
  late final String _sessionBaseId;

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
    _sessionBaseId = widget.sessionId?.trim().isNotEmpty == true
        ? widget.sessionId!.trim()
        : 'ai_chat_${DateTime.now().millisecondsSinceEpoch}';
    _bootstrapChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recoverStuckFinishingStateIfNeeded();
  }

  void _recoverStuckFinishingStateIfNeeded() {
    if (!_isFinishing) return;
    if (_isTyping || _isBootstrapping || _isSubmittingAnswer) return;
    if (_retryFlowState != _RetryFlowState.idle) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isFinishing) return;
      setState(() => _isFinishing = false);
      debugPrint('[CHAT_AI] retry_flow | phase=finish_recovered');
    });
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
    if (mounted) {
      setState(() => _isBootstrapping = true);
    }

    try {
      _contextData = await _resolveContext();
      final aiStatus = ref.read(aiRuntimeStatusProvider);
      _aiOnlineReady = aiStatus.openAiReady;
      _aiNotReadyReason = aiStatus.reason;
      debugPrint(
        '[CHAT_AI] bootstrap | aiOnlineReady=$_aiOnlineReady | provider=${aiStatus.provider} | source=${aiStatus.source} | apiKeyPresent=${aiStatus.apiKeyPresent} | openAiReady=${aiStatus.openAiReady} | reason=${aiStatus.reason}',
      );
      unawaited(_syncProfileCacheFromLastKnownScore());
      _buildQuestionsFromContext(_contextData);

      _addAiMessage(
        _aiOnlineReady
            ? 'Hai! Saya adalah AI Assistant online. Sesi ini terdiri dari 3 pertanyaan, dan skor dihitung dari jawaban sesi ini. 😊'
            : 'Hai! Saya adalah AI Assistant mode lokal. Sesi ini terdiri dari 3 pertanyaan, dan skor dihitung dari jawaban sesi ini. 😊',
        questionType: 'proactive',
      );

      if (!mounted) return;
      await _simulateTyping(const Duration(milliseconds: 900));
      await _askNextQuestion();
    } catch (e) {
      debugPrint('[CHAT_AI] bootstrap | failed | reason=$e');
    } finally {
      if (mounted) {
        setState(() => _isBootstrapping = false);
      }
    }
  }

  Future<void> _syncProfileCacheFromLastKnownScore() async {
    final uid = _safeCurrentUid();
    if (uid.isEmpty) return;

    try {
      final lastKnown =
          await ref.read(pasienComprehensionScoreProvider(uid).future);
      final latestScore = lastKnown.score.clamp(0, 100);
      if (latestScore <= 0) return;

      final firestore = FirebaseFirestore.instance;
      final pasienProfilesRef = firestore.collection('pasien_profiles');
      final primaryProfileRef = pasienProfilesRef.doc(uid);
      final sameUidProfiles = await pasienProfilesRef
          .where('uid', isEqualTo: uid)
          .limit(20)
          .get();

      final payload = <String, dynamic>{
        'comprehensionScore': latestScore,
        'lastQuizScore': latestScore,
        'lastQuizSource':
            lastKnown.source.trim().isNotEmpty ? lastKnown.source : _sourceTag,
        'lastQuizScoringModelVersion': 'normalized_v1',
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (lastKnown.latestCompletedAt != null) {
        payload['lastQuizCompletedAt'] =
            Timestamp.fromDate(lastKnown.latestCompletedAt!);
      }

      final batch = firestore.batch();
      batch.set(primaryProfileRef, payload, SetOptions(merge: true));
      var syncedDocs = 1;
      for (final doc in sameUidProfiles.docs) {
        if (doc.reference.path == primaryProfileRef.path) continue;
        batch.set(doc.reference, payload, SetOptions(merge: true));
        syncedDocs += 1;
      }
      await batch.commit();
      debugPrint(
        '[CHAT_AI] profile_cache_repair | status=success | pasienId=$uid | score=$latestScore | syncedDocs=$syncedDocs',
      );
    } catch (e) {
      debugPrint('[CHAT_AI] profile_cache_repair | status=failed | reason=$e');
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

    final evaluation = _evaluateQuickOption(q, option);
    _applyEvaluation(
      question: q,
      quality: evaluation.quality,
      feedback: evaluation.feedback,
    );

    setState(() => _sessionState = HybridSessionState.assessmentFeedback);
    await _simulateTyping(const Duration(milliseconds: 1200));
    _currentQuestionIndex += 1;
    await _askNextQuestion();
  }

  Future<void> _handleManualSubmit() async {
    final text = _messageController.text.trim();
    if (text.isEmpty ||
        !_waitingManualAnswer ||
        _isTyping ||
        _isSubmittingAnswer) {
      return;
    }

    final q = _questions[_currentQuestionIndex];
    setState(() => _isSubmittingAnswer = true);

    try {
      _messageController.clear();
      _addUserMessage(text);
      await _simulateTyping(const Duration(milliseconds: 950));

      final evaluation = await _evaluateWithAiOrFallback(q, text);
      _applyEvaluation(
        question: q,
        quality: evaluation.quality,
        feedback: evaluation.feedback,
      );

      setState(() {
        _waitingManualAnswer = false;
        _sessionState = HybridSessionState.assessmentFeedback;
      });
      await _simulateTyping(const Duration(milliseconds: 1200));
      _currentQuestionIndex += 1;
      await _askNextQuestion();
    } finally {
      if (mounted) {
        setState(() => _isSubmittingAnswer = false);
      }
    }
  }

  Future<_HybridEvaluation> _evaluateWithAiOrFallback(
    HybridQuestion question,
    String answer,
  ) async {
    if (!_aiOnlineReady) {
      debugPrint(
        '[CHAT_AI] evaluate | mode=local_fallback | reason=$_aiNotReadyReason | question="${question.question}"',
      );
      return _evaluateLocally(question, answer);
    }

    try {
      debugPrint(
        '[CHAT_AI] evaluate | mode=openai_direct_attempt | question="${question.question}"',
      );
      final openAi = ref.read(openAIServiceProvider);
      final result = await openAi.evaluateAnswer(
        question: question.question,
        userAnswer: answer,
        keyPoints: <String>[
          question.correctAnswer,
          ...question.expectedKeywords,
          question.explanation,
        ],
      );

      final scoreRaw = result['score'];
      final score = scoreRaw is num ? scoreRaw.toInt() : 0;
      final feedback = (result['feedback'] as String?)?.trim();
      final clarification = (result['clarification'] as String?)?.trim();
      final finalFeedback = [
        if (feedback != null && feedback.isNotEmpty) feedback,
        if (clarification != null && clarification.isNotEmpty) clarification,
      ].join(' ');

      if (score >= 75) {
        debugPrint(
          '[CHAT_AI] evaluate_result | mode=openai_direct_success | score=$score | bucket=strong',
        );
        return _HybridEvaluation(
          quality: _AnswerQuality.strong,
          feedback: finalFeedback.isEmpty
              ? '✅ Jawaban Anda sangat baik. Kita lanjut ke pertanyaan berikutnya.'
              : '✅ $finalFeedback',
        );
      }

      if (score >= 55) {
        debugPrint(
          '[CHAT_AI] evaluate_result | mode=openai_direct_success | score=$score | bucket=medium',
        );
        return _HybridEvaluation(
          quality: _AnswerQuality.partial,
          feedback: finalFeedback.isEmpty
              ? 'Jawaban Anda cukup baik, tapi masih bisa diperdalam. ${question.explanation}'
              : finalFeedback,
        );
      }

      debugPrint(
        '[CHAT_AI] evaluate_result | mode=openai_direct_success | score=$score | bucket=weak',
      );
      return _HybridEvaluation(
        quality: _AnswerQuality.weak,
        feedback: finalFeedback.isEmpty
            ? 'Jawaban Anda belum tepat. ${question.explanation}'
            : finalFeedback,
      );
    } on AiUnavailableError catch (e) {
      debugPrint(
        '[CHAT_AI] evaluate | mode=local_fallback | reason=${e.reason}',
      );
      return _evaluateLocally(question, answer);
    } catch (_) {
      debugPrint(
        '[CHAT_AI] evaluate | mode=local_fallback | reason=ai_request_failed_upstream',
      );
      return _evaluateLocally(question, answer);
    }
  }

  _HybridEvaluation _evaluateQuickOption(
    HybridQuestion question,
    String answer,
  ) {
    final isQuickCorrect = answer == question.correctAnswer;
    if (isQuickCorrect) {
      return const _HybridEvaluation(
        quality: _AnswerQuality.strong,
        feedback:
            '✅ Benar! Pemahaman Anda sangat baik. Kita lanjut ke pertanyaan berikutnya.',
      );
    }

    return _HybridEvaluation(
      quality: _AnswerQuality.weak,
      feedback:
          'Jawaban Anda belum tepat. Yang paling sesuai: "${question.correctAnswer}". ${question.explanation}',
    );
  }

  _HybridEvaluation _evaluateLocally(
    HybridQuestion question,
    String answer,
  ) {
    final normalized = answer.toLowerCase();
    final isQuickOption =
        question.options.contains(answer) && !answer.contains('💬');
    if (isQuickOption) {
      return _evaluateQuickOption(question, answer);
    }

    final matchCount =
        question.expectedKeywords.where((k) => normalized.contains(k)).length;

    if (matchCount >= 2) {
      return const _HybridEvaluation(
        quality: _AnswerQuality.strong,
        feedback:
            '✅ Benar! Pemahaman Anda sangat baik. Kita lanjut ke pertanyaan berikutnya.',
      );
    }

    if (matchCount == 1) {
      return _HybridEvaluation(
        quality: _AnswerQuality.partial,
        feedback:
            'Jawaban Anda sudah mengarah benar, tapi perlu detail tambahan. ${question.explanation}',
      );
    }

    if (normalized.contains('belum') ||
        normalized.contains('tidak yakin') ||
        normalized.length < 20) {
      return _HybridEvaluation(
        quality: _AnswerQuality.weak,
        feedback:
            'Tidak apa-apa. ${question.explanation} Silakan baca ulang bagian terkait ya. 📖',
      );
    }

    return _HybridEvaluation(
      quality: _AnswerQuality.weak,
      feedback:
          'Jawaban Anda belum tepat. Yang paling sesuai: "${question.correctAnswer}". ${question.explanation}',
    );
  }

  void _applyEvaluation({
    required HybridQuestion question,
    required _AnswerQuality quality,
    required String feedback,
  }) {
    if (quality == _AnswerQuality.strong) {
      _strongSections.add(question.relatedSection);
    } else {
      _weakSections.add(question.relatedSection);
    }
    _questionOutcomes.add(
      _QuestionOutcome(
        questionIndex: _currentQuestionIndex,
        relatedSection: question.relatedSection,
        quality: quality,
      ),
    );
    _comprehensionScore = _calculateComprehensionScore();
    _addAiMessage(feedback, questionType: 'assessment');
  }

  int _calculateComprehensionScore() {
    if (_questions.isEmpty || _questionOutcomes.isEmpty) return 0;
    final totalPoint = _questionOutcomes.fold<double>(
      0,
      (total, outcome) => total + outcome.points,
    );
    final maxPoint = _questions.length * 1.0;
    if (maxPoint <= 0) return 0;
    final normalized = (totalPoint / maxPoint) * 100;
    return normalized.round().clamp(0, 100);
  }

  void _completeSession() {
    final weak = _weakSections.toList()..sort();
    final weakLines = weak
        .map((idx) => '• Section $idx: ${_sectionMap[idx] ?? 'Bagian Materi'}')
        .join('\n');
    final ready = _comprehensionScore >= 80;

    var text = '🎉 Sesi evaluasi selesai. Tingkat pemahaman Anda saat ini: '
        '$_comprehensionScore%.';
    if (ready) {
      text += ' Anda sudah siap untuk informed consent!';
    } else if (weakLines.isNotEmpty) {
      text += '\n\nUntuk lanjut ke tahap berikutnya, Anda perlu minimal 80%.'
          '\n\nSaya lihat Anda masih perlu memperkuat:\n$weakLines'
          '\n\nSilakan baca kembali bagian tersebut untuk meningkatkan pemahaman. 📖';
    } else {
      text += '\n\nUntuk lanjut ke tahap berikutnya, Anda perlu minimal 80%.'
          '\n\nSilakan baca materi lagi agar pemahaman semakin baik. 📖';
    }

    setState(() {
      _sessionState = HybridSessionState.completed;
    });
    _addAiMessage(text, questionType: 'recommendation');
  }

  Future<void> _finishAndNavigate() async {
    if (_sessionState != HybridSessionState.completed || _isTyping) return;
    if (_isFinishing) return;
    if (_comprehensionScore < 80) {
      _showFinishMessage(
        'Skor pemahaman belum memenuhi syarat. Minimal 80% untuk menyelesaikan sesi.',
      );
      return;
    }
    _setFinishState(_FinishFlowState.saving);
    setState(() => _isFinishing = true);
    debugPrint('[CHAT_AI] finish_start | phase=build_summary');

    Map<String, dynamic> summary = const <String, dynamic>{};
    try {
      summary = await _buildSummary();
      debugPrint('[CHAT_AI] finish_step | phase=build_summary_success');

      debugPrint('[CHAT_AI] finish_step | phase=persist_start');
      await _persistSessionResult(summary)
          .timeout(const Duration(seconds: 10));
      _setFinishState(_FinishFlowState.saved);
      debugPrint('[CHAT_AI] finish_step | phase=persist_success');
    } on TimeoutException {
      _setFinishState(_FinishFlowState.saveFailed);
      debugPrint('[CHAT_AI] finish_step | phase=persist_fail | reason=timeout');
      _showFinishMessage(
        'Penyimpanan sesi terlalu lama. Data mungkin belum lengkap, tapi Anda bisa lanjut ke dashboard.',
      );
    } catch (e) {
      _setFinishState(_FinishFlowState.saveFailed);
      debugPrint('[CHAT_AI] finish_step | phase=persist_fail | reason=$e');
      _showFinishMessage(
        'Sebagian hasil sesi belum tersimpan sempurna. Silakan cek dashboard.',
      );
    }

    final navigated = await _navigateAfterFinish();
    if (navigated) {
      _setFinishState(_FinishFlowState.completed);
      debugPrint('[CHAT_AI] finish_step | phase=navigate_success');
      return;
    }

    _setFinishState(_FinishFlowState.navigateFailed);
    debugPrint('[CHAT_AI] finish_step | phase=navigate_fail');
    if (mounted) {
      setState(() => _isFinishing = false);
      _showFinishMessage(
        'Gagal berpindah ke dashboard. Silakan tekan tombol kembali.',
      );
    }
  }

  Future<void> _persistCurrentAttempt({
    required String trigger,
  }) async {
    _setFinishState(_FinishFlowState.saving);
    _setRetryFlowState(_RetryFlowState.buildingSummary);
    debugPrint('[CHAT_AI] retry_flow | phase=build_summary_start | via=$trigger');
    try {
      final summary = await _buildSummary().timeout(const Duration(seconds: 8));
      debugPrint('[CHAT_AI] retry_flow | phase=build_summary_success');
      _setRetryFlowState(_RetryFlowState.persistingAttempt);
      debugPrint('[CHAT_AI] retry_flow | phase=persist_start');
      await _persistSessionResult(summary).timeout(const Duration(seconds: 8));
      _setFinishState(_FinishFlowState.saved);
      debugPrint('[CHAT_AI] retry_flow | phase=persist_success');
    } on TimeoutException {
      _setFinishState(_FinishFlowState.saveFailed);
      debugPrint(
        '[CHAT_AI] retry_flow | phase=build_summary_or_persist_fail | reason=timeout',
      );
      _showFinishMessage(
        'Penyimpanan terlalu lama, sesi baru tetap dimulai.',
      );
    } catch (e) {
      _setFinishState(_FinishFlowState.saveFailed);
      debugPrint(
        '[CHAT_AI] retry_flow | phase=build_summary_or_persist_fail | reason=$e',
      );
      _showFinishMessage(
        'Sesi sebelumnya belum tersimpan sempurna, tetapi Anda bisa lanjut.',
      );
    } finally {
      _setRetryFlowState(_RetryFlowState.idle);
    }
  }

  Future<void> _handleRetrySession() async {
    if (!_isCompletedLocked) return;
    if (_isFinishing) {
      debugPrint('[CHAT_AI] retry_flow | ignored | reason=already_running');
      return;
    }

    if (mounted) {
      setState(() => _isFinishing = true);
    }
    try {
      await _persistCurrentAttempt(trigger: 'retry');
      if (!mounted) return;

      _setRetryFlowState(_RetryFlowState.preparingNewSession);
      debugPrint('[CHAT_AI] retry_flow | phase=session_reset_start');
      _resetForRetryAttempt();
      debugPrint(
        '[CHAT_AI] retry_reset_done | attemptNo=$_sessionAttempt | score=$_comprehensionScore',
      );
      await _bootstrapChat();
      debugPrint('[CHAT_AI] retry_flow | phase=session_reset_success');
    } finally {
      _setRetryFlowState(_RetryFlowState.idle);
      if (mounted) {
        setState(() => _isFinishing = false);
      }
    }
  }

  Future<void> _handleBackToDashboardFromLocked() async {
    if (!_isCompletedLocked) return;
    if (_isFinishing) {
      debugPrint('[CHAT_AI] retry_flow | ignored | reason=already_running');
      return;
    }

    if (mounted) {
      setState(() => _isFinishing = true);
    }
    try {
      await _persistCurrentAttempt(trigger: 'back_to_dashboard');
      _setRetryFlowState(_RetryFlowState.navigating);
      final navigated = await _navigateAfterFinish();
      if (navigated) {
        _setFinishState(_FinishFlowState.completed);
        debugPrint('[CHAT_AI] retry_flow | phase=navigate_success');
        return;
      }

      _setFinishState(_FinishFlowState.navigateFailed);
      if (mounted) {
        _showFinishMessage('Gagal kembali ke dashboard. Silakan coba lagi.');
      }
    } finally {
      _setRetryFlowState(_RetryFlowState.idle);
      if (mounted) {
        setState(() => _isFinishing = false);
      }
    }
  }

  Future<bool> _navigateAfterFinish() async {
    if (!mounted) return false;

    try {
      final inMainShell = PasienMainShellScope.maybeOf(context) != null;
      ref.read(selectedIndexPasienProvider.notifier).state = 0;

      if (inMainShell) {
        if (GoRouter.of(context).canPop()) {
          context.pop();
        }
        return true;
      }
      context.goNamed(RouteName.mainPasien);
      return true;
    } catch (e) {
      debugPrint('[CHAT_AI] navigate_primary_fail | reason=$e');
    }

    if (!mounted) return false;
    try {
      ref.read(selectedIndexPasienProvider.notifier).state = 0;
      if (GoRouter.of(context).canPop()) {
        context.pop();
      } else {
        context.go(RouteName.mainPasien);
      }
      debugPrint('[CHAT_AI] navigate_recovered | via=fallback');
      return true;
    } catch (e) {
      debugPrint('[CHAT_AI] navigate_recovered_fail | reason=$e');
      return false;
    }
  }

  void _setFinishState(_FinishFlowState next) {
    _finishFlowState = next;
  }

  void _setRetryFlowState(_RetryFlowState next) {
    _retryFlowState = next;
  }

  void _resetForRetryAttempt() {
    if (!mounted) return;
    setState(() {
      _sessionAttempt += 1;
      _sessionState = HybridSessionState.intro;
      _finishFlowState = _FinishFlowState.idle;
      _isTyping = false;
      _isBootstrapping = false;
      _isSubmittingAnswer = false;
      _waitingManualAnswer = false;
      _currentQuestionIndex = 0;
      _comprehensionScore = _initialComprehensionScore;
      _messages.clear();
      _weakSections.clear();
      _strongSections.clear();
      _questionOutcomes.clear();
      _messageController.clear();
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _showFinishMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _finishButtonLabel() {
    if (_comprehensionScore < 80) return 'Minimal 80% untuk Selesai';
    if (!_isFinishing) return 'Selesai & Kembali ke Dashboard';
    switch (_finishFlowState) {
      case _FinishFlowState.saving:
        return 'Menyimpan hasil sesi...';
      case _FinishFlowState.saved:
        return 'Mengarahkan ke dashboard...';
      case _FinishFlowState.saveFailed:
        return 'Menyelesaikan sesi...';
      case _FinishFlowState.navigateFailed:
        return 'Gagal berpindah, coba lagi';
      case _FinishFlowState.completed:
        return 'Selesai';
      case _FinishFlowState.idle:
        return 'Selesai & Kembali ke Dashboard';
    }
  }

  String _retryPrimaryButtonLabel() {
    if (!_isFinishing) return 'Ulangi Sesi AI';
    switch (_retryFlowState) {
      case _RetryFlowState.buildingSummary:
        return 'Menyusun ringkasan attempt...';
      case _RetryFlowState.persistingAttempt:
        return 'Menyimpan attempt sebelumnya...';
      case _RetryFlowState.preparingNewSession:
        return 'Menyiapkan sesi baru...';
      case _RetryFlowState.navigating:
        return 'Mengalihkan ke dashboard...';
      case _RetryFlowState.idle:
        return 'Ulangi Sesi AI';
    }
  }

  _CompletionMode get _completionMode =>
      _comprehensionScore >= 80 ? _CompletionMode.ready : _CompletionMode.locked;

  bool get _isCompletedReady =>
      _sessionState == HybridSessionState.completed &&
      _completionMode == _CompletionMode.ready;

  bool get _isCompletedLocked =>
      _sessionState == HybridSessionState.completed &&
      _completionMode == _CompletionMode.locked;

  String get _resolvedKontenId {
    final kontenId = (_contextData.konten.id ?? '').trim();
    return kontenId.isEmpty ? 'standalone_ai' : kontenId;
  }

  bool get _isStandaloneSession {
    return _resolvedKontenId == 'standalone_ai';
  }

  String get _sourceTag {
    final source = (widget.sourceScreen ?? '').trim();
    if (source.isNotEmpty) return source;
    return _isStandaloneSession ? 'ai_chat_standalone' : 'ai_chat_contextual';
  }

  String get _resolvedSessionId {
    return '${_sessionBaseId}_a$_sessionAttempt';
  }

  String _safeCurrentUid() {
    try {
      return FirebaseAuth.instance.currentUser?.uid ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> _persistSessionResult(Map<String, dynamic> summary) async {
    final uid = _safeCurrentUid();
    if (uid.isEmpty) return;
    final resolvedSessionId = _resolvedSessionId;

    final resultModel = QuizResultModel(
      id: '',
      pasienId: uid,
      kontenId: _resolvedKontenId,
      sessionId: resolvedSessionId,
      overallScore: summary['overall_score'] is num
          ? (summary['overall_score'] as num).toInt()
          : _comprehensionScore,
      status: (summary['status'] as String?)?.trim().isNotEmpty == true
          ? (summary['status'] as String).trim()
          : 'fair',
      strengths: (summary['strengths'] as List?)
              ?.map((e) => e.toString())
              .where((e) => e.trim().isNotEmpty)
              .toList(growable: false) ??
          const <String>[],
      areasToImprove: (summary['areas_to_improve'] as List?)
              ?.map((e) => e.toString())
              .where((e) => e.trim().isNotEmpty)
              .toList(growable: false) ??
          const <String>[],
      summary: (summary['summary'] as String?)?.trim().isNotEmpty == true
          ? (summary['summary'] as String).trim()
          : 'Ringkasan sesi AI berhasil disimpan.',
      recommendations: (summary['recommendations'] as List?)
              ?.map((e) => e.toString())
              .where((e) => e.trim().isNotEmpty)
              .toList(growable: false) ??
          const <String>[],
      motivationalMessage: (summary['motivational_message'] as String?)?.trim(),
      questionResults: <Map<String, dynamic>>[
        ..._messages.map((e) => e.toJson()),
        <String, dynamic>{
          '_meta': <String, dynamic>{
            'source': _sourceTag,
            'sessionType': _isStandaloneSession ? 'standalone_ai' : 'konten_ai',
            'attemptNo': _sessionAttempt,
            'completionMode':
                _completionMode == _CompletionMode.ready ? 'ready' : 'locked',
            'passedThreshold': _comprehensionScore >= 80,
            'scoringModelVersion': 'normalized_v1',
          },
        },
      ],
      completedAt: DateTime.now(),
    );

    try {
      final saveNotifier = ref.read(saveQuizResultProvider.notifier);
      await saveNotifier.save(resultModel);
      final saveState = ref.read(saveQuizResultProvider);
      if (saveState.hasError) {
        throw saveState.error ?? Exception('save_quiz_result_failed');
      }

      final latestScore = resultModel.overallScore.clamp(0, 100);
      final profilePayload = <String, dynamic>{
        'comprehensionScore': latestScore,
        'lastQuizScore': latestScore,
        'lastQuizCompletedAt': FieldValue.serverTimestamp(),
        'lastQuizSessionId': resolvedSessionId,
        'lastQuizSource': _sourceTag,
        'lastQuizScoringModelVersion': 'normalized_v1',
        'updatedAt': FieldValue.serverTimestamp(),
      };
      final firestore = FirebaseFirestore.instance;
      final pasienProfilesRef = firestore.collection('pasien_profiles');
      final primaryProfileRef = pasienProfilesRef.doc(uid);
      final sameUidProfiles = await pasienProfilesRef
          .where('uid', isEqualTo: uid)
          .limit(20)
          .get();
      final batch = firestore.batch();
      batch.set(primaryProfileRef, profilePayload, SetOptions(merge: true));
      var syncedDocs = 1;
      for (final doc in sameUidProfiles.docs) {
        if (doc.reference.path == primaryProfileRef.path) continue;
        batch.set(doc.reference, profilePayload, SetOptions(merge: true));
        syncedDocs += 1;
      }
      await batch.commit();
      debugPrint(
        '[CHAT_AI] profile_cache_sync | status=success | pasienId=$uid | sessionId=$resolvedSessionId | score=$latestScore | source=$_sourceTag | syncedDocs=$syncedDocs',
      );

      ref.invalidate(fetchAiRecommendationsProvider);
      ref.invalidate(fetchAllUnreadKontenProvider);
      ref.invalidate(fetchAllQuizResultsProvider);
      ref.invalidate(pasienComprehensionScoreProvider(uid));
      debugPrint(
        '[CHAT_AI] persist | saved=true | kontenId=$_resolvedKontenId | source=$_sourceTag | score=$latestScore',
      );
    } catch (e) {
      debugPrint('[CHAT_AI] persist | saved=false | reason=$e');
      debugPrint(
        '[CHAT_AI] profile_cache_sync | status=failed | pasienId=$uid | sessionId=$resolvedSessionId | reason=$e',
      );
      rethrow;
    }

    if (!_isStandaloneSession) {
      final currentSessionId = resolvedSessionId;
      if (currentSessionId.isNotEmpty &&
          !currentSessionId.startsWith('standalone_')) {
        try {
          await ref
              .read(endReadingSessionProvider.notifier)
              .endSession(sessionId: currentSessionId);
        } catch (e) {
          debugPrint('[CHAT_AI] end_session | failed=$e');
        }
      }
    }

    if (!_isStandaloneSession &&
        (summary['overall_score'] is num
                ? (summary['overall_score'] as num).toInt()
                : _comprehensionScore) >=
            70) {
      final assignmentId = await _getAssignmentId(
        pasienId: uid,
        kontenId: _resolvedKontenId,
      );
      if (assignmentId != null) {
        try {
          await ref
              .read(postMarkAsCompletedProvider.notifier)
              .postMarkAsCompleted(assignmentId: assignmentId);
        } catch (e) {
          debugPrint('[CHAT_AI] mark_completed | failed=$e');
        }
      }
    }
  }

  Future<String?> _getAssignmentId({
    required String pasienId,
    required String kontenId,
  }) async {
    try {
      final assignments = await ref.read(
        fetchAssignmentsByPasienProvider(pasienId: pasienId).future,
      );
      if (assignments == null || assignments.isEmpty) return null;
      for (final assignment in assignments) {
        if (assignment.kontenId == kontenId && !assignment.isCompleted) {
          return assignment.id;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _buildSummary() async {
    if (_aiOnlineReady) {
      try {
        debugPrint('[CHAT_AI] summary | mode=openai_direct_start');
        final openAi = ref.read(openAIServiceProvider);
        final aiSummary = await openAi.generateChatSummary(
          kontenTitle: _contextData.kontenTitle,
          conversationHistory: _messages
              .map(
                (m) => <String, String>{
                  'role': m.type == 'user' ? 'user' : 'assistant',
                  'content': m.content,
                },
              )
              .toList(growable: false),
        );
        aiSummary['overall_score'] = _comprehensionScore;
        debugPrint('[CHAT_AI] summary | mode=openai_direct_success');
        return aiSummary;
      } on AiUnavailableError catch (e) {
        debugPrint(
          '[CHAT_AI] summary | mode=local_fallback | reason=${e.reason}',
        );
        // fallback to local summary below
      } catch (_) {
        debugPrint(
          '[CHAT_AI] summary | mode=local_fallback | reason=ai_request_failed_upstream',
        );
      }
    }

    debugPrint(
      '[CHAT_AI] summary | mode=local_fallback | reason=$_aiNotReadyReason',
    );
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

    return <String, dynamic>{
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
    final uid = _safeCurrentUid();
    final comprehensionState = uid.isEmpty
        ? null
        : ref.watch(pasienComprehensionScoreProvider(uid)).valueOrNull;
    final hasLastKnownScore = (comprehensionState?.latestCompletedAt != null);
    final lastKnownScoreText = hasLastKnownScore
        ? '${comprehensionState!.score}%'
        : '-';

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
              _buildHeader(lastKnownScoreText: lastKnownScoreText),
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
              if (_isCompletedReady)
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
                      onPressed: (_isFinishing || _comprehensionScore < 80)
                          ? null
                          : _finishAndNavigate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _comprehensionScore >= 80
                            ? const Color(0xFF059669)
                            : const Color(0xFF94A3B8),
                        disabledBackgroundColor: const Color(0xFFCBD5E1),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(
                        _comprehensionScore >= 80
                            ? Icons.check_circle_outline
                            : Icons.lock_outline_rounded,
                      ),
                      label: Text(_finishButtonLabel()),
                    ),
                  ),
                ),
              if (_isCompletedLocked)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    UiSpacing.md,
                    UiSpacing.xs,
                    UiSpacing.md,
                    UiSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _isFinishing ? null : _handleRetrySession,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF93C5FD),
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: _isFinishing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.refresh_rounded),
                          label: Text(_retryPrimaryButtonLabel()),
                        ),
                      ),
                      const Gap(UiSpacing.xs),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          onPressed:
                              _isFinishing ? null : _handleBackToDashboardFromLocked,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: UiPalette.slate700,
                            side: const BorderSide(color: UiPalette.slate300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.home_outlined, size: 18),
                          label: const Text('Kembali ke Dashboard'),
                        ),
                      ),
                    ],
                  ),
                ),
              _buildInputArea(completed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required String lastKnownScoreText}) {
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
                          decoration: BoxDecoration(
                            color: _aiOnlineReady
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFB45309),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          _aiOnlineReady ? 'Online AI' : 'Mode Lokal',
                          style: UiTypography.caption.copyWith(
                            color: _aiOnlineReady
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFB45309),
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
                  'Sesi Ini',
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
                Text(
                  'Skor Terakhir: $lastKnownScoreText',
                  style: UiTypography.caption.copyWith(
                    color: UiPalette.slate500,
                    fontSize: 11,
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
    final sendBusy = !completed &&
        (_isTyping || _isBootstrapping || _isSubmittingAnswer || _isFinishing);
    final disabled = completed || sendBusy;
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !disabled,
                    minLines: 1,
                    maxLines: 3,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _handleManualSubmit(),
                    decoration: InputDecoration(
                      hintText: _waitingManualAnswer
                          ? 'Ketik jawaban Anda di sini...'
                          : 'Ketik jawaban Anda di sini...',
                      filled: true,
                      fillColor: UiPalette.slate50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: UiSpacing.sm,
                        vertical: UiSpacing.sm,
                      ),
                      suffixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIcon: !_waitingManualAnswer
                          ? Padding(
                              padding: const EdgeInsets.only(
                                right: UiSpacing.sm,
                                top: 14,
                                bottom: 14,
                              ),
                              child: Container(
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
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: UiPalette.slate200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: UiPalette.slate200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: UiPalette.blue500,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(UiSpacing.sm),
                SizedBox(
                  width: 56,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: disabled ? null : _handleManualSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UiPalette.blue600,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF93C5FD),
                      elevation: disabled ? 0 : 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: sendBusy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            completed
                                ? Icons.check_rounded
                                : Icons.send_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
            const Gap(UiSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡'),
                const Gap(6),
                Expanded(
                  child: Text(
                    completed
                        ? (_comprehensionScore >= 80
                            ? 'Sesi selesai. Tekan tombol Selesai untuk kembali ke dashboard.'
                            : 'Skor belum 80%. Tekan Ulangi Sesi AI untuk mencoba lagi.')
                        : (sendBusy
                            ? 'AI sedang memproses jawaban Anda...'
                            : 'Tip: Pilih quick reply atau ketik manual untuk jawaban lebih detail'),
                    style: UiTypography.caption.copyWith(
                      color: completed
                          ? (_comprehensionScore >= 80
                              ? const Color(0xFF166534)
                              : const Color(0xFFB45309))
                          : (sendBusy
                              ? const Color(0xFF1D4ED8)
                              : UiPalette.slate500),
                      fontWeight: (sendBusy || completed)
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
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

class _HybridEvaluation {
  const _HybridEvaluation({
    required this.quality,
    required this.feedback,
  });

  final _AnswerQuality quality;
  final String feedback;
}

class _QuestionOutcome {
  const _QuestionOutcome({
    required this.questionIndex,
    required this.relatedSection,
    required this.quality,
  });

  final int questionIndex;
  final int relatedSection;
  final _AnswerQuality quality;

  double get points {
    switch (quality) {
      case _AnswerQuality.strong:
        return 1.0;
      case _AnswerQuality.partial:
        return 0.5;
      case _AnswerQuality.weak:
        return 0.0;
    }
  }
}
