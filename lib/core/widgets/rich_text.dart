import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/images.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class RichText extends StatefulWidget {
  final String content;
  final TextStyle? style;
  final bool selectable;
  final Iterable<Object?> attachments;
  final bool decodeHtml;

  const RichText({
    super.key,
    required this.content,
    this.style,
    this.selectable = true,
    this.attachments = const [],
    this.decodeHtml = true,
  });

  static String decodeContent(String content) {
    return normalizeLineBreaks(
      content
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&nbsp;', ''),
    );
  }

  static String normalizeLineBreaks(String content) {
    return content.replaceAll(RegExp(r'(\r?\n){3,}'), '\n\n');
  }

  @override
  State<RichText> createState() => _RichTextState();
}

class _RichTextState extends State<RichText> {
  late List<_ContentSegment> _contentSegments;
  final _linkRecognizers = <_InlineLink, TapGestureRecognizer>{};

  @override
  void initState() {
    super.initState();
    _syncSegments();
  }

  @override
  void didUpdateWidget(covariant RichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != oldWidget.content ||
        widget.decodeHtml != oldWidget.decodeHtml) {
      _syncSegments();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textStyle = widget.style ?? theme.mainFont;
    final audioAttachment = _AudioAttachment.fromAttachments(
      widget.attachments,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, segment) in _contentSegments.indexed) ...[
          if (index > 0) const SizedBox(height: 8),
          switch (segment) {
            _TextSegment(:final text) => _InlineRichText(
              text: text,
              style: textStyle,
              selectable: widget.selectable,
              linkRecognizers: _linkRecognizers,
            ),
            _ImageSegment(:final altText, :final url) => _ContentImage(
              altText: altText,
              url: url,
            ),
            _DividerSegment() => const _ContentDivider(),
          },
        ],
        if (audioAttachment != null) ...[
          if (_contentSegments.isNotEmpty) const SizedBox(height: 10),
          _AudioAttachmentBox(attachment: audioAttachment),
        ],
      ],
    );
  }

  void _syncSegments() {
    _disposeRecognizers();
    final decodedContent = widget.decodeHtml
        ? RichText.decodeContent(widget.content)
        : widget.content;
    final content = RichText.normalizeLineBreaks(decodedContent);
    _contentSegments = _ContentSegment.parse(content);

    for (final segment in _contentSegments) {
      if (segment is! _TextSegment) continue;
      for (final inlineSegment in _InlineTextSegment.parse(segment.text)) {
        final link = inlineSegment.link;
        if (link == null) continue;
        _linkRecognizers.putIfAbsent(
          link,
          () => TapGestureRecognizer()..onTap = () => launchUrl(link.uri),
        );
      }
    }
  }

  void _disposeRecognizers() {
    for (final recognizer in _linkRecognizers.values) {
      recognizer.dispose();
    }
    _linkRecognizers.clear();
  }
}

sealed class _ContentSegment {
  const _ContentSegment();

  // ignore: deprecated_member_use
  static final _blockPattern = RegExp(
    r'((?:^|\r?\n)[ \t]*---[ \t]*(?:\r?\n|$))|!\[([^\]]*)\]\((https?:\/\/[^)\s]+)\)',
  );

  static List<_ContentSegment> parse(String content) {
    final segments = <_ContentSegment>[];
    var cursor = 0;

    for (final match in _blockPattern.allMatches(content)) {
      if (match.start > cursor) {
        final text = content.substring(cursor, match.start);
        if (text.isNotEmpty) segments.add(_TextSegment(text));
      }

      if (match.group(1) != null) {
        segments.add(const _DividerSegment());
      } else {
        segments.add(_ImageSegment(match.group(2) ?? '', match.group(3)!));
      }

      cursor = match.end;
    }

    if (cursor < content.length) {
      final text = content.substring(cursor);
      if (text.isNotEmpty) segments.add(_TextSegment(text));
    }

    return segments;
  }
}

class _TextSegment extends _ContentSegment {
  final String text;

  const _TextSegment(this.text);
}

class _ImageSegment extends _ContentSegment {
  final String altText;
  final String url;

  const _ImageSegment(this.altText, this.url);
}

class _DividerSegment extends _ContentSegment {
  const _DividerSegment();
}

class _InlineRichText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool selectable;
  final Map<_InlineLink, TapGestureRecognizer> linkRecognizers;

  const _InlineRichText({
    required this.text,
    required this.style,
    required this.selectable,
    required this.linkRecognizers,
  });

  @override
  State<_InlineRichText> createState() => _InlineRichTextState();
}

class _InlineRichTextState extends State<_InlineRichText> {
  late List<_InlineTextSegment> _segments;

  @override
  void initState() {
    super.initState();
    _segments = _InlineTextSegment.parse(widget.text);
  }

  @override
  void didUpdateWidget(covariant _InlineRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _segments = _InlineTextSegment.parse(widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final linkStyle = widget.style.copyWith(
      color: theme.headingText,
      decoration: TextDecoration.underline,
      decorationColor: theme.headingText,
    );

    final spans = [
      for (final segment in _segments)
        TextSpan(
          text: segment.text,
          style: segment.markup.textStyle(widget.style, linkStyle),
          recognizer: segment.link == null
              ? null
              : widget.linkRecognizers[segment.link],
        ),
    ];

    final textSpan = TextSpan(style: widget.style, children: spans);
    if (widget.selectable) return SelectableText.rich(textSpan);
    return Text.rich(textSpan);
  }
}

class _InlineLink {
  final String text;
  final Uri uri;

  const _InlineLink({required this.text, required this.uri});

  @override
  bool operator ==(Object other) {
    return other is _InlineLink && other.text == text && other.uri == uri;
  }

  @override
  int get hashCode => Object.hash(text, uri);
}

class _InlineTextSegment {
  final String text;
  final _InlineMarkup markup;

  static final _linkPattern = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');

  const _InlineTextSegment(this.text, this.markup);

  _InlineLink? get link => markup.link;

  static List<_InlineTextSegment> parse(String text) {
    return _parseRange(text, const _InlineMarkup());
  }

  static List<_InlineTextSegment> _parseRange(
    String text,
    _InlineMarkup markup,
  ) {
    final segments = <_InlineTextSegment>[];
    var cursor = 0;

    void addPlain(String value, _InlineMarkup markup) {
      if (value.isEmpty) return;
      final last = segments.isEmpty ? null : segments.last;
      if (last != null && last.markup == markup) {
        segments[segments.length - 1] = _InlineTextSegment(
          '${last.text}$value',
          markup,
        );
      } else {
        segments.add(_InlineTextSegment(value, markup));
      }
    }

    while (cursor < text.length) {
      final linkMatch = _linkPattern.matchAsPrefix(text, cursor);
      if (linkMatch != null) {
        final linkedText = linkMatch.group(1)?.trim() ?? '';
        final uri = _parseLinkUri(linkMatch.group(2));
        if (linkedText.isEmpty || uri == null) {
          addPlain(linkMatch.group(0) ?? '', markup);
        } else {
          segments.addAll(
            _parseRange(
              linkedText,
              markup.copyWith(
                link: _InlineLink(text: linkedText, uri: uri),
              ),
            ),
          );
        }
        cursor = linkMatch.end;
        continue;
      }

      final marker = _Marker.matchAt(text, cursor);
      if (marker != null) {
        final end = text.indexOf(marker.token, cursor + marker.token.length);
        if (end == -1) {
          addPlain(marker.token, markup);
          cursor += marker.token.length;
          continue;
        }

        segments.addAll(
          _parseRange(
            text.substring(cursor + marker.token.length, end),
            marker.apply(markup),
          ),
        );
        cursor = end + marker.token.length;
        continue;
      }

      addPlain(text[cursor], markup);
      cursor++;
    }

    return segments;
  }

  static Uri? _parseLinkUri(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);
    if (uri == null) return null;
    if (uri.hasScheme) return uri;

    return Uri.tryParse('https://$text');
  }
}

class _Marker {
  final String token;
  final _InlineMarkup Function(_InlineMarkup markup) apply;

  const _Marker(this.token, this.apply);

  static const _markers = [
    _Marker('**', _applyBold),
    _Marker('++', _applyUnderline),
    _Marker('~~', _applyStrikethrough),
    _Marker('*', _applyItalic),
  ];

  static _Marker? matchAt(String text, int index) {
    for (final marker in _markers) {
      if (text.startsWith(marker.token, index)) return marker;
    }

    return null;
  }

  static _InlineMarkup _applyBold(_InlineMarkup markup) {
    return markup.copyWith(bold: true);
  }

  static _InlineMarkup _applyItalic(_InlineMarkup markup) {
    return markup.copyWith(italic: true);
  }

  static _InlineMarkup _applyUnderline(_InlineMarkup markup) {
    return markup.copyWith(underline: true);
  }

  static _InlineMarkup _applyStrikethrough(_InlineMarkup markup) {
    return markup.copyWith(strikethrough: true);
  }
}

class _InlineMarkup {
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strikethrough;
  final _InlineLink? link;

  const _InlineMarkup({
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strikethrough = false,
    this.link,
  });

  TextStyle? textStyle(TextStyle baseStyle, TextStyle linkStyle) {
    final decorations = <TextDecoration>[
      if (underline || link != null) TextDecoration.underline,
      if (strikethrough) TextDecoration.lineThrough,
    ];

    final effectiveStyle = link == null ? baseStyle : linkStyle;
    return effectiveStyle.copyWith(
      fontWeight: bold ? FontWeight.w700 : effectiveStyle.fontWeight,
      fontStyle: italic ? FontStyle.italic : effectiveStyle.fontStyle,
      decoration: decorations.isEmpty
          ? effectiveStyle.decoration
          : TextDecoration.combine(decorations),
      decorationColor: link == null
          ? effectiveStyle.decorationColor
          : linkStyle.decorationColor,
    );
  }

  _InlineMarkup copyWith({
    bool? bold,
    bool? italic,
    bool? underline,
    bool? strikethrough,
    _InlineLink? link,
  }) {
    return _InlineMarkup(
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      underline: underline ?? this.underline,
      strikethrough: strikethrough ?? this.strikethrough,
      link: link ?? this.link,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _InlineMarkup &&
        other.bold == bold &&
        other.italic == italic &&
        other.underline == underline &&
        other.strikethrough == strikethrough &&
        other.link == link;
  }

  @override
  int get hashCode => Object.hash(bold, italic, underline, strikethrough, link);
}

class _AudioAttachment {
  final String title;
  final String artist;
  final Uri src;

  const _AudioAttachment({
    required this.title,
    required this.artist,
    required this.src,
  });

  static _AudioAttachment? fromAttachments(Iterable<Object?> attachments) {
    for (final attachment in attachments) {
      if (attachment is! Map) continue;
      if (attachment['type'] != 'audio') continue;

      final src = Uri.tryParse('${attachment['src'] ?? ''}');
      if (src == null || !src.hasScheme) continue;

      return _AudioAttachment(
        title: _stringValue(attachment['title'], fallback: '[untitled audio]'),
        artist: _stringValue(
          attachment['artist'],
          fallback: '[unknown artist]',
        ),
        src: src,
      );
    }

    return null;
  }

  static String _stringValue(Object? value, {required String fallback}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }
}

class _AudioAttachmentBox extends StatelessWidget {
  final _AudioAttachment attachment;

  const _AudioAttachmentBox({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Semantics(
      button: true,
      label: 'Open audio ${attachment.title} by ${attachment.artist}',
      child: InkWell(
        onTap: () => launchUrl(attachment.src),
        hoverColor: theme.headingText.withValues(alpha: 0.08),
        focusColor: theme.headingText.withValues(alpha: 0.08),
        splashColor: theme.headingText.withValues(alpha: 0.12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.cardBorder, width: 1),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(LucideIcons.music, size: 18, color: theme.headingText),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.title,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: theme.headingText,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      attachment.artist,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: theme.metaText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(LucideIcons.externalLink, size: 16, color: theme.actionIcon),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentImage extends StatelessWidget {
  final String altText;
  final String url;

  const _ContentImage({required this.altText, required this.url});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Semantics(
      label: altText.isEmpty ? 'Post image' : altText,
      image: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 420),
        child: ClipRect(
          child: ShadedNetworkImage(
            url: url,
            fit: BoxFit.contain,
            effect: theme.imageShaderEffect,
            fallbackColor: theme.headingText,
            placeholderBuilder: (_) => const _ContentImagePlaceholder(),
            errorBuilder: (_) => const _ContentImageError(),
          ),
        ),
      ),
    );
  }
}

class _ContentDivider extends StatelessWidget {
  const _ContentDivider();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SizedBox(
      width: double.infinity,
      height: 1,
      child: DecoratedBox(decoration: BoxDecoration(color: theme.divider)),
    );
  }
}

class _ContentImagePlaceholder extends StatelessWidget {
  const _ContentImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SizedBox(
      height: 180,
      child: Center(
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: theme.actionIcon,
          ),
        ),
      ),
    );
  }
}

class _ContentImageError extends StatelessWidget {
  const _ContentImageError();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SizedBox(
      height: 120,
      child: Center(
        child: Text(
          '[image failed to load]',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: theme.hintText,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
