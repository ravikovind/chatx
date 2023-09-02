import 'package:chatx/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_avatar/random_avatar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                /// generate random avatar every second
                StreamBuilder(
                  stream: Stream<DateTime>.periodic(
                    const Duration(seconds: 2),
                    (_) => DateTime.now(),
                  ),
                  builder: (context, snapshot) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.secondary,
                            blurRadius: 1,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: RandomAvatar(
                        snapshot.data?.toIso8601String() ?? 'ChatX',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                /// chatx
                Text(
                  'ChatX',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),

                /// sologan
                Text(
                  'Chat with your friends & family in real-time.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),

                const SizedBox(height: 64),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(kSignUpRoute);
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(kSignInRoute);
                  },
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
