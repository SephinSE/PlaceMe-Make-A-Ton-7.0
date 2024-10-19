import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_state.dart';
import 'package:go_router/go_router.dart';
import 'auth_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            return const PlaceMeAuthPage();
          }
      )
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