import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoping_list/screens/categories_screen.dart';

final themeData = ThemeData.dark().copyWith(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 24, 151, 206),
    brightness: Brightness.dark,
    surface: const Color.fromARGB(255, 42, 51, 59)
  ),
  textTheme: GoogleFonts.latoTextTheme(),
  scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
);

void main() async {
  // the app stored Firebase database URL in .env file
  // please check example.env and assets in pubspec.yaml
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groceries App',
      theme: themeData,
      home: const CategoriesScreen(),
    );
  }
}
