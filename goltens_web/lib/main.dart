import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:goltens_core/theme/theme.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalState()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    getPermission();
    messageListener(context);
  }

  Future<void> getPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  void messageListener(BuildContext context) async {
    var message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      handleMessage(message);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> handleMessage(RemoteMessage message) async {
    if (message.notification != null) {
      String? route = message.data['route'];
      var user = navigatorKey.currentContext?.read<GlobalState>().user?.data;

      switch (route) {
        case 'home':
          navigateTo(routeName: '/home');
          break;
        case 'risk-assessment':
          navigateTo(
            routeName: '/home',
            queryParams: {'page': 'risk-assessment'},
          );
          break;
        case 'other-files':
          navigateTo(
            routeName: '/home',
            queryParams: {'page': 'other-files'},
          );
          break;
        case 'user-orientation':
          navigateTo(
            routeName: '/home',
            queryParams: {'page': 'user-orientation'},
          );
          break;
        case 'messages':
          if (user?.type == UserType.admin) {
            navigateTo(routeName: '/admin/messages');
          } else {
            navigateTo(routeName: '/home');
          }
          break;
        case 'admin-feedback':
          navigateTo(routeName: '/admin/feedbacks');
          break;
        case 'feedbacks':
          navigateTo(routeName: '/feedback-list');
          break;
        case 'assigned-feedbacks':
          navigateTo(routeName: '/feedback-assigned');
          break;
        default:
          navigateTo(routeName: '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goltens Web',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: '/',
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
      onGenerateRoute: routeGenerator,
    );
  }
}
