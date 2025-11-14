import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_service.g.dart';

/// OpenAI Service using free tier gpt-4o-mini
/// Handles quiz generation, chat, and comprehension analysis
class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  final String _apiKey;
  final bool _useMockMode;

  OpenAIService()
      : _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '',
        _useMockMode = dotenv.env['USE_MOCK_AI'] == 'true' {
    // Debug logging
    print(
        '🔑 OpenAI API Key loaded: ${_apiKey.isNotEmpty ? "YES (${_apiKey.substring(0, 10)}...)" : "NO"}');
    print('🤖 Mock Mode: $_useMockMode');
    print('📝 USE_MOCK_AI env value: ${dotenv.env['USE_MOCK_AI']}');
  }

  /// Generate quiz questions based on konten sections
  /// Returns list of questions in Indonesian
  Future<Map<String, dynamic>> generateQuizQuestions({
    required String kontenTitle,
    required List<String> sectionContents,
    required List<String> sectionTitles,
    int questionCount = 5,
  }) async {
    // Mock mode for development without OpenAI API
    if (_useMockMode) {
      return _generateMockQuestions(
        kontenTitle,
        questionCount,
        sectionTitles,
        sectionContents,
      );
    }

    try {
      // Build detailed content context for AI
      String contentContext = '';
      for (int i = 0; i < sectionContents.length; i++) {
        final title =
            i < sectionTitles.length ? sectionTitles[i] : 'Bagian ${i + 1}';
        final content = sectionContents[i];
        contentContext += '\n\n=== $title ===\n$content';
      }

      final prompt = '''
Kamu adalah asisten edukasi medis untuk aplikasi Aconsia (Anesthesia Consent).
Berdasarkan materi edukasi berikut, buatlah $questionCount pertanyaan pemahaman yang relevan untuk pasien yang akan menjalani anestesi.

Judul Materi: $kontenTitle

Konten Materi:$contentContext

INSTRUKSI PENTING:
1. Buat pertanyaan dalam Bahasa Indonesia yang mudah dipahami pasien awam
2. Fokus pada pemahaman konsep penting dari ISI KONTEN yang diberikan, bukan hafalan
3. Pertanyaan harus SPESIFIK mengacu pada topik dan informasi yang ADA di konten
4. Hindari istilah medis yang terlalu teknis
5. Gunakan judul bagian (${sectionTitles.isNotEmpty ? sectionTitles.join(', ') : kontenTitle}) dalam pertanyaan agar kontekstual
6. Pertanyaan terbuka yang mendorong pasien menjelaskan dengan kata-kata sendiri
7. JANGAN gunakan "bagian 1, 2, 3" - gunakan judul bagian yang SEBENARNYA

Format response JSON:
{
  "questions": [
    {
      "id": 1,
      "question": "Pertanyaan di sini...",
      "key_points": ["Poin penting 1", "Poin penting 2"],
      "difficulty": "easy|medium|hard"
    }
  ]
}
''';

      final response = await _sendChatRequest(prompt);
      return response;
    } catch (e) {
      // If API error, return mock data instead of crashing
      if (e.toString().contains('quota') || e.toString().contains('401')) {
        print('⚠️ OpenAI API quota exceeded, using mock data');
        return _generateMockQuestions(
          kontenTitle,
          questionCount,
          sectionTitles,
          sectionContents,
        );
      }
      throw Exception('Gagal generate quiz: $e');
    }
  }

  /// Evaluate user's answer to a quiz question
  /// Returns comprehension score (0-100) and feedback
  Future<Map<String, dynamic>> evaluateAnswer({
    required String question,
    required String userAnswer,
    required List<String> keyPoints,
  }) async {
    // Mock mode for development
    if (_useMockMode) {
      return _generateMockEvaluation(userAnswer);
    }

    try {
      final prompt = '''
Kamu adalah evaluator medis untuk aplikasi Aconsia.
Evaluasi jawaban pasien berikut:

Pertanyaan: $question

Jawaban Pasien: $userAnswer

Poin Penting yang Harus Dipahami:
${keyPoints.map((p) => '- $p').join('\n')}

INSTRUKSI:
1. Berikan skor pemahaman 0-100 (HARUS NUMBER, bukan string)
2. Identifikasi poin yang dipahami dengan baik
3. Identifikasi poin yang masih kurang dipahami
4. Berikan feedback konstruktif dalam Bahasa Indonesia
5. Jika skor < 70, berikan penjelasan ulang yang lebih sederhana

Format response JSON (PENTING: score harus number, bukan string):
{
  "score": 85,
  "understood_points": ["Poin yang dipahami 1", "Poin yang dipahami 2"],
  "missed_points": ["Poin yang terlewat"],
  "feedback": "Feedback untuk pasien...",
  "clarification": "Penjelasan ulang jika perlu (null jika skor >= 70)"
}
''';

      final response = await _sendChatRequest(prompt);

      // Ensure score is a number
      if (response['score'] is String) {
        response['score'] = int.tryParse(response['score']) ?? 0;
      } else if (response['score'] is double) {
        if (response['score'].isInfinite || response['score'].isNaN) {
          response['score'] = 0;
        }
      }

      return response;
    } catch (e) {
      // If API error, return mock evaluation
      if (e.toString().contains('quota') || e.toString().contains('401')) {
        print('⚠️ OpenAI API quota exceeded, using mock evaluation');
        return _generateMockEvaluation(userAnswer);
      }
      throw Exception('Gagal evaluate answer: $e');
    }
  }

  /// Generate final learning summary after quiz completion
  /// Returns overall comprehension score and recommendations
  Future<Map<String, dynamic>> generateLearningSummary({
    required String kontenTitle,
    required List<Map<String, dynamic>> quizResults,
  }) async {
    // Mock mode for development
    if (_useMockMode) {
      return _generateMockSummary(kontenTitle, quizResults);
    }

    try {
      final totalScore = quizResults.fold<double>(
        0,
        (sum, result) {
          final score = result['score'];
          if (score is num) {
            final doubleScore = score.toDouble();
            if (!doubleScore.isInfinite && !doubleScore.isNaN) {
              return sum + doubleScore;
            }
          }
          return sum;
        },
      );
      final avgScore = quizResults.isNotEmpty
          ? (totalScore / quizResults.length).round()
          : 0;

      final prompt = '''
Kamu adalah asisten edukasi medis untuk aplikasi Aconsia.
Buatlah rangkuman pembelajaran untuk pasien:

Materi: $kontenTitle

Hasil Quiz:
${quizResults.map((r) => '''
Pertanyaan ${r['question_id']}: Skor ${r['score']}/100
Poin yang Dipahami: ${(r['understood_points'] as List).join(', ')}
Poin yang Terlewat: ${(r['missed_points'] as List).join(', ')}
''').join('\n')}

Skor Rata-rata: $avgScore/100

INSTRUKSI:
1. Buat rangkuman pemahaman secara keseluruhan
2. Highlight topik yang sudah dikuasai dengan baik
3. Identifikasi area yang perlu dipelajari lebih lanjut
4. Berikan rekomendasi konten terkait (opsional)
5. Motivasi pasien untuk terus belajar
6. Gunakan Bahasa Indonesia yang ramah dan supportif

Format response JSON:
{
  "overall_score": $avgScore,
  "status": "excellent|good|fair|needs_improvement",
  "strengths": ["Kekuatan 1", "Kekuatan 2"],
  "areas_to_improve": ["Area 1", "Area 2"],
  "summary": "Rangkuman lengkap pembelajaran...",
  "recommendations": ["Rekomendasi 1", "Rekomendasi 2"],
  "motivational_message": "Pesan motivasi untuk pasien..."
}
''';

      final response = await _sendChatRequest(prompt);
      return response;
    } catch (e) {
      throw Exception('Gagal generate summary: $e');
    }
  }

  /// FREE CHAT MODE: Send message with konten context
  /// AI can proactively ask questions based on content
  Future<String> sendFreeChatMessage({
    required String message,
    required String kontenTitle,
    required List<String> sectionContents,
    required List<String> sectionTitles,
    required List<Map<String, String>> conversationHistory,
  }) async {
    // Mock mode for development
    if (_useMockMode) {
      return _generateMockChatResponse(message, sectionTitles);
    }

    try {
      // Build content context
      String contentContext = '';
      for (int i = 0; i < sectionContents.length; i++) {
        final title =
            i < sectionTitles.length ? sectionTitles[i] : 'Bagian ${i + 1}';
        final content = sectionContents[i];
        contentContext += '\n\n=== $title ===\n$content';
      }

      final systemPrompt = '''
Kamu adalah asisten medis AI yang membantu pasien memahami anestesi melalui percakapan santai dan interaktif.

Konteks: Pasien sedang mempelajari "$kontenTitle"

Materi:$contentContext

ATURAN WAJIB - IKUTI PERSIS:

1. JAWABAN SINGKAT & PADAT
   • Maksimal 2-3 kalimat per respons
   • Langsung to the point, tidak bertele-tele
   • Seperti chat WA, bukan essay

2. FOKUS MENGETES PEMAHAMAN (SANGAT PENTING!)
   • Setiap respons HARUS bertanya untuk MENGETES pemahaman pasien
   • JANGAN hanya menawarkan "Ada yang ingin dipahami?" atau "Mau saya jelaskan?"
   • Aktif QUIZ pasien tentang apa yang mereka BACA di materi
   • Gali apakah pasien BENAR-BENAR PAHAM konten yang sudah dibaca

3. STYLE PERCAKAPAN:
   • Gunakan bahasa casual tapi sopan
   • Seperti teman yang ingin TAHU seberapa paham pasien
   • Boleh pakai emoji sesekali untuk friendly vibes

CARA MERESPONS & MENGETES:

Jika pasien jawab SINGKAT ("ok", "baik", "iya", dll):
→ Langsung TES pemahaman mereka tentang konten yang dibaca
Contoh:
- "Coba jelaskan dengan kata-kata sendiri, apa yang Anda pahami tentang [topik dari konten]?"
- "Di materi tadi disebutkan ada [X jenis/konsep]. Bisa sebutkan apa saja?"
- "Menurut Anda, kenapa [konsep dari konten] itu penting?"

Jika pasien tanya tentang ANESTESI:
→ Jawab 2-3 kalimat + TEST pemahaman mereka
Contoh:
User: "apa itu anestesi umum"
AI: "Anestesi umum adalah prosedur di mana pasien tidur total dan tidak sadarkan diri selama operasi. Dari materi yang Anda baca tadi, apa perbedaan anestesi umum dengan anestesi regional?"

Jika pasien jawab dengan DETAIL:
→ Validasi singkat + gali lebih dalam dengan TES
Contoh:
User: "anestesi umum buat pasien tidur total"
AI: "Betul! Nah, di materi tadi juga dijelaskan tentang persiapan sebelum anestesi umum. Kira-kira apa saja yang harus dilakukan pasien sebelumnya?"

Jika pasien tunjukkan KEKHAWATIRAN:
→ Tenangkan 1-2 kalimat + test pemahaman tentang cara mengatasi
Contoh:
User: "takut efek sampingnya"
AI: "Wajar kok khawatir. Tapi di materi tadi sudah dijelaskan cara tim medis monitor pasien. Menurut Anda, apa yang membuat anestesi tetap aman?"

VARIASI PERTANYAAN TES PEMAHAMAN (gunakan bergantian):
✓ "Coba jelaskan dengan kata-kata sendiri, apa itu [konsep dari konten]?"
✓ "Di materi tadi disebutkan [X hal]. Bisa sebutkan apa saja?"
✓ "Menurut Anda, kenapa [konsep] itu penting untuk dipahami?"
✓ "Apa perbedaan antara [A] dan [B] yang dijelaskan di materi?"
✓ "Kalau ditanya teman, gimana Anda jelasin tentang [topik dari konten]?"
✓ "Dari semua yang dijelaskan tadi, mana yang paling penting menurut Anda?"
✓ "Coba ceritakan, apa yang Anda ingat tentang [bagian konten]?"

CONTOH PERCAKAPAN IDEAL (TESTING MODE):
User: "ok"
AI: "Coba jelaskan dengan kata-kata sendiri, apa perbedaan antara anestesi umum, regional, dan lokal yang ada di materi tadi?"

User: "anestesi umum itu tidur total"
AI: "Betul! Nah kalau anestesi regional gimana? Di materi tadi juga dijelaskan kan?"

User: "regional cuma bagian tubuh tertentu yang dibius"
AI: "Mantap, Anda paham! Sekarang, di materi juga disebutkan persiapan penting sebelum anestesi. Kira-kira apa aja yang harus pasien lakukan?"

User: "puasa"
AI: "Iya betul, puasa salah satunya! Berapa lama puasa yang disarankan sebelum anestesi?"

LARANGAN KERAS:
❌ Jawaban lebih dari 3 kalimat
❌ Bertanya "Ada yang ingin dipahami lebih lanjut?" (terlalu pasif!)
❌ Bertanya "Mau saya jelaskan tentang X?" (jangan tawarkan, langsung TES!)
❌ Respons tanpa pertanyaan TES di akhir
❌ Bahasa terlalu formal/medis
❌ Mengulang pertanyaan yang sama

Ingat: Kamu GURU yang MENGETES, bukan asisten yang menunggu! Aktif quiz pasien tentang konten yang mereka baca! 📝✨
''';

      final messages = [
        {'role': 'system', 'content': systemPrompt},
        ...conversationHistory,
        {'role': 'user', 'content': message},
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o-mini',
          'messages': messages,
          'max_tokens': 200, // Reduced drastically to force short responses
          'temperature':
              0.9, // Higher for more natural, conversational responses
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else if (response.statusCode == 429) {
        // Rate limit hit - wait and retry once
        print('⚠️ Rate limit hit, waiting 3 seconds and retrying...');
        await Future.delayed(Duration(seconds: 3));

        // Retry once
        final retryResponse = await http.post(
          Uri.parse(_baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiKey',
          },
          body: json.encode({
            'model': 'gpt-3.5-turbo',
            'messages': messages,
            'max_tokens': 200,
            'temperature': 0.9,
          }),
        );

        if (retryResponse.statusCode == 200) {
          final data = json.decode(retryResponse.body);
          return data['choices'][0]['message']['content'];
        } else {
          throw Exception(
              'Rate limit masih aktif. Tunggu 1 menit lalu coba lagi.');
        }
      } else {
        throw Exception('OpenAI API error: ${response.statusCode}');
      }
    } catch (e) {
      // If API error, throw exception instead of returning mock
      print('❌ OpenAI API Error: $e');
      throw Exception(
          'Gagal menghubungi AI. Cek koneksi internet dan coba lagi.');
    }
  }

  /// Generate summary from free chat history
  /// Analyze entire conversation to assess comprehension
  Future<Map<String, dynamic>> generateChatSummary({
    required String kontenTitle,
    required List<Map<String, String>> conversationHistory,
  }) async {
    // Mock mode for development
    if (_useMockMode) {
      return _generateMockChatSummary(kontenTitle, conversationHistory);
    }

    try {
      // Build conversation context
      String chatContext = '';
      for (var msg in conversationHistory) {
        final role = msg['role'] == 'user' ? 'Pasien' : 'AI';
        chatContext += '\n$role: ${msg['content']}';
      }

      final prompt = '''
Kamu adalah evaluator medis untuk aplikasi Aconsia.
Analisis percakapan pembelajaran berikut dan buat rangkuman:

Materi: $kontenTitle

Percakapan:$chatContext

INSTRUKSI:
1. Analisis pemahaman pasien dari SELURUH percakapan
2. Berikan skor pemahaman 0-100 berdasarkan:
   - Kedalaman jawaban pasien
   - Kemampuan menjelaskan konsep
   - Responsif terhadap pertanyaan probing AI
   - Konsistensi pemahaman
3. Identifikasi topik yang sudah dikuasai dengan baik
4. Identifikasi area yang masih perlu dipelajari
5. Berikan feedback konstruktif
6. Motivasi pasien untuk terus belajar

Format response JSON:
{
  "overall_score": 85,
  "status": "excellent|good|fair|needs_improvement",
  "strengths": ["Kekuatan 1", "Kekuatan 2"],
  "areas_to_improve": ["Area 1", "Area 2"],
  "summary": "Rangkuman lengkap pembelajaran berdasarkan diskusi...",
  "recommendations": ["Rekomendasi 1", "Rekomendasi 2"],
  "motivational_message": "Pesan motivasi untuk pasien..."
}
''';

      final response = await _sendChatRequest(prompt);

      // Ensure score is a number
      if (response['overall_score'] is String) {
        response['overall_score'] =
            int.tryParse(response['overall_score']) ?? 0;
      }

      return response;
    } catch (e) {
      // Handle rate limit error specifically
      if (e.toString().contains('Rate limit') ||
          e.toString().contains('429') ||
          e.toString().contains('quota')) {
        print('⚠️ OpenAI API rate limit reached, generating local summary');
        // Return local summary based on conversation data
        return _generateMockChatSummary(kontenTitle, conversationHistory);
      }

      // For other errors, still try to generate local summary
      print('⚠️ OpenAI API error, using local summary: $e');
      return _generateMockChatSummary(kontenTitle, conversationHistory);
    }
  }

  /// General chat with AI assistant
  /// For mental health support, anesthesia questions, etc.
  Future<String> sendChatMessage({
    required String message,
    required List<Map<String, String>> conversationHistory,
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': '''
Kamu adalah asisten AI untuk aplikasi Aconsia (Anesthesia Consent).
Tugasmu adalah membantu pasien dengan:
1. Menjawab pertanyaan tentang anestesi dan prosedur medis
2. Memberikan dukungan mental dan mengurangi kecemasan pra-operasi
3. Menjelaskan konsep medis dengan bahasa yang mudah dipahami
4. Memberikan informasi umum kesehatan (BUKAN diagnosis medis)

PENTING:
- Gunakan Bahasa Indonesia yang ramah dan empatik
- Jika pertanyaan terlalu teknis/medis, sarankan untuk konsultasi langsung dengan dokter
- Jangan memberikan diagnosis atau saran pengobatan spesifik
- Fokus pada edukasi dan dukungan emosional
'''
        },
        ...conversationHistory,
        {'role': 'user', 'content': message},
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o-mini',
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('OpenAI API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal kirim chat message: $e');
    }
  }

  /// Private helper to send chat completion request
  Future<Map<String, dynamic>> _sendChatRequest(String prompt) async {
    if (_apiKey.isEmpty) {
      throw Exception('OpenAI API Key tidak ditemukan. Periksa file .env');
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: json.encode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 1000,
        'temperature': 0.3, // Lower temperature for more consistent responses
        'response_format': {'type': 'json_object'}, // Force JSON response
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final content = data['choices'][0]['message']['content'];
      return json.decode(content);
    } else {
      final error = json.decode(response.body);
      throw Exception('OpenAI API Error: ${error['error']['message']}');
    }
  }

  /// Mock data generators for development without OpenAI API
  Map<String, dynamic> _generateMockQuestions(
    String kontenTitle,
    int count,
    List<String> sectionTitles,
    List<String> sectionContents,
  ) {
    return {
      'questions': List.generate(count, (index) {
        final difficulties = ['easy', 'medium', 'hard'];

        // Use real section titles instead of generic "bagian 1, 2, 3"
        final sectionIndex = index % sectionTitles.length;
        final sectionTitle =
            sectionTitles.isNotEmpty ? sectionTitles[sectionIndex] : 'materi';

        // Create more contextual questions based on content
        final questions = [
          'Jelaskan pemahaman Anda tentang $sectionTitle yang telah Anda pelajari?',
          'Apa yang Anda pahami dari materi $sectionTitle dalam konten ini?',
          'Bagaimana Anda menjelaskan konsep $sectionTitle dengan kata-kata sendiri?',
          'Mengapa $sectionTitle penting untuk dipahami sebelum prosedur anestesi?',
          'Setelah membaca tentang $sectionTitle, apa yang paling Anda ingat?',
        ];

        return {
          'id': index + 1,
          'question': questions[index % questions.length],
          'key_points': [
            'Pemahaman konsep utama dari $sectionTitle',
            'Relevansi dengan prosedur anestesi',
            'Penjelasan dengan bahasa sendiri',
          ],
          'difficulty': difficulties[index % 3],
        };
      }),
    };
  }

  Map<String, dynamic> _generateMockEvaluation(String userAnswer) {
    // Simple scoring based on answer length
    final wordCount = userAnswer.split(' ').length;
    final score = (wordCount * 10).clamp(0, 100);

    return {
      'score': score,
      'understood_points': [
        'Anda menunjukkan pemahaman dasar',
        'Jawaban cukup detail',
      ],
      'missed_points': score < 70 ? ['Perlu penjelasan lebih detail'] : [],
      'feedback': score >= 70
          ? 'Bagus! Anda sudah memahami materi dengan baik.'
          : 'Coba jelaskan lebih detail lagi untuk meningkatkan pemahaman.',
      'clarification': score < 70
          ? 'Coba fokus pada poin-poin penting dan jelaskan dengan kata-kata sendiri.'
          : null,
    };
  }

  Map<String, dynamic> _generateMockSummary(
    String kontenTitle,
    List<Map<String, dynamic>> quizResults,
  ) {
    final totalScore = quizResults.fold<double>(
      0,
      (sum, result) {
        final score = result['score'];
        if (score is num) {
          final doubleScore = score.toDouble();
          if (!doubleScore.isInfinite && !doubleScore.isNaN) {
            return sum + doubleScore;
          }
        }
        return sum;
      },
    );
    final avgScore =
        quizResults.isNotEmpty ? (totalScore / quizResults.length).round() : 0;

    return {
      'overall_score': avgScore,
      'status': avgScore >= 85
          ? 'excellent'
          : avgScore >= 70
              ? 'good'
              : avgScore >= 50
                  ? 'fair'
                  : 'needs_improvement',
      'strengths': [
        'Pemahaman dasar materi $kontenTitle',
        'Kemampuan menjelaskan konsep dengan kata sendiri',
      ],
      'areas_to_improve': avgScore < 70
          ? [
              'Pemahaman detail materi perlu ditingkatkan',
              'Coba baca ulang bagian yang belum dipahami',
            ]
          : [],
      'summary':
          'Anda telah menyelesaikan quiz untuk materi $kontenTitle dengan skor rata-rata $avgScore/100. ${avgScore >= 70 ? "Pertahankan semangat belajar!" : "Terus belajar dan jangan menyerah!"}',
      'recommendations': [
        'Review kembali materi $kontenTitle',
        'Diskusikan dengan dokter jika ada yang belum dipahami',
      ],
      'motivational_message':
          'Setiap langkah belajar adalah kemajuan. Terus semangat! 💪',
    };
  }

  /// Mock chat response for free chat mode
  String _generateMockChatResponse(String message, List<String> sectionTitles) {
    // REMOVED: No more default/template responses
    // If this is called, it means API failed - throw error instead of returning template
    throw Exception(
        'OpenAI API tidak tersedia. Pastikan koneksi internet dan API key valid.');
  }

  /// Mock chat summary from conversation history
  Map<String, dynamic> _generateMockChatSummary(
    String kontenTitle,
    List<Map<String, String>> conversationHistory,
  ) {
    // Score based on conversation length and engagement
    final messageCount =
        conversationHistory.where((m) => m['role'] == 'user').length;
    final score = (messageCount * 15).clamp(50, 100);

    return {
      'overall_score': score,
      'status': score >= 85
          ? 'excellent'
          : score >= 70
              ? 'good'
              : score >= 50
                  ? 'fair'
                  : 'needs_improvement',
      'strengths': [
        'Aktif bertanya dan berdiskusi',
        'Menunjukkan ketertarikan pada materi $kontenTitle',
        'Responsif terhadap pertanyaan AI',
      ],
      'areas_to_improve': score < 70
          ? [
              'Coba pelajari materi lebih mendalam',
              'Berikan jawaban yang lebih detail',
            ]
          : [],
      'summary':
          'Anda telah menyelesaikan sesi pembelajaran interaktif tentang $kontenTitle dengan $messageCount pertanyaan/jawaban. Skor pemahaman Anda: $score/100. ${score >= 70 ? "Anda menunjukkan pemahaman yang baik!" : "Terus belajar, Anda pasti bisa!"}',
      'recommendations': [
        'Review kembali materi $kontenTitle',
        'Diskusikan lebih lanjut dengan dokter jika ada yang belum jelas',
        'Coba jelaskan materi ini ke orang lain untuk memperkuat pemahaman',
      ],
      'motivational_message':
          'Pembelajaran interaktif yang bagus! Terus kembangkan rasa ingin tahu Anda. 🌟',
    };
  }
}

/// Riverpod Provider
@riverpod
OpenAIService openAIService(OpenAIServiceRef ref) {
  return OpenAIService();
}
