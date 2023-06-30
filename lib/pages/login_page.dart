import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'package:photo_album/pages/pages.dart';
import 'package:photo_album/widgets/widgets.dart';
import 'package:photo_album/constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: GestureDetector(
            onTap: onTapAuth,
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
        ),
        Positioned(
          child: isLoading ? const LoadingView() : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void onTapAuth() async {
    setState(() => isLoading = true);
    bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

    if (weCanCheckBiometrics) {
      bool authenticated = await localAuth.authenticate(
        localizedReason: "Authenticate to use ${AppConstants.appTitle}.",
      );

      if (authenticated && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardPage(),
          ),
        ).then((_) => setState(() => isLoading = false));
      }
    }
  }
}
