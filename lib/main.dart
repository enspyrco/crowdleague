import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

import 'auth/sign_in_screen.dart';
import 'home/home_screen.dart';
import 'onboarding/edit_name_screen.dart';
import 'onboarding/onboard_notifications.dart';
import 'onboarding/edit_profile_pic_screen.dart';
import 'players/find_players_screen.dart';
import 'players/player_profile_screen.dart';
import 'services/geo_location_service.dart';
import 'services/images_service.dart';
import 'services/messaging_service.dart';
import 'services/players_service.dart';
import 'services/user_auth_service.dart';
import 'services/user_service.dart';
import 'services/venues_service.dart';
import 'venues/add-venue/screens/finalise_new_venue_screen.dart';
import 'venues/add-venue/screens/select_new_venue_location_screen.dart';
import 'venues/venue-detail/venue_detail_screen.dart';
import 'utils/locator.dart';

final _router = GoRouter(
  initialLocation:
      locate<UserAuthService>().currentUserId == null ? '/signin' : '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
      redirect: (BuildContext context, GoRouterState state) async {
        bool onboarded = await locate<UserService>().userHasOnboarded;
        if (!onboarded) {
          return '/edit-name';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      name: 'signin',
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      name: 'edit-name',
      path: '/edit-name/onboarding/:onboarding',
      builder: (context, state) => EditNameScreen(
        onboarding: state.pathParameters['onboarding']!,
      ),
    ),
    GoRoute(
      name: 'edit-profile-pic',
      path: '/edit-profile-pic/onboarding/:onboarding',
      builder: (context, state) => EditProfilePicScreen(
        onboarding: state.pathParameters['onboarding']!,
      ),
    ),
    GoRoute(
      name: 'onboard-notifications',
      path: '/onboard-notifications',
      builder: (context, state) => const OnboardNotifications(),
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
      name: 'find-players',
      path: '/find-players',
      builder: (context, state) => const FindPlayersScreen(),
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

  // Setup the data layer of the "data layer architecture"
  final firestore = kReleaseMode
      ? FirebaseFirestore.instanceFor(app: firebaseApp, databaseId: '(default)')
      : FirebaseFirestore.instanceFor(
          app: firebaseApp, databaseId: 'firestore-usa');
  final storage = kReleaseMode
      ? FirebaseStorage.instanceFor(bucket: 'gs://crowdleague-project-aus')
      : FirebaseStorage.instanceFor(
          bucket: 'gs://crowdleague-project.firebasestorage.app');
  final firebaseAuth = FirebaseAuth.instance;
  final messaging = FirebaseMessaging.instance;
  final cloudFunctions = FirebaseFunctions.instance;

  // The services make up the repositories layer of the "data layer architecture"
  Locator.add<MessagingService>(MessagingService(
    firestore: firestore,
    firebaseAuth: firebaseAuth,
    messaging: messaging,
  ));
  Locator.add<GeoLocationService>(GeoLocationService());
  Locator.add<UserService>(UserService(
      cloudFunctions: cloudFunctions,
      firebaseAuth: firebaseAuth,
      firestore: firestore));
  Locator.add<UserAuthService>(UserAuthService(
    firebaseAuth: firebaseAuth,
    firestore: firestore,
  ));
  Locator.add<PlayersService>(
      PlayersService(firestore: firestore, storage: storage));
  Locator.add<VenuesService>(
      VenuesService(firestore: firestore, storage: storage));
  Locator.add<ImagesService>(
      ImagesService(storage: storage, firebaseAuth: firebaseAuth));

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
