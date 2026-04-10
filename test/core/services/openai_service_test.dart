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

    test('mock mode false tetap fallback ke mock lokal (locked mode)',
        () async {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'false',
          'AI_PROVIDER': 'mock_local',
        },
      );

      final service = OpenAIService();
      final response = await service.sendFreeChatMessage(
        message: 'tes',
        kontenTitle: 'Materi A',
        sectionContents: const ['Materi anestesi dasar'],
        sectionTitles: const ['Dasar Anestesi'],
        conversationHistory: const [],
      );

      expect(response.trim(), isNotEmpty);
    });

    test(
        'general chat dengan USE_MOCK_AI=false tetap menggunakan mock lokal',
        () async {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'false',
          'AI_PROVIDER': 'mock_local',
        },
      );

      final service = OpenAIService();
      final response = await service.sendChatMessage(
        message: 'tes',
        conversationHistory: const [],
      );

      expect(response.trim(), isNotEmpty);
    });

    test('diagnostics should reflect mock-only contract', () {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'false',
          'AI_PROVIDER': 'mock_local',
        },
      );

      final service = OpenAIService();
      final d = service.diagnostics();

      expect(d['mockModeActive'], isTrue);
      expect(d['source'], 'mock_local');
      expect(d['openAiReady'], isFalse);
    });
  });
}
