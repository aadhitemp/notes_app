import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/auth/bloc/auth_bloc.dart';
import 'package:notesapp/services/auth/bloc/auth_events.dart';
import 'package:notesapp/services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _HomePageState();
}

class _HomePageState extends State<LoginView> {
  late final TextEditingController _email;
  //We need stateful widgets to use late fields
  late final TextEditingController _password;
  //CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          // final closeDialog = _closeDialogHandle;
          // if (!state.isLoading && closeDialog != null) {
          //   closeDialog();
          //   _closeDialogHandle = null;
          // } else if (state.isLoading && closeDialog == null) {
          //   _closeDialogHandle = showLoadingDialog(
          //     context: context,
          //     text: 'Loading...',
          //   );
          // }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'Cannot find a user with the entered credentials!');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
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
                    margin: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Column(
                          children: [
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            Text("Enter your credential to login"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _email,
                              enableSuggestions: false,
                              autocorrect: false,
                              autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter your email here',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor: Colors.purple.withOpacity(0.1),
                                filled: true,
                                prefixIcon: const Icon(Icons.email),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _password,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor: Colors.purple.withOpacity(0.1),
                                filled: true,
                                hintText: 'Password here',
                                prefixIcon: const Icon(Icons.password),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () async {
                                  final email = _email.text;
                                  final password = _password.text;
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthEventLogIn(email, password));
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  backgroundColor: Colors.purple,
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    const AuthEventForgotPassword(),
                                  );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Dont have an account?"),
                            TextButton(
                                onPressed: () {
                                  // Navigator.of(context).pushNamedAndRemoveUntil(
                                  //     registerRoute, (route) => false);
                                  context.read<AuthBloc>().add(
                                        const AuthEvenShouldRegister(),
                                      );
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.purple,
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  );
                default:
                  return const Text('Loading..');
              }
            }),
      ),
    );
  }
}
