import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/theme/theme.dart' as app_theme;

class GlitchBootAnimation extends ConsumerStatefulWidget {
  final Widget child;
  final Duration duration;

  const GlitchBootAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  ConsumerState<GlitchBootAnimation> createState() =>
      _GlitchBootAnimationState();
}

class _GlitchBootAnimationState extends ConsumerState<GlitchBootAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _done = true);
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return widget.child;
    final theme = ref.watch(app_theme.appThemeProvider).theme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return _GlitchSplash(progress: _controller.value, theme: theme);
      },
    );
  }
}

class _GlitchSplash extends StatelessWidget {
  final double progress; // 0.0 → 1.0
  final app_theme.Theme theme;

  const _GlitchSplash({required this.progress, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.background,
        body: CustomPaint(
          painter: _GlitchPainter(progress: progress, theme: theme),
          child: Center(
            child: _GlitchText(progress: progress, theme: theme),
          ),
        ),
      ),
    );
  }
}

// ── Glitch Text ──────────────────────────────────────────────────────────────

class _GlitchText extends StatelessWidget {
  final double progress;
  final app_theme.Theme theme;

  const _GlitchText({required this.progress, required this.theme});

  @override
  Widget build(BuildContext context) {
    // Phase 1 (0.0–0.6): heavy RGB split + random offsets
    // Phase 2 (0.6–0.85): converging
    // Phase 3 (0.85–1.0): clean, fade in subtitle
    final rng = Random(42);

    double splitAmount;
    double noise;

    if (progress < 0.6) {
      final t = progress / 0.6;
      // Oscillating glitch intensity
      splitAmount = 14.0 * sin(t * pi * 6).abs() * (1 - t * 0.3);
      noise = (rng.nextDouble() - 0.5) * 8 * (1 - t * 0.2);
    } else if (progress < 0.85) {
      final t = (progress - 0.6) / 0.25;
      splitAmount = 14.0 * (1 - t);
      noise = (rng.nextDouble() - 0.5) * 4 * (1 - t);
    } else {
      splitAmount = 0;
      noise = 0;
    }

    final cleanProgress = progress < 0.85
        ? 0.0
        : (progress - 0.85) / 0.15; // 0→1 in final phase

    return Stack(
      alignment: Alignment.center,
      children: [
        // Red channel — shifted left+up
        if (splitAmount > 0)
          Transform.translate(
            offset: Offset(-splitAmount + noise, -splitAmount * 0.5),
            child: _logoText(const Color(0xFFFF003C), opacity: 0.75),
          ),
        // Blue channel — shifted right+down
        if (splitAmount > 0)
          Transform.translate(
            offset: Offset(splitAmount * 0.8 + noise, splitAmount * 0.4),
            child: _logoText(const Color(0xFF00FFFF), opacity: 0.75),
          ),
        // Main white/clean layer
        _logoText(
          splitAmount > 0
              ? theme.foreground.withValues(alpha: 0.9)
              : theme.foreground,
        ),
        // Subtitle fades in during clean phase
        if (cleanProgress > 0)
          Positioned(
            top:
                MediaQueryData.fromView(
                      WidgetsBinding.instance.platformDispatcher.views.first,
                    ).size.height /
                    2 +
                36,
            child: Opacity(
              opacity: cleanProgress,
              child: Text(
                'CYBERSPACE CLIENT v0.1',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  letterSpacing: 4,
                  color: theme.dimmed,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _logoText(Color color, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Image(
        image: const AssetImage('assets/images/onosendai_icon.png'),
        color: color,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}

// ── Scanline / noise painter ─────────────────────────────────────────────────

class _GlitchPainter extends CustomPainter {
  final double progress;
  final app_theme.Theme theme;

  _GlitchPainter({required this.progress, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    _drawScanlines(canvas, size);
    if (progress < 0.85) {
      _drawHorizontalGlitchBars(canvas, size);
    }
  }

  void _drawScanlines(Canvas canvas, Size size) {
    final opacity = progress < 0.85 ? 0.15 : 0.06;
    final paint = Paint()
      ..color = theme.foreground.withValues(alpha: opacity)
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawHorizontalGlitchBars(Canvas canvas, Size size) {
    final intensity = progress < 0.6
        ? sin(progress / 0.6 * pi * 5).abs()
        : 1 - (progress - 0.6) / 0.25;

    final barCount = (intensity * 6).round();
    final rng = Random(DateTime.now().millisecondsSinceEpoch ~/ 80);

    for (int i = 0; i < barCount; i++) {
      final y = rng.nextDouble() * size.height;
      final h = rng.nextDouble() * 6 + 1;
      final w = rng.nextDouble() * size.width * 0.6 + size.width * 0.1;
      final x = rng.nextDouble() * (size.width - w);

      final paint = Paint()
        ..color = [
          const Color(0x33FF003C),
          const Color(0x2200FFFF),
          theme.dimmed.withValues(alpha: 0.14),
        ][i % 3];

      canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);
    }
  }

  @override
  bool shouldRepaint(_GlitchPainter old) {
    return old.progress != progress ||
        old.theme.runtimeType != theme.runtimeType;
  }
}
