import 'package:bobok/pages/add_review.dart';
import 'package:bobok/pages/home.dart';
import 'package:bobok/pages/onboarding.dart';
import 'package:bobok/pages/review_detail.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:bobok/themes/theme.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          theme: globalTheme,
          home: const Onboarding(),
          routes: {
            AppRoutes.REVIEW_DETAIL: (ctx) => const ReviewDetail(),
            AppRoutes.ADD_REVIEW: (ctx) => const AddReview(),
            AppRoutes.HOME: (ctx) => const Home(),
          },
        ),
      );
}
