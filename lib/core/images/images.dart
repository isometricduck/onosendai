import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const _ditherShaderAsset = 'assets/shaders/dither.glsl';

Future<ui.FragmentProgram>? _ditherProgramFuture;

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

Future<ui.FragmentProgram> loadDitherFragmentProgram() {
  return _ditherProgramFuture ??= ui.FragmentProgram.fromAsset(
    _ditherShaderAsset,
  );
}

@immutable
class DitherShaderSettings {
  final double pixelSize;
  final double ditherAmount;
  final double bitDepth;
  final double contrast;
  final Color foreground;
  final Color background;

  const DitherShaderSettings({
    this.pixelSize = 2,
    this.ditherAmount = 0.85,
    this.bitDepth = 1,
    this.contrast = 1.2,
    this.foreground = const Color(0xFFEBDBB2),
    this.background = const Color(0xFF1D2021),
  });
}

class DitheredNetworkImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final WidgetBuilder placeholderBuilder;
  final WidgetBuilder errorBuilder;
  final DitherShaderSettings settings;

  const DitheredNetworkImage({
    super.key,
    required this.url,
    required this.placeholderBuilder,
    required this.errorBuilder,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.settings = const DitherShaderSettings(),
  });

  @override
  State<DitheredNetworkImage> createState() => _DitheredNetworkImageState();
}

class _DitheredNetworkImageState extends State<DitheredNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return DitheredImage(
      imageProvider: CachedNetworkImageProvider(widget.url),
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      placeholderBuilder: widget.placeholderBuilder,
      errorBuilder: widget.errorBuilder,
      settings: widget.settings,
    );
  }
}

class DitheredImage extends StatefulWidget {
  final ImageProvider imageProvider;
  final BoxFit fit;
  final double? width;
  final double? height;
  final WidgetBuilder placeholderBuilder;
  final WidgetBuilder errorBuilder;
  final DitherShaderSettings settings;

  const DitheredImage({
    super.key,
    required this.imageProvider,
    required this.placeholderBuilder,
    required this.errorBuilder,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.settings = const DitherShaderSettings(),
  });

  @override
  State<DitheredImage> createState() => _DitheredImageState();
}

class _DitheredImageState extends State<DitheredImage> {
  late Future<(ui.FragmentProgram, ui.Image)> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadShaderImage(widget.imageProvider);
  }

  @override
  void didUpdateWidget(DitheredImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != oldWidget.imageProvider) {
      _imageFuture = _loadShaderImage(widget.imageProvider);
    }
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
              child: CustomPaint(
                painter: DitheredImagePainter(
                  image: image,
                  program: program,
                  fit: widget.fit,
                  settings: widget.settings,
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
) async {
  final results = await Future.wait<Object>([
    loadDitherFragmentProgram(),
    loadImageProviderAsUiImage(imageProvider),
  ]);

  return (results[0] as ui.FragmentProgram, results[1] as ui.Image);
}

class DitheredImagePainter extends CustomPainter {
  final ui.Image image;
  final ui.FragmentProgram program;
  final BoxFit fit;
  final DitherShaderSettings settings;

  const DitheredImagePainter({
    required this.image,
    required this.program,
    this.fit = BoxFit.contain,
    this.settings = const DitherShaderSettings(),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final sourceSize = Size(image.width.toDouble(), image.height.toDouble());
    final fitted = applyBoxFit(fit, sourceSize, size);
    final destination = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & size,
    );
    final shader = _createDitherShader(destination.size);

    canvas
      ..save()
      ..clipRect(destination)
      ..translate(destination.left, destination.top)
      ..drawRect(Offset.zero & destination.size, Paint()..shader = shader)
      ..restore();
  }

  ui.FragmentShader _createDitherShader(Size size) {
    final shader = program.fragmentShader()
      ..setImageSampler(0, image)
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, settings.pixelSize)
      ..setFloat(3, settings.ditherAmount)
      ..setFloat(4, settings.bitDepth)
      ..setFloat(5, settings.contrast);

    _setColor(shader, 6, settings.foreground);
    _setColor(shader, 9, settings.background);
    return shader;
  }

  void _setColor(ui.FragmentShader shader, int index, Color color) {
    shader
      ..setFloat(index, color.r)
      ..setFloat(index + 1, color.g)
      ..setFloat(index + 2, color.b);
  }

  @override
  bool shouldRepaint(DitheredImagePainter oldDelegate) {
    return image != oldDelegate.image ||
        program != oldDelegate.program ||
        fit != oldDelegate.fit ||
        settings != oldDelegate.settings;
  }
}
