import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/pages/add_review.dart';
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
import 'package:bobok/wisgets/listCard/list_card_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/services.dart'; fullscreen
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

ThemeData globalTheme = darkTheme;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthEmail(context)),
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UserStore()),
      ],
      child: MaterialApp(
        theme: globalTheme,
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
        },
      ),
    );
  }
}
