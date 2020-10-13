/// A [NextDispatcher] for use in middleware tests, does nothing but allow the
/// middleware to be called without throwing.
final testDispatcher = (dynamic _) => null;
