import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onosendai/core/images/shader_effects.dart';

final Map<String, Future<ui.FragmentProgram>> _programCache = {};

Future<ui.FragmentProgram> loadFragmentProgram(String assetPath) {
  return _programCache.putIfAbsent(
    assetPath,
    () => ui.FragmentProgram.fromAsset(assetPath),
  );
}

Future<ui.Image> loadNetworkImageAsUiImage(String url) async {
  return loadImageProviderAsUiImage(CachedNetworkImageProvider(url));
}

Future<ui.Image> loadImageProviderAsUiImage(ImageProvider imageProvider) async {
  final completer = Completer<ui.Image>();

  final stream = imageProvider.resolve(ImageConfiguration.empty);

  late ImageStreamListener listener;
  listener = ImageStreamListener(
    (ImageInfo info, bool _) {
      stream.removeListener(listener);
      completer.complete(info.image);
    },
    onError: (exception, stackTrace) {
      stream.removeListener(listener);
      completer.completeError(exception, stackTrace);
    },
  );

  stream.addListener(listener);
  return completer.future;
}

class ShadedNetworkImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final WidgetBuilder placeholderBuilder;
  final WidgetBuilder errorBuilder;
  final ImageShaderEffect effect;

  const ShadedNetworkImage({
    super.key,
    required this.url,
    required this.placeholderBuilder,
    required this.errorBuilder,
    required this.effect,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  State<ShadedNetworkImage> createState() => _ShadedNetworkImageState();
}

class _ShadedNetworkImageState extends State<ShadedNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return ShadedImage(
      imageProvider: CachedNetworkImageProvider(widget.url),
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      placeholderBuilder: widget.placeholderBuilder,
      errorBuilder: widget.errorBuilder,
      effect: widget.effect,
    );
  }
}

class ShadedImage extends StatefulWidget {
  final ImageProvider imageProvider;
  final BoxFit fit;
  final double? width;
  final double? height;
  final WidgetBuilder placeholderBuilder;
  final WidgetBuilder errorBuilder;
  final ImageShaderEffect effect;

  const ShadedImage({
    super.key,
    required this.imageProvider,
    required this.placeholderBuilder,
    required this.errorBuilder,
    required this.effect,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  State<ShadedImage> createState() => _ShadedImageState();
}

class _ShadedImageState extends State<ShadedImage> {
  static const _animationFrameInterval = Duration(milliseconds: 1000 ~/ 24);

  late Future<(ui.FragmentProgram, ui.Image)> _imageFuture;
  ValueNotifier<double>? _timeNotifier;
  Timer? _animationTimer;
  Stopwatch? _animationClock;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadShaderImage(
      widget.imageProvider,
      widget.effect.assetPath,
    );
    if (widget.effect.isAnimated) _startAnimation();
  }

  @override
  void didUpdateWidget(ShadedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != oldWidget.imageProvider ||
        widget.effect.assetPath != oldWidget.effect.assetPath) {
      _imageFuture = _loadShaderImage(
        widget.imageProvider,
        widget.effect.assetPath,
      );
    }
    if (widget.effect.isAnimated != oldWidget.effect.isAnimated) {
      if (widget.effect.isAnimated) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  void dispose() {
    _stopAnimation();
    super.dispose();
  }

  void _startAnimation() {
    _timeNotifier = ValueNotifier(0);
    _animationClock = Stopwatch()..start();
    _animationTimer = Timer.periodic(_animationFrameInterval, (_) {
      _timeNotifier!.value = _animationClock!.elapsedMilliseconds / 1000.0;
    });
  }

  void _stopAnimation() {
    _animationTimer?.cancel();
    _animationTimer = null;
    _animationClock?.stop();
    _animationClock = null;
    _timeNotifier?.dispose();
    _timeNotifier = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder<(ui.FragmentProgram, ui.Image)>(
          future: _imageFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) return widget.errorBuilder(context);
            if (!snapshot.hasData) return widget.placeholderBuilder(context);

            final (program, image) = snapshot.requireData;
            final paintSize = _imagePaintSize(
              image: image,
              constraints: constraints,
              width: widget.width,
              height: widget.height,
            );

            return SizedBox.fromSize(
              size: paintSize,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: ShadedImagePainter(
                    image: image,
                    program: program,
                    fit: widget.fit,
                    effect: widget.effect,
                    timeListenable: _timeNotifier,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Size _imagePaintSize({
  required ui.Image image,
  required BoxConstraints constraints,
  required double? width,
  required double? height,
}) {
  final imageWidth = image.width.toDouble();
  final imageHeight = image.height.toDouble();
  final aspectRatio = imageWidth / imageHeight;

  var paintWidth =
      width ??
      (constraints.hasBoundedWidth ? constraints.maxWidth : imageWidth);
  var paintHeight = height ?? paintWidth / aspectRatio;

  if (height == null && constraints.hasBoundedHeight) {
    paintHeight = paintHeight.clamp(0, constraints.maxHeight).toDouble();
    if (width == null) paintWidth = paintHeight * aspectRatio;
  }

  if (constraints.hasBoundedWidth) {
    paintWidth = paintWidth.clamp(0, constraints.maxWidth).toDouble();
  }
  if (constraints.hasBoundedHeight) {
    paintHeight = paintHeight.clamp(0, constraints.maxHeight).toDouble();
  }

  return Size(paintWidth, paintHeight);
}

Future<(ui.FragmentProgram, ui.Image)> _loadShaderImage(
  ImageProvider imageProvider,
  String shaderAssetPath,
) async {
  final results = await Future.wait<Object>([
    loadFragmentProgram(shaderAssetPath),
    loadImageProviderAsUiImage(imageProvider),
  ]);

  return (results[0] as ui.FragmentProgram, results[1] as ui.Image);
}

class ShadedImagePainter extends CustomPainter {
  final ui.Image image;
  final ui.FragmentProgram program;
  final BoxFit fit;
  final ImageShaderEffect effect;
  final ValueListenable<double>? timeListenable;

  ShadedImagePainter({
    required this.image,
    required this.program,
    required this.effect,
    this.timeListenable,
    this.fit = BoxFit.contain,
  }) : super(repaint: timeListenable);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final sourceSize = Size(image.width.toDouble(), image.height.toDouble());
    final fitted = applyBoxFit(fit, sourceSize, size);
    final destination = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & size,
    );
    final shader = program.fragmentShader();
    effect.applyUniforms(
      shader,
      image,
      destination.size,
      timeListenable?.value ?? 0,
    );

    canvas
      ..save()
      ..clipRect(destination)
      ..translate(destination.left, destination.top)
      ..drawRect(Offset.zero & destination.size, Paint()..shader = shader)
      ..restore();
  }

  @override
  bool shouldRepaint(ShadedImagePainter oldDelegate) {
    return image != oldDelegate.image ||
        program != oldDelegate.program ||
        fit != oldDelegate.fit ||
        effect != oldDelegate.effect ||
        timeListenable != oldDelegate.timeListenable;
  }
}
