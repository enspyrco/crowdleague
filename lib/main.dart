import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

import 'auth/sign_in_screen.dart';
import 'home/home_screen.dart';
import 'players/find_team_mate_screen.dart';
import 'players/player_profile_screen.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/geo_location_service.dart';
import 'services/images_service.dart';
import 'services/messaging_service.dart';
import 'services/players_service.dart';
import 'services/storage_service.dart';
import 'services/user_service.dart';
import 'services/venues_service.dart';
import 'venues/add-venue/screens/finalise_new_venue_screen.dart';
import 'venues/add-venue/screens/select_new_venue_location_screen.dart';
import 'venues/venue-detail/venue_detail_screen.dart';
import 'you/edit_profile_screen.dart';
import 'utils/locator.dart';

final _router = GoRouter(
  initialLocation:
      locate<UserService>().currentUserId == null ? '/signin' : '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'signin',
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      name: 'image-picker',
      path: '/image-picker',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
        name: 'select-new-venue-location',
        path: '/select-new-venue-location',
        builder: (context, state) => const SelectNewVenueLocationScreen()),
    GoRoute(
        name: 'finalise-new-venue',
        path: '/finalise-new-venue/latitude/:latitude/longitude/:longitude',
        builder: (context, state) => FinaliseNewVenueScreen(
              latitude: state.pathParameters['latitude']!,
              longitude: state.pathParameters['longitude']!,
            )),
    GoRoute(
      name: 'venue-detail',
      path: '/venue-detail/:id',
      builder: (context, state) => VenueDetailScreen(
        venueId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      name: 'find-team-mate',
      path: '/find-team-mate',
      builder: (context, state) => const FindTeamMateScreen(),
    ),
    GoRoute(
      name: 'player-profile',
      path: '/player-profile/:id',
      builder: (context, state) => PlayerProfileScreen(
        playerId: state.pathParameters['id']!,
      ),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // the data layer
  final authService = AuthService();
  final firestoreService = FirestoreService(firebaseApp);
  final storageService = StorageService();

  // possibly also data layer
  Locator.add<MessagingService>(MessagingService());
  Locator.add<GeoLocationService>(GeoLocationService());

  Locator.add<UserService>(UserService(
    authService: authService,
    firestoreService: firestoreService,
    storageService: storageService,
  ));

  // repository layer
  Locator.add<PlayersService>(PlayersService(
      firestoreService: firestoreService, storageService: storageService));
  Locator.add<VenuesService>(VenuesService(
      firestoreService: firestoreService, storageService: storageService));
  Locator.add<ImagesService>(ImagesService());

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
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 34,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 18,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 34,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 18,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
