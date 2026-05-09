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
  final Color fallbackColor;

  const ShadedNetworkImage({
    super.key,
    required this.url,
    required this.placeholderBuilder,
    required this.errorBuilder,
    required this.effect,
    required this.fallbackColor,
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
      fallbackColor: widget.fallbackColor,
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
  final Color fallbackColor;

  const ShadedImage({
    super.key,
    required this.imageProvider,
    required this.placeholderBuilder,
    required this.errorBuilder,
    required this.effect,
    required this.fallbackColor,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  State<ShadedImage> createState() => _ShadedImageState();
}

class _ShadedImageState extends State<ShadedImage> {
  static const _animationFrameInterval = Duration(milliseconds: 1000 ~/ 24);

  late Future<_ShadedImageData> _imageFuture;
  ValueNotifier<double>? _timeNotifier;
  Timer? _animationTimer;
  Stopwatch? _animationClock;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadShaderImage(
      widget.imageProvider,
      widget.effect.assetPath,
      widget.fallbackColor,
    );
    if (widget.effect.isAnimated) _startAnimation();
  }

  @override
  void didUpdateWidget(ShadedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != oldWidget.imageProvider ||
        widget.effect.assetPath != oldWidget.effect.assetPath ||
        widget.fallbackColor != oldWidget.fallbackColor) {
      _imageFuture = _loadShaderImage(
        widget.imageProvider,
        widget.effect.assetPath,
        widget.fallbackColor,
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
        return FutureBuilder<_ShadedImageData>(
          future: _imageFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(
                '[ShadedImage] Failed to load shader/image: ${snapshot.error}\n${snapshot.stackTrace}',
              );
              return widget.errorBuilder(context);
            }
            if (!snapshot.hasData) return widget.placeholderBuilder(context);

            final data = snapshot.requireData;
            final paintSize = _imagePaintSize(
              image: data.image,
              constraints: constraints,
              width: widget.width,
              height: widget.height,
            );

            return SizedBox.fromSize(
              size: paintSize,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: ShadedImagePainter(
                    image: data.image,
                    program: data.program,
                    fallbackImage: data.fallbackImage,
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

Future<_ShadedImageData> _loadShaderImage(
  ImageProvider imageProvider,
  String shaderAssetPath,
  Color fallbackColor,
) async {
  final image = await loadImageProviderAsUiImage(imageProvider);
  final results = await Future.wait<Object?>([
    loadFragmentProgram(shaderAssetPath).then<Object?>(
      (program) => program,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[ShadedImage] Failed to load shader: $error\n$stackTrace');
        return null;
      },
    ),
    _loadMonochromeImage(image, fallbackColor).then<Object?>(
      (fallbackImage) => fallbackImage,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint(
          '[ShadedImage] Failed to build monochrome fallback: $error\n$stackTrace',
        );
        return null;
      },
    ),
  ]);

  return _ShadedImageData(
    image: image,
    program: results[0] as ui.FragmentProgram?,
    fallbackImage: results[1] as ui.Image?,
  );
}

Future<ui.Image> _loadMonochromeImage(ui.Image image, Color color) async {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) {
    throw StateError('Unable to read image pixels.');
  }

  final rgba = Uint8List.fromList(
    byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  );
  final monochromeRgba = await compute(
    _monochromeRgba,
    _MonochromeTransformRequest(
      rgba: rgba,
      tintRed: (color.r * 255).round(),
      tintGreen: (color.g * 255).round(),
      tintBlue: (color.b * 255).round(),
      tintAlpha: color.a,
    ),
  );

  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    monochromeRgba,
    image.width,
    image.height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );

  return completer.future;
}

Uint8List _monochromeRgba(_MonochromeTransformRequest request) {
  final pixels = request.rgba;

  for (var offset = 0; offset < pixels.length; offset += 4) {
    final luminance =
        (0.299 * pixels[offset] +
            0.587 * pixels[offset + 1] +
            0.114 * pixels[offset + 2]) /
        255;

    pixels[offset] = (request.tintRed * luminance)
        .round()
        .clamp(0, 255)
        .toInt();
    pixels[offset + 1] = (request.tintGreen * luminance)
        .round()
        .clamp(0, 255)
        .toInt();
    pixels[offset + 2] = (request.tintBlue * luminance)
        .round()
        .clamp(0, 255)
        .toInt();
    pixels[offset + 3] = (pixels[offset + 3] * request.tintAlpha)
        .round()
        .clamp(0, 255)
        .toInt();
  }

  return pixels;
}

class _MonochromeTransformRequest {
  final Uint8List rgba;
  final int tintRed;
  final int tintGreen;
  final int tintBlue;
  final double tintAlpha;

  const _MonochromeTransformRequest({
    required this.rgba,
    required this.tintRed,
    required this.tintGreen,
    required this.tintBlue,
    required this.tintAlpha,
  });
}

class _ShadedImageData {
  final ui.Image image;
  final ui.FragmentProgram? program;
  final ui.Image? fallbackImage;

  const _ShadedImageData({
    required this.image,
    required this.program,
    required this.fallbackImage,
  });
}

class ShadedImagePainter extends CustomPainter {
  final ui.Image image;
  final ui.FragmentProgram? program;
  final ui.Image? fallbackImage;
  final BoxFit fit;
  final ImageShaderEffect effect;
  final ValueListenable<double>? timeListenable;

  ShadedImagePainter({
    required this.image,
    required this.program,
    required this.fallbackImage,
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
    final program = this.program;

    canvas
      ..save()
      ..clipRect(destination)
      ..translate(destination.left, destination.top);

    if (program == null) {
      _paintFallback(canvas, destination.size);
      canvas.restore();
      return;
    }

    try {
      final shader = program.fragmentShader();
      effect.applyUniforms(
        shader,
        image,
        destination.size,
        timeListenable?.value ?? 0,
      );
      canvas.drawRect(Offset.zero & destination.size, Paint()..shader = shader);
    } catch (error, stackTrace) {
      debugPrint('[ShadedImage] Failed to apply shader: $error\n$stackTrace');
      _paintFallback(canvas, destination.size);
    } finally {
      canvas.restore();
    }
  }

  void _paintFallback(Canvas canvas, Size size) {
    final fallbackImage = this.fallbackImage;
    if (fallbackImage == null) {
      paintImage(
        canvas: canvas,
        rect: Offset.zero & size,
        image: image,
        fit: BoxFit.fill,
      );
      return;
    }

    paintImage(
      canvas: canvas,
      rect: Offset.zero & size,
      image: fallbackImage,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(ShadedImagePainter oldDelegate) {
    return image != oldDelegate.image ||
        program != oldDelegate.program ||
        fallbackImage != oldDelegate.fallbackImage ||
        fit != oldDelegate.fit ||
        effect != oldDelegate.effect ||
        timeListenable != oldDelegate.timeListenable;
  }
}
