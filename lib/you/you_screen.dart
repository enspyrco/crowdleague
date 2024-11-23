import 'package:crowdleague/auth/sign_in_screen.dart';
import 'package:crowdleague/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class YouScreen extends StatefulWidget {
  const YouScreen({super.key});

  @override
  State<YouScreen> createState() => _YouScreenState();
}

class _YouScreenState extends State<YouScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: SizedBox(
          width: 120,
          height: 120,
          child: CircleAvatar(
            backgroundColor: Colors.yellow.shade800,
            child: const Text(
              'AH',
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        onPressed: () {
          context.push('/image-picker');
        },
      ),
    );
  }
}
