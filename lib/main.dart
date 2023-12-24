import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Commons/app_strings.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/global_bloc.dart';
import 'package:cpscom_admin/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
<<<<<<< Updated upstream
import 'package:flutter/foundation.dart';
=======
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'Commons/theme.dart';
import 'Features/Splash/Presentation/splash_screen.dart';
import 'firebase_options.dart';
late final FirebaseApp firebaseApp;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
<<<<<<< Updated upstream
  if (kDebugMode) {
    log("Handling a background message messageID: ${message.messageId}");
    log("Handling a background message data: ${message.data.toString()}");
    log("Handling a background message notification: ${message.notification!.title}");
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  log('User granted permission: ${settings.authorizationStatus}');
}

Future<void> main() async {
=======

  print("Handling a background message: ${message.messageId}");
}

void main() async {
>>>>>>> Stashed changes
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar configuration
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light));

<<<<<<< Updated upstream
  // Initialize Firebase to App
  // firebaseApp = await Firebase.initializeApp(
  //   name: AppStrings.appNameInFirebase,
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  const firebaseConfig = {
    "apiKey": "AIzaSyALDdPTyjaE6qad-Uc-hslCrR2PfknvhWE",
    "authDomain": "cpscom-aea2f.firebaseapp.com",
    "projectId": "cpscom-aea2f",
    "storageBucket": "cpscom-aea2f.appspot.com",
    "messagingSenderId": "985033228014",
    "appId": "1:985033228014:web:b48e1ab07d656c29b93dff"
  };

  if (Platform.isIOS || Platform.isAndroid) {
    firebaseApp = await Firebase.initializeApp(
        name: AppStrings.appNameInFirebase,
        options: DefaultFirebaseOptions.currentPlatform);
  } else {
    var app = await Firebase.initializeApp(
        name: firebaseConfig.toString(),
        options: DefaultFirebaseOptions.currentPlatform);
  }

  if (Platform.isIOS || Platform.isAndroid) {
    // Request Permission for Push Notification
    requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    LocalNotificationService.initialize();
  }

  // Main Function to run the application
=======
  firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
>>>>>>> Stashed changes
  runApp(const MyApp());

  // To Prevent Screenshot in app
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //1: This method only call when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (kDebugMode) {
        log('This method only call when app is terminated');
        log('Initial Message - ${FirebaseMessaging.instance.getInitialMessage()}');
      }
      if (message != null) {
        if (kDebugMode) {
          log('Got New Notification');
        }
      }
    });
    //2: This method only call when app is in foreground or app must be opened
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        log('This method only call when app is in foreground or app must be opened');
      }
      if (message.notification != null) {
        if (kDebugMode) {
          log('Notification Title - ${message.notification!.title}');
          log('Notification Body - ${message.notification!.body}');
          log("Notification Data - ${message.data}");
        }

        LocalNotificationService.createDisplayNotification(message);
      }
    });
    //3: This method only call when app is in background and not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        log('This method only call when app is in background and not terminated');
      }
      if (message.notification != null) {
        if (kDebugMode) {
          log('Notification Title - ${message.notification!.title}');
          log('Notification Body - ${message.notification!.body}');
          log("Notification Data - ${message.data}");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalBloc(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
<<<<<<< Updated upstream
        title: AppStrings.appName,
=======
        title: 'CPSCOM',
>>>>>>> Stashed changes
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
