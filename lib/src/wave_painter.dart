import 'package:flutter/material.dart';

import 'base/utils.dart';

class WavePainter extends CustomPainter {
  final List<double> waveData;
  final Color waveColor;
  final bool showMiddleLine;
  final double spacing;
  final double initialPosition;
  final bool showTop;
  final bool showBottom;
  final double scaleFactor;
  final double bottomPadding;
  final StrokeCap waveCap;
  final Color middleLineColor;
  final double middleLineThickness;
  final Offset totalBackDistance;
  final Offset dragOffset;
  final double waveThickness;
  final VoidCallback pushBack;
  final bool callPushback;
  final bool extendWaveform;
  final bool showDurationLine;
  final bool showHourInDuration;
  final double updateFrequecy;
  final Paint _wavePaint;
  final Paint _linePaint;
  final Paint _durationLinePaint;
  final TextStyle durationStyle;
  final Color durationLinesColor;
  final double durationTextPadding;
  WavePainter({
    required this.waveData,
    required this.waveColor,
    required this.showMiddleLine,
    required this.spacing,
    required this.initialPosition,
    required this.showTop,
    required this.showBottom,
    required this.scaleFactor,
    required this.bottomPadding,
    required this.waveCap,
    required this.middleLineColor,
    required this.middleLineThickness,
    required this.totalBackDistance,
    required this.dragOffset,
    required this.waveThickness,
    required this.pushBack,
    required this.callPushback,
    required this.extendWaveform,
    required this.updateFrequecy,
    required this.showHourInDuration,
    required this.showDurationLine,
    required this.durationStyle,
    required this.durationLinesColor,
    required this.durationTextPadding,
  })  : _wavePaint = Paint()
          ..color = waveColor
          ..strokeWidth = waveThickness
          ..strokeCap = waveCap,
        _linePaint = Paint()
          ..color = middleLineColor
          ..strokeWidth = middleLineThickness,
        _durationLinePaint = Paint()
          ..strokeWidth = 2
          ..color = durationLinesColor;
  var labelPadding = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    ///duration labels
    if (showDurationLine) {
      //for now adding extra 5 seconds
      for (var i = 0; i < waveData.length + 5; i++) {
        _drawDurationLine(canvas, size, i);
      }
    }

    for (var i = 0; i < waveData.length; i++) {
      if (((spacing * i) + dragOffset.dx + spacing >
              size.width / (extendWaveform ? 1 : 2) + totalBackDistance.dx) &&
          callPushback) {
        pushBack();
      }

      ///upper graph
      if (showTop) {
        _drawUpperWave(canvas, size, i);
      }

      ///lower graph
      if (showBottom) {
        _drawLowerWave(canvas, size, i);
      }
    }
    if (showMiddleLine) {
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        _linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return true;
  }

  void _drawUpperWave(Canvas canvas, Size size, int i) {
    canvas.drawLine(
        Offset(
            -totalBackDistance.dx +
                dragOffset.dx +
                (spacing * i) -
                initialPosition,
            size.height - bottomPadding),
        Offset(
            -totalBackDistance.dx +
                dragOffset.dx +
                (spacing * i) -
                initialPosition,
            -waveData[i] * scaleFactor + size.height - bottomPadding),
        _wavePaint);
  }

  void _drawLowerWave(Canvas canvas, Size size, int i) {
    canvas.drawLine(
        Offset(
            -totalBackDistance.dx +
                dragOffset.dx +
                (spacing * i) -
                initialPosition,
            size.height - bottomPadding),
        Offset(
            -totalBackDistance.dx +
                dragOffset.dx +
                (spacing * i) -
                initialPosition,
            waveData[i] * scaleFactor + size.height - bottomPadding),
        _wavePaint);
  }

  void _drawDurationLine(Canvas canvas, Size size, int i) {
    final textSpan = TextSpan(
      text: showHourInDuration
          ? toHHMMSS(Duration(seconds: i))
          : toMMSS(Duration(seconds: i).inSeconds),
      style: durationStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    canvas.drawLine(
        Offset(
            labelPadding + dragOffset.dx - totalBackDistance.dx, size.height),
        Offset(labelPadding + dragOffset.dx - totalBackDistance.dx,
            size.height + 16),
        _durationLinePaint);
    // canvas.drawLine(
    //     Offset(labelPadding / 2 + dragOffset.dx - totalBackDistance.dx,
    //         size.height),
    //     Offset(labelPadding / 2 + dragOffset.dx - totalBackDistance.dx,
    //         size.height + 8),
    //     _durationLinePaint);
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(
        labelPadding + dragOffset.dx - totalBackDistance.dx - durationTextPadding,
        size.height + 16,
      ),
    );
    labelPadding += spacing * updateFrequecy;
  }
}

///Addtion Information to get first and last wave location
///-totalBackDistance.dx + dragOffset.dx + (spacing * i)
///this gives location of first wave from right to left
///-totalBackDistance.dx + dragOffset.dx
///this gives location of first wave from left to right
