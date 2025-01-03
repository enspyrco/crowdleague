class UploadEvent {
  UploadEvent({required int transferred, required int total}) {
    final double progress = transferred / total;
    if (progress.isInfinite) _progress = 1.0;
    if (progress.isNaN) _progress = 0.0;
  }

  late final double _progress;
  double get progress => _progress;
}
