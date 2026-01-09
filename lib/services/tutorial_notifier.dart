import 'package:flutter/foundation.dart';

/// Notifies listeners when the onboarding tutorial has completed.
/// Used to delay location permission requests until after the tutorial.
class TutorialNotifier extends ValueNotifier<bool> {
  TutorialNotifier() : super(false);

  void markComplete() {
    value = true;
  }
}
