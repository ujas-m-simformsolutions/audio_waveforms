import 'package:flutter/material.dart';

class WaveController {
  Color waveColor;
  bool showMiddleLine;
  double spacing;
  bool showTop;
  bool showBottom;
  double scaleFactor;
  double? bottomPadding;
  StrokeCap waveCap;
  Color middleLineColor;
  double middleLineThickness;
  double waveThickness;
  Color backgroundColor;
  bool showDurationLine;
  bool showHourInDuration;

  //TODO: improve logic for getting flag from user for pushBack function
  bool? callPushback;
  bool extendWaveform;
  TextStyle durationStyle;
  Color durationLinesColor;
  ///value > 0 will be padded right and value < 0 will be padded left
  double durationTextPadding;

  WaveController({
    this.waveColor = Colors.blueGrey,
    this.showMiddleLine = true,
    this.spacing = 8.0,
    this.showTop = true,
    this.showBottom = true,
    this.scaleFactor = 1.0,
    this.bottomPadding,
    this.waveCap = StrokeCap.round,
    this.middleLineColor = Colors.redAccent,
    this.middleLineThickness = 3.0,
    this.waveThickness = 3.0,
    this.showDurationLine = true,
    this.callPushback,
    this.extendWaveform = false,
    this.backgroundColor = Colors.black,
    this.showHourInDuration = false,
    this.durationStyle = const TextStyle(
      color: Colors.red,
      fontSize: 16.0,
    ),
    this.durationTextPadding = 20.0,
    this.durationLinesColor = Colors.blueAccent,
  }) : assert(waveThickness < spacing,
            "waveThickness can't be greater than spacing");

  void refresh() {
    callPushback = true;
  }
}
