import 'package:flutter/material.dart';

/// A necktie glyph drawn with a [CustomPainter] — Material Icons has no tie.
/// [filled] paints a solid tie (used for elders); otherwise it is outlined
/// (ministerial servants). Sized and colored to sit beside Material [Icon]s.
class TieIcon extends StatelessWidget {
  const TieIcon({
    super.key,
    required this.filled,
    required this.color,
    this.size = 18,
  });

  final bool filled;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _TiePainter(filled: filled, color: color),
        ),
      );
}

class _TiePainter extends CustomPainter {
  _TiePainter({required this.filled, required this.color});

  final bool filled;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Path authored in a 24x24 box, then scaled to the requested size.
    final scale = size.shortestSide / 24.0;
    Offset p(double x, double y) => Offset(x * scale, y * scale);

    // Knot (wide top) narrowing to the neck, then the blade widening and
    // tapering to a point — a single closed silhouette.
    final tie = Path()
      ..moveTo(p(9.5, 2).dx, p(9.5, 2).dy)
      ..lineTo(p(14.5, 2).dx, p(14.5, 2).dy)
      ..lineTo(p(13.5, 6.5).dx, p(13.5, 6.5).dy)
      ..lineTo(p(16, 15).dx, p(16, 15).dy)
      ..lineTo(p(12, 22).dx, p(12, 22).dy)
      ..lineTo(p(8, 15).dx, p(8, 15).dy)
      ..lineTo(p(10.5, 6.5).dx, p(10.5, 6.5).dy)
      ..close();

    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(tie, paint);
    // Neck line hinting the knot; only visible (and needed) when outlined.
    if (!filled) {
      canvas.drawLine(p(10.5, 6.5), p(13.5, 6.5), paint);
    }
  }

  @override
  bool shouldRepaint(_TiePainter old) =>
      old.filled != filled || old.color != color;
}
