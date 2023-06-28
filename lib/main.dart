import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:photo_album/pages/pages.dart';
import 'package:photo_album/providers/providers.dart';
import 'package:photo_album/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LightProvider(),
        ),
      ],
      child: const Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    int luxValue = Provider.of<LightProvider>(context).luxValue;
    return MaterialApp(
      title: 'Photo Album',
      theme: luxValue < 10 ? ThemeData.dark() : ThemeData.light(),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
