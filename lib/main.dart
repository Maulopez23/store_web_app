import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:store_web_app/views/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid ? const FirebaseOptions(
      apiKey: "AIzaSyDnuO3cEti45VN-o_5Jooqna6R4KpFXbGk",
      projectId: "store-app-movil",
      storageBucket: "store-app-movil.appspot.com",
      messagingSenderId: "183261802238",
      appId: "1:183261802238:web:2ea5fbd7bc3128ba72ffaf",
    ) : null
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow.shade900),
        useMaterial3: false,
      ),
      home: const MainScreen(),
    );
  }
}
