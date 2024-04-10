import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/pages/add_review.dart';
import 'package:bobok/pages/edit_profile.dart';
import 'package:bobok/pages/home.dart';
import 'package:bobok/pages/onboarding.dart';
import 'package:bobok/pages/profile.dart';
import 'package:bobok/pages/review_detail.dart';
import 'package:bobok/pages/search.dart';
import 'package:bobok/pages/world.dart';
import 'package:bobok/provider/auth_email.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/themes/theme.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/utils/constants.dart';
import 'package:bobok/utils/push_notification.dart';
import 'package:bobok/wisgets/listCard/list_card_friends.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart'; fullscreen
import 'package:google_mobile_ads/google_mobile_ads.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHadler(RemoteMessage message) async {
  RemoteMessage? initialMessege =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessege != null) {
    PushNotification(
        title: initialMessege.notification?.title ?? '',
        body: initialMessege.notification?.body ?? '',
        dataTitle: initialMessege.data['title'] ?? '',
        dataBody: initialMessege.data['body'] ?? '');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHadler);
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

//ThemeData globalTheme = darkTheme;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    _firebaseMessaging.getToken().then((token) {
      print("token :$token ");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Recebeu mensagem ${message.notification?.body}");
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = systemBrightness == Brightness.dark;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthEmail(context)),
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UserStore()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          theme: isDarkMode ? darkTheme : lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pt', 'BR'),
          ],
          home: const Onboarding(),
          routes: {
            AppRoutes.REVIEW_DETAIL: (ctx) => const ReviewDetail(),
            AppRoutes.ADD_REVIEW: (ctx) => const AddReview(),
            AppRoutes.HOME: (ctx) => const Home(),
            AppRoutes.SEARCH: (ctx) => const Search(),
            AppRoutes.BOOK: (ctx) => const Text("livros"),
            AppRoutes.PROFILE: (ctx) => Profile(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  currentUid: true,
                ),
            AppRoutes.WORLD: (ctx) => const World(),
            AppRoutes.EDITPROFILE: (ctx) => const EditProfile(),
            AppRoutes.LISTFRIENDS: (ctx) => const ListFriends()
          },
        ),
      ),
    );
  }
}
