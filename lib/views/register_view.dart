import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/auth/bloc/auth_events.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordcheck;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordcheck = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordcheck.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
        body: FutureBuilder(
            future: AuthService.firebase().initialize(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    height: MediaQuery.of(context).size.height - 50,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: <Widget>[
                            const SizedBox(height: 60.0),
                            const Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Create your account",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
                            )
                          ],
                        ),
                        TextField(
                          controller: _email,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.email)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.purple.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _passwordcheck,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.purple.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          child: ElevatedButton(
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              context
                                  .read<AuthBloc>()
                                  .add(AuthEventRegister(email, password));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.purple,
                            ),
                            child: const Text(
                              "Sign up",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                                onPressed: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(const AuthEventLogOut());
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.purple,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  );
                default:
                  return const Center(child: Text('Loading..'));
              }
            }),
      ),
    );
  }
}
