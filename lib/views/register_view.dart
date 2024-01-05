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
  late final TextEditingController
      _email; //We need stateful widgets to use late fields
  late final TextEditingController _password;

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
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: FutureBuilder(
            future: AuthService.firebase().initialize(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Enter your email here'),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration:
                            const InputDecoration(hintText: 'Password here'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context
                              .read<AuthBloc>()
                              .add(AuthEventRegister(email, password));
                          //   try {
                          //     await AuthService.firebase()
                          //         .createUser(email: email, password: password);
                          //     AuthService.firebase().sendEmailVerification();
                          //     Navigator.of(context).pushNamed(verifyEmailRoute);
                          //   } on WeakPasswordAuthException {
                          //     await showErrorDialog(
                          //       context,
                          //       'Weak Password',
                          //     );
                          //   } on EmailAlreadyInUseAuthException {
                          //     await showErrorDialog(
                          //       context,
                          //       'Email already in Use',
                          //     );
                          //   } on InvalidEmailAuthException {
                          //     await showErrorDialog(
                          //       context,
                          //       'Invalid Email',
                          //     );
                          //   } on GenericAuthException {
                          //     await showErrorDialog(
                          //       context,
                          //       'Failed to Register',
                          //     );
                          //   }
                          // },
                        },
                        child: const Text('Register'),
                      ),
                      TextButton(
                          onPressed: () {
                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //     loginRoute, (route) => false);
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          },
                          child: const Text('Already registered? Login here'))
                    ],
                  );
                default:
                  return const Text('Loading..');
              }
            }),
      ),
    );
  }
}
