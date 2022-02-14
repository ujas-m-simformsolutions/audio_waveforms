import 'package:audio_wave/src/base/enums.dart';
import 'package:audio_wave/src/wave_painter.dart';
import 'package:flutter/material.dart';
import './base/wave_controller.dart';

class AudioWave extends StatefulWidget {
  final List<double> waveData;
  final Size size;
  final RecordingState recordingState;
  final Duration updateFrequency;
  final WaveController waveController;

  const AudioWave({
    Key? key,
    required this.waveData,
    required this.size,
    required this.recordingState,
    required this.updateFrequency,
    required this.waveController,
  }) : super(key: key);

  @override
  _AudioWaveState createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave>
    with SingleTickerProviderStateMixin {
  bool _callPushBack = true;
  bool _isScrolled = false;

  Offset _totalBackDistance = Offset.zero;
  Offset dragOffset = Offset.zero;

  double _initialOffsetPosition = 0.0;
  double _initialPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleHorizontalDragUpdate,
      onHorizontalDragStart: _handleHorizontalDragStart,
      child: ColoredBox(
        color: widget.waveController.backgroundColor,
        child: RepaintBoundary(
          child: CustomPaint(
            size: widget.size,
            painter: WavePainter(
              waveThickness: widget.waveController.waveThickness,
              middleLineThickness: widget.waveController.middleLineThickness,
              middleLineColor: widget.waveController.middleLineColor,
              scaleFactor: widget.waveController.scaleFactor,
              waveData: widget.waveData,
              callPushback: widget.waveController.callPushback ?? _callPushBack,
              bottomPadding:
                  widget.waveController.bottomPadding ?? widget.size.height / 2,
              spacing: widget.waveController.spacing,
              waveCap: widget.waveController.waveCap,
              showBottom: widget.waveController.showBottom,
              showTop: widget.waveController.showTop,
              waveColor: widget.waveController.waveColor,
              showMiddleLine: widget.waveController.showMiddleLine,
              totalBackDistance: _totalBackDistance,
              dragOffset: dragOffset,
              pushBack: _pushBackWave,
              initialPosition: _initialPosition,
              extendWaveform: widget.waveController.extendWaveform,
              showHourInDuration: widget.waveController.showHourInDuration,
              showDurationLine: widget.waveController.showDurationLine,
              durationLinesColor: widget.waveController.durationLinesColor,
              durationStyle: widget.waveController.durationStyle,
              updateFrequecy: const Duration(seconds: 1).inMilliseconds /
                  widget.updateFrequency.inMilliseconds,
              durationTextPadding: widget.waveController.durationTextPadding,
            ),
          ),
        ),
      ),
    );
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    var direction = details.globalPosition.dx - _initialOffsetPosition;
    widget.waveController.callPushback = false;
    _isScrolled = true;

    ///left to right
    if (-_totalBackDistance.dx + dragOffset.dx + details.delta.dx <
            (widget.waveController.extendWaveform
                ? widget.size.width
                : widget.size.width / 2) &&
        direction > 0) {
      setState(() => dragOffset += details.delta);
    }

    ///right to left
    else if (-_totalBackDistance.dx +
                dragOffset.dx +
                (widget.waveController.spacing * widget.waveData.length) +
                details.delta.dx >
            (widget.waveController.extendWaveform
                ? widget.size.width
                : widget.size.width / 2) &&
        direction < 0) {
      setState(() => dragOffset += details.delta);
    }
  }

  void _handleHorizontalDragStart(DragStartDetails details) {
    _initialOffsetPosition = details.globalPosition.dx;
  }

  void _pushBackWave() {
    if (_isScrolled) {
      _initialPosition =
          widget.waveController.spacing * widget.waveData.length -
              widget.size.width / 2;
      _isScrolled = false;
    } else {
      _initialPosition = 0.0;
      _totalBackDistance =
          _totalBackDistance + Offset(widget.waveController.spacing, 0.0);
    }
  }
}
