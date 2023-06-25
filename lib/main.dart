import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:photo_album/screens/home_screen.dart';
import 'package:photo_album/models/light_state.dart';
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
          create: (context) => LightStateProvider(),
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
    int luxValue = Provider.of<LightStateProvider>(context).luxValue;
    return MaterialApp(
      title: 'Photo Album',
      theme: luxValue < 10 ? ThemeData.dark() : ThemeData.light(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
