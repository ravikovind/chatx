import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:chatx/core/routes/routes.dart';
import 'package:chatx/data/models/conversation.dart';
import 'package:chatx/debug/router_observer.dart';
import 'package:chatx/view/pages/auth/auth.dart';
import 'package:chatx/view/pages/auth/sign_in.dart';
import 'package:chatx/view/pages/auth/sign_up.dart';
import 'package:chatx/view/pages/home/conversation.dart';
import 'package:chatx/view/pages/home/home.dart';
import 'package:chatx/view/pages/home/profile.dart';
import 'package:chatx/view/pages/home/search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({
    required this.observer,
    required this.userBloc,
  }) {
    _router = GoRouter(
      initialLocation: kHomeRoute,
      refreshListenable: userBloc,
      redirect: (context, state) {
        final authenticated = userBloc.state.accessToken != null &&
            userBloc.state.accessToken?.isNotEmpty == true &&
            userBloc.state.id != null &&
            userBloc.state.id?.isNotEmpty == true &&
            userBloc.state.name != null &&
            userBloc.state.name?.isNotEmpty == true &&
            userBloc.state.email != null &&
            userBloc.state.email?.isNotEmpty == true;
        final authRoute = state.location.startsWith(kAuthRoute);
        print(
            '\x1B[39m[GoRouter] Redirecting to ${state.location} according to auth state: $authenticated location is auth route: $authRoute\x1B[0m');
        if (!authRoute && !authenticated) {
          return kAuthRoute;
        } else if (authRoute && authenticated) {
          return kHomeRoute;
        }
        return null;
      },
      observers: [observer],
      routes: [
        GoRoute(
          path: kAuthRoute,
          name: kAuthRoute,
          builder: (context, state) => const AuthPage(),
          routes: [
            GoRoute(
              path: kSignInRoute,
              name: kSignInRoute,
              builder: (context, state) => const SignInPage(),
            ),
            GoRoute(
              path: kSignUpRoute,
              name: kSignUpRoute,
              builder: (context, state) => const SignUpPage(),
            ),
          ],
        ),
           GoRoute(
              path: kHomeRoute,
              name: kHomeRoute,
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  path: kUpdateRoute,
                  name: kUpdateRoute,
                  builder: (context, state) => Scaffold(
                    appBar: AppBar(
                      title: const Text('ChatX'),
                    ),
                  ),
                ),
                GoRoute(
                  path: kProfileRoute,
                  name: kProfileRoute,
                  builder: (context, state) => const ProfilePage(),
                ),
                GoRoute(
                  path: kSearchRoute,
                  name: kSearchRoute,
                  builder: (context, state) => const SearchPage(),
                ),
                GoRoute(
                  path: kConversationRoute,
                  name: kConversationRoute,
                  builder: (context, state) => ConversationPage(
                    conversation: state.extra as Conversation,
                  ),
                ),
              ],
            ),
          
      ],
    );
  }

  late final GoRouter _router;
  GoRouter get router => _router;
  final RouterObserver observer;
  final UserBloc userBloc;
}
