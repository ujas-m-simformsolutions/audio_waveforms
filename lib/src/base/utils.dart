
///converts duration to HH:MM:SS format
String toHHMMSS(Duration d) => d.toString().split('.').first.padLeft(8, "0");

///converts duration to MM:SS format
String toMMSS(int value) =>
    '${(value ~/ 60).toString().padLeft(2, '0')}:${(value % 60).toString().padLeft(2, '0')}';

///state of recording
enum RecordingState { playing, stopped }
