import 'package:aconsia_app/presentation/pasien/konten/pages/chat_ai_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets(
    'chat page should show hybrid intro and quick reply options',
    (tester) async {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'true',
          'AI_PROVIDER': 'mock_local',
          'OPENAI_API_KEY': '',
        },
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChatAiPage(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(seconds: 2));

      expect(find.textContaining('AI Assistant'), findsWidgets);
      expect(
        find.textContaining('Mari kita mulai.'),
        findsWidgets,
      );
      expect(
        find.textContaining(
            '💬 Saya ingin menjelaskan dengan kata-kata sendiri'),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'chat page should start comprehension score from 0 percent',
    (tester) async {
      dotenv.testLoad(
        mergeWith: {
          'USE_MOCK_AI': 'true',
          'AI_PROVIDER': 'mock_local',
          'OPENAI_API_KEY': '',
        },
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChatAiPage(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('0%'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
    },
  );
}
