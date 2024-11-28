import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/firestore_service.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/services/user_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

import 'auth/sign_in_screen.dart';
import 'home/home_screen.dart';
import 'utils/image_picker_screen.dart';

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
      builder: (context, state) => const ImagePickerScreen(),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Locator.add<AuthService>(AuthService());
  Locator.add<StorageService>(StorageService());
  Locator.add<FirestoreService>(FirestoreService());
  Locator.add<UserService>(UserService());

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
