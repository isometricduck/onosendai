import 'package:flutter_test/flutter_test.dart';
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
}
