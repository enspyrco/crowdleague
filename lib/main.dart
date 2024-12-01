import 'package:crowdleague/services/geo_location_service.dart';
import 'package:crowdleague/services/venues_service.dart';
import 'package:crowdleague/venues/add_venue_location_screen.dart';
import 'package:crowdleague/venues/finalise_venue_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

import 'auth/sign_in_screen.dart';
import 'home/home_screen.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/images_service.dart';
import 'services/storage_service.dart';
import 'services/user_service.dart';
import 'venues/configure_venue_screen.dart';
import 'you/edit_profile_screen.dart';
import 'utils/locator.dart';

final _router = GoRouter(
  initialLocation:
      locate<AuthService>().currentUserId == null ? '/signin' : '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/image-picker',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
        path: '/add-venue-location',
        builder: (context, state) => const AddVenueLocationScreen()),
    GoRoute(
        path: '/configure-venue',
        builder: (context, state) => const ConfigureVenueScreen()),
    GoRoute(
        path: '/finalise-venue',
        builder: (context, state) => const FinaliseVenueScreen()),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // The order here matters as the AuthService accesses the UserService in its
  // constructor to setup listening to the profile.
  Locator.add<UserService>(UserService());
  Locator.add<AuthService>(AuthService());

  Locator.add<StorageService>(StorageService());
  Locator.add<FirestoreService>(FirestoreService());
  Locator.add<ImagesService>(ImagesService());
  Locator.add<GeoLocationService>(GeoLocationService());
  Locator.add<VenuesService>(VenuesService());

  runApp(const CrowdLeagueApp());
}

class CrowdLeagueApp extends StatefulWidget {
  const CrowdLeagueApp({super.key});

  @override
  State<CrowdLeagueApp> createState() => _CrowdLeagueAppState();
}

class _CrowdLeagueAppState extends State<CrowdLeagueApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
