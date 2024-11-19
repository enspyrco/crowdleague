import 'package:crowdleague/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _router = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser == null ? '/signin' : '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isSigningIn = false;

  Future<UserCredential> signInWithApple(BuildContext context) async {
    final appleProvider = AppleAuthProvider();
    setState(() {
      isSigningIn = true;
    });
    final credential =
        await FirebaseAuth.instance.signInWithProvider(appleProvider);
    if (context.mounted) context.pushReplacement('/');
    return credential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (isSigningIn)
            ? const CircularProgressIndicator()
            : TextButton.icon(
                icon: const Icon(
                  CustomIcons.apple,
                  size: 16,
                ),
                onPressed: () => signInWithApple(context),
                label: const Text('Sign in with Apple'),
                style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  textStyle:
                      WidgetStatePropertyAll(TextStyle(color: Colors.white)),
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) context.pushReplacement('/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () => signOut(context), child: const Text('Sign Out')),
      ),
    );
  }
}
