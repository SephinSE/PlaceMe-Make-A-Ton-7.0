import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_state.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final response = await http.get(Uri.parse('http://localhost:5000/api/users/signup'));
              if (response.statusCode == 200) {
                final data = jsonDecode(response.body);
                print(data);
              } else {
                throw Exception('Failed to load data');
              }
            },
            child: const Text('Connect to NodeJS'),
          ),
        ),
      ),
    );
  }
}