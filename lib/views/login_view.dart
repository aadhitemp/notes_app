import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/auth/bloc/auth_bloc.dart';
import 'package:notesapp/services/auth/bloc/auth_events.dart';
import 'package:notesapp/services/auth/bloc/auth_state.dart';
//import 'package:notesapp/utilities/dialogs/loading_dialog.dart';
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
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: FutureBuilder(
            future: AuthService.firebase().initialize(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        autofocus: true,
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
                              .add(AuthEventLogIn(email, password));
                          //try {
                          // final userCredential = await AuthService.firebase()
                          //     .logIn(email: email, password: password);
                          // final user = AuthService.firebase().currentUser;
                          // if (user?.isEmailVerified ?? false) {
                          //   devtools.log(userCredential.toString());
                          //   Navigator.of(context).pushNamedAndRemoveUntil(
                          //     notesRoute,
                          //     (route) => false,
                          //   );
                          // } else {
                          //   Navigator.of(context).pushNamedAndRemoveUntil(
                          //     verifyEmailRoute,
                          //     (route) => false,
                          //   );
                          // }
                          //   } on UserNotFoundAuthException {
                          //     await showErrorDialog(
                          //       context,
                          //       'User not found',
                          //     );
                          //   } on WrongPasswordAuthException {
                          //     await showErrorDialog(
                          //       context,
                          //       'Wrong Credentials', //injecting something inside a string ${}
                          //     );
                          //   } on GenericAuthException {
                          //     await showErrorDialog(
                          //       context,
                          //       'Authentication Error',
                          //     );
                          //   }
                          // },
                        },
                        child: const Text('Login'),
                      ),
                      TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventForgotPassword(),
                                );
                          },
                          child: const Text('Forgot Password?')),
                      TextButton(
                          onPressed: () {
                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //     registerRoute, (route) => false);
                            context.read<AuthBloc>().add(
                                  const AuthEvenShouldRegister(),
                                );
                          },
                          child:
                              const Text('Not Registered yet? Register here'))
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
