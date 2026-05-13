import 'package:flutter/material.dart' hide RichText;
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/widgets/rich_text.dart' as app;

void main() {
  test('decodeContent allows up to two line breaks', () {
    expect(
      app.RichText.decodeContent('first\n\nsecond\n\nthird'),
      'first\n\nsecond\n\nthird',
    );
  });

  test('normalizeLineBreaks trims repeated line breaks to two', () {
    expect(
      app.RichText.normalizeLineBreaks('first\n\n\n\nsecond'),
      'first\n\nsecond',
    );
  });

  test('normalizeLineBreaks trims repeated CRLF line breaks to two', () {
    expect(
      app.RichText.normalizeLineBreaks('first\r\n\r\n\r\n\r\nsecond'),
      'first\n\nsecond',
    );
  });

  testWidgets('tapping a rich text image opens the fullscreen viewer', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: app.RichText(
            content: '![Signal](https://example.com/image.png)',
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Signal').first);
    await tester.pump(const Duration(milliseconds: 140));

    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byIcon(LucideIcons.rotateCcw), findsOneWidget);
    expect(find.byIcon(LucideIcons.rotateCw), findsOneWidget);
    expect(find.byIcon(LucideIcons.refreshCcw), findsOneWidget);
    expect(find.byIcon(LucideIcons.x), findsOneWidget);
  });

  testWidgets('fullscreen image can be closed', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: app.RichText(
            content: '![Signal](https://example.com/image.png)',
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Signal').first);
    await tester.pump(const Duration(milliseconds: 140));

    await tester.tap(find.byTooltip('Close image viewer'));
    await tester.pump(const Duration(milliseconds: 140));

    expect(find.byType(InteractiveViewer), findsNothing);
  });

  testWidgets('fullscreen image rotates left and right', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: app.RichText(
            content: '![Signal](https://example.com/image.png)',
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Signal').first);
    await tester.pump(const Duration(milliseconds: 140));

    expect(_fullscreenImage(tester).quarterTurns, 0);

    await tester.tap(find.byTooltip('Rotate right'));
    await tester.pump();
    expect(_fullscreenImage(tester).quarterTurns, 1);

    await tester.tap(find.byTooltip('Rotate left'));
    await tester.pump();
    expect(_fullscreenImage(tester).quarterTurns, 0);

    await tester.tap(find.byTooltip('Rotate left'));
    await tester.pump();
    expect(_fullscreenImage(tester).quarterTurns, 3);
  });

  testWidgets('fullscreen image reset restores default rotation', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: app.RichText(
            content: '![Signal](https://example.com/image.png)',
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Signal').first);
    await tester.pump(const Duration(milliseconds: 140));

    await tester.tap(find.byTooltip('Rotate right'));
    await tester.pump();
    expect(_fullscreenImage(tester).quarterTurns, 1);

    await tester.tap(find.byTooltip('Reset image'));
    await tester.pump();

    expect(_fullscreenImage(tester).quarterTurns, 0);
  });
}

RotatedBox _fullscreenImage(WidgetTester tester) {
  return tester.widget<RotatedBox>(find.byType(RotatedBox));
}
