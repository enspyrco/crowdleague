/// A [NextDispatcher] for use in middleware tests, just returns the single
/// parameter. Allows the middleware to be called without throwing but otherwise
/// doesn't take part in the test.
final iDispatcher = (dynamic x) => x;
