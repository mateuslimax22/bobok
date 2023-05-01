import 'package:bobok/pages/add_review.dart';
import 'package:bobok/pages/onboarding.dart';
import 'package:bobok/pages/review_detail.dart';
import 'package:bobok/themes/theme.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: globalTheme,
      home: Onboarding(),
      routes: {
        AppRoutes.REVIEW_DETAIL: (ctx) => ReviewDetail(),
        AppRoutes.ADD_REVIEW: (ctx) => AddReview(),
      },
    );
  }
}
