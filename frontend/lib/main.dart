import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_state.dart';
import 'package:go_router/go_router.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'pages/feed.dart';
import 'pages/post.dart';
import 'pages/schedules.dart';
import 'pages/career.dart';
import 'pages/profile.dart';
import 'pages/edit_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //GoogleFonts.config.allowRuntimeFetching = false;

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(), // Create your ChangeNotifier
    builder: ((context, child) => const MyApp()),
  ));
}

final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          //return const PlaceMeAuthPage();
          return const MyHomePage();
        },
        routes: [
          GoRoute(
              path: 'schedules',
              builder: (context, state) {
                return const PlaceMeSchedulesPage();
              }
          ),
          GoRoute(
              path: 'post',
              builder: (context, state) {
                return const PlaceMePostPage();
              }
          ),
          GoRoute(
              path: 'career',
              builder: (context, state) {
                return const PlaceMeCareerPage();
              }
          ),
          GoRoute(
              path: 'profile',
              builder: (context, state) {
                return const PlaceMeProfilePage();
              },
              routes: [
                GoRoute(
                    path: 'edit_profile',
                    builder: (context, state) {
                      return const PlaceMeEditProfilePage();
                    }
                )
              ]
          ),
        ]

      ),
    ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PlaceMe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D63C6)),
        textTheme: GoogleFonts.robotoFlexTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}