import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:notesapp/constants/routes.dart';
//import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/auth/bloc/auth_bloc.dart';
import 'package:notesapp/services/auth/bloc/auth_events.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: [
          const Text(
            "We've sent you an email verifitcation. Please open it to verify your account.",
            textAlign: TextAlign.center,
          ),
          const Text(
            'If you haven"t received a verfication email yet, press the button below',
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              //await AuthService.firebase().sendEmailVerification();
              context
                  .read<AuthBloc>()
                  .add(const AuthEventSendEmailVerification());
            },
            child: const Text('Send email verfication'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: const Text('Restart'),
          ),
        ]),
      ),
    );
  }
}
