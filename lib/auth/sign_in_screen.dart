import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/user_auth_service.dart';
import '../utils/icons/custom_icons.dart';
import '../utils/locator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isSigningIn = false;

  Future<void> signInWithApple(BuildContext context) async {
    setState(() {
      isSigningIn = true;
    });
    await locate<UserAuthService>().signInWithApple();
    if (context.mounted) context.pushReplacement('/');
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(() {
      isSigningIn = true;
    });
    await locate<UserAuthService>().signInWithGoogle();
    if (context.mounted) context.pushReplacement('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (isSigningIn)
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.macOS)
                    SizedBox(
                      width: 185,
                      child: TextButton.icon(
                        icon: const Icon(
                          CustomIcons.apple,
                          size: 16,
                        ),
                        onPressed: () => signInWithApple(context),
                        label: const Text('Sign in with Apple'),
                        style: const ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          textStyle: WidgetStatePropertyAll(
                              TextStyle(color: Colors.white)),
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
                  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android)
                    SizedBox(
                      child: TextButton.icon(
                        icon: Image.asset(
                          'assets/images/google_icon.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          signInWithGoogle(context);
                        },
                        label: const Text('Sign in with Google'),
                        style: ButtonStyle(
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          textStyle: const WidgetStatePropertyAll(
                              TextStyle(color: Colors.white)),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.blue[600]),
                          shape: const WidgetStatePropertyAll<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
