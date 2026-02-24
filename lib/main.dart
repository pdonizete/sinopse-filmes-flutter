import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const SinopseFilmesApp());
}

class SinopseFilmesApp extends StatelessWidget {
  const SinopseFilmesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sinopse de Filmes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
