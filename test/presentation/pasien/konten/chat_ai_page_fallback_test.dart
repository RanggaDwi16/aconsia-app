import 'package:aconsia_app/presentation/pasien/konten/pages/chat_ai_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'chat page should show hybrid intro and quick reply options',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatAiPage(),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

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
}
