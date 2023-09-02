
import 'package:chatx/bloc/auth/authentication_bloc.dart';
import 'package:chatx/core/utils/extenstions.dart';
import 'package:chatx/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  bool obscure = true;
  DateTime dateOfBirth = DateTime.now().subtract(
    const Duration(
      days: 365 * 18,
    ),
  );
  final gender = TextEditingController(text: 'male');

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
                        'Create Account',
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

                      /// name
                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        autofillHints: const [AutofillHints.name],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

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
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          hintText: 'Enter your phone',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Phone is required';
                          } else if (value?.isPhoneNumber == false) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      /// gender male, female, other
                      DropdownButtonFormField<String>(
                        value: gender.text,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Please select your gender!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          hintText: 'Please select your gender!',
                          prefixIcon: Icon(Icons.person),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        items: const [
                          DropdownMenuItem(
                            value: 'male',
                            child: Text('Male'),
                          ),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (genderOf) {
                          if (genderOf == null) return;
                          gender.text = genderOf;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        readOnly: true,
                        autofillHints: const [AutofillHints.birthday],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (date) {
                          dateOfBirth = DateTime.tryParse(date) ?? dateOfBirth;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText:
                              'Date of Birth : ${dateOfBirth.toLocal().toString().split(' ').first}',
                          hintText:
                              'Date of Birth : ${dateOfBirth.toLocal().toString().split(' ').first}',
                          prefixIcon: const Icon(Icons.today),

                          /// suffixIcon select date of birth from calendar button
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: dateOfBirth,
                                firstDate: DateTime(1900),
                                lastDate: dateOfBirth,
                              );
                              if (date == null) return;
                              dateOfBirth = date;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// create account button
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            final user = User(
                              name: name.text.trim(),
                              email: email.text.trim(),
                              password: password.text.trim(),
                              phone: int.tryParse(phone.text),
                              gender: gender.text.trim(),
                              dateOfBirth: dateOfBirth,
                              avatar: email.text.trim().split('@').first,
                            );
                            context.read<AuthenticationBloc>().add(
                                  RegisterEvent(user: user),
                                );
                          }
                        },
                        child: const Text('Create Account'),
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
