import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:light/light.dart';
import 'package:provider/provider.dart';

import 'package:photo_album/pages/pages.dart';
import 'package:photo_album/providers/providers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication localAuth = LocalAuthentication();

  late Light _light;
  late StreamSubscription _subscription;

  late LightProvider lightStateProvider;

  void onData(int luxValue) async {
    lightStateProvider.luxValue = luxValue;
  }

  void stopListening() {
    _subscription.cancel();
  }

  void startListening() {
    _light = Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      log(exception.toString());
    }
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    lightStateProvider = Provider.of<LightProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void onTapAuth() async {
    bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

    if (weCanCheckBiometrics) {
      bool authenticated = await localAuth.authenticate(
        localizedReason: "Authenticate to see your bank statement.",
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
