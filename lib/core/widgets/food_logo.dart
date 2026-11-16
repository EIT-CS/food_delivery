import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Figma-ийн "Food" лого: хар F, d болон шар-ногоон "oo", дээр нь хоолны
/// бүрхүүл (cloche). Зураг шаардахгүй, кодоор зурна.
class FoodLogo extends StatelessWidget {
  const FoodLogo({super.key, this.fontSize = 44, this.showTagline = true});

  final double fontSize;
  final bool showTagline;

  static const Color ink = Color(0xFF202333);
  static const Color lime = Color(0xFF98D832);
  static const Color muted = Color(0xFF929292);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: _LogoPainter.sizeFor(fontSize),
          painter: _LogoPainter(fontSize),
        ),
        if (showTagline) ...[
          const SizedBox(height: 6),
          const Text(
            'Амттай хоол, хурдан хүргэлт',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: muted,
            ),
          ),
        ],
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter(this.fs);

  final double fs;

  static TextPainter _text(String s, double fs, Color c) {
    return TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontSize: fs,
          fontWeight: FontWeight.w900,
          color: c,
          height: 1.0,
          letterSpacing: -fs * 0.03,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  static Size sizeFor(double fs) {
    final f = _text('F', fs, FoodLogo.ink);
    final o = _text('o', fs, FoodLogo.lime);
    final d = _text('d', fs, FoodLogo.ink);
    return Size(f.width + o.width * 2 + d.width, fs * 1.24);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final f = _text('F', fs, FoodLogo.ink);
    final o = _text('o', fs, FoodLogo.lime);
    final d = _text('d', fs, FoodLogo.ink);

    final dy = fs * 0.24;
    var x = 0.0;

    f.paint(canvas, Offset(x, dy));
    x += f.width;

    final firstOX = x;
    o.paint(canvas, Offset(x, dy));
    x += o.width;
    o.paint(canvas, Offset(x, dy));
    x += o.width;

    d.paint(canvas, Offset(x, dy));

    // Хоолны бүрхүүл: эхний "o"-ийн дээр.
    final baseline = o.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    final oTop = dy + baseline - fs * 0.53;
    final cx = firstOX + o.width / 2;
    final dw = o.width * 1.2;
    final dh = fs * 0.30;
    final baseY = oTop - fs * 0.06;

    final paint = Paint()..color = FoodLogo.lime;

    final dome = Path()
      ..moveTo(cx - dw / 2, baseY)
      ..arcTo(
        Rect.fromLTWH(cx - dw / 2, baseY - dh, dw, dh * 2),
        math.pi,
        math.pi,
        false,
      )
      ..close();
    canvas.drawPath(dome, paint);

    // Бүрхүүлийн суурь ба бариул.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - dw / 2 - fs * 0.04, baseY, dw + fs * 0.08, fs * 0.05),
        Radius.circular(fs * 0.025),
      ),
      paint,
    );
    canvas.drawCircle(Offset(cx, baseY - dh - fs * 0.025), fs * 0.045, paint);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter old) => old.fs != fs;
}
