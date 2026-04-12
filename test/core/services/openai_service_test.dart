import 'package:aconsia_app/core/services/openai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OpenAIService', () {
    test('mock mode true should return usable free chat response', () async {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'true',
          'AI_PROVIDER': 'mock_local',
        },
      );

      final service = OpenAIService();
      final response = await service.sendFreeChatMessage(
        message: 'apa itu anestesi?',
        kontenTitle: 'Materi A',
        sectionContents: const ['Materi anestesi dasar'],
        sectionTitles: const ['Dasar Anestesi'],
        conversationHistory: const [
          {'role': 'assistant', 'content': 'Halo'}
        ],
      );

      expect(response.trim(), isNotEmpty);
    });

    test('mock mode true should return usable general chat response', () async {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'true',
          'AI_PROVIDER': 'mock_local',
        },
      );

      final service = OpenAIService();
      final response = await service.sendChatMessage(
        message: 'saya cemas sebelum operasi',
        conversationHistory: const [],
      );

      expect(response.trim(), isNotEmpty);
    });

    test(
        'mock mode false + direct provider tanpa API key harus gagal dengan missing_config',
        () async {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'false',
          'AI_PROVIDER': 'openai_direct',
          'OPENAI_API_KEY': '',
        },
      );

      final service = OpenAIService();
      await expectLater(
        () => service.sendFreeChatMessage(
          message: 'tes',
          kontenTitle: 'Materi A',
          sectionContents: const ['Materi anestesi dasar'],
          sectionTitles: const ['Dasar Anestesi'],
          conversationHistory: const [],
        ),
        throwsA(
          isA<AiUnavailableError>().having(
            (e) => e.reason,
            'reason',
            'ai_not_ready_missing_key',
          ),
        ),
      );
    });

    test('diagnostics should reflect direct mode with missing config', () {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'false',
          'AI_PROVIDER': 'openai_direct',
          'OPENAI_API_KEY': '',
        },
      );

      final service = OpenAIService();
      final d = service.diagnostics();

      expect(d['mockModeActive'], isFalse);
      expect(d['source'], 'openai_direct');
      expect(d['openAiReady'], isFalse);
      expect(d['apiKeyPresent'], isFalse);
    });
  });
}
