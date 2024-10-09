import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils/colors.dart';

import 'package:my_notes_app/note_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> initializeFirebaseAppCheck() async {
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.playIntegrity);
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: ColorManager.backgroundcolor,
        systemNavigationBarIconBrightness: Brightness.dark),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        AndroidProvider.playIntegrity, // for web, leave empty for mobile
  );
  runApp(const NoteApp());
}
