import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:light/light.dart';

import 'package:photo_album/pages/pages.dart';
import 'package:photo_album/providers/providers.dart';
import 'package:photo_album/constants/constants.dart';
import 'package:photo_album/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final Light light = Light();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<int>(
          create: (_) => light.lightSensorStream,
          initialData: 10,
          catchError: (_, e) => 10,
        ),
        Provider<ImageDataProvider>(
          create: (_) => ImageDataProvider(
            firebaseFirestore: firebaseFirestore,
            firebaseStorage: firebaseStorage,
          ),
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
    final luxValue = context.watch<int>();
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: luxValue < 10 ? ThemeData.dark() : ThemeData.light(),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
