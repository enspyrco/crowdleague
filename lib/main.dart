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
import 'utils/image_picker_screen.dart';
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
  Locator.add<ImagesService>(ImagesService());
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
