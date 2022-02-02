import 'package:flutter/material.dart';

class DashPaint extends CustomPainter {
  const DashPaint({Key? key}) : super();
  @override
  void paint(Canvas canvas, Size size) {
    var path_0 = Path();
    path_0.moveTo(size.width * 0.6586667, size.height * 0.01553618);
    path_0.cubicTo(
        size.width * 0.8848000,
        size.height * -0.03568795,
        size.width * 1.104888,
        size.height * 0.05194539,
        size.width * 1.186667,
        size.height * 0.1021652);
    path_0.lineTo(size.width * 1.186667, size.height * 1.100282);
    path_0.lineTo(size.width * -0.1093333, size.height * 1.100282);
    path_0.lineTo(size.width * -0.1093333, size.height * 0.1021652);
    path_0.cubicTo(
        size.width * 0.1306667,
        size.height * 0.1887947,
        size.width * 0.3760000,
        size.height * 0.07956629,
        size.width * 0.6586667,
        size.height * 0.01553618);
    path_0.close();

    var paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffFDFDFD).withOpacity(0.8);
    canvas.drawPath(path_0, paint_0_fill);

    var path_1 = Path();
    path_1.moveTo(size.width * 0.6586667, size.height * 0.03436855);
    path_1.cubicTo(
        size.width * 0.8848000,
        size.height * -0.01685554,
        size.width * 1.104888,
        size.height * 0.07077778,
        size.width * 1.186667,
        size.height * 0.1209976);
    path_1.lineTo(size.width * 1.186667, size.height * 1.119115);
    path_1.lineTo(size.width * -0.1093333, size.height * 1.119115);
    path_1.lineTo(size.width * -0.1093333, size.height * 0.1209976);
    path_1.cubicTo(
        size.width * 0.1306667,
        size.height * 0.2076271,
        size.width * 0.3760000,
        size.height * 0.09839868,
        size.width * 0.6586667,
        size.height * 0.03436855);
    path_1.close();

    var paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffFDFDFD).withOpacity(0.85);
    canvas.drawPath(path_1, paint_1_fill);

    var path_2 = Path();
    path_2.moveTo(size.width * 0.6586667, size.height * 0.05320094);
    path_2.cubicTo(
        size.width * 0.8848000,
        size.height * 0.001976855,
        size.width * 1.104888,
        size.height * 0.08961017,
        size.width * 1.186667,
        size.height * 0.1398299);
    path_2.lineTo(size.width * 1.186667, size.height * 1.137947);
    path_2.lineTo(size.width * -0.1093333, size.height * 1.137947);
    path_2.lineTo(size.width * -0.1093333, size.height * 0.1398299);
    path_2.cubicTo(
        size.width * 0.1306667,
        size.height * 0.2264595,
        size.width * 0.3760000,
        size.height * 0.1172311,
        size.width * 0.6586667,
        size.height * 0.05320094);
    path_2.close();

    var paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffFDFDFD).withOpacity(0.85);
    canvas.drawPath(path_2, paint_2_fill);

    var path_3 = Path();
    path_3.moveTo(size.width * 0.3413333, size.height * 0.02259831);
    path_3.cubicTo(
        size.width * 0.1152000,
        size.height * -0.02862580,
        size.width * -0.1048888,
        size.height * 0.05900753,
        size.width * -0.1866667,
        size.height * 0.1092273);
    path_3.lineTo(size.width * -0.1866667, size.height * 1.107345);
    path_3.lineTo(size.width * 1.109333, size.height * 1.107345);
    path_3.lineTo(size.width * 1.109333, size.height * 0.1092273);
    path_3.cubicTo(
        size.width * 0.8693333,
        size.height * 0.1958569,
        size.width * 0.6240000,
        size.height * 0.08662844,
        size.width * 0.3413333,
        size.height * 0.02259831);
    path_3.close();

    var paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFDFDFD).withOpacity(0.8);
    canvas.drawPath(path_3, paint_3_fill);

    var path_4 = Path();
    path_4.moveTo(size.width * 0.3413333, size.height * 0.03813503);
    path_4.cubicTo(
        size.width * 0.1152000,
        size.height * -0.01308906,
        size.width * -0.1048888,
        size.height * 0.07454426,
        size.width * -0.1866667,
        size.height * 0.1247640);
    path_4.lineTo(size.width * -0.1866667, size.height * 1.122881);
    path_4.lineTo(size.width * 1.109333, size.height * 1.122881);
    path_4.lineTo(size.width * 1.109333, size.height * 0.1247640);
    path_4.cubicTo(
        size.width * 0.8693333,
        size.height * 0.2113936,
        size.width * 0.6240000,
        size.height * 0.1021652,
        size.width * 0.3413333,
        size.height * 0.03813503);
    path_4.close();

    var paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xffFDFDFD).withOpacity(0.85);
    canvas.drawPath(path_4, paint_4_fill);

    var path_5 = Path();
    path_5.moveTo(size.width * 0.3440000, size.height * 0.06638362);
    path_5.cubicTo(
        size.width * 0.1178667,
        size.height * 0.01515953,
        size.width * -0.1022221,
        size.height * 0.1027928,
        size.width * -0.1840000,
        size.height * 0.1530126);
    path_5.lineTo(size.width * -0.1840000, size.height * 1.151130);
    path_5.lineTo(size.width * 1.112000, size.height * 1.151130);
    path_5.lineTo(size.width * 1.112000, size.height * 0.1530126);
    path_5.cubicTo(
        size.width * 0.8720000,
        size.height * 0.2396422,
        size.width * 0.6266667,
        size.height * 0.1304137,
        size.width * 0.3440000,
        size.height * 0.06638362);
    path_5.close();

    var paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffFDFDFD).withOpacity(0.7);
    canvas.drawPath(path_5, paint_5_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
