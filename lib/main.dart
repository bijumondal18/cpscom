import 'package:cpscom_admin/global_bloc.dart';
import 'package:cpscom_admin/local_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Commons/theme.dart';
import 'Features/Splash/Presentation/splash_screen.dart';
import 'firebase_options.dart';

late final FirebaseApp firebaseApp;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message messageID: ${message.messageId}");
  print("Handling a background message data: ${message.data.toString()}");
  print(
      "Handling a background message notification: ${message.notification!.title}");
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
  print('User granted permission: ${settings.authorizationStatus}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light));
  firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  LocalNotificationService.initialize();
  runApp(const MyApp());
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
      print('This method only call when app is terminated');
      print(FirebaseMessaging.instance.getInitialMessage());
      if (message != null) {
        print('New Notification');
      }
    });
    //2: This method only call when app is in foreground or app must be opened
    FirebaseMessaging.onMessage.listen((message) {
      print(
          'This method only call when app is in foreground or app must be opened');
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("Message Data - ${message.data}");
        LocalNotificationService.createDisplayNotification(message);
      }
    });
    //3: This method only call when app is in background and not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(
          'This method only call when app is in background and not terminated');
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("Message Data - ${message.data}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalBloc(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CPSCOM',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
