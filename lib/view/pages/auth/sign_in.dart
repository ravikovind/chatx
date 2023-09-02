import 'package:chatx/bloc/auth/authentication_bloc.dart';
import 'package:chatx/core/utils/extenstions.dart';
import 'package:chatx/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.message.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const CircularProgressIndicator();
            }
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// create account
                      Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 16),

                      /// sologan
                      Text(
                        'Chat with your friends & family in real-time.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),

                      const SizedBox(height: 16),

                      /// email
                      TextFormField(
                        controller: email,
                        autofillHints: const [AutofillHints.email],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Email is required';
                          } else if (value?.isEmail == false) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      /// password
                      TextFormField(
                        controller: password,
                        obscureText: obscure,
                        autofillHints: const [AutofillHints.password],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Password is required';
                          } else if (value?.isStrongPassword == false) {
                            return '''Password must be at least 8 characters long,
                              contain at least one uppercase letter,
                              one lowercase letter,
                              one number and one special character
                              e.g. Ghty@123
                              ''';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// create account button
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            final user = User(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                            context.read<AuthenticationBloc>().add(
                                  SignInEvent(user: user),
                                );
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
