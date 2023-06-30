import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'package:photo_album/pages/pages.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => onTapAuth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Icon(
              Icons.fingerprint,
              size: 124.0,
            ),
            Text(
              "Touch to Login",
              style: TextStyle(
                fontSize: 64.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void onTapAuth(BuildContext context) async {
    bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

    if (weCanCheckBiometrics) {
      bool authenticated = await localAuth.authenticate(
        localizedReason: "Authenticate.",
      );

      if (authenticated && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardPage(),
          ),
        );
      }
    }
  }
}
