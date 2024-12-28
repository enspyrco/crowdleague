/// Represents the current status of the platforms notification permissions.
enum AuthorizationStatus {
  /// The app is authorized to create notifications.
  authorized,

  /// The app is not authorized to create notifications.
  denied,

  /// The app user has not yet chosen whether to allow the application to create
  /// notifications. Usually this status is returned prior to the first call
  /// of [requestPermission].
  notDetermined,

  /// The app is currently authorized to post non-interrupting user notifications.
  provisional,
}
