import 'package:chatx/bloc/auth/authentication_bloc.dart';
import 'package:chatx/bloc/conversation/conversation_bloc.dart';
import 'package:chatx/bloc/search/search_user_bloc.dart';
import 'package:chatx/bloc/theme/theme_bloc.dart';
import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:chatx/core/routes/app_router.dart';
import 'package:chatx/core/utils/color_scheme.dart';
import 'package:chatx/data/repositories/auth_repository.dart';
import 'package:chatx/data/repositories/user_repository.dart';
import 'package:chatx/data/services/auth_service.dart';
import 'package:chatx/data/services/user_service.dart';
import 'package:chatx/debug/router_observer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (BuildContext context) => ThemeBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc()..add(CheckUserState()),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(
            userBloc: context.read<UserBloc>(),
            repository: AuthRepositoryOf(
              service: AuthService(
                dio: Dio(),
              ),
            ),
          ),
        ),
        /// conversation bloc
        BlocProvider<ConversationBloc>(
          create: (BuildContext context) => ConversationBloc(
            repository: UserRepositoryOf(
              service: UserService(
                dio: Dio(),
              ),
            ),
          )..add(const GetConversations()),
        ),
        /// search user bloc
        BlocProvider<SearchUserBloc>(
          create: (BuildContext context) => SearchUserBloc(
            repository: UserRepositoryOf(
              service: UserService(
                dio: Dio(),
              ),
            ),
          ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp.router(
            title: 'ChatX',
            debugShowCheckedModeBanner: false,
            themeMode: mode,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.urbanistTextTheme(
                Theme.of(context).textTheme,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: darkColorScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.urbanistTextTheme(
                Theme.of(context).textTheme,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            routerConfig: AppRouter(
              observer: RouterObserver(),
              userBloc: BlocProvider.of<UserBloc>(context),
            ).router,
          );
        },
      ),
    );
  }
}
