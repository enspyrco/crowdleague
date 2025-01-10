enum NavigationDestinations {
  venues('Venues'),
  notifications('Notifications'),
  messages('Messages'),
  you('You');

  const NavigationDestinations(this.description);

  final String description;
}
