import 'package:chatx/bloc/auth/authentication_bloc.dart';
import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:chatx/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_avatar/random_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<UserBloc, User>(
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// create account
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),

                  /// avatar
                  RandomAvatar(
                    state.name ?? 'Anonymous',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${DateTime.now().greeting} ${state.name?.split(' ').first}!',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),

                  /// email
                  Text(
                    '${state.email}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    '${state.phone}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    'Status: ${state.status == true ? 'Active' : 'Inactive'}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              state.status == true ? Colors.green : Colors.red,
                        ),
                  ),
                  const SizedBox(height: 16),

                  /// joined
                  Text(
                    'Joined ${state.createdAt?.year}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 16),

                  /// logout
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(SignOutEvent());
                    },
                    label: const Text('Sign Out'),
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

extension OnDateTime on DateTime {
  /// gretting message
  String get greeting {
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
